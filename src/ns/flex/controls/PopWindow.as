package ns.flex.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.managers.SystemManager;

	import ns.flex.support.MenuSupport;

	public class PopWindow extends TitleWindowPlus
	{
		private var originWidth:Number;
		private var originHeight:Number;
		private var originX:Number;
		private var originY:Number;
		public var menuSupport:MenuSupport;
		private var popProgress:ProgressBox;

		public function PopWindow()
		{
			super();
			showCloseButton=true
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(FlexEvent.CREATION_COMPLETE, cc);
			addEventListener(CloseEvent.CLOSE, onClose);
			addEventListener(Event.ADDED, function(e:Event):void
			{
				setFocus();
			});
			addEventListener('titleDoubleClick', switchSize);
			setStyle('horizontalAlign', 'center')
			setStyle('borderAlpha', .9)

			maxWidth=SystemManager.getSWFRoot(this).stage.stageWidth * .9;
			maxHeight=SystemManager.getSWFRoot(this).stage.stageHeight * .9;
		}

		private function switchSize(e:Event):void
		{
			if (isNaN(originWidth))
			{
				originWidth=width;
				originHeight=height;
			}

			if (originWidth == width && originHeight == height)
			{
				width=parent.width;
				height=parent.height;
				originX=x;
				originY=y;
				x=0;
				y=0;
			}
			else
			{
				width=originWidth;
				height=originHeight;
				x=originX;
				y=originY;
			}
		}

		private function cc(e:Event):void
		{
			//height最大时，出现横竖滚动条，加大width，去除横向滚动
			if (height == maxHeight && this.verticalScrollBar)
				width+=this.verticalScrollBar.width * 2;
			center();
			menuSupport=new MenuSupport(this);
			menuSupport.createMenuItem('关闭', onClose, false, true);
		}

		//导致重影，无法解决
		private function followMouse():void
		{
			trace(mouseX, mouseY);
			var moveToX:Number=mouseX - width / 2;
			var moveToY:Number=mouseY - height / 2;

			if (moveToX < 0)
				moveToX=0;

			if (moveToX + width > stage.stageWidth)
				moveToX=stage.stageWidth - width;

			if (moveToY + height > stage.stageHeight)
				moveToY=stage.stageHeight - height;

			//顺序不能改变，保证关闭按钮显示
			if (moveToY < 0)
				moveToY=0;
			x=moveToX;
			y=moveToY;
		}

		private function onKeyDown(evt:KeyboardEvent):void
		{
			if (evt.keyCode == Keyboard.ESCAPE)
				close();
		}

		private function onClose(evt:Event=null):void
		{
			closeProgress();

			if (this.isPopUp)
				PopUpManager.removePopUp(this);
		}

		public function center():void
		{
			if (this.isPopUp)
				PopUpManager.centerPopUp(this);
		}

		public function show(parent:DisplayObject, modal:Boolean=true):void
		{
			PopUpManager.addPopUp(this, parent, modal);
		}

		public function close():void
		{
			this.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
			trace('CloseEvent');
		}

		public function showProgress():void
		{
			if (!popProgress)
				popProgress=new ProgressBox();
			popProgress.show(this);
		}

		public function closeProgress():void
		{
			if (popProgress)
				popProgress.close();
		}
	}
}

