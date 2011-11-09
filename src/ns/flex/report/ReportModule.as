package ns.flex.report
{
	import flash.events.Event;

	import mx.events.FlexEvent;
	import mx.rpc.remoting.mxml.RemoteObject;

	import ns.flex.controls.DataGridPlus;
	import ns.flex.controls.Paging;
	import ns.flex.module.AbstractModule;
	import ns.flex.util.ContainerUtil;
	import ns.flex.util.SQLUtil;

	public class ReportModule extends AbstractModule
	{
		public var paged:Boolean=false;
		protected var map:Object={};
		[Bindable]
		protected var reportService:RemoteObject;

		/**
		 * 必须在继承的类中初始化reportService
		 */
		public function ReportModule()
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, cc);
		}

		public function query():void
		{
			if (paged)
				queryPage(-1)
			else
				reportService.list(queryParam, domain);
		}

		public function queryPage(first:int):void
		{
			SQLUtil.countAndList(reportService, queryParam, paging.offset.value,
				paging.forFirst(first), dgp.orders, domain);
		}

		protected function cc(e:Event):void
		{
			query();
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

