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
		 * 清除远程对象的查询结果
		 * @param ro
		 * @param methods 方法数组
		 */
		public static function clearResults(ro:RemoteObject, ... methods):void
		{
			for each (var method:String in methods)
			{
				ro.getOperation(method).clearResult();
				ro.getOperation(method).dispatchEvent(new ResultEvent(ResultEvent.RESULT));
			}
		}

		public static function count(ro:RemoteObject, params:Object, domain:String):void
		{
			ro.count(params, domain);
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
		public static function countAndList(ro:RemoteObject, params:Object,
			maxResults:int, firstResult:int, orders:Array=null, domain:String=null):void
		{

			count(ro, params, domain);
			list(ro, params, maxResults, firstResult, orders, domain);
		}

		/**
		 * 右模糊
		 * @param param 查询条件
		 * @return  右模糊后的查询条件
		 */
		public static function fuzzyRight(param:String):String
		{
			param=param == null ? '' : param;
			return param.concat('%');
		}

		public static function list(ro:RemoteObject, params:Object, maxResults:int,
			firstResult:int, orders:Array, domain:String):void
		{
			//线程安全创建一个新对象，如果直接对param赋值有时会影响count的参数
			var listParam:Object=ObjectUtils.clone(params)
			if (maxResults > -1)
			{
				listParam.maxResults=[maxResults]
				listParam.firstResult=[firstResult]
			}
			var notNestOrders:Array=[];
			listParam.order=notNestOrders

			//嵌套字段的排序criteria
			for each (var order:Array in orders)
			{
				if (String(order[0]).indexOf('.') == -1)
					notNestOrders.push(order);
				else
				{
					var nestFields:Array=order[0].split('.');
					order[0]=nestFields[nestFields.length - 1];
					var parentParam:Object=listParam;

					for (var i:int=0; i < nestFields.length - 1; i++)
					{
						if (!parentParam[nestFields[i]])
							parentParam[nestFields[i]]={}
						parentParam=parentParam[nestFields[i]];
					}

					if (parentParam.order)
						(parentParam.order as Array).push(order);
					else
						parentParam.order=[order];
				}
			}
			ro.list(listParam, domain);
		}
	}
}

