package flinjin.input
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flinjin.system.FlinjinError;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class Input
	{
		public static var KeysPressed:Array = new Array(256);
		public static var enableWASD:Boolean = true;
		public static var MousePosition:Point = new Point();
		
		private static var _isMouseDown:Boolean = false;
		
		public static function isLeft():Boolean
		{
			return KeysPressed[Keyboard.LEFT] || (KeysPressed[Keyboard.A] && enableWASD);
		}
		
		public static function isRight():Boolean
		{
			return KeysPressed[Keyboard.RIGHT] || (KeysPressed[Keyboard.D] && enableWASD);
		}
		
		public static function isUp():Boolean
		{
			return KeysPressed[Keyboard.UP] || (KeysPressed[Keyboard.W] && enableWASD);
		}
		
		public static function isDown():Boolean
		{
			return KeysPressed[Keyboard.DOWN] || (KeysPressed[Keyboard.S] && enableWASD);
		}
		
		public static function isKey(key:uint):Boolean
		{
			if (key < 256)
				return Input.KeysPressed[key];
			else
				throw new FlinjinError("Invalid key [" + key + "]");
		}
		
		public static function onKeyDown(e:KeyboardEvent):void
		{
			KeysPressed[e.keyCode] = true;
		}
		
		public static function onKeyUp(e:KeyboardEvent):void
		{
			KeysPressed[e.keyCode] = false;
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
	}

}