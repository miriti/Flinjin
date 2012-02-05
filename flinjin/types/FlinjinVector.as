package flinjin.types
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class FlinjinVector extends Point
	{
		public static function angle(p1:Point, p2:Point):Number
		{
			var a:Number;
			
			var x1:Number = p2.x - p1.x;
			var y1:Number = p2.y - p1.y;
			
			if (x1 == 0)
			{
				if (y1 > 0)
				{
					a = 90;
				}
				if (y1 < 0)
				{
					a = 270;
				}
			}
			else
			{
				a = y1 / x1;
				a = Math.atan(a);
			}
			
			return a;
		}
		
		public function flip():Point
		{
			x *= -1;
			y *= -1;
			return this;
		}
		
		public function FlinjinVector(x:Number = 0, y:Number = 0)
		{
			super(x, y);
		}
	
	}

}