package ns.flex.util
{
	import mx.validators.DateValidator;
	
	/**
	 * 日期校验
	 * @author wangchu
	 */
	public class DateValidatorPlus extends DateValidator
	{
		public function DateValidatorPlus()
		{
			super();
			inputFormat="YYYYMMDD";
			property="text";
			validateAsString="true";
			wrongLengthError="日期格式错误";
			wrongDayError="根据当前月份，请输入正确的日期.";
			wrongMonthError="请输入正确的月份 1 - 12.";
			wrongYearError="请输入正确的年度 0 - 9999.";
		}
	}
}