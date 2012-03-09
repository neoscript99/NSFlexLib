package ns.flex.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.ui.Keyboard;

	import mx.containers.ApplicationControlBar;
	import mx.containers.TitleWindow;
	import mx.effects.Sequence;
	import mx.events.FlexEvent;
	import mx.events.ScrollEvent;

	import ns.flex.support.MenuSupport;
	import ns.flex.util.EffectUtil;

	[Event(name="enterKeyDown")]
	[Event(name="titleDoubleClick", type="flash.events.MouseEvent")]
	public class TitleWindowPlus extends TitleWindow
	{
		public var menuSupport:MenuSupport;

		protected var scrollFollowChildren:Array=[];
		private var shake:Sequence;

		public function TitleWindowPlus()
		{
			super();
			menuSupport=new MenuSupport(this);
			addEventListener(FlexEvent.CREATION_COMPLETE, cc);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			//ScrollEvent.SCROLL is not perfect
			addEventListener(Event.RENDER, onRenderScroll);
			shake=
				EffectUtil.createSequence({duration: 100, repeatCount: 2}, this,
				EffectUtil.createMove({xBy: 10}), EffectUtil.createMove({xBy: -10}));
		}

		public function addScrollFollowChild(child:DisplayObject):void
		{
			scrollFollowChildren.push(child);
		}

		public function playShake():void
		{
			shake.play();
		}

		protected function onRenderScroll(e:Event):void
		{
			trace('onRenderScroll:', e);
			var diso:DisplayObject;
			for each (diso in this.getChildren())
			{
				if (diso is ApplicationControlBar)
					diso.x=this.horizontalScrollPosition + this.getStyle('paddingLeft');
			}
			for each (diso in scrollFollowChildren)
			{
				diso.x=this.horizontalScrollPosition;
			}
		}

		protected function onTitleDoubleClick(e:MouseEvent):void
		{
			dispatchEvent(new MouseEvent('titleDoubleClick', e.bubbles, e.cancelable,
				e.localX, e.localY, e.relatedObject, e.ctrlKey, e.altKey, e.shiftKey,
				e.buttonDown, e.delta));
		}

		private function cc(e:FlexEvent):void
		{
			this.titleBar.toolTip='双击放大'
			this.titleBar.doubleClickEnabled=true;
			this.titleBar.addEventListener(MouseEvent.DOUBLE_CLICK, onTitleDoubleClick);
			menuSupport.createMenuItem('复制标题', copyTitle, false, true);
		}

		private function copyTitle(evt:Event=null):void
		{
			System.setClipboard(title);
		}

		private function onKeyDown(evt:KeyboardEvent):void
		{
			if (evt.keyCode == Keyboard.ENTER)
				this.dispatchEvent(new Event('enterKeyDown'));
		}
	}
}

