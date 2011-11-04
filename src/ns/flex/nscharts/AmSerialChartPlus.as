package ns.flex.nscharts
{
	import com.amcharts.AmSerialChart;

	import ns.flex.util.UIUtil;

	public class AmSerialChartPlus extends AmSerialChart
	{
		override protected function createChildren():void
		{
			super.createChildren();
			UIUtil.removeAmLink(this)
		}
	}
}

