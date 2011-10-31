package flinjin.graphics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flinjin.events.FlinjinSpriteEvent;
	import flinjin.system.FlinjinError;
	
	/**
	 * Base Sprite class
	 *
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class Sprite extends EventDispatcher
	{
		private var _bitmap:Bitmap;
		private var _frames:Array;
		private var _current_bitmap:BitmapData;
		
		private var _spriteWidth:uint;
		private var _spriteHeight:uint;
		private var _spriteRect:Rectangle;
		
		private var _namedAnimationRegions:Array = new Array();
		private var _currentRegion:String = null;
		
		private var _animated:Boolean = false;
		private var _minFrame:uint = 0;
		private var _maxFrame:uint = 0;
		private var _currentFrame:Number = 0;
		private var _frameRate:Number = 1;
		private var _playing:Boolean = true;
		
		private var _position:Point = new Point();
		private var _center:Point;
		private var _angle:Number = 0;
		private var _scale:Number = 1;
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;
		
		private var _matrix:Matrix = new Matrix();
		
		private var _colorTransform:ColorTransform = new ColorTransform();
		
		public var _flipHorizontal:Boolean = false;
		public var _flipVertical:Boolean = false;
		
		public var Visible:Boolean = true;
		
		public var Drawed:Boolean = false;
		public var DeleteFlag:Boolean = false;
		public var zIndex:int = 0;
		public var CollisionEnabled:Boolean = false;
		public var CollisionPixelCheck:Boolean = false;
		public var Interactive:Boolean = false;
		public var MouseOver:Boolean = false;
		
		public function set angle(val:Number):void
		{
			_angle = val;
		}
		
		public function get angle():Number
		{
			return _angle;
		}
		
		public function set alpha(val:Number):void
		{
			_colorTransform.alphaMultiplier = val;
		}
		
		public function get alpha():Number
		{
			return _colorTransform.alphaMultiplier;
		}
		
		public function set color(val:uint):void
		{
			_colorTransform.color = val;
		}
		
		public function get color():uint
		{
			return _colorTransform.color;
		}
		
		public function set currentAnimation(val:String):void {
			for each(var o:Object in _namedAnimationRegions) {
				if (o['name'] == val) {
					setNamedAnimationRegion(val);
					return;
				}
			}
			
			throw new FlinjinError("Animation not found in list <" + val + ">");
		}
		
		public function get currentAnimation():String {
			return _currentRegion;
		}
		
		public function set y(val:Number):void
		{
			_spriteRect.y = val;
			_position.y = val;
		}
		
		public function get y():Number
		{
			return _position.y;
		}
		
		public function set x(val:Number):void
		{
			_spriteRect.x = val;
			_position.x = val;
		}
		
		public function get x():Number
		{
			return _position.x;
		}
		
		public function set width(val:Number):void
		{
		
		}
		
		public function get width():Number
		{
			return _spriteRect.width;
		}
		
		public function set height(val:Number):void
		{
		
		}
		
		public function get height():Number
		{
			return _spriteRect.height;
		}
		
		public function set CurrentBitmap(val:BitmapData):void
		{
			_current_bitmap = val;
			_spriteRect.width = val.width;
			_spriteRect.height = val.height;
		}
		
		public function get CurrentBitmap():BitmapData
		{
			return _current_bitmap;
		}
		
		public function set Center(val:Point):void
		{
			if (val != null)
			{
				_center = val;
			}
			else
			{
				_center = new Point();
			}
		}
		
		public function get Center():Point
		{
			return _center;
		}
		
		public function set scale(val:Number):void
		{
			_scale = val;
		}
		
		public function get scale():Number
		{
			return _scale;
		}
		
		public function get rect():Rectangle
		{
			return _spriteRect;
		}
		
		/**
		 * Mark this sprite for deletion
		 *
		 */
		public function Delete():void
		{
			DeleteFlag = true;
		}
		
		/**
		 * Gettting private property _matrix to read
		 *
		 * @return
		 */
		public function getMatrix():Matrix
		{
			return _matrix;
		}
		
		/**
		 * Start or resume playing animation
		 */
		public function PlayAnimation():void
		{
			_animated = true;
		}
		
		/**
		 * Stop playing animation
		 */
		public function StopAnimation():void
		{
			_animated = false;
			_currentFrame = _minFrame;
		}
		
		public function PauseAnimation():void
		{
			_animated = false;
		}
		
		/**
		 * Creating name animation region
		 * @param	name
		 * @param	frameStart
		 * @param	frameEnd
		 * @return
		 */
		public function addNamedAnimationRegion(name:String, frameStart:uint, frameEnd:uint):Object
		{
			var newRegion:Object = new Object();
			newRegion['name'] = name;
			newRegion['start'] = frameStart;
			newRegion['end'] = frameEnd;
			_namedAnimationRegions[_namedAnimationRegions.length] = newRegion;
			
			return newRegion;
		}
		
		/**
		 *
		 * @param	name
		 */
		private function setNamedAnimationRegion(name:String):void
		{
			for each (var o:Object in _namedAnimationRegions)
			{
				if (o['name'] == name)
				{
					_minFrame = o['start'];
					_maxFrame = o['end'];
					_currentRegion = name;
					_currentFrame = _minFrame;
				}
			}
		}
		
		/**
		 * Updating animation state if sprite is animated
		 */
		public function Move():void
		{
			if (_animated)
			{
				_current_bitmap = _frames[Math.floor(_currentFrame)];
				
				if (_playing)
				{
					_currentFrame += _frameRate;
					if (Math.floor(_currentFrame) > _maxFrame)
					{
						_currentFrame = _minFrame;
						dispatchEvent(new Event(FlinjinSpriteEvent.ANIMATION_FINISHED));
					}
				}
			}
		}
		
		/**
		 * Reset animation region to 0 .. _frames.length
		 */
		public function ResetAnimationRegion():void
		{
			_minFrame = 0;
			_maxFrame = _frames.length - 1;
			_currentRegion = null;
		}
		
		/**
		 * Draw sprite on the surface with all transformations
		 *
		 * @param	surface
		 */
		public function Draw(surface:BitmapData):void
		{
			// nothing to do if visible is false
			if (!Visible)
				return;
			
			// nothing to do is scale is zero
			if (_scale == 0)
				return;
			
			// Loading matrix indentity
			_matrix.identity();
			
			// Flipping if necessery
			if (_flipHorizontal)
			{
				_matrix.scale(-1, 1);
				_matrix.translate(_spriteWidth, 0);
			}
			
			if (_flipVertical)
			{
				_matrix.scale(1, -1);
				_matrix.translate(0, _spriteHeight);
			}
			
			// Moving to center
			_matrix.translate(-_center.x, -_center.y);
			
			// Rotation
			if (_angle != 0)
			{
				_matrix.rotate(_angle);
			}
			
			// Scaling
			if ((_scaleX != 1) || (_scaleY != 1) || (_scale != 1))
			{
				_matrix.scale(_scaleX * _scale, _scaleY * _scale);
			}
			
			// Moving to the place
			_matrix.translate(_position.x, _position.y);
			
			// Actual draw
			if (_current_bitmap is IBitmapDrawable) // dunno why it is here...
			{
				surface.draw(_current_bitmap, _matrix, _colorTransform, null, null, true);
			}
			
			_spriteRect.left = _matrix.tx;
			_spriteRect.top = _matrix.ty;
		}
		
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
			
			Center = rotationCenter;
			
			_animated = animated;
			
			if (animated)
			{
				if ((_bitmap.width % frameWidth != 0) || (_bitmap.height % frameHeight != 0))
				{
					throw new FlinjinError('Frame size does not fits Bitmap size');
					return;
				}
				
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