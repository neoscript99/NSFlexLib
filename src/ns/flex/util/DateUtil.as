package ns.flex.util
{
	import mx.controls.DateField;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.formatters.DateFormatter;

	public class DateUtil
	{
		private static var _dateFormatter:DateFormatter=new DateFormatter();

		public static function get dateFormatter():DateFormatter
		{
			return _dateFormatter;
		}
		public static const millisecondsPerDay:int=1000 * 60 * 60 * 24;
		public static const millisecondsPerHour:int=1000 * 60 * 60;
		public static const millisecondsPerMinute:int=1000 * 60;
		private static var _timeFormatter:DateFormatter=new DateFormatter();

		public static function get timeFormatter():DateFormatter
		{
			return _timeFormatter;
		}

		public static function getDateLabel(item:Object=null,
			column:DataGridColumn=null):String
		{
			if (column)
				return _dateFormatter.format(item[column.dataField]);
			else
				return _dateFormatter.format(item ? item : new Date());
		}

		/**
		 * 取得day所在月的最后一天
		 * @param day
		 * @return
		 */
		public static function getLastDay(day:Date):Date
		{
			return new Date(day.fullYear, day.month + 1, 0);
		}

		public static function getLastDayString(dayString:String):String
		{
			return getDateLabel(getLastDay(stringToDate(dayString)));
		}

		public static function getLastMonthFinal(day:Date):Date
		{
			return new Date(day.fullYear, day.month, 0);
		}

		public static function getLastMonthFinalString(day:*):String
		{
			return getDateLabel(getLastMonthFinal((day is Date) ? day : stringToDate(day)));
		}

		public static function getLastYearFinal(day:*):Date
		{
			//new Date 参数小于最小值或大于最大值时，对应日期自动移动
			return new Date(((day is Date) ? day : stringToDate(day)).fullYear, 0, 0);
		}

		public static function getLastYearFinalString(dayString:String):String
		{
			return String(Number(dayString.substr(0, 4)) - 1).concat('1231');
		}

		public static function getTimeLabel(item:Object,
			column:DataGridColumn=null):String
		{
			if (column)
				return _timeFormatter.format(item[column.dataField]);
			else
				return _timeFormatter.format(item);
		}

		public static function shiftDays(date:Date, value:int):Date
		{
			return new Date(date.getTime() + value * millisecondsPerDay);
		}

		public static function stringToDate(dayString:String, format:String=null):Date
		{
			return DateField.stringToDate(dayString,
				format ? format : dateFormatter.formatString);
		}

		public static function stringToTime(timeString:String):Date
		{
			return DateField.stringToDate(timeString, timeFormatter.formatString);
		}

		/**
		 * 计算两个日期间隔天数
		 * @param left
		 * @param right
		 * @return
		 */
		public static function sub(left:Date, right:Date):int
		{
			return (left.getTime() - right.getTime()) / millisecondsPerDay;
		}
		_timeFormatter.formatString='YYYY-MM-DD HH:NN:SS';
		_dateFormatter.formatString='YYYYMMDD';
	}
}

