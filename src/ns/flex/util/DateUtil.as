package ns.flex.util
{
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.formatters.DateFormatter;
	
	public class DateUtil
	{
		static private var _timeFormatter:DateFormatter=new DateFormatter();
		_timeFormatter.formatString='YYYY-MM-DD HH:NN:SS';
		static private var _dateFormatter:DateFormatter=new DateFormatter();
		_dateFormatter.formatString='YYYYMMDD';
		public static const millisecondsPerMinute:int=1000 * 60;
		public static const millisecondsPerHour:int=1000 * 60 * 60;
		public static const millisecondsPerDay:int=1000 * 60 * 60 * 24;
		
		/**
		 * 计算两个日期间隔天数
		 * @param left
		 * @param right
		 * @return
		 */
		static public function sub(left:Date, right:Date):int
		{
			return (left.getTime() - right.getTime()) / millisecondsPerDay;
		}
		
		static public function shiftDays(date:Date, value:int):Date
		{
			return new Date(date.getTime() + value * millisecondsPerDay);
		}
		
		static public function getTimeLabel(item:Object, column:DataGridColumn=
			null):String
		{
			if (column)
				return _timeFormatter.format(item[column.dataField]);
			else
				return _timeFormatter.format(item);
		}
		
		static public function getDateLabel(item:Object, column:DataGridColumn=
			null):String
		{
			if (column)
				return _dateFormatter.format(item[column.dataField]);
			else
				return _dateFormatter.format(item);
		}
		
		static public function get timeFormatter():DateFormatter
		{
			return _timeFormatter;
		}
		
		static public function get dateFormatter():DateFormatter
		{
			return _dateFormatter;
		}
		
		static public function getYesterday(selectDate:Date):String
		{
			return dateFormatter.format(new Date(selectDate.getTime() - millisecondsPerDay));
		}
		
		static public function getLastYearFinal(day:Object):String
		{
			switch (typeof day)
			{
				case 'string':
					var str:String=day as String;
					return String(Number(str.substr(0, 4)) - 1).concat('1231');
				default:
					break;
			}
			throw new Error('格式错误:' + day);
		}
	}
}