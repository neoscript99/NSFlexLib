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
	}
}

