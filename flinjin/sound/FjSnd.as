package flinjin.sound
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;
	import flinjin.FjLog;
	import flinjin.system.FlinjinError;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class FjSnd extends Object
	{
		private static var _sounds:Dictionary = new Dictionary();
		private static var _channels:Vector.<SoundChannel> = new Vector.<SoundChannel>;
		private static var _tags:Dictionary = new Dictionary();
		private static var _tags_disabled:Array = new Array();
		private static var _enabled:Boolean = true;
		
		/**
		 *
		 * @param	tags
		 */
		public static function disableTags(tags:Array):void
		{
			for (var i:int = 0; i < tags.length; i++)
			{
				if (_tags_disabled.indexOf(tags[i]) == -1)
					_tags_disabled.push(tags[i]);
			}
		}
		
		/**
		 *
		 * @param	tags
		 */
		public static function enableTags(tags:Array, play:Boolean = false):void
		{
			for (var i:int = 0; i < tags.length; i++)
			{
				if (_tags_disabled.indexOf(tags[i]) != -1)
					_tags_disabled.splice(i, 1);
			}
		}
		
		/**
		 * Play sound by name
		 *
		 * @param	name
		 */
		public static function playSound(name:String, volume:Number = 1, pan:Number = 0):FjSndItem
		{
			if (_tags[name] != null)
			{
				for (var i:int = 0; i < _tags[name].length; i++)
				{
					if (_tags_disabled.indexOf(_tags[name][i]) != -1)
						return null;
				}
			}
			
			var _snd:FjSndItem = getSound(name);
			if (_snd != null)
			{
				_snd.volume = volume;
				_snd.pan = pan;
				return _snd.play();
			}
			else
			{
				FjLog.l("Sound <" + name + "> not found!", FjLog.W_ERRO);
				return null;
			}
		}
		
		/**
		 * Get flinjin sound object
		 *
		 * @param	name
		 * @return
		 */
		public static function getSound(name:String):FjSndItem
		{
			if (_sounds[name] != null)
			{
				var _newSnd:FjSndItem = new FjSndItem(_sounds[name]);
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
		public static function addSound(sndObject:Sound, sndName:String, sndTags:Array = null):void
		{
			_sounds[sndName] = sndObject;
			_tags[sndName] = sndTags;
		}
		
		static public function get enabled():Boolean
		{
			return _enabled;
		}
		
		static public function set enabled(value:Boolean):void
		{
			if (!value)
			{
				for (var i:int = 0; i < _channels.length; i++)
				{
					_channels.pop().stop();
				}
			}
			_enabled = value;
		}
		
		static public function get channels():Vector.<SoundChannel>
		{
			return _channels;
		}
	
	}

}