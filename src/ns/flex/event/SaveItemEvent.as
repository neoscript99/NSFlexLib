package ns.flex.event
{
	import flash.events.Event;
	
	public class SaveItemEvent extends Event
	{
		public var dataItem:Object;
		
		public function SaveItemEvent(item:Object, bubbles:Boolean=false,
			cancelable:Boolean=false)
		{
			dataItem=item;
			super('saveItem', bubbles, cancelable);
		}
	}
}