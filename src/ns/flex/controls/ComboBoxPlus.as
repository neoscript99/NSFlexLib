package ns.flex.controls
{
	import mx.controls.ComboBox;

	public class ComboBoxPlus extends ComboBox
	{
		private var _defaultLabel:String;

		public function ComboBoxPlus()
		{
			super();
			tabEnabled=false;
			rowCount=15;
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
	}
}
