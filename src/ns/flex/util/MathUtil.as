package ns.flex.util
{

	public class MathUtil
	{
		static public function sum(values:Array):Number
		{
			var sum:Number=0;
			for each (var v:* in values)
			{
				var vnum:Number=Number(v);
				if (!isNaN(vnum))
					sum+=vnum;
			}
			return sum;
		}

		static public function avg(values:Array):Number
		{
			return values.length > 0 ? sum(values) / values.length : NaN;
		}

		static public function max(values:Array):Number
		{
			var max:Number;
			for each (var v:* in values)
			{
				var vnum:Number=Number(v);
				if (!isNaN(vnum) && (isNaN(max) || vnum > max))
					max=vnum;
			}
			return max;
		}

		static public function min(values:Array):Number
		{
			var min:Number;
			for each (var v:* in values)
			{
				var vnum:Number=Number(v);
				if (!isNaN(vnum) && (isNaN(min) || vnum < min))
					min=vnum;
			}
			return min;
		}
	}
}

