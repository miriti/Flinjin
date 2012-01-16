package flinjin.types 
{
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class BoundingCircle extends BoundingShape 
	{
		private var _radius:Number;
		
		public function BoundingCircle(radius:Number) 
		{
			_radius = radius;
		}
		
		public function get radius():Number 
		{
			return _radius;
		}
		
		public function set radius(value:Number):void 
		{
			_radius = value;
		}
		
	}

}