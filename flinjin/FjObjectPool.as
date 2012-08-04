package flinjin
{
	import flash.events.IEventDispatcher;
	import flash.system.System;
	import flinjin.events.FlinjinObjectPoolEvent;
	
	/**
	 * Flinjin Object Pool static class
	 *
	 * @author Michael Miriti
	 */
	public class FjObjectPool
	{
		private static var _enabled:Boolean = true;
		private static var _pool:Vector.<Object> = new Vector.<Object>();
		private static var _limit:uint = 10000;
		
		/**
		 * Clears Object Pool
		 */
		public static function clear():void
		{
			_pool = new Vector.<Object>();
			System.gc();
		}
		
		/**
		 * Get precreated object from pool
		 *
		 * @param	type
		 * @return
		 */
		public static function pull(type:Class):Object
		{
			if (_enabled)
			{
				for (var i:int = 0; i < _pool.length; i++)
				{
					if (_pool[i] is type)
					{
						var _obj:Object = _pool[i];
						_pool.splice(i, 1);
						if (_obj is IEventDispatcher)
						{
							(_obj as IEventDispatcher).dispatchEvent(new FlinjinObjectPoolEvent(FlinjinObjectPoolEvent.RESTORE));
						}
						return _obj;
					}
				}
			}
			var _newObj:Object = new type();
			return _newObj;
		}
		
		/**
		 * Precreate <count> of object in pool
		 *
		 * @param	type
		 * @param	count
		 */
		public static function prepare(type:Class, count:uint):void
		{
			if (count > 0)
			{
				for (var i:int = 0; i < count; i++)
				{
					var _newObj:Object = new type();
					put(_newObj);
				}
			}
		}
		
		/**
		 * Put object in pool
		 *
		 * @param	obj
		 * @return
		 */
		public static function put(obj:Object):Object
		{
			if (_enabled)
			{
				if (_pool.indexOf(obj) == -1)
					_pool.push(obj);
			}
			
			return obj;
		}
		
		static public function get enabled():Boolean
		{
			return _enabled;
		}
		
		static public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
		
		static public function get limit():uint
		{
			return _limit;
		}
		
		static public function set limit(value:uint):void
		{
			_limit = value;
		}
	}

}