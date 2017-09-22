package ns.flex.util
{
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.mxml.RemoteObject;

public class RemoteUtil
{
    /**
     * 创建远程对象通用方法
     * @param destination
     * @param resultListeners [{method:,listener:}]
     * @param showBusyCursor
     * @param concurrency mx.rpc.mxml.Concurrency
     * @return
     */
    static public function createRemoteObject(destination:String,
                                              resultListeners:Array = null, faultListener:Function = null,
                                              showBusyCursor:Boolean = true, concurrency:String = 'multiple'):RemoteObject
    {
        var ro:RemoteObject = new RemoteObject(destination);
        ro.showBusyCursor = showBusyCursor;
        ro.concurrency = concurrency;
        ro.addEventListener(FaultEvent.FAULT,
                faultListener == null ? MessageUtil.showError : faultListener);

        ro.addEventListener(ResultEvent.RESULT, function (e:ResultEvent):void
        {
            if (e.result.hasMessage)
                MessageUtil.showMessage(e.result.message)
        });

        if (resultListeners)
            resultListeners.forEach(function (item:*, index:int, array:Array):void
            {
                ro.getOperation(item.method).addEventListener(ResultEvent.RESULT,
                        item.listener);
            });
        return ro;
    }
}
}

