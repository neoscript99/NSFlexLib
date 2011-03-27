package ns.flex.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import mx.containers.TitleWindow;
	import mx.effects.Sequence;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import ns.flex.util.EffectUtil;
	
	[Event(name="enterKeyDown")]
	[Event(name="titleDoubleClick", type="flash.events.MouseEvent")]
	public class TitleWindowPlus extends TitleWindow
	{
		private var shake:Sequence;
		
		public function TitleWindowPlus()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, cc);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
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
		
		private function onKeyDown(evt:KeyboardEvent):void
		{
			if (evt.keyCode == Keyboard.ENTER)
				this.dispatchEvent(new Event('enterKeyDown'));
		}
		
		public function playShake():void
		{
			shake.play();
		}
	}
}