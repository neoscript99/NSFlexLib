package ns.flex.util
{

	public class ConstraintCommon
	{
		public static const integer:Object=
			{noSpace: true, expression: '^-{0,1}\\d+\.{0,1}\\d*$', required: true,
				imeDisabled: true, restrict: '-0-9', maxChars: 9};
		public static const justRequired:Object={required: true};
		public static const number:Object=
			{noSpace: true, expression: '^-{0,1}\\d+\.{0,1}\\d*$', required: true,
				imeDisabled: true, restrict: '-.0-9', maxChars: 18};
		public static const phone:Object=
			{noSpace: true, expression: '^[\-\+\.\(\)\\d]{5,32}$', required: true,
				imeDisabled: true, restrict: '\\-+.()0-9'};

		public static function forLength(len:int, required:Boolean=true,
			noSpace:Boolean=true, imeDisabled:Boolean=true):Object
		{
			return {expression: String(".{").concat(len, "}"), required: required,
					noSpace: noSpace, imeDisabled: imeDisabled};
		}
	}
}

