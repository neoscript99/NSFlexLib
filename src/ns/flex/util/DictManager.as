package ns.flex.util
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.mxml.RemoteObject;

	import ns.flex.controls.ProgressBox;

	public class DictManager
	{
		static public var initCompleted:Boolean=false;
		static private var dictionaryService:RemoteObject;
		static private var listMap:Object={};
		static private var readyCount:int=0;
		static private var pb:ProgressBox=new ProgressBox()

		static public function init(ds:RemoteObject, readyGoal:int,
			parent:DisplayObject):void
		{
			dictionaryService=ds;
			pb.title='System Initlizing...';
			pb.show(parent);
			dictionaryService.addEventListener(ResultEvent.RESULT, function(e:Event):void
			{
				if ((++readyCount) >= readyGoal)
				{
					initCompleted=true;
					pb.close();
					pb=null;
				}
			});
		}

		static public function getLabel(operationName:String, fieldName:String,
			fieldValue:Object, labelField:String):String
		{
			var oo:Object=getList(operationName).findByField(fieldName, fieldValue);
			return oo ? oo[labelField] : String(fieldValue);
		}

		static public function getResult(operationName:String):Object
		{
			return dictionaryService.getOperation(operationName).lastResult;
		}

		static public function getList(operationName:String):ArrayCollectionPlus
		{
			return getListFromMap(operationName);
		}

		static public function getListWithAll(operationName:String,
			labelField:String):ArrayCollectionPlus
		{
			return getListFromMap(operationName, labelField, true);
		}

		static public function getListWithAskToChoose(operationName:String,
			labelField:String):ArrayCollectionPlus
		{
			return getListFromMap(operationName, labelField, false, true);
		}

		static private function getListFromMap(operationName:String,
			labelField:String=null, withAll:Boolean=false,
			withAskToChoose:Boolean=false):ArrayCollectionPlus
		{
			var key:String=operationName.concat(withAll, withAskToChoose);
			if (!listMap[operationName])
			{
				if (labelField && (withAll || withAskToChoose))
				{
					var first:Object={};
					first[labelField]=withAll ? '全部' : '请选择';
					listMap[key]=
						ArrayCollectionPlus.withFirst(dictionaryService.getOperation(operationName).lastResult,
						first);
				}
				else
					listMap[key]=
						new ArrayCollectionPlus(dictionaryService.getOperation(operationName).lastResult);

			}
			return listMap[key];
		}
	}
}

