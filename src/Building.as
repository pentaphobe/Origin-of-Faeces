package
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.FP;
	
	public class Building extends Entity
	{
		private const TILE_SIZE:Number = 16;
		private const TILE_FILL:uint = 0;
		private const TILE_TOP:uint = 1;
		private const TILE_TOP_LEFT:uint = 2;
		private const TILE_TOP_RIGHT:uint = 3;
		public var tileWidth:uint;
		public var tileHeight:uint;
		public var theMap:Tilemap;
		public var tileSet:Array;
		public function Building(tileset:Array, tileW:Number, tileH:Number, x:Number=0)
		{
			tileWidth = tileW;
			tileHeight = tileH;
			tileSet = tileset;
			theMap = new Tilemap(GameWorld.TILES, tileW * TILE_SIZE, tileH * TILE_SIZE, TILE_SIZE, TILE_SIZE);
			graphic = theMap;
			
			buildtheMap();
			this.setHitbox(tileWidth * TILE_SIZE, tileHeight * TILE_SIZE);
			type = "solid";
			super(x, FP.screen.height - theMap.height, graphic);
		}
		/* for overriding */
		public function buildtheMap():void {
			theMap.setRect(0, 0, tileWidth, tileHeight, tileSet[TILE_FILL]);
			theMap.setRect(0, 0, tileWidth, 1, tileSet[TILE_TOP]);
			
		}
	}
}