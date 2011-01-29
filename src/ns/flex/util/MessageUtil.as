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
		
		/**
		 * 进度条弹框
		 * @param parent 父对象
		 * @param closeTrigger 进度条消失事件触发宿主
		 * @param triggerEventArray 消失触发事件列表，默认使用远程调用事件'result', 'fault'
		 * @param title 弹框标题
		 */
		static public function showProgressBox(parent:DisplayObject,
			closeTrigger:IEventDispatcher, triggerEventArray:Array=null, title:String=
			'处理中，请稍等......'):void
		{
			var pBar:ProgressBar=new ProgressBar();
			pBar.indeterminate=true;
			pBar.height=10;
			pBar.width=200;
			pBar.setStyle('trackHeight', 10);
			pBar.label='';
			var pop:IFlexDisplayObject=
				ContainerUtil.showPopUP(title, parent, pBar, -1, -1, false);
			closeTrigger=closeTrigger ? closeTrigger : pop;
			triggerEventArray=triggerEventArray ? triggerEventArray : ['result', 'fault'];
			
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