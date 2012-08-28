package
{
	import flash.utils.Dictionary;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class HUD extends Entity
	{
		private var scoreText:Text = new Text(String(distanceRun), 10, 8, 200, 50);
		private var pickupText:Text = new Text("", 10, 20, 200, 50);
		private var hintText:Text = new Text("hint", 10, 60, 200, 50);
		private var hintBackground:Image = new Image(Assets.HINT_BG);
		private var profileImage:Image = new Image(Assets.APE_PROFILE);
		public static var distanceRun:Number = 0;
		public static var pickups:Object = {};
		public static var hints:Array = [
			{	start:20, end:35 * 16, text:"you can jump with <Z> or <UP>"		},
			{	start:50 * 16, end:75 * 16, text:"you can also swing from tree tops with <X>"},
			{	start:300 * 16, end:400 * 16, text:"get that Pope!"},
			{	start:450 * 16, end:550 * 16, text:"(Just kidding. He doesn't exist in this version)"},
			{	start:2000 * 16, end:2500 * 16, text:"frankly I'm amazed you stuck with it this long.." },
			{	start:3500 * 16, end:3800 * 16, text:"I wish I could have finished\nmaking this :)" },
			{	start:5000 * 16, end:5100 * 16, text:"That's it, seriously.  there's no end" }
		];
		public static var hintStack:Array = [];
		public static var itemHints:Object = {
			brain:"collect brains to gain skills"
		};
		public static var activeHint:Object;
		public function HUD()
		{
			layer = -1;
			profileImage.x = 10;
			profileImage.y = FP.screen.height - profileImage.height + 1;
			hintText.x = 80;
			hintText.y = FP.screen.height - hintText.height;
			hintText.color = 0x272727;
			hintBackground.x = hintText.x - 10;
			hintBackground.y = hintText.y - 10;
			hintText.alpha = 0;hintBackground.alpha = 0;
			var display:Graphic = new Graphiclist(scoreText, pickupText, hintBackground, hintText, profileImage);
			graphic = display;
			super(x, y, graphic);
		}
		public function reset():void {
			distanceRun = 0;
			pickups = {};
			hintText.alpha = 0;hintBackground.alpha = 0;
			hintStack = [];
		}
		override public function update():void {
			if (Input.pressed(Key.D)) {
				addHint("hi boogies");
				trace(distanceRun);
			}
			scoreText.text = String(Math.floor(distanceRun / 16)) + "m";
			pickupText.text = "";
			for (var i in pickups) {
				pickupText.text += String(i) + "s:" + pickups[i].toString();
			}
			y = Math.floor(world.camera.y);
			x = Math.floor(world.camera.x);
			FP.console.watch(hintStack);
			
			for (var h in hints) {
				var hint:Object = hints[h];
				if (hint.end > distanceRun && hint.start < distanceRun && (hintStack.indexOf(hint) == -1)) {
					hintStack.push(hint);
					trace(hintStack);
				}
			}
			
			if (activeHint != null) {
				hintText.text = activeHint.text;
				var alph:Number = 1;

				if (distanceRun - activeHint.start < 200) {
					alph = (distanceRun - activeHint.start) / 200;
				} else if (activeHint.end - distanceRun < 200) {
					alph = (activeHint.end - distanceRun) / 200;
					if (alph < 0.1) {
						activeHint = null;
						alph = 0;
					}					
				}
				hintText.alpha = alph;
				hintBackground.alpha = alph * 0.5;
			} else {			
				// check for any hints in our stack
				if (hintStack.length > 0) {
//					trace("checking for others");

					var hint:Object = hintStack.shift();
//					for (var i in hint) {
//						trace(i + ":" + hint[i]);
//					}
					if (hint instanceof String) {
						setHint(500, hint as String);
					} else {
						activeHint = hint;
					}
				}
			}
		}	
		/* adds a nonessential hint to be shown whenever possible
		 */
		public static function addHint(text:String, start:Number=-1, end:Number=-1):void {
			if (start == -1) start = distanceRun+100;
			if (end == -1) end = start + 1500;
			var hint:Object = {text:text, start:start, end:end};
//			trace("item hint" + hint);
			if (hintStack.length == 0 && activeHint == null) {
				activeHint = hint;
			} else {
				hintStack.push(hint);			
			}
		}
		public static function setHint(time:Number, text:String):void {
			activeHint = {start:distanceRun, end:distanceRun+time, text:text};
		}
		public static function addPickup(name:String):void {
			if (!pickups.hasOwnProperty(name)) {				
				pickups[name] = 1;
				if (itemHints.hasOwnProperty(name)) {
					addHint(itemHints[name]);
				}
			} else {
				pickups[name]++;	

				if (name == "brain") {
					// [@todo just hardcoding stuff because it's submission time..]
					var cnt:Number = pickups[name];
					if (cnt >= 15 && !GameWorld.player.hasDoubleJump) {
						addHint("you have learnt double-jump!\npress <JUMP> while airborne");
						GameWorld.player.hasDoubleJump = true;
					}
					if (cnt >= 100 && !GameWorld.player.hasFloat) {
						addHint("you have learnt how to float!\nhold <JUMP> to fall slowly");
						GameWorld.player.hasFloat = true;
					}
					if (cnt % 30 == 0) {
						addHint("brain magnet upgraded!");
						GameWorld.player.itemMagnetRange += 5;
						GameWorld.player.itemMagnetStrength += 7;
					}
				}
			}
		}
	}
}