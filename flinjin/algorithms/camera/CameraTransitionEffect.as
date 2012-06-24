package flinjin.algorithms.camera
{
	import flash.display.BitmapData;
	import flinjin.graphics.Layer;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class CameraTransitionEffect
	{
		protected var _sceneFrom:Layer;
		protected var _sceneTo:Layer;
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
		
		public function get sceneTo():Layer
		{
			return _sceneTo;
		}
		
		public function set sceneTo(value:Layer):void
		{
			_sceneTo = value;
		}
		
		public function get sceneFrom():Layer
		{
			return _sceneFrom;
		}
		
		public function set sceneFrom(value:Layer):void
		{
			_sceneFrom = value;
		}
		
		public function get finished():Boolean 
		{
			return _finished;
		}
	
	}

}