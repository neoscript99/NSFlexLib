package ns.flex.controls
{
import com.hillelcoren.components.AutoComplete;

import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import mx.collections.ArrayCollection;
import mx.validators.Validator;

import ns.flex.util.ContainerUtil;
import ns.flex.util.ObjectUtils;
import ns.flex.util.StringUtil;
import ns.flex.util.Validatable;
import ns.flex.util.ValidatorUtil;

public class AutoCompletePlus extends AutoComplete implements Validatable
{
    protected var _editable:Boolean = true;
    protected var _editableChanged:Boolean = false;
    private var validator:Validator;

    public function AutoCompletePlus()
    {
        super();
        _selectedItems = new ArrayCollection();
        backspaceAction = BACKSPACE_REMOVE;
        showRemoveIcon = true;
        _dropDownRowCount = 12;
        prompt = '使用逗号(,)或回车分隔多个项目';
    }

    override public function set allowMultipleSelection(value:Boolean):void
    {
        super.allowMultipleSelection = value;
        prompt = value ? '使用逗号(,)或回车分隔多个项目' : '请输入或选择';
    }

    public function get allowMultipleSelection():Boolean
    {
        return super._allowMultipleSelection;
    }

    public function get labelField():String
    {
        return _labelField;
    }

    public function get allowNewValues():Boolean
    {
        return _allowNewValues;
    }

    //清空后，应该刷新下拉列表
    override public function clear():void
    {
        super.clear();
        search();
    }

    public function set constraints(value:Object):void
    {
        if (value)
        {
            if (!validator)
            {
                validator = new Validator();
                validator.required = true;
                validator.source = this;
                validator.trigger = this;
                validator.property = 'selectedLabels';
                validator.requiredFieldError = '请选择项目';
            }
            ObjectUtils.copyProperties(this, value);
            ObjectUtils.copyProperties(validator, value);
        }
    }

    [Bindable(event="change")]
    [Bindable(event="valueCommit")]
    [Inspectable(category="General")]
    public function get editable():Boolean
    {
        return _editable;
    }

    public function set editable(value:Boolean):void
    {
        if (_editable != value)
        {
            _editable = value;
            showRemoveIcon = _editable;
            _editableChanged = true;
            invalidateProperties();
        }
    }

    //基类将selectedItem添加到 selectedItems，就置为null,如果再传入null将不做任何处理，我觉得传入null应该清空选择项
    override public function set selectedItem(value:Object):void
    {
        _selectedItem = value;
        _selectedItemChanged = true;

        invalidateProperties();
    }

    //不要赋值空列表，否则prompt不显示
    override public function set selectedItems(value:ArrayCollection):void
    {
        super.selectedItems = value;
        if (value == null || value.length == 0)
            if (flowBox && flowBox.textInput)
                clear();
    }

    //选择返回label时，去除空格和大小写重复
    [Bindable(event="change")]
    [Bindable(event="valueCommit")]
    public function get selectedLabels():Array
    {
        var labels:Array = [];
        var map:Object = {};
        if (_selectedItems)
            for each (var item:Object in _selectedItems.source)
            {
                var key:String = StringUtil.trim(String(labelFunction(item)))
                if (map[key.toLowerCase()])
                    map[key.toLowerCase()]++
                else
                {
                    map[key.toLowerCase()] = 1;
                    labels.push(key);
                }
            }
        return labels;
    }

    public function get validated():Boolean
    {
        return ValidatorUtil.validate(validator);
    }

    override protected function commitProperties():void
    {
        super.commitProperties();
        if (_editableChanged)
        {
            if (_editable)
                addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
            else
                removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
            ContainerUtil.eachChild(this, function (child:Object):void
            {
                if (child.hasOwnProperty('editable'))
                    child.editable = _editable;
            }, true);
        }
    }

    override protected function defaultLabelFunction(item:Object):String
    {
        var value:Object;
        if (_labelField)
            value = ObjectUtils.getValue(item, _labelField);
        return value ? String(value) : super.defaultLabelFunction(item);
    }

    //回车不要向上抛出，防止提交
    override protected function handleKeyDown(evt:KeyboardEvent):void
    {
        super.handleKeyDown(evt);
        if (evt.keyCode == Keyboard.ENTER)
            evt.stopImmediatePropagation();
    }

    //不需要自动选择，无法增加前缀相同的选择，如有Java后无法增加Javascript
    override protected function isPerfectMatch():Boolean
    {
        return false;
    }
}
}

