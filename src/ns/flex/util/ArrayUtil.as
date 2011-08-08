package ns.flex.util
{
	import flash.utils.getDefinitionByName;

	import mx.collections.XMLListCollection;
	import mx.utils.ObjectUtil;

	public class ArrayUtil
	{

		/**
		 *
		 * @param source Array or ArrayCollection and object with length property
		 * @return
		 */
		static public function isEmpty(source:Object):Boolean
		{
			return !(source && source.length > 0);
		}

		static public function findByProperty(array:Array, property:String, source:*):*
		{
			for each (var item:* in array)
				if (ObjectUtil.compare(item[property], source) == 0)
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

		public static function toArray(source:Object):Array
		{
			if (!source)
				return [];
			else if (source is Array)
				return source as Array;
			else if (source.hasOwnProperty('toArray'))
				return source.toArray();
			else if (source is XMLList)
				return new XMLListCollection(source as XMLList).toArray();
			else if (source is XML)
			{
				var xl:XMLList=new XMLList();
				xl+=source;
				return new XMLListCollection(xl).toArray();
			}
			else
				return [source];
		}
	}
}

