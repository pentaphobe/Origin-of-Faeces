package
{
	import flash.utils.Dictionary;
	
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.*;
	import net.flashpunk.FP;
	
	public class HUD extends Entity
	{
		private var scoreText:Text = new Text(String(distanceRun), 10, 8, 200, 50);
		private var pickupText:Text = new Text("", 10, 20, 200, 50);
		private var profileImage:Image = new Image(GameWorld.APE_PROFILE);
		public static var distanceRun:Number = 0;
		public static var pickups:Object = {};
		public function HUD()
		{
			layer = -1;
			profileImage.x = 10;
			profileImage.y = FP.screen.height - profileImage.height + 1;
			var display:Graphic = new Graphiclist(scoreText, pickupText, profileImage);
			graphic = display;
			super(x, y, graphic);
		}
		public function reset():void {
			distanceRun = 0;
			pickups = {};
		}
		override public function update():void {
			scoreText.text = String(Math.floor(distanceRun / 16)) + "m";
			pickupText.text = "";
			for (var i in pickups) {
				pickupText.text += String(i) + "s:" + pickups[i].toString();
			}
			y = Math.floor(world.camera.y);
			x = Math.floor(world.camera.x);
		}
		public static function addPickup(name:String):void {
			if (!pickups.hasOwnProperty(name)) {
				
				pickups[name] = 1;
			} else {
				pickups[name]++;			
			}
		}
	}
}