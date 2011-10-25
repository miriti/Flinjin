package flinjin.graphics
{
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flinjin.system.FlinjinError;
	
	/**
	 * ...
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class Sprite
	{
		private var _bitmap:Bitmap;
		private var _frames:Array;
		private var _current_bitmap:BitmapData;
		
		private var _spriteWidth:uint;
		private var _spriteHeight:uint;
		private var _spriteRect:Rectangle;
		
		private var _animated:Boolean = false;
		private var _minFrame:uint = 0;
		private var _maxFrame:uint = 0;
		private var _currentFrame:Number = 0;
		private var _frameRate:Number = 1;
		private var _playing:Boolean = true;
		
		private var _globalPosition:Point = new Point();
		private var _centerPoint:Point;
		private var _angle:Number = 0;
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;
		
		private var _matrix:Matrix = new Matrix();
		
		public var _flipHorizontal:Boolean = false;
		public var _flipVertical:Boolean = false;
		
		public var colorTransform:ColorTransform = new ColorTransform();
		public var Drawed:Boolean = false;
		public var Delete:Boolean = false;
		public var zIndex:int = 0;
		public var CollisionEnabled:Boolean = false;
		public var CollisionPixelCheck:Boolean = false;
		public var Interactive:Boolean = false;
		public var MouseOver:Boolean = false;
		
		/**
		 * Base Sprite class constructor
		 * 
		 * @param	spriteBmp	Bitmap containing sprite frame(s)
		 * @param	rotationCenter	Rotation point of sprite
		 * @param	animated	Is sprite animated
		 * @param	frameWidth	Width of animation frame
		 * @param	frameHeight	Height of animation frame
		 * @param	frameRate	Animation speed scale. Defines how many frames of animation passes in one application frame. 1/2 means 1 animation frame per 2 application frames
		 */
		public function Sprite(spriteBmp:Bitmap, rotationCenter:Point = null, animated:Boolean = false, frameWidth:uint = 0, frameHeight:uint = 0, frameRate:Number = 1)
		{
			if (spriteBmp == null)
			{
				spriteBmp = new Bitmap();
			}
			else
			{
				if (!(spriteBmp is Bitmap))
				{
					throw new FlinjinError('Invalid argument type for "spriteBmp": <' + typeof(spriteBmp) + '> must be Bitmap');
					return;
				}
			}
			
			_bitmap = spriteBmp;
			_matrix = new Matrix();
			
			if (rotationCenter == null)
			{
				_centerPoint = new Point(0, 0);
			}
			else
			{
				_centerPoint = rotationCenter;
			}
			
			_animated = animated;
			
			if (animated)
			{
				_spriteWidth = frameWidth;
				_spriteHeight = frameHeight;
				_frameRate = frameRate;
				
				_frames = new Array();
				
				for (var j:uint = 0; j < Math.floor(_bitmap.height / frameHeight); j++)
				{
					for (var i:uint = 0; i < Math.floor(_bitmap.width / frameWidth); i++)
					{
						var _frameData:BitmapData = new BitmapData(frameWidth, frameHeight);
						_frameData.copyPixels(_bitmap.bitmapData, new Rectangle(i * frameWidth, j * frameHeight, frameWidth, frameHeight), new Point(0, 0));
						_frames[_frames.length] = _frameData;
					}
				}
				
				ResetAnimationRegion();
				_current_bitmap = _frames[0];
			}
			else
			{
				_spriteWidth = _bitmap.width;
				_spriteHeight = _bitmap.height;
				_current_bitmap = _bitmap.bitmapData;
			}
			
			_spriteRect = new Rectangle(0, 0, _spriteWidth, _spriteHeight);
		}
	
	}

}