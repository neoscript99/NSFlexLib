package ns.flex.util
{
	import flash.display.DisplayObjectContainer;
	import flash.display.IBitmapDrawable;
	import flash.events.EventDispatcher;
	import flash.net.FileReference;

	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.graphics.ImageSnapshot;

	public class UIUtil
	{

		static public function setStyles(uic:UIComponent, styles:Object):void
		{
			for (var style:* in styles)
				uic.setStyle(style, styles[style])
		}

		static public function setEvents(ed:EventDispatcher, events:Object):void
		{
			for (var event:* in events)
				ed.addEventListener(event, events[event])
		}

		static public function snapshot(target:IBitmapDrawable, fileName:String=null):void
		{
			new FileReference().save(ImageSnapshot.captureImage(target).data,
				fileName ? fileName : ('Image' + new Date().getTime()) + '.png');
		}

		/*
		 * 隐藏amchart免费版链接
		 */
		static public function removeAmLink(container:DisplayObjectContainer):void
		{
			trace('removeAmLink')
			var link:UITextField=
				ContainerUtil.findContainerChild(container, UITextField, 'text',
				"chart by amCharts.com") as UITextField
			if (link)
			{
				link.htmlText=''
				link.text=''
				link.visible=false
				link.parent.visible=false
			}
		}
	}
}

