package ns.flex.controls
{
	import mx.controls.Text;
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
		[Inspectable(enumeration="Text,TextArea,CheckBox,DateString", defaultValue="Text",
			category="General")]
		public var asControl:String='Text';
		public var comboBoxInfo:Object; //for asComboBox
		// @see TextInputPlus,TextAreaPlus,DateFieldPlus
		public var constraints:Object;
		[Inspectable(enumeration="sum,avg,max,min,none", defaultValue="",
			category="General")]
		public var groupMethod:String;
		[Inspectable(category="General")]
		public var isSeparateThousands:Boolean=true;
		[Inspectable(category="General")]
		public var readonly:Boolean=false;
		private var _percision:int;

		public function DataGridColumnPlus(columnName:String=null)
		{
			super(columnName);
			headerWordWrap=true;
			itemRenderer=new ClassFactory(SelectableLabel);
		}

		public static function getLabel(item:Object, column:DataGridColumn):String
		{
			var label:Object=item;
			column.dataField.split('.').every(function(it:*, index:int, arr:Array):Boolean
			{
				//返回为false时停止every
				label=label[it]
				return (label != null);
			});

			if (label != null)
				return String(label);
			else if (item[column.dataField] != null)
				return String(item[column.dataField]);
			else
				return '';
		}

		public static function getNumberLabel(item:Object,
			column:DataGridColumnPlus):String
		{
			var label:String=StringUtil.trim(getLabel(item, column));
			return label.length == 0 ? label : StringUtil.formatNumber(Number(label),
				column._percision, column.isSeparateThousands);
		}

		/**
		 *
		 * @param info like {labelField:'',dataField:'',dataProvider:[]}
		 */
		[Inspectable(category="General")]
		public function set asComboBox(info:Object):void
		{
			asControl='ComboBox';
			comboBoxInfo=info;
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
		public function set chineseSort(value:Boolean):void
		{
			if (value)
				this.sortCompareFunction=StringUtil.chineseCompare;
		}

		/**
		 * Flex 3.6已增加功能支持嵌套字段
		 * 这里只是保持老代码正确
		 * @param nestField
		 */
		public function set nestDataField(nestField:String):void
		{
			dataField=nestField;
			//Flex 3.6已增加功能支持嵌套字段
			//sortable = false;
			//labelFunction=DataGridColumnPlus.getLabel;
		}

		public function set percision(p:int):void
		{
			_percision=p;
			if (!groupMethod)
				groupMethod='sum';
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

			var obj1Data:String=deriveComplexColumnData(obj1).toString();
			var obj2Data:String=deriveComplexColumnData(obj2).toString();
			return StringUtil.chineseCompare(obj1Data, obj2Data);

		}
	}
}

