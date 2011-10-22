package flinjin 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flinjin.graphics.Render;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class Flinjin extends Sprite 
	{
		// Main rendering unit
		public var Screen:Render;
		
		// Rendering region
		private var _regionRect:Rectangle = null;
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			if (_regionRect == null) {
				regionRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			}
			
			Screen = new Render(_regionRect.width, _regionRect.height);
			addChild(Screen);
			
			x = _regionRect.left;
			y = _regionRect.top;
			
			EngineStartup();
		}
		
		public function EngineStartup():void {
			
		}
		
		public function get regionRect():Rectangle {
			return _regionRect;
		}
		
		public function set regionRect(newRegionRect:Rectangle):void {
			_regionRect = newRegionRect;
		}
		
		public function Flinjin() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
	}

}