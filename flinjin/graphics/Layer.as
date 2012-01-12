package flinjin.graphics
{
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flinjin.events.FlinjinSpriteEvent;
	import flinjin.system.FlinjinError;
	import game.mobs.PlayerMob;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class Layer extends Sprite
	{
		/** Buffer where all children sprites will be drawed in */
		protected var _buffer:BitmapData = null;
		
		/** Layer boundings */
		protected var _layerRect:Rectangle;
		
		/** List of the Leyer's sprites **/
		protected var Sprites:Array = new Array();
		
		
		/** Enable clipping of the layer by it's rect **/
		public var EnableClip:Boolean = false;
		
		/** Backgroung filling of the Layer **/
		public var FillColor:uint = 0x00000000;
		
		public var shift:Point = new Point(0, 0);
		
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
					var _last:Sprite = Sprites.pop();
					
					if (num != Sprites.length)
						Sprites[num] = _last;
					
					return true;
				}
				else
				{
					throw new FlinjinError("Index is out of range <" + spriteToDelete + ">");
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
		 * @param	newSprite
		 */
		public function addSprite(newSprite:Sprite, atX:Object = null, atY:Object = null):void
		{
			newSprite.setPosition((atX != null) && (atX is Number) ? (atX as Number) : newSprite.x, (atY != null) && (atY is Number) ? (atY as Number) : newSprite.y);
			Sprites[Sprites.length] = newSprite;
			newSprite.dispatchEvent(new FlinjinSpriteEvent(FlinjinSpriteEvent.ADDED_TO_LAYER, this));
		}
		
		override public function get x():Number
		{
			return super.x;
		}
		
		override public function set x(value:Number):void
		{
			_layerRect.x = value;
			super.x = value;
		}
		
		override public function get y():Number
		{
			return super.y;
		}
		
		override public function set y(value:Number):void
		{
			_layerRect.y = value;
			super.y = value;
		}
		
		override public function get width():Number
		{
			return _layerRect.width;
		}
		
		override public function set width(value:Number):void
		{
			_layerRect.width = value;
		}
		
		override public function get height():Number
		{
			return _layerRect.height;
		}
		
		override public function set height(value:Number):void
		{
			_layerRect.height = value;
		}
		
		override public function get rect():Rectangle
		{
			return _layerRect;
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
			dispatchEvent(new FlinjinSpriteEvent(FlinjinSpriteEvent.BEFORE_MOVE));
			
			for each (var eachSprite:Sprite in Sprites)
			{
				eachSprite.Move();
			}
			
			testSpritesCollisions();
			
			dispatchEvent(new FlinjinSpriteEvent(FlinjinSpriteEvent.AFTER_MOVE));
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
				// TODO Fucked up
				var _tmpRect:Rectangle = eachSprite.rect.clone();
				_tmpRect.x *= scale;
				_tmpRect.y *= scale;
				_tmpRect.width *= scale;
				_tmpRect.height *= scale;
				
				if (_tmpRect.containsPoint(mousePos))
				{
					var subEvent:MouseEvent = e.clone() as MouseEvent;
					subEvent.localX -= eachSprite.x;
					subEvent.localY -= eachSprite.y;
					
					eachSprite.dispatchEvent(subEvent);
				}
			}
		}
		
		private function onKeyboardEvent(e:KeyboardEvent):void
		{
			for each (var eachSprite:Sprite in Sprites)
			{
				eachSprite.dispatchEvent(e);
			}
		}
		
		protected function _isSpriteVisible(sp:Sprite, shift:Point):Boolean
		{
			var sR:Rectangle = new Rectangle(sp.x + shift.x, sp.y + shift.y, sp.width, sp.height);
			return rect.intersects(sR);
		}
		
		/**
		 * Draw
		 *
		 * @param	surface
		 */
		override public function Draw(surface:BitmapData, shiftVector:Point = null):void
		{
			dispatchEvent(new FlinjinSpriteEvent(FlinjinSpriteEvent.BEFORE_RENDER));
			if ((_buffer != null) && (Sprites.length > 0))
			{
				_buffer.fillRect(_buffer.rect, FillColor);
				
				_prepareSprites();
				
				/**
				 * @todo DRY here
				 *
				 */
				for each (var eachSprite:Sprite in Sprites)
				{
					if (EnableClip)
					{
						if (_isSpriteVisible(eachSprite, shift))
						{
							eachSprite.Draw(_buffer, shift);
						}
					}
					else
					{
						eachSprite.Draw(_buffer, shift);
					}
				}
				
				_current_bitmap = _buffer;
				super.Draw(surface, shiftVector);
			}
			dispatchEvent(new FlinjinSpriteEvent(FlinjinSpriteEvent.AFTER_RENDER));
		}
		
		protected function testSpritesCollisions():void
		{
			if (Sprites.length >= 2)
			{
				for (var i:int = 0; i < Sprites.length - 1; i++)
				{
					var sprite1:Sprite = Sprites[i];
					
					if (sprite1.CollisionEnabled)
					{
						for (var j:int = i + 1; j < Sprites.length; j++)
						{
							var sprite2:Sprite = Sprites[j];
							
							if (sprite2.CollisionEnabled)
							{
								if (_collisionTest(i, j))
								{
									sprite1.dispatchEvent(new FlinjinSpriteEvent(FlinjinSpriteEvent.COLLISION, sprite2));
									sprite2.dispatchEvent(new FlinjinSpriteEvent(FlinjinSpriteEvent.COLLISION, sprite1));
								}
							}
						}
					}
				}
			}
		}
		
		/**
		 * Test collission btween to sprite
		 *
		 * @param	spIndex1
		 * @param	spIndex2
		 * @return
		 */
		private function _collisionTest(spIndex1:int, spIndex2:int):Boolean
		{
			var sp1:Sprite = Sprites[spIndex1] as Sprite;
			var sp2:Sprite = Sprites[spIndex2] as Sprite;
			
			return sp1.collisionRect.intersects(sp2.collisionRect);
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
			super(null);
			
			if ((layerWidth != 0) && (layerHeight != 0))
			{
				_buffer = new BitmapData(layerWidth, layerHeight, true, 0x00000000);
				_layerRect = new Rectangle(0, 0, layerWidth, layerHeight);
			}
			else
			{
				throw new FlinjinError("Layer can not be zero size");
			}
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardEvent);
			addEventListener(KeyboardEvent.KEY_UP, onKeyboardEvent);
		}
	}

}