package ns.flex.util
{
	import mx.controls.Alert;
	import mx.events.*;
	import mx.rpc.events.*;

	/**
	 * 消息显示工具类
	 * @author wangchu
	 */
	public class MessageUtil
	{

		public static function print(... objs):void
		{
			var str:String='';

			for each (var obj:* in objs)
				str+=seesee(obj);
			Alert.show(str);
		}

		public static function printStackTrace():void
		{
			trace(new Error().getStackTrace());
		}

		public static function confirmAction(prompt:String, action:Function):void
		{

			Alert.show(prompt, null, Alert.YES | Alert.NO, null,
				function(evt:CloseEvent):void
				{
					if (evt.detail == Alert.YES)
					{
						action();
					}
				})
		}

		public static function seesee(obj:*):String
		{
			var str:String=
				String(obj) + "\ntype is " + typeof obj + ", has properties: \n";

			for (var prop:* in obj)
				str+="   " + prop + " : [" + typeof obj[prop] + "]" + obj[prop] + ";\n";
			return str;
		}

		public static function showError(e:FaultEvent, title:String="Warning"):void
		{
			Alert.show(e.fault.faultString.substr(e.fault.faultString.indexOf(':') + 2),
				title);
		}

		public static function showMessage(message:String, title:String='Message'):void
		{
			Alert.show(message, title);
		}

		public static function tracing(... objs):void
		{
			for each (var obj:* in objs)
				trace(seesee(obj));
		}
	}
}

