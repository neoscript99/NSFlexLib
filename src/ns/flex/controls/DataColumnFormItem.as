package ns.flex.controls
{
	import mx.binding.utils.BindingUtils;
	import mx.containers.FormItem;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	
	public class DataColumnFormItem extends FormItem
	{
		private const inputThresholdSize:int=32;
		private const areaThresholdSize:int=64;
		
		public function DataColumnFormItem(dgp:DataGridPlus, col:DataGridColumn,
			editable:Boolean)
		{
			super();
			var colp:DataGridColumnPlus;
			var textInput:UIComponent;
			label=col.headerText;
			
			if (col.wordWrap)
			{
				var tap:TextAreaPlus=new TextAreaPlus();
				
				if (col is DataGridColumnPlus)
				{
					colp=DataGridColumnPlus(col);
					tap.height=60;
					
					if (colp.maxChars > areaThresholdSize)
					{
						tap.width=colp.maxChars / areaThresholdSize * 160;
						tap.height=colp.maxChars / areaThresholdSize * 60;
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
					
					if (colp.maxChars > inputThresholdSize)
						tip.width=colp.maxChars / inputThresholdSize * 160;
					
					if (editable)
					{
						tip.maxChars=colp.maxChars;
						tip.imeDisabled=colp.imeDisabled;
						tip.noSpace=colp.noSpace;
						tip.autoTrim=colp.autoTrim;
						tip.required=colp.required;
						tip.expression=colp.expression;
						tip.flags=colp.flags;
					}
				}
				textInput=tip;
			}
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
			addChild(textInput);
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