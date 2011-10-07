package ns.flex.module
{
	import mx.modules.Module;
	
	public class AbstractModule extends Module
	{
		
		public function beforeDisplay():void
		{
		}
		
		[Bindable('click')]
		[Bindable('keyUp')]
		protected function get validated():Boolean
		{
			return validate();
		}
		
		protected function validate():Boolean
		{
			return false;
		}
	}
}

