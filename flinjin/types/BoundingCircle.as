package flinjin.types
{
	import flash.geom.Point;
	import flash.display.BitmapData;
	import flinjin.graphics.Sprite;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class BoundingCircle extends BoundingShape
	{
		private var _radius:Number;
		
		override public function DebugDraw(surface:BitmapData):void
		{
			var stX:Number = x;
			var stY:Number = y;
			
			for (var i:int = 0; i < 8; i++)
			{
				// TODO fix it! FIXED?
				surface.setPixel32(stX + Math.sin((i * 45) * Math.PI / 180) * _radius, stY + Math.cos((i * 45) * Math.PI / 180) * _radius, 0xffff0000);
			}
		}
		
		public function BoundingCircle(toObj:Sprite, nRadius:Number)
		{
			_radius = nRadius;
			super(toObj);
		}
		
		public function get radius():Number
		{
			return _radius;
		}
		
		public function set radius(value:Number):void
		{
			_radius = value;
		}
	}

}