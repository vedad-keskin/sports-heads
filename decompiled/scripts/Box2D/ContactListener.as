package Box2D
{
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Contacts.*;
   import Box2D.Dynamics.Joints.*;
   import flash.display.MovieClip;
   
   public class ContactListener extends b2ContactListener
   {
      
      public var Root:MovieClip;
      
      public function ContactListener(param1:MovieClip)
      {
         super();
         Root = param1;
      }
      
      override public function Add(param1:b2ContactPoint) : void
      {
         var _loc2_:b2Body = param1.shape1.GetBody();
         var _loc3_:b2Body = param1.shape2.GetBody();
         Root.CollisionHappened(param1,_loc2_,_loc3_);
      }
      
      override public function Persist(param1:b2ContactPoint) : void
      {
      }
      
      override public function Remove(param1:b2ContactPoint) : void
      {
      }
      
      override public function Result(param1:b2ContactResult) : void
      {
      }
   }
}

