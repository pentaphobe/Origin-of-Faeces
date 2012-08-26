package
{
	import flash.geom.Point;
	
	public class Vec2
	{
		public var x:Number;
		public var y:Number;
		public function Vec2(x:Number=0, y:Number=0)
		{
			this.x = x;
			this.y = y;
		}
		public function mult(v:Vec2):void  {
			x *= v.x;
			y *= v.y;			
		}
		public function multS(s:Number):void  {
			x *= s;
			y *= s;
		}
		public function multXY(xx:Number, yy:Number):void {
			x *= xx;
			y *= yy;
		}
		public function addS(s:Number):void  {
			x += s;
			y += s;			
		}
		public function addXY(xx:Number, yy:Number):void {
			x += xx;
			y += yy;
		}
		public function add(v:Vec2):void {
			x += v.x;
			y += v.y;			
		}
		public function set(x:Number, y:Number):void {
			this.x = x;
			this.y = y;
		}
		public function toString():String {
			return "{x:" + this.x + ", y:" + this.y + "}";
		}
	}
}