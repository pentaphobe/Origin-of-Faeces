package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class DeathWorld extends World
	{
		private var scoreText:Text = new Text("", 10, 8, 200, 50);
		private var safetyCountdown:Number;
		private var safetyInterval:Number = 10; // the time we wait before accepting input
		public function DeathWorld()
		{
			super();		
			add(new Entity(0, 0, new Image(Assets.SCENE_DEATH)));
			add(new Entity(180, 100, scoreText));
		}
		override public function begin():void {
			safetyCountdown = safetyInterval;
		}
		override public function update():void {
			scoreText.text = "Reassuring death text here!\n" + 
							"You ran " + Math.floor(HUD.distanceRun / 16) + " metres\n" + 
							"and grabbed " + HUD.pickups["brain"] + " brains\n\n" +
							"(press <SPACE> to try again)";
			if (--safetyCountdown <= 0 && (Input.pressed(Key.SPACE) || Input.mousePressed)) {
				FP.world = new ScoreWorld;
			}
			super.update();			
		}
	}
}