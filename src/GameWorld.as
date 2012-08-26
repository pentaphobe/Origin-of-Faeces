package
{
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
		[Embed(source = "assets/tiles.png")] public static const TILES:Class;
		[Embed(source = "assets/brain.png")] public static const BRAIN:Class;
		[Embed(source = "assets/tree.png")] public static const TREE:Class;
		[Embed(source = "assets/ape_sheet.png")] public static const PLAYER:Class;
		[Embed(source = "assets/sky.png")] public static const SKY:Class;
		[Embed(source = "assets/ape profile.png")] public static const APE_PROFILE:Class;
		
		public static var friction:Vec2 = new Vec2(0.65, 0.85);
		public static var gravity:Number = 1.0;
		
		public var tileWorld:TileWorld;
		public var bg:TileWorld;
		public var sky:Entity;
		public var player:Player;
		public var hud:HUD;
		public var buildings:Array = [];
		public var lastBuilding:Building;
		
		public var scrollSpeed:Number = 100.0;
		public var topSpeed:Number = 300.0;
		
		public function GameWorld()
		{			
			super();					
		}
		override public function begin():void {
			newGame();
		}
		public function playerDied():void {
			trace("Game Over");			
			newGame();
		}
		public function newGame():void {			
			removeAll();
//			tileWorld = new TileWorld();
//			add(tileWorld);
//			bg = new TileWorld(24, false, 0.3, 13);
//			bg.layer = 3;			
//			add(bg);
			sky = new Entity(0, 0, new Backdrop(SKY, true, false));
			sky.width = FP.screen.width;
			sky.height= FP.screen.height;
			add(sky);
			
			player = new Player(FP.width / 6, 5);
			add(player);
			
			hud = new HUD;
			add(hud);
			hud.reset();

			lastBuilding = null;
			buildings = [];
			updateBuildings();
			player.x = lastBuilding.x;
			player.y = lastBuilding.y - 20;
			trace("yup. it's wood.");
			camera.x = player.x - FP.screen.width / 2;
			camera.y = player.y - FP.screen.height / 2;
			
		}
		public function updateBuildings():void {
			while (lastBuilding == null || entityOnScreen(lastBuilding)) {
				spawnBuilding();
			}
		}
		public function entityOnScreen(e:Entity, margin:Number=0):Boolean {			
			return e.collideRect(e.x, e.y, camera.x - margin, camera.y - margin, FP.screen.width + (2*margin), FP.screen.height + (2*margin));
		}
		override public function update():void {	
			updateBuildings();
			if (player.vel.x != 0) {
				HUD.distanceRun += player.vel.x;
			}
//			tileWorld.scrollRight(player.speed * FP.elapsed);			
//			bg.scrollRight(player.speed * FP.elapsed);
			
			var idealCameraY:Number = player.y - FP.screen.height/2;
			var idealCameraX:Number = player.x - FP.screen.width/4;
			if (Math.abs(idealCameraY - camera.y) > FP.screen.height / 8) {
				camera.y += (idealCameraY - camera.y) * 4 * FP.elapsed;
			}
			if (Math.abs(idealCameraX - camera.x) > FP.screen.height / 8) {
				camera.x += (idealCameraX - camera.x) * 4 * FP.elapsed;
			}
//			camera.x = idealCameraX;
//			camera.y = idealCameraY;
			
			sky.y = camera.y-(sky.height*2.4) - camera.y*0.65;
			sky.x = camera.x + FP.screen.width / 2;
			super.update();
		}
		
		override public function render():void {
			
			super.render();
		}		
		public function addItems(building:Building) {
			var x:Number = building.x;
			var y:Number = Math.random()*50 + 20;

			for (var i:Number = 0; i < building.tileWidth; i++) {	
				if (Math.random() < 0.2) {
					var newItem:Pickup = new Pickup("brain", x, building.y - y, new Image(BRAIN));
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
					var swinger:Swinger = new Swinger(building.x + x - (Building.TILE_SIZE / 2), building.y + Building.TILE_SIZE, new Image(TREE));
					building.items.push(swinger);
					add(swinger);
				}
				x += Building.TILE_SIZE;
			}
		}
		public function spawnBuilding() {
			var newX:Number = 0;
			var wid:Number = Math.random() * 20 + 12;
			var hei:Number = 40;
			
			if (lastBuilding != null) {
				newX = lastBuilding.x + lastBuilding.width;
				hei = lastBuilding.tileHeight;
			} else {
				wid += 40;
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
				var gapWidth:Number = (Math.random() * (player.speed / Building.TILE_SIZE) + 1) * Building.TILE_SIZE;
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
			addItems(newBuilding);
			
			cullBuildings();

			add(newBuilding);
		}		
		public function cullBuildings():void {
			var removedTotal:uint = 0;
			while (buildings.length > 0 && !entityOnScreen(buildings[0], FP.screen.width)) {
				if ( Math.abs(buildings[0].x - player.x) < buildings[0].width) break;
				
				var oldBuilding:Building = buildings.shift();
				this.removeList(oldBuilding.items);
				this.remove(oldBuilding);
				++removedTotal;
			}	
			trace("total removed:" + removedTotal);
		}
	}
}