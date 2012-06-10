package flinjin
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
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
		
		/**
		 * Make a flash
		 * 
		 * @param	color
		 * @param	time
		 */
		public function Flash(color:uint, time: Number = 0.2):void {
			/**
			 * @todo Make a colored flash
			 */
		}
		
		/**
		 * Change the layer to look at for camera
		 *
		 * @param	scene
		 * @return
		 */
		public function LookAt(scene:Layer):Layer
		{
			_scene = scene;
			return scene;
		}
		
		/**
		 * Update all content
		 *
		 */
		public function Update():void
		{
			if (null != _scene) _scene.Move();
		}
		
		/**
		 * Draw all content
		 *
		 */
		public function Render():void
		{
			Update();
			_filmSurface.bitmapData.fillRect(_filmSurface.bitmapData.rect, _fillColor);
			
			if (null != _scene) {
				_scene.x = -_posX;
				_scene.y = -_posY;
				_scene.Draw(_filmSurface.bitmapData);
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
			
			buttonMode = true;
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