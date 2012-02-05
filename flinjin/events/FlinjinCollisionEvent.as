package flinjin.events 
{
	import flash.geom.Point;
	import flinjin.graphics.Sprite;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class FlinjinCollisionEvent extends FlinjinSpriteEvent 
	{
		public static const COLLISION:String = "collision";
		
		public var resolveVector:Point = new Point(0, 0);
		
		public function FlinjinCollisionEvent(type:String, interactionSprite:Sprite=null, resolveVector:Point=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, interactionSprite, bubbles, cancelable);
			
			if (resolveVector != null) {
				this.resolveVector = resolveVector;
			}
		}
		
	}

}