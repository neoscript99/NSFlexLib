package ns.flex.controls
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	import ns.flex.util.ObjectUtils;
	import ns.flex.util.RegExpValidatorPlus;
	import ns.flex.util.StringUtil;
	import ns.flex.util.Validatable;
	import ns.flex.util.ValidatorUtil;

	[Event(name="enterKeyDown")]
	public class TextAreaPlus extends TextArea implements Validatable
	{
		[Inspectable(category="General")]
		public var autoTrim:Boolean=true;
		private const THRESHOLD_SIZE:int=64;
		[Inspectable(category="General")]
		private var validator:RegExpValidatorPlus;

		public function TextAreaPlus()
		{
			super();
			addEventListener(FlexEvent.VALUE_COMMIT, onValueCommit);
			addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			maxChars=64;
			height=60;
		}

		public function set constraints(value:Object):void
		{
			if (value)
			{
				if (!validator)
					validator=new RegExpValidatorPlus(this);
				ObjectUtils.copyProperties(this, value);

				if (maxChars > THRESHOLD_SIZE)
				{
					width=Math.min(maxChars / THRESHOLD_SIZE, 3) * 160;
					height=Math.min(maxChars / THRESHOLD_SIZE, 3) * 60;
				}
				validator.copyProperties(value);
			}
		}

		[Bindable("textChanged")]
		[Bindable("maxCharsChanged")]
		public function get remainSize():int
		{
			return maxChars - text.length;
		}

		[Bindable("valueCommit")]
		public function get validated():Boolean
		{
			return ValidatorUtil.validate(validator);
		}

		public function set zoom(times:Number):void
		{
			width=times * 160;
			height=times * 60;
		}

		private function onKeyDown(evt:KeyboardEvent):void
		{
			if (evt.keyCode == Keyboard.ENTER)
				this.dispatchEvent(new Event('enterKeyDown'));
		}

		private function onValueCommit(e:Event):void
		{
			if (autoTrim)
				text=StringUtil.trim(text);
		}
	}
}

