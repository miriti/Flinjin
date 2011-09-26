package BlitEngine
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SpriteGroup extends SpriteBase
	{
		public var Sprites:Array;
		
		public var zSorting:Boolean = true;
		public var CollisionCheck:Boolean = false;
		
		private var _matrix:Matrix = new Matrix();
		private var _clipRect:Rectangle = null;
		private var _nextZIndex:uint = 0;
		
		/**
		 * Функция сортировки по zIndex
		 * @param	a
		 * @param	b
		 * @return
		 */
		private function zIndexSortFunction(a:SpriteBase, b:SpriteBase):int
		{
			if (a.zIndex < b.zIndex)
			{
				return -1;
			}
			else if (a.zIndex > b.zIndex)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * Подготовка списка спрайтов для прорисовки
		 */
		public function prepareSprites():void
		{
			var i:int;
			var j:int;
			
			// Проверка столкновений
			if (CollisionCheck)
			{
				for (i = 0; i < Sprites.length - 1; i++)
				{
					var op1:SpriteBase = Sprites[i];
					
					if (!op1.CollisionEnabled)
					{
						continue;
					}
					
					for (j = 1; j < Sprites.length; j++)
					{
						
						var op2:SpriteBase = Sprites[j];
						
						if (!op2.CollisionEnabled)
						{
							continue;
						}
						
						if (op1.Rect.intersects(op2.Rect))
						{
							op1.Collision(op2);
							op2.Collision(op1);
						}
					}
				}
			}
			
			/** Удаление лишьних **/
			for (i = Sprites.length - 1; i >= 0; i--)
			{
				var current:SpriteBase = Sprites[i];
				
				if (current.Delete)
				{
					Sprites[i] = Sprites[Sprites.length - 1];
					Sprites.pop();
				}
			}
			
			/** Сортировка по zIndex **/
			if (zSorting)
			{
				Sprites.sort(zIndexSortFunction);
			}
		}
		
		/**
		 * Очистка списка спрайтов
		 */
		public function Clear():void {
			Sprites = new Array();
		}
		
		override public function Draw(surface:BitmapData, inmatrix:Matrix = null):void
		{
			_matrix.identity();
			if (inmatrix != null)
			{
				_matrix.concat(inmatrix);
			}
			
			_matrix.scale(scale, scale);
			_matrix.translate(x, y);
			
			prepareSprites();
			
			for (var i:int = 0; i < Sprites.length; i++)
			{
				var Current:SpriteBase = Sprites[i];
				Current.Draw(surface, _matrix);
				
				if (_clipRect != null)
				{
					if (Current.Rect != null)
					{
						if (!_clipRect.intersects(Current.Rect))
						{
							Current.outside = true;
						}
						else
						{
							Current.outside = false;
						}
					}
				}
			}
		}
		
		override public function Move():void
		{
			for (var i:int = 0; i < Sprites.length; i++)
			{
				SpriteBase(Sprites[i]).Move();
			}
		}
		
		override public function Play():void
		{
			for (var i:int = 0; i < Sprites.length; i++)
			{
				SpriteBase(Sprites[i]).Play();
			}
		}
		
		override public function get Rect():Rectangle
		{
			if (_clipRect == null)
			{
				_clipRect = new Rectangle(Number.MAX_VALUE, Number.MAX_VALUE);
				_clipRect.bottom = Number.MIN_VALUE;
				_clipRect.right = Number.MIN_VALUE;
				
				for (var i:uint = 0; i < Sprites.length; i++)
				{
					if (SpriteBase(Sprites[i]).Rect.left < _clipRect.left)
					{
						_clipRect.left = SpriteBase(Sprites[i]).Rect.left;
					}
					
					if (SpriteBase(Sprites[i]).Rect.top < _clipRect.top)
					{
						_clipRect.top = SpriteBase(Sprites[i]).Rect.top;
					}
					
					if (SpriteBase(Sprites[i]).Rect.right > _clipRect.right)
					{
						_clipRect.right = SpriteBase(Sprites[i]).Rect.right;
					}
					
					if (SpriteBase(Sprites[i]).Rect.bottom > _clipRect.bottom)
					{
						_clipRect.bottom = SpriteBase(Sprites[i]).Rect.bottom;
					}
				}
			}
			return _clipRect;
		}
		
		override public function get flipHorizontal():Boolean
		{
			return super.flipHorizontal;
		}
		
		override public function set flipHorizontal(value:Boolean):void
		{
			for (var i:int = 0; i < Sprites.length; i++) {
				if (SpriteBase(Sprites[i]).flipHorizontal) {
					SpriteBase(Sprites[i]).flipHorizontal = false;
				}else {
					SpriteBase(Sprites[i]).flipHorizontal = true;
				}
			}
			super.flipHorizontal = value;
		}
		
		override public function get flipVertical():Boolean
		{
			return super.flipVertical;
		}
		
		override public function set flipVertical(value:Boolean):void
		{
			for (var i:int = 0; i < Sprites.length; i++) {
				if (SpriteBase(Sprites[i]).flipVertical) {
					SpriteBase(Sprites[i]).flipVertical = false;
				}else {
					SpriteBase(Sprites[i]).flipVertical = true;
				}
			}
			
			super.flipVertical = value;
		}
		
		override public function get rotation():Number
		{
			return super.rotation;
		}
		
		override public function set rotation(value:Number):void
		{
			super.rotation = value;
		}
		
		override public function onMouseDown():void
		{
			for (var i:int = 0; i < Sprites.length; i++)
			{
				if (SpriteBase(Sprites[i]).Interactive)
				{
					if (SpriteBase(Sprites[i]).Rect.containsPoint(Input.mousePos))
					{
						SpriteBase(Sprites[i]).onMouseDown();
					}
				}
			}
		}
		
		override public function onMouseOver():void
		{
			for (var i:int = 0; i < Sprites.length; i++)
			{
				if (SpriteBase(Sprites[i]).Interactive)
				{
					// Мышь над спрайтом
					if (SpriteBase(Sprites[i]).Rect.containsPoint(Input.mousePos))
					{
						// Мышь еще не была над спрайтом
						if (!SpriteBase(Sprites[i]).MouseOver)
						{
							SpriteBase(Sprites[i]).onMouseIn();
							SpriteBase(Sprites[i]).MouseOver = true;
						}
						else
						{
							SpriteBase(Sprites[i]).onMouseOver();
						}
					}
					else
					{
						if (SpriteBase(Sprites[i]).MouseOver)
						{
							SpriteBase(Sprites[i]).onMouseOut();
							SpriteBase(Sprites[i]).MouseOver = false;
						}
					}
				}
			}
		}
		
		override public function onMouseOut():void
		{
			for (var i:uint = 0; i < Sprites.length; i++)
			{
				SpriteBase(Sprites[i]).onMouseOut();
			}
		}
		
		
		/**
		 * Возвращает количество спрайтов в группе.
		 * Рекурсивно для групп в группах
		 */
		public function get spriteCount():uint
		{
			var res:uint = 0;
			for (var i:uint = 0; i < Sprites.length; i++)
			{
				if (Sprites[i] is SpriteGroup)
				{
					res += SpriteGroup(Sprites[i]).spriteCount;
				}
				else
				{
					if (Sprites[i] is SpriteBase)
					{
						res++;
					}
				}
			}
			
			return res;
		}
		
		/**
		 * Добавление спрайта к списку
		 *
		 * @param	newSprite
		 * @param	newZIndex
		 */
		public function AddSprite(newSprite:SpriteBase, newZIndex:int = -1):void
		{
			Sprites[Sprites.length] = newSprite;
			newSprite.Group = this;
			
			if (newZIndex == -1) {
				newSprite.zIndex = _nextZIndex;
				_nextZIndex++;
			}else {
				newSprite.zIndex = newZIndex;
			}
			
			newSprite.AddedToGroup();
		}
		
		/**
		 * Установить область группы
		 *
		 *
		 * @param	clipRect
		 */
		public function SetClipRect(clipRect:Rectangle):void
		{
			_clipRect = clipRect;
		}
		
		public function SpriteGroup()
		{
			Sprites = new Array();
			super(null, null);
		}
	
	}

}