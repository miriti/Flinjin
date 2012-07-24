package flinjin.graphics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flinjin.algorithms.collisions.CollisionDetection;
	import flinjin.events.FlinjinEvent;
	import flinjin.events.FlinjinSpriteEvent;
	import flinjin.FlinjinLog;
	import flinjin.system.FlinjinError;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class Layer extends Sprite
	{
		private var _collisionsAlgorithm:CollisionDetection;
		private var _nextSpriteZIndex:Number;
		
		/** scale of the inside components **/
		protected var _contentScale:Number = 1;
		
		/** Layer boundings */
		protected var _layerRect:Rectangle = new Rectangle();
		protected var _layerShift:Point = new Point();
		
		/** List of the Leyer's sprites **/
		protected var _sprites:Vector.<Sprite> = new Vector.<Sprite>;
		
		/** Enable clipping of the layer by it's rect **/
		public var EnableClip:Boolean = false;
		
		/** Backgroung filling of the Layer **/
		public var FillColor:uint = 0x00000000;
		
		override public function Dispose():void
		{
			for (var i:int = 0; i < Sprites.length; i++)
			{
				Sprites[i].Dispose();
			}
			super.Dispose();
		}
		
		/**
		 * Sets the algorithm to compute sprites collisions
		 *
		 * @param	collAlg
		 */
		public function setCollisionsAlgorithm(collAlg:CollisionDetection):void
		{
			if (collAlg != null)
			{
				_collisionsAlgorithm = collAlg;
			}
			else
			{
				_collisionsAlgorithm = null;
			}
		}
		
		public function setColorMults(r:Number = 1, g:Number = 1, b:Number = 1):void
		{
			colorTransform.redMultiplier = r;
			colorTransform.greenMultiplier = g;
			colorTransform.blueMultiplier = b;
		}
		
		/**
		 * Delete specified sprite
		 *
		 * @param	spriteToDelete Object of sprite or Index in list
		 * @return
		 */
		public function deleteSprite(spriteToDelete:Sprite):Boolean
		{
			var _itemIndex:int = _sprites.indexOf(spriteToDelete);
			
			if (_itemIndex != -1)
			{
				_sprites.splice(_itemIndex, 1);
				if (_collisionsAlgorithm != null)
				{
					_collisionsAlgorithm.RemoveFromCollection(spriteToDelete);
				}
				spriteToDelete.dispatchEvent(new FlinjinSpriteEvent(FlinjinSpriteEvent.REMOVED_FROM_LAYER, this));
				return true;
			}
			else
			{
				FlinjinLog.l(spriteToDelete + " is not added to " + this, FlinjinLog.W_WARN);
				return false;
			}
		
		}
		
		/**
		 * Adding new sprite to Flinjin display list
		 *
		 * @param	newSprite	flinjin.graphics.Sprite or it's child object
		 * @param	atX			X position on the layer to put new sprite
		 * @param	atY			Y position on the layer to put new sprite
		 * @param	atZIndex	ZIndex for the new sprite
		 */
		public function addSprite(newSprite:Sprite, atX:Object = null, atY:Object = null, atZIndex:Object = null):void
		{
			if (newSprite is Sprite)
			{
				if (_sprites.indexOf(newSprite) == -1)
				{
					if (newSprite.zIndex == 0)
					{
						if (atZIndex != null)
							newSprite.zIndex = (atZIndex as Number);
						else
						{
							newSprite.zIndex = _nextSpriteZIndex;
							_nextSpriteZIndex++;
						}
					}
					newSprite.setPosition((atX != null) && (atX is Number) ? (atX as Number) : newSprite.x, (atY != null) && (atY is Number) ? (atY as Number) : newSprite.y);
					Sprites[Sprites.length] = newSprite;
					if (_collisionsAlgorithm != null)
					{
						_collisionsAlgorithm.AddToCollection(newSprite);
					}
					newSprite.dispatchEvent(new FlinjinSpriteEvent(FlinjinSpriteEvent.ADDED_TO_LAYER, this));
				}
				else
				{
					FlinjinLog.l("This sprite <" + newSprite.toString() + "> is already in the layer's <" + this.toString() + "> list");
				}
			}
			else
			{
				throw new FlinjinError("You can add only flinjin.graphics.Sprite objects to Layer");
			}
		}
		
		/**
		 * Adding array of new sprites
		 *
		 * @param	newSpritesArray
		 */
		public function addSprites(newSpritesArray:Array):void
		{
			for (var i:int = 0; i < newSpritesArray.length; i++)
			{
				addSprite(newSpritesArray[i]);
			}
		}
		
		public function resetDefaultZIndex():Number
		{
			_nextSpriteZIndex = 1;
			return _nextSpriteZIndex;
		}
		
		public function get shiftX():Number
		{
			return _layerShift.x;
		}
		
		public function set shiftX(value:Number):void
		{
			_layerShift.x = value;
		}
		
		public function get shiftY():Number
		{
			return _layerShift.y;
		}
		
		public function set shiftY(value:Number):void
		{
			_layerShift.y = value;
		}
		
		/**
		 * X
		 */
		override public function get x():Number
		{
			return super.x;
		}
		
		override public function set x(value:Number):void
		{
			_layerRect.x = value;
			super.x = value;
		}
		
		/**
		 * Y
		 */
		override public function get y():Number
		{
			return super.y;
		}
		
		override public function set y(value:Number):void
		{
			_layerRect.y = value;
			super.y = value;
		}
		
		/**
		 * WIDTH
		 */
		override public function get width():Number
		{
			return _layerRect.width;
		}
		
		override public function set width(value:Number):void
		{
			resetSize(value, _layerRect.height);
		}
		
		/**
		 * HEIGHT
		 */
		override public function get height():Number
		{
			return _layerRect.height;
		}
		
		override public function set height(value:Number):void
		{
			resetSize(_layerRect.width, value);
		}
		
		/**
		 * RECT
		 */
		override public function get rect():Rectangle
		{
			// TODO Warning: possible memory leak, and also this code is fucked up
			return new Rectangle(_layerRect.x - _center.x, _layerRect.y - _center.y, _layerRect.width, _layerRect.height);
		}
		
		public function get collisionsAlgorithm():CollisionDetection
		{
			return _collisionsAlgorithm;
		}
		
		public function get Sprites():Vector.<Sprite>
		{
			return _sprites;
		}
		
		public function get contentScale():Number
		{
			return _contentScale;
		}
		
		public function set contentScale(value:Number):void
		{
			_contentScale = value;
		}
		
		/**
		 * Delete all sprites
		 *
		 */
		public function clear():void
		{
			for (var i:int = _sprites.length - 1; i >= 0; i--)
				deleteSprite(_sprites[i]);
		}
		
		/**
		 * Move all child sprites
		 *
		 */
		override public function Move(deltaTime:Number):void
		{
			for each (var eachSprite:Sprite in Sprites)
			{
				eachSprite.Move(deltaTime);
			}
			
			if (_collisionsAlgorithm != null)
				_collisionsAlgorithm.Run();
		}
		
		/**
		 * Mouse down on Layer
		 *
		 * @param	mousePos
		 */
		protected function onMouseEvent(e:MouseEvent):void
		{
			var mousePos:Point = new Point(e.localX * _scaleX, e.localY * _scaleY);
			var clickedSprites:Vector.<Sprite> = new Vector.<Sprite>;
			
			/**
			 * @todo use simple for here
			 */
			for each (var eachSprite:Sprite in _sprites)
			{
				if (eachSprite.interactive)
				{
					if (eachSprite.rect.containsPoint(mousePos))
					{
						if (eachSprite.pixelCheck)
						{
							if (eachSprite.lastDrawedBitmap.getPixel(e.localX - eachSprite.x, e.localY - eachSprite.y) != 0)
							{
								clickedSprites.push(eachSprite);
							}
						}
						else
						{
							clickedSprites.push(eachSprite);
						}
						
					}
				}
			}
			
			if (clickedSprites.length > 1)
			{
				clickedSprites = clickedSprites.sort(_spriteSortFunction);
			}
			
			/**
			 * Formating list of sprites under the mouse poiner while clicking.
			 * @todo Determine which sprites must dispatch this mouse event: topmost or all. Now it is only topmost
			 */
			if (1)
			{
				clickedSprites = clickedSprites.splice(clickedSprites.length - 1, 1);
			}
			
			for (var i:int = 0; i < clickedSprites.length; i++)
			{
				var subEvent:MouseEvent = e.clone() as MouseEvent;
				subEvent.localX -= clickedSprites[i].x;
				subEvent.localY -= clickedSprites[i].y;
				
				trace(clickedSprites, subEvent.type);
				
				clickedSprites[i].dispatchEvent(subEvent);
			}
		}
		
		/**
		 * Keyboard action on layer
		 *
		 * @param	e
		 */
		protected function onKeyboardEvent(e:KeyboardEvent):void
		{
			for each (var eachSprite:Sprite in Sprites)
			{
				eachSprite.dispatchEvent(e);
			}
		}
		
		/**
		 * Check if sprite is visible
		 *
		 * @param	sp
		 * @param	shift
		 * @return
		 */
		protected function _isSpriteVisible(sp:Sprite, shift:Point):Boolean
		{
			var sR:Rectangle = new Rectangle(sp.x + shift.x, sp.y + shift.y, sp.width, sp.height);
			return rect.intersects(sR);
		}
		
		/**
		 *
		 * @param	newWidth
		 * @param	newHeight
		 */
		protected function resetSize(newWidth:uint, newHeight:uint):void
		{
			if ((newWidth != width) || (newHeight != height))
			{
				if (_current_bitmap != null)
				{
					_current_bitmap.dispose();
				}
				_current_bitmap = new BitmapData(newWidth, newHeight, true, 0x00000000);
				
				_layerRect.width = newWidth;
				_layerRect.height = newHeight;
				
				for each (var eachSprite:Sprite in Sprites)
				{
					eachSprite.dispatchEvent(new FlinjinEvent(FlinjinEvent.LAYER_RESIZE));
				}
			}
		}
		
		/**
		 * Draw
		 *
		 * @param	surface
		 */
		override public function Draw(surface:BitmapData):void
		{
			if ((_current_bitmap != null) && (Sprites.length > 0))
			{
				_current_bitmap.fillRect(_current_bitmap.rect, FillColor);
				
				_prepareSprites();
				
				for (var i:int = _sprites.length - 1; i >= 0; i--)
				{
					var eachSprite:Sprite = _sprites[i];
					
					if (EnableClip)
					{
						if (_isSpriteVisible(eachSprite, _layerShift))
						{
							eachSprite.Draw(_current_bitmap);
						}
					}
					else
					{
						eachSprite.Draw(_current_bitmap);
					}
				}
				
				super.Draw(surface);
			}
		}
		
		/**
		 * Function for sorting sprites by zIndex value
		 *
		 * @param	cmp1
		 * @param	cmp2
		 * @return
		 */
		private function _spriteSortFunction(cmp1:Sprite, cmp2:Sprite):int
		{
			if (cmp1.zIndex < cmp2.zIndex)
			{
				return 1;
			}
			else if (cmp1.zIndex > cmp2.zIndex)
			{
				return -1;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * Preparing sprites to render.
		 * Deleting, culling, sorting etc.
		 *
		 */
		private function _prepareSprites():void
		{
			if (_sprites.length > 0)
			{
				// Sort sprites by zIndex
				if (_sprites.length >= 2)
				{
					_sprites = _sprites.sort(_spriteSortFunction);
				}
			}
		}
		
		/**
		 * New Layer Constructor
		 *
		 * @param	layerWidth
		 * @param	layerHeight
		 */
		public function Layer(layerWidth:uint, layerHeight:uint)
		{
			super(new Bitmap(new BitmapData(layerWidth, layerHeight, true, FillColor), "auto", Sprite.Smoothing));
			
			_layerRect.width = layerWidth;
			_layerRect.height = layerHeight;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
			addEventListener(MouseEvent.CLICK, onMouseEvent);
			addEventListener(MouseEvent.DOUBLE_CLICK, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseEvent);
			
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEvent);
			addEventListener(KeyboardEvent.KEY_UP, onKeyboardEvent);
			
			resetDefaultZIndex();
		}
	}

}