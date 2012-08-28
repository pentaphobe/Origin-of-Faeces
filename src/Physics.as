package 
{	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	/*
	 * A character in the game
	 *
	 */
	public class Physics extends Entity
	{
		public var vel:Vec2 = new Vec2(0, 0);
		public var acc:Vec2 = new Vec2(0, 0);
		public var maxSpeed:Vec2 = new Vec2(75, 75);
		
		public var mass:Number = 0.75;
		
		public var onGround:Boolean = false;
		public var wasOnGround:Boolean = false;
		public var friction:Vec2 = GameWorld.friction;
		public function Physics(x:Number=0, y:Number=0, solid:Boolean = true, graphic:Graphic=null, mask:Mask=null)
		{
			if (solid) {
				type = "solid";
			}
			super(x, y, graphic, mask);
		}
		override public function update():void {
			if (onGround) {
				vel.x *= friction.x;
			} else {
				vel.x *= friction.y;
				vel.y *= friction.y;
			}
			vel.add(acc);
			
			if (Math.abs(vel.x) > maxSpeed.x) {
				vel.x = FP.sign(vel.x) * maxSpeed.x;
			}
			if (Math.abs(vel.y) > maxSpeed.y) {
				vel.y = FP.sign(vel.y) * maxSpeed.y;				
			}
//			x += vel.x;
//			y += vel.y;
			checkCollision();
			move();
			checkBounds();
			acc.set(0, 0);
		}
		public function checkCollision():void {
			if (collide("solid", x, y+1)) {
				wasOnGround = onGround;
				onGround = true;
				if (vel.y > 0) {
					vel.y = 0;
				}
				if (collide("solid", x, y)) {
					y -= 1.0;
				}
			} else {
				wasOnGround = onGround;
				onGround = false;
				fall();
			}			
		}
		public function move():void {
			if (x <= GameWorld.leftX && vel.x < 0) {
				vel.x = 0;
			}
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
				vel.multXY(-friction.x, -friction.y);
			}
			onGround = collided;			
		}
		public function checkBounds():void {
			
		}
	}
}