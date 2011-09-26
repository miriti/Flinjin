package flinjin.graphics
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flinjin.graphics.PostEffects.PostEffect;
	import flinjin.input.Input;
	
	/**
	 * Main render unit
	 *
	 * @author Michael Miriti
	 */
	public class Render extends Sprite
	{
		// Все спрайты начинаются тут
		public var SpritesRoot:SpriteGroup;
		
		// Отладка
		public var Debug:Boolean = false;
		
		// Еффекты
		public var PostEffects:Array = new Array();
		
		// Использовать компинсацию лага
		public var UseLagCompinstation:Boolean = true;
		
		// Это для прорисовки
		private var _bitmapSurface:Bitmap;
		
		// Цвет заливки
		private var _fillColor:uint = 0x0;
		
		private var _fps_last:int = 0;
		private var _fps_curr:int = 0;
		
		private var _ups_last:int = 0;
		private var _ups_curr:int = 0;
		
		// Интервал между обновлениями в миллисекундах. 40 = 25/с
		private static const UPDATE_INTERVAL:uint = 30;
		private var _last_update_time:uint = 0;
		private var _deley_accum:uint = 0;
		
		/**
		 *
		 */
		private function doUpdate():void {
			if (UseLagCompinstation)
			{
				var time:Date = new Date();
				var _delay:uint = time.getTime() - _last_update_time;
				
				if (_delay < UPDATE_INTERVAL) {
					if (_delay + _deley_accum >= UPDATE_INTERVAL) {
						_deley_accum = 0;
						SpritesRoot.Move();
						_ups_curr++;
					}else {
						_deley_accum += _delay;
					}
				}else {
					var repeats:uint = Math.floor(_delay / UPDATE_INTERVAL);
					
					for (var i:uint = 0; i < repeats; i++) {
						SpritesRoot.Move();
						_ups_curr++;
					}
				}
				
				_last_update_time = time.getTime();
			}else {
				SpritesRoot.Move();
			}
		}
		
		/**
		 * Прорисовка
		 * Вызывется при каждом кадре
		 *
		 * @param	e
		 */
		private function doRender(e:Event):void {
			_bitmapSurface.bitmapData.fillRect(_bitmapSurface.bitmapData.rect, _fillColor);
			doUpdate();
			SpritesRoot.Draw(_bitmapSurface.bitmapData);
			
			if (PostEffects.length) {
				for (var i:int = 0; i < PostEffects.length; i++) {
					PostEffect(PostEffects[i]).Apply(_bitmapSurface.bitmapData);
				}
			}
			
			_fps_curr++;
		}
		
		/**
		 * При добавлении в дисплей лист
		 * @param	e
		 */
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, doRender);
		}
		
		private function onKeyDown(e:KeyboardEvent):void {
			Input.KeysPressed[e.keyCode] = true;
		}
		
		private function onKeyUp(e:KeyboardEvent):void {
			Input.KeysPressed[e.keyCode] = false;
		}
		
		private function onMouseDown(e:MouseEvent):void {
			stage.focus = this;
			Input.mousePos.x = e.stageX;
			Input.mousePos.y = e.stageY;
			Input.LMBDown = true;
			SpritesRoot.onMouseDown();
		}
		
		private function onMouseUp(e:MouseEvent):void {
			Input.mousePos.x = e.stageX;
			Input.mousePos.y = e.stageY;
			Input.LMBDown = false;
		}
		
		private function onMouseMove(e:MouseEvent):void {
			Input.mousePos.x = e.stageX;
			Input.mousePos.y = e.stageY;
			SpritesRoot.onMouseOver();
		}
		
		/**
		 * Инициализация интерфейса прорисовки
		 *
		 * @param	nWidth Ширина области прорисовки
		 * @param	nHeight Высота области прорисовки
		 * @param	fillColor Цвет заполнения
		 */
		public function Render(nWidth:int, nHeight:int, fillColor:uint=0x0)
		{
			SpritesRoot = new SpriteGroup();
			SpritesRoot.SetClipRect(new Rectangle(0, 0, nWidth, nHeight));
			_bitmapSurface = new Bitmap(new BitmapData(nWidth, nHeight, false, fillColor));
			addChild(_bitmapSurface);
			
			_fillColor = fillColor;
			
			focusRect = false;
			
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			var time:Date = new Date();
			_last_update_time = time.getTime();
		}
		
	}

}