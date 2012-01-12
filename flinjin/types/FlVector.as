package flinjin.types
{
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class FlVector
	{
		private var _x:Number;
		private var _y:Number;
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(val:Number):void
		{
			_x = val;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(val:Number):void
		{
			_y = val;
		}
		
		public function get lenght():Number
		{
			return Math.sqrt(x * x + y * y);
		}
		
		public function set length(val:Number):void
		{
			var d:Number = lenght / val;
			
			x = x * d;
			y = y * d;
		}
		
		public function toString():String
		{
			return "[FlVector x=[ " + x + " ] y=[ " + y + " ] lenght=[ " + lenght + " ]";
		}
		
		public function FlVector(vx:Number = 0, vy:Number = 0)
		{
			_x = vx;
			_y = vy;
		}
	
	}

}