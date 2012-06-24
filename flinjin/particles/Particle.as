package flinjin.particles
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flinjin.Flinjin;
	import flinjin.graphics.Sprite;
	
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
		
		public function Particle(spriteBmp:Bitmap, rotationCenter:Point = null, animated:Boolean = false, frameWidth:uint = 0, frameHeight:uint = 0, frameRate:Number = 1)
		{
			super(spriteBmp, rotationCenter, animated, frameWidth, frameHeight, frameRate);
			_lastTime = _date.getTime();
			setCenterInBitmapCenter();
		}
		
		override public function Move(deltaTime:Number):void
		{
			x += speedVector.x;
			y += speedVector.y;
			super.Move(deltaTime);
			_timeToLive -= 1000 / Flinjin.frameRate;
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