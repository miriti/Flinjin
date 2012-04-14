package flinjin.motion
{
	import flash.geom.Point;
	import flinjin.events.FlinjinEvent;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class MotionChain extends Motion
	{
		private var _chain:Vector.<Motion> = new Vector.<Motion>;
		private var _currentChain:int = 0;
		
		public var loop:Boolean = false;
		
		override public function get currentPoint():Point
		{
			if (finished)
				return _chain[_chain.length - 1].currentPoint;
			else
				return _chain[_currentChain].currentPoint;
		}
		
		override public function get finished():Boolean
		{
			return _currentChain == _chain.length;
		}
		
		override protected function _update():void
		{
			// TODO fix it
			if (finished && loop)
			{
				_currentChain = 0;
				_chain[_currentChain].reset();
			}
			
			_chain[_currentChain].Update();
			
			if (_chain[_currentChain].finished)
			{
				_currentChain++;
				if (!finished)
					_chain[_currentChain].reset();
			}
		}
		
		public function addToChain(motion:Motion):void
		{
			_chain.push(motion);
		}
		
		public function MotionChain(chain:Array)
		{
			super(null, null, 0);
			
			for (var i:int = 0; i < chain.length; i++)
			{
				if (chain[i] is Motion)
				{
					_chain.push(chain[i]);
				}
				else
					throw new FlinjinEvent("One of parametrs is not a Motion object");
			}
		}
	
	}

}