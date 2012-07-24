package flinjin.types
{
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flinjin.events.FlinjinCollisionEvent;
	import flinjin.FlinjinLog;
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
		
		/**
		 * Rectangle bounding shape
		 *
		 * @param	toObj
		 * @param	newHalfWidth
		 * @param	newHalfHeight
		 * @param	centerShift
		 */
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
		
		override public function containPoint(p:Point):Boolean
		{
			return getRect().containsPoint(p);
		}
		
		/**
		 * returns the rectangle
		 *
		 * @return
		 */
		public function getRect():Rectangle
		{
			_rect.x = x - halfWidth + _centerShift.x;
			_rect.y = y - halfHeight + _centerShift.y;
			_rect.width = width;
			_rect.height = height;
			return _rect;
		}
		
		/**
		 * Test collision to another kinds of shapes
		 *
		 * @param	shape
		 * @return
		 */
		override public function CollisionTest(shape:BoundingShape):Boolean
		{
			switch (typeof(shape))
			{
				case BoundingPoint: 
					return _collidePoint(shape as BoundingPoint);
				case BoundingBitmap: 
				case BoundingCircle: 
				case BoundingFreeForm: 
				case BoundingRect: 
				case BoundingShapeGroup: 
				default: 
					FlinjinLog.l("Shape cannot be collided", FlinjinLog.W_ERRO);
					return false;
			}
			return super.CollisionTest(shape);
		}
		
		/**
		 * Collision with point
		 *
		 * @param	shape
		 */
		private function _collidePoint(shape:BoundingPoint):Boolean
		{
			if (_rect.contains(shape.x, shape.y))
			{
				dispatchEvent(new FlinjinCollisionEvent(FlinjinCollisionEvent.COLLISION, shape.connectedObject));
				shape.dispatchEvent(new FlinjinCollisionEvent(FlinjinCollisionEvent.COLLISION, this.connectedObject));
				return true;
			}
			else
				return false;
		}
		
		/**
		 * Draw debug rectangle
		 *
		 * @param	surface
		 * @param	shiftVector
		 */
		override public function DebugDraw(surface:BitmapData):void
		{
			var stX:Number = (x + _centerShift.x) - _halfWidth;
			var stY:Number = (y + _centerShift.y) - _halfWidth;
			
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