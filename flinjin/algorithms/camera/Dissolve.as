package flinjin.algorithms.camera
{
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class Dissolve extends CameraTransitionEffect
	{
		private var _dissolveTime:Number;
		private var _dissolveTimeDid:Number = 0;
		
		/**
		 * Dissolve effect
		 *
		 * @param	dissolveTime	Time of the effect
		 */
		public function Dissolve(dissolveTime:Number = 500)
		{
			_dissolveTime = dissolveTime;
		}
		
		override public function start():void
		{
			super.start();
			_sceneFrom.alpha = 1;
			_sceneTo.alpha = 0;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			var stage:Number = (_dissolveTimeDid / _dissolveTime);
			if (stage > 1)
			{
				stage = 1;
				_finished = true;
			}
			//_sceneFrom.alpha = 1 - stage;
			_sceneTo.alpha = stage;
			_dissolveTimeDid += timeDelta;
		}
		
		override public function render(surface:BitmapData):void
		{
			super.render(surface);
			_sceneFrom.Draw(surface);
			_sceneTo.Draw(surface);
		}
	}

}