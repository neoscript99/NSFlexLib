package ns.flex.controls
{
	import mx.collections.IList;
	import mx.controls.ComboBox;

	public class ComboBoxPlus extends ComboBox
	{
		private var _defaultLabel:String;
		public var valueField:String;

		[Bindable("valueCommit")]
		public function get validated():Boolean
		{
			if (selectedItem)
				return valueField ? selectedItem[valueField] : true;
			else
				return false;
		}

		private function getIndexLabel(item:Object):String
		{
			return (dataProvider is IList) ? String(IList(dataProvider).getItemIndex(item) + 1).concat('、',
				item[labelField]) : item[labelField];
		}

		public function ComboBoxPlus()
		{
			super();
			tabEnabled=false;
			rowCount=15;
		}

		public function set withIndex(v:Boolean):void
		{
			if (v)
				labelFunction=getIndexLabel;
		}

		override protected function commitProperties():void
		{
			super.commitProperties();
			selectDefaultLabel();
		}

		private function selectDefaultLabel():void
		{
			var tempIndex:int=-1;

			for (var i:int=dataProvider.length - 1; i >= 0; i--)
			{
				var label:String=itemToLabel(dataProvider[i]);

				if (label == _defaultLabel)
				{
					tempIndex=i;
					break;
				}
				//如果没有完全相等的，查找包含的
				else if (label.indexOf(_defaultLabel) > -1)
				{
					tempIndex=i;
				}
			}

			if (tempIndex > -1)
				selectedIndex=tempIndex;
		}

		public function get defaultLabel():String
		{
			return _defaultLabel;
		}

		public function set defaultLabel(value:String):void
		{
			this._defaultLabel=value;
			invalidateProperties();
		}

		/**
		 * 当ComboBox在popwindow中多次弹出时，无法记忆上次的选择结果
		 * 但如果ComboBox在module中，再通过popwindow弹出时，没有这个问题
		 */
		public function reserveSelect():void
		{
			_defaultLabel=selectedLabel;
		}
	}
}

