package ns.flex.util
{
	import mx.utils.ObjectUtil;

	public class ObjectUtils
	{
		public static function copyProperties(toObject:Object, fromObject:Object,
			isDynamic:Boolean=false):void
		{
			if (fromObject)
				for (var prop:String in fromObject)
					if (toObject.hasOwnProperty(prop) || isDynamic)
						toObject[prop]=fromObject[prop];
		}

		public static function mergeObject(... objs):Object
		{
			var merger:Object={};

			for each (var obj:* in objs)
				copyProperties(merger, obj, true);
			return merger;
		}
	}
}