package flinjin.particles
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flinjin.events.FlinjinSpriteEvent;
	import flinjin.FjObjectPool;
	import flinjin.graphics.FjLayer;
	import flinjin.graphics.FjSprite;
	
	/**
	 * @todo Make an object pool to not create particle every time when emmit needed
	 *
	 * @author Michael Miriti
	 */
	public class FjEmitter extends FjSprite
	{
		/** Classes of particles to emmit **/
		protected var _samples:Array;
		
		/** Emmiting area shape **/
		protected var _emmitRect:Rectangle;
		
		/** Emmited particles **/
		protected var _emmitedParticles:Vector.<FjParticle> = new Vector.<FjParticle>();
		
		/** Count of emmit iterations. -1 for infinitie emmition **/
		protected var _emmitCount:int = -1;
		
		/** Interval between emmiting iterations in milliseconds **/
		protected var _emmitInterval:int;
		
		/** Count of particles to emmit on each iteration **/
		protected var _particlesPerEmmit:int;
		
		protected var _active:Boolean = true;
		
		/** Time left to next emmition **/
		private var _timeUntilNextEmmit:int = 0;
		
		/** Number of done emmit iterations **/
		private var _emmitIterations:Number = 0;
		
		/**
		 * Emitter of the particles
		 *
		 * @param	samples		Classes of the particles to emmit
		 * @param	rect		Rectangle of emmiting area. You can define only size (width and height), x and y will be automaticly set on adding to layer
		 */
		public function FjEmitter(samples:Array, rect:Rectangle)
		{
			super(null);
			_samples = samples;
			_emmitRect = rect;
			addEventListener(FlinjinSpriteEvent.ADDED_TO_LAYER, onAddedToLayer);
		}
		
		private function onAddedToLayer(e:FlinjinSpriteEvent):void
		{
			_setShapeCentre();
		}
		
		/**
		 * Update emmiter
		 *
		 */
		override public function Move(deltaTime:Number):void
		{
			super.Move(deltaTime);
			
			if (_active)
			{
				_prepareParticles();
				if ((_emmitCount == -1) || (_emmitIterations < _emmitCount))
				{
					if (_timeUntilNextEmmit <= 0)
					{
						_timeUntilNextEmmit = _emmitInterval;
						_emmit();
						_emmitIterations++;
					}
					else
					{
						_timeUntilNextEmmit -= deltaTime;
					}
				}
			}
		}
		
		protected function _emmit():void
		{
			for (var i:int = 0; i < _particlesPerEmmit; i++)
			{
				var _newParticleClass:Class = _pickNewParticleClass();
				var _newParticle:FjParticle = FjObjectPool.pull(_newParticleClass) as FjParticle;
				var _newPosition:Point = _pickNewParticlePosition(i);
				_newParticle.setPosition(x + _newPosition.x, y + _newPosition.y);
				_newParticle.speedVector = _pickNewParticleVector(i);
				_emmitedParticles.push(_newParticle);
				(parent as FjLayer).addSprite(_newParticle, null, null, zIndex);
			}
		}
		
		/**
		 * Setting center of the emmiter shape
		 *
		 */
		protected function _setShapeCentre():void
		{
			_emmitRect.x = x;
			_emmitRect.y = y;
		}
		
		/**
		 * Generates speed vector for new created particle. Up by default
		 *
		 * @param	iteration
		 * @return
		 */
		protected function _pickNewParticleVector(iteration:int = 0):Point
		{
			return new Point(0, -1);
		}
		
		/**
		 * Pick class defenition of new created particle
		 *
		 * @return
		 */
		protected function _pickNewParticleClass():Class
		{
			return _samples[Math.floor(Math.random() * _samples.length)];
		}
		
		/**
		 * Count and return position of new emmited particle related to emitter position
		 *
		 * @param	iteration	Number of particle in emmiting set
		 * @return	Point
		 */
		protected function _pickNewParticlePosition(iteration:int = 0):Point
		{
			return new Point(Math.random() * _emmitRect.width, Math.random() * _emmitRect.height);
		}
		
		/**
		 * Prepare particles array before update
		 */
		protected function _prepareParticles():void
		{
			// Deleting dead particles
			for (var i:int = _emmitedParticles.length - 1; i >= 0; i--)
			{
				if (_emmitedParticles[i].timeToLive <= 0)
				{
					var p:FjParticle = _emmitedParticles[i];
					_emmitedParticles.splice(i, 1);
					p.Delete(true);
				}
			}
			
			if ((_emmitIterations >= _emmitCount) && (_emmitedParticles.length == 0) && (_emmitCount != -1))
				Delete(true);
		}
		
		public function emmit():void
		{
			_emmit();
		}
		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function set active(value:Boolean):void
		{
			if ((_active == false) && (value == true))
			{
				_timeUntilNextEmmit = 0;
			}
			_active = value;
		}
	}

}