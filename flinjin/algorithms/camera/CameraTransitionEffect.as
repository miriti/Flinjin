package flinjin.algorithms.camera
{
	import flash.display.BitmapData;
	import flinjin.graphics.FjLayer;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class CameraTransitionEffect
	{
		protected var _sceneFrom:FjLayer;
		protected var _sceneTo:FjLayer;
		protected var _finished:Boolean = false;
		
		public function start():void
		{
			//
		}
		
		public function stop():void
		{
			//
		}
		
		public function pauser():void
		{
			//
		}
		
		public function render(surface:BitmapData):void
		{
			//
		}
		
		public function update(timeDelta:Number):void
		{
			// 
		}
		
		public function CameraTransitionEffect()
		{
		
		}
		
		public function get sceneTo():FjLayer
		{
			return _sceneTo;
		}
		
		public function set sceneTo(value:FjLayer):void
		{
			_sceneTo = value;
		}
		
		public function get sceneFrom():FjLayer
		{
			return _sceneFrom;
		}
		
		public function set sceneFrom(value:FjLayer):void
		{
			_sceneFrom = value;
		}
		
		public function get finished():Boolean 
		{
			return _finished;
		}
	
	}

}