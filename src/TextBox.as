package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class TextBox extends Entity
	{
		private var promptText:Text = new Text("input:", 0, 0);
		private var inputText:Text = new Text("", 0, 0);
		private var box:Image;
		private var callback:Function = TextBox.defaultCallback;
		public function TextBox( prompt:String, callback:Function, x:Number=0, y:Number=0)
		{
			this.callback = callback;
			box = Image.createRect(16 * 30, 16 * 3, 0x272727, 0.9);
			box.x = FP.screen.width / 2 - box.width / 2;
			box.y = FP.screen.height / 2 - box.height / 2;
			promptText.text = prompt;
			promptText.x = FP.screen.width / 2 - promptText.width / 2;
			promptText.y = box.y + 5;
			inputText.x = promptText.x;
			inputText.y = promptText.y + 20;
			graphic = new Graphiclist(box, promptText, inputText);
			Input.keyString = "";
			super(x, y, graphic, mask);
		}
		override public function update():void {
			if (Input.pressed(Key.ENTER)) {
				callback(inputText.text);
			}
			inputText.text = Input.keyString;
		}
		public static function defaultCallback(str:String):void {
			trace("No callback specified, or something really odd is happening");
		}
	}
}