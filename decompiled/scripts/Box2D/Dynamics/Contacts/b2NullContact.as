package Box2D.Dynamics.Contacts
{
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2ContactListener;
   
   use namespace b2internal;
   
   public class b2NullContact extends b2Contact
   {
      
      public function b2NullContact()
      {
         super();
      }
      
      override b2internal function Evaluate(param1:b2ContactListener) : void
      {
      }
      
      override public function GetManifolds() : Array
      {
         return null;
      }
   }
}

