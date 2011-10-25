package flinjin.graphics
{
	import flash.display.BitmapData;
	import flinjin.system.FlinjinError;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class Layer extends Sprite
	{
		// Buffer where all children sprites will be drawed in
		private var _buffer:BitmapData = null;
		
		// Children sprites collection
		public var Sprites:Array = new Array(); /** @todo Maybe we should use Vector here? **/
		
		/**
		 * Adding new sprite to list
		 * @param	newSprite
		 */
		public function addSprite(newSprite:Sprite):void {
			Sprites[Sprites.length] = newSprite;
		}
		
		/**
		 * Move all child sprites
		 */
		override public function Move():void 
		{
			for (var i:uint = 0; i < Sprites.length; i++) {
				(Sprites[i] as Sprite).Move();
			}
		}
		
		override public function PauseAnimation():void 
		{
			for (var i:uint = 0; i < Sprites.length; i++) {
				(Sprites[i] as Sprite).PauseAnimation();
			}
		}
		
		override public function PlayAnimation():void 
		{
			for (var i:uint = 0; i < Sprites.length; i++) {
				(Sprites[i] as Sprite).PlayAnimation();
			}
		}
		
		override public function StopAnimation():void 
		{
			for (var i:uint = 0; i < Sprites.length; i++) {
				(Sprites[i] as Sprite).StopAnimation();
			}
		}
		
		/**
		 * 
		 * @param	surface
		 */
		override public function Draw(surface:BitmapData):void
		{
			if ((_buffer != null) && (Sprites.length > 0))
			{				
				_buffer.fillRect(_buffer.rect, 0x00000000);
				
				for (var i:uint = 0; i < Sprites.length; i++) {
					(Sprites[i] as Sprite).Draw(_buffer);					
				}
				
				CurrentBitmap = _buffer;
				super.Draw(surface);
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
			
			if ((layerWidth != 0) && (layerHeight != 0)) {
				_buffer = new BitmapData(layerWidth, layerHeight, true, 0x00000000);				
			}else {
				throw new FlinjinError('Layer can not be zero size');				
			}			
		}
	}

}