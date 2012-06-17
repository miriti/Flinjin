package flinjin.graphics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.drm.AuthenticationMethod;
	import flash.utils.Dictionary;
	import flinjin.events.FlinjinSpriteEvent;
	import flinjin.Flinjin;
	import flinjin.motion.Motion;
	import flinjin.system.FlinjinError;
	import flinjin.types.BoundingShape;
	
	/**
	 * Base Sprite class
	 * 
	 * @todo Rename to FlinjinSprtite some day
	 *
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class Sprite extends EventDispatcher
	{
		protected var _bitmap:Bitmap;
		protected var _frames:Array = null;
		protected var _current_bitmap:BitmapData = null;
		protected var _current_result:BitmapData = null;
		protected var _lastDrawedBitmap:BitmapData = null;
		protected var _name:String = "untitled sprite";
		
		private var _spriteSourceWidth:uint;
		private var _spriteSourceHeight:uint;
		private var _spriteWidth:uint;
		private var _spriteHeight:uint;
		private var _spriteRect:Rectangle;
		private var _repeatX:Boolean = false;
		private var _repeatY:Boolean = false;
		private var _namedAnimationRegions:Dictionary = new Dictionary();
		private var _currentRegion:String = null;
		private var _animated:Boolean = false;
		private var _minFrame:uint = 0;
		private var _maxFrame:uint = 0;
		private var _currentFrame:Number = 0;
		private var _frameRate:Number = 1;
		private var _playing:Boolean = true;
		private var _collisionShape:BoundingShape = null;
		
		protected var _prevPosition:Point = new Point();
		protected var _position:Point = new Point();
		protected var _center:Point;
		protected var _angle:Number = 0;
		protected var _scale:Number = 1;
		protected var _scaleX:Number = 1;
		protected var _scaleY:Number = 1;
		protected var _scroll:Point = new Point(0, 0);
		protected var _visible:Boolean = true;
		protected var _matrix:Matrix = new Matrix();
		protected var _colorTransform:ColorTransform = new ColorTransform();
		protected var _flipHorizontal:Boolean = false;
		protected var _flipVertical:Boolean = false;
		protected var _pixelCheck:Boolean = false;
		
		protected var _motion:Motion = null;
		
		public var Dynamic:Boolean = true;
		public var Drawed:Boolean = false;
		public var DeleteFlag:Boolean = false;
		public var zIndex:int = 0;
		public var Interactive:Boolean = true;
		public var MouseOver:Boolean = false;
		
		public static var Smoothing:Boolean = true;
		public static var SharpBlitting:Boolean = true;
		
		protected var _parentSprite:Sprite = null;
		
		private function _resizeCanvas(newW:uint, newH:uint):BitmapData
		{
			var newBmp:BitmapData = new BitmapData(newW, newH);
			newBmp.draw(_current_result);
			_current_result = newBmp;
			return _current_result
		}
		
		/**
		 * Rotation angle around center point
		 */
		public function set angle(val:Number):void
		{
			_angle = val;
		}
		
		public function get angle():Number
		{
			return _angle;
		}
		
		/**
		 * Alpha channel multiplyer
		 *
		 */
		public function set alpha(val:Number):void
		{
			_colorTransform.alphaMultiplier = val;
		}
		
		public function get alpha():Number
		{
			return _colorTransform.alphaMultiplier;
		}
		
		/**
		 * Color transform of the sprite
		 *
		 */
		public function set color(val:uint):void
		{
			_colorTransform.color = val;
		}
		
		public function get color():uint
		{
			return _colorTransform.color;
		}
		
		/**
		 * Current animation named range
		 *
		 */
		public function set currentAnimation(val:String):void
		{
			for each (var o:Object in _namedAnimationRegions)
			{
				if (o['name'] == val)
				{
					setNamedAnimationRegion(val);
					return;
				}
			}
			
			throw new FlinjinError("Animation not found in list <" + val + ">");
		}
		
		public function get currentAnimation():String
		{
			return _currentRegion;
		}
		
		/**
		 * Current animation frame
		 *
		 */
		public function get currentFrame():uint
		{
			return _currentFrame;
		}
		
		public function set currentFrame(val:uint):void
		{
			_currentFrame = val;
			_current_bitmap = _frames[val];
		}
		
		public function get totalFrames():uint
		{
			if (_frames != null)
			{
				return _frames.length;
			}
			else
			{
				return 0;
			}
		}
		
		public function set y(val:Number):void
		{
			_spriteRect.y = val - _center.x;
			if (_collisionShape != null)
				_collisionShape.y = val;
			
			_position.y = val;
		}
		
		public function get y():Number
		{
			return _position.y;
		}
		
		public function set x(val:Number):void
		{
			_spriteRect.x = val - _center.x;
			if (_collisionShape != null)
				_collisionShape.x = val;
			_position.x = val;
		}
		
		public function get x():Number
		{
			return _position.x;
		}
		
		public function get width():Number
		{
			return _spriteWidth;
		}
		
		public function set width(value:Number):void
		{
			if (value != _spriteWidth)
			{
				_spriteWidth = value;
				_resizeCanvas(value, _spriteHeight);
			}
		}
		
		public function get height():Number
		{
			return _spriteHeight;
		}
		
		public function set height(value:Number):void
		{
			if (value != _spriteHeight)
			{
				_spriteHeight = value;
				_resizeCanvas(_spriteWidth, value);
			}
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
		
		public function get Paused():Boolean
		{
			return _animated;
		}
		
		public function get position():Point
		{
			return _position;
		}
		
		public function get colorTransform():ColorTransform
		{
			return _colorTransform;
		}
		
		public function set colorTransform(value:ColorTransform):void
		{
			_colorTransform = value;
		}
		
		public function get Visible():Boolean
		{
			return _visible;
		}
		
		public function set Visible(value:Boolean):void
		{
			_visible = value;
		}
		
		public function get parent():Sprite
		{
			return _parentSprite;
		}
		
		public function get collisionShape():BoundingShape
		{
			return _collisionShape;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get prevPosition():Point
		{
			return _prevPosition;
		}
		
		public function get repeatX():Boolean
		{
			return _repeatX;
		}
		
		public function set repeatX(value:Boolean):void
		{
			_repeatX = value;
		}
		
		public function get repeatY():Boolean
		{
			return _repeatY;
		}
		
		public function set repeatY(value:Boolean):void
		{
			_repeatY = value;
		}
		
		public function get scrollX():Number
		{
			return _scroll.x;
		}
		
		public function set scrollX(value:Number):void
		{
			if (value < 0)
				value = _spriteWidth + value;
			if (value >= _spriteWidth)
				value = value - _spriteWidth;
			_scroll.x = value;
		}
		
		public function get scrollY():Number
		{
			return _scroll.y;
		}
		
		public function set scrollY(value:Number):void
		{
			if (value < 0)
				value = _spriteHeight + value;
			if (value >= _spriteHeight)
				value = value - _spriteHeight;
			_scroll.y = value;
		}
		
		public function get flipHorizontal():Boolean
		{
			return _flipHorizontal;
		}
		
		public function set flipHorizontal(value:Boolean):void
		{
			_flipHorizontal = value;
		}
		
		public function get flipVertical():Boolean
		{
			return _flipVertical;
		}
		
		public function set flipVertical(value:Boolean):void
		{
			_flipVertical = value;
		}
		
		public function get lastDrawedBitmap():BitmapData
		{
			return _lastDrawedBitmap;
		}
		
		public function get motion():Motion
		{
			return _motion;
		}
		
		public function set motion(value:Motion):void
		{
			_motion = value;
		}
		
		/**
		 * Determinates the pixelCheck for interactions
		 */
		public function get pixelCheck():Boolean 
		{
			return _pixelCheck;
		}
		
		public function set pixelCheck(value:Boolean):void 
		{
			_pixelCheck = value;
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
		
		/**
		 * Pause animation
		 *
		 */
		public function PauseAnimation():void
		{
			_animated = false;
		}
		
		/**
		 * Creating new Sprite object from frame bitmap data
		 *
		 * @param	frameNumber
		 * @param	rotationPoint
		 * @return
		 */
		public function CreateSpriteFromFrame(frameNumber:uint, rotationPoint:Point = null):Sprite
		{
			if (rotationPoint == null)
			{
				rotationPoint = new Point();
			}
			
			return new Sprite(getBitmapAtFrame(frameNumber), rotationPoint);
		}
		
		/**
		 * Get bitmap from specified frame
		 *
		 * @param	frameNumber
		 * @return
		 */
		public function getBitmapAtFrame(frameNumber:uint):Bitmap
		{
			if (frameNumber <= _frames.length - 1)
			{
				return new Bitmap(_frames[frameNumber]);
			}
			else
			{
				throw new FlinjinError('frame number is out of range of frames: ' + frameNumber);
			}
		}
		
		/**
		 * Creating name animation region
		 *
		 * @param	name
		 * @param	frameStart
		 * @param	frameEnd
		 * @return
		 */
		public function addNamedAnimationRegion(name:String, frameStart:uint, frameEnd:uint):AnimationNamedRegion
		{
			var newRegion:AnimationNamedRegion = new AnimationNamedRegion(frameStart, frameEnd);
			_namedAnimationRegions[name] = newRegion;
			return newRegion;
		}
		
		/**
		 * Set current animation min and max frame from named animation region
		 *
		 * @param	name
		 */
		public function setNamedAnimationRegion(name:String):void
		{
			var o:AnimationNamedRegion;
			if ((o = _namedAnimationRegions[name]) != null)
			{
				_minFrame = o.start;
				_maxFrame = o.end;
				_currentRegion = name;
				_currentFrame = _minFrame;
			}
		}
		
		/**
		 * Set center of sprite in it's bitmap (or frame) center
		 * 
		 */
		public function setCenterInBitmapCenter():void
		{
			setCenter(width / 2, height / 2);
		}
		
		/**
		 * If sprite changed position
		 *
		 * @return
		 */
		public function Moved():Boolean
		{
			// TODO can change some flags in setters of x and y maybe..
			return _position.equals(_prevPosition);
		}
		
		/**
		 * Updating sprite properties
		 *
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
			_prevPosition.x = _position.x;
			_prevPosition.y = _position.y;
			
			if (_motion != null)
			{
				_motion.Update();
				_position = _motion.currentPoint;
			}
		}
		
		/**
		 * Reset animation region to 0 .. _frames.length
		 *
		 */
		public function ResetAnimationRegion():void
		{
			_minFrame = 0;
			_maxFrame = _frames.length - 1;
			_currentRegion = null;
		}
		
		/**
		 * Actual draw of sprite
		 *
		 * Wrap of protected method _Draw
		 *
		 * @param	surface
		 * @param	shiftVector
		 */
		public function Draw(surface:BitmapData, shiftVector:Point = null, innerScale:Number = 1):void
		{
			_Draw(surface, shiftVector, innerScale);
		}
		
		/**
		 * Removw anything about this sprite from memory
		 */
		public function Dispose():void
		{
			if (_bitmap != null)
				_bitmap.bitmapData.dispose();
			if (_current_bitmap != null)
				_current_bitmap.dispose();
			if (_current_result != null)
				_current_result.dispose();
			
			if (_frames != null)
			{
				for (var i:int = 0; i < _frames.length; i++)
				{
					if (_frames[i] != null)
						(_frames[i] as BitmapData).dispose();
				}
			}
		}
		
		/**
		 * Checks is point not transporent
		 *
		 * @param	p Point
		 * @return Boolean True is this is non transporent pixel, false otherwise.
		 */
		public function PointPixelCheck(p:Point):Boolean
		{
			if (p != null)
			{
				if ((p.x < width) && (p.y < height) && (p.x >= 0) && (p.y >= 0))
				{
					var pixel:uint = _current_bitmap.getPixel(p.x, p.y);
					return true;
				}
				else
				{
					throw new FlinjinError("Point is out of sprite");
				}
			}
			else
			{
				throw new FlinjinError("Point must not be null");
			}
			
			return false;
		}
		
		/**
		 * Draw sprite on the surface with all transformations
		 *
		 * @param	surface
		 */
		protected function _Draw(surface:BitmapData, shiftVector:Point = null, innerScale:Number = 1):void
		{
			if ((null != _current_bitmap) && (null != _current_result))
			{
				// nothing to do if visible is false
				if (false == Visible)
					return;
				
				// nothing to do is scale is zero
				if (0 == _scale)
					return;
				
				// absolutly transporent
				if (0 == _colorTransform.alphaMultiplier)
					return;
				
				//
				var _bitmapToDraw:BitmapData = _current_bitmap;
				
				// tiling/repeating sprite
				if ((_scroll.x != 0) || (_scroll.y != 0))
				{
					var _rpX:uint = _repeatX ? Math.ceil(_spriteSourceWidth / _current_bitmap.width) + 1 : 1;
					var _rpY:uint = _repeatY ? Math.ceil(_spriteSourceHeight / _current_bitmap.height) + 1 : 1;
					var _tmpMatrix:Matrix = new Matrix();
					
					_current_result.fillRect(_current_result.rect, 0x00000000);
					
					for (var j:int = 0; j < _rpY; j++)
					{
						if (_rpY == 1)
							_tmpMatrix.ty = 0;
						else
						{
							_tmpMatrix.ty = -_spriteHeight + _scroll.y + (j * _spriteHeight);
							
							if (SharpBlitting)
								_tmpMatrix.ty = Math.floor(_tmpMatrix.ty);
						}
						
						for (var i:int = 0; i < _rpX; i++)
						{
							if (_rpX == 1)
								_tmpMatrix.tx = 0;
							else
							{
								_tmpMatrix.tx = -_spriteWidth + _scroll.x + (i * _spriteWidth);
								
								if (SharpBlitting)
									_tmpMatrix.tx = Math.floor(_tmpMatrix.tx);
							}
							
							_current_result.draw(_current_bitmap, _tmpMatrix);
						}
					}
					
					_bitmapToDraw = _current_result;
				}
				
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
				if (0 != _angle)
				{
					_matrix.rotate(_angle);
				}
				
				// Scaling
				if ((_scaleX != 1) || (_scaleY != 1) || (_scale != 1))
				{
					_matrix.scale(_scaleX * _scale, _scaleY * _scale);
				}
				
				if (innerScale != 1)
					_matrix.scale(innerScale, innerScale);
				
				if (shiftVector != null)
				{
					if (SharpBlitting)
					{
						shiftVector.x = Math.floor(shiftVector.x);
						shiftVector.y = Math.floor(shiftVector.y);
					}
					
					_matrix.translate(shiftVector.x, shiftVector.y);
				}
				
				// Moving to the place
				if (SharpBlitting)
				{
					_matrix.translate(Math.floor(_position.x * innerScale), Math.floor(_position.y * innerScale));
				}
				else
				{
					_matrix.translate(_position.x * innerScale, _position.y * innerScale);
				}
				
				surface.draw(_bitmapToDraw, _matrix, _colorTransform, null, null, Smoothing);
				_lastDrawedBitmap = _bitmapToDraw;
				
				if ((_collisionShape != null) && (Flinjin.Debug))
				{
					_collisionShape.DebugDraw(surface, shiftVector);
				}
				
				_spriteRect.x = _matrix.tx;
				_spriteRect.y = _matrix.ty;
			}
		}
		
		/**
		 * Sets bounding shape for this sprite
		 * 
		 * @param	boundingShape BoundingShape or null if you need to disable collisions for this sprite
		 * @return
		 */
		public function setBoundingShape(boundingShape:BoundingShape):BoundingShape
		{
			if (boundingShape != null)
			{
				_collisionShape = boundingShape;
			}
			
			return boundingShape;
		}
		
		/**
		 * Set new center for sprite
		 *
		 * @param	newCX
		 * @param	newCY
		 */
		public function setCenter(newCX:Number, newCY:Number):void
		{
			_center.x = newCX;
			_center.y = newCY;
		}
		
		/**
		 * Set new possition for sprite
		 *
		 * @param	newX
		 * @param	newY
		 */
		public function setPosition(newX:Number, newY:Number):void
		{
			x = newX;
			y = newY;
		}
		
		/**
		 * Add vector to the position
		 *
		 * @param	v
		 */
		public function addPositionVector(v:Point):void
		{
			x += v.x;
			y += v.y;
		}
		
		/**
		 *
		 * @param	spriteBmp
		 * @param	rotationCenter
		 * @param	animated
		 * @param	frameWidth
		 * @param	frameHeight
		 * @param	frameRate
		 */
		protected function _initSprite(spriteBmp:Bitmap, rotationCenter:Point = null, animated:Boolean = false, frameWidth:uint = 0, frameHeight:uint = 0, frameRate:Number = 1):void
		{
			if ((!(spriteBmp is Bitmap)) && (null != spriteBmp))
			{
				throw new FlinjinError('Invalid argument type for "spriteBmp": <' + typeof(spriteBmp) + '> must be Bitmap');
				return;
			}
			
			_bitmap = spriteBmp;
			_matrix = new Matrix();
			
			Center = rotationCenter;
			
			_animated = animated;
			
			if ((animated) && (null != spriteBmp))
			{
				if ((_bitmap.width % frameWidth != 0) || (_bitmap.height % frameHeight != 0))
				{
					throw new FlinjinError('Frame size does not fits Bitmap size');
					return;
				}
				
				_spriteWidth = frameWidth;
				_spriteSourceWidth = frameWidth;
				
				_spriteHeight = frameHeight;
				_spriteSourceHeight = frameHeight;
				
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
				if (_bitmap != null)
				{
					_spriteWidth = _bitmap.width;
					_spriteSourceWidth = _bitmap.width;
					
					_spriteHeight = _bitmap.height;
					_spriteSourceHeight = _bitmap.height;
					
					_current_bitmap = _bitmap.bitmapData;
				}
				else
				{
					_spriteWidth = 0;
					_spriteHeight = 0;
					_current_bitmap = null;
				}
			}
			
			if (null != spriteBmp)
				_current_result = _current_bitmap.clone();
			
			_spriteRect = new Rectangle(-_center.x, -_center.y, _spriteWidth, _spriteHeight);
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
			_initSprite(spriteBmp, rotationCenter, animated, frameWidth, frameHeight, frameRate);
			addEventListener(FlinjinSpriteEvent.ADDED_TO_LAYER, onAddedToLayer);
		}
		
		private function onAddedToLayer(e:FlinjinSpriteEvent):void
		{
			_parentSprite = e.interactionSprite;
		}
	}

}

class AnimationNamedRegion
{
	private var _start:uint;
	private var _end:uint;
	
	function AnimationNamedRegion(newStart:uint, newEnd:uint)
	{
		_start = newStart;
		_end = newEnd;
	}
	
	public function get start():uint
	{
		return _start;
	}
	
	public function get end():uint
	{
		return _end;
	}
}