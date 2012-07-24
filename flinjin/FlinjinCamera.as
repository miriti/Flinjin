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
		private var _sceneStack:Vector.<Layer> = new Vector.<Layer>();
		
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
		
		public function get zoom():Number
		{
			return _zoom;
		}
		
		public function set zoom(value:Number):void
		{
			_zoom = value;
			// TODO fix zooming
			/*
			if (_scene != null)
				_scene.scale = _zoom;
			else if (_transitionEffect != null)
			{
				_transitionEffect.sceneFrom.scale = _zoom;
				_transitionEffect.sceneTo.scale = _zoom;
			}*/
		}
		
		public function get scene():Layer
		{
			return _scene;
		}
		
		public function set scene(value:Layer):void
		{
			_sceneStack.push(_scene);
			_scene = value;
			// TODO fix scaling
			//_scene.scale = _zoom;
		}
		
		/**
		 * Change the layer to look at by camera
		 *
		 * @param	scene
		 * @param	transitionEffect	Transition effect
		 * @return
		 */
		public function LookAt(lookAtScene:Layer, transitionEffect:CameraTransitionEffect = null):Layer
		{
			if (transitionEffect == null)
			{
				scene = lookAtScene;
			}
			else
			{
				_transitionEffect = transitionEffect;
				_transitionEffect.sceneFrom = _scene;
				//_transitionEffect.sceneFrom.scale = _zoom;
				_transitionEffect.sceneTo = lookAtScene;
				//_transitionEffect.sceneTo.scale = _zoom;
				_transitionEffect.start();
				_scene = null;
			}
			return scene;
		}
		
		/**
		 * Look at the previous scene
		 * 
		 * @param	transitionEffect
		 */
		public function LookBack(transitionEffect:CameraTransitionEffect = null):void
		{
			LookAt(_sceneStack.pop(), transitionEffect);
			_sceneStack.pop();
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
			var _repeatMoveCount:int = 1;
			
			if (Flinjin.Debug)
			{
				_debugLastDeltaTime = _deltaTime;
				_debugTotalUpdateCount++;
				_debugTotalUpdateTime += _deltaTime;
			}
			
			if (_deltaTime > Flinjin.frameDelta)
			{
				_repeatMoveCount = _deltaTime / Flinjin.frameDelta;
				if (_deltaTime % Flinjin.frameDelta != 0)
					_repeatMoveCount++;
			}
			
			for (var i:int = 0; i < _repeatMoveCount; i++)
			{
				var _iterationDeltaTime:Number;
				
				if (_deltaTime <= Flinjin.frameDelta)
				{
					_iterationDeltaTime = _deltaTime;
				}
				else
				{
					_iterationDeltaTime = Flinjin.frameDelta;
				}
				_deltaTime -= Flinjin.frameDelta;
				
				if (null != _scene)
					_scene.Move(_iterationDeltaTime);
				
				else
				{
					if (null != _transitionEffect)
					{
						_transitionEffect.sceneFrom.Move(_iterationDeltaTime);
						_transitionEffect.sceneTo.Move(_iterationDeltaTime);
						_transitionEffect.update(_iterationDeltaTime);
						
						if (_transitionEffect.finished)
						{
							scene = _transitionEffect.sceneTo;
							_transitionEffect = null;
						}
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
		 * Flinjin Camera constructor
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
		
		/**
		 * Debug timer event
		 *
		 * @param	e
		 */
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
			Input.MousePosition.x = e.stageX / _zoom;
			Input.MousePosition.y = e.stageY / _zoom;
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