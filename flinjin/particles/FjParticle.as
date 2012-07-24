package flinjin.particles
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flinjin.Flinjin;
	import flinjin.graphics.FjSprite;
	import flinjin.graphics.FjSpriteAnimation;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class FjParticle extends FjSprite
	{
		protected var _timeToLive:Number;
		
		protected var _speedVector:Point;
		
		private var _date:Date = new Date();
		private var _lastTime:Number;
		
		public function FjParticle(spriteBmp:Bitmap, rotationCenter:Point = null, frameSize:Point = null, spriteAnimation:FjSpriteAnimation = null)
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