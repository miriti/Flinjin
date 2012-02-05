package flinjin.events
{
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class FlinjinMotionEvent extends FlinjinEvent
	{
		public static const MOTION_FINISHED:String = "motionFinished";
		
		public function FlinjinMotionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	
	}

}