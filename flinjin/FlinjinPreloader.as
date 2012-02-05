package flinjin
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class FlinjinPreloader extends MovieClip
	{
		public static var MainClassName:String;
		private var _progressBar:PreloaderProgressBar;
		
		public function FlinjinPreloader()
		{
			
			if (stage)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				
				_progressBar = new PreloaderProgressBar(stage.stageWidth);
				addChild(_progressBar);
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
		}
		
		private function ioError(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void
		{
			_progressBar.progress = Math.floor(e.bytesTotal / e.bytesLoaded * 100);
		}
		
		private function checkFrame(e:Event):void
		{
			if (currentFrame == totalFrames)
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
			
			startup();
		}
		
		private function startup():void
		{
			var mainClass:Class = getDefinitionByName(MainClassName) as Class;
			addChild(new mainClass() as DisplayObject);
		}
	
	}

}
import flash.display.MovieClip;

class PreloaderProgressBar extends MovieClip
{
	private var _progress:uint;
	private var _maxWidth:Number;
	
	function PreloaderProgressBar(maxWidth:Number)
	{
		_maxWidth = maxWidth;
		super();
	}
	
	public function get progress():uint 
	{
		return _progress;
	}
	
	public function set progress(value:uint):void 
	{
		_progress = value;
		
		graphics.clear();
		graphics.beginFill(0xffffff);
		graphics.drawRect(0, 0, _maxWidth * (100 / _progress), 16);
		graphics.endFill();
	}
}