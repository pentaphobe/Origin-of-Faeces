package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	
	public class TileWorld extends Entity
	{
		[Embed(source = "assets/tiles.png")] private static const TILES:Class;
		
		private const TILE_SIZE:Number = 16;
		private var lastHeight:uint = 5;
		private var runLength:uint = 0;
		private var speedScaler:Number;
		private var theMap:Tilemap;
		private var tileIndexOffset:uint;
		public function TileWorld(tileIndexOffset:uint = 0, isSolid:Boolean = true, speed:Number = 1.0)
		{
			this.tileIndexOffset = tileIndexOffset;
			speedScaler = speed;
			theMap = new Tilemap(TILES, FP.screen.width + TILE_SIZE*2, FP.screen.height + TILE_SIZE*2, TILE_SIZE, TILE_SIZE);
			graphic = theMap;			
			drawAll();
			if (isSolid) {
				type = "solid";
			}
			super(- 2*TILE_SIZE, - 2*TILE_SIZE, graphic, mask);
		}
		override public function render():void {
			super.render();	
		}
		
		public function scrollRight(speed:Number):void {
			x -= speed * speedScaler; 
			while (x < -TILE_SIZE) {
				theMap.shiftTiles(-1, 0, false);
				theMap.clearRect(theMap.columns - 1, 0, 1, theMap.rows);
				drawColumn(theMap.columns-1, 1);
				x += TILE_SIZE;
			}
		}
		
		public function drawAll():void {
			for (var i:int = 0; i < theMap.columns; i++) {
				drawColumn(i, 1);
			}
			theMap.updateAll();
		}		
		public function drawColumn(x:Number, w:Number):void {
			var h:int = lastHeight;
			
			if (runLength < 12 && Math.random() < 0.9) {
				runLength += 1;
			} else if (Math.random() < 0.5 && h < theMap.rows - 3) {
				// go up a tile
				h += 1;				
			} else {
				h -= (uint)(Math.random() * (theMap.rows/2));
				if (h < 0) {
					// if the height is low then force it to higher.  eventually we'll want gap logic here
					h = 2;
				}
			}
			if (lastHeight != h) { runLength = 0; }
			lastHeight = h;
			theMap.setRect(x, theMap.rows - h, w, h, 1 + this.tileIndexOffset);
			theMap.setTile(x, theMap.rows - h, 2 + this.tileIndexOffset);
			theMap.updateAll();
		}
	}
}