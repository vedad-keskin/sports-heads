package mochi.as3
{
   public final class MochiDigits
   {
      
      private var Fragment:Number;
      
      private var Sibling:MochiDigits;
      
      private var Encoder:Number;
      
      public function MochiDigits(param1:Number = 0, param2:uint = 0)
      {
         super();
         Encoder = 0;
         setValue(param1,param2);
      }
      
      public function get value() : Number
      {
         return Number(this.toString());
      }
      
      public function set value(param1:Number) : void
      {
         setValue(param1);
      }
      
      public function addValue(param1:Number) : void
      {
         value += param1;
      }
      
      public function setValue(param1:Number = 0, param2:uint = 0) : void
      {
         var _loc3_:String = param1.toString();
         Fragment = _loc3_.charCodeAt(param2++) ^ Encoder;
         if(param2 < _loc3_.length)
         {
            Sibling = new MochiDigits(param1,param2);
         }
         else
         {
            Sibling = null;
         }
         reencode();
      }
      
      public function reencode() : void
      {
         var _loc1_:uint = uint(int(2147483647 * Math.random()));
         Fragment ^= _loc1_ ^ Encoder;
         Encoder = _loc1_;
      }
      
      public function toString() : String
      {
         var _loc1_:String = String.fromCharCode(Fragment ^ Encoder);
         if(Sibling != null)
         {
            _loc1_ += Sibling.toString();
         }
         return _loc1_;
      }
   }
}

