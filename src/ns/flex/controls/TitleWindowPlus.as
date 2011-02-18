package ns.flex.controls
{
	import flash.events.MouseEvent;
	import mx.containers.TitleWindow;
	import mx.events.FlexEvent;
	
	[Event(name="titleDoubleClick", type="flash.events.MouseEvent")]
	public class TitleWindowPlus extends TitleWindow
	{
		public function TitleWindowPlus()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, cc);
		}
		
		private function cc(e:FlexEvent):void
		{
			this.titleBar.doubleClickEnabled=true;
			this.titleBar.addEventListener(MouseEvent.DOUBLE_CLICK, onTitleDoubleClick);
		}
		
		protected function onTitleDoubleClick(e:MouseEvent):void
		{
			dispatchEvent(new MouseEvent('titleDoubleClick', e.bubbles, e.cancelable,
				e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey,
				e.buttonDown, e.delta));
		}
	}
}