package Box2D.Collision
{
   import flash.utils.Dictionary;
   
   public class b2Proxy
   {
      
      public var lowerBounds:Array = [uint(0),uint(0)];
      
      public var upperBounds:Array = [uint(0),uint(0)];
      
      public var overlapCount:uint;
      
      public var timeStamp:uint;
      
      public var pairs:Dictionary = new Dictionary();
      
      public var next:b2Proxy;
      
      public var userData:* = null;
      
      public function b2Proxy()
      {
         super();
      }
      
      public function IsValid() : Boolean
      {
         return overlapCount != b2BroadPhase.b2_invalid;
      }
   }
}

