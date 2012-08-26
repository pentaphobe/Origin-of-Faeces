package 
{	
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.FP;
	/*
	 * A character in the game
	 *
	 */
	public class Character extends Entity
	{
		public var vel:Vec2 = new Vec2(0, 0);
		public var acc:Vec2 = new Vec2(0, 0);
		
		public var mass:Number = 0.5;
		
		public var onGround:Boolean = false;
		public var friction:Number = GameWorld.friction;
		public function Character(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null)
		{
			super(x, y, graphic, mask);
		}
		override public function update():void {
			vel.multS(friction);
			vel.add(acc);
			
//			x += vel.x;
//			y += vel.y;
			checkCollision();
			move();
			checkBounds();
			acc.set(0, 0);
		}
		public function checkCollision():void {
			if (collide("solid", x, y+1)) {
				onGround = true;
				if (vel.y > 0) {
					vel.y = 0;
				}
				if (collide("solid", x, y)) {
					y -= 1.0;
				}
			} else {
				fall();
			}			
		}
		public function move():void {
			moveBy(vel.x, vel.y, "solid", true);
		}
		public function fall():void {
			vel.y += GameWorld.gravity * mass;
			
			var oldVel:Vec2 = new Vec2(vel.x, vel.y);
			var collided:Boolean = false;
			while (true) {
				var ground:Entity = collide("solid", x, y) as Entity;
				// step backwards by a tenth - horrible collision response
				if (ground != null) {
					collided = true;
					x -= oldVel.x * 0.1;
					y -= oldVel.y * 0.1;
				} else {
					break;
				}
			}
			if (collided) {
				vel.multS(-friction);
			}
			onGround = collided;			
		}
		public function checkBounds():void {
			
		}
	}
}