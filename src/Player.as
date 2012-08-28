package
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.*;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Player extends Physics
	{
		// abilities
		public var hasDoubleJump:Boolean = false;
		public var hasFloat:Boolean = false;
		
		public var topSpeed:Number = 200.0;
		public var bottomSpeed:Number = 10.0;
		public var targetSpeed:Number = 5.0;
		public var speed:Number = 70.0;
		public var jumpEnergy:Number = 6.0;
		public var jumpTime:Number = 0.2;
		public var jumpCounter:Number;
		public var canDoubleJump:Boolean;
		
		public var footStepCountdown:Number = 0;
		public var footStepInterval:Number = 0.2;
		
		
		public var facingRight:Boolean = true;
		
		public var swinger:Swinger;
		public var swinging:Boolean = false;
		
		public var swingVel:Number = 0;
		public var swingDist:Number;
		public var swingAngle:Number;
		
		public var minArmLength:Number = 48;
		public var idealArmLength:Number = 96;
		public var maxArmLength:Number = 128;
		
		public var itemMagnetStrength:Number = 40.0;
		public var itemMagnetRange:Number = 40.0;
		public var spriteMap:Spritemap;
		public var armGraphic:Image = new Image(Assets.APE_ARM);
		public var emitter:Emitter;

		
		public function Player(x:Number=0, y:Number=0)
		{
			//graphic = Image.createRect(8, 8);
			spriteMap = new Spritemap(Assets.PLAYER, 32, 32);
			spriteMap.add("stand_right", [0], 0);
			spriteMap.add("stand_left", [8], 0);
			spriteMap.add("run_right", [1, 0, 2, 0], 10);
			spriteMap.add("run_left", [8], 10);
			spriteMap.add("jump_right", [16], 10);
			spriteMap.add("jump_left", [24], 10);
			spriteMap.originX = 16;
			spriteMap.originY = 16;
			
//			emitter = new Emitter(new BitmapData(1,1), 1, 1);
			emitter = new Emitter(Assets.PARTICLE_DUST, 3, 3);
			//			emitter.newType("sparkle", [0, 1, 2, 3, 4]);
			emitter.relative = false;
			
			emitter.newType("sparkle", [0]);
			emitter.setAlpha("sparkle",1.0, 0);
			emitter.setMotion("sparkle", 0, 100, 3, 360, -100, -0.5, Ease.quadOut);
			emitter.setColor("sparkle", 0xef5e5e);
			
			emitter.newType("dustCloud", [0]);
			emitter.setAlpha("dustCloud", 1.0, 0);
			emitter.setMotion("dustCloud", 5, 15, 3, 170, -5, -0.5, Ease.quadOut);
			emitter.setColor("dustCloud", 0x404000);
			emitter.setGravity("dustCloud", 0.8);
			
			emitter.newType("dustCloudBig", [0]);
			emitter.setAlpha("dustCloudBig", 1.0, 0);
			emitter.setMotion("dustCloudBig", 5, 50, 4, 170, -5, -0.5, Ease.quadOut);
			emitter.setColor("dustCloudBig", 0x404000);
			emitter.setGravity("dustCloudBig", 0.8);
			
			
//			emitter.setMotion("dustCloud", 0, 50, 2, 360, -40, -0.5, Ease.quadOut);			
			
			graphic = new Graphiclist(emitter, spriteMap);
			
			
			setHitbox(32, 32, 16, 16);
			type = "player";
			super(x, y, false, graphic, mask);
			mass = 0.7;
			layer = -6;
			FP.console.watch(swinging, swinger);
		}
		override public function update():void {
			var walked:Boolean = false;
			if (Input.pressed(Key.S)) {
				speed *= 3;
				HUD.pickups["brain"] = 49;
			}
			if (Input.check("left")) { 
//				targetSpeed = bottomSpeed;
				if (swinging) {
					swingVel -= 0.1;
				} else if (acc.x > -maxSpeed.x) {
					if (onGround) {
						targetSpeed = topSpeed;
						acc.x -= speed * FP.elapsed;
					} else {
						acc.x -= speed * 0.3 * FP.elapsed;
					}
					walked = true;
				}
				facingRight = false;
				
			} else if (Input.check("right")) { 
//				targetSpeed = topSpeed;
				if (swinging) {
					swingVel += 0.1;
				} else if (acc.x < maxSpeed.x) {
					if (onGround) {
						targetSpeed = topSpeed;
						acc.x += speed * FP.elapsed;
					} else {
						acc.x += speed * 0.3 * FP.elapsed;
					}
					walked = true;					
				}
				facingRight = true;
				
			} else {
				targetSpeed = (topSpeed + bottomSpeed) / 2;
			}
			friction = GameWorld.friction;
			if (Input.check("jump")) {
				if (Input.pressed("jump") && (onGround || (hasDoubleJump && canDoubleJump))) {
//					yVel -= jumpEnergy;
					acc.y -= jumpEnergy;
//					vel.x += jumpEnergy * 0.25;
					jumpCounter = jumpTime;
					if (onGround) {
						canDoubleJump = true;
						emit("dustCloudBig", x, y + height / 2, 10);
						Assets.jumpSound.play(0.1);
						Assets.landingSound.play(0.8);
					} else {						
						canDoubleJump = false;
						Assets.jumpSound.play(0.1);
						vel.y = 0;
					}
				} else {
					jumpCounter -= FP.elapsed;
					if (hasFloat) {
						vel.y -= GameWorld.gravity * 0.35;
					} 
					if ((jumpCounter > 0 && vel.y < 0)) {					
//						yVel -= jumpEnergy * 0.5;
//						vel.y -= jumpEnergy * 0.75;
						var jumpAmount:Number = (jumpCounter / jumpTime);
//						vel.x += jumpEnergy * 0.25 * jumpAmount;						
						acc.y -= jumpEnergy * 0.5 * jumpAmount;
					}
				}
			}
			if (Input.check("swing")) {
				if (Input.pressed("swing")) {
					// find a swing target
					swinger = world.nearestToEntity("swinger", this, true) as Swinger;
					
					var velocity:Number = Math.sqrt(vel.y*vel.y + vel.x*vel.x);
					
					if (swinger != null) {
						var dx:Number = x - swinger.x;
						var dy:Number = y - swinger.y;
						
						// only start swinging if we're at least slightly under the swinger point
	//					if (dy < 0) {
							swingDist = Math.sqrt(dx*dx + dy*dy);
							var ang:Number = Math.atan2(dy, dx) * 180 / Math.PI;
							swingVel = vel.x * Math.sin(ang) + vel.y * -Math.cos(ang);					
							if (swinger != null && swingDist < maxArmLength) {
								swinging = true;	
								if (swingDist < minArmLength) {
									x = swinger.x + Math.cos(ang) * minArmLength;
									y = swinger.y + Math.sin(ang) * minArmLength;
								}
//								trace("started swinging with velocity: " + swingVel);
							}
							swinger.emit("leaves", swinger.x  + 16, swinger.y + 16, Math.random()*20+3);
	//					}
					}
				} else {
					// continue swinging
//					trace("swinging?");
				}
			} else {
				if (Input.released("swing") && swinging) {
					// convert from swing velocity to normal
//					trace("stopping swinging");
				}
				swinging = false;
			}
			if (Input.pressed(Key.R)) {
				(world as GameWorld).playerDied();
			}
//			topSpeed += 0.2;
//			bottomSpeed += 0.1;
			//speed += (targetSpeed - speed) * 0.1;
			if (speed < targetSpeed) {
				speed += 0.1;
			} else {
				speed -= 0.1;
			}
			footStepCountdown -= FP.elapsed;
			if (!swinging) {
//				vel.x += speed * FP.elapsed;
				if (onGround) {		
					if (walked) {
						spriteMap.play( vel.x < 0 ? "run_left" : "run_right");						
						if (footStepCountdown < 0) {
							Assets.footStepSound.play(0.08);
							footStepCountdown = footStepInterval;
						}
					} else {
						spriteMap.play( facingRight ? "stand_right" : "stand_left");
					}
				} else {
					spriteMap.play( vel.x < 0 ? "jump_left" : "jump_right");
				}
				super.update();
				if (onGround && !wasOnGround) {
					emit("dustCloudBig", x, y + height / 2, 30);
					Assets.landingSound.play(0.5);
				}
			} else {			
				 // update swingy stuff
				var dx:Number = x - swinger.centerX;
				var dy:Number = y - swinger.centerY;
				var ang:Number = Math.atan2(dy, dx) * 180 / Math.PI;				 
				 if (ang > 90 && ang < 180) {
					 swingVel += 0.3 * ( (ang-90) / 90 );
//					 trace("SW");
				 }
				 if (ang < 90 && ang > 0) {
					 swingVel -= 0.3 * (1.0 - (ang / 90));
//					 trace("SE");
				 }
				 
				 if (ang > -90 && ang < 0) {
//					 swingVel *= 0.9;
					 swingVel -= 0.3;
//					 trace("NE");
				 }
				 if (ang < -90) {
//					 swingVel *= 0.9;
					 swingVel += 0.3;
//					 trace("NW");
				 }
				 
				 var swingAmount:Number = -swingVel * FP.elapsed;
				 var s:Number = Math.sin(swingAmount);
				 var c:Number = Math.cos(swingAmount);
				 x -= swinger.centerX;
				 y -= swinger.centerY;
				 var newX:Number = x * c - y * s;
				 var newY:Number = x * s + y * c;
				 acc.x = (newX - x) * 4.0;			
				 acc.y = (newY - y) * 4.0 - jumpEnergy;
				 x = newX;
				 y = newY;

				 // [@todo fix this part - it's supposed to keep the arm within a reasonable length range]
				 dx = x - swinger.centerX;
				 dy = y - swinger.centerY;
				 var dist:Number = Math.sqrt(dx*dx + dy*dy);
				 ang = Math.atan2(dy, dx);
				 swingAngle = ang;
//				 newX = Math.cos(ang) * idealArmLength;
//				 newY = Math.sin(ang) * idealArmLength;
//
//				 if (dist < minArmLength) {
//					 trace("dist:" + dist + ", x,y:" + x + ", " + y);
////					 if (dist <= 2) {
////						 x += vel.x;
////						 y += vel.y;
////					 }
////					 x *= 1.1 * FP.elapsed;
////					 y *= 1.1 * FP.elapsed;
//					 
////					 x -= (newX - x) *  FP.elapsed;
////					 y -= (newY - y) *  FP.elapsed;
//					 
//					 
//				 } else if (dist > idealArmLength) {
////					 x *= 0.9 * FP.elapsed;
////					 y *= 0.9 * FP.elapsed;
//					 x += (newX - x) *  FP.elapsed;
//					 y += (newY - y) *  FP.elapsed;
//					 
//				 }
				 x += swinger.centerX;
				 y += swinger.centerY;
			}
			
			if (spriteMap.currentAnim === "run_right" || spriteMap.currentAnim === "run_left") {
				emit("dustCloud", x, y + height / 2, 5);
			}
			
			
		}
		override public function render():void {
			if (swinging) {
				Draw.line(x, y, swinger.centerX, swinger.centerY, 0x808080);
				
//				FP.matrix.rotate(swingAngle);
//				FP.buffer.draw(armGraphic);
			}
			super.render();
		}
		override public function checkBounds():void {
			if (x < world.camera.x-32 || y < world.camera.y-FP.screen.height || x > world.camera.x+FP.screen.width+32 || y > FP.screen.height) {				
				(world as GameWorld).playerDied();

			}
		}
		public function emit(name:String, xx:Number=0, yy:Number=0, count:int = 1) {
			for (var i:int=0;i<count;i++) {
				emitter.emit(name, xx, yy);
			}
		}
	}
}