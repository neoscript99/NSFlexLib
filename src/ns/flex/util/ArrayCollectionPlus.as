package ns.flex.util
{
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	/**
	 * 集合类
	 * @author wangchu
	 */
	public class ArrayCollectionPlus extends ArrayCollection
	{
		public static const EMPTY:ArrayCollectionPlus=new ArrayCollectionPlus();
		
		public function ArrayCollectionPlus(source:Object=null)
		{
			var arr:Array;
			
			if (source is IList && source != null)
				arr=source.toArray();
			else
				arr=source as Array;
			super(arr);
		}
		
		/**
		 * 将集合转化为二维数组，如：[{a:1,b:2}]-->[[1,2]]
		 * @param fields 包含字段，如为空，包含所有字段
		 * @return
		 */
		public function toBiArray(... fields):Array
		{
			var array:Array=[];
			toArray().forEach(function(item:*, index:int, ar:Array):void
				{
					var innerArray:Array=[];
					
					if (fields.length > 0)
						for each (var field:String in fields)
							innerArray.push(item[field]);
					else
						for each (var prop:* in item)
							innerArray.push(prop);
					array.push(innerArray);
				});
			return array;
		}
		
		/**
		 * 增加到最前面
		 * @param item 增加的项
		 * @return 集合本身
		 */
		public function addFirst(item:Object):ArrayCollectionPlus
		{
			addItemAt(item, 0);
			return this;
		}
		
		/**
		 * 查询项目
		 * @param f 函数f(item)，返回true代表符合查询条件
		 * @return 查找到的项或null
		 */
		public function find(f:Function):Object
		{
			for (var i:int=0; i < this.length; i++)
			{
				var item:Object=this.getItemAt(i);
				
				if (f(item))
					return item;
			}
			return null;
		}
		
		[Bindable("collectionChange")]
		/**
		 * 根据字段查找集合项
		 * @param field 字段名称
		 * @param value 值
		 * @return  找到的集合项或null
		 */
		public function findByField(field:String, value:*):Object
		{
			for each (var item:* in this)
				if (item[field] == value)
					return item;
			return null;
		}
		
		/**
		 * 删除符合条件的所有集合项
		 * @param f 函数f(item)为true时代表符合条件
		 */
		public function remove(f:Function):void
		{
			for (var i:int=0; i < this.length; i++)
			{
				var item:Object=this.getItemAt(i);
				
				if (f(item))
					this.removeItemAt(i);
			}
		}
		
		/**
		 * 相加每个集合项对应的计算值
		 * @param f 函数f(item)为计算结果
		 * @return 总和
		 */
		public function sum(f:Function):Object
		{
			var value:Object;
			
			if (this.length > 0)
				value=f(this.getItemAt(0));
			
			for (var i:int=1; i < this.length; i++)
			{
				value+=f(this.getItemAt(i));
			}
			return value;
		}
		
		/**
		 * 查找符合条件的所有集合项的集合
		 * @param f 函数，f(item)为true代表符合条件
		 * @return  新集合
		 */
		public function grep(f:Function):ArrayCollectionPlus
		{
			var acp:ArrayCollectionPlus=new ArrayCollectionPlus();
			
			for (var i:int=0; i < this.length; i++)
			{
				var item:Object=this.getItemAt(i);
				
				if (f(item))
					acp.addItem(item);
			}
			return acp;
		}
		
		[Bindable("listChanged")]
		static public function withAll(source:Object, labelField:String, label:String=
			'全部'):ArrayCollectionPlus
		{
			var all:Object={};
			all[labelField]=label;
			return new ArrayCollectionPlus(source).addFirst(all);
		}
	}
}