package flinjin
{
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class FlinjinLog
	{
		public static const W_INFO:int = 0;
		public static const W_HINT:int = 1;
		public static const W_WARN:int = 2;
		public static const W_ERRO:int = 3;
		public static const W_CRTC:int = 4;
		
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
		}
	
	}

}

class FlinjinLogEntry extends Object
{
	public function FlinjinLogEntry(text:String):void
	{
		trace(text);
	}
	
	public function toString():String
	{
		return "[FlinjinLogEntry]";
	}
}