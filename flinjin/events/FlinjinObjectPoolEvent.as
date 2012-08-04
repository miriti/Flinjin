package flinjin.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class FlinjinObjectPoolEvent extends Event 
	{
		static public const RESTORE:String = "restore";
		
		public function FlinjinObjectPoolEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}

}