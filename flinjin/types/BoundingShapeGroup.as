package flinjin.types
{
	import flash.geom.Point;
	import flash.display.BitmapData;
	import flinjin.graphics.Sprite;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class BoundingShapeGroup extends BoundingRect
	{
		private var _list:Vector.<BoundingShape> = new Vector.<BoundingShape>;
		
		override public function get x():Number
		{
			return super.x;
		}
		
		override public function set x(value:Number):void
		{
			
			for each (var BS:BoundingShape in _list)
			{
				BS.x += value - super.x;
			}
			super.x = value;
		}
		
		override public function get y():Number
		{
			return super.y;
		}
		
		override public function set y(value:Number):void
		{
			for each (var BS:BoundingShape in _list)
			{
				BS.y += value - super.y;
			}
			super.y = value;
		}
		
		override public function DebugDraw(surface:BitmapData):void
		{
			for each (var BS:BoundingShape in _list)
			{
				BS.DebugDraw(surface);
			}
			super.DebugDraw(surface);
		}
		
		public function BoundingShapeGroup(toObj:Sprite, listObjects:Array)
		{
			for (var i:int = 0; i < listObjects.length; i++)
			{
				_list.push(listObjects[i]);
			}
			
			super(toObj, 0, 0);
		
		}
	
	}

}