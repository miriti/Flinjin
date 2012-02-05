package flinjin.graphics.PostEffects
{
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class Blur extends PostEffect
	{
		private var _filter:BlurFilter;
		private var _p:Point = new Point();
		
		override public function Apply(bitmapData:BitmapData):void
		{
			bitmapData.applyFilter(bitmapData, bitmapData.rect, _p, _filter);
		}
		
		public function Blur(strong:Number = 5)
		{
			super();
			_filter = new BlurFilter(strong, strong);
		}
	
	}

}