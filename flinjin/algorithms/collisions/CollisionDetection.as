package flinjin.algorithms.collisions
{
	import flinjin.graphics.Sprite;
	import flinjin.system.FlinjinError;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class CollisionDetection
	{
		public static final const TYPE_RECTANGLE:uint = 0;
		public static final const TYPE_CIRCLE:uint = 1;
		
		private function testShapeIntersection(shape1:Object, shape2:Object):void {
			
		}
		
		public function CollisionTest(sp1:Sprite, sp2:Sprite):Boolean {
			if (sp1 == sp2) {
				throw new FlinjinError("Can not collide one sprite to itself");
				return false;
			}
			
			
			
		}
		
		public function RemoveFromCollection(obj:Sprite):void;
		public function AddToCollection(obj:Sprite):void;
		public function Run():void;
		public function CollisionDetection();
	}

}