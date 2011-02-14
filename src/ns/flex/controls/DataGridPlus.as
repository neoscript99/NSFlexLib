package ns.flex.controls
{
	import flash.events.ContextMenuEvent;
	import flash.system.System;
	import flash.ui.ContextMenuItem;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.CloseEvent;
	import mx.events.DataGridEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import ns.flex.support.MenuSupport;
	import ns.flex.util.ArrayCollectionPlus;
	import ns.flex.util.StringUtil;
	
	[Event(name="createItem")]
	[Event(name="modifyItem")]
	[Event(name="deleteItem")]
	[Event(name="deleteAll")]
	[Event(name="changeOrder")]
	public class DataGridPlus extends DataGrid
	{
		[Inspectable(category="General")]
		public var globalSort:Boolean=false;
		[Inspectable(category="General")]
		public var multiSort:Boolean=false;
		[Inspectable(enumeration="asc,desc", defaultValue="desc", category="General")]
		public var defaultOrder:String='desc';
		[Bindable]
		private var lastRollOverIndex:Number;
		private var orderList:ArrayCollectionPlus=new ArrayCollectionPlus();
		[Inspectable(category="General")]
		public var cmdMenu:Boolean=false;
		[Inspectable(category="General")]
		public var deleteEnabled:Boolean=true;
		[Inspectable(category="General")]
		public var deleteAllEnabled:Boolean=true;
		[Inspectable(category="General")]
		public var createEnabled:Boolean=true;
		[Inspectable(category="General")]
		public var modifyEnabled:Boolean=true;
		[Inspectable(category="General")]
		public var copyToExcelEnabled:Boolean=true;
		public var menuSupport:MenuSupport;
		
		public function DataGridPlus()
		{
			super();
			allowMultipleSelection=true;
			variableRowHeight=true;
			addEventListener(ListEvent.ITEM_ROLL_OVER, dgItemRollOver);
			addEventListener(ListEvent.ITEM_ROLL_OUT, dgItemRollOut);
			addEventListener(FlexEvent.CREATION_COMPLETE, cc);
			addEventListener(DataGridEvent.HEADER_RELEASE, onHeaderRelease);
		}
		
		public function get orders():Array
		{
			return orderList.toBiArray('sortField', 'order');
		}
		
		public function addOrder(sortField:String, order:String=null):void
		{
			pushOrder(sortField, order);
		}
		
		private function onHeaderRelease(event:DataGridEvent):void
		{
			if (!globalSort)
				return;
			var col:DataGridColumn=columns[event.columnIndex];
			
			if (col.sortable && col.dataField)
			{
				pushOrder(col.dataField);
			}
		}
		
		private function pushOrder(sortField:String, order:String=null):void
		{
			var item:Object;
			
			for (var i:int=0; i < orderList.length; i++)
				if (orderList[i].sortField == sortField)
				{
					item=orderList[i];
					item.order=(item.order == 'asc' ? 'desc' : 'asc');
					orderList.removeItemAt(i);
					break;
				}
			
			//是否可以多列排序
			if (!multiSort)
				orderList.removeAll();
			
			if (item == null)
				item={sortField: sortField, order: order == null ? defaultOrder : order};
			orderList.addFirst(item);
			refreshHeadText();
			dispatchEvent(new Event('changeOrder'));
		}
		
		private function refreshHeadText():void
		{
			for each (var col:DataGridColumn in columns)
			{
				col.headerText=col.headerText.replace(/[↑↓]\d*/g, '');
				
				if (col.sortable && col.dataField)
					for (var i:int=0; i < orderList.length; i++)
						if (orderList[i].sortField == col.dataField)
						{
							col.headerText=
								col.headerText.concat((orderList[i].order == 'asc' ? '↑' : '↓'),
								multiSort ? i + 1 : '');
						}
			}
		}
		
		private function cc(event:FlexEvent):void
		{
			menuSupport=new MenuSupport();
			this.contextMenu=menuSupport.contextMenu;
			contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT,
				contextMenu_menuSelect);
			
			if (this.cmdMenu)
			{
				if (createEnabled)
					menuSupport.createMenuItem("新增", createItem, false, true, true);
				
				if (modifyEnabled)
				{
					this.doubleClickEnabled=true;
					this.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, modifyItem);
					menuSupport.createMenuItem("修改", modifyItem);
				}
				
				if (deleteEnabled)
					menuSupport.createMenuItem("删除选中", deleteItemSelect);
				
				if (deleteAllEnabled)
					menuSupport.createMenuItem("删除全部", deleteAllItemSelect);
			}
			
			if (copyToExcelEnabled)
				enableCopyToExcel(true);
		}
		
		public function enableCopyToExcel(separatorBefore:Boolean=false):void
		{
			menuSupport.createMenuItem("复制到Excel", copyToExcel, separatorBefore);
		}
		
		private function contextMenu_menuSelect(evt:ContextMenuEvent):void
		{
			this.selectedIndex=lastRollOverIndex;
		}
		
		private function dgItemRollOver(event:ListEvent):void
		{
			lastRollOverIndex=event.rowIndex;
			
			for each (var menu:ContextMenuItem in contextMenu.customItems)
				menu.enabled=true;
		}
		
		private function dgItemRollOut(event:ListEvent):void
		{
			for each (var menu:ContextMenuItem in contextMenu.customItems)
				menu.enabled=menuSupport.isAlwaysEnabled(menu);
		}
		
		private function createItem(evt:ContextMenuEvent):void
		{
			dispatchEvent(new Event('createItem'));
		}
		
		private function modifyItem(evt:Event):void
		{
			dispatchEvent(new Event('modifyItem'));
		}
		
		private function deleteItemSelect(evt:ContextMenuEvent):void
		{
			Alert.show("确认删除？", null, Alert.YES | Alert.NO, this, deleteItem)
		}
		
		private function copyToExcel(evt:ContextMenuEvent):void
		{
			var spiltor:String='	';
			var ss:String='';
			
			for (var k:int=0; k < columns.length; k++)
			{
				ss=
					ss.concat(StringUtil.toLine(columns[k].headerText),
					k == columns.length - 1 ? '' : spiltor);
			}
			ss+='\n';
			var list:Object=selectedItems.length > 1 ? selectedItems : dataProvider;
			
			for (var i:int=0; i < list.length; i++)
			{
				for (var j:int=0; j < columns.length; j++)
				{
					ss=
						ss.concat(StringUtil.toLine(columns[j].itemToLabel(list[i])),
						j == columns.length - 1 ? '' : spiltor);
				}
				ss=ss.concat('\n');
			}
			System.setClipboard(ss);
		}
		
		private function deleteAllItemSelect(evt:ContextMenuEvent):void
		{
			Alert.show("确认全部删除？", null, Alert.YES | Alert.NO, this, deleteAllItem)
		}
		
		private function deleteItem(evt:CloseEvent):void
		{
			if (evt.detail == Alert.YES)
			{
				dispatchEvent(new Event('deleteItem'));
			}
		}
		
		private function deleteAllItem(evt:CloseEvent):void
		{
			if (evt.detail == Alert.YES)
			{
				dispatchEvent(new Event('deleteAll'));
			}
		}
	}
}