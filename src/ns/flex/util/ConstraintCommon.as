package ns.flex.util
{
	
	public class ConstraintCommon
	{
		static public const phone:Object=
			{noSpace: true, expression: '^[\-\+\.\(\)\\d]{5,32}$', required: true,
				imeDisabled: true, restrict: '\-\+\.\(\)\\d'};
		static public const number:Object=
			{noSpace: true, expression: '^\\d+\.{0,1}\\d*$', required: true,
				imeDisabled: true, restrict: '\.0-9'};
		static public const justRequired:Object={required: true};
		static public const noSpaceFour:Object=
			{expression: ".{4}", noSpace: true, imeDisabled: true, required: true};
	}
}