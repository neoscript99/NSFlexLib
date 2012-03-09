package ns.flex.module
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import mx.modules.Module;
	import ns.flex.controls.TitleWindowPlus;

	public class AbstractModule extends Module
	{

		public function beforeDisplay():void
		{
		}

		protected function addScrollFollowChild(child:DisplayObject):void
		{
			var p:DisplayObjectContainer=parent;
			while (p)
			{
				if (p is TitleWindowPlus)
				{
					(p as TitleWindowPlus).addScrollFollowChild(child);
					break;
				}
				p=p.parent;
			}
		}

		protected function validate():Boolean
		{
			return false;
		}

		[Bindable('click')]
		[Bindable('keyUp')]
		protected function get validated():Boolean
		{
			return validate();
		}
	}
}

