package ns.flex.controls
{
	import mx.controls.DateField;
	import ns.flex.util.DateUtil;
	
	public class DateFieldPlus extends DateField
	{
		private var today:Date=new Date();
		[Inspectable(category="General")]
		public var required:Boolean=false;
		private var _defaultDate:String='today';
		
		public function DateFieldPlus()
		{
			super();
			yearNavigationEnabled=true;
			firstDayOfWeek=1;
			width=100;
			yearSymbol='年';
			monthNames=
				['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月']
			formatString='YYYYMMDD';
			dayNames=['日', '一', '二', '三', '四', '五', '六'];
			resetDefault();
		}
		
		[Bindable("valueCommit")]
		public function get validated():Boolean
		{
			return (!required || (selectedDate && text));
		}
		
		[Inspectable(enumeration="today,yesterday", defaultValue="today",
			category="General")]
		public function set defaultDate(dd:String):void
		{
			_defaultDate=dd;
		}
		
		public function resetDefault():void
		{
			switch (_defaultDate)
			{
				case 'yesterday':
					selectYesterday();
					break;
				default:
					selectToday();
			}
		}
		
		public function getTomorrow():Date
		{
			return DateUtil.shiftDays(selectedDate, 1);
		}
		
		public function getYesterday():Date
		{
			return DateUtil.shiftDays(selectedDate, -1);
		}
		
		public function selectToday():void
		{
			selectedDate=today;
		}
		
		public function selectYesterday():void
		{
			selectedDate=new Date(today.getTime() - DateUtil.millisecondsPerDay);
		}
	}
}