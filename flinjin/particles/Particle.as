package flinjin.particles
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flinjin.Flinjin;
	import flinjin.graphics.Sprite;
	import flinjin.graphics.SpriteAnimation;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class Particle extends Sprite
	{
		protected var _timeToLive:Number;
		
		protected var _speedVector:Point;
		
		private var _date:Date = new Date();
		private var _lastTime:Number;
		
		public function Particle(spriteBmp:Bitmap, rotationCenter:Point = null, frameSize:Point = null, spriteAnimation:SpriteAnimation = null)
		{
			super(spriteBmp, rotationCenter, frameSize, spriteAnimation);
			_lastTime = _date.getTime();
			setCenterInBitmapCenter();
		}
		
		override public function Move(deltaTime:Number):void
		{
			x += speedVector.x * r(deltaTime);
			y += speedVector.y * r(deltaTime);
			super.Move(deltaTime);
			_timeToLive -= deltaTime;
		}
		
		public function get timeToLive():Number
		{
			return _timeToLive;
		}
		
		public function get speedVector():Point
		{
			return _speedVector;
		}
		
		public function set speedVector(value:Point):void
		{
			_speedVector = value;
		}
	
	}

}