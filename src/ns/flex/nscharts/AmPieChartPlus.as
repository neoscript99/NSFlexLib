package ns.flex.nscharts
{
	import com.amcharts.AmPieChart;

	import ns.flex.util.UIUtil;

	public class AmPieChartPlus extends AmPieChart
	{
		override protected function createChildren():void
		{
			super.createChildren();
			UIUtil.removeAmLink(this)
		}
	}
}

