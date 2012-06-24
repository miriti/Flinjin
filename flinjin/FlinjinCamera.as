package flinjin
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flinjin.algorithms.camera.CameraTransitionEffect;
	import flinjin.graphics.Layer;
	import flinjin.input.Input;
	
	/**
	 * Camera
	 *
	 * @author Michael Miriti
	 */
	public class FlinjinCamera extends Sprite
	{
		// Color to fill empty space
		private var _fillColor:uint = 0x000000;
		
		// Surface to draw on
		private var _filmSurface:Bitmap = null;
		
		// Layer to draw
		private var _scene:Layer = null;
		
		// Zoom factor
		private var _zoom:Number = 1.0;
		
		// Camera position X
		private var _posX:Number = 0;
		
		// Camera position Y
		private var _posY:Number = 0;
		
		// Camera position in Point
		private var _cameraPos:Point = new Point();
		
		private var _lastTime:Number = 0;
		
		private var _debugTotalUpdateTime:Number = 0;
		private var _debugTotalUpdateCount:Number = 0;
		private var _debugTimer:Timer;
		private var _debugLastDeltaTime:Number = 0;
		private var _transitionEffect:CameraTransitionEffect = null;
		
		public function resetTimeDelta():void
		{
			_lastTime = new Date().getTime();
		}
		
		/**
		 *
		 */
		public function get cameraPos():Point
		{
			_cameraPos.setTo(_posX, _posY);
			return _cameraPos;
		}
		
		public function get fillColor():uint
		{
			return _fillColor;
		}
		
		public function set fillColor(value:uint):void
		{
			_fillColor = value;
		}
		
		public function get filmSurface():Bitmap
		{
			return _filmSurface;
		}
		
		/**
		 * Change the layer to look at by camera
		 *
		 * @param	scene
		 * @param	transitionEffect	Transition effect
		 * @return
		 */
		public function LookAt(scene:Layer, transitionEffect:CameraTransitionEffect = null):Layer
		{
			if (transitionEffect == null)
			{
				_scene = scene;
			}
			else
			{
				_transitionEffect = transitionEffect;
				_transitionEffect.sceneFrom = _scene;
				_transitionEffect.sceneTo = scene;
				_transitionEffect.start();
				_scene = null;
			}
			return scene;
		}
		
		/**
		 * Update all content
		 *
		 */
		public function Update():void
		{
			var _date:Date = new Date();
			var _newLastTime:Number = _date.getTime();
			var _deltaTime:Number = _newLastTime - _lastTime;
			
			if (Flinjin.Debug)
			{
				_debugLastDeltaTime = _deltaTime;
				_debugTotalUpdateCount++;
				_debugTotalUpdateTime += _deltaTime;
			}
			
			if (null != _scene)
				_scene.Move(_deltaTime);
			
			else
			{
				if (null != _transitionEffect)
				{
					_transitionEffect.sceneFrom.Move(_deltaTime);
					_transitionEffect.sceneTo.Move(_deltaTime);
					_transitionEffect.update(_deltaTime);
					
					if (_transitionEffect.finished)
					{
						_scene = _transitionEffect.sceneTo;
						_transitionEffect = null;
					}
				}
			}
			_lastTime = _newLastTime;
		}
		
		/**
		 * Draw all content
		 *
		 */
		public function Render():void
		{
			Update();
			_filmSurface.bitmapData.fillRect(_filmSurface.bitmapData.rect, _fillColor); // TODO Do we really new this? Not always
			
			if (null != _scene)
			{
				_scene.x = -_posX;
				_scene.y = -_posY;
				_scene.Draw(_filmSurface.bitmapData);
			}
			else
			{
				if (null != _transitionEffect)
				{
					_transitionEffect.render(_filmSurface.bitmapData);
				}
			}
		}
		
		/**
		 * Set camera vieport
		 *
		 * @param	viewportWidth
		 * @param	viewportHeight
		 */
		public function setViewport(viewportWidth:uint, viewportHeight:uint):void
		{
			if (null != _filmSurface)
			{
				removeChild(_filmSurface);
				_filmSurface.bitmapData.dispose();
				_filmSurface = null;
			}
			
			_filmSurface = new Bitmap(new BitmapData(viewportWidth, viewportHeight, false, _fillColor), "auto", false);
			addChild(_filmSurface);
		}
		
		/**
		 *
		 */
		public function FlinjinCamera()
		{
			focusRect = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			// Translate Mouse Events
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			addEventListener(MouseEvent.CLICK, onMouseEvent);
			
			// Translate Keyboard events
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyEvent);
			addEventListener(KeyboardEvent.KEY_UP, onKeyEvent);
			
			// Dispatch Input Events
			addEventListener(MouseEvent.MOUSE_DOWN, Input.onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, Input.onMouseUp);
			
			addEventListener(KeyboardEvent.KEY_DOWN, Input.onKeyDown);
			addEventListener(KeyboardEvent.KEY_UP, Input.onKeyUp);
			
			var _date:Date = new Date();
			_lastTime = _date.getTime();
			
			if (Flinjin.Debug)
			{
				_debugTimer = new Timer(1000);
				_debugTimer.addEventListener(TimerEvent.TIMER, onDebugTimer);
				_debugTimer.start();
			}
			
			buttonMode = true;
		}
		
		private function onDebugTimer(e:TimerEvent):void
		{
			FlinjinLog.l('FPS: ' + 1000 / (_debugTotalUpdateTime / _debugTotalUpdateCount) + ' / ' + Flinjin.frameRate);
			_debugTotalUpdateCount = 0;
			_debugTotalUpdateTime = 0;
		}
		
		/**
		 * Dispatch Keyboard events
		 *
		 * @param	e
		 */
		private function onKeyEvent(e:KeyboardEvent):void
		{
			if (null != _scene)
				_scene.dispatchEvent(e);
		}
		
		/**
		 * Dispatch Mouse events
		 *
		 * @param	e
		 */
		private function onMouseEvent(e:MouseEvent):void
		{
			if (null != _scene)
				_scene.dispatchEvent(e);
		}
		
		/**
		 * Dispatch MouseOver event for Input
		 *
		 * @param	e
		 */
		private function onMouseMove(e:MouseEvent):void
		{
			Input.MousePosition.x = e.stageX;
			Input.MousePosition.y = e.stageY;
		}
		
		/**
		 * Dispatch ADDED_TO_STAGE event
		 *
		 * @param	e
		 */
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
	}
}