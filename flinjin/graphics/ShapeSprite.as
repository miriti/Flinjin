package flinjin.graphics
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author KEFIR
	 */
	public class ShapeSprite extends SpriteBase
	{
		public static const SHAPE_RECTANGLE:String = 'rectangle';
		public static const SHAPE_CIRCLE:String = 'circle';
		
		private var _shapeType:String;
		private var _sp:Shape;
		
		public var Radius:Number;
		
		override public function Draw(surface:BitmapData, inmatrix:Matrix = null):void
		{
			_sp.graphics.beginFill(colorTransform.color, alpha);
			switch(_shapeType) {
				case SHAPE_CIRCLE:
					_sp.graphics.drawCircle(0, 0, Radius);
					break;
					
				case SHAPE_RECTANGLE:
				default:
					_sp.graphics.drawRect(0, 0, width, height);
			}
			_sp.graphics.endFill();
			
			surface.draw(_sp, inmatrix);
		}
		
		public function ShapeSprite(shape:String)
		{
			_shapeType = shape;
			_sp = new Shape();
			
			super(null);
		}
		
	}

}