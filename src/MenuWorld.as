package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	public class MenuWorld extends World
	{
		public var ready:Boolean = false;
		private var menuText:Text = new Text("> press anything to start <", 10, 8, 150, 200);
		private var backgroundImage:Image;
		public function MenuWorld()
		{
			
			super();
		}
		override public function begin():void {
			Assets.foyerMusic.loop(0.3);
			FP.screen.color = 0x13131c;
			backgroundImage = new Image(Assets.SCENE_MENU);
			add(new Entity(0, 0, backgroundImage));
			add(new Entity(120, 210, menuText));
			 
			super.begin();
		} 
		override public function update():void {
			
			if (Input.pressed(Key.ANY) || Input.mousePressed) {
				ready = true;				
//				trace("update");
			}
			if (ready) {
				Assets.foyerMusic.volume *= 0.91;
				menuText.alpha *= 0.91;
				backgroundImage.alpha *= 0.91;
//				trace(Assets.foyerMusic.volume);
				if (Assets.foyerMusic.volume <= 0.005) {
					FP.world = new GameWorld;
					Assets.foyerMusic.stop();
				}
			}
		}
		override public function end():void {
			
		}
	}
}