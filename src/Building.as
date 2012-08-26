package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Tilemap;
	
	/*
	 * A "building" - but really just a generic chunk of tiles that auto generates
	 * hopefully I'll get enough done that I can justify adding changing scenery at which point we'll have the city
	 * but more likely this will always be a jungle building :)
	 */
	public class Building extends Entity
	{
		public static const TILE_SIZE:Number = 16;
		private const TILE_FILL:uint = 0;
		private const TILE_TOP:uint = 1;
		private const TILE_TOP_LEFT:uint = 2;
		private const TILE_TOP_RIGHT:uint = 3;
		private const TILE_GROUND_DECORATIONS:uint = 4;
		public var tileWidth:uint;
		public var tileHeight:uint;
		public var theMap:Tilemap;
		public var tileSet:Array;
		public var items:Array = [];
		public function Building(tileset:Array, tileW:Number, tileH:Number, x:Number=0)
		{
			tileWidth = tileW;
			tileHeight = tileH;
			tileSet = tileset;
			theMap = new Tilemap(Assets.TILES, tileW * TILE_SIZE, tileH * TILE_SIZE, TILE_SIZE, TILE_SIZE);
			graphic = theMap;
			
			buildtheMap();
			this.setHitbox(tileWidth * TILE_SIZE, tileHeight * TILE_SIZE, 0, -TILE_SIZE);
			type = "solid";
			super(x, FP.screen.height - theMap.height, graphic);
		}
		/* for overriding */
		public function buildtheMap():void {
			theMap.setRect(0, 2, tileWidth, tileHeight, tileSet[TILE_FILL]);
			theMap.setRect(0, 1, tileWidth, 1, tileSet[TILE_TOP]);
			theMap.setTile(0, 1, tileSet[TILE_TOP_LEFT]);
			theMap.setTile(tileWidth-1, 1, tileSet[TILE_TOP_RIGHT]);
			var decos:Array = tileSet[TILE_GROUND_DECORATIONS];
			for (var i:uint = 0; i < tileWidth; i++) {
				if (Math.random() < 0.7) {					
					theMap.setTile(i, 0, decos[i % decos.length]);
				} else {
					theMap.setTile(i, 0, 0);
				}
			}
		}
	}
}