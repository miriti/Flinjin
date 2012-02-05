package flinjin.motion
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flinjin.events.FlinjinMotionEvent;
	
	/**
	 * ...
	 * @author KEFIR
	 */
	public class Motion extends EventDispatcher
	{
		protected var _currentStep:int = 0;
		protected var _currentPoint:Point = new Point();
		protected var _duration:int;
		
		private var _startPoint:Point;
		private var _endPoint:Point;
		private var _vector:Point = new Point();
		private var _len:Number;
		
		protected function _update():void
		{
			_currentPoint.x = _startPoint.x + _vector.x * (_len * (_currentStep / _duration));
			_currentPoint.y = _startPoint.y + _vector.y * (_len * (_currentStep / _duration));
			_currentStep++;
		}
		
		public function Update():void
		{
			// TODO  fix it
			_update();
		}
		
		public function get finished():Boolean
		{
			return _currentStep == _duration;
		}
		
		/**
		 *
		 * @param	startPoint
		 * @param	endPoint
		 * @param	duration in steps
		 */
		public function Motion(startPoint:Point, endPoint:Point, duration:int)
		{
			if (startPoint != null)
			{
				_startPoint = startPoint.clone();
				_endPoint = endPoint.clone();
				_duration = duration;
				
				_vector.x = _endPoint.x - _startPoint.x;
				_vector.y = _endPoint.y - _startPoint.y;
				_len = _vector.length;
				_vector.normalize(1);
			}
		}
		
		public function reset():void
		{
			_currentStep = 0;
		}
		
		public function get currentPoint():Point
		{
			return _currentPoint;
		}
	
	}

}