package Box2D.Collision
{
   import Box2D.Common.b2Settings;
   
   public class b2Pair
   {
      
      public static var b2_nullProxy:uint = b2Settings.USHRT_MAX;
      
      public static var e_pairBuffered:uint = 1;
      
      public static var e_pairRemoved:uint = 2;
      
      public static var e_pairFinal:uint = 4;
      
      public var userData:* = null;
      
      public var proxy1:b2Proxy;
      
      public var proxy2:b2Proxy;
      
      public var next:b2Pair;
      
      public var status:uint;
      
      public function b2Pair()
      {
         super();
      }
      
      public function SetBuffered() : void
      {
         status |= e_pairBuffered;
      }
      
      public function ClearBuffered() : void
      {
         status &= ~e_pairBuffered;
      }
      
      public function IsBuffered() : Boolean
      {
         return (status & e_pairBuffered) == e_pairBuffered;
      }
      
      public function SetRemoved() : void
      {
         status |= e_pairRemoved;
      }
      
      public function ClearRemoved() : void
      {
         status &= ~e_pairRemoved;
      }
      
      public function IsRemoved() : Boolean
      {
         return (status & e_pairRemoved) == e_pairRemoved;
      }
      
      public function SetFinal() : void
      {
         status |= e_pairFinal;
      }
      
      public function IsFinal() : Boolean
      {
         return (status & e_pairFinal) == e_pairFinal;
      }
   }
}

