package flinjin.particles
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flinjin.events.FlinjinSpriteEvent;
	import flinjin.graphics.Layer;
	import flinjin.graphics.Sprite;
	
	/**
	 * @todo Make an object pool to not create particle every time when emmit needed
	 *
	 * @author Michael Miriti
	 */
	public class Emitter extends Sprite
	{
		/** Classes of particles to emmit **/
		protected var _samples:Array;
		
		/** Emmiting area shape **/
		protected var _emmitRect:Rectangle;
		
		/** Emmited particles **/
		protected var _emmitedParticles:Vector.<Particle> = new Vector.<Particle>();
		
		/** Count of emmit iterations. -1 for infinitie emmition **/
		protected var _emmitCount:int = -1;
		
		/** Interval between emmiting iterations in milliseconds **/
		protected var _emmitInterval:int;
		
		/** Count of particles to emmit on each iteration **/
		protected var _particlesPerEmmit:int;
		
		private var _lastTimestamp:uint = 0;
		private var _timeSinceLastEmmit:int = 0;
		private var _emmitIterations:Number = 0;
		
		/**
		 * Emitter of the particles
		 *
		 * @param	samples		Classes of the particles to emmit
		 * @param	rect		Rectangle of emmiting area. You can define only size (width and height), x and y will be automaticly set on adding to layer
		 */
		public function Emitter(samples:Array, rect:Rectangle)
		{			
			super(null);
			var _date:Date = new Date();
			_samples = samples;
			_emmitRect = rect;
			_lastTimestamp = _date.getTime();
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
		override public function Move():void
		{
			var _date:Date = new Date();
			_prepareParticles();
			
			super.Move();
			
			if ((_emmitCount == -1) || (_emmitIterations < _emmitCount))
			{
				if (_timeSinceLastEmmit <= 0)
				{
					_timeSinceLastEmmit = _emmitInterval;
					for (var i:int = 0; i < _particlesPerEmmit; i++)
					{
						var _newParticleClass:Class = _pickNewParticleClass();
						var _newParticle:Particle = new _newParticleClass() as Particle;
						var _newPosition:Point = _pickNewParticlePosition(i);
						_newParticle.setPosition(x + _newPosition.x, y + _newPosition.y);
						_newParticle.speedVector = _pickNewParticleVector(i);
						_emmitedParticles.push(_newParticle);
						(parent as Layer).addSprite(_newParticle, null, null, zIndex);
					}
					_emmitIterations++;
				}
				else
				{
					_timeSinceLastEmmit -= _date.getTime() - _lastTimestamp;
					_lastTimestamp = _date.getTime();
				}
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
					_emmitedParticles[i].Delete();
					if (_emmitedParticles.length > 1)
						_emmitedParticles[i] = _emmitedParticles.pop();
					else
						_emmitedParticles.pop();
				}
			}
			
			if ((_emmitIterations >= _emmitCount) && (_emmitedParticles.length == 0) && (_emmitCount != -1))
				Delete();
		}
	}

}