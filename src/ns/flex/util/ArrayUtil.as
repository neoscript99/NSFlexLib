package ns.flex.util
{
	import flash.utils.getDefinitionByName;
	import mx.utils.ObjectUtil;
	
	public class ArrayUtil
	{
		static public function findByProperty(array:Array, property:String, value:*):*
		{
			for each (var item:* in array)
				if (ObjectUtil.compare(item[property], value) == 0)
					return item;
			return null;
		}
		
		public static function removeItem(array:Array, item:*):void
		{
			var index:int=getItemIndex(item, array);
			
			for (var i:int=index; i < array.length - 1; i++)
				array[i]=array[i + 1];
			array.pop();
		}
		
		public static function getItemIndex(item:Object, array:Array):int
		{
			return int(getDefinitionByName('mx.utils.ArrayUtil').getItemIndex(item,
				array));
		}
	}
}