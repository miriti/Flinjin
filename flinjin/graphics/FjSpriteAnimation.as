package flinjin.graphics
{
	import flash.events.EventDispatcher;
	import flinjin.events.FlinjinSpriteEvent;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class FjSpriteAnimation extends EventDispatcher
	{
		private var _frames:Array;
		private var _name:String;
		private var _sprite:FjSprite = null;
		private var _speed:Number;
		private var _playHead:Number = 0;
		private var _playHeadDirection:int = 1; // 1 for forward, -1 for backward
		private var _playing:Boolean = true;
		private var _animTime:Number = 0;
		private var _yoyo:Boolean = false;
		private var _repeatCount:int;
		
		private var _playsCount:int = 0;
		
		/**
		 * Sprite animation class
		 *
		 * @param	animationName			Defines the name of animation
		 * @param	frames					Specifie array of frames for this animation. null for all frames.
		 * @param	animationSpeed			Time to show each frame of animation in milliseconds
		 * @param	yoyo					Play animation rewind after its reaches last frame
		 * @param	animationRepeatCount	Count of animation repeat. -1 for infinitie
		 */
		public function FjSpriteAnimation(animationName:String = "default", frames:Array = null, animationSpeed:Number = 100, yoyo:Boolean = false, animationRepeatCount:int = -1)
		{
			_name = animationName;
			_frames = frames;
			_speed = animationSpeed;
			_yoyo = yoyo;
			_repeatCount = animationRepeatCount;
		}
		
		/**
		 * Pause animation
		 *
		 */
		public function pause():void
		{
			_playing = false;
		}
		
		/**
		 * Play animation
		 *
		 */
		public function play():void
		{
			_playing = true;
		}
		
		/**
		 * Stop animation
		 *
		 */
		public function stop():void
		{
			pause();
			_playHead = 0;
			_sprite.currentFrame = _frames[_playHead];
		}
		
		/**
		 * Update animation
		 *
		 * @param	deltaTime
		 */
		public function update(deltaTime:Number):void
		{
			if ((_playing) && (null != _sprite))
			{
				if (_sprite.currentFrame != _playHead)
				{
					_sprite.currentFrame = _frames[_playHead];
				}
				
				if (_animTime >= _speed)
				{
					_animTime = _animTime - _speed;
					
					_playHead += _playHeadDirection;
					
					if (_playHead >= _frames.length)
					{
						if (_yoyo)
						{
							_playHead = _frames.length - 2;
							_playHeadDirection = -1;
						}
						else
						{
							_playHead = 0;
							_playsCount++;
							if ((_repeatCount != -1) && (_repeatCount == _playsCount))
							{
								stop();
							}
							dispatchEvent(new FlinjinSpriteEvent(FlinjinSpriteEvent.ANIMATION_FINISHED));
						}
					}
					else if (_playHead < 0)
					{
						if (_yoyo)
						{
							_playHead = 1;
							_playHeadDirection = 1;
							_playsCount++;
							if ((_repeatCount != -1) && (_repeatCount == _playsCount))
							{
								stop();
							}
							dispatchEvent(new FlinjinSpriteEvent(FlinjinSpriteEvent.ANIMATION_FINISHED));
						}
						else
						{
							_playHead = _frames.length - 1;
						}
					}
				}
				else
				{
					_animTime += deltaTime;
				}
			}
		}
		
		/**
		 *
		 */
		public function get sprite():FjSprite
		{
			return _sprite;
		}
		
		public function set sprite(value:FjSprite):void
		{
			if (null == _frames)
			{
				_frames = new Array();
				for (var i:int = 0; i < value.totalFrames; i++)
				{
					_frames[i] = i;
				}
			}
			else
			{
				// more than one frame given
				if (_frames.length > 1)
				{
					// second frame value obove first
					if (_frames[1] > _frames[0])
					{
						// is this is range
						if (_frames[1] - _frames[0] > 1)
						{
							var _frameStart:Number = _frames[0];
							var _frameEnd:Number = _frames[1];
							
							_frames = new Array();
							
							for (var j:int = _frameStart; j <= _frameEnd; j++)
							{
								_frames.push(j);
							}
						}
					}
				}
			}
			
			_sprite = value;
		}
		
		public function get speed():Number
		{
			return _speed;
		}
		
		public function set speed(value:Number):void
		{
			_speed = value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
	
	}

}