package ns.flex.controls
{
	import com.hillelcoren.components.AutoComplete;
	import ns.flex.util.StringUtil;

	public class AutoCompletePlus extends AutoComplete
	{
		public function AutoCompletePlus()
		{
			super();
			width=300;
			backspaceAction=BACKSPACE_REMOVE;
			showRemoveIcon=true;
			prompt='使用逗号(,)或回车分隔多个项目';
		}

		public function get allowNewValues():Boolean
		{
			return _allowNewValues;
		}

		//选择返回label时，去除空格和大小写重复
		[Bindable(event="change")]
		[Bindable(event="valueCommit")]
		public function get selectedLabels():Array
		{
			var labels:Array=[];
			var map:Object={};
			if (_selectedItems)
				for each (var item:Object in _selectedItems.source)
				{
					var key:String=StringUtil.trim(String(labelFunction(item)))
					if (map[key.toLowerCase()])
						map[key.toLowerCase()]++
					else
					{
						map[key.toLowerCase()]=1;
						labels.push(key);
					}
				}
			return labels;
		}

		//不需要自动选择，无法增加前缀相同的选择，如有Java后无法增加Javascript
		override protected function isPerfectMatch():Boolean
		{
			return false;
		}
	}
}

