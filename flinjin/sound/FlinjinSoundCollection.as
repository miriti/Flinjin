package flinjin.sound
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;
	import flinjin.FlinjinLog;
	import flinjin.system.FlinjinError;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class FlinjinSoundCollection extends Object
	{
		public static var Sounds:Dictionary = new Dictionary();
		public static var Channels:Vector.<SoundChannel> = new Vector.<SoundChannel>;
		
		private static var _enabled:Boolean = true;
		
		/**
		 * Play sound by name
		 *
		 * @param	name
		 */
		public static function playSound(name:String):FlinjinSound
		{
			var _snd:FlinjinSound = FlinjinSoundCollection.getSound(name);
			if (_snd != null)
				return _snd.play();
			else
			{
				FlinjinLog.l("Sound <" + name + "> not found", FlinjinLog.W_ERRO);
				return null;
			}
		}
		
		public static function getSound(name:String):FlinjinSound
		{
			if (Sounds[name] != null)
			{
				var _newSnd:FlinjinSound = new FlinjinSound(Sounds[name]);
				return _newSnd;
			}
			else
				return null;
		
		}
		
		/**
		 * Adds sound to sound collection
		 *
		 * @param	sndObject
		 * @param	name
		 * @param	looping
		 * @return
		 */
		public static function addSound(sndObject:Sound, name:String):Boolean
		{
			if (Sounds == null)
			{
				Sounds = new Dictionary();
			}
			
			Sounds[name] = sndObject;
			
			return true;
		}
		
		static public function get enabled():Boolean
		{
			return _enabled;
		}
		
		static public function set enabled(value:Boolean):void
		{
			if (!value)
			{
				for (var i:int = 0; i < Channels.length; i++)
				{
					Channels.pop().stop();
				}
			}
			_enabled = value;
		}
	
	}

}