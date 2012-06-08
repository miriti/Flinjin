package flinjin
{
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.events.ContextMenuEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flinjin.events.FlinjinEvent;
	import flinjin.system.Consts;
	
	/**
	 * Flinjin application base class
	 *
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class Flinjin extends Sprite
	{
		// Camera
		private var _Camera:FlinjinCamera;
		
		// Rendering region
		private var _regionRect:Rectangle = null;
		
		// Debug state
		public static var Debug:Boolean = false;
		
		// Last instance of Flinjin in current application
		public static var Instance:Flinjin = null;
		
		private static var _sceneWidth:Number;
		private static var _sceneHeight:Number;
		
		private static var _stage3dAvail:Boolean = false;
		private var _contextMenu:ContextMenu;
		private var _flinjinContextMenuItem:ContextMenuItem;
		
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
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			if (ApplicationDomain.currentDomain.hasDefinition('flash.display.Stage3D'))
			{
				stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreate);
				stage.stage3Ds[0].addEventListener(ErrorEvent.ERROR, onContext3DError);
				stage.stage3Ds[0].requestContext3D();
			}
			
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
			
			_Camera.fillColor = stage.color;
			_Camera.setViewport(_sceneWidth, _sceneHeight);
			addChild(_Camera);
			stage.quality = StageQuality.LOW;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP;
			stage.focus = _Camera;
			stage.addEventListener(Event.RESIZE, onStageResize);
			dispatchEvent(new FlinjinEvent(FlinjinEvent.ENGINE_STARTUP, e.bubbles, e.cancelable));
		}
		
		/**
		 * Stage3d initializing error event handler
		 *
		 * @param	e
		 */
		private function onContext3DError(e:ErrorEvent):void
		{
			// error initializing stage3d
		}
		
		/**
		 * Stage3d initializing Context3d created event handler
		 *
		 * @param	e
		 */
		private function onContext3DCreate(e:Event):void
		{
			var s3d:Stage3D = e.target as Stage3D;
			var context3d:Context3D = s3d.context3D;
			
			if (context3d == null)
			{
				_stage3dAvail = false;
			}
			
			trace(context3d.driverInfo);
			context3d.enableErrorChecking = false;
			context3d.configureBackBuffer(_sceneWidth, _sceneHeight, 0, true);
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
		
		static public function get stage3dAvail():Boolean
		{
			return _stage3dAvail;
		}
		
		/**
		 * 
		 */
		public function get Camera():FlinjinCamera 
		{
			return _Camera;
		}
		
		/**
		 *
		 * @param	nWidth		Width of the main scene
		 * @param	nHeight		Height of the main scene
		 */
		public function Flinjin(nWidth:Number = -1, nHeight:Number = -1)
		{
			_Camera = new FlinjinCamera();
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
			
			_contextMenu = new ContextMenu();
			_contextMenu.hideBuiltInItems();
			
			_flinjinContextMenuItem = new ContextMenuItem("powered by Flinjin v" + Consts.ENGINE_VERSION);
			_flinjinContextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onFlinjinMenuItemSelect);
			
			_contextMenu.customItems.push(_flinjinContextMenuItem);
			
			contextMenu = _contextMenu;
		}
		
		private function onFlinjinMenuItemSelect(e:ContextMenuEvent):void 
		{
			/**
			 * @todo utm_ marks in URL
			 */
			var _flinjinURLRequest:URLRequest = new URLRequest("http://flinjin.com/");
			navigateToURL(_flinjinURLRequest);
		}
		
		private function onEnterFrame(e:Event):void 
		{
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
		}
		
		/**
		 * Deactivate event
		 *
		 * @param	e
		 */
		private function onDeactivate(e:Event):void
		{
			/** @todo It is possible to make pause here **/
		}
	}
}