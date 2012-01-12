package flinjin.events
{
	import flash.events.Event;
	import flinjin.graphics.Sprite;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class FlinjinSpriteEvent extends Event
	{
		public static const ANIMATION_FINISHED:String = "animationFinished";
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
		public static const COLLISION:String = "spriteCollision";
		public static const COLLISION_FINISHED:String = "spriteCollisionFinished";
		public static const NO_COLLISIONS:String = "noCollisions";
		
		public var interactionSprite:Sprite = null;
		
		public function FlinjinSpriteEvent(type:String, interactionSprite:Sprite = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.interactionSprite = interactionSprite;
		}
	
	}

}