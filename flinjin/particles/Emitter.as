package flinjin.particles 
{
	import flinjin.graphics.Sprite;
	
	/**
	 * ...
	 * @author 
	 */
	public class Emitter extends Sprite 
	{
		protected var _samples:Array;
		
		public function Emitter(samples:Array) 
		{
			_samples = samples;
		}
	}

}