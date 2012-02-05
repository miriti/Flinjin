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
		
		public static var sceneWidth:Number;
		public static var sceneHeight:Number;
		
		override public function get width():Number
		{
			return _regionRect.width;
		}
		
		override public function get height():Number
		{
			return _regionRect.height;
		}
		
		public function addToMainLayer(newObject:flinjin.graphics.Sprite):void
		{
			Screen.MainLayer.addSprite(newObject);
		}
		
		/**
		 * Overriding current main layer
		 * @param	newLayer
		 */
		public function setMainLayer(newLayer:Layer):void
		{
			Screen.MainLayer = newLayer;
		}
		
		/**
		 * Added to stage event
		 * @param	e
		 */
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			if (_regionRect == null)
			{
				regionRect = new Rectangle(x, y, stage.stageWidth - x, stage.stageHeight - y);
			}
			
			Screen.setDemensions(_regionRect.width, _regionRect.height);
			
			addChild(Screen);
			
			stage.focus = Screen;
			
			x = _regionRect.left;
			y = _regionRect.top;
			
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			Flinjin.sceneWidth = stage.stageWidth;
			Flinjin.sceneHeight = stage.stageHeight;
			
			dispatchEvent(new FlinjinEvent(FlinjinEvent.ENGINE_STARTUP, e.bubbles, e.cancelable));
		}
		
		private function onStageResize(e:Event):void 
		{
			Screen.setDemensions(stage.stageWidth, stage.stageHeight);
			Screen.InitSurface();
		}
		
		public function get regionRect():Rectangle
		{
			return _regionRect;
		}
		
		public function set regionRect(newRegionRect:Rectangle):void
		{
			_regionRect = newRegionRect;
		}
		
		public function Flinjin()
		{
			Screen = new Render();
			
			focusRect = false;
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ACTIVATE, onActivate);
			addEventListener(Event.DEACTIVATE, onDeactivate);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void
		{
			stage.focus = Screen;
		}
		
		private function onActivate(e:Event):void
		{
			stage.focus = Screen;
		}
		
		private function onDeactivate(e:Event):void
		{
		}
	
	}

}