package flinjin.graphics
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flinjin.events.FlinjinEvent;
	import flinjin.events.FlinjinSpriteEvent;
	
	/**
	 * ...
	 * @author ...
	 */
	public class HUDSprite extends Sprite
	{
		protected var _alignLeft:Boolean;
		protected var _alignRight:Boolean;
		protected var _alignTop:Boolean;
		protected var _alignBottom:Boolean;
		
		public function HUDSprite(spriteBmp:Bitmap, rotationCenter:Point = null, animated:Boolean = false, frameWidth:uint = 0, frameHeight:uint = 0, frameRate:Number = 1)
		{
			super(spriteBmp, rotationCenter, animated, frameWidth, frameHeight, frameRate);
			addEventListener(FlinjinSpriteEvent.ADDED_TO_LAYER, onAddedToLayer);
			addEventListener(FlinjinEvent.LAYER_RESIZE, onLayerResize);
		}
		
		private function onLayerResize(e:FlinjinEvent):void
		{
		
		}
		
		private function onAddedToLayer(e:FlinjinSpriteEvent):void
		{
		
		}
		
		public function setClientAlign(clientAlign:Boolean = true):void
		{
			_alignBottom = clientAlign;
			_alignLeft = clientAlign;
			_alignRight = clientAlign;
			_alignTop = clientAlign;
		}
		
		public function get alignLeft():Boolean
		{
			return _alignLeft;
		}
		
		public function set alignLeft(value:Boolean):void
		{
			_alignLeft = value;
		}
		
		public function get alignRight():Boolean
		{
			return _alignRight;
		}
		
		public function set alignRight(value:Boolean):void
		{
			_alignRight = value;
		}
		
		public function get alignTop():Boolean
		{
			return _alignTop;
		}
		
		public function set alignTop(value:Boolean):void
		{
			_alignTop = value;
		}
		
		public function get alignBottom():Boolean
		{
			return _alignBottom;
		}
		
		public function set alignBottom(value:Boolean):void
		{
			_alignBottom = value;
		}
	
	}

}