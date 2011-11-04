package ns.flex.amcharts
{
	import com.amcharts.AmPieChart;

	import ns.flex.util.UIUtil;

	public class NsPieChart extends AmPieChart
	{
		public function NsPieChart()
		{
			super();
		}

		override protected function createChildren():void
		{
			super.createChildren();
			UIUtil.removeAmLink(this)
		}
	}
}

