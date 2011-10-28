package ns.flex.controls
{
	import mx.binding.utils.BindingUtils;

	import ns.flex.popup.PopLineChart;

	public class DataGridChart extends DataGridPlus
	{
		private var _lineChart:PopLineChart;

		public function get lineChart():PopLineChart
		{
			if (!_lineChart)
				_lineChart=new PopLineChart;
			return _lineChart
		}

		public function bindLineData(host:Object, chain:Object,
			commitOnly:Boolean=false):void
		{
			BindingUtils.bindProperty(lineChart, 'chartData', host, chain, commitOnly);
		}

		/**
		 * 生成趋势图的列索引，从1开始
		 * @param colIds
		 */
		public function set lineColumnIndexes(indexes:Array):void
		{
			if (indexes.length > 0)
			{
				var seriesInfos:Array=[];
				for each (var i:int in indexes)
					seriesInfos.push({yField: columns[i - 1].dataField,
							displayName: columns[i - 1].headerText});
				lineChart.seriesInfos=seriesInfos;
			}
		}

		public function showLine(title:String='趋势图'):void
		{
			lineChart.bindTitle=title;
			lineChart.show(root);
		}
	}
}

