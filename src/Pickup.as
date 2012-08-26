package
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	
	public class Pickup extends Entity
	{
		public var pickupType:String;
		public function Pickup(pickType:String, x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null)
		{
			this.pickupType = pickType;
			this.setHitbox(16, 16);
			super(x, y, graphic, mask);
		}
		override public function update():void {
			var play:Player = collide("player", x, y) as Player;
			if (play != null) {
				// collision, do pickup
				doPickup();
			}
			super.update();
		}
		public function doPickup():void {
//			trace("Item grabbed");
			HUD.addPickup(pickupType);
			world.remove(this);
		}
	}
}