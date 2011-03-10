package ns.flex.controls
{
	import flash.events.MouseEvent;
	
	import mx.containers.TitleWindow;
	import mx.effects.Move;
	import mx.effects.Sequence;
	import mx.events.FlexEvent;
	
	import ns.flex.util.EffectUtil;
	
	[Event(name="titleDoubleClick", type="flash.events.MouseEvent")]
	public class TitleWindowPlus extends TitleWindow
	{
		private var shake:Sequence;
		
		public function TitleWindowPlus()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, cc);
			shake=
				EffectUtil.createSequence({duration: 100, repeatCount: 2}, this,
				EffectUtil.createMove({xBy: 10}), EffectUtil.createMove({xBy: -10}));
		}
		
		private function cc(e:FlexEvent):void
		{
			this.titleBar.doubleClickEnabled=true;
			this.titleBar.addEventListener(MouseEvent.DOUBLE_CLICK, onTitleDoubleClick);
		}
		
		protected function onTitleDoubleClick(e:MouseEvent):void
		{
			dispatchEvent(new MouseEvent('titleDoubleClick', e.bubbles, e.cancelable,
				e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey,
				e.buttonDown, e.delta));
		}
		
		public function playShake():void
		{
			shake.play();
		}
	}
}