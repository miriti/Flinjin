package flinjin.types
{
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flinjin.graphics.Sprite;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class BoundingRect extends BoundingShape
	{
		protected var _halfWidth:Number;
		protected var _halfHeight:Number;
		protected var _centerShift:Point = new Point();
		protected var _rect:Rectangle = new Rectangle();
		
		public function BoundingRect(toObj:Sprite, newHalfWidth:Number, newHalfHeight:Number, centerShift:Point = null)
		{
			_halfWidth = newHalfWidth;
			_halfHeight = newHalfHeight;
			
			if (centerShift != null)
			{
				_centerShift = centerShift;
			}
			
			super(toObj);
		}
		
		public function getRect():Rectangle
		{
			_rect.x = x - halfWidth + _centerShift.x;
			_rect.y = y - halfHeight + _centerShift.y;
			_rect.width = width;
			_rect.height = height;
			return _rect;
		}
		
		override public function DebugDraw(surface:BitmapData, shiftVector:Point):void
		{
			var stX:Number = (shiftVector.x + x + _centerShift.x) - _halfWidth;
			var stY:Number = (shiftVector.y + y + _centerShift.y) - _halfWidth;
			
			for (var i:int = stX; i < (stX + width); i++)
			{
				surface.setPixel32(i, stY, 0xffff0000);
				surface.setPixel32(i, stY + height - 1, 0xffff0000);
			}
			
			for (var j:int = stY; j < (stY + height); j++)
			{
				surface.setPixel32(stX, j, 0xffff0000);
				surface.setPixel32(stX + width - 1, j, 0xffff0000);
			}
		}
		
		public function get height():Number
		{
			return _halfHeight * 2;
		}
		
		public function get width():Number
		{
			return _halfWidth * 2;
		}
		
		public function get halfWidth():Number
		{
			return _halfWidth;
		}
		
		public function set halfWidth(value:Number):void
		{
			_halfWidth = value;
		}
		
		public function get halfHeight():Number
		{
			return _halfHeight;
		}
		
		public function set halfHeight(value:Number):void
		{
			_halfHeight = value;
		}
		
		public function get shift():Point
		{
			return _centerShift;
		}
		
		public function set shift(value:Point):void
		{
			_centerShift = value;
		}
	
	}

}