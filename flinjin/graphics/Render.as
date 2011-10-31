package flinjin.graphics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flinjin.graphics.PostEffects.PostEffect;
	import flinjin.input.Input;
	
	/**
	 * Main render unit
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
		private var _deley_accum:uint = 0;
		
		/**
		 * Update movements
		 */
		private function doUpdate():void {
			if (UseLagCompensation)
			{
				var time:Date = new Date();
				var _delay:uint = time.getTime() - _last_update_time;
				
				if (_delay < UPDATE_INTERVAL) {
					if (_delay + _deley_accum >= UPDATE_INTERVAL) {
						_deley_accum = 0;
						MainLayer.Move();
						_ups_curr++;
					}else {
						_deley_accum += _delay;
					}
				}else {
					var repeats:uint = Math.floor(_delay / UPDATE_INTERVAL);
					
					for (var i:uint = 0; i < repeats; i++) {
						MainLayer.Move();
						_ups_curr++;
					}
				}
				
				_last_update_time = time.getTime();
			}else {
				MainLayer.Move();
			}
		}
		
		/**
		 * Actual rendering method
		 * 
		 * @param	e
		 */
		private function doRender(e:Event = null):void {
			doUpdate();
			_bitmapSurface.bitmapData.fillRect(_bitmapSurface.bitmapData.rect, _fillColor);
			MainLayer.Draw(_bitmapSurface.bitmapData);
			
			if (PostEffects.length) {
				// Applying post effects
				for (var i:int = 0; i < PostEffects.length; i++) {
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
		private function onMouseEvent(e:MouseEvent):void {
			var mousePos:Point = new Point(e.localX, e.localY);
			
			for each (var eachSprite:flinjin.graphics.Sprite in MainLayer.Sprites) {
				if (eachSprite.rect.containsPoint(mousePos)) {					
					var localMousePos:Point = mousePos.clone();
					localMousePos.x -= eachSprite.x;
					localMousePos.y -= eachSprite.y;
					
					var subEvent:MouseEvent = e.clone() as MouseEvent;					
					subEvent.localX = localMousePos.x;
					subEvent.localY = localMousePos.y;
					
					eachSprite.dispatchEvent(subEvent);
				}				
			}
		}
		
		/**
		 * Each keyboard event broadcasting to all childs
		 * 
		 * @param	e
		 */
		private function onKeyEvent(e:KeyboardEvent):void {
			for each (var eachSprite:flinjin.graphics.Sprite in MainLayer.Sprites) {
				eachSprite.dispatchEvent(e);
			}
		}
		
		/**
		 * Added to stage event
		 * 
		 * @param	e
		 */
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, doRender);
		}		
		
		/**
		 * Adding new post effect to convair
		 * 
		 * @param	newPostEffect
		 */
		public function addPostEffect(newPostEffect:PostEffect):void {
			PostEffects[PostEffects.length] = newPostEffect;
		}
		
		/**
		 * Initialize rendering unit
		 * 
		 * @param	nWidth
		 * @param	nHeight
		 * @param	fillColor
		 */
		public function Render(nWidth:int, nHeight:int, fillColor:uint=0x000000)
		{
			MainLayer = new Layer(nWidth, nHeight);
			_bitmapSurface = new Bitmap(new BitmapData(nWidth, nHeight, false, fillColor));
			addChild(_bitmapSurface);
			
			_fillColor = fillColor;
			
			focusRect = false;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var time:Date = new Date();
			_last_update_time = time.getTime();
			
			addEventListener(MouseEvent.MOUSE_DOWN,		onMouseEvent);
			addEventListener(MouseEvent.MOUSE_UP,		onMouseEvent);
			addEventListener(KeyboardEvent.KEY_DOWN,	onKeyEvent);
			addEventListener(KeyboardEvent.KEY_UP,		onKeyEvent);
		}
		
	}

}