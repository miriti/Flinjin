package flinjin.motion
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author KEFIR
	 */
	public class Motion
	{
		private var _startPoint:Point;
		private var _endPoint:Point;
		private var _duration:Number;
		private var _currentPoint:Point;
		
		public function getCurrentPoint():Point {
			return _currentPoint;
		}
		
		public function Update():void {
			
		}
		
		public function Motion(startPoint:Point, endPoint:Point, duration:Number)
		{
			_startPoint = startPoint;
			_endPoint = endPoint;
		}
		
	}

}