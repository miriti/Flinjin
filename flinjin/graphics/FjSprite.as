package flinjin.graphics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flinjin.events.FlinjinObjectPoolEvent;
	import flinjin.events.FlinjinSpriteEvent;
	import flinjin.FjObjectPool;
	import flinjin.Flinjin;
	import flinjin.FjLog;
	import flinjin.system.FlinjinError;
	import flinjin.types.BoundingShape;
	
	/**
	 * Base Sprite class
	 *
	 * @todo Rename to FlinjinSprtite some day
	 *
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class FjSprite extends EventDispatcher
	{
		private var _repeatX:Boolean = false;
		private var _repeatY:Boolean = false;
		private var _currentFrame:Number = 0;
		
		protected var _angle:Number = 0;
		protected var _animations:Dictionary = new Dictionary();
		protected var _bitmap:Bitmap;
		protected var _blendMode:String = null;
		protected var _center:Point;
		protected var _colorTransform:ColorTransform = new ColorTransform();
		protected var _collisionShape:BoundingShape = null;
		protected var _currentAnimation:FjSpriteAnimation = null;
		protected var _cropRect:Rectangle = null;
		protected var _current_bitmap:BitmapData = null;
		protected var _current_result:BitmapData = null;
		protected var _filters:Array = [];
		protected var _flipHorizontal:Boolean = false;
		protected var _flipVertical:Boolean = false;
		protected var _frames:Array = null;
		protected var _interactive:Boolean = false;
		protected var _matrix:Matrix = new Matrix();
		protected var _mouseOver:Boolean = false;
		protected var _parent:FjLayer = null;
		protected var _pixelCheck:Boolean = false;
		protected var _position:Point = new Point();
		protected var _prevPosition:Point = new Point();
		protected var _spriteSourceWidth:uint;
		protected var _spriteSourceHeight:uint;
		protected var _spriteWidth:uint;
		protected var _spriteHeight:uint;
		protected var _spriteRect:Rectangle;
		protected var _spriteRectTransformed:Rectangle;
		protected var _scaleX:Number = 1;
		protected var _scaleY:Number = 1;
		protected var _visible:Boolean = true;
		
		public var Dynamic:Boolean = true;
		public var Drawed:Boolean = false;
		public var zIndex:int = 0;
		
		public static var Smoothing:Boolean = true;
		public static var SharpBlitting:Boolean = true;
		static public const DRAW_METHOD:int = 0;
		
		/**
		 *
		 * @param	anim
		 * @param	setAsCurrent
		 */
		public function addAnimation(anim:FjSpriteAnimation, setAsCurrent:Boolean = false):void
		{
			anim.sprite = this;
			_animations[anim.name] = anim;
			
			if (setAsCurrent)
			{
				setAnimation(anim);
			}
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
		 * Current animation frame
		 *
		 */
		public function get currentFrame():uint
		{
			return _currentFrame;
		}
		
		public function set currentFrame(val:uint):void
		{
			if (_frames != null)
			{
				if (val < _frames.length)
				{
					_currentFrame = val;
					_current_bitmap = _frames[val];
				}
				else
				{
					FjLog.l(this + ": Frame index [" + val + "] is out of bounds", FjLog.W_ERRO);
				}
			}
			else
			{
				FjLog.l("Sprite <" + this + "> is not animated", FjLog.W_ERRO);
			}
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
			return _spriteWidth * _scaleX;
		}
		
		public function set width(value:Number):void
		{
			_scaleX = value / _spriteWidth;
		}
		
		public function get height():Number
		{
			return _spriteHeight * _scaleY;
		}
		
		public function set height(value:Number):void
		{
			_scaleY = value / _spriteHeight;
		}
		
		public function set center(val:Point):void
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
		
		public function get center():Point
		{
			return _center;
		}
		
		public function get rect():Rectangle
		{
			/*_spriteRectTransformed.copyFrom(_spriteRect);
			_spriteRectTransformed.width = _spriteWidth * _scaleX;
			_spriteRectTransformed.height = _spriteHeight * _scaleY;*/
			return _spriteRect;
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
		
		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function set visible(value:Boolean):void
		{
			_visible = value;
		}
		
		public function get parent():FjLayer
		{
			return _parent;
		}
		
		public function get collisionShape():BoundingShape
		{
			return _collisionShape;
		}
		
		public function get prevPosition():Point
		{
			return _prevPosition;
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
		
		public function get pixelCheck():Boolean
		{
			return _pixelCheck;
		}
		
		public function set pixelCheck(value:Boolean):void
		{
			_pixelCheck = value;
		}
		
		public function get sourceBitmap():Bitmap
		{
			return _bitmap;
		}
		
		public function set sourceBitmap(value:Bitmap):void
		{
			_bitmap = value;
			if (null != _currentAnimation)
				_current_bitmap = _bitmap.bitmapData;
		}
		
		public function set animation(value:FjSpriteAnimation):void
		{
			setAnimation(value);
		}
		
		public function get animation():FjSpriteAnimation
		{
			return _currentAnimation;
		}
		
		public function get interactive():Boolean
		{
			return _interactive;
		}
		
		public function set interactive(value:Boolean):void
		{
			_interactive = value;
		}
		
		public function get blendMode():String
		{
			return _blendMode;
		}
		
		public function set blendMode(value:String):void
		{
			_blendMode = value;
		}
		
		public function get originalHeight():Number
		{
			return _spriteHeight;
		}
		
		public function get originalWidth():Number
		{
			return _spriteWidth;
		}
		
		/**
		 *
		 */
		public function get matrix():Matrix
		{
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
			if ((_scaleX != 1) || (_scaleY != 1))
			{
				_matrix.scale(_scaleX, _scaleY);
			}
			
			// Moving to the place
			if (SharpBlitting)
			{
				_matrix.translate(Math.floor(_position.x), Math.floor(_position.y));
			}
			else
			{
				_matrix.translate(_position.x, _position.y);
			}
			
			_spriteRect.x = _matrix.tx;
			_spriteRect.y = _matrix.ty;
			
			return _matrix;
		}
		
		public function get render():BitmapData
		{
			if ((_filters != null) && (_filters.length > 0))
			{
				for (var i:int = 0; i < _filters.length; i++)
				{
					_current_bitmap.applyFilter(_current_bitmap, _current_bitmap.rect, new Point(0, 0), _filters[i]);
				}
			}
			return _current_bitmap;
		}
		
		/**
		 * Delete sprite form layer
		 *
		 */
		public function Delete(doDispose:Boolean = false):void
		{
			if (_parent != null)
				_parent.deleteSprite(this);
			
			if (doDispose)
				Dispose();
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
		 * Call mouse over method
		 *
		 * @param	localX
		 * @param	localY
		 */
		public function mouseOver(localX:Number, localY:Number):void
		{
			// abstract	
			_mouseOver = true;
		}
		
		public function mouseOut():void
		{
			_mouseOver = false;
		}
		
		/**
		 * If sprite changed position
		 *
		 * @return
		 */
		public function get moved():Boolean
		{
			// TODO can change some flags in setters of x and y maybe..
			return _position.equals(_prevPosition);
		}
		
		public function get filters():Array
		{
			return _filters;
		}
		
		public function set filters(value:Array):void
		{
			_filters = value;
		}
		
		/**
		 * Update action in game sprite
		 *
		 * @param	deltaTime time in milliseconds since last move action
		 */
		public function Move(deltaTime:Number):void
		{
			if (null != _currentAnimation)
			{
				_currentAnimation.update(deltaTime);
			}
			
			_prevPosition.x = _position.x;
			_prevPosition.y = _position.y;
		}
		
		/**
		 * Removw anything about this sprite from memory
		 */
		public function Dispose():void
		{
			if ((FjObjectPool.enabled) && (FjObjectPool.gotPlace()))
			{
				FjObjectPool.put(this);
			}
			else
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
		}
		
		/**
		 * This strange function is basicly divides current deltaTime by Flinjin.frameDalte and returns this value.
		 * Use this value in your Move function to provide FPS independence
		 *
		 * @param	deltaTime
		 * @return
		 */
		protected function r(deltaTime:Number):Number
		{
			return deltaTime / Flinjin.frameDelta;
		}
		
		/**
		 * This function returns the deltaTime's fraction of the second.
		 * For example 500 ms gives 0.5 fraction and 1000 gives 1.0 etc.
		 * @param	deltaTime
		 * @return
		 */
		protected function s(deltaTime:Number):Number
		{
			return deltaTime / 1000;
		}
		
		/**
		 * Set current sprite animation
		 *
		 * @param	anim	Animation id. Can be string name or FjSpriteAnimation instance
		 */
		public function setAnimation(anim:Object):void
		{
			if (anim is String)
			{
				if (null != _animations[anim])
				{
					_currentAnimation = _animations[anim];
				}
			}
			else if (anim is FjSpriteAnimation)
			{
				_currentAnimation = (anim as FjSpriteAnimation);
			}
			else if (anim == null)
			{
				_currentAnimation = null;
			}
			else
			{
				FjLog.l("Connot set <" + anim + "> as animation", FjLog.W_ERRO);
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
		public function setCenter(newCX:Number = NaN, newCY:Number = NaN):FjSprite
		{
			if (isNaN(newCX))
				newCX = width / 2;
			if (isNaN(newCY))
				newCY = height / 2;
			_center.x = newCX;
			_center.y = newCY;
			_spriteRect.x = _position.x - newCX;
			_spriteRect.y = _position.y - newCY;
			
			return this;
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
		public function addPositionVector(v:Point, w:Number = 1):void
		{
			x += v.x * w;
			y += v.y * w;
		}
		
		/**
		 *
		 * @param	spriteBmp
		 * @param	rotationCenter
		 * @param	frameSize
		 * @param	spriteAnimation
		 */
		protected function _initSprite(spriteBmp:Bitmap, rotationCenter:Point = null, frameSize:Point = null, spriteAnimation:FjSpriteAnimation = null):void
		{
			_bitmap = spriteBmp;
			_matrix = new Matrix();
			
			center = rotationCenter;
			
			if ((null != frameSize) && (null != spriteBmp))
			{
				if ((_bitmap.width % frameSize.x != 0) || (_bitmap.height % frameSize.y != 0))
				{
					throw new FlinjinError('Frame size does not fits Bitmap size');
					return;
				}
				
				_spriteWidth = frameSize.x;
				_spriteSourceWidth = frameSize.x;
				
				_spriteHeight = frameSize.y;
				_spriteSourceHeight = frameSize.y;
				
				_frames = new Array();
				
				for (var j:uint = 0; j < Math.floor(_bitmap.height / frameSize.y); j++)
				{
					for (var i:uint = 0; i < Math.floor(_bitmap.width / frameSize.x); i++)
					{
						var _frameData:BitmapData = new BitmapData(frameSize.x, frameSize.y);
						_frameData.copyPixels(_bitmap.bitmapData, new Rectangle(i * frameSize.x, j * frameSize.y, frameSize.x, frameSize.y), new Point(0, 0));
						_frames[_frames.length] = _frameData;
					}
				}
				
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
			
			if (spriteAnimation != null)
			{
				addAnimation(spriteAnimation, true);
			}
			
			if (null != spriteBmp)
				_current_result = _current_bitmap.clone();
			
			_spriteRect = new Rectangle(-_center.x, -_center.y, _spriteWidth, _spriteHeight);
			_spriteRectTransformed = _spriteRect.clone();
		}
		
		/**
		 * Creates new raster sprite
		 *
		 * @param	spriteBmp
		 * @param	rotationCenter
		 * @param	frameSize
		 * @param	spriteAnimation
		 */
		public function FjSprite(spriteBmp:Bitmap, rotationCenter:Point = null, frameSize:Point = null, spriteAnimation:FjSpriteAnimation = null)
		{
			_initSprite(spriteBmp, rotationCenter, frameSize, spriteAnimation);
			addEventListener(FlinjinSpriteEvent.ADDED_TO_LAYER, onAddedToLayer);
			addEventListener(FlinjinObjectPoolEvent.RESTORE, restore);
		}
		
		/**
		 * This method triggers when sprite is restored from Object Pool
		 *
		 * @param	e	FlinjinObjectPoolEvent instance
		 */
		protected function restore(e:FlinjinObjectPoolEvent = null):void
		{
		}
		
		private function onAddedToLayer(e:FlinjinSpriteEvent):void
		{
			_parent = (e.interactionSprite as FjLayer);
		}
	}

}