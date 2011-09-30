package ns.flex.report
{
	import ns.flex.controls.Paging;
	import ns.flex.util.ContainerUtil;
	import ns.flex.util.SQLUtil;

	public class PagedReportModule extends ReportModule
	{

		override public function query():void
		{
			queryPage(-1)
		}

		public function queryPage(first:int):void
		{
			SQLUtil.countAndList(reportService, queryParam, paging.offset.value,
				paging.forFirst(first), dgp.orders, domain);
		}

		protected function get paging():Paging
		{
			if (!map.paging)
				map.paging=ContainerUtil.findContainerChild(this, Paging);
			return map.paging;
		}

	}
}

