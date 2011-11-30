package ns.flex.util
{
	import flash.utils.ByteArray;

	public class StringUtil
	{

		public static function chineseCompare(str1:String, str2:String):int
		{
			var encode:String="hz-gb-2312";
			if (!str1 && !str2)
				return 0;
			if (!str1)
				return 1;
			if (!str2)
				return -1;
			var byte1:ByteArray=new ByteArray();
			var byte2:ByteArray=new ByteArray();
			byte1.writeMultiByte(str1, encode);
			byte2.writeMultiByte(str2, encode);

			if (byte1 > byte2)
				return 1
			else if (byte1 < byte2)
				return -1
			else
				return 0
		}

		public static function firstToLowCase(str:String):String
		{
			return str.charAt(0).toLowerCase() + str.slice(1);
		}

		/**
		 * 增加千分位逗号，并根据精度补0
		 * @param v 格式化的数字
		 * @param precision 精度
		 * @param isSeparateThousands 是否使用千分位
		 * @return
		 */
		public static function formatNumber(numObject:Object, precision:int=2,
			isSeparateThousands:Boolean=true):String
		{
			if (numObject == null)
				return '';
			var v:Number=Number(numObject);
			if (isNaN(v))
				return String(v);
			var value:String=v.toFixed(precision);
			//当precision=0，value为0-1小数时，toFixed结果为'1.'，多了一个'.'
			if (precision == 0)
				value=value.replace('\.', '');
			if (isSeparateThousands)
			{
				var valueString:String="";
				var left:int=precision > 0 ? value.indexOf(".") : value.length;

				for (var i:int=0; i < left; i++)
				{
					valueString+=value.charAt(i);
					var inteval:int=left - i - 1;

					if (inteval % 3 == 0 && inteval > 0 && value.charAt(i) != "-")
					{
						valueString+=",";
					}
				}

				if (precision > 0)
					valueString+=value.slice(left);
				return valueString;
			}
			else
				return value;
		}

		public static function parseNumber(str:String):Number
		{
			return Number(str ? str.replace(/\,/g, '') : str);
		}

		public static function removeSpace(str:String):String
		{
			return str ? str.replace(/\s/g, '') : '';
		}

		public static function toLine(str:String):String
		{
			return str ? trim(str.replace(/[\t\r\n]/g, ' ')) : '';
		}

		public static function trim(str:String):String
		{
			return str ? str.replace(/^\s*/, '').replace(/\s*$/, '') : '';
		}
	}
}

