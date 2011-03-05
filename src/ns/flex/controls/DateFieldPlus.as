package ns.flex.controls
{
	import mx.controls.DateField;

	public class DateFieldPlus extends DateField
	{
		private var millisecondsPerDay:int=1000 * 60 * 60 * 24;
		private var today:Date=new Date();
		[Inspectable(category="General")]
		public var required:Boolean=false;

		public function DateFieldPlus()
		{
			super();
			yearNavigationEnabled=true
			firstDayOfWeek=1
			width=100
			yearSymbol='年'
			monthNames=
				['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月']
			formatString='YYYYMMDD'
			dayNames=['日', '一', '二', '三', '四', '五', '六']
			selectToday()
		}

		[Bindable("valueCommit")]
		public function get validated():Boolean
		{
			return (!required || (selectedDate && text));
		}

		public function getTomorrow():Date
		{
			return new Date(selectedDate.getTime() + millisecondsPerDay);
		}

		public function getYesterday():Date
		{
			return new Date(selectedDate.getTime() - millisecondsPerDay);
		}

		public function selectToday():void
		{
			selectedDate=today;
		}

		public function selectYesterday():void
		{
			selectedDate=new Date(today.getTime() - millisecondsPerDay);
		}

	}
}