package ns.flex.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.ui.Keyboard;
	import mx.binding.utils.BindingUtils;
	import mx.containers.TitleWindow;
	import mx.effects.Sequence;
	import mx.events.FlexEvent;
	import mx.events.ScrollEvent;
	import mx.events.ScrollEventDirection;
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
			shake=
				EffectUtil.createSequence({duration: 100, repeatCount: 2}, this,
				EffectUtil.createMove({xBy: 10}), EffectUtil.createMove({xBy: -10}));
		}

		// set horizontalScrollPosition=0 after update
		public function addScrollFollowChild(child:DisplayObject):void
		{
			BindingUtils.bindSetter(function(value:Number):void
			{
				child.x=value;
			}, this, 'horizontalScrollPosition')
		}

		public function playShake():void
		{
			shake.play();
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

