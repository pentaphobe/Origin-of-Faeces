package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class GameWorld extends World
	{
		[Embed(source = "assets/tiles.png")] public static const TILES:Class;
		[Embed(source = "assets/brain.png")] public static const BRAIN:Class;
		public static var friction:Number = 0.65;
		public static var gravity:Number = 4.0;
		
		public var tileWorld:TileWorld;
		public var bg:TileWorld;
		public var player:Player;
		public var hud:HUD;
		public var buildings:Array = [];
		public var lastBuilding:Building;
		
		public var scrollSpeed:Number = 100.0;
		public var topSpeed:Number = 300.0;
		
		public function GameWorld()
		{			
			super();
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
			
			player = new Player(FP.screen.width / 2, 5);
			add(player);
			
			hud = new HUD;
			add(hud);
			hud.reset();

			lastBuilding = null;
			buildings = [];
			updateBuildings();
			player.x = lastBuilding.x + 10;
			player.y = lastBuilding.y - 30;
			trace("yup. it's wood.");
			camera.x = player.x - FP.screen.height / 2;
			camera.y = player.y - FP.screen.width / 2;
			
		}
		public function updateBuildings():void {
			while (lastBuilding == null || entityOnScreen(lastBuilding)) {
				spawnBuilding();
			}
		}
		public function entityOnScreen(e:Entity):Boolean {			
			return e.collideRect(e.x, e.y, camera.x, camera.y, FP.screen.width, FP.screen.height)
		}
		override public function update():void {	
			updateBuildings();
			HUD.distanceRun += player.speed * FP.elapsed;
//			tileWorld.scrollRight(player.speed * FP.elapsed);			
//			bg.scrollRight(player.speed * FP.elapsed);
			
			var idealCameraY:Number = player.y - FP.screen.height/2;
			var idealCameraX:Number = player.x - FP.screen.width/4;
			if (Math.abs(idealCameraY - camera.y) > FP.screen.height / 4) {
				camera.y += (idealCameraY - camera.y) * 4 * FP.elapsed;
			}
//			if (Math.abs(idealCameraX - camera.x) > FP.screen.height / 8) {
				camera.x += (idealCameraX - camera.x) * 16 * FP.elapsed;
//			}
//			camera.x = idealCameraX;
//			camera.y = idealCameraY;
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
		public function spawnBuilding() {
			var newX:Number = 0;
			var wid:Number = Math.random() * 20 + 12;
			var hei:Number = 50;
			
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
				var gapWidth:Number = (Math.random() * 10 + 1) * 16;
				newX += gapWidth;
				if (hei - lastBuilding.tileHeight > gapWidth) {
					hei = lastBuilding.tileHeight - gapWidth;
				} 
			}
			
			if (hei < 1) hei = 1;
			if (wid < 10) wid = 10;
			var newBuilding:Building = new Building([1,3,2,4], wid, hei, newX);
			buildings.push(newBuilding);
			lastBuilding = newBuilding;
			addItems(newBuilding);
			

			add(newBuilding);
		}		
		public function cullBuildings():void {
			var removedTotal:uint = 0;
			while (buildings.length > 0 && !entityOnScreen(buildings[0])) {
				var oldBuilding:Building = buildings.shift();
				this.removeList(oldBuilding.items);
				++removedTotal;
			}			
		}
	}
}