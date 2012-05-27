package ns.flex.controls
{
	import com.hillelcoren.components.AutoComplete;
	
	public class AutoCompletePlus extends AutoComplete
	{
		public function AutoCompletePlus()
		{
			super();
			width=300;
			backspaceAction=BACKSPACE_REMOVE;
			showRemoveIcon=true;
		}
		
		//不需要自动选择，无法增加前缀相同的选择
		override protected function isPerfectMatch():Boolean
		{
			return false;
		}
	}
}

