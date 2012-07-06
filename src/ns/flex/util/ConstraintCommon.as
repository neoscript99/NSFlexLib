package ns.flex.util
{

	public class ConstraintCommon
	{
		public static const account:Object=
			{expression: "\\w{2}", required: true, noSpace: true, imeDisabled: true,
				restrict: '0-9A-Za-z_'}
		public static const english:Object=
			{imeDisabled: true, required: true, expression: '^[\\x00-\\xff]*$',
				errorTip: '请输入英文'};
		public static const integer:Object=
			{noSpace: true, expression: '^-{0,1}\\d*$', required: true, imeDisabled: true,
				restrict: '\\-0-9', maxChars: 9};
		public static const justRequired:Object={required: true};
		public static const number:Object=
			{noSpace: true, expression: '^-{0,1}\\d+\.{0,1}\\d*$', required: true,
				imeDisabled: true, restrict: '\\-\\.0-9', maxChars: 18};
		public static const password:Object=
			{expression: "\\w{2}", required: true, noSpace: true, imeDisabled: true,
				displayAsPassword: true, restrict: '\u0021-\u007E'};
		public static const phone:Object=
			{noSpace: true, expression: '^[\-\+\.\(\)\\d]{5,32}$', required: true,
				imeDisabled: true, restrict: '\\-+\\.()0-9'};
		public static const url:Object=
			{noSpace: true, expression: '^[a-zA-z]+://.*$', maxChars: 256, autoTrim: true,
				errorTip: '请输入正确的网址'};

		public static function forLength(len:int, required:Boolean=true,
			noSpace:Boolean=true, imeDisabled:Boolean=true):Object
		{
			return {expression: String(".{").concat(len, "}"), required: required,
					noSpace: noSpace, imeDisabled: imeDisabled};
		}
	}
}

