package flinjin.algorithms.collisions
{
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class BoundingSphere
	{
		private var _radius:Number;
		
		public function BoundingSphere(r:Number)
		{
			_radius = r;
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