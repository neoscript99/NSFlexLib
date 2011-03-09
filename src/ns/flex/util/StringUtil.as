package ns.flex.util
{
	
	public class StringUtil
	{
		static public function trim(str:String):String
		{
			return str ? str.replace(/^\s*/, '').replace(/\s*$/, '') : str;
		}
		
		static public function removeSpace(str:String):String
		{
			return str ? str.replace(/\s/g, '') : str;
		}
		
		static public function toLine(str:String):String
		{
			return str ? trim(str.replace(/[\t\r\n]/g, ' ')) : str;
		}
		
		static public function firstToLowCase(str:String):String
		{
			return str.charAt(0).toLowerCase() + str.slice(1);
		}
		
		static public function parseNumber(str:String):Number
		{
			return Number(str ? str.replace(/\,/g, '') : str);
		}
		
		/**
		 * 增加千分位逗号，并根据精度补0
		 * @param v 格式化的数字
		 * @param precision 精度
		 * @param isSeparateThousands 是否使用千分位
		 * @return
		 */
		static public function formatNumber(v:Number, precision:int=2,
			isSeparateThousands:Boolean=true):String
		{
			var value:String=v.toFixed(precision);
			
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
	}
}