package flinjin.graphics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flinjin.Flinjin;
	import flinjin.graphics.PostEffects.PostEffect;
	import flinjin.input.Input;
	
	/**
	 * Main render unit
	 *
	 * !!! Extends flash.display.Sprite !!!
	 *
	 * @author Michael Miriti <m.s.miriti@gmail.com>
	 */
	public class Render extends Sprite
	{
		// Root Layer
		public var MainLayer:Layer;
		
		// Array of postrender effects (look in flinjin.graphics.PostEffects)
		public var PostEffects:Array = new Array();
		
		// Lag compenstation algorithm flag
		public var UseLagCompensation:Boolean = false;
		
		private var _bitmapSurface:Bitmap;
		
		private var _fillColor:uint;
		
		// Lag compensation vars
		private var _fps_last:int = 0;
		private var _fps_curr:int = 0;
		
		private var _ups_last:int = 0;
		private var _ups_curr:int = 0;
		
		// Update interval
		private static const UPDATE_INTERVAL:uint = 30;
		
		private var _last_update_time:uint = 0;
		private var _delay_accum:uint = 0;
		
		private var _fpsTimer:Timer;
		
		/**
		 * Update movements
		 */
		private function doUpdate():void
		{
			if (UseLagCompensation)
			{
				var time:Date = new Date();
				var _delay:uint = time.getTime() - _last_update_time;
				
				if (_delay < UPDATE_INTERVAL)
				{
					if (_delay + _delay_accum >= UPDATE_INTERVAL)
					{
						_delay_accum = 0;
						MainLayer.Move();
						_ups_curr++;
					}
					else
					{
						_delay_accum += _delay;
					}
				}
				else
				{
					var repeats:uint = Math.floor(_delay / UPDATE_INTERVAL);
					
					for (var i:uint = 0; i < repeats; i++)
					{
						MainLayer.Move();
						_ups_curr++;
					}
				}
				
				_last_update_time = time.getTime();
			}
			else
			{
				MainLayer.Move();
			}
		}
		
		/**
		 * Actual rendering method
		 *
		 * @param	e
		 */
		private function doRender(e:Event = null):void
		{
			doUpdate();
			_bitmapSurface.bitmapData.fillRect(_bitmapSurface.bitmapData.rect, _fillColor);
			MainLayer.Draw(_bitmapSurface.bitmapData);
			
			if (PostEffects.length)
			{
				// Applying post effects
				for (var i:int = 0; i < PostEffects.length; i++)
				{
					PostEffect(PostEffects[i]).Apply(_bitmapSurface.bitmapData);
				}
			}
			
			_fps_curr++;
		}
		
		/**
		 * Each mouse event broadcasting to all childs
		 *
		 * @param	e
		 */
		private function onMouseEvent(e:MouseEvent):void
		{
			MainLayer.dispatchEvent(e);
		}
		
		/**
		 * Each keyboard event broadcasting to all childs
		 *
		 * @param	e
		 */
		private function onKeyEvent(e:KeyboardEvent):void
		{
			MainLayer.dispatchEvent(e);
		}
		
		/**
		 * Added to stage event
		 *
		 * @param	e
		 */
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, doRender);
		}
		
		/**
		 * Sets the default fill color of renderer
		 *
		 * @param	color
		 */
		public function setFillColor(color:uint):void
		{
			_fillColor = color;
		}
		
		/**
		 * Adding new post effect to convair
		 *
		 * @param	newPostEffect
		 */
		public function addPostEffect(newPostEffect:PostEffect):void
		{
			PostEffects[PostEffects.length] = newPostEffect;
		}
		
		/**
		 * Initialize rendering unit
		 *
		 * @param	nWidth
		 * @param	nHeight
		 * @param	fillColor
		 */
		public function Render(nWidth:uint, nHeight:uint, fillColor:uint = 0x000000)
		{
			MainLayer = new Layer(nWidth, nHeight);
			_bitmapSurface = new Bitmap(new BitmapData(nWidth, nHeight, false, fillColor), "auto", false);
			addChild(_bitmapSurface);
			
			_fillColor = fillColor;
			
			focusRect = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var time:Date = new Date();
			_last_update_time = time.getTime();
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
			addEventListener(MouseEvent.CLICK, onMouseEvent);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyEvent);
			addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void
				{
					Input.KeysPressed[e.keyCode] = true;
				});
			
			addEventListener(KeyboardEvent.KEY_UP, onKeyEvent);
			addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent):void
				{
					Input.KeysPressed[e.keyCode] = false;
				});
			
			if (Flinjin.Debug)
			{
				_fpsTimer = new Timer(1000);
				_fpsTimer.addEventListener(TimerEvent.TIMER, onFpsTimer);
				_fpsTimer.start();
			}
		}
		
		private function onFpsTimer(e:TimerEvent):void
		{
			if (Flinjin.Debug)
			{
				_fps_last = _fps_curr;
				trace('FPS:', _fps_curr);
				_fps_curr = 0;
			}
		}
	}

}