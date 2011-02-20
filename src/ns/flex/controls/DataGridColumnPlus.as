package ns.flex.controls
{
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import ns.flex.util.DateUtil;
	import ns.flex.util.StringUtil;
	
	/**
	 * datagrid类对象增强，包括功能：1、支持dataField属性嵌套；2、支持数字设定小数点位数；
	 * 3、文字支持复制；4、标题默认自动换行。
	 * @author wangchu
	 */
	public class DataGridColumnPlus extends DataGridColumn
	{
		private var _percision:int;
		[Inspectable(category="General")]
		public var isSeparateThousands:Boolean=true;
		//以下属性用来自动生成编辑对话框
		[Inspectable(category="General")]
		public var imeDisabled:Boolean=false;
		[Inspectable(category="General")]
		public var noSpace:Boolean=false;
		[Inspectable(category="General")]
		public var autoTrim:Boolean=true;
		[Inspectable(category="General")]
		public var required:Boolean=false;
		public var maxChars:int=32;
		public var expression:String;
		public var flags:String;
		[Inspectable(enumeration="Text,CheckBox", defaultValue="Text",
			category="General")]
		public var asControl:String='Text';
		
		public function DataGridColumnPlus(columnName:String=null)
		{
			super(columnName);
			labelFunction=DataGridColumnPlus.getLabel;
			headerWordWrap=true;
			itemRenderer=new ClassFactory(DataGridColumnRenderer);
		}
		
		public function set percision(p:int):void
		{
			_percision=p;
			labelFunction=getNumberLabel;
			this.setStyle('textAlign', 'right');
		}
		
		[Inspectable(category="General")]
		public function set asDate(b:Boolean):void
		{
			if (b)
				labelFunction=DateUtil.getDateLabel;
		}
		
		[Inspectable(category="General")]
		public function set asTime(b:Boolean):void
		{
			if (b)
				labelFunction=DateUtil.getTimeLabel;
		}
		
		public function getNumberLabel(item:Object, column:DataGridColumn):String
		{
			return StringUtil.formatNumber(Number(item[column.dataField]), _percision,
				isSeparateThousands);
		}
		
		static public function getLabel(item:Object, column:DataGridColumn):String
		{
			column.dataField.split('.').every(function(it:*, index:int, arr:Array):Boolean
			{
				//返回为false时停止every
				item=item[it]
				return (item != null);
			});
			
			if (item == null)
				return '';
			else
				return String(item);
		}
	}
}