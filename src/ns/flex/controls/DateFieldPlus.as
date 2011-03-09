package ns.flex.controls
{
	import mx.controls.DateField;
	import mx.events.FlexEvent;
	
	import ns.flex.util.DateUtil;
	import ns.flex.util.DateValidatorPlus;
	import ns.flex.util.ObjectUtils;
	import ns.flex.util.ValidatorUtil;
	
	public class DateFieldPlus extends DateField
	{
		private var today:Date=new Date();
		[Inspectable(category="General")]
		private var _defaultDate:String='today';
		private var validator:DateValidatorPlus;
		
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
			return ValidatorUtil.validate(validator);
		}
		
		public function set constraints(value:Object):void
		{
			if (value)
			{
				if (!validator)
					validator=new DateValidatorPlus(this);
				ObjectUtils.copyProperties(this, value);
				ObjectUtils.copyProperties(validator, value);
			}
		}
		
		[Inspectable(enumeration="today,yesterday", defaultValue="today",
			category="General")]
		public function set defaultDate(dd:String):void
		{
			_defaultDate=dd;
			resetDefault();
		}
		
		public function resetDefault():void
		{
			switch (_defaultDate)
			{
				case 'yesterday':
					selectYesterday();
					break;
				case 'today':
					selectToday();
					break;
				default:
					selectedDate=null;
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
		
		protected function selectToday():void
		{
			selectedDate=today;
		}
		
		protected function selectYesterday():void
		{
			selectedDate=new Date(today.getTime() - DateUtil.millisecondsPerDay);
		}
	}
}