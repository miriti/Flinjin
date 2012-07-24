package flinjin.types 
{
	import flinjin.graphics.FjSprite;
	import flinjin.system.FlinjinError;
	
	/**
	 * ...
	 * @author 
	 */
	public class BoundingFreeForm extends BoundingShape 
	{
		public function BoundingFreeForm(toObj:FjSprite, points:Array) 
		{
			super(toObj);
			
			if (points.length < 3) {
				throw new FlinjinError("Not enough points to build shape");
			}
		}
		
	}

}