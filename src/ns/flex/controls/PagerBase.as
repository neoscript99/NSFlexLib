package ns.flex.controls
{
	import mx.containers.ControlBar;
	import mx.controls.NumericStepper;
	import mx.skins.halo.NumericStepperUpSkin;
	import ns.flex.event.PageChangeEvent;
	import ns.flex.util.ContainerUtil;

	[Event(name="changePage", type="ns.flex.event.PageChangeEvent")]
	public class PagerBase extends ControlBar
	{

		[Bindable]
		protected var _offsetValue:int=15;
		[Bindable]
		protected var curPage:int=0;

		public function get first():int
		{
			return (curPage - 1) * _offsetValue
		}

		/*
		 *检查当前查询的firstResult是否小于0，是的话标识重置当前页
		 */
		public function forFirst(first:int):int
		{
			var realFirst:int=first > 0 ? first : 0;
			curPage=realFirst / _offsetValue + 1;
			return realFirst;
		}

		/*
		 *向前或向后多少页
		 *num可以为负数
		 */
		public function go(num:int):void
		{
			gotoPage(curPage + num);
		}

		/*
		 *跳转到某页，触发换页事件
		 */
		public function gotoPage(pageIndex:int):void
		{
			curPage=pageIndex;
			dispatchEvent(new PageChangeEvent((curPage - 1) * _offsetValue));
		}

		public function set offsetValue(value:int):void
		{
			_offsetValue=value;
		}

		public function get offsetValue():int
		{
			return _offsetValue;
		}

		/*
		 *刷新当前页
		 */
		public function refresh(e:Event=null):void
		{
			go(0)
		}

		protected function changeStepper(value:int):void
		{
			_offsetValue=value;
			go(0);
		}
	}
}

