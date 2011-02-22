package ns.flex.controls
{
	import mx.binding.utils.BindingUtils;
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
			
			if (col is DataGridColumnPlus && 'CheckBox' == col['asControl'])
				uic=asCheckBox(dgp, col, editable);
			else
				uic=asText(dgp, col, editable);
			addChild(uic);
		}
		
		private function asCheckBox(dgp:DataGridPlus, col:DataGridColumn,
			editable:Boolean):UIComponent
		{
			var cb:CheckBox=new CheckBox();
			cb.enabled=(editable && col.dataField);
			
			if (editable && col.dataField)
			{
				BindingUtils.bindSetter(function(value:Object):void
				{
					cb.selected=dgp.editingItem[col.dataField];
				}, dgp, 'editingItem');
				BindingUtils.bindSetter(function(value:String):void
				{
					dgp.editingItem[col.dataField]=value;
				}, cb, 'selected');
			}
			else if (dgp.editingItem)
				cb.selected=dgp.editingItem[col.dataField];
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
					
					if (editable)
					{
						tip.maxChars=colp.maxChars;
						tip.imeDisabled=colp.imeDisabled;
						tip.noSpace=colp.noSpace;
						tip.autoTrim=colp.autoTrim;
						tip.required=colp.required;
						tip.expression=colp.expression;
						tip.flags=colp.flags;
						
						if ('Password' == colp.asControl)
							tip.displayAsPassword=true;
					}
				}
				textInput=tip;
			}
			textInput.setStyle('textAlign', col.getStyle('textAlign'));
			textInput['editable']=(editable && col.dataField);
			
			if (editable && col.dataField)
			{
				BindingUtils.bindSetter(function(value:Object):void
				{
					textInput['text']=col.itemToLabel(dgp.editingItem);
				}, dgp, 'editingItem');
				BindingUtils.bindSetter(function(value:String):void
				{
					dgp.editingItem[col.dataField]=value
					label=col.headerText.concat('(', textInput['remainSize'], ')');
				}, textInput, 'text');
			}
			else if (dgp.editingItem)
				textInput['text']=col.itemToLabel(dgp.editingItem);
			return textInput;
		}
		
		public function get validated():Boolean
		{
			if (this.getChildAt(0) is TextInputPlus)
				return (this.getChildAt(0) as TextInputPlus).validated;
			else
				return true;
		}
	}
}