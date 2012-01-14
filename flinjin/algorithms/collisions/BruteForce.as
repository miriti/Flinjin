package flinjin.algorithms.collisions
{
	import flinjin.graphics.Sprite;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class BruteForce extends CollisionDetection
	{
		private var _Collection:Vector.<Sprite> = new Vector.<Sprite>;
		
		override public function AddToCollection(obj:Sprite):void
		{
			_Collection.push(obj);
		}
		
		override public function RemoveFromCollection(obj:Sprite):void
		{
			var indexOf:int = _Collection.indexOf(obj);
			
			if (indexOf != -1)
			{
				_Collection.splice(indexOf, 1);
			}
		}
		
		override public function Run():void
		{
			if (_Collection.length >= 2)
			{
				for (var i:int = 0; i < _Collection.length - 1; i++)
				{
					for (var j:int = i + 1; j < _Collection.length; j++)
					{
						
					}
				}
			}
		}
		
		public function BruteForce()
		{
		
		}
	
	}

}