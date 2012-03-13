package ns.flex.util
{
	
	public class ConstraintCommon
	{
		static public const phone:Object=
			{noSpace: true, expression: '^[\-\+\.\(\)\\d]{5,32}$', required: true,
				imeDisabled: true, restrict: '\\-+.()0-9'};
		static public const number:Object=
			{noSpace: true, expression: '^-{0,1}\\d+\.{0,1}\\d*$', required: true,
				imeDisabled: true, restrict: '-.0-9'};
		static public const justRequired:Object={required: true};
		
		static public function forLength(len:int, required:Boolean=true, noSpace:Boolean=
			true, imeDisabled:Boolean=true):Object
		{
			return {expression: String(".{").concat(len, "}"), required: required,
					noSpace: noSpace, imeDisabled: imeDisabled};
		}
	}
}