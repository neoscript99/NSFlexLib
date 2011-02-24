package ns.flex.controls
{
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.system.System;
	import flash.ui.ContextMenuItem;
	import mx.containers.Form;
	import mx.containers.FormItem;
	import mx.containers.HBox;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.CloseEvent;
	import mx.events.DataGridEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.utils.ObjectProxy;
	import mx.utils.ObjectUtil;
	import ns.flex.event.SaveItemEvent;
	import ns.flex.support.MenuSupport;
	import ns.flex.util.ArrayCollectionPlus;
	import ns.flex.util.ContainerUtil;
	import ns.flex.util.StringUtil;
	
	[Event(name="createItem")]
	[Event(name="saveItem", type="ns.flex.event.SaveItemEvent")]
	[Event(name="modifyItem")]
	[Event(name="deleteItems")]
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
		[Inspectable(enumeration="none,read,write", defaultValue="none",
			category="General")]
		public var showDetail:String='none';
		[Inspectable(category="General")]
		public var showDetailPopWidth:int=-1;
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
		[Bindable]
		public var editingItem:ObjectProxy;
		private var popEditing:PopWindow;
		
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
		
		public function resetMenu():void
		{
			menuSupport=new MenuSupport(this, contextMenu_menuSelect);
			var separatorCount:int=0;
			
			if (showDetail == 'write')
			{
				if (!(cmdMenu && createEnabled))
					enableMenu("新增", function(evt:Event):void
						{
							showItemDetail(null, true);
						}, (separatorCount++ == 0), true);
				
				if (!(cmdMenu && modifyEnabled))
					enableMenu("修改", function(evt:Event):void
						{
							showItemDetail(selectedItem, true);
						}, (separatorCount++ == 0), false, true);
			}
			else if (showDetail == 'read')
				if (!(cmdMenu && modifyEnabled))
					enableMenu('查看', function(evt:Event):void
						{
							showItemDetail(selectedItem, false);
						}, (separatorCount++ == 0), false, true);
			
			if (this.cmdMenu)
			{
				if (createEnabled)
					enableMenu("新增", createItem, (separatorCount++ == 0), true);
				
				if (modifyEnabled)
					enableMenu("修改", modifyItem, (separatorCount++ == 0));
				
				if (deleteEnabled)
					enableMenu("删除选中", deleteItems, (separatorCount++ == 0));
				
				if (deleteAllEnabled)
					enableMenu("删除全部", deleteAll, (separatorCount++ == 0));
			}
			
			if (copyToExcelEnabled)
				enableMenu("复制到Excel", copyToExcel, true);
		}
		
		private function cc(event:FlexEvent):void
		{
			resetMenu();
		}
		
		private function enableMenu(menuLabel:String, action:Function,
			separatorBefore:Boolean=false, alwaysEnabled:Boolean=false,
			withDoubleClick:Boolean=false):void
		{
			menuSupport.createMenuItem(menuLabel, action, separatorBefore, alwaysEnabled);
			
			if (withDoubleClick && !doubleClickEnabled)
			{
				this.doubleClickEnabled=true;
				this.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, action);
			}
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
		
		private function createItem(evt:Event):void
		{
			dispatchEvent(new Event('createItem'));
		}
		
		private function modifyItem(evt:Event):void
		{
			dispatchEvent(new Event('modifyItem'));
		}
		
		private function deleteItems(evt:Event):void
		{
			Alert.show("确认删除？", null, Alert.YES | Alert.NO, this,
				function(evt:CloseEvent):void
				{
					if (evt.detail == Alert.YES)
					{
						dispatchEvent(new Event('deleteItems'));
					}
				})
		}
		
		public function closePopEditing():void
		{
			if (popEditing)
				popEditing.close();
		}
		
		public function closeProgress():void
		{
			if (popEditing)
				popEditing.closeProgress();
		}
		
		/**
		 * 生成默认的详细对话框
		 * @param evt
		 */
		private function showItemDetail(showItem:Object, editable:Boolean=false):void
		{
			editingItem=new ObjectProxy(ObjectUtil.copy(showItem));
			var form:Form=new Form();
			
			for each (var col:DataGridColumn in columns)
			{
				form.addChild(new DataColumnFormItem(this, col, editable));
			}
			popEditing=
				ContainerUtil.showPopUP(editable ? (showItem ? '修改' : '新增') : '查看', this,
				form, showDetailPopWidth, -1, false);
			
			if (editable)
			{
				var buttonItem:FormItem=new FormItem();
				var hbox:HBox=new HBox;
				var saveButton:Button=new Button();
				saveButton.label='保存';
				saveButton.addEventListener('click', function(e:Event):void
					{
						for each (var it:FormItem in form.getChildren())
							if (it is DataColumnFormItem)
								if (!(it as DataColumnFormItem).validated)
								{
									popEditing.shake.play();
									return;
								}
						popEditing.showProgress();
						dispatchEvent(new SaveItemEvent(editingItem));
					});
				var resetButton:Button=new Button();
				resetButton.label='重置';
				resetButton.addEventListener('click', function(e:Event):void
					{
						editingItem=new ObjectProxy(ObjectUtil.copy(showItem));
					});
				hbox.addChild(saveButton);
				hbox.addChild(resetButton);
				buttonItem.addChild(hbox);
				form.addChild(buttonItem);
			}
		}
		
		private function copyToExcel(evt:Event):void
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
		
		private function deleteAll(evt:Event):void
		{
			Alert.show("确认全部删除？", null, Alert.YES | Alert.NO, this,
				function(evt:CloseEvent):void
				{
					if (evt.detail == Alert.YES)
					{
						dispatchEvent(new Event('deleteAll'));
					}
				})
		}
	}
}