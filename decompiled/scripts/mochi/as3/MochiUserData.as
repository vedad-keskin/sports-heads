package mochi.as3
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.ObjectEncoding;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   
   public class MochiUserData extends EventDispatcher
   {
      
      public var _loader:URLLoader;
      
      public var key:String = null;
      
      public var data:* = null;
      
      public var error:Event = null;
      
      public var operation:String = null;
      
      public var callback:Function = null;
      
      public function MochiUserData(param1:String = "", param2:Function = null)
      {
         super();
         this.key = param1;
         this.callback = param2;
      }
      
      public static function get(param1:String, param2:Function) : void
      {
         var _loc3_:MochiUserData = new MochiUserData(param1,param2);
         _loc3_.getEvent();
      }
      
      public static function put(param1:String, param2:*, param3:Function) : void
      {
         var _loc4_:MochiUserData = new MochiUserData(param1,param3);
         _loc4_.putEvent(param2);
      }
      
      public function serialize(param1:*) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.objectEncoding = ObjectEncoding.AMF3;
         _loc2_.writeObject(param1);
         _loc2_.compress();
         return _loc2_;
      }
      
      public function deserialize(param1:ByteArray) : *
      {
         param1.objectEncoding = ObjectEncoding.AMF3;
         param1.uncompress();
         return param1.readObject();
      }
      
      public function request(param1:String, param2:ByteArray) : void
      {
         var api_url:String;
         var api_token:String;
         var args:URLVariables;
         var req:URLRequest;
         var _operation:String = param1;
         var _data:ByteArray = param2;
         operation = _operation;
         api_url = MochiSocial.getAPIURL();
         api_token = MochiSocial.getAPIToken();
         if(api_url == null || api_token == null)
         {
            errorHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,"not logged in"));
            return;
         }
         _loader = new URLLoader();
         args = new URLVariables();
         args.op = _operation;
         args.key = key;
         req = new URLRequest(MochiSocial.getAPIURL() + "/" + "MochiUserData?" + args.toString());
         req.method = URLRequestMethod.POST;
         req.contentType = "application/x-mochi-userdata";
         req.requestHeaders = [new URLRequestHeader("x-mochi-services-version",MochiServices.getVersion()),new URLRequestHeader("x-mochi-api-token",api_token)];
         req.data = _data;
         _loader.dataFormat = URLLoaderDataFormat.BINARY;
         _loader.addEventListener(Event.COMPLETE,completeHandler);
         _loader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
         _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
         try
         {
            _loader.load(req);
         }
         catch(e:SecurityError)
         {
            errorHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,"security error: " + e.toString()));
         }
      }
      
      public function completeHandler(param1:Event) : void
      {
         var event:Event = param1;
         try
         {
            if(_loader.data.length)
            {
               data = deserialize(_loader.data);
            }
            else
            {
               data = null;
            }
         }
         catch(e:Error)
         {
            errorHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,"deserialize error: " + e.toString()));
            return;
         }
         if(callback != null)
         {
            performCallback();
         }
         else
         {
            dispatchEvent(event);
         }
         close();
      }
      
      public function errorHandler(param1:IOErrorEvent) : void
      {
         data = null;
         error = param1;
         if(callback != null)
         {
            performCallback();
         }
         else
         {
            dispatchEvent(param1);
         }
         close();
      }
      
      public function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         errorHandler(new IOErrorEvent(IOErrorEvent.IO_ERROR,false,false,"security error: " + param1.toString()));
      }
      
      public function performCallback() : void
      {
         try
         {
            callback(this);
         }
         catch(e:Error)
         {
            trace("[MochiUserData] exception during callback: " + e);
         }
      }
      
      public function close() : void
      {
         if(_loader)
         {
            _loader.removeEventListener(Event.COMPLETE,completeHandler);
            _loader.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
            _loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
            _loader.close();
            _loader = null;
         }
         error = null;
         callback = null;
      }
      
      public function getEvent() : void
      {
         request("get",serialize(null));
      }
      
      public function putEvent(param1:*) : void
      {
         request("put",serialize(param1));
      }
      
      override public function toString() : String
      {
         return "[MochiUserData operation=" + operation + " key=\"" + key + "\" data=" + data + " error=\"" + error + "\"]";
      }
   }
}

