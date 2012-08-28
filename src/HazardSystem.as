package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	public class HazardSystem extends Entity
	{		
		public  var hazards:Object = {};
		public  var hazardList:Array = [];
		public  var hazardCountdown:Number = 0;
		public  var hazardInterval:Number = 5;
		public  var activeHazard:Hazard;
		
		public function HazardSystem()			
		{
			super();
		}
		override public function update():void {
			hazardCountdown -= FP.elapsed;			
			if (activeHazard != null && activeHazard.active) {
				activeHazard.update();
			} else if (hazardCountdown <= 0) {
				activeHazard = hazardList[Math.floor(Math.random()*hazardList.length)];
				trace("activeHazard is now " + activeHazard);
				world.add(activeHazard);
				activeHazard.begin();
			}
			super.update();
		}
		override public function render():void {
			if (activeHazard != null && activeHazard.visible) {
				activeHazard.render();
			}
			super.render();
		}
		
		public function addType(hazard:Hazard):Hazard {
			hazards[hazard.name] = hazard;
			hazardList.push(hazard);
			hazard.setParent(this);
			return hazard;
		}
		public function hazardComplete():void {
			if (!activeHazard) return;
			trace("hazard complete:" + activeHazard.name);
			activeHazard.visible = false;			
			world.remove(activeHazard);	
			activeHazard = null;
			hazardCountdown = hazardInterval;
		}
	}
}