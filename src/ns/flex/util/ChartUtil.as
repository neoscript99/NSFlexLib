package ns.flex.util
{
	import flash.display.DisplayObject;
	import mx.binding.utils.BindingUtils;
	import mx.charts.CategoryAxis;
	import mx.charts.ColumnChart;
	import mx.charts.Legend;
	import mx.charts.LineChart;
	import mx.charts.PieChart;
	import mx.charts.events.ChartItemEvent;
	import mx.charts.series.ColumnSeries;
	import mx.charts.series.LineSeries;
	import mx.charts.series.PieSeries;
	import mx.containers.HBox;
	import mx.core.ClassFactory;
	import mx.rpc.remoting.mxml.Operation;
	
	/**
	 * 图形显示工具类
	 * @author wangchu
	 */
	public class ChartUtil
	{
		/**
		 * 产生饼图
		 * @param chartName 标题
		 * @param parent 父显示对象
		 * @param chartData 原数据
		 * @param field 值字段
		 * @param nameField 名称字段
		 * @param itemClick 点击时的回调函数
		 * @param width 初始宽
		 * @param height 初始高
		 */
		static public function showPie(chartName:String, parent:DisplayObject,
			chartData:Array, field:String='value', nameField:String='name',
			itemClick:Function=null, width:int=480, height:int=400):void
		{
			for each (var o:Object in chartData)
			{
				o[field]=Number(o[field]).toFixed(2);
			}
			var pc:PieChart=new PieChart();
			pc.dataProvider=chartData;
			pc.showDataTips=true;
			BindingUtils.bindProperty(pc, 'width', pc, 'height');
			pc.percentHeight=100;
			
			if (itemClick != null)
				pc.addEventListener(ChartItemEvent.ITEM_CLICK, itemClick);
			var ps:PieSeries=new PieSeries();
			ps.field=field;
			ps.nameField=nameField;
			pc.series=[ps];
			var legend:Legend=new Legend();
			legend.dataProvider=pc;
			
			with (ContainerUtil)
			{
				showPopUP(chartName, parent,
					generateContainer(new ClassFactory(HBox), pc, legend), width, height);
			}
		}
		
		/**
		 * 曲线图
		 * @param chartName 标题
		 * @param parent 父显示对象
		 * @param operation 提供数据的远程对象方法
		 * @param categoryField x轴字段
		 * @param series y轴字段序列
		 * @param itemClick 点击回调函数
		 * @param width 宽
		 * @param height 高
		 */
		static public function showLine(chartName:String, parent:DisplayObject,
			operation:Operation, categoryField:String, series:Array, itemClick:Function=
			null, width:int=700, height:int=400):void
		{
			var lineChart:LineChart=new LineChart();
			//lineChart.dataProvider=chartData;
			BindingUtils.bindProperty(lineChart, 'dataProvider', operation, 'lastResult');
			lineChart.percentWidth=100;
			lineChart.percentHeight=100;
			lineChart.showDataTips=true;
			
			if (itemClick != null)
				lineChart.addEventListener(ChartItemEvent.ITEM_CLICK, itemClick);
			var axis:CategoryAxis=new CategoryAxis();
			axis.categoryField=categoryField;
			axis.ticksBetweenLabels=false;
			BindingUtils.bindProperty(axis, 'dataProvider', operation, 'lastResult');
			lineChart.horizontalAxis=axis;
			
			for each (var s:Object in series)
			{
				var ls:LineSeries=new LineSeries();
				ls.yField=s.yField;
				ls.displayName=s.displayName;
				//忽略miss数据，曲线连续
				ls.interpolateValues=true;
				ls.setStyle('form', 'curve');
				lineChart.series.push(ls);
			}
			var legend:Legend=new Legend();
			legend.dataProvider=lineChart;
			
			with (ContainerUtil)
			{
				showPopUP(chartName, parent,
					generateContainer(new ClassFactory(HBox), lineChart, legend), width,
					height);
			}
		}
		
		/**
		 * 列图
		 * @param chartName 标题
		 * @param parent 父显示对象
		 * @param chartData 绑定数据源
		 * @param categoryField x轴字段
		 * @param series y轴字段序列
		 * @param itemClick 点击回调函数
		 * @param width 宽
		 * @param height 高
		 */
		static public function showColumn(chartName:String, parent:DisplayObject,
			chartData:Array, categoryField:String, series:Array, itemClick:Function=null,
			width:int=700, height:int=400):void
		{
			var columnChart:ColumnChart=new ColumnChart();
			columnChart.dataProvider=chartData;
			columnChart.showDataTips=true;
			columnChart.percentWidth=100;
			columnChart.percentHeight=100;
			
			if (itemClick != null)
				columnChart.addEventListener(ChartItemEvent.ITEM_CLICK, itemClick);
			var axis:CategoryAxis=new CategoryAxis();
			axis.categoryField=categoryField;
			columnChart.horizontalAxis=axis;
			
			for each (var s:Object in series)
			{
				var cs:ColumnSeries=new ColumnSeries()
				cs.xField=s.xField;
				cs.yField=s.yField;
				cs.displayName=s.displayName;
				columnChart.series.push(cs);
			}
			var legend:Legend=new Legend();
			legend.dataProvider=columnChart;
			
			with (ContainerUtil)
			{
				showPopUP(chartName, parent,
					generateContainer(new ClassFactory(HBox), columnChart, legend), width,
					height);
			}
		}
	}
}