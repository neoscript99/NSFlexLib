package ns.flex.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import mx.controls.ComboBox;
	import mx.controls.DateField;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.utils.ObjectUtil;
	import ns.flex.controls.PopWindow;

	/**
	 * 显示容器工具类
	 * @author wangchu
	 */
	public class ContainerUtil
	{

		public static function builderContainer(parent:Container, ... children):Container
		{
			for each (var child:* in children)
				parent.addChild(child);
			return parent;
		}

		/**
		 * 级联清空容器内输入对象的输入内容
		 * @param container
		 */
		public static function clearInput(container:Container):void
		{
			for each (var diso:DisplayObject in container.getChildren())
			{
				if (diso is Container)
					clearInput(Container(diso));
				else if (diso is TextInput && TextInput(diso).editable)
					TextInput(diso).text='';
				else if (diso is TextArea && TextArea(diso).editable)
					TextArea(diso).text='';
				else if (diso is ComboBox)
					ComboBox(diso).selectedIndex=0;
				else if (diso is DateField && DateField(diso).editable)
				{
					DateField(diso).selectedDate=null;
					DateField(diso).text='';
				}
			}
		}

		public static function findContainerChild(container:DisplayObjectContainer,
			type:Class, property:String=null, value:Object=null):DisplayObject
		{
			var result:DisplayObject;
			for (var i:int=0; i < container.numChildren; i++)
			{
				var diso:DisplayObject=container.getChildAt(i);
				if (diso is type)
				{
					if (property == null ||
						ObjectUtil.compare(diso[property], value) == 0)
						return diso;
				}
				if (diso is DisplayObjectContainer)
				{
					result=
						findContainerChild(DisplayObjectContainer(diso), type, property,
						value);

					if (result)
						return result;
				}
			}
			return null;
		}

		public static function findParent(diso:DisplayObject, type:Class):DisplayObject
		{
			if (diso.parent && diso.parent is type)
				return diso.parent
			else if (diso.parent)
				return findParent(diso.parent, type)
			else
				return null;
		}

		public static function initPopUP(title:String, child:DisplayObject, width:int=-1,
			height:int=-1, horizontalAlign:String=null):PopWindow
		{
			var pop:PopWindow=new PopWindow();
			pop.title=title;

			if (width > -1)
				pop.width=width;

			if (height > -1)
				pop.height=height;

			if (horizontalAlign)
				pop.setStyle('horizontalAlign', horizontalAlign);
			pop.addChild(child);
			return pop;
		}

		public static function removeChildrenByName(container:DisplayObjectContainer,
			... names):void
		{
			for each (var name:String in names)
			{
				var child:DisplayObject=
					ContainerUtil.findContainerChild(container, DisplayObject, 'name',
					name);
				if (child)
					child.parent.removeChild(child);
			}
		}

		/**
		 * 显示对话框
		 * @param title 标题
		 * @param parent 父显示对象
		 * @param child 显示内容
		 * @param width 宽
		 * @param height 高
		 */
		public static function showPopUP(title:String, parent:DisplayObject,
			child:DisplayObject, width:int=-1, height:int=-1):PopWindow
		{
			var pop:PopWindow=initPopUP(title, child, width, height);
			pop.show(parent);
			return pop;
		}

		/**
		 * 级联验证容器内输入对象的输入内容
		 * @param container
		 */
		public static function validate(container:Container,
			isSetFocus:Boolean=true):Boolean
		{
			for each (var uic:UIComponent in container.getChildren())
			{
				if (uic.hasOwnProperty('validated'))
				{
					if (uic.enabled && !uic['validated'])
					{
						if (isSetFocus)
							uic.setFocus();
						return false;
					}
				}
				else if (uic is ComboBox)
				{
					if (!ComboBox(uic).selectedItem)
					{
						if (isSetFocus)
							uic.setFocus();
						return false;
					}
				}
				else if (uic is Container)
				{
					if (!validate(Container(uic), isSetFocus))
						return false;
				}
			}
			return true;
		}
	}
}

