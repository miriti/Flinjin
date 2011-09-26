package BlitEngine
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Спрайт, с прокпуткой битмапа
	 *
	 * @todo Дать возможность задавать произвольные размеры спрайта. Тем самым тайлить. Или наследовать класс с такой возможностью
	 *
	 */
	public class ScrollingSprite extends SpriteBase
	{
		private var _bitmap:Bitmap;
		private var _resBitmap:BitmapData;
		private var _matrix:Matrix = new Matrix();
		
		public var speedX:Number = 0;
		public var speedY:Number = 0;
		
		public var shiftX:int = 0;
		public var shiftY:int = 0;
		
		private var _shiftX_f:Number = 0;
		private var _shiftY_f:Number = 0;
		
		/**
		 * Движение
		 */
		override public function Move():void {
			_shiftX_f += speedX;
			_shiftY_f += speedY;
			
			if (_shiftX_f >= _bitmap.width) {
				_shiftX_f = _shiftX_f - _bitmap.width;
			}
			
			if (_shiftX_f < 0) {
				_shiftX_f = _bitmap.width + _shiftX_f;
			}
			
			if (_shiftY_f >= _bitmap.height) {
				_shiftY_f = _shiftY_f - _bitmap.height;
			}
			
			if (_shiftY_f < 0) {
				_shiftY_f = _bitmap.height + _shiftY_f;
			}
	
			shiftX = Math.floor(_shiftX_f);
			shiftY = Math.floor(_shiftY_f);
		}
		
		override public function Draw(surface:BitmapData, inmatrix:Matrix = null):void
		{
			var BlitsArray:Array = new Array();
			var BlitsPoints:Array = new Array();
			
			// TODO Оптимизировать! Совсем не обязательно создавать все эти штуки при каждом вызове!
			BlitsArray[0] = new Rectangle(_bitmap.width - shiftX, _bitmap.height - shiftY, shiftX, shiftY);
			BlitsArray[1] = new Rectangle(0, _bitmap.height - shiftY, _bitmap.width - shiftX, shiftY);
			BlitsArray[2] = new Rectangle(_bitmap.width - shiftX, 0, shiftX, _bitmap.height - shiftY);
			BlitsArray[3] = new Rectangle(0, 0, _bitmap.width - shiftX, _bitmap.height - shiftY);
			
			BlitsPoints[0] = new Point(0,		0);
			BlitsPoints[1] = new Point(shiftX,	0);
			BlitsPoints[2] = new Point(0,		shiftY);
			BlitsPoints[3] = new Point(shiftX,	shiftY);
			
			for (var i:uint = 0; i < 4; i++) {
				if ((Rectangle(BlitsArray[i]).width > 0) && (Rectangle(BlitsArray[i]).height > 0)) {
					_resBitmap.copyPixels(_bitmap.bitmapData, BlitsArray[i], BlitsPoints[i]);
				}
			}
			
			_matrix.identity();
			
			if (inmatrix != null) {
				_matrix.concat(inmatrix);
			}
			
			_matrix.translate(x, y);
			
			
			surface.draw(_resBitmap, _matrix);
		}
		
		public function ScrollingSprite(spriteBmp:Bitmap)
		{
			super(spriteBmp, new Point(0, 0));
			_bitmap = spriteBmp;
			_resBitmap = new BitmapData(_bitmap.width, _bitmap.height);
		}
		
	}

}