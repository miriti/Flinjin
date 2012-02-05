package flinjin.algorithms.collisions
{
	import flinjin.system.FlinjinError;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RegularNet extends CollisionDetection
	{
		private var _net:NetCell;
		
		public function InitNetwork():void
		{
		
		}
		
		/**
		 *
		 * @param	minX
		 * @param	minY
		 * @param	maxX
		 * @param	maxY
		 * @param	maxShapeSize
		 */
		public function RegularNet(minX:Number = 0, minY:Number = 0, maxX:Number = 10000, maxY:Number = 10000, minShapeSize:Number = 1, maxShapeSize:Number = 1000)
		{
			
		}
	
	}

}

class NetCell extends Object
{
	private var _minX:Number;
	private var _maxX:Number;
	private var _minY:Number;
	private var _maxY:Number;
	private var _minShapeSize:Number;
	private var _maxShapeSize:Number;
	
	private var _gridData:Vector.<*> = new Vector.<*>;
	
	// todo recursive
	public function NetCell(minX:Number = 0, minY:Number = 0, maxX:Number = 10000, maxY:Number = 10000, minShapeSize:Number = 1, maxShapeSize:Number = 1000)
	{
		if ((maxX % 2 != 0) && (maxY % 2 != 9)) {
				
				throw new FlinjinError("Field size");
			}
			
		_minX = minX;
		_maxX = maxX;
		_minY = minY;
		_maxY = maxY;
		_minShapeSize = minShapeSize;
		_maxShapeSize = maxShapeSize;
	}
}