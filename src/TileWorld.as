package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.Grid;
	
	public class TileWorld extends Entity
	{
		[Embed(source = "assets/tiles.png")] private static const TILES:Class;
		
		private const TILE_SIZE:Number = 16;
		private var lastHeight:uint = 8;
		private var runLength:uint = 0;
		private var speedScaler:Number;
		private var theMap:Tilemap;
		private var collisionGrid:Grid;
		private var tileIndexOffset:uint;
		public function TileWorld(tileIndexOffset:uint = 0, isSolid:Boolean = true, speed:Number = 1.0, initialHeight:uint = 8)
		{
			this.tileIndexOffset = tileIndexOffset;
			this.lastHeight = initialHeight;
			speedScaler = speed;
			theMap = new Tilemap(TILES, FP.screen.width + TILE_SIZE*2, FP.screen.height + TILE_SIZE*2, TILE_SIZE, TILE_SIZE);
			graphic = theMap;			
			drawAll();
			if (isSolid) {
				type = "solid";
			}
			this.collisionGrid = theMap.createGrid([1,2, 3, 4, 5]);
			super(- 1*TILE_SIZE, - 1*TILE_SIZE, graphic, collisionGrid);
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
			for (var y:uint = 0; y < theMap.columns; y++) {
				for (var x:uint = 0; x < theMap.rows; x++) {
					var solid:Boolean = theMap.getTile(x, y) != 0;
					collisionGrid.setTile(x, y, solid);
				}
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
			var edgeType:int = 0;
			if (runLength < 12 && Math.random() < 0.9) {
				runLength += 1;
			} else if (Math.random() < 0.5 && h < theMap.rows - 3) {
				// go up a tile
				h += 1;		
				edgeType = -1;
			} else {
				h -= (uint)(Math.random() * (theMap.rows/2));
				if (h < 3) {
					// if the height is low then force it to higher.  eventually we'll want gap logic here
					h = 4;
				}
				edgeType = 1;
			}
			if (lastHeight != h) { runLength = 0; }
			lastHeight = h;
			theMap.setRect(x, theMap.rows - h, w, h, 1 + this.tileIndexOffset);
			theMap.setTile(x, theMap.rows - h, 3 + edgeType + this.tileIndexOffset);
			theMap.updateAll();
		}
	}
}