package ns.flex.event
{
	import flash.events.Event;
	
	public class SaveItemEvent extends Event
	{
		public var saveItem:Object;
		
		public function SaveItemEvent(item:Object, bubbles:Boolean=false,
			cancelable:Boolean=false)
		{
			saveItem=item;
			super('saveItem', bubbles, cancelable);
		}
	}
}