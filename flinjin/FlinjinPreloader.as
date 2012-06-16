package flinjin
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Default Flinjin preloader class
	 *
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class FlinjinPreloader extends MovieClip
	{
		public static var MainClassName:String;
		private var _progressBar:PreloaderProgressBar;
		
		[Embed(source="assets/flinjin-logo.png")]
		private static var _flinjinLogo:Class;
		
		private var logoObject:DisplayObject = null;
		
		/**
		 * Constructor
		 * 
		 */
		public function FlinjinPreloader()
		{
			if (stage)
			{
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				
				graphics.beginFill(0x000000);
				graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				graphics.endFill();
				
				if (logoObject == null)
					setLogo(new _flinjinLogo() as Bitmap);
				addChild(logoObject);
				
				_progressBar = new PreloaderProgressBar(stage.stageWidth);
				_progressBar.y = stage.stageHeight - _progressBar.height;
				addChild(_progressBar);
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
		}
		
		/**
		 * Change the logo, that displayed in preloader
		 *
		 * @param	logoObject
		 */
		protected function setLogo(newLogo:DisplayObject):void
		{
			logoObject = newLogo;
			logoObject.x = (stage.stageWidth - logoObject.width) / 2;
			logoObject.y = (stage.stageHeight - logoObject.height) / 2;
		}
		
		/**
		 * Some possible error
		 *
		 * @param	e
		 */
		private function ioError(e:IOErrorEvent):void
		{
			FlinjinLog.l(e.text);
		}
		
		/**
		 * Dispatching progress
		 *
		 * @param	e
		 */
		private function progress(e:ProgressEvent):void
		{
			_progressBar.progress = Math.floor(e.bytesTotal / e.bytesLoaded * 100);
		}
		
		/**
		 * Checking frame
		 *
		 * @param	e
		 */
		private function checkFrame(e:Event):void
		{
			if (currentFrame == totalFrames)
			{
				stop();
				loadingFinished();
			}
		}
		
		/**
		 * Loading finished
		 *
		 */
		private function loadingFinished():void
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			startup();
		}
		
		/**
		 * Start game
		 *
		 */
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
	private var _barHeight:Number;
	
	function PreloaderProgressBar(maxWidth:Number, barHeight:Number = 16)
	{
		super();
		_maxWidth = maxWidth;
		_barHeight = barHeight;
		
		graphics.clear();
		graphics.beginFill(0x000000);
		graphics.drawRect(0, 0, _maxWidth, _barHeight);
		graphics.endFill();
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
		graphics.drawRect(0, 0, _maxWidth * (100 / _progress), _barHeight);
		graphics.endFill();
	}
}