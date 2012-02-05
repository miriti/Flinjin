package flinjin.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class FlinjinEvent extends Event 
	{
		public static const ENGINE_STARTUP:String = "engineStartup";
		public static const LAYER_RESIZE:String = "layerResize";
		
		public function FlinjinEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);			
		}
		
	}

}