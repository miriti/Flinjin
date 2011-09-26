package flinjin.graphics
{
	import flash.display.BitmapData;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class TextSprite extends SpriteBase
	{
		private var _font:String;
		private var _size:uint;
		private var _text:String;
		private var _field:TextField;
		private var _textformat:TextFormat;
		
		public function set text(val:String):void {
			_field.text = val;
			_field.setTextFormat(_textformat);
			
			var bd:BitmapData = new BitmapData(_field.width, _field.height, true, 0x00000000);
			
			bd.draw(_field);
			
			spriteBitmapData = bd;
		}
		
		override public function get width():uint
		{
			return _field.width;
		}
		
		override public function get height():uint
		{
			return _field.height;
		}
		
		public function get text():String {
			return _field.text;
		}
		
		public function TextSprite(newtext:String, font:String, size:uint)
		{
			super(null);
			
			_field = new TextField();
			_field.autoSize = TextFieldAutoSize.LEFT;
			_field.background = false;
			_field.antiAliasType = AntiAliasType.ADVANCED;
			_field.embedFonts = true;
			
			_textformat = new TextFormat(font, size, 0xffffff);
			
			text = newtext;
		}
		
	}

}