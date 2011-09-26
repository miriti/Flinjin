package BlitEngine.PostEffects
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author KEFIR
	 */
	public class MotionBlur extends PostEffect
	{
		private var _buffer:BitmapData = null;
		private var _color:ColorTransform;
		
		override public function Apply(bitmapData:BitmapData):void
		{
			if (_buffer != null) {
				bitmapData.draw(_buffer, null, _color);
				_buffer.draw(bitmapData);
			}else {
				_buffer = new BitmapData(bitmapData.width, bitmapData.height, true, 0x00000000);
				_buffer.draw(bitmapData);
			}
		}
		
		public function MotionBlur(alpha:Number = 0.5)
		{
			_color = new ColorTransform(1, 1, 1, alpha);
		}
		
	}

}