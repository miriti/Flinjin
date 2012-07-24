package flinjin.types
{
	import flash.display.BitmapData;
	import flinjin.graphics.FjSprite;
	import flinjin.system.FlinjinError;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class BoundingBitmap extends BoundingRect
	{
		private var _data:BitmapData = null;
		
		public function BoundingBitmap(toObj:FjSprite, data:BitmapData)
		{
			super(toObj, _data.width / 2, _data.height / 2);
			_data = data;
		}
	
	}

}