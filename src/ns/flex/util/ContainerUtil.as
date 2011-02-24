package ns.flex.util
{
	import flash.display.DisplayObject;
	import mx.controls.ComboBox;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.ClassFactory;
	import mx.core.Container;
	import mx.managers.PopUpManager;
	import ns.flex.controls.PopWindow;
	
	/**
	 * 显示容器工具类
	 * @author wangchu
	 */
	public class ContainerUtil
	{
		/**
		 * 级联清空容器内输入对象的输入内容
		 * @param container
		 */
		static public function clearInput(container:Container):void
		{
			for each (var diso:DisplayObject in container.getChildren())
			{
				if (diso is Container)
					clearInput(Container(diso));
				else if (diso is TextInput)
					TextInput(diso).text='';
				else if (diso is TextArea)
					TextArea(diso).text='';
				else if (diso is ComboBox)
					ComboBox(diso).selectedIndex=0;
			}
		}
		
		/**
		 * 生产容器
		 * @param childClass 容器类
		 * @param children
		 * @return
		 */
		static public function generateContainer(childClass:ClassFactory,
			... children):Container
		{
			var container:Container=Container(childClass.newInstance());
			container.percentHeight=container.percentWidth=100;
			container.setStyle('horizontalAlign', 'center');
			
			for each (var child:* in children)
				container.addChild(child);
			return container;
		}
		
		/**
		 * 显示对话框
		 * @param title 标题
		 * @param parent 父显示对象
		 * @param child 显示内容
		 * @param width 宽
		 * @param height 高
		 */
		static public function showPopUP(title:String, parent:DisplayObject,
			child:DisplayObject, width:int=-1, height:int=-1, goCenter:Boolean=
			true):PopWindow
		{
			var pop:PopWindow=new PopWindow();
			pop.title=title;
			pop.goCenter=goCenter;
			
			if (width > -1)
				pop.width=width;
			
			if (height > -1)
				pop.height=height;
			PopUpManager.addPopUp(pop, parent, true);
			pop.addChild(child);
			return pop;
		}
	}
}