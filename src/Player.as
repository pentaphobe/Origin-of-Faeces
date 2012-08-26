package
{
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Player extends Character
	{
		public var topSpeed:Number = 400.0;
		public var bottomSpeed:Number = 50.0;
		public var targetSpeed:Number = 5.0;
		public var speed:Number = 30.0;
		public var jumpEnergy:Number = 29.0;
		public var jumpTime:Number = 0.2;
		public var jumpCounter:Number;
		public function Player(x:Number=0, y:Number=0)
		{
			graphic = Image.createRect(8, 8);
			width = 8;
			height = 8;
			Input.define("left", Key.LEFT);
			Input.define("right", Key.RIGHT);
			Input.define("jump", Key.Z, Key.UP);
			super(x, y, graphic, mask);
			mass = 0.3;
		}
		override public function update():void {
			if (Input.check("left")) { 
				targetSpeed = bottomSpeed; 
			} else if (Input.check("right")) { 
				targetSpeed = topSpeed;
			} else {
				targetSpeed = (topSpeed + bottomSpeed) / 2;
			}
			if (Input.check("jump")) {
				if (onGround && Input.pressed("jump")) {
//					yVel -= jumpEnergy;
					vel.y -= jumpEnergy;
					vel.x += jumpEnergy * 0.25;
					jumpCounter = jumpTime;
				} else {
					jumpCounter -= FP.elapsed;
					if (jumpCounter > 0 && vel.y > 0) {					
//						yVel -= jumpEnergy * 0.5;
						vel.y -= jumpEnergy * 0.5;
					}
				}
			}
			if (Input.pressed(Key.R)) {
				(world as GameWorld).playerDied();
			}
			speed += (targetSpeed - speed) * 0.1;
			vel.x = speed * FP.elapsed;
			topSpeed += 0.2;
			bottomSpeed += 0.1;
			super.update();
		}
		override public function checkBounds():void {
			if (x < world.camera.x-32 || y < world.camera.y-FP.screen.height || x > world.camera.x+FP.screen.width+32 || y > world.camera.y+FP.screen.height) {				
				(world as GameWorld).playerDied();

			}
		}
	}
}