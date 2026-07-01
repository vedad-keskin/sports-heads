package Box2D.Collision
{
   public class b2Bound
   {
      
      public var value:uint;
      
      public var proxy:b2Proxy;
      
      public var stabbingCount:uint;
      
      public function b2Bound()
      {
         super();
      }
      
      public function IsLower() : Boolean
      {
         return (value & 1) == 0;
      }
      
      public function IsUpper() : Boolean
      {
         return (value & 1) == 1;
      }
      
      public function Swap(param1:b2Bound) : void
      {
         var _loc2_:uint = value;
         var _loc3_:b2Proxy = proxy;
         var _loc4_:uint = stabbingCount;
         value = param1.value;
         proxy = param1.proxy;
         stabbingCount = param1.stabbingCount;
         param1.value = _loc2_;
         param1.proxy = _loc3_;
         param1.stabbingCount = _loc4_;
      }
   }
}

