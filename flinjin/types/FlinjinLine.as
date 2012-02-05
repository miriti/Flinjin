package flinjin.types
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FlinjinLine
	{
		private var _start:Point;
		private var _end:Point;
		
		public function FlinjinLine(lineStart:Point = null, lineEnd:Point = null)
		{
			if (lineStart != null)
			{
				start = lineStart.clone();
			}
			else
			{
				start = new Point(0, 0);
			}
			
			if (lineEnd != null)
			{
				end = lineEnd.clone();
			}
			else
			{
				end = new Point(0, 0);
			}
		}
		
		/**
		 *
		 * @param	surface
		 * @param	color
		 */
		public static function drawLine(line:FlinjinLine, surface:BitmapData, color:uint):void
		{
		}
		
		public function get vector():Point
		{
			return new Point(end.x - start.x, end.y - start.y);
		}
		
		/**
		 * Check for intersecttion with specified line
		 *
		 * @param	line
		 * @return
		 */
		public function intersects(line:FlinjinLine):Boolean
		{
			// TODO How??? RTFW! http://e-maxx.ru/algo/segments_intersection_checking
			return false;
		}
		
		/**
		 * Is point is a part of line
		 *
		 * @param	p
		 * @return
		 */
		public function isOnLine(p:Point):Boolean
		{
			var d1:Number = Math.abs(Point.distance(start, p));
			var d2:Number = Math.abs(Point.distance(end, p));
			
			return (d1 + d2 == lenght);
		}
		
		/**
		 * Returns rectangle projection on X axis
		 *
		 * @param	rect
		 */
		public function projectRectToX(rect:Rectangle):void
		{
			start.x = rect.x;
			start.y = 0;
			
			end.x = rect.x + rect.width;
			end.y = 0;
		}
		
		/**
		 * Returns rectangle projection on Y axis
		 *
		 * @param	rect
		 */
		public function projectRectToY(rect:Rectangle):void
		{
			start.x = 0;
			start.y = rect.y;
			
			end.x = 0;
			end.y = rect.y + rect.height;
		}
		
		public function get dx():Number
		{
			return end.x - start.x;
		}
		
		public function get dy():Number
		{
			return end.y - start.y;
		}
		
		public function get lenght():Number
		{
			return Math.abs(Point.distance(start, end));
		}
		
		public function set length(value:Number):void
		{
			var vect:Point = new Point(dx, dy);
			vect.normalize(1);
			vect.x *= value;
			vect.y *= value;
			end = start.add(vect);
		}
		
		public function get start():Point
		{
			return _start;
		}
		
		public function set start(value:Point):void
		{
			_start = value;
		}
		
		public function get end():Point
		{
			return _end;
		}
		
		public function set end(value:Point):void
		{
			_end = value;
		}
	
	}

}