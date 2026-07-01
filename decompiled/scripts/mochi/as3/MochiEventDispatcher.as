package mochi.as3
{
   public class MochiEventDispatcher
   {
      
      private var eventTable:Object;
      
      public function MochiEventDispatcher()
      {
         super();
         eventTable = {};
      }
      
      public function addEventListener(param1:String, param2:Function) : void
      {
         removeEventListener(param1,param2);
         eventTable[param1].push(param2);
      }
      
      public function removeEventListener(param1:String, param2:Function) : void
      {
         var _loc3_:Object = null;
         if(eventTable[param1] == undefined)
         {
            eventTable[param1] = [];
            return;
         }
         for(_loc3_ in eventTable[param1])
         {
            if(eventTable[param1][_loc3_] == param2)
            {
               eventTable[param1].splice(Number(_loc3_),1);
            }
         }
      }
      
      public function triggerEvent(param1:String, param2:Object) : void
      {
         var _loc3_:Object = null;
         if(eventTable[param1] == undefined)
         {
            return;
         }
         for(_loc3_ in eventTable[param1])
         {
            eventTable[param1][_loc3_](param2);
         }
      }
   }
}

