package flinjin.sound
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flinjin.FjLog;
	
	/**
	 * This class represents sound
	 *
	 * @author Michael Miriti
	 */
	public class FjSndItem
	{
		private var _snd:Sound;
		private var _sndChannel:SoundChannel;
		private var _loop:Boolean;
		private var _volume:Number = 1;
		private var _pan:Number = 0;
		
		public function FjSndItem(snd:Sound)
		{
			_snd = snd;
		}
		
		private function _deleteChannel():void
		{
			FjSnd.channels.splice(FjSnd.channels.indexOf(_sndChannel), 1);
		}
		
		/**
		 * Stop the sound
		 *
		 * @return
		 */
		public function stop():FjSndItem
		{
			if (_sndChannel != null)
			{
				_deleteChannel();
				_sndChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				_sndChannel.stop();
			}
			
			return this;
		}
		
		/**
		 * Play the sound
		 *
		 * @param	shift			Shift from start of the sound
		 * @return	FjSndItem	Returns this object
		 */
		public function play(shift:Number = 0):FjSndItem
		{
			if (!FjSnd.enabled)
				return this;
			
			_sndChannel = _snd.play(shift, 0, new SoundTransform(_volume, _pan));
			if (_sndChannel != null)
			{
				FjSnd.channels.push(_sndChannel);
				_sndChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
			else
				FjLog.l("Maximum sound channels count riched");
			
			return this;
		}
		
		/**
		 *
		 * @param	e
		 */
		private function onSoundComplete(e:Event = null):void
		{
			_sndChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			_deleteChannel();
			if (_loop)
				play();
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
				_sndChannel.soundTransform.volume = _volume;
		}
		
		public function get pan():Number
		{
			if (_sndChannel != null)
				return _sndChannel.soundTransform.pan;
			else
				return _pan;
		}
		
		public function set pan(value:Number):void
		{
			_pan = value;
			if (_sndChannel != null)
				_sndChannel.soundTransform.pan = _pan;
		}
	
	}

}