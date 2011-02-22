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
			separatorBefore:Boolean=false, alwaysEnabled:Boolean=false, position:int=
			-1):ContextMenuItem
		{
			var menuItem:ContextMenuItem=
				new ContextMenuItem(caption, separatorBefore, alwaysEnabled);
			menuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, listener);
			alwaysEnabledMap[getMenuCode(menuItem)]=alwaysEnabled;
			pushMenuItem(menuItem, position);
			return menuItem;
		}
		
		private function getMenuCode(item:ContextMenuItem):String
		{
			return item.caption;
		}
		
		private function pushMenuItem(item:ContextMenuItem, position:int):void
		{
			if (position == 0)
				contextMenu.customItems.unshift(item);
			else
				contextMenu.customItems.push(item);
			trace(contextMenu.customItems)
			if (position > 0)
			{
				for (var i:int=position; i < contextMenu.customItems.length - 1; i++)
					contextMenu.customItems[i + 1]=contextMenu.customItems[i];
				contextMenu.customItems[position]=item;
			}
			trace(contextMenu.customItems)
		}
		
		public function clearCustomMenu():void
		{
			contextMenu.customItems=[];
		}
	}
}