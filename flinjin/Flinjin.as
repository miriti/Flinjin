package flinjin
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flinjin.events.FlinjinEvent;
	import flinjin.graphics.Layer;
	import flinjin.graphics.Render;
	import flinjin.input.Input;
	
	/**
	 * Flinjin application base class
	 *
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class Flinjin extends Sprite
	{
		// Main rendering unit
		public var Screen:Render;
		
		// Rendering region
		private var _regionRect:Rectangle = null;
		
		// Debug state
		public static var Debug:Boolean = false;
		
		override public function get width():Number {
			return _regionRect.width;
		}
		
		override public function get height():Number {
			return _regionRect.height;
		}
		
		public function addToMainLayer(newObject:flinjin.graphics.Sprite):void {
			Screen.MainLayer.addSprite(newObject);
		}
		
		/**
		 * Overriding current main layer
		 * @param	newLayer
		 */
		public function setMainLayer(newLayer:Layer):void {
			Screen.MainLayer = newLayer;
		}
		
		/**
		 * Added to stage event
		 * @param	e
		 */
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			if (_regionRect == null) {
				regionRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			}
			
			Screen = new Render(_regionRect.width, _regionRect.height, 0x000000);
			addChild(Screen);
			
			x = _regionRect.left;
			y = _regionRect.top;
			
			dispatchEvent(new FlinjinEvent(FlinjinEvent.ENGINE_STARTUP, e.bubbles, e.cancelable));
		}
		
		public function get regionRect():Rectangle {
			return _regionRect;
		}
		
		public function set regionRect(newRegionRect:Rectangle):void {
			_regionRect = newRegionRect;
		}
		
		public function Flinjin()
		{
			focusRect = false;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
	}

}