package ns.flex.support
{
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	public class MenuSupport
	{
		public var contextMenu:ContextMenu;
		//用于需要判断是否选择记录进行处理的控件,如datagrid等
		private var alwaysEnabledMap:Object={};
		
		public function MenuSupport()
		{
			contextMenu=new ContextMenu();
			contextMenu.hideBuiltInItems();
			contextMenu.customItems=[];
		}
		
		public function isAlwaysEnabled(item:ContextMenuItem):Boolean
		{
			return alwaysEnabledMap[getMenuCode(item)];
		}
		
		public function createMenuItem(caption:String, listener:Function,
			separatorBefore:Boolean=false, enabled:Boolean=false, alwaysEnabled:Boolean=
			false):ContextMenuItem
		{
			var menuItem:ContextMenuItem=
				new ContextMenuItem(caption, separatorBefore, enabled);
			menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, listener);
			alwaysEnabledMap[getMenuCode(menuItem)]=alwaysEnabled;
			pushMenuItems(menuItem);
			return menuItem;
		}
		
		private function getMenuCode(item:ContextMenuItem):String
		{
			return item.caption;
		}
		
		public function pushMenuItems(... items):void
		{
			for each (var item:* in items)
				contextMenu.customItems.push(item);
		}
		
		public function clearCustomMenu():void
		{
			contextMenu.customItems=[];
		}
	}
}