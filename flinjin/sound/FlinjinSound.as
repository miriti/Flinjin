package flinjin.sound
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class FlinjinSound
	{
		private var _snd:Sound;
		private var _sndChannel:SoundChannel;
		private var _loop:Boolean;
		
		private var _volume:Number = 1;
		
		public function stop():FlinjinSound
		{
			if (_sndChannel != null)
			{
				FlinjinSoundCollection.Channels.splice(FlinjinSoundCollection.Channels.indexOf(_sndChannel), 1);
				_sndChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				_sndChannel.stop();
			}
			
			return this;
		}
		
		public function play():FlinjinSound
		{
			if (!FlinjinSoundCollection.enabled)
				return this;
				
			_sndChannel = _snd.play();
			if (_sndChannel != null)
			{
				FlinjinSoundCollection.Channels.push(_sndChannel);
				_sndChannel.soundTransform.volume = _volume;
				_sndChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
			else
			{
				trace('Maximum sound channels count riched');
			}
			return this;
		}
		
		private function onSoundComplete(e:Event = null):void
		{
			_sndChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			FlinjinSoundCollection.Channels.splice(FlinjinSoundCollection.Channels.indexOf(_sndChannel), 1);
			if (_loop)
			{
				play();
			}
		}
		
		public function FlinjinSound(snd:Sound)
		{
			_snd = snd;
		}
		
		public function get sndChannel():SoundChannel
		{
			return _sndChannel;
		}
		
		public function get loop():Boolean
		{
			return _loop;
		}
		
		public function set loop(value:Boolean):void
		{
			_loop = value;
		}
		
		public function get volume():Number
		{
			if (_sndChannel != null)
				return _sndChannel.soundTransform.volume;
			else
				return _volume;
		}
		
		public function set volume(value:Number):void
		{
			_volume = value;
			if (_sndChannel != null)
				_sndChannel.soundTransform.volume = value;
		}
	
	}

}