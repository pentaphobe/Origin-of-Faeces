package
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Graphiclist;

	/* 
	 * An object upon which we may swing
	 */
	public class Swinger extends Entity
	{
		public var emitter:Emitter;
		public function Swinger(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null)
		{
 			setHitbox(48, 32, -8, -8);
			type="swinger";
			
			emitter = new Emitter(Assets.PARTICLE_LEAF, 9, 9);
			emitter.relative = false;
			emitter.newType("leaves", [0, 1, 2, 3, 4, 5]);
			emitter.setMotion("leaves", 0, 64, 3, 360, -32, -1.5);
			emitter.setGravity("leaves", 1.0);
			
			graphic = new Graphiclist(graphic, emitter);
			super(x, y-127, graphic, mask);
		}
		public function emit(name:String, xx:Number, yy:Number, count:int=1) {
			for (var i:int=0;i<count;i++) {
				emitter.emit(name, xx, yy);
			}
		}
	}
}