package ns.flex.controls
{
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.containers.FormItem;
	import mx.controls.CheckBox;
	import mx.controls.LinkButton;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.Operation;
	import ns.flex.util.ObjectUtils;
	import ns.flex.util.StringUtil;

	public class DataColumnFormItem extends FormItem
	{

		public function DataColumnFormItem(dgp:DataGridPlus, col:DataGridColumn,
			editable:Boolean)
		{
			super();
			var uic:UIComponent;
			label=
				col.headerText ? StringUtil.toLine(col.headerText.replace(/[↑↓]\d*/,
				'')) : '';
			editable=(editable && col.dataField);

			if (col is DataGridColumnPlus)
			{
				var colp:DataGridColumnPlus=DataGridColumnPlus(col)

				if ('CheckBox' == colp.asControl && col.dataField)
					uic=asCheckBox(dgp, col, editable);
				else if ('ComboBox' == colp.asControl && editable)
					uic=asComboBox(dgp, colp);
				else if ('AutoComplete' == colp.asControl)
					uic=asAutoComplete(dgp, colp, editable);
				else if ('LinkButton' == colp.asControl && !editable)
					uic=asLinkButton(dgp, colp);
				else if (('DateField' == colp.asControl || 'DateString' == colp.asControl) &&
					editable)
					uic=asDateField(dgp, colp);
				else
					uic=asText(dgp, col, editable, 'TextArea' == colp.asControl);
			}
			else
				uic=asText(dgp, col, editable);

			uic.name=col.headerText;
			addChild(uic);
		}

		private function asAutoComplete(dgp:DataGridPlus, colp:DataGridColumnPlus,
			editable:Boolean):UIComponent
		{
			var ac:AutoCompletePlus=new AutoCompletePlus;
			ObjectUtils.copyProperties(ac, colp.controlProps);
			ac.enabled=editable;
			var getSelected:Operation=colp.controlProps.getSelected;
			getSelected.addEventListener(ResultEvent.RESULT, function(e:ResultEvent):void
			{
				ac.selectedItems=e.result as ArrayCollection;
			})
			BindingUtils.bindSetter(function(value:Object):void
			{
				getSelected.send(value)
			}, dgp, 'showItemProxy');

			if (editable)
				BindingUtils.bindSetter(function(value:Object):void
				{
					ObjectUtils.setValue(dgp.showItemProxy, colp.dataField, value);
				}, ac, ac.allowNewValues ? 'selectedLabels' : 'selectedItems');
			//allowNewValues取label就够了，因为新输入的只能是label
			return ac;
		}

		private function asCheckBox(dgp:DataGridPlus, col:DataGridColumn,
			editable:Boolean):UIComponent
		{
			var cb:CheckBox=new CheckBox();
			cb.enabled=editable;
			BindingUtils.bindSetter(function(value:Object):void
			{
				cb.selected=value[col.dataField];
			}, dgp, 'showItemProxy');

			if (editable)
				BindingUtils.bindSetter(function(value:String):void
				{
					ObjectUtils.setValue(dgp.showItemProxy, col.dataField, value);
				}, cb, 'selected');
			return cb;
		}

		private function asComboBox(dgp:DataGridPlus, colp:DataGridColumnPlus):UIComponent
		{
			var cbp:ComboBoxPlus=new ComboBoxPlus();
			ObjectUtils.copyProperties(cbp, colp.controlProps);
			BindingUtils.bindSetter(function(value:Object):void
			{
				var defaultStr:String=StringUtil.trim(colp.itemToLabel(value))
				if (defaultStr)
					cbp.defaultLabel=defaultStr;
				else
					cbp.selectedIndex=0;
			}, dgp, 'showItemProxy');
			BindingUtils.bindSetter(function(value:Object):void
			{
				if (value)
				{
					//write col.dataField if dataField is set
					if (colp.controlProps.dataField)
						dgp.showItemProxy[colp.dataField]=
							value[colp.controlProps.dataField];
					else //set nest first field
						dgp.showItemProxy[colp.dataField.split('.')[0]]=value;
				}
			}, cbp, 'selectedItem');
			return cbp;
		}

		private function asDateField(dgp:DataGridPlus,
			colp:DataGridColumnPlus):UIComponent
		{
			var dfp:DateFieldPlus=new DateFieldPlus();
			dfp.constraints=colp.constraints;

			if ('DateString' == colp.asControl)
			{
				BindingUtils.bindSetter(function(value:Object):void
				{
					if (value[colp.dataField])
						dfp.text=value[colp.dataField];
					else //不能设text为null，否则flex出错
						dfp.resetDefault();
				}, dgp, 'showItemProxy');
				BindingUtils.bindSetter(function(value:Object):void
				{
					ObjectUtils.setValue(dgp.showItemProxy, colp.dataField, value);
				}, dfp, 'text');
			}
			else
			{
				BindingUtils.bindSetter(function(value:Object):void
				{
					if (value[colp.dataField])
						dfp.selectedDate=value[colp.dataField];
					else
						dfp.resetDefault();
				}, dgp, 'showItemProxy');
				BindingUtils.bindSetter(function(value:Object):void
				{
					ObjectUtils.setValue(dgp.showItemProxy, colp.dataField, value);
				}, dfp, 'selectedDate');
			}
			return dfp;
		}

		private function asLinkButton(dgp:DataGridPlus, col:DataGridColumn):UIComponent
		{
			var lb:LinkButton=new LinkButton();
			lb.maxWidth=480;
			BindingUtils.bindSetter(function(value:Object):void
			{
				lb.label=value[col.dataField];
			}, dgp, 'showItemProxy');
			lb.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				navigateToURL(new URLRequest(lb.label), '_blank')
			});
			return lb;
		}

		private function asText(dgp:DataGridPlus, col:DataGridColumn, editable:Boolean,
			asTextArea:Boolean=false):UIComponent
		{
			var textInput:UIComponent=
				(col.wordWrap || asTextArea) ? new TextAreaPlus() : new TextInputPlus();

			if (col is DataGridColumnPlus)
				textInput['constraints']=DataGridColumnPlus(col).constraints;

			textInput.setStyle('textAlign', col.getStyle('textAlign'));
			textInput['editable']=editable;
			BindingUtils.bindSetter(function(value:Object):void
			{
				textInput['text']=col.itemToLabel(value);
			}, dgp, 'showItemProxy');

			if (editable)
				BindingUtils.bindSetter(function(value:String):void
				{
					ObjectUtils.setValue(dgp.showItemProxy, col.dataField,
						col['asNumber'] ? Number(value) : value);
					label=
						textInput['maxChars'] ? col.headerText.concat('(',
						textInput['remainSize'], ')') : col.headerText;
				}, textInput, 'text');
			return textInput;
		}
	}
}

