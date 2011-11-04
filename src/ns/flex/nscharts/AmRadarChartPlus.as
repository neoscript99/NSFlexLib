package ns.flex.nscharts
{
	import com.amcharts.AmRadarChart;

	import ns.flex.util.UIUtil;

	public class AmRadarChartPlus extends AmRadarChart
	{
		override protected function createChildren():void
		{
			super.createChildren();
			UIUtil.removeAmLink(this)
		}
	}
}

