package ns.flex.util
{
	
	public class ObjectUtils
	{
		public static function copyProperties(toObject:Object, fromObject:Object):void
		{
			if (fromObject)
				for (var prop:String in fromObject)
					if (toObject.hasOwnProperty(prop))
						toObject[prop]=fromObject[prop];
		}
	}
}