package flinjin.types
{
	import flash.geom.Point;
	import flash.display.BitmapData;
	import flinjin.graphics.Sprite;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class BoundingPoint extends BoundingShape
	{
		override public function DebugDraw(surface:BitmapData):void
		{
			surface.setPixel32(_position.x, _position.y, 0xffff0000);
		}
		
		public function BoundingPoint(toObj:Sprite, pX:Number, pY:Number)
		{
			super(toObj);
			
			position.x = pX;
			position.y = pY;
		}
	
	}

}