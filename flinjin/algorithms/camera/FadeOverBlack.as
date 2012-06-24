package flinjin.algorithms.camera
{
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class FadeOverBlack extends CameraTransitionEffect
	{
		private var _fadeTime:Number;
		private var _fadeTimeDid:Number = 0;
		
		public function FadeOverBlack(fadeTime:Number)
		{
			_fadeTime = fadeTime;
		}
		
		override public function update(timeDelta:Number):void
		{
			super.update(timeDelta);
			_fadeTimeDid += timeDelta;
			
			if (_fadeTimeDid >= _fadeTime)
			{
				// TODO wtf?
				if (_sceneTo.alpha < 1)
					_sceneTo.alpha = 1;
				_finished = true;
			}
		}
		
		override public function start():void
		{
			super.start();
			_sceneFrom.alpha = 1;
			_sceneTo.alpha = 1;
		}
		
		override public function render(surface:BitmapData):void
		{
			surface.fillRect(surface.rect, 0x000000);
			if (_fadeTimeDid < _fadeTime / 2)
			{
				_sceneFrom.alpha = 1 - _fadeTimeDid / (_fadeTime / 2);
				_sceneFrom.Draw(surface);
			}
			else
			{
				_sceneTo.alpha = (_fadeTimeDid - (_fadeTime / 2)) / (_fadeTime / 2);
				// TODO wtf?
				if (_sceneTo.alpha > 1)
					_sceneTo.alpha = 1;
				_sceneTo.Draw(surface);
			}
		}
	
	}

}