package flinjin.graphics 
{
	import flash.geom.Point;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author 
	 */
	public class Scene extends Layer 
	{
		private var _Camera:SceneCamera = new SceneCamera();
		
		/**
		 * Scene class
		 * 
		 * @param	layerWidth
		 * @param	layerHeight
		 */
		public function Scene(layerWidth:uint, layerHeight:uint) 
		{
			super(layerWidth, layerHeight);
			
		}
		
		public function parallaxSetup():void {
			
		}
		
		/**
		 * 
		 * @param	xmlData
		 */
		public function buildFromXML(xmlData:XML):void {
			// TODO build scene from xml
		}
		
		override protected function _Draw(surface:BitmapData, shiftVector:Point = null, innerScale:Number = 1):void 
		{
			super._Draw(surface, shiftVector, innerScale);
		}
		
		public function get Camera():SceneCamera 
		{
			return _Camera;
		}
	}

}
import flash.events.EventDispatcher;

class SceneCamera extends EventDispatcher {
	
}