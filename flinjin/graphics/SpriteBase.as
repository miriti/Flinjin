package BlitEngine
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	 * Базовый класс спрайта
	 *
	 * @author ...
	 */
	public class SpriteBase extends Object
	{
		private var _bitmap:Bitmap;
		private var _frames:Array;
		private var _current_bitmap:BitmapData;
		
		private var _spriteWidth:uint;
		private var _spriteHeight:uint;
		private var _spriteRect:Rectangle;
		
		private var _animated:Boolean = false;
		private var _minFrame:uint = 0;
		private var _maxFrame:uint = 0;
		private var _currentFrame:Number = 0;
		private var _frameRate:Number = 1;
		private var _playing:Boolean = true;
		
		private var _globalPosition:Point = new Point();
		private var _centerPoint:Point;
		private var _angle:Number = 0;
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;
		
		private var _matrix:Matrix = new Matrix();
		
		public var _flipHorizontal:Boolean = false;
		public var _flipVertical:Boolean = false;
		
		// Цветовое преобразование
		public var colorTransform:ColorTransform = new ColorTransform();
		
		// Родительская группа спрайта
		public var Group:SpriteGroup = null;
		
		// Был ли прорисован этот спрайт за предидущую итерацию
		public var Drawed:Boolean = false;
		
		// Флаг удаления спрайта
		public var Delete:Boolean = false;
		
		// zIndex
		public var zIndex:int = 0;
		
		// Флаг проверки столкновений
		public var CollisionEnabled:Boolean = false;
		
		// Попиксельная проверка столкновений
		public var CollisionPixelCheck:Boolean = false;
		
		// Отзывается ли объект на интерактивные действия
		public var Interactive:Boolean = false;
		
		// Мышь на спрайте
		public var MouseOver:Boolean = false;
		
		public function set flipHorizontal(val:Boolean):void {
			_flipHorizontal = val;
		}
		
		public function get flipHorizontal():Boolean {
			return _flipHorizontal;
		}
		
		public function set flipVertical(val:Boolean):void {
			_flipVertical = val;
		}
		
		public function get flipVertical():Boolean {
			return _flipVertical;
		}
		
		/**
		 * Сеттер X
		 */
		public function set x(val:int):void
		{
			_globalPosition.x = val;
		}
		
		/**
		 * Геттер X
		 */
		public function get x():int
		{
			return _globalPosition.x;
		}
		
		/**
		 * Сеттер Y
		 */
		public function set y(val:int):void
		{
			_globalPosition.y = val;
		}
		
		/**
		 * Геттер Y
		 */
		public function get y():int
		{
			return _globalPosition.y;
		}
		
		/**
		 * Геттер X в глобальной системе коррдинат
		 */
		public function get globalX():int
		{
			if (_spriteRect != null)
			{
				return _spriteRect.left;
			}
			else
			{
				return x;
			}
		
		}
		
		/**
		 * Геттер Y в глобальной системе коррдинат
		 */
		public function get globalY():int
		{
			if (_spriteRect != null)
			{
				return _spriteRect.top;
			}
			else
			{
				return y;
			}
		
		}
		
		public function get width():uint
		{
			return _spriteWidth;
		}
		
		public function get height():uint
		{
			return _spriteHeight;
		}
		
		public function set rotation(val:Number):void
		{
			_angle = val;
		}
		
		public function get rotation():Number
		{
			return _angle;
		}
		
		public function set scale(val:Number):void
		{
			_scaleX = val;
			_scaleY = val;
		}
		
		public function get scale():Number
		{
			return _scaleX;
		}
		
		
		public function set alpha(val:Number):void
		{
			colorTransform.alphaMultiplier = val;
		}
		
		public function get alpha():Number
		{
			return colorTransform.alphaMultiplier;
		}
		
		public function get Rect():Rectangle
		{
			_spriteRect.width = _spriteWidth;
			_spriteRect.height = _spriteHeight;
			return _spriteRect;
		}
		
		public function get totalFrames():uint
		{
			return _frames.length;
		}
		
		public function set currentFrame(val:uint):void
		{
			if (val < totalFrames)
			{
				_currentFrame = val;
			}
		}
		
		public function get currentFrame():uint
		{
			return Math.floor(_currentFrame);
		}
		
		public function set outside(val:Boolean):void
		{
			return;
		}
		
		public function get outside():Boolean
		{
			return false;
		}
		
		public function get isPlaying():Boolean {
			return _playing;
		}
		
		/**
		 * Геттер матрицы преобразования
		 */
		public function get Translations():Matrix
		{
			return _matrix;
		}
		
		/**
		 * Начать воспроизведение анимации
		 */
		public function Play():void
		{
			_playing = true;
		}
		
		/**
		 * Остановить воспроизведение анимации
		 */
		public function Stop():void
		{
			_playing = false;
		}
		
		/**
		 * Задать регион анимации
		 *
		 * @param	frameStart Начальный кадр
		 * @param	frameEnd Конечный кадр
		 */
		public function SetAnimationRegion(frameStart:uint, frameEnd:uint):void
		{
			_minFrame = frameStart;
			_maxFrame = frameEnd;
		}
		
		/**
		 * Задать изначальный регион анимации
		 * От первого до последнего кадра
		 */
		public function ResetAnimationRegion():void
		{
			_minFrame = 0;
			_maxFrame = _frames.length - 1;
		}
		
		/**
		 * Вызывается при окончании анимации. Абстрактный метод
		 */
		public function AnimationFinished():void
		{
		
		}
		
		/**
		 * Прорисовка результата на указанной поверхности
		 *
		 * @return
		 */
		public function Draw(surface:BitmapData, inmatrix:Matrix = null):void
		{
			// Обнуляем матрицу
			_matrix.identity();
			
			// Если надо, отражаем по горизонтали
			if (_flipHorizontal) {
				_matrix.scale( -1, 1);
				_matrix.translate(_spriteWidth, 0);
			}
			
			if (_flipVertical) {
				_matrix.scale(1, -1);
				_matrix.translate(0, _spriteHeight);
			}
			
			
			// Перемещаем так, чтобы центр спрайта оказался в нулевой точке
			_matrix.translate(-_centerPoint.x, -_centerPoint.y);
			
			// Если нужно, поворациваем
			if (_angle != 0)
			{
				_matrix.rotate(_angle);
			}
			
			// Если нужно, изменяем размеры
			if ((_scaleX != 1) || (_scaleY != 1))
			{
				_matrix.scale(_scaleX, _scaleY);
			}
			
			// Перемещаем в нужное место
			_matrix.translate(_globalPosition.x, _globalPosition.y);
			
			// Если анимированный спрайт, анимируем
			
			
			// Если есть матрица в параметре, приплюсовываем
			if (inmatrix != null)
			{
				_matrix.concat(inmatrix);
			}
			
			// Рисуем
			if (_current_bitmap is IBitmapDrawable)
			{
				surface.draw(_current_bitmap, _matrix, colorTransform, null, null, true);
			}
			
			_spriteRect.left = _matrix.tx;
			_spriteRect.top = _matrix.ty;
		}
		
		public function onMouseIn():void
		{
		
		}
		
		public function onMouseOver():void
		{
		
		}
		
		public function onMouseOut():void
		{
		
		}
		
		public function onMouseDown():void
		{
		}
		
		public function onMouseUp():void
		{
		
		}
		
		/**
		 * Двигать
		 */
		public function Move():void
		{
			if (_animated)
			{
				_current_bitmap = _frames[Math.floor(_currentFrame)];
				
				if (_playing)
				{
					_currentFrame += _frameRate;
					if (Math.floor(_currentFrame) > _maxFrame)
					{
						_currentFrame = _minFrame;
						AnimationFinished();
					}
				}
			}
		}
		
		/**
		 * Вызывается, когда объект пересекается с другим объектом.
		 * Вызывается только в случае, когда флаг CollisionEnabled выставлен в true
		 *
		 * @param	Intersects Объект с которым произошло столкновение
		 */
		public function Collision(Intersects:SpriteBase):void
		{
		}
		
		/**
		 * Вызывается после добавления в группу
		 */
		public function AddedToGroup():void {
			
		}
		
		public function set spriteBitmapData(val:BitmapData):void {
			_bitmap.bitmapData = val;
			_spriteRect.width = _bitmap.width;
			_spriteRect.height = _bitmap.height;
			
			if (_animated) {
				
			}else {
				_current_bitmap = val;
			}
		}
		
		public function get spriteBitmapData():BitmapData {
			return _bitmap.bitmapData;
		}
		
		/**
		 * Конструктор спрайта
		 *
		 * @param	spriteBmp		Битмэп для спрайта
		 * @param	rotationCenter	Нулевая точка спрайта. Вокруг нее будет происходить вращение.
		 * @param	animated		Является ли спрайт анимированным
		 * @param	frameWidth		Ширина кадра
		 * @param	frameHeight		Высота кадра
		 * @param	frameRate		Скорость анимации, доля от заданного FPS. Например если частота кадров у SWF 60, то 1/2 или 0.5 это 30 кадров анимации за 60 кадров SWF
		 */
		public function SpriteBase(spriteBmp:Bitmap, rotationCenter:Point = null, animated:Boolean = false, frameWidth:uint = 0, frameHeight:uint = 0, frameRate:Number = 1)
		{
			if (spriteBmp == null)
			{
				spriteBmp = new Bitmap();
			}
			else
			{
				if (!(spriteBmp is Bitmap))
				{
					throw new Error('spriteBmp не является Bitmap, а является ' + typeof(spriteBmp));
					return;
				}
			}
			
			_bitmap = spriteBmp;
			_matrix = new Matrix();
			
			if (rotationCenter == null)
			{
				_centerPoint = new Point(0, 0);
			}
			else
			{
				_centerPoint = rotationCenter;
			}
			
			_animated = animated;
			
			if (animated)
			{
				_spriteWidth = frameWidth;
				_spriteHeight = frameHeight;
				_frameRate = frameRate;
				
				_frames = new Array();
				
				for (var j:uint = 0; j < Math.floor(_bitmap.height / frameHeight); j++)
				{
					for (var i:uint = 0; i < Math.floor(_bitmap.width / frameWidth); i++)
					{
						var _frameData:BitmapData = new BitmapData(frameWidth, frameHeight);
						_frameData.copyPixels(_bitmap.bitmapData, new Rectangle(i * frameWidth, j * frameHeight, frameWidth, frameHeight), new Point(0, 0));
						_frames[_frames.length] = _frameData;
					}
				}
				
				ResetAnimationRegion();
				_current_bitmap = _frames[0];
			}
			else
			{
				_spriteWidth = _bitmap.width;
				_spriteHeight = _bitmap.height;
				_current_bitmap = _bitmap.bitmapData;
			}
			
			_spriteRect = new Rectangle(0, 0, _spriteWidth, _spriteHeight);
		}
	
	}

}