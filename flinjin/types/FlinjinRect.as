package flinjin.types
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class FlinjinRect extends Rectangle
	{
		public static function draw(rect:Rectangle, surface:BitmapData, color:uint = 0xff000000):void
		{
			for (var i:int = rect.x; i < rect.right; i++)
			{
				surface.setPixel32(i, rect.y, color);
				surface.setPixel32(i, rect.bottom - 1, color);
			}
			
			for (var j:int = rect.y; j < rect.bottom; j++)
			{
				surface.setPixel32(rect.x, j, color);
				surface.setPixel32(rect.right - 1, j, color);
			}
		}
		
		public function FlinjinRect(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0)
		{
			super(x, y, width, height);
		}
	
	}

}