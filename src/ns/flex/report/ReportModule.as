package ns.flex.report
{

	import flash.events.Event;

	import mx.events.FlexEvent;
	import mx.rpc.remoting.mxml.RemoteObject;

	import ns.flex.controls.DataGridPlus;
	import ns.flex.module.AbstractModule;
	import ns.flex.util.ContainerUtil;

	public class ReportModule extends AbstractModule
	{
		[Bindable]
		protected var reportService:RemoteObject;
		protected var map:Object={};

		/**
		 * 必须在继承的类中初始化reportService
		 */
		public function ReportModule()
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, cc);
		}

		protected function cc(e:Event):void
		{
			query();
		}

		protected function get reportBar():ReportControlBar
		{
			if (!map.reportBar)
				map.reportBar=ContainerUtil.findContainerChild(this, ReportControlBar);
			return map.reportBar;
		}

		protected function get queryParam():Object
		{
			return reportBar.queryParam;
		}

		public function query():void
		{
			reportService.list(queryParam, domain);
		}

		protected function get domain():String
		{
			return this.className;
		}

		protected function get dgp():DataGridPlus
		{
			if (!map.dgp)
				map.dgp=
					ContainerUtil.findContainerChild(this, DataGridPlus) as DataGridPlus;
			return map.dgp;
		}

		protected function get item():Object
		{
			return dgp.selectedItem;
		}
	}
}

