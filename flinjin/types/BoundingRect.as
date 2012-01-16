package flinjin.types
{
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class BoundingRect extends BoundingShape
	{
		private var _rect:Rectangle;
		
		public function BoundingRect(width:Number, height:Number)
		{
			_rect = new Rectangle(0, 0, width, height);
			super();
		}
		
		public function get rect():Rectangle
		{
			return _rect;
		}
		
		public function get height():Number
		{
			return _rect.height;
		}
		
		public function set height(value:Number):void
		{
			_rect.height = value;
		}
		
		public function get width():Number
		{
			return _rect.width;
		}
		
		public function set width(value:Number):void
		{
			_rect.width = value;
		}
	
	}

}