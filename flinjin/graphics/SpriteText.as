package flinjin.graphics
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class SpriteText extends Sprite
	{
		private var _font:String;
		private var _size:uint;
		private var _text:String;
		private var _field:TextField;
		private var _textformat:TextFormat;
		
		public function set text(val:String):void
		{
			_field.text = val;
			_field.setTextFormat(_textformat);
			
			var bd:BitmapData = new BitmapData(_field.width, _field.height, true, 0x00000000);
			
			bd.draw(_field);
			
			_current_bitmap = bd;
			_current_result = _current_bitmap;
		}
		
		override protected function _Draw(surface:BitmapData, shiftVector:Point = null):void 
		{
			super._Draw(surface, shiftVector);
		}
		
		public function get text():String
		{
			return _field.text;
		}
		
		override public function get width():Number
		{
			return _field.height;
		}
		
		override public function set width(value:Number):void
		{
		}
		
		override public function get height():Number
		{
			return _field.height;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
		}
		
		public function set Format(val:TextFormat):void
		{
			_textformat = val;
		}
		
		public function get Format():TextFormat
		{
			return _textformat;
		}
		
		/**
		 *
		 * @param	initText
		 * @param	initTextFormat
		 */
		public function SpriteText(initText:String, initTextFormat:TextFormat)
		{
			super(null);
			
			_field = new TextField();
			_field.autoSize = TextFieldAutoSize.LEFT;
			_field.background = false;
			_field.antiAliasType = AntiAliasType.ADVANCED;
			_field.wordWrap = false;
			
			Format = initTextFormat;
			
			text = initText;
		}
	
	}

}