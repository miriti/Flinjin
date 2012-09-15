package flinjin
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flinjin.system.FlinjinError;
	
	/**
	 *
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class FjInput
	{
		private static var _enabled:Boolean = true;
		private static var _keysPressed:Array = new Array(256);
		private static var _enableWASD:Boolean = true;
		private static var _mousePosition:Point = new Point();
		private static var _isMouseDown:Boolean = false;
		
		public static function isLeft():Boolean
		{
			return (_enabled) && (_keysPressed[Keyboard.LEFT] || (_keysPressed[Keyboard.A] && enableWASD));
		}
		
		public static function isRight():Boolean
		{
			return (_enabled) && (_keysPressed[Keyboard.RIGHT] || (_keysPressed[Keyboard.D] && enableWASD));
		}
		
		public static function isUp():Boolean
		{
			return (_enabled) && (_keysPressed[Keyboard.UP] || (_keysPressed[Keyboard.W] && enableWASD));
		}
		
		public static function isDown():Boolean
		{
			return (_enabled) && (_keysPressed[Keyboard.DOWN] || (_keysPressed[Keyboard.S] && enableWASD));
		}
		
		public static function isKeyPressed(key:uint):Boolean
		{
			if (key < 256)
				return _keysPressed[key];
			else
				return false;
		}
		
		public static function onKeyDown(e:KeyboardEvent):void
		{
			_keysPressed[e.keyCode] = true;
		}
		
		public static function onKeyUp(e:KeyboardEvent):void
		{
			_keysPressed[e.keyCode] = false;
		}
		
		public static function onMouseDown(e:MouseEvent):void
		{
			_isMouseDown = true;
		}
		
		public static function onMouseUp(e:MouseEvent):void
		{
			_isMouseDown = false;
		}
		
		static public function get isMouseDown():Boolean
		{
			return _isMouseDown;
		}
		
		static public function get keysPressed():Array
		{
			return _keysPressed;
		}
		
		static public function get enableWASD():Boolean
		{
			return _enableWASD;
		}
		
		static public function set enableWASD(value:Boolean):void
		{
			_enableWASD = value;
		}
		
		static public function get mousePosition():Point
		{
			return _mousePosition;
		}
		
		static public function get enabled():Boolean
		{
			return _enabled;
		}
		
		static public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
	}

}