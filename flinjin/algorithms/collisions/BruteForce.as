package flinjin.algorithms.collisions
{
	import flinjin.graphics.Sprite;
	import flinjin.system.FlinjinError;
	
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
				_Collection = _Collection.splice(indexOf, 1);
			}
		}
		
		override public function FindCollision(toSprite:Sprite):Boolean
		{
			for (var i:int = 0; i < _Collection.length; i++)
			{
				if (_Collection[i] != toSprite)
				{
					CollisionTest(toSprite, _Collection[i]);
				}
			}
			
			return false;
		}
		
		override public function Run():void
		{
			if (_Collection.length >= 2)
			{
				for (var i:int = 0; i < _Collection.length - 1; i++)
				{
					for (var j:int = i + 1; j < _Collection.length; j++)
					{
						CollisionTest(_Collection[i], _Collection[j]);
					}
				}
			}
		}
		
		public function BruteForce()
		{
		
		}
	
	}

}