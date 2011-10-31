package flinjin.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class FlinjinSpriteEvent extends Event 
	{
		public static const ANIMATION_FINISHED:String = "animationFinished";
		
		public function FlinjinSpriteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}

}