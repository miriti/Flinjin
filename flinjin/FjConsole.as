package flinjin
{
	
	/**
	 * ...
	 * @author Michael Miriti
	 */
	public class FjConsole
	{
		public static var fontName:String = "Courier New";
		public static var fontSize:Number = 11;
		
		private static var _window:ConsoleWindow = null;
		private static var _active:Boolean = false;
		
		static public function show():void
		{
			if (null == _window)
				_window = new ConsoleWindow();
			
			Flinjin.Instance.addChild(_window);
			_active = true;
		}
		
		static public function hide():void
		{
			Flinjin.Instance.removeChild(_window);
			_active = false;
		}
		
		static public function get active():Boolean
		{
			return _active;
		}
		
		static public function set active(value:Boolean):void
		{
			_active = value;
			if (_active)
				show();
			else
				hide();
		}
		
		static public function inspect(obj:Object, prop:String, propName:String, edit:Boolean = false):void
		{
			if (null == _window)
				_window = new ConsoleWindow();
			_window.addElement(new ConsoleWindowElement(new ConsoleElement(obj, prop, propName, edit)));
		}
	}

}
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TextEvent;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.ui.Keyboard;
import flinjin.FjConsole;

class ConsoleElement
{
	private var _editable:Boolean = false;
	private var _name:String;
	private var _property:String;
	private var _object:Object;
	
	function ConsoleElement(object:Object, property:String, propName:String, propEditable:Boolean = false):void
	{
		_object = object;
		_property = property;
		_name = propName;
		_editable = propEditable;
	}
	
	public function setValue(val:*):void
	{
		if (_object != null)
		{
			if (_object.hasOwnProperty(_property))
			{
				_object[_property] = val;
			}
		}
	}
	
	public function getValue():*
	{
		if (_object.hasOwnProperty(_property))
		{
			return String(_object[_property]);
		}
		else
		{
			return "no prop. <" + _property + ">";
		}
	}
	
	public function get name():String
	{
		return _name;
	}
	
	public function set name(value:String):void
	{
		_name = value;
	}
	
	public function get editable():Boolean
	{
		return _editable;
	}
	
	public function set editable(value:Boolean):void
	{
		_editable = value;
	}
}

class ConsoleWindow extends Sprite
{
	private var _title:TextField;
	private var _elements:Vector.<ConsoleWindowElement> = new Vector.<ConsoleWindowElement>();
	
	function ConsoleWindow():void
	{
		super();
		_setTitle();
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private function onEnterFrame(e:Event):void
	{
		_resetBackground();
	}
	
	public function addElement(element:ConsoleWindowElement):void
	{
		_elements.push(element);
		element.y = height;
		addChild(element);
		_resetBackground();
	}
	
	protected function _resetBackground():void
	{
		graphics.clear();
		graphics.beginFill(0x000000, 0.8);
		graphics.drawRect(0, 0, width, height);
		graphics.endFill();
	}
	
	protected function _setTitle():void
	{
		_title = new TextField();
		//_title.embedFonts = true;
		_title.autoSize = TextFieldAutoSize.LEFT;
		_title.background = false;
		_title.antiAliasType = AntiAliasType.ADVANCED;
		_title.wordWrap = false;
		_title.selectable = false;
		_title.text = "Flinjin Console";
		_title.setTextFormat(new TextFormat("Consolas", 9, 0xffffff));
		addChild(_title);
		_resetBackground();
	}
}

class ConsoleWindowElement extends Sprite
{
	private var _title:TextField = new TextField();
	private var _txtVal:TextField = new TextField();
	private var _format:TextFormat = new TextFormat(FjConsole.fontName, FjConsole.fontSize, 0xaaaaaa);
	private var _trackEnabled:Boolean = true;
	private var _editFormat:TextFormat = new TextFormat(FjConsole.fontName, FjConsole.fontSize, 0xff0000);
	protected var _element:ConsoleElement;
	
	function ConsoleWindowElement(element:ConsoleElement):void
	{
		super();
		_element = element;
		
		_title.autoSize = TextFieldAutoSize.LEFT;
		_title.background = false;
		_title.antiAliasType = AntiAliasType.ADVANCED;
		_title.wordWrap = false;
		_title.selectable = false;
		_title.text = element.name + ": ";
		_title.setTextFormat(_format);
		
		_txtVal.autoSize = TextFieldAutoSize.LEFT;
		_txtVal.background = false;
		_txtVal.antiAliasType = AntiAliasType.ADVANCED;
		_txtVal.wordWrap = false;
		_txtVal.selectable = false;
		_txtVal.x = _title.width;
		_txtVal.doubleClickEnabled = true;
		
		if (element.editable)
		{
			_format.underline = true;
			_format.bold = true;
			_txtVal.addEventListener(MouseEvent.DOUBLE_CLICK, onValDblClick);
			_txtVal.addEventListener(KeyboardEvent.KEY_DOWN, onValKeyDown);
		}
		
		addChild(_title);
		addChild(_txtVal);
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private function _startEditVal():void
	{
		_txtVal.background = true;
		_txtVal.selectable = true;
		_txtVal.type = TextFieldType.INPUT;
	}
	
	private function _endEditVal():void
	{
		_txtVal.background = false;
		_txtVal.selectable = false;
		_txtVal.type = TextFieldType.DYNAMIC;
	}
	
	private function onValKeyDown(e:KeyboardEvent):void
	{
		if (e.keyCode == Keyboard.ENTER)
		{
			_endEditVal();
			_trackEnabled = true;
			_element.setValue(_txtVal.text);
		}
		
		if (e.keyCode == Keyboard.ESCAPE)
		{
			_endEditVal();
			_trackEnabled = true;
		}
	}
	
	private function onValDblClick(e:MouseEvent):void
	{
		_trackEnabled = false;
		_startEditVal();
	}
	
	private function onEnterFrame(e:Event):void
	{
		if (_trackEnabled)
		{
			_txtVal.text = _element.getValue();
			_txtVal.setTextFormat(_format);
		}
	}
}