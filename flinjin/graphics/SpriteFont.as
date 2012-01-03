package flinjin.graphics
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author KEFIR
	 */
	public class SpriteFont extends Sprite
	{
		/**
		 * Font sprite constructor.
		 * Draw text from bitmap strip
		 *
		 * @param	spriteBmp Bitmap with characters
		 * @param	representChars string, that represents chars, drawn on bitmap
		 * @param	charWidth width of char
		 * @param	charHeight height of char
		 */
		public function SpriteFont(spriteBmp:Bitmap, representChars:String, charWidth:int, charHeight:int)
		{
			super(spriteBmp, null, true, charWidth, charHeight);
		}
	}

}