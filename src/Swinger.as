package
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;

	/* 
	 * An object upon which we may swing
	 */
	public class Swinger extends Entity
	{
		public function Swinger(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null)
		{
			super(x, y, graphic, mask);
		}
	}
}