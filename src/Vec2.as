package
{
	import flash.geom.Point;
	
	public class Vec2 extends Point
	{
		public function Vec2(x:Number=0, y:Number=0)
		{
			super(x, y);
		}
		public function mult(pt:Point):void  {
			x *= pt.x;
			y *= pt.y;
		}
		public function multS(v:Number):void  {
			x *= v;
			y *= v;
		}
		public function addS(v:Number):void  {
			x += v;
			y += v;
		}
		public function set(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}
	}
}