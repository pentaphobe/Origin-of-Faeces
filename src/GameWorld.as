package
{
	import net.flashpunk.*;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class GameWorld extends World
	{
		[Embed(source = "assets/tiles.png")] public static const TILES:Class;
		
		public static var friction:Number = 0.65;
		public static var gravity:Number = 2.0;
		
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
			
			
		}
		public function updateBuildings():void {
			while (lastBuilding == null || entityOnScreen(lastBuilding)) {
				spawnBuilding();
				spawnBuilding();
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
			var idealCameraX:Number = player.x - FP.screen.width/2;
			if (Math.abs(idealCameraY - camera.y) > FP.screen.height / 8) {
				camera.y += (idealCameraY - camera.y) * 1.0 * FP.elapsed;
			}
			if (Math.abs(idealCameraX - camera.x) > FP.screen.height / 8) {
				camera.x += (idealCameraX - camera.x) * 1.0 * FP.elapsed;
			}
			camera.x = idealCameraX;
//			camera.y = idealCameraY;
			super.update();
		}
		
		override public function render():void {
			super.render();
		}
		public function spawnBuilding() {
			var newX:Number = 0;
			var wid:Number = Math.random() * 20 + 5;
			var hei:Number = 50;
			
			if (lastBuilding != null) {
				newX = lastBuilding.x + lastBuilding.width;
				hei = lastBuilding.tileHeight;
			}
			if (Math.random() < 0.5) {
				// go up by a little
				hei += 1;
			} else if (hei > 2) {
				hei -= 1;
			}
			
			if (hei < 1) hei = 1;
			if (wid < 5) wid = 5;
			var newBuilding:Building = new Building([1,3,2,4], wid, hei, newX);
			buildings.push(newBuilding);
			lastBuilding = newBuilding;
			
			var removedTotal:uint = 0;
			while (buildings.length > 0 && !entityOnScreen(buildings[0])) {
				buildings.shift();
				++removedTotal;
			}

			add(newBuilding);
		}		
	}
}