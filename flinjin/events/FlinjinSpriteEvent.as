package flinjin.events
{
	import flash.events.Event;
	import flinjin.graphics.FjSprite;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class FlinjinSpriteEvent extends Event
	{
		/**
		 * Triggers when last animation frame has been riched
		 * 
		 */
		public static const ANIMATION_FINISHED:String = "animationFinished";
		
		/**
		 * Triggers before render of sprite started
		 * 
		 */
		public static const BEFORE_RENDER:String = "beforeRender";
		public static const AFTER_RENDER:String = "afterRender";
		public static const BEFORE_MOVE:String = "beforeMove";
		public static const AFTER_MOVE:String = "afterMove";
		public static const MOVE:String = FlinjinSpriteEvent.BEFORE_MOVE;
		public static const UPDATE:String = FlinjinSpriteEvent.BEFORE_MOVE;
		public static const DRAW:String = FlinjinSpriteEvent.BEFORE_RENDER;
		public static const RENDER:String = FlinjinSpriteEvent.BEFORE_RENDER;
		public static const ADDED_TO_LAYER:String = "addedToLayer";
		public static const REMOVED_FROM_LAYER:String = "removedFromLayer";
		
		public var interactionSprite:FjSprite = null;
		
		public function FlinjinSpriteEvent(type:String, interactionSprite:FjSprite = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.interactionSprite = interactionSprite;
		}
	
	}

}