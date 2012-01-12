package flinjin.sound
{
	import flash.media.Sound;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class FlinjinSound extends Object
	{
		
		public static var Sounds:Array;
		
		public static function playSound(name:String):void
		{
			for (var i:int = 0; i < Sounds.length; i++) 
			{
				if (SoundItem(Sounds[i]).Name == name) {
					SoundItem(Sounds[i]).Play();
				}
			}
		}
		
		public static function addSound(sndObject:Sound, name:String, looping:Boolean = false):Boolean
		{
			if (Sounds == null)
			{
				Sounds = new Array();
			}
			
			for (var i:int = 0; i < Sounds.length; i++)
			{
				if (SoundItem(Sounds[i]).Name == name)
				{
					return false;
				}
			}
			
			Sounds[Sounds.length] = new SoundItem(name, sndObject, looping);
			
			return true;
		}
	
	}

}

import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;

class SoundItem
{
	public var Name:String;
	public var Snd:Sound;
	public var Loop:Boolean = false;
	
	private var _soundChannel:SoundChannel;
	
	public function Play():void
	{
		_soundChannel = Snd.play();
		_soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
	}
	
	public function Stop():void {
		_soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
		_soundChannel.stop();
	}
	
	private function onSoundComplete(e:Event):void 
	{
		if (Loop) {
			Play();
		}
	}
	
	public function SoundItem(newName:String, newSnd:Sound, isLoop:Boolean)
	{
		Name = newName;
		Snd = newSnd;
		Loop = isLoop;
	}
}