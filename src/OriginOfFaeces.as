package
{
	import net.flashpunk.*;
	[SWF(width = "960", height="480")] 
	/*
	Sidescroller canabalt-like with apes picking up brains and slowly gaining skill
	
	possible endings:
	* evolve into an obese human and just sprawl, helpless in a dungeon of media and abundance
	* fight a religious figure (Pope?)
	*/
	public class OriginOfFaeces extends Engine
	{
		public function OriginOfFaeces()
		{
			//			super(960, 480, 60, false);
			
			super(480, 240, 60, false);
			scaleX = 2;
			scaleY = 2;
			//			FP.console.enable();
		}
		
		override public function init():void {
			trace("Started successfully");
			FP.world = new MenuWorld;
			super.init();
		}
	}
	
	
}