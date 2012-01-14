package flinjin.input
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author KEFIR
	 */
	public class Input
	{
		public static var KeysPressed:Array = new Array(256);
		public static var enableWASD:Boolean = true;
		
		private static var _isMouseDown:Boolean = false;
		
		public static function isLeft():Boolean
		{
			return KeysPressed[Keyboard.LEFT];
		}
		
		public static function idRight():Boolean
		{
			return KeysPressed[Keyboard.RIGHT];
		}
		
		public static function isUp():Boolean
		{
			return KeysPressed[Keyboard.UP];
		}
		
		public static function isDown():Boolean
		{
			return KeysPressed[Keyboard.DOWN];
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