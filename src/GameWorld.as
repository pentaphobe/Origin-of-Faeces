package
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import net.flashpunk.*;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class GameWorld extends World
	{

		
		public static var friction:Vec2 = new Vec2(0.75, 0.85);
		public static var gravity:Number = 1.0;
		public static var isPaused:Boolean = false;
		
		public var tileWorld:TileWorld;
		public var bg:TileWorld;
		public var sky:Entity;
		public var parallax:Array = [];
		public static var player:Player;
		public var hud:HUD;
		public var buildings:Array = [];
		public var lastBuilding:Building;
		public var hazardSystem:HazardSystem;
		
		public var scrollSpeed:Number = 100.0;
		public var topSpeed:Number = 300.0;
		
		public static var leftX:Number = 0;
		
		public function GameWorld()
		{			
			isPaused = true;
			super();			
			Input.define("left", Key.LEFT);
			Input.define("right", Key.RIGHT);
			Input.define("jump", Key.Z, Key.UP);
			Input.define("swing", Key.X);
			Input.define("start", Key.Z, Key.SPACE);
			Input.define("pause", Key.ESCAPE, Key.P);
			
		}
		override public function begin():void {
			FP.screen.color = 0x57708b;
			
			for (var i:int=0;i<2;i++) {
				var par:Entity = new Entity(0, 0, new Backdrop(Assets.MOUNTAINS, true, false));
				par.width = 2048;				
				par.y += i * 10;
				par.x += i * 30;
				(par.graphic as Backdrop).color = (0x40 << 16) >> i | (0x44 << 8) >> i | (0x4);
				parallax.push(par);
			}
			// a solid for the bottom
//			var img:Image = Image.createRect(FP.screen.width * 3, FP.screen.height);
//			img.relative = false;
//			add(new Entity(4 * 10, 4 * 30, img));
			
			newGame();
		}
		override public function end():void {
			removeAll();
		}
		public function playerDied():void {
			trace("Game Over");	
			FP.world = new DeathWorld;
//			newGame();
		}
		public function newGame():void {			
			trace("newGame()");
//			tileWorld = new TileWorld();
//			add(tileWorld);
//			bg = new TileWorld(24, false, 0.3, 13);
//			bg.layer = 3;			
//			add(bg);
			sky = new Entity(0, 0, new Backdrop(Assets.SKY, true, false));
			sky.width = FP.screen.width;
			sky.height= FP.screen.height;
			add(sky);
			
			this.addList(parallax);
			
			player = new Player(FP.width / 6, 5);
			// [@todo perhaps the source of the bug where skipping the score scene returns to the score scene with zero score?]
			// [@... ie. perhaps this is getting a single update upon being added?]
			add(player);
			
			hud = new HUD;
			add(hud);
			hud.reset();

			lastBuilding = null;
			buildings = [];
			updateBuildings();
			player.x = buildings[0].x + 14 * Building.TILE_SIZE;
			player.y = buildings[0].y - 20;
			
			hazardSystem = new HazardSystem();
			hazardSystem.addType(new Hazard("hand_of_god", 0, 0, Image.createRect(64, 128)) );
			add(hazardSystem);
			
			
			trace("yup. it's wood.");
			camera.x = player.x - FP.screen.width / 2;
			camera.y = player.y - FP.screen.height / 2;
			
			isPaused = false;
		}
		public function updateBuildings():void {
			while (lastBuilding == null || entityOnScreen(lastBuilding) || player.x > lastBuilding.x) {
				spawnBuilding();
			}
		}
		public function entityOnScreen(e:Entity, margin:Number=0):Boolean {			
			return e.collideRect(e.x, e.y, camera.x - margin, camera.y - margin, FP.screen.width + (2*margin), FP.screen.height + (2*margin));
		}
		override public function update():void {	
			if (Input.pressed("pause")) {
				isPaused = !isPaused;
			}

			// have to update the HUD so we see the >> PAUSED << text			
			if (isPaused) {
				hud.update();
				return;	
			}
			
			updateBuildings();
			// [@bug this was the cause of the distance counter going up when spinning around or running continuously into walls]
			// [@... it's leftover lazy code from when this was still a canabalt-a-like]
			// [@... functionality is now in the Player.move() function
//			if (player.vel.x != 0) {
//				HUD.distanceRun += player.vel.x;				
//			}
			
			var idealCameraY:Number = player.y - FP.screen.height/2;
			var idealCameraX:Number = Math.max(leftX, player.x - FP.screen.width/4);
			if (Math.abs(idealCameraY - camera.y) > FP.screen.height / 8) {
				camera.y += (idealCameraY - camera.y) * 8 * FP.elapsed;
			}
			if (Math.abs(idealCameraX - camera.x) > FP.screen.height / 8) {
				camera.x += (idealCameraX - camera.x) * 4 * FP.elapsed;
			}
			leftX = camera.x;
			
			// [@debug for debugging - this is a camera directly fixed to the player]
//			camera.x = idealCameraX;
//			camera.y = idealCameraY;
			
			sky.y = camera.y-(sky.height*1.4) - camera.y*0.25;
			sky.x = camera.x + FP.screen.width / 2;
			
			for (var i:int=0;i<parallax.length;i++) {
				var ent:Entity = parallax[i] as Entity;
				// [@todo the 12 here was just lazy hard-coding]
				var para:Number = (i / 12.0);
//				ent.x = (camera.x * 0.99 * para) + FP.screen.width / 2 + (i * 327);
				//ent.y = (camera.y * 0.9) - (FP.screen.height) - camera.y*0.4 + i*16;
				
//				ent.y = (camera.y * para * 0.3) - (FP.screen.height * 2);
//				ent.y = (camera.y - FP.screen.height / 2) - (camera.y * para * 0.3);
				ent.y = camera.y - (camera.y * para * 0.3);
				ent.x = ((camera.x * para) % ent.width);
				
			}
			super.update();
		}
		
		override public function render():void {		

			super.render();
		}		
		public function addItems(building:Building) {
			var x:Number = building.x;
			var y:Number = Math.random()*50 + 20;

			for (var i:Number = 0; i < building.tileWidth; i++) {	
				// create ground level items
				if (Math.random() < 0.1) {
					var newItem:Pickup = new Pickup("brain", x, building.y - y, new Image(Assets.BRAIN));
					building.items.push(newItem);	
					add(newItem);
				}
				// create sky items
				if (HUD.distanceRun > HUD.HIGH_BRAIN_DISTANCE && Math.random() < 0.2) {
					var topScale:Number = Math.min( HUD.distanceRun - HUD.HIGH_BRAIN_DISTANCE, 10 * 16 );
					var newItem:Pickup = new Pickup("brain", x, building.y - (8 * 16) - (Math.random()*topScale), new Image(Assets.BRAIN));
					building.items.push(newItem);	
					add(newItem);					
				}
				x += Building.TILE_SIZE;
				if (Math.random() < 0.5 && y > Building.TILE_SIZE) {
					y -= Building.TILE_SIZE;
				} else if (y < 5*Building.TILE_SIZE) {
					y += Building.TILE_SIZE;
				}

			}
		}
		public function addSwingers(building:Building) {
			var x:Number = 0;
			while (x < building.width - Building.TILE_SIZE) {
				if (Math.random() < 0.2) {
					var swinger:Swinger = new Swinger(building.x + x - (Building.TILE_SIZE / 2), building.y + Building.TILE_SIZE, new Image(Assets.TREE));
					building.items.push(swinger);
					add(swinger);
				}
				x += Building.TILE_SIZE;
			}
		}
		public function spawnBuilding() {
			var makeItems:Boolean = true;
			var newX:Number = 0;
			var wid:Number = Math.random() * 20 + 12;
			var hei:Number = 40;
			
			if (lastBuilding != null) {
				newX = lastBuilding.x + lastBuilding.width;
				hei = lastBuilding.tileHeight;
			} else {
				wid += 140;
				makeItems = false;
				// first building is extra wide				
				
			}
			if (Math.random() < 0.5) {
				// go up by a little
				hei += 1;
			} else if (hei > 2) {
				hei -= 1;
			}
			if (lastBuilding != null && Math.random() < 0.1) {
				// create a gap
				var gapWidth:Number = (Math.random() * ((player.speed * 0.3) / Building.TILE_SIZE) + 1) * Building.TILE_SIZE;
				if (gapWidth < 2) {
					gapWidth = 2;
				}
				newX += gapWidth;
				if (hei - lastBuilding.tileHeight > gapWidth) {
					hei = lastBuilding.tileHeight - gapWidth;
				} 
			}
			
			if (hei < 1) hei = 1;
			if (wid < 10) wid = 10;
			var newBuilding:Building = new Building([1,3,2,4,[5,6,7]], wid, hei, newX);
			buildings.push(newBuilding);
			lastBuilding = newBuilding;
			addSwingers(newBuilding);
			if (makeItems) {
				addItems(newBuilding);
			}
			
			cullBuildings();

			add(newBuilding);
		}		
		public function cullBuildings():void {
			var removedTotal:uint = 0;
			while (buildings.length > 0 && !entityOnScreen(buildings[0], FP.screen.width)) {
				if ( Math.abs(buildings[0].x - player.x) < buildings[0].width) break;
				
				var oldBuilding:Building = buildings.shift();
				this.removeList(oldBuilding.items);
				this.recycle(oldBuilding);
				++removedTotal;
			}	
			//trace("total removed:" + removedTotal);
		}
		public function doPickup(src:Entity):void {
			player.emit("sparkle", src.x, src.y, 40);
			Assets.brainGrabSound.play(0.3);
			recycle(src);
		}
		public static function pause():void {
			isPaused = true;
		}
		public static function unPause():void {
			isPaused = false;
		}
		override public function focusLost():void {
			pause();
		}
		override public function focusGained():void {
			unPause();
		}
	}
}