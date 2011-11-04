package ns.flex.nscharts
{
	import com.amcharts.AmXYChart;

	import ns.flex.util.UIUtil;

	public class AmXYChartPlus extends AmXYChart
	{
		override protected function createChildren():void
		{
			super.createChildren();
			UIUtil.removeAmLink(this)
		}
	}
}

