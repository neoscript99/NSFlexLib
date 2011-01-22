package ns.flex.util
{
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.formatters.DateFormatter;
	
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