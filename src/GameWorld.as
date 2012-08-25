package
{
	import net.flashpunk.*;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class GameWorld extends World
	{
		
		public var tileWorld:TileWorld;
		public var bg:TileWorld;
		public var scrollSpeed:Number = 100.0;
		public var topSpeed:Number = 300.0;
		public function GameWorld()
		{			
			super();
			tileWorld = new TileWorld();
			add(tileWorld);
			bg = new TileWorld(24, false, 0.3);
			bg.layer = 3;
			
			add(bg);
			trace("yup. it's wood.");		
		}
		
		override public function update():void {
			tileWorld.scrollRight(scrollSpeed * FP.elapsed);
			bg.scrollRight(scrollSpeed * FP.elapsed);
			scrollSpeed += 0.1;
			super.update();
		}
		
		override public function render():void {
			super.render();
		}
	}
}