package flinjin.graphics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flinjin.algorithms.collisions.BruteForce;
	import flinjin.algorithms.collisions.CollisionDetection;
	import flinjin.events.FlinjinEvent;
	import flinjin.events.FlinjinSpriteEvent;
	import flinjin.system.FlinjinError;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class Layer extends Sprite
	{
		private var _collisionsAlgorithm:CollisionDetection;
		
		/** scale of the inside components **/
		protected var _contentScale:Number = 1;
		
		/** Layer boundings */
		protected var _layerRect:Rectangle = new Rectangle();
		protected var _layerShift:Point = new Point();
		
		/** List of the Leyer's sprites **/
		protected var sprites:Vector.<Sprite> = new Vector.<Sprite>;
		
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
		public function deleteSprite(spriteToDelete:*):Boolean
		{
			if (spriteToDelete is Sprite)
			{
				var num:int = Sprites.indexOf(spriteToDelete);
				
				if (num != -1)
				{
					if (_collisionsAlgorithm != null)
					{
						_collisionsAlgorithm.RemoveFromCollection(Sprites[num]);
					}
					
					var _deleting:Sprite = Sprites[num];
					_deleting.Dispose();
					var _last:Sprite = Sprites.pop();
					
					if (num != Sprites.length)
						Sprites[num] = _last;					
					
					return true;
				}
				else
				{
					return false;
				}
			}
			else if (spriteToDelete is int)
			{
				if ((spriteToDelete >= 0) && (spriteToDelete < Sprites.length))
				{
					if (Sprites[spriteToDelete] is Layer)
						(Sprites[spriteToDelete] as Layer).Clear();
					
					if (spriteToDelete < Sprites.length - 1)
					{
						if (_collisionsAlgorithm != null)
						{
							_collisionsAlgorithm.RemoveFromCollection(Sprites[spriteToDelete]);
						}
						Sprites[spriteToDelete] = Sprites.pop();
					}
					else
					{
						Sprites.pop();
					}
					return true;
				}
				else
				{
					throw new FlinjinError("Index is out of range <" + spriteToDelete + ">");
				}
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * Adding new sprite to list
		 *
		 * @param	newSprite
		 */
		public function addSprite(newSprite:Sprite, atX:Object = null, atY:Object = null):void
		{
			newSprite.setPosition((atX != null) && (atX is Number) ? (atX as Number) : newSprite.x, (atY != null) && (atY is Number) ? (atY as Number) : newSprite.y);
			Sprites[Sprites.length] = newSprite;
			if (_collisionsAlgorithm != null)
			{
				_collisionsAlgorithm.AddToCollection(newSprite);
			}
			newSprite.dispatchEvent(new FlinjinSpriteEvent(FlinjinSpriteEvent.ADDED_TO_LAYER, this));
		}
		
		/**
		 * Adding array of new sprites
		 * 
		 * @param	newSpritesArray
		 */
		public function addSprites(newSpritesArray:Array):void {
			for (var i:int = 0; i < newSpritesArray.length; i++) 
			{
				addSprite(newSpritesArray[i]);
			}
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
			return _layerRect;
		}
		
		public function get collisionsAlgorithm():CollisionDetection
		{
			return _collisionsAlgorithm;
		}
		
		public function get Sprites():Vector.<Sprite>
		{
			return sprites;
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
		 * Delete all child sprites form this layer
		 *
		 */
		override public function Delete():void
		{
			for each (var eachSprite:Sprite in Sprites)
			{
				eachSprite.Delete();
			}
			super.Delete();
		}
		
		/**
		 * Delete all sprites
		 *
		 */
		public function Clear():void
		{
			for (var i:int = Sprites.length - 1; i >= 0; i--)
				deleteSprite(i);
		}
		
		/**
		 * Move all child sprites
		 *
		 */
		override public function Move():void
		{
			for each (var eachSprite:Sprite in Sprites)
			{
				eachSprite.Move();
			}
			
			if (_collisionsAlgorithm != null)
				_collisionsAlgorithm.Run();
		}
		
		/**
		 * Pause animation for all sprites
		 *
		 */
		override public function PauseAnimation():void
		{
			for each (var eachSprite:Sprite in Sprites)
			{
				eachSprite.PauseAnimation();
			}
		}
		
		/**
		 * Play animation for all sprites
		 *
		 */
		override public function PlayAnimation():void
		{
			for each (var eachSprite:Sprite in Sprites)
			{
				eachSprite.PlayAnimation();
			}
		}
		
		/**
		 * Stop animation for all sprites
		 *
		 */
		override public function StopAnimation():void
		{
			for each (var eachSprite:Sprite in Sprites)
			{
				eachSprite.StopAnimation();
			}
		}
		
		/**
		 * Set visibility of all sprites
		 *
		 * @param	toClass
		 * @param	val
		 */
		public function setVisibility(toClass:Class, val:Boolean):void
		{
			for (var i:int = 0; i < Sprites.length; i++)
			{
				if (Sprites[i] is toClass)
					Sprite(Sprites[i]).Visible = val;
			}
		}
		
		/**
		 * Mouse down on Layer
		 *
		 * @param	mousePos
		 */
		private function onMouseEvent(e:MouseEvent):void
		{
			var mousePos:Point = new Point(e.localX * _scaleX, e.localY * _scaleY);
			
			for each (var eachSprite:Sprite in Sprites)
			{
				var _tmpRect:Rectangle;
				
				// TODO Fucked up
				if (scale != 1)
				{
					_tmpRect = eachSprite.rect.clone();
					_tmpRect.x *= scale;
					_tmpRect.y *= scale;
					_tmpRect.width *= scale;
					_tmpRect.height *= scale;
				}
				else
				{
					_tmpRect = eachSprite.rect;
				}
				
				if (_tmpRect.containsPoint(mousePos))
				{
					var subEvent:MouseEvent = e.clone() as MouseEvent;
					subEvent.localX -= eachSprite.x;
					subEvent.localY -= eachSprite.y;
					
					eachSprite.dispatchEvent(subEvent);
				}
			}
		}
		
		/**
		 * Keyboard action on layer
		 *
		 * @param	e
		 */
		private function onKeyboardEvent(e:KeyboardEvent):void
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
		override public function Draw(surface:BitmapData, shiftVector:Point = null, innerScale:Number = 1):void
		{
			dispatchEvent(new FlinjinSpriteEvent(FlinjinSpriteEvent.BEFORE_RENDER));
			
			if ((_current_bitmap != null) && (Sprites.length > 0))
			{
				_current_bitmap.fillRect(_current_bitmap.rect, FillColor);
				
				_prepareSprites();
				
				/**
				 * @todo DRY here
				 *
				 */
				for each (var eachSprite:Sprite in Sprites)
				{
					if (EnableClip)
					{
						if (_isSpriteVisible(eachSprite, _layerShift))
						{
							eachSprite.Draw(_current_bitmap, _layerShift, _contentScale);
						}
					}
					else
					{
						eachSprite.Draw(_current_bitmap, _layerShift, _contentScale);
					}
				}
				
				super.Draw(surface, shiftVector, innerScale);
			}
			
			dispatchEvent(new FlinjinSpriteEvent(FlinjinSpriteEvent.AFTER_RENDER));
		}
		
		/**
		 * Preparing sprites to render.
		 * Deleting, culling, sorting etc.
		 *
		 */
		private function _prepareSprites():void
		{
			if (Sprites.length > 0)
			{
				for (var i:int = Sprites.length - 1; i > 0; i--)
				{
					if ((Sprites[i] as Sprite).DeleteFlag)
					{
						(Sprites[i] as Sprite).dispatchEvent(new FlinjinSpriteEvent(FlinjinSpriteEvent.REMOVED_FROM_LAYER, this));
						Sprites[i] = Sprites.pop();
					}
				}
				
				if (Sprites.length >= 2)
				{
					// TODO sort by zIndex
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
			super(new Bitmap(new BitmapData(layerWidth, layerHeight, true, 0x00000000), "auto", Sprite.Smoothing));
			//resetSize(layerWidth, layerHeight);
			
			_layerRect.width = layerWidth;
			_layerRect.height = layerHeight;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEvent);
			addEventListener(KeyboardEvent.KEY_UP, onKeyboardEvent);
		}
	}

}