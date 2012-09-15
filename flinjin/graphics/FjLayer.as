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
	import flinjin.FjLog;
	import flinjin.system.FlinjinError;
	import Game.GameMain;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class FjLayer extends FjSprite
	{
		private var _collisionsAlgorithm:CollisionDetection;
		private var _nextSpriteZIndex:Number;
		private var _clickedSprites:Vector.<FjSprite> = new Vector.<FjSprite>;
		private var _mousePos:Point = new Point();
		
		/** scale of the inside components **/
		protected var _contentScale:Number = 1;
		
		/** Layer boundings */
		protected var _layerRect:Rectangle = new Rectangle();
		protected var _layerShift:Point = new Point();
		
		/** List of the Leyer's sprites **/
		protected var _sprites:Vector.<FjSprite> = new Vector.<FjSprite>;
		
		/** List of the Layer's interactive sprites **/
		protected var _spritesInteractive:Vector.<FjSprite> = new Vector.<FjSprite>;
		
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
		public function deleteSprite(spriteToDelete:FjSprite):Boolean
		{
			var _itemIndex:int = _sprites.indexOf(spriteToDelete);
			
			if (_itemIndex != -1)
			{
				_sprites.splice(_itemIndex, 1);
				if (_collisionsAlgorithm != null)
				{
					_collisionsAlgorithm.RemoveFromCollection(spriteToDelete);
				}
				
				if (spriteToDelete.interactive)
				{
					var interactiveIndex:int = _spritesInteractive.indexOf(spriteToDelete);
					if (interactiveIndex != -1)
					{
						_spritesInteractive.splice(interactiveIndex, 1);
					}
				}
				
				spriteToDelete.dispatchEvent(new FlinjinSpriteEvent(FlinjinSpriteEvent.REMOVED_FROM_LAYER, this));
				return true;
			}
			else
			{
				FjLog.l(spriteToDelete + " is not added to " + this, FjLog.W_WARN);
				return false;
			}
		
		}
		
		/**
		 * Adding new sprite to Flinjin display list
		 *
		 * @param	newSprite	flinjin.graphics.FjSprite or it's child object
		 * @param	atX			X position on the layer to put new sprite
		 * @param	atY			Y position on the layer to put new sprite
		 * @param	atZIndex	ZIndex for the new sprite
		 */
		public function addSprite(newSprite:FjSprite, atX:Object = null, atY:Object = null, atZIndex:Object = null):void
		{
			if (newSprite is FjSprite)
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
					_sprites[_sprites.length] = newSprite;
					
					if (newSprite.interactive)
						_spritesInteractive[_spritesInteractive.length] = newSprite;
					
					if (_collisionsAlgorithm != null)
					{
						_collisionsAlgorithm.AddToCollection(newSprite);
					}
					newSprite.dispatchEvent(new FlinjinSpriteEvent(FlinjinSpriteEvent.ADDED_TO_LAYER, this));
				}
				else
				{
					FjLog.l("This sprite <" + newSprite.toString() + "> is already in the layer's <" + this.toString() + "> list");
				}
			}
			else
			{
				throw new FlinjinError("You can add only flinjin.graphics.FjSprite objects to Layer");
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
		
		override public function mouseOver(localX:Number, localY:Number):void
		{
			super.mouseOver(localX, localY);
			for (var i:int = 0; i < _sprites.length; i++)
			{
				var _s:FjSprite = _sprites[i];
				if ((_s.rect.contains(localX, localY)) && (_s.interactive))
				{
					_s.mouseOver(localX - _s.x, localY - _s.y);
				}
				else if (_s.interactive)
					_s.mouseOut();
			}
		}
		
		override public function mouseOut():void
		{
			super.mouseOut();
			for (var i:int = 0; i < _sprites.length; i++)
			{
				_sprites[i].mouseOut();
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
		
		public function get Sprites():Vector.<FjSprite>
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
			for each (var eachSprite:FjSprite in Sprites)
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
			_mousePos.x = e.localX * _scaleX
			_mousePos.y = e.localY * _scaleY;
			_clickedSprites.splice(0, _clickedSprites.length);
			/**
			 * @todo use simple for here
			 */
			for each (var eachSprite:FjSprite in _spritesInteractive)
			{
				if ((eachSprite.visible) && (eachSprite.rect != null))
				{
					if (eachSprite.rect.containsPoint(_mousePos))
					{
						if (eachSprite.pixelCheck)
						{
							if (eachSprite.render.getPixel(e.localX - eachSprite.x, e.localY - eachSprite.y) != 0)
							{
								_clickedSprites.push(eachSprite);
							}
						}
						else
						{
							_clickedSprites.push(eachSprite);
						}
						
					}
				}
			}
			
			if (_clickedSprites.length > 1)
			{
				_clickedSprites = _clickedSprites.sort(_spriteSortFunction);
			}
			
			/**
			 * Formating list of sprites under the mouse poiner while clicking.
			 * @todo Determine which sprites must dispatch this mouse event: topmost or all. Now it is only topmost
			 */
			if (1)
			{
				_clickedSprites = _clickedSprites.splice(0, 1);
			}
			
			for (var i:int = 0; i < _clickedSprites.length; i++)
			{
				var subEvent:MouseEvent = e.clone() as MouseEvent;
				subEvent.localX -= _clickedSprites[i].x;
				subEvent.localY -= _clickedSprites[i].y;
				
				_clickedSprites[i].dispatchEvent(subEvent);
			}
		}
		
		/**
		 * Keyboard action on layer
		 *
		 * @param	e
		 */
		protected function onKeyboardEvent(e:KeyboardEvent):void
		{
			for each (var eachSprite:FjSprite in Sprites)
			{
				if (eachSprite.interactive)
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
		protected function _isSpriteVisible(sp:FjSprite):Boolean
		{
			var sR:Rectangle = new Rectangle(sp.x, sp.y, sp.width, sp.height);
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
				
				for each (var eachSprite:FjSprite in Sprites)
				{
					eachSprite.dispatchEvent(new FlinjinEvent(FlinjinEvent.LAYER_RESIZE));
				}
			}
		}
		
		override public function get render():BitmapData
		{
			if ((_current_bitmap != null) && (Sprites.length > 0))
			{
				var t:Date = new Date();
				
				_current_bitmap.fillRect(_current_bitmap.rect, FillColor);
				
				_prepareSprites();
				
				for (var i:int = _sprites.length - 1; i >= 0; i--)
				{
					var eachSprite:FjSprite = _sprites[i];
					if (eachSprite.visible)
					{
						var _render:BitmapData = eachSprite.render;
						
						if (null != _render)
						{
							if (FjSprite.DRAW_METHOD == 0)
								_current_bitmap.draw(_render, eachSprite.matrix, eachSprite.colorTransform, null, null, FjSprite.Smoothing);
							else if (FjSprite.DRAW_METHOD == 1) {								
								_current_bitmap.copyPixels(_render, _render.rect, new Point(eachSprite.x + eachSprite.center.x, eachSprite.y + eachSprite.center.y), _render);
							}
						}
					}
				}
				return _current_bitmap;
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * Function for sorting sprites by zIndex value
		 *
		 * @param	cmp1
		 * @param	cmp2
		 * @return
		 */
		private function _spriteSortFunction(cmp1:FjSprite, cmp2:FjSprite):int
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
		 * New FjLayer Constructor
		 *
		 * @param	layerWidth
		 * @param	layerHeight
		 */
		public function FjLayer(layerWidth:uint, layerHeight:uint)
		{
			super(new Bitmap(new BitmapData(layerWidth, layerHeight, true, FillColor), "auto", FjSprite.Smoothing));
			
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