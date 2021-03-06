package flinjin.types
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flinjin.graphics.FjSprite;
	import flinjin.system.FlinjinError;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class BoundingShape extends EventDispatcher
	{
		protected var _position:Point = new Point(0, 0);
		protected var _connectedObject:FjSprite = null;
		
		public function BoundingShape(toObj:FjSprite)
		{
			_connectedObject = toObj;
		}
		
		public function containPoint(p:Point):Boolean {
			return false;
		}
		
		public function DebugDraw(surface:BitmapData):void
		{
		
		}
		
		public function setPossition(x:Number, y:Number):void
		{
			_position.x = x;
			_position.y = y;
		}
		
		public function CollisionTest(shape:BoundingShape):Boolean
		{
			if (!(shape is BoundingShape))
			{
				throw new FlinjinError("Unknown error");
			}
			
			return false;
		}
		
		public function get position():Point
		{
			return _position;
		}
		
		public function set position(value:Point):void
		{
			_position = value;
		}
		
		public function get y():Number
		{
			return _position.y;
		}
		
		public function set y(value:Number):void
		{
			_position.y = value;
		}
		
		public function get x():Number
		{
			return _position.x;
		}
		
		public function set x(value:Number):void
		{
			_position.x = value;
		}
		
		public function get connectedObject():FjSprite
		{
			return _connectedObject;
		}
	}

}