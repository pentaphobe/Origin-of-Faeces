package
{
	import net.flashpunk.*;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class GameWorld extends World
	{
		public static var friction:Number = 0.65;
		public static var gravity:Number = 2.0;
		
		public var tileWorld:TileWorld;
		public var bg:TileWorld;
		public var player:Player;
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
			tileWorld = new TileWorld();
			add(tileWorld);
			bg = new TileWorld(24, false, 0.3, 13);
			bg.layer = 3;
			
			add(bg);
			player = new Player(FP.screen.width / 2, FP.screen.height / 2);
			add(player);
			trace("yup. it's wood.");
		}
		override public function update():void {
			tileWorld.scrollRight(player.speed * FP.elapsed);
			bg.scrollRight(player.speed * FP.elapsed);
			var idealCameraY:Number = player.y - FP.screen.height/2;
			if (Math.abs(idealCameraY - camera.y) > FP.screen.height / 16) {
				camera.y += (idealCameraY - camera.y) * 0.1 * FP.elapsed;
			}
			super.update();
		}
		
		override public function render():void {
			super.render();
		}
	}
}