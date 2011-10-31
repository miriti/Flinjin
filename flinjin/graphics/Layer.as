package flinjin.graphics
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flinjin.system.FlinjinError;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class Layer extends Sprite
	{
		// Buffer where all children sprites will be drawed in
		private var _buffer:BitmapData = null;
		
		// Layer boundings
		private var _layerRect:Rectangle;
		
		// Children sprites collection
		public var Sprites:Array = new Array(); /** @todo Maybe we should use Vector here? **/
		
		/**
		 * Adding new sprite to list
		 * @param	newSprite
		 */
		public function addSprite(newSprite:Sprite):void
		{
			Sprites[Sprites.length] = newSprite;
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
		
		override public function get rect():Rectangle
		{
			return _layerRect;
		}
		
		override public function Delete():void 
		{
			for each (var eachSprite:Sprite in Sprites)
			{
				eachSprite.Delete();
			}
			super.Delete();
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
		 * Mouse down on Layer
		 *
		 * @param	mousePos
		 */
		private function onMouseEvent(e:MouseEvent):void
		{
			var mousePos:Point = new Point(e.localX, e.localY);
			
			for each (var eachSprite:Sprite in Sprites)
			{
				if (eachSprite.rect.containsPoint(mousePos))
				{
					var subEvent:MouseEvent = e.clone() as MouseEvent;
					subEvent.localX -= eachSprite.x;
					subEvent.localY -= eachSprite.y;
					
					eachSprite.dispatchEvent(subEvent);
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
			if ((_buffer != null) && (Sprites.length > 0))
			{
				_buffer.fillRect(_buffer.rect, 0x00000000);
				
				_prepareSprites();
				
				for (var i:uint = 0; i < Sprites.length; i++)
				{
					(Sprites[i] as Sprite).Draw(_buffer);
				}
				
				CurrentBitmap = _buffer;
				super.Draw(surface);
			}
		}
		
		/**
		 * Preparing sprites to render.
		 * Deleting, culling, sorting etc.
		 * 
		 */
		private function _prepareSprites():void {
			for (var i:uint = 0; i < Sprites.length; i++) {
				if ((Sprites[i] as Sprite).DeleteFlag) {
					Sprites[i] = Sprites.pop();
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
				throw new FlinjinError('Layer can not be zero size');
			}
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
		}
	}

}