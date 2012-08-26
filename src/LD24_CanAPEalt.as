package
{
	import net.flashpunk.*;
	[SWF(width = "640", height="480")] 
	/*
		Sidescroller canabalt-like with apes picking up brains and slowly gaining skill
		
		possible endings:
			* evolve into an obese human and just sprawl, helpless in a dungeon of media and abundance
			* fight a religious figure (Pope?)
	 */
	public class LD24_CanAPEalt extends Engine
	{
		public function LD24_CanAPEalt()
		{
//			super(640, 480, 60, false);

			super(320, 240, 60, false);
			scaleX = 2;
			scaleY = 2;
			FP.console.enable();
		}
		
		override public function init():void {
			trace("Started successfully");
			FP.world = new GameWorld;
			super.init();
		}
	}
	
	
}