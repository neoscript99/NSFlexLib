package ns.flex.controls
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.system.IME;
	import flash.ui.Keyboard;
	
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import ns.flex.util.ObjectUtils;
	import ns.flex.util.RegExpValidatorPlus;
	import ns.flex.util.StringUtil;
	import ns.flex.util.ValidatorUtil;
	
	public class TextInputPlus extends TextInput
	{
		[Inspectable(category="General")]
		public var noSpace:Boolean=false;
		
		[Inspectable(category="General")]
		public var autoTrim:Boolean=true;
		
		[Inspectable(enumeration="true,false", defaultValue="true", category="General")]
		public var imeDisabled:Boolean=false;
		public var ignorePattern:RegExp;
		private var validator:RegExpValidatorPlus;
		
		public function TextInputPlus()
		{
			super();
			addEventListener(FlexEvent.VALUE_COMMIT, onValueCommit);
			maxChars=32;
			validator=new RegExpValidatorPlus(this);
		}
		
		public function set constraints(value:Object):void
		{
			ObjectUtils.copyProperties(this, value);
			validator.copyProperties(value);
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
		
		override protected function focusInHandler(event:FocusEvent):void
		{
			super.focusInHandler(event);
			IME.enabled=!imeDisabled;
		}
		
		override protected function focusOutHandler(event:FocusEvent):void
		{
			super.focusOutHandler(event);
			IME.enabled=true;
		}
		
		protected function onValueCommit(event:Event):void
		{
			if (noSpace)
				text=StringUtil.removeSpace(text);
			else if (autoTrim)
				text=StringUtil.trim(text);
			
			if (ignorePattern)
				text=text.replace(ignorePattern, '');
		}
	}
}