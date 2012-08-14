package flinjin
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.net.LocalConnection;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flinjin.events.FlinjinEvent;
	import flinjin.system.FjConsts;
	
	/**
	 * Flinjin application base class singletone
	 *
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class Flinjin extends Sprite
	{
		// Default application name constant
		private static const DEFAULT_APPLICATION_NAME:String = 'Flinjin v' + FjConsts.ENGINE_VERSION + ' application';
		
		// Name of the Flinjin Application
		private static var _applicationName:String = DEFAULT_APPLICATION_NAME;
		
		// Camera
		private var _Camera:FjCamera;
		
		// Rendering region
		private var _regionRect:Rectangle = null;
		
		// Debug state
		public static var Debug:Boolean = false;
		
		// Last instance of Flinjin in current application
		public static var Instance:Flinjin = null;
		
		private static var _sceneWidth:Number;
		private static var _sceneHeight:Number;
		private static var _frameRate:Number;
		private static var _contextMenu:ContextMenu = null;
		private static var _siteLocks:Array = null;
		
		private static var _stage3dAvail:Boolean = false;
		private var _contextMenu:ContextMenu;
		private var _flinjinContextMenuItem:ContextMenuItem;
		private var _deactivated:Boolean = false;
		private var _deactivatedFilters:Array = new Array(new BlurFilter(10, 10));
		
		/**
		 * Adding item to the context menu of the application
		 *
		 * If callback function is not defined (null given) then item will be added as disabled
		 *
		 * @param	caption		Caption of the item
		 * @param	callback	Callback function to be called by clicking the item
		 *
		 * @return New created ContextMenuItem object
		 */
		public function contextMenuAddItem(caption:String, callback:Function = null):ContextMenuItem
		{
			if (_contextMenu == null)
			{
				_contextMenu = new ContextMenu();
				_contextMenu.hideBuiltInItems();
				contextMenu = _contextMenu;
			}
			
			var _newMenuItem:ContextMenuItem = new ContextMenuItem(caption, (_contextMenu.customItems.length == 1), (callback != null));
			if (callback != null)
			{
				_newMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:ContextMenuEvent):void
					{
						callback.call();
					});
			}
			_contextMenu.customItems.push(_newMenuItem);
			return _newMenuItem;
		}
		
		/**
		 * Add domains for site locking
		 *
		 * @param	domains
		 */
		public static function lockDomains(domains:Array):void
		{
			for (var i:int = 0; i < domains.length; i++)
			{
				if (domains[i] is String)
				{
					_siteLocks.push(domains[0]);
				}
			}
		}
		
		/**
		 * Maximum value of frame time.
		 *
		 */
		public static function get frameDelta():Number
		{
			return 1000 / _frameRate;
		}
		
		override public function get width():Number
		{
			return _regionRect.width;
		}
		
		override public function get height():Number
		{
			return _regionRect.height;
		}
		
		/**
		 * Added to stage event
		 * @param	e
		 */
		private function onAddedToStage(e:Event):void
		{
			FjLog.l("Flinjin added to stage");
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			if (_regionRect == null)
			{
				_regionRect = new Rectangle(x, y, stage.stageWidth - x, stage.stageHeight - y);
				_sceneWidth = stage.stageWidth;
				_sceneHeight = stage.stageHeight;
			}
			else
			{
				_regionRect.x = x;
				_regionRect.y = y;
			}
			
			_frameRate = stage.frameRate;
			
			_Camera.fillColor = stage.color;
			_Camera.setViewport(_sceneWidth, _sceneHeight);
			addChild(_Camera);
			stage.quality = StageQuality.LOW;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP;
			stage.focus = _Camera;
			stage.addEventListener(Event.RESIZE, onStageResize);
			dispatchEvent(new FlinjinEvent(FlinjinEvent.ENGINE_STARTUP, e.bubbles, e.cancelable));
			FjLog.l("Flinjin started: " + sceneWidth + "x" + sceneHeight + " Frame rate: " + frameRate);
			
			if (_applicationName == DEFAULT_APPLICATION_NAME)
				FjLog.l("Application name not set. Recommended to set this value in your Flinjin subclass constructor using Flinjin.applicationName", FjLog.W_HINT);
		}
		
		/**
		 * Stage resize event
		 *
		 * @param	e
		 */
		private function onStageResize(e:Event):void
		{
		/** @todo Put resize actions here **/
		}
		
		public function get regionRect():Rectangle
		{
			return _regionRect;
		}
		
		public function set regionRect(newRegionRect:Rectangle):void
		{
			_regionRect = newRegionRect;
		}
		
		static public function get sceneHeight():Number
		{
			return _sceneHeight;
		}
		
		static public function get sceneWidth():Number
		{
			return _sceneWidth;
		}
		
		/**
		 *
		 */
		public function get Camera():FjCamera
		{
			return _Camera;
		}
		
		static public function get applicationName():String
		{
			return _applicationName;
		}
		
		static public function set applicationName(value:String):void
		{
			_applicationName = value;
		}
		
		static public function get frameRate():Number
		{
			return _frameRate;
		}
		
		public function get deactivated():Boolean
		{
			return _deactivated;
		}
		
		/**
		 *
		 * @param	nWidth		Width of the main scene
		 * @param	nHeight		Height of the main scene
		 */
		public function Flinjin(nWidth:Number = -1, nHeight:Number = -1)
		{
			if (checkSiteLock())
			{
				_Camera = new FjCamera();
				if ((nWidth != -1) && (nHeight != -1))
				{
					_regionRect = new Rectangle(0, 0, nWidth, nHeight);
					_sceneWidth = nWidth;
					_sceneHeight = nHeight;
				}
				focusRect = false;
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
				addEventListener(Event.ACTIVATE, onActivate);
				addEventListener(Event.DEACTIVATE, onDeactivate);
				addEventListener(MouseEvent.CLICK, onClick);
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
				
				Flinjin.Instance = this;
				
				contextMenuAddItem("Flinjin v" + FjConsts.ENGINE_VERSION, function():void
					{
						/**
						 * Please, don't change this, I need this for statistics
						 */
						var _flinjinURLRequest:URLRequest = new URLRequest("http://www.flinjin.com/?utm_source=game&utm_medium=contextmenu&utm_campaign=" + encodeURIComponent(applicationName));
						navigateToURL(_flinjinURLRequest);
					});
				
				if (Debug)
				{
					contextMenuAddItem("Toggle Flinjin Console", function():void
						{
							FjConsole.active = !FjConsole.active;
						});
					FjConsole.inspect(_Camera, "fps", "Camera FPS");
				}
			}
			else
			{
				var lockInfo:TextField = new TextField();
				with (lockInfo)
				{
					text = "You can not run this game on this domain!\nContact developer";
					setTextFormat(new TextFormat("Tahoma", 48, 0xff0000, true));
					background = true;
					backgroundColor = 0x00ff00;
					autoSize = TextFieldAutoSize.LEFT;
				}
				
				lockInfo.x = (width - lockInfo.width) / 2;
				lockInfo.y = (height - lockInfo.height) / 2;
				addChild(lockInfo);
				FjLog.l("This game is locked");
			}
		}
		
		/**
		 * Returns true is application can be runned in this domain
		 *
		 * @return	Boolean
		 */
		private function checkSiteLock():Boolean
		{
			try
			{
				var lc:LocalConnection = new LocalConnection();
				return (((_siteLocks != null) && (_siteLocks.indexOf(lc.domain) != -1)) || (lc.domain == "localhost"));
			}
			finally
			{
				return true;
			}
		}
		
		/**
		 * Enter frame event
		 *
		 * @param	e
		 */
		private function onEnterFrame(e:Event):void
		{
			if (!_deactivated)
				_Camera.Render();
		}
		
		/**
		 * Click event
		 *
		 * @param	e
		 */
		private function onClick(e:MouseEvent):void
		{
			stage.focus = _Camera;
		}
		
		/**
		 * Activate event
		 *
		 * @param	e
		 */
		private function onActivate(e:Event):void
		{
			stage.focus = _Camera;
			_deactivated = false;
			if (_Camera.filmSurface != null)
				_Camera.filmSurface.filters = [];
			_Camera.resetTimeDelta();
		
		}
		
		/**
		 * Deactivate event
		 *
		 * @param	e
		 */
		private function onDeactivate(e:Event):void
		{
			_deactivated = true;
			if (_Camera.filmSurface != null)
				_Camera.filmSurface.filters = _deactivatedFilters;
		}
	}
}