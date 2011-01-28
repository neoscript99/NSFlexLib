package ns.flex.util
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import mx.controls.ProgressBar;
	import mx.core.IFlexDisplayObject;
	import mx.managers.PopUpManager;
	
	/**
	 * 消息显示工具类
	 * @author wangchu
	 */
	public class MessageUtil
	{
		import mx.controls.Alert;
		import mx.events.*;
		import mx.rpc.events.*;
		
		static public function showError(e:FaultEvent, title:String="Warning"):void
		{
			Alert.show(e.fault.faultString.substr(e.fault.faultString.indexOf(':') + 2),
				title);
		}
		
		static public function showMessage(message:String, title:String='Message'):void
		{
			Alert.show(message, title);
		}
		
		static public function showProgressBox(parent:DisplayObject,
			closeTrigger:IEventDispatcher, triggerEventArray:Array):void
		{
			var pBar:ProgressBar=new ProgressBar();
			pBar.label='';
			pBar.height=10;
			pBar.setStyle('trackHeight', 10);
			pBar.width=200;
			var pop:IFlexDisplayObject=
				ContainerUtil.showPopUP('处理中，请稍等......', parent, pBar, -1, -1, false);
			
			for each (var triggerEvent:String in triggerEventArray)
				closeTrigger.addEventListener(triggerEvent, function(e:Event):void
					{
						PopUpManager.removePopUp(pop);
					});
		}
		
		static public function print(... objs):void
		{
			var str:String='';
			
			for each (var obj:* in objs)
				str+=seesee(obj);
			Alert.show(str);
		}
		
		static public function printStackTrace():void
		{
			trace(new Error().getStackTrace());
		}
		
		static public function tracing(... objs):void
		{
			for each (var obj:* in objs)
				trace(seesee(obj));
		}
		
		static public function seesee(obj:*):String
		{
			var str:String=
				String(obj) + "\ntype is " + typeof obj + ", has properties: \n";
			
			for (var prop:* in obj)
				str+="   " + prop + " : [" + typeof obj[prop] + "]" + obj[prop] + ";\n";
			return str;
		}
	}
}