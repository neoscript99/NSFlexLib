package ns.flex.controls
{
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.system.System;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	import mx.collections.IList;
	import mx.containers.Form;
	import mx.containers.FormItem;
	import mx.containers.HBox;
	import mx.controls.Button;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.DataGridEvent;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.utils.ObjectProxy;
	import mx.utils.ObjectUtil;
	import mx.utils.UIDUtil;
	import ns.flex.event.SaveItemEvent;
	import ns.flex.support.MenuSupport;
	import ns.flex.util.ArrayCollectionPlus;
	import ns.flex.util.ContainerUtil;
	import ns.flex.util.IOUtil;
	import ns.flex.util.MathUtil;
	import ns.flex.util.MessageUtil;
	import ns.flex.util.ObjectUtils;
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
		public var copyToExcelEnabled:Boolean=true;
		[Inspectable(category="General")]
		public var createEnabled:Boolean=false;
		[Inspectable(enumeration="asc,desc", defaultValue="desc", category="General")]
		public var defaultOrder:String='desc';
		[Inspectable(category="General")]
		public var deleteAllEnabled:Boolean=false;
		[Inspectable(category="General")]
		public var deleteEnabled:Boolean=false;
		public var exportName:String;
		[Inspectable(category="General")]
		public var globalSort:Boolean=false;
		public var menuSupport:MenuSupport;
		[Inspectable(category="General")]
		public var modifyEnabled:Boolean=false;
		//如果有嵌套字段，排序顺序无法保证，不要使用
		[Inspectable(category="General")]
		public var multiSort:Boolean=false;
		public var popEditing:PopWindow;
		[Inspectable(category="General")]
		public var popEnterSubmit:Boolean=true;
		public var popTitleFunciton:Function;
		public var popView:PopWindow;
		[Inspectable(enumeration="none,new,view,edit,new-edit,view-edit,new-view-edit",
			defaultValue="none", category="General")]
		public var showDetail:String='none';
		[Inspectable(category="General")]
		public var showIndex:Boolean=true;
		[Bindable]
		public var showItemProxy:ObjectProxy=new ObjectProxy();
		[Inspectable(category="General")]
		public var showOnlyVisible:Boolean=true;
		[Inspectable(category="General")]
		public var showSum:Boolean=false;
		public var sumColumnLabel:String='◆汇总◆';
		private var indexColumn:DataGridColumnPlus;
		[Bindable]
		private var lastRollOverIndex:Number;
		private var orderList:ArrayCollectionPlus=new ArrayCollectionPlus();
		private var replacableDoubleClickHandler:Function;
		private var showItem:Object;

		public function DataGridPlus()
		{
			super();
			allowMultipleSelection=true;
			toolTip='右键菜单更多功能';
			//variableRowHeight为true后，再设置rowCount，得到的最终rowCount可能不准确
			//height=第一行rowHeignt*rowCount
			variableRowHeight=true;
			addEventListener(ListEvent.ITEM_ROLL_OVER, dgItemRollOver);
			addEventListener(ListEvent.ITEM_ROLL_OUT, dgItemRollOut);
			addEventListener(FlexEvent.INITIALIZE, init);
			addEventListener(DataGridEvent.HEADER_RELEASE, onHeaderRelease);
		}

		override public function addEventListener(type:String, listener:Function,
			useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			if (type == ListEvent.ITEM_DOUBLE_CLICK &&
				replacableDoubleClickHandler != null)
			{
				this.removeEventListener(ListEvent.ITEM_DOUBLE_CLICK,
					replacableDoubleClickHandler);
			}
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		public function addOrder(sortField:String, order:String=null):void
		{
			var item:Object;

			for (var i:int=0; i < orderList.length; i++)
				if (orderList[i].sortField == sortField)
				{
					item=orderList[i];
					item.order=
						order == null ? (item.order == 'asc' ? 'desc' : 'asc') : order;
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
		}

		public function closePop():void
		{
			if (popEditing)
				popEditing.close();

			if (popView)
				popView.close();
		}

		public function closeProgress():void
		{
			if (popEditing)
				popEditing.closeProgress();
		}

		[Inspectable(category="Data", defaultValue="undefined")]
		override public function set dataProvider(value:Object):void
		{
			trace('set dataProvider');
			if (showSum && value)
			{
				//clone source
				var acp:ArrayCollectionPlus=new ArrayCollectionPlus(value);
				var sumItem:Object={uniqueIdForSumItem: uid};
				var hasGroupColumn:Boolean=false;
				if (acp.length > 0)
				{
					var minVisible:int=-1;
					var cols:Array=columns;
					for (var ci:int=0; ci < cols.length; ci++)
					{
						var col:DataGridColumn=cols[ci];
						if (col.dataField)
						{
							if (minVisible < 0 && col.visible)
								minVisible=ci;
							var genValue:Object=''
							if (col is DataGridColumnPlus && col['groupMethod'] &&
								col['groupMethod'] != 'none')
							{
								hasGroupColumn=true;
								var valueArray:Array=[];
								for (var i:int=0; i < acp.length; i++)
									valueArray.push((col as DataGridColumnPlus).getValue(acp[i]));
								genValue=MathUtil[col['groupMethod']](valueArray);
							}
							else if (minVisible == ci)
								genValue=sumColumnLabel
							ObjectUtils.setValue(sumItem, col.dataField, genValue);
						}
					}
					if (hasGroupColumn)
						acp.addItem(sumItem);
					super.dataProvider=acp;
					return;
				}
			}
			super.dataProvider=value;
		}

		public function get editableColumns():Array
		{
			return (showOnlyVisible ? visibleColumns : columns).filter(function(item:DataGridColumn,
					index:int, array:Array):Boolean
					{
						return item.editable;
					})
		}

		public function getSelectedFieldArray(field:String):Array
		{
			return new ArrayCollectionPlus(selectedItems).getFieldArray(field)
		}

		public function initPopEditing():PopWindow
		{
			if (popEditing)
				return popEditing;
			popEditing=initPop(true);
			addEventListener('resetEditItem', function(e:Event):void
			{
				showItemProxy=new ObjectProxy(ObjectUtil.copy(showItem));
			});
			return popEditing;
		}

		public function initPopView():PopWindow
		{
			if (!popView)
				popView=initPop(false);
			return popView;
		}

		public function isSumItem(item:Object):Boolean
		{
			return item.uniqueIdForSumItem == uid;
		}

		public function get orders():Array
		{
			return orderList.toBiArray('sortField', 'order');
		}

		public function resetMenu():void
		{
			menuSupport=new MenuSupport(this, contextMenu_menuSelect);
			var separatorCount:int=0;

			if (createEnabled)
				enableMenu("新增", createItem, (separatorCount++ == 0), true);
			else if (showDetail.indexOf('new') > -1)
				enableMenu("新增", function(evt:Event):void
				{
					showItemDetail(null, true);
				}, (separatorCount++ == 0), true);

			if (showDetail.indexOf('view') > -1)
				enableMenu('查看', function(evt:Event):void
				{
					showItemDetail(selectedItem, false);
				}, (separatorCount++ == 0), false, true);

			if (modifyEnabled)
				enableMenu("修改", modifyItem, (separatorCount++ == 0), false, true);
			else if (showDetail.indexOf('edit') > -1)
				enableMenu("修改", function(evt:Event):void
				{
					showItemDetail(selectedItem, true);
				}, (separatorCount++ == 0), false, true);

			if (deleteEnabled)
				enableMenu("删除选中", deleteItems, (separatorCount++ == 0));

			if (deleteAllEnabled)
				enableMenu("删除全部", deleteAll, (separatorCount++ == 0), true);

			if (copyToExcelEnabled)
			{
				enableMenu("复制选择行", copySelectedToExcel, true);
				enableMenu("复制全部行", copyTotalToExcel);
				enableMenu("另存为Excel", saveToExcel);
			}
		}

		public function rowsToExcel(dataList:Object):ByteArray
		{
			var cols:Array=viewableColumns;
			var sheet:Sheet=new Sheet();
			sheet.resize(dataList ? dataList.length + 1 : 1, cols.length);
			for (var k:int=0; k < cols.length; k++)
				sheet.setCell(0, k, cols[k].headerText)

			if (dataList)
				for (var i:int=0; i < dataList.length; i++)
					for (var j:int=0; j < cols.length; j++)
					{
						var vStr:String=cols[j].itemToLabel(dataList[i]);
						//Excel 超过10位会自动科学计数、超过15位尾数丢失，以下防止类似情况发生
						if (vStr.length > 10 && !isNaN(Number(vStr)))
							vStr='[' + vStr + ']';
						sheet.setCell(i + 1, j, vStr);
					}

			var xls:ExcelFile=new ExcelFile();
			xls.sheets.addItem(sheet);

			return xls.saveToByteArray();
		}

		public function rowsToString(dataList:Object, spiltor:String='	',
			withHead:Boolean=true):String
		{
			var ss:String='';
			var cols:Array=visibleColumns;
			if (withHead)
			{
				for (var k:int=0; k < cols.length; k++)
					ss=
						ss.concat(StringUtil.toLine(cols[k].headerText),
						k == cols.length - 1 ? '' : spiltor);
				ss+='\n';
			}

			if (dataList)
				for (var i:int=0; i < dataList.length; i++)
				{
					for (var j:int=0; j < cols.length; j++)
						ss=
							ss.concat(StringUtil.toLine(cols[j].itemToLabel(dataList[i])),
							j == cols.length - 1 ? '' : spiltor);
					ss=ss.concat('\n');
				}

			return ss;
		}

		public function saveAsExcel(dataList:Object, fileName:String):void
		{
			IOUtil.saveFile(rowsToExcel(dataList), fileName.concat('.xls'));
		}

		public function saveAsExcelWithAlert(dataList:Object, fileName:String):void
		{
			IOUtil.saveFileWithAlert(rowsToExcel(dataList), fileName.concat('.xls'), this);
		}

		[Bindable("change")]
		[Bindable("valueCommit")]
		[Inspectable(environment="none")]

		/**
		 *  An array of references to the selected items in the data provider. The
		 *  items are in order same as dataProvider.
		 *  @default [ ]
		 */
		public function get selectedItemsInOriginOrder():Array
		{
			if (collection is IList)
			{
				var dp:IList=IList(collection);
				return selectedItems.sort(function(a:Object, b:Object):Number
				{
					return dp.getItemIndex(a) > dp.getItemIndex(b) ? 1 : -1;
				});
			}
			else
				return selectedItems
		}

		/**
		 * 不选择汇总项
		 * @return
		 */
		public function get selectedOriItem():Object
		{
			return (selectedItem &&
				selectedItem.uniqueIdForSumItem == uid) ? null : selectedItem;
		}

		/**
		 * 生成默认的详细对话框
		 * @param evt
		 */
		public function showItemDetail(item:Object, editable:Boolean=false):void
		{
			showItem=item;
			showItemProxy=new ObjectProxy(ObjectUtil.copy(showItem));

			if (editable)
			{
				if (!popEditing)
					initPopEditing();
				popEditing.show(root);
				popEditing.title=
					showItem ? '修改' + (popTitleFunciton ? ' ' + popTitleFunciton(showItem) : '') : '新增';
			}
			else
			{
				if (!popView)
					initPopView()
				popView.show(root);
			}
		}

		public function updateCMDMenu(enabled:Boolean):void
		{
			deleteEnabled=deleteAllEnabled=createEnabled=modifyEnabled=enabled;
		}

		public function get viewableColumns():Array
		{
			return (showOnlyVisible ? visibleColumns : columns).filter(function(item:DataGridColumn,
					index:int, array:Array):Boolean
					{
						return (item is DataGridColumnPlus && DataGridColumnPlus(item).viewable) ||
							!(item is DataGridColumnPlus);
					})
		}

		public function get visibleColumns():Array
		{
			return columns.filter(function(item:DataGridColumn, index:int,
					array:Array):Boolean
					{
						return item.visible && item != indexColumn;
					})
		}

		override protected function updateDisplayList(unscaledWidth:Number,
			unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight)
			if (indexColumn && indexColumn.width > 30)
				indexColumn.width=30
		}

		private function contextMenu_menuSelect(evt:ContextMenuEvent):void
		{
			this.selectedIndex=lastRollOverIndex;
		}

		private function copySelectedToExcel(evt:Event):void
		{
			copyToExcel(selectedItemsInOriginOrder);
		}

		private function copyToExcel(dataList:Object):void
		{
			System.setClipboard(rowsToString(dataList, '	'));
		}

		private function copyTotalToExcel(evt:Event):void
		{
			copyToExcel(dataProvider);
		}

		private function createItem(evt:Event):void
		{
			dispatchEvent(new Event('createItem'));
		}

		private function deleteAll(evt:Event):void
		{
			MessageUtil.confirmAction("确认全部删除？", function():void
			{
				dispatchEvent(new Event('deleteAll'));
			})
		}

		private function deleteItems(evt:Event):void
		{
			MessageUtil.confirmAction("确认删除？", function():void
			{
				dispatchEvent(new Event('deleteItems'));
			})
		}

		private function dgItemRollOut(event:ListEvent):void
		{
			for each (var menu:ContextMenuItem in contextMenu.customItems)
				menu.enabled=menuSupport.isAlwaysEnabled(menu);
		}

		private function dgItemRollOver(event:ListEvent):void
		{
			lastRollOverIndex=event.rowIndex;

			for each (var menu:ContextMenuItem in contextMenu.customItems)
				menu.enabled=true;
		}

		private function enableMenu(menuLabel:String, action:Function,
			separatorBefore:Boolean=false, alwaysEnabled:Boolean=false,
			withDoubleClick:Boolean=false):void
		{
			menuSupport.createMenuItem(menuLabel, action, separatorBefore, alwaysEnabled);

			if (withDoubleClick && !doubleClickEnabled)
			{
				doubleClickEnabled=true;
				addEventListener(ListEvent.ITEM_DOUBLE_CLICK, action);
				replacableDoubleClickHandler=action;
			}
		}

		private function init(event:FlexEvent):void
		{
			resetMenu();
			if (showIndex)
			{
				indexColumn=new DataGridColumnPlus;
				indexColumn.headerText='#'
				indexColumn.setStyle("backgroundColor", 0xeeeeee);
				indexColumn.setStyle("backgroundAlpha", 1);
				indexColumn.setStyle("textAlign", 'center');
				indexColumn.width=30
				indexColumn.viewable=false;
				indexColumn.editable=false;
				indexColumn.sortable=false
				indexColumn.resizable=false
				indexColumn.labelFunction=
					function(item:Object, column:DataGridColumn):String
					{
						return String(new ArrayCollectionPlus(dataProvider).getItemIndex(item) + 1);
					};
				var cols:Array=columns;
				cols.unshift(indexColumn);
				columns=cols;
			}
		}

		private function initPop(editable:Boolean=false):PopWindow
		{
			var form:Form=new Form();
			var pop:PopWindow=ContainerUtil.initPopUP('查看', form, -1, -1, 'center');
			for each (var col:DataGridColumn in(editable ? editableColumns : viewableColumns))
			{
				form.addChild(new DataColumnFormItem(this, col, editable));
			}

			if (editable)
			{
				var buttonItem:FormItem=new FormItem();
				var hbox:HBox=new HBox;
				var saveButton:Button=new Button();
				saveButton.label='保存';
				var submit:Function=function(e:Event):void
				{
					if (!ContainerUtil.validate(form))
					{
						popEditing.playShake();
						return;
					}
					popEditing.showProgress();
					dispatchEvent(new SaveItemEvent(showItemProxy));
				}
				saveButton.addEventListener('click', submit);
				if (popEnterSubmit)
					pop.addEventListener('enterKeyDown', submit);
				var resetButton:Button=new Button();
				resetButton.label='重置';
				resetButton.addEventListener('click', function(e:Event):void
				{
					dispatchEvent(new Event('resetEditItem'));
				});
				hbox.addChild(saveButton);
				hbox.addChild(resetButton);
				buttonItem.addChild(hbox);
				form.addChild(buttonItem);
			}
			return pop;
		}

		private function modifyItem(evt:Event):void
		{
			dispatchEvent(new Event('modifyItem'));
		}

		private function onHeaderRelease(event:DataGridEvent):void
		{
			if (!globalSort)
				return;
			event.preventDefault();
			var col:DataGridColumn=columns[event.columnIndex];

			if (col.sortable && col.dataField)
			{
				addOrder(col.dataField);
				dispatchEvent(new Event('changeOrder'));
			}
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

		private function saveToExcel(evt:Event):void
		{
			saveAsExcel(dataProvider, exportName ? exportName : UIDUtil.createUID());
		}
	}
}

