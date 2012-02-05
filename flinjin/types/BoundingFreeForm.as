package flinjin.types 
{
	import flinjin.graphics.Sprite;
	import flinjin.system.FlinjinError;
	
	/**
	 * ...
	 * @author 
	 */
	public class BoundingFreeForm extends BoundingShape 
	{
		public function BoundingFreeForm(toObj:Sprite, points:Array) 
		{
			super(toObj);
			
			if (points.length < 3) {
				throw new FlinjinError("Not enough points to build shape");
			}
		}
		
	}

}