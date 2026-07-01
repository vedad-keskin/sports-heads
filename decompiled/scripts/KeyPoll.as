package
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.utils.ByteArray;
   
   public class KeyPoll
   {
      
      private var states:ByteArray;
      
      private var dispObj:DisplayObject;
      
      public function KeyPoll(param1:DisplayObject)
      {
         super();
         states = new ByteArray();
         states.writeUnsignedInt(0);
         states.writeUnsignedInt(0);
         states.writeUnsignedInt(0);
         states.writeUnsignedInt(0);
         states.writeUnsignedInt(0);
         states.writeUnsignedInt(0);
         states.writeUnsignedInt(0);
         states.writeUnsignedInt(0);
         dispObj = param1;
         dispObj.addEventListener(KeyboardEvent.KEY_DOWN,keyDownListener,false,0,true);
         dispObj.addEventListener(KeyboardEvent.KEY_UP,keyUpListener,false,0,true);
         dispObj.addEventListener(Event.ACTIVATE,activateListener,false,0,true);
         dispObj.addEventListener(Event.DEACTIVATE,deactivateListener,false,0,true);
      }
      
      private function keyDownListener(param1:KeyboardEvent) : void
      {
         states[param1.keyCode >>> 3] |= 1 << (param1.keyCode & 7);
      }
      
      private function keyUpListener(param1:KeyboardEvent) : void
      {
         states[param1.keyCode >>> 3] &= ~(1 << (param1.keyCode & 7));
      }
      
      private function activateListener(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 32)
         {
            states[_loc2_] = 0;
            _loc2_++;
         }
      }
      
      private function deactivateListener(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 32)
         {
            states[_loc2_] = 0;
            _loc2_++;
         }
      }
      
      public function isDown(param1:uint) : Boolean
      {
         return (states[param1 >>> 3] & 1 << (param1 & 7)) != 0;
      }
      
      public function isUp(param1:uint) : Boolean
      {
         return (states[param1 >>> 3] & 1 << (param1 & 7)) == 0;
      }
   }
}

