package ns.flex.controls
{
	import mx.binding.utils.BindingUtils;
	import mx.containers.FormItem;
	import mx.controls.CheckBox;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	import ns.flex.util.ObjectUtils;

	public class DataColumnFormItem extends FormItem
	{

		public function DataColumnFormItem(dgp:DataGridPlus, col:DataGridColumn,
			editable:Boolean)
		{
			super();
			var uic:UIComponent;
			label=col.headerText.replace(/[↑↓]\d*/, '');
			editable=(editable && col.dataField);

			if (col is DataGridColumnPlus)
			{
				var colp:DataGridColumnPlus=DataGridColumnPlus(col)

				if ('CheckBox' == colp.asControl && col.dataField)
					uic=asCheckBox(dgp, col, editable);
				else if ('ComboBox' == colp.asControl && editable)
					uic=asComboBox(dgp, colp);
				else if (('DateField' == colp.asControl || 'DateString' == colp.asControl) &&
					editable)
					uic=asDateField(dgp, colp);
				else
					uic=asText(dgp, col, editable, 'TextArea' == colp.asControl);
			}
			else
				uic=asText(dgp, col, editable);
			addChild(uic);
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
					dgp.showItemProxy[col.dataField]=value;
				}, cb, 'selected');
			return cb;
		}

		private function asComboBox(dgp:DataGridPlus, colp:DataGridColumnPlus):UIComponent
		{
			var cbp:ComboBoxPlus=new ComboBoxPlus();
			ObjectUtils.copyProperties(cbp, colp.comboBoxInfo);
			BindingUtils.bindSetter(function(value:Object):void
			{
				if (value[colp.dataField])
					cbp.defaultLabel=colp.itemToLabel(value);
				else
					cbp.selectedIndex=0;
			}, dgp, 'showItemProxy');
			BindingUtils.bindSetter(function(value:Object):void
			{
				if (value)
					dgp.showItemProxy[colp.dataField]=value[colp.comboBoxInfo.dataField];
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
					dgp.showItemProxy[colp.dataField]=value;
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
					dgp.showItemProxy[colp.dataField]=value;
				}, dfp, 'selectedDate');
			}
			return dfp;
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
					dgp.showItemProxy[col.dataField]=value
					label=
						textInput['maxChars'] ? col.headerText.concat('(',
						textInput['remainSize'], ')') : col.headerText;
				}, textInput, 'text');
			return textInput;
		}
	}
}

