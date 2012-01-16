package flinjin.types
{
	import flinjin.system.FlinjinError;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class BoundingShape extends Object
	{
		public function CollisionTest(shape:BoundingShape):Boolean
		{
			if (!(shape is BoundingShape))
			{
				throw new FlinjinError("Unknown error");
			}
		}
	}

}