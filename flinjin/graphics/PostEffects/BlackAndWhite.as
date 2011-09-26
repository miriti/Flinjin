package flinjin.graphics.PostEffects
{
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author KEFIR
	 */
	public class BlackAndWhite extends PostEffect
	{

		override public function Apply(bitmapData:BitmapData):void
		{
			for (var i:uint = 0; i < bitmapData.width; i++) {
				for (var j:uint = 0; j < bitmapData.height; j++) {
					var col:uint = bitmapData.getPixel(i, j);
					var r:uint = (col >> 16) & 0xff;
					var g:uint = (col >> 8) & 0xff;
					var b:uint = (col & 0xff);
					var gray:uint = (r + g + b) / 3;
					var rcol:uint = ( (  gray << 16 ) | (  gray << 8 ) |  gray );
					
					bitmapData.setPixel(i, j, rcol);
				}
			}
		}
		public function BlackAndWhite()
		{
			super();
			
		}
		
	}

}