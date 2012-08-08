package flinjin.algorithms.collisions
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flinjin.events.FlinjinCollisionEvent;
	import flinjin.graphics.FjSprite;
	import flinjin.system.FlinjinError;
	import flinjin.types.BoundingCircle;
	import flinjin.types.BoundingPoint;
	import flinjin.types.BoundingRect;
	import flinjin.types.BoundingShape;
	import flinjin.types.FlinjinLine;
	import flinjin.types.FlinjinVector;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class CollisionDetection
	{
		
		/**
		 * Test intersection between two Rects
		 *
		 * @param	sh1
		 * @param	sh2
		 * @return
		 */
		private function _testRectRect(sh1:BoundingRect, sh2:BoundingRect):Boolean
		{
			var centerLenght:Point = new Point((sh2.x + sh2.shift.x) - (sh1.x + sh1.shift.x), (sh2.y + sh2.shift.y) - (sh1.y + sh1.shift.y));
			
			if ((Math.abs(centerLenght.x) < sh1.halfWidth + sh2.halfWidth) && (Math.abs(centerLenght.y) < sh1.halfHeight + sh2.halfHeight))
			{
				var resVector:FlinjinVector = new FlinjinVector();
				resVector.x = (sh1.halfWidth + sh2.halfWidth) - Math.abs(centerLenght.x);
				resVector.y = (sh1.halfHeight + sh2.halfHeight) - Math.abs(centerLenght.y);
				
				// TODO Stupid code. fix it
				if (sh1.x < sh2.x)
					resVector.x *= -1;
				
				if (sh1.y < sh2.y)
					resVector.y *= -1;
				
				if (Math.abs(resVector.x) < Math.abs(resVector.y))
				{
					resVector.y = 0;
				}
				else
				{
					resVector.x = 0;
				}
				
				sh1.connectedObject.dispatchEvent(new FlinjinCollisionEvent(FlinjinCollisionEvent.COLLISION, sh2.connectedObject, resVector));
				sh2.connectedObject.dispatchEvent(new FlinjinCollisionEvent(FlinjinCollisionEvent.COLLISION, sh2.connectedObject, resVector.flip()));
			}
			
			return false;
		}
		
		/**
		 * Test intersection between Circle and Rect
		 *
		 * @param	sh1
		 * @param	sh2
		 * @return
		 */
		private function _testCircleRect(sh1:BoundingCircle, sh2:BoundingRect):Boolean
		{
			// TODO test collision between circle and rect
			return false;
		}
		
		/**
		 * Test intersection between two circles
		 *
		 * @param	sh1
		 * @param	sh2
		 * @return
		 */
		private function _testCircleCircle(sh1:BoundingCircle, sh2:BoundingCircle):Boolean
		{
			var catethSumm:Number = ((sh2.x - sh1.x) * (sh2.x - sh1.x)) + ((sh2.y - sh1.y) * (sh2.y - sh1.y));
			var l:Number = Point.distance(sh1.position, sh2.position);
			
			if (l < sh1.radius + sh2.radius)
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * Test intersection between two shapes
		 *
		 * @param	shape1
		 * @param	shape2
		 * @return
		 */
		private function testShapeIntersection(shape1:Object, shape2:Object):Boolean
		{
			// TODO It must be another way 
			if (shape1 is BoundingCircle)
			{
				if (shape2 is BoundingCircle)
				{
					return _testCircleCircle((shape1 as BoundingCircle), (shape2 as BoundingCircle));
				}
				else if (shape2 is BoundingRect)
				{
					return _testCircleRect((shape1 as BoundingCircle), (shape2 as BoundingRect));
				}
			}
			else if (shape1 is BoundingRect)
			{
				if (shape2 is BoundingCircle)
				{
					return _testCircleRect((shape2 as BoundingCircle), (shape1 as BoundingRect));
				}
				else if (shape2 is BoundingRect)
				{
					return _testRectRect((shape2 as BoundingRect), (shape1 as BoundingRect));
				}
			}
			
			return false;
		}
		
		/**
		 * Test collision between two sprites
		 *
		 * @param	sp1
		 * @param	sp2
		 * @return
		 */
		public function CollisionTest(sp1:FjSprite, sp2:FjSprite):Boolean
		{
			if (sp1 == sp2)
			{
				throw new FlinjinError("Can not collide sprite to itself");
				return false;
			}
			
			if ((sp1.collisionShape != null) && (sp2.collisionShape != null))
			{
				if (sp1.moved || sp2.moved)
				{
					return sp1.collisionShape.CollisionTest(sp2.collisionShape);
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
		
		public function FindCollision(toSprite:FjSprite):Boolean
		{
			return false;
		}
		
		public function DebugDraw(surface:BitmapData, shiftVector:Point):void
		{
		
		}
		
		public function RemoveFromCollection(obj:FjSprite):void
		{
		}
		
		public function AddToCollection(obj:FjSprite):void
		{
		}
		
		public function ImportCollection(importedCollection:*):void
		{
		}
		
		public function Run():void
		{
		}
		
		public function CollisionDetection()
		{
		}
	}

}