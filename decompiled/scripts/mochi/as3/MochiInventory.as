package mochi.as3
{
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Proxy;
   import flash.utils.Timer;
   import flash.utils.flash_proxy;
   
   use namespace flash_proxy;
   
   public dynamic class MochiInventory extends Proxy
   {
      
      private static const CONSUMER_KEY:String = "MochiConsumables";
      
      private static const KEY_SALT:String = " syncMaint\x01";
      
      public static const READY:String = "InvReady";
      
      public static const WRITTEN:String = "InvWritten";
      
      public static const ERROR:String = "Error";
      
      public static const IO_ERROR:String = "IoError";
      
      public static const VALUE_ERROR:String = "InvValueError";
      
      public static const NOT_READY:String = "InvNotReady";
      
      private static var _dispatcher:MochiEventDispatcher = new MochiEventDispatcher();
      
      private var _timer:Timer;
      
      private var _consumableProperties:Object;
      
      private var _syncPending:Boolean;
      
      private var _outstandingID:Number;
      
      private var _syncID:Number;
      
      private var _names:Array;
      
      private var _storeSync:Object;
      
      public function MochiInventory()
      {
         super();
         MochiCoins.addEventListener(MochiCoins.ITEM_OWNED,itemOwned);
         MochiCoins.addEventListener(MochiCoins.ITEM_NEW,newItems);
         MochiSocial.addEventListener(MochiSocial.LOGGED_IN,loggedIn);
         MochiSocial.addEventListener(MochiSocial.LOGGED_OUT,loggedOut);
         _storeSync = new Object();
         _syncPending = false;
         _outstandingID = 0;
         _syncID = 0;
         _timer = new Timer(1000);
         _timer.addEventListener(TimerEvent.TIMER,sync);
         _timer.start();
         if(MochiSocial.loggedIn)
         {
            loggedIn();
         }
         else
         {
            loggedOut();
         }
      }
      
      public static function addEventListener(param1:String, param2:Function) : void
      {
         _dispatcher.addEventListener(param1,param2);
      }
      
      public static function triggerEvent(param1:String, param2:Object) : void
      {
         _dispatcher.triggerEvent(param1,param2);
      }
      
      public static function removeEventListener(param1:String, param2:Function) : void
      {
         _dispatcher.removeEventListener(param1,param2);
      }
      
      public function release() : void
      {
         MochiCoins.removeEventListener(MochiCoins.ITEM_NEW,newItems);
         MochiSocial.removeEventListener(MochiSocial.LOGGED_IN,loggedIn);
         MochiSocial.removeEventListener(MochiSocial.LOGGED_OUT,loggedOut);
      }
      
      private function loggedOut(param1:Object = null) : void
      {
         _consumableProperties = null;
      }
      
      private function loggedIn(param1:Object = null) : void
      {
         MochiUserData.get(CONSUMER_KEY,getConsumableBag);
      }
      
      private function newItems(param1:Object) : void
      {
         if(!this[param1.id + KEY_SALT])
         {
            this[param1.id + KEY_SALT] = 0;
         }
         if(!this[param1.id])
         {
            this[param1.id] = 0;
         }
         this[param1.id + KEY_SALT] += param1.count;
         this[param1.id] += param1.count;
         if(Boolean(param1.privateProperties) && Boolean(param1.privateProperties.consumable))
         {
            if(!this[param1.privateProperties.tag])
            {
               this[param1.privateProperties.tag] = 0;
            }
            this[param1.privateProperties.tag] += param1.privateProperties.inc * param1.count;
         }
      }
      
      private function itemOwned(param1:Object) : void
      {
         _storeSync[param1.id] = {
            "properties":param1.properties,
            "count":param1.count
         };
      }
      
      private function getConsumableBag(param1:MochiUserData) : void
      {
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         if(param1.error)
         {
            triggerEvent(ERROR,{
               "type":IO_ERROR,
               "error":param1.error
            });
            return;
         }
         _consumableProperties = {};
         _names = new Array();
         if(param1.data)
         {
            for(_loc2_ in param1.data)
            {
               _names.push(_loc2_);
               _consumableProperties[_loc2_] = new MochiDigits(param1.data[_loc2_]);
            }
         }
         for(_loc2_ in _storeSync)
         {
            _loc3_ = Number(_storeSync[_loc2_].count);
            if(_consumableProperties[_loc2_ + KEY_SALT])
            {
               _loc3_ -= _consumableProperties[_loc2_ + KEY_SALT].value;
            }
            if(_loc3_ != 0)
            {
               newItems({
                  "id":_loc2_,
                  "count":_loc3_,
                  "properties":_storeSync[_loc2_].properties
               });
            }
         }
         triggerEvent(READY,{});
      }
      
      private function putConsumableBag(param1:MochiUserData) : void
      {
         _syncPending = false;
         if(param1.error)
         {
            triggerEvent(ERROR,{
               "type":IO_ERROR,
               "error":param1.error
            });
            _outstandingID = -1;
         }
         triggerEvent(WRITTEN,{});
      }
      
      private function sync(param1:Event = null) : void
      {
         var _loc3_:String = null;
         if(_syncPending || _syncID == _outstandingID)
         {
            return;
         }
         _outstandingID = _syncID;
         var _loc2_:Object = {};
         for(_loc3_ in _consumableProperties)
         {
            _loc2_[_loc3_] = MochiDigits(_consumableProperties[_loc3_]).value;
         }
         MochiUserData.put(CONSUMER_KEY,_loc2_,putConsumableBag);
         _syncPending = true;
      }
      
      override flash_proxy function getProperty(param1:*) : *
      {
         if(_consumableProperties == null)
         {
            triggerEvent(ERROR,{"type":NOT_READY});
            return -1;
         }
         if(_consumableProperties[param1])
         {
            return MochiDigits(_consumableProperties[param1]).value;
         }
         return undefined;
      }
      
      override flash_proxy function deleteProperty(param1:*) : Boolean
      {
         if(!_consumableProperties[param1])
         {
            return false;
         }
         _names.splice(_names.indexOf(param1),1);
         delete _consumableProperties[param1];
         return true;
      }
      
      override flash_proxy function hasProperty(param1:*) : Boolean
      {
         if(_consumableProperties == null)
         {
            triggerEvent(ERROR,{"type":NOT_READY});
            return false;
         }
         if(_consumableProperties[param1] == undefined)
         {
            return false;
         }
         return true;
      }
      
      override flash_proxy function setProperty(param1:*, param2:*) : void
      {
         var _loc3_:MochiDigits = null;
         if(_consumableProperties == null)
         {
            triggerEvent(ERROR,{"type":NOT_READY});
            return;
         }
         if(!(param2 is Number))
         {
            triggerEvent(ERROR,{
               "type":VALUE_ERROR,
               "error":"Invalid type",
               "arg":param2
            });
            return;
         }
         if(_consumableProperties[param1])
         {
            _loc3_ = MochiDigits(_consumableProperties[param1]);
            if(_loc3_.value == param2)
            {
               return;
            }
            _loc3_.value = param2;
         }
         else
         {
            _names.push(param1);
            _consumableProperties[param1] = new MochiDigits(param2);
         }
         ++_syncID;
      }
      
      override flash_proxy function nextNameIndex(param1:int) : int
      {
         return param1 >= _names.length ? 0 : int(param1 + 1);
      }
      
      override flash_proxy function nextName(param1:int) : String
      {
         return _names[param1 - 1];
      }
   }
}

