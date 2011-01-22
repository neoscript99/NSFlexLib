package ns.flex.util
{
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;
	
	/**
	 * 数据库查询工具类
	 * @author wangchu
	 */
	public class SQLUtil
	{
		/**
		 * 右模糊
		 * @param param 查询条件
		 * @return  右模糊后的查询条件
		 */
		static public function fuzzyRight(param:String):String
		{
			param=param == null ? '' : param;
			return param.concat('%');
		}
		
		/**
		 * 查询并统计总结果数
		 * @param ro
		 * @param params
		 * @param maxResults
		 * @param firstResult
		 * @param orders
		 * @param domain
		 */
		static public function countAndList(ro:RemoteObject, params:Object,
			maxResults:int, firstResult:int, orders:Array=null, domain:String=null):void
		{
			ro.count(params, domain);
			//线程安全创建一个新对象，否则下面的赋值有时会影响count的参数
			var listParam:Object=
				{maxResults: [maxResults], firstResult: [firstResult], order: orders};
			
			for (var prop:* in params)
			{
				trace(prop);
				listParam[prop]=params[prop];
			}
			ro.list(listParam, domain);
		}
		
		/**
		 * 清除远程对象的查询结果
		 * @param ro
		 * @param methods 方法数组
		 */
		static public function clearResults(ro:RemoteObject, ... methods):void
		{
			for each (var method:String in methods)
			{
				ro.getOperation(method).clearResult();
				ro.getOperation(method).dispatchEvent(new ResultEvent(ResultEvent.RESULT));
			}
		}
	}
}