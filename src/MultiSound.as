package
{
	import net.flashpunk.Sfx;

	public class MultiSound
	{
		public var sounds:Array = [];
		public var index:uint = 0;		
		public function MultiSound(soundResourceList:Array) 
		{
			for (var i:int = 0; i < soundResourceList.length; i++) {
				sounds.push(new Sfx(soundResourceList[i]));
			}
		}
		public function play(vol:Number = 1.0, pan:Number = 0):void {
			index = (index + 1) % sounds.length;
			(sounds[index] as Sfx).play(vol, pan);
		}
	}
}