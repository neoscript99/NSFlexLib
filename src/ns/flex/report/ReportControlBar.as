package ns.flex.report
{
	import flash.events.Event;

	import mx.containers.ApplicationControlBar;

	[Event(name="change")]
	public class ReportControlBar extends ApplicationControlBar
	{
		protected function change():void
		{
			dispatchEvent(new Event('change'))
		}

		public function get queryParam():Object
		{
			return null;
		}

	}
}

