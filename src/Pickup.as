package
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.FP;
	
	public class Pickup extends Entity
	{
		public var pickupType:String;
		public function Pickup(pickType:String, x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null)
		{
			this.pickupType = pickType;
//			this.setHitbox(graphic.width, graphic.height);
			super(x, y, graphic, mask);
		}
		override public function update():void {
			var play:Player = collide("player", x, y) as Player;
			if (play != null) {
				// collision, do pickup
				doPickup();
			} else {
				var wrld:GameWorld = world as GameWorld;
				var player:Player = wrld.player;
				var dx:Number = player.x - x;
				var dy:Number = player.y - y;
				var dist:Number = Math.sqrt(dx*dx + dy*dy);
				if (dist < player.itemMagnetRange) {
					dist /= player.itemMagnetRange;
					dist = 1.0 - dist;
					x += dx * dist * player.itemMagnetStrength * FP.elapsed;
					y += dy * dist * player.itemMagnetStrength * FP.elapsed;
				}
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