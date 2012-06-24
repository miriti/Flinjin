package flinjin.graphics
{
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
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
		private var _border:Boolean = false;
		private var _borderColor:uint = 0xff000000;
		private var _textColor:uint;
		
		public function set text(val:String):void
		{
			_field.text = val;
			_field.setTextFormat(_textformat);
			
			var bd:BitmapData = new BitmapData(_field.width, _field.height, true, 0x00000000);
			
			bd.draw(_field);
			
			_current_bitmap = bd;
			_current_result = _current_bitmap;
			
			_spriteRect.width = bd.width;
			_spriteRect.height = bd.height;
		}
		
		override protected function _Draw(surface:BitmapData, shiftVector:Point = null, innerScale:Number = 1):void
		{
			super._Draw(surface, shiftVector, innerScale);
		}
		
		public function get text():String
		{
			return _field.text;
		}
		
		override public function get width():Number
		{
			return _field.width;
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
		
		public function get borderColor():uint
		{
			return _borderColor;
		}
		
		public function set borderColor(value:uint):void
		{
			_borderColor = value;
		}
		
		public function get border():Boolean
		{
			return _border;
		}
		
		public function set border(value:Boolean):void
		{
			if (value)
			{
				_field.filters = [new GlowFilter(_borderColor, 1, 6, 6, 2)];
			}
			else
			{
				_field.filters = [];
			}
			_border = value;
			// to update bitmap
			text = text;
		}
		
		public function get textColor():uint
		{
			return _textColor;
		}
		
		public function set textColor(value:uint):void
		{
			_textColor = value;
			_textformat.color = value;
			text = text;
		}
		
		/**
		 * This class using standart or embeded TrueType fonts to draw text
		 *
		 * @param	initText
		 * @param	initTextFormat
		 */
		public function SpriteText(initText:String, initTextFormat:TextFormat, initBorder:Boolean = false, initBoarderColor:Number = 0x000000)
		{
			super(null);
			
			_field = new TextField();
			_field.embedFonts = true;
			_field.autoSize = TextFieldAutoSize.LEFT;
			_field.background = false;
			_field.antiAliasType = AntiAliasType.ADVANCED;
			_field.wordWrap = false;
			
			Format = initTextFormat;
			
			_textColor = initTextFormat.color as uint;
			
			border = initBorder;
			borderColor = initBoarderColor;
			
			text = initText;
		}
	
	}

}