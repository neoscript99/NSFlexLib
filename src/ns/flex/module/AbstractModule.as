package ns.flex.module
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import mx.modules.Module;
	import ns.flex.controls.TitleWindowPlus;

	public class AbstractModule extends Module
	{
		protected var map:Object={};

		public function beforeDisplay():void
		{
		}

		protected function addScrollFollowChild(child:DisplayObject):void
		{
			if (titleWindow)
				titleWindow.addScrollFollowChild(child);
		}

		/**
		 *
		 * @return first parent which is TitleWindow
		 */
		protected function get titleWindow():TitleWindowPlus
		{
			if (!map.titleWindow)
			{
				var p:DisplayObjectContainer=parent;
				while (p)
				{
					if (p is TitleWindowPlus)
					{
						map.titleWindow=p;
						break
					}
					p=p.parent;
				}
			}
			return map.titleWindow;
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

