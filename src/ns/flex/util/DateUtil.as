package ns.flex.util
{
	import mx.controls.DateField;
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
		
		static public function stringToDate(dayString:String):Date
		{
			return DateField.stringToDate(dayString, dateFormatter.formatString);
		}
		
		static public function stringToTime(timeString:String):Date
		{
			return DateField.stringToDate(timeString, timeFormatter.formatString);
		}
		
		static public function getLastMonthFinal(day:Date):Date
		{
			return new Date(day.fullYear, day.month, 0);
		}
		
		static public function getLastYearFinal(day:Date):Date
		{
			//new Date 参数小于最小值或大于最大值时，对应日期自动移动
			return new Date(day.fullYear, 0, 0);
		}		
	}
}