package ns.flex.report
{
	import flash.events.Event;
	import mx.containers.Panel;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	import ns.flex.controls.DataGridPlus;
	import ns.flex.controls.Paging;
	import ns.flex.controls.ProgressBox;
	import ns.flex.module.AbstractModule;
	import ns.flex.util.ContainerUtil;
	import ns.flex.util.SQLUtil;

	public class ReportModule extends AbstractModule
	{
		[Bindable]
		public var drillDepth:int=0;

		[Inspectable(category="General")]
		[Bindable]
		public var drillable:Boolean=false;
		protected var drillLast:Object;
		protected var map:Object={};
		[Bindable]
		protected var reportService:RemoteObject;
		private var drillHist:Array=[];
		private var drillPageHist:Array=[];
		private var popProgress:ProgressBox=new ProgressBox;

		/**
		 * 必须在继承的类中初始化reportService
		 */
		public function ReportModule()
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, cc);
		}

		public function query(first:int=-1):void
		{
			if (paging)
				queryPage(first)
			else
				SQLUtil.list(reportService, queryParam, -1, 0, dgp.orders, domain);
		}

		public function queryPage(first:int):void
		{
			SQLUtil.countAndList(reportService, queryParam, paging.offset.value,
				paging.forFirst(first), dgp.orders, domain);
		}

		protected function cc(e:Event):void
		{
			query();
			reportService.getOperation('export').addEventListener(ResultEvent.RESULT,
				exportFile);
			if (drillable)
				drillInit();
		}

		protected function get dgp():DataGridPlus
		{
			if (!map.dgp)
				map.dgp=
					ContainerUtil.findContainerChild(this, DataGridPlus) as DataGridPlus;
			return map.dgp;
		}

		protected function get domain():String
		{
			return this.className;
		}

		protected function drillDown(e:Event):void
		{
			if (drillDepth < drillMaxDepth - 1 && dgp.selectedOriItem)
			{
				drillPageHist.push(paging ? paging.first : -1);
				if (drillLast)
					drillHist.push(drillLast);
				drillLast=drillNow;
				drillDepth++;
				query();
			}
		}

		protected function drillInit():void
		{
			dgp.menuSupport.createMenuItem('向下钻取', drillDown, true);
			dgp.menuSupport.createMenuItem('向上钻取', drillUp);
			dgp.menuSupport.createMenuItem('返回顶层', drillTop, false, true);
			dgp.doubleClickEnabled=true;
			dgp.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, drillDown);
		}

		protected function get drillMaxDepth():int
		{
			return 0;
		}

		protected function get drillNow():Object
		{
			throw new Error('Please override this method')
		}

		protected function drillTop(e:Event):void
		{
			drillDepth=0;
			drillLast=null;
			drillHist=[];
			query(drillPageHist[0]);
			drillPageHist=[]
		}

		protected function drillUp(e:Event):void
		{
			if (drillDepth > 0)
			{
				drillLast=drillHist.pop();
				drillDepth--;
				query(drillPageHist.pop());
			}
		}

		protected function export():void
		{
			popProgress.show(this)
			reportService.export(exportParam, domain);
		}

		protected function exportFile(evt:Event):void
		{
			popProgress.close()
			dgp.saveAsExcelWithAlert(reportService.export.lastResult, exportFileName)
		}

		protected function get exportFileName():String
		{

			var panel:Panel=ContainerUtil.findParent(this, Panel) as Panel;
			return panel ? panel.title : name;
		}

		protected function get exportParam():Object
		{
			return queryParam;
		}

		protected function get item():Object
		{
			return dgp.selectedOriItem;
		}

		protected function get paging():Paging
		{
			if (!map.paging)
				map.paging=ContainerUtil.findContainerChild(this, Paging);
			return map.paging;
		}

		protected function get queryParam():Object
		{
			return reportBar.queryParam;
		}

		protected function get reportBar():ReportControlBar
		{
			if (!map.reportBar)
				map.reportBar=ContainerUtil.findContainerChild(this, ReportControlBar);
			return map.reportBar;
		}
	}
}

