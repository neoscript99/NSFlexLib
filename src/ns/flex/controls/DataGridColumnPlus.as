package ns.flex.controls
{
	import mx.controls.Text;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.utils.ObjectUtil;
	import ns.flex.util.DateUtil;
	import ns.flex.util.ObjectUtils;
	import ns.flex.util.StringUtil;

	/**
	 * datagrid类对象增强，包括功能：1、支持dataField属性嵌套；2、支持数字设定小数点位数；
	 * 3、文字支持复制；4、标题默认自动换行。
	 * @author wangchu
	 */
	public class DataGridColumnPlus extends DataGridColumn
	{
		[Inspectable(enumeration="Text,TextArea,CheckBox,DateString,AutoComplete,LinkButton",
			defaultValue="Text", category="General")]
		public var asControl:String='Text';
		[Inspectable(category="General")]
		public var asNumber:Boolean=false;
		public var controlProps:Object; //for asComboBox
		[Inspectable(enumeration="sum,avg,max,min,none", defaultValue="",
			category="General")]
		public var groupMethod:String;
		[Inspectable(category="General")]
		public var isSeparateThousands:Boolean=true;
		//use for set visiable,not work if is '*ignore*'
		public var type:String;
		//能否显示在datagrid的view pop中
		[Inspectable(category="General")]
		public var viewable:Boolean=true;
		// @see TextInputPlus,TextAreaPlus,DateFieldPlus
		private var _constraints:Object;
		private var _percision:int;

		public function DataGridColumnPlus(columnName:String=null)
		{
			super(columnName);
			headerWordWrap=true;
			itemRenderer=new ClassFactory(SelectableLabel);
		}

		public static function getNumberLabel(item:Object,
			column:DataGridColumnPlus):String
		{
			return StringUtil.formatNumber(column.getValue(item), column._percision,
				column.isSeparateThousands);
		}

		[Inspectable(category="General")]
		public function set asAutoComplete(props:Object):void
		{
			asControl='AutoComplete';
			controlProps=props;
		}

		/**
		 *
		 * @param info like {labelField:'',dataField:'',dataProvider:[]}
		 */
		[Inspectable(category="General")]
		public function set asComboBox(props:Object):void
		{
			asControl='ComboBox';
			controlProps=props;
		}

		[Inspectable(category="General")]
		public function set asDate(b:Boolean):void
		{
			if (b)
			{
				labelFunction=DateUtil.getDateLabel;
				asControl='DateField';
			}
		}

		[Inspectable(category="General")]
		public function set asTime(b:Boolean):void
		{
			if (b)
			{
				labelFunction=DateUtil.getTimeLabel;
				asControl='DateField';
			}
		}

		[Inspectable(category="General")]
		/**
		 * 嵌套字段已根据中文排序，不能再在这里设置
		 * @param value
		 */
		public function set chineseSort(value:Boolean):void
		{
			if (value)
				this.sortCompareFunction=complexColumnSortCompare;
		}

		public function get constraints():Object
		{
			return _constraints;
		}

		public function set constraints(value:Object):void
		{
			_constraints=
				(value is Array) ? ObjectUtils.mergeObjectArray(value as Array) : value;
		}

		public function getValue(item:Object):Object
		{
			return (!hasComplexFieldName) ? item[dataField] : deriveComplexColumnData(item);
		}

		public function set percision(p:int):void
		{
			_percision=p;
			if (!groupMethod)
				groupMethod='sum';
			if (labelFunction == null)
				labelFunction=DataGridColumnPlus.getNumberLabel;
			this.setStyle('textAlign', 'right');
		}

		/**
		 * 默认使用SelectableLabel的truncateToFit
		 * 如果设wordWrap为ture，改用Text，可以多行，对话框控件改用TextArea
		 * 如果想保留truncateToFit，但对话框控件是TextArea，可设置asControl=TextArea
		 * @param value
		 */
		override public function set wordWrap(value:*):void
		{
			super.wordWrap=value;
			if (value == true)
				itemRenderer=new ClassFactory(Text);
		}

		override protected function complexColumnSortCompare(obj1:Object, obj2:Object):int
		{
			if (!obj1 && !obj2)
				return 0;

			if (!obj1)
				return 1;

			if (!obj2)
				return -1;

			var obj1Data:String=itemToLabel(obj1);
			var obj2Data:String=itemToLabel(obj2);
			if (!asNumber)
				return StringUtil.chineseCompare(obj1Data, obj2Data);
			else
				return ObjectUtil.numericCompare(Number(obj1Data), Number(obj2Data));
		}

		override protected function deriveComplexColumnData(data:Object):Object
		{
			return ObjectUtils.getValue(data, dataField);
		}
	}
}

