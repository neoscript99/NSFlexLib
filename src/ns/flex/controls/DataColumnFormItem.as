package ns.flex.controls
{
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	import mx.containers.FormItem;
	import mx.controls.CheckBox;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;

	public class DataColumnFormItem extends FormItem
	{
		private const INPUT_THRESHOLD_SIZE:int=32;
		private const AREA_THRESHOLD_SIZE:int=64;

		public function DataColumnFormItem(dgp:DataGridPlus, col:DataGridColumn,
			editable:Boolean)
		{
			super();
			var uic:UIComponent;
			label=col.headerText;

			if (col is DataGridColumnPlus && col.dataField)
			{
				var colp:DataGridColumnPlus=DataGridColumnPlus(col)

				if ('CheckBox' == colp.asControl)
					uic=asCheckBox(dgp, col, editable);
				else if ('ComboBox' == colp.asControl && editable &&
					colp.comboBoxDataField && colp.comboBoxLabelField)
					uic=asComboBox(dgp, colp);
				else if (('DateField' == colp.asControl || 'DateString' == colp.asControl) &&
					editable)
					uic=asDateField(dgp, colp);
				else
					uic=asText(dgp, col, editable);
			}
			else
				uic=asText(dgp, col, editable);
			addChild(uic);
		}

		private function asDateField(dgp:DataGridPlus,
			colp:DataGridColumnPlus):UIComponent
		{
			var dfp:DateFieldPlus=new DateFieldPlus();

			if (colp.constraints)
				if (colp.constraints.required)
					dfp.required=true;

			if ('DateString' == colp.asControl)
			{
				BindingUtils.bindSetter(function(value:Object):void
				{
					if (value[colp.dataField])
						dfp.text=value[colp.dataField];
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
				}, dgp, 'showItemProxy');
				BindingUtils.bindSetter(function(value:Object):void
				{
					dgp.showItemProxy[colp.dataField]=value;
				}, dfp, 'selectedDate');
			}
			return dfp;
		}

		private function asComboBox(dgp:DataGridPlus, colp:DataGridColumnPlus):UIComponent
		{
			var cbp:ComboBoxPlus=new ComboBoxPlus();
			cbp.labelField=colp.comboBoxLabelField;
			cbp.dataProvider=colp.comboBoxDataProvider;
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
					dgp.showItemProxy[colp.dataField]=value[colp.comboBoxDataField];
			}, cbp, 'selectedItem');
			return cbp;
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

		private function asText(dgp:DataGridPlus, col:DataGridColumn,
			editable:Boolean):UIComponent
		{
			var colp:DataGridColumnPlus;
			var textInput:UIComponent;

			if (col.wordWrap)
			{
				var tap:TextAreaPlus=new TextAreaPlus();

				if (col is DataGridColumnPlus)
				{
					colp=DataGridColumnPlus(col);
					tap.height=60;

					if (colp.maxChars > AREA_THRESHOLD_SIZE)
					{
						tap.width=colp.maxChars / AREA_THRESHOLD_SIZE * 160;
						tap.height=colp.maxChars / AREA_THRESHOLD_SIZE * 60;
						tap.width=tap.width > 320 ? 320 : tap.width;
						tap.height=tap.height > 192 ? 192 : tap.height;
					}

					if (editable)
						tap.maxChars=colp.maxChars;
				}
				textInput=tap;
			}
			else
			{
				var tip:TextInputPlus=new TextInputPlus();

				if (col is DataGridColumnPlus)
				{
					colp=DataGridColumnPlus(col);

					if (colp.maxChars > INPUT_THRESHOLD_SIZE)
						tip.width=colp.maxChars / INPUT_THRESHOLD_SIZE * 160;

					if ('Password' == colp.asControl)
						tip.displayAsPassword=true;

					if (editable)
					{
						if (colp.constraints && colp.constraints.maxChars &&
							colp.constraints.maxChars != colp.maxChars)
							trace('Warning: DataGridColumnPlus[maxChars] is conflicted with constraints[maxChars], constraints is priority.',
								colp.dataField, colp.headerText, colp.maxChars,
								colp.constraints.maxChars)
						tip.maxChars=colp.maxChars;
						tip.constraints=colp.constraints;
					}
				}
				textInput=tip;
			}
			textInput.setStyle('textAlign', col.getStyle('textAlign'));
			textInput['editable']=(editable && col.dataField);
			BindingUtils.bindSetter(function(value:Object):void
			{
				textInput['text']=col.itemToLabel(value);
			}, dgp, 'showItemProxy');

			if (editable && col.dataField)
				BindingUtils.bindSetter(function(value:String):void
				{
					dgp.showItemProxy[col.dataField]=value
					label=col.headerText.concat('(', textInput['remainSize'], ')');
				}, textInput, 'text');
			return textInput;
		}
	}
}