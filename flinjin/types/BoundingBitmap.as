package flinjin.types
{
	import flash.display.BitmapData;
	import flinjin.graphics.Sprite;
	import flinjin.system.FlinjinError;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class BoundingBitmap extends BoundingRect
	{
		private var _data:BitmapData = null;
		
		public function BoundingBitmap(toObj:Sprite, data:BitmapData)
		{
			if (data == null)
			{
				throw new FlinjinError("Bitmap data is null");
			}
			
			super(toObj, _data.width / 2, _data.height / 2);
			_data = data;
		}
	
	}

}