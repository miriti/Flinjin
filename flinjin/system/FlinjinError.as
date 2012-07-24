package flinjin.system 
{
	import flinjin.FlinjinLog;
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class FlinjinError extends Error 
	{
		
		public function FlinjinError(message:*="", id:*=0) 
		{
			super(message, id);
		}
		
	}

}