package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Draw;
	
	public class Hazard extends Entity
	{
		public var parent:HazardSystem;
		public function Hazard(name:String, x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null)
		{
			this.name = name;
			super(x, y, graphic, mask);
		}
		override public function update():void {			
			if (Math.random() < 0.2) parent.hazardComplete();
			super.update();
		}
		override public function render():void {
			Draw.line(x, y, GameWorld.player.x, GameWorld.player.y);
		}
		public function begin():void {
//			if (!world) {  
//				trace("NO WORLD!");
//				return;
//			}
			var player:Player = GameWorld.player;
			x = player.x + FP.screen.width * 2;
			y = player.y - FP.screen.height / 2.0;
		}
		public function setParent(sys:HazardSystem):void {
			parent = sys;
		}
	}
}