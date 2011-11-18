package ns.flex.util
{
	import flash.utils.ByteArray;

	public class ObjectUtils
	{

		public static function clone(source:Object):*
		{
			var myBA:ByteArray=new ByteArray();
			myBA.writeObject(source);
			myBA.position=0;
			return (myBA.readObject());
		}

		public static function copyProperties(toObject:Object, fromObject:Object,
			isDynamic:Boolean=false):void
		{
			if (fromObject)
				for (var prop:String in fromObject)
					if (toObject.hasOwnProperty(prop) || isDynamic)
						toObject[prop]=fromObject[prop];
		}

		public static function getValue(obj:Object, field:String):Object
		{
			var cur:Object=obj;
			var chain:Array=field.split('.');
			for (var i:int=0; i < chain.length; i++)
				if (cur)
					cur=cur[chain[i]];
			return cur;
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

