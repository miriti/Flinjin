package flinjin
{
	import flinjin.system.FlinjinError;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class FjLog
	{
		public static const W_INFO:int = 0;
		public static const W_HINT:int = 1;
		public static const W_WARN:int = 2;
		public static const W_ERRO:int = 3;
		public static const W_CRTC:int = 4;
		
		private static var _haltOn:int = W_CRTC;
		
		private static var _warningLevelsNames:Array = new Array('Info', 'Hint', 'Warning', 'Error', 'Critical Error');
		
		private static var _log:Array = new Array();
		
		public static function l(message:*, warnLevel:int = W_INFO):void
		{
			var _msgStr:String;
			
			if (message is String)
				_msgStr = message;
			else if (message is Object)
				_msgStr = message.toString;
			else
				_msgStr = '???';
			
			_log.push(new FlinjinLogEntry('[' + _warningLevelsNames[warnLevel] + ']: ' + _msgStr));
			
			if (warnLevel >= _haltOn)
			{
				throw new FlinjinError(_msgStr);
			}
		}
		
		static public function get haltOn():int
		{
			return _haltOn;
		}
		
		static public function set haltOn(value:int):void
		{
			if (value <= W_CRTC)
				_haltOn = value;
			else
				_haltOn = W_CRTC;
		}
	
	}

}
import flash.external.ExternalInterface;

class FlinjinLogEntry extends Object
{
	public function FlinjinLogEntry(text:String):void
	{
		if (ExternalInterface.available)
			ExternalInterface.call("console.log", text);
		
		trace(text);
	}
	
	public function toString():String
	{
		return "[FlinjinLogEntry]";
	}
}