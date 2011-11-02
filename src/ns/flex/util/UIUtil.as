package ns.flex.util
{
	import mx.core.UIComponent;

	public class UIUtil
	{

		static public function setStyles(uic:UIComponent, styles:Object):void
		{
			for (var style:* in styles)
				uic.setStyle(style, styles[style])
		}
	}
}

