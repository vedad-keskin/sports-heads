package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.Math.b2XForm;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2TimeStep;
   
   use namespace b2internal;
   
   public class b2Joint
   {
      
      b2internal static const e_unknownJoint:int = 0;
      
      b2internal static const e_revoluteJoint:int = 1;
      
      b2internal static const e_prismaticJoint:int = 2;
      
      b2internal static const e_distanceJoint:int = 3;
      
      b2internal static const e_pulleyJoint:int = 4;
      
      b2internal static const e_mouseJoint:int = 5;
      
      b2internal static const e_gearJoint:int = 6;
      
      b2internal static const e_lineJoint:int = 7;
      
      b2internal static const e_inactiveLimit:int = 0;
      
      b2internal static const e_atLowerLimit:int = 1;
      
      b2internal static const e_atUpperLimit:int = 2;
      
      b2internal static const e_equalLimits:int = 3;
      
      b2internal var m_type:int;
      
      b2internal var m_prev:b2Joint;
      
      b2internal var m_next:b2Joint;
      
      b2internal var m_node1:b2JointEdge = new b2JointEdge();
      
      b2internal var m_node2:b2JointEdge = new b2JointEdge();
      
      b2internal var m_body1:b2Body;
      
      b2internal var m_body2:b2Body;
      
      b2internal var m_islandFlag:Boolean;
      
      b2internal var m_collideConnected:Boolean;
      
      private var m_userData:*;
      
      b2internal var m_localCenter1:b2Vec2 = new b2Vec2();
      
      b2internal var m_localCenter2:b2Vec2 = new b2Vec2();
      
      b2internal var m_invMass1:Number;
      
      b2internal var m_invMass2:Number;
      
      b2internal var m_invI1:Number;
      
      b2internal var m_invI2:Number;
      
      public function b2Joint(param1:b2JointDef)
      {
         super();
         b2internal::m_type = param1.type;
         b2internal::m_prev = null;
         b2internal::m_next = null;
         b2internal::m_body1 = param1.body1;
         b2internal::m_body2 = param1.body2;
         b2internal::m_collideConnected = param1.collideConnected;
         b2internal::m_islandFlag = false;
         m_userData = param1.userData;
      }
      
      b2internal static function Create(param1:b2JointDef, param2:*) : b2Joint
      {
         var _loc3_:b2Joint = null;
         switch(param1.type)
         {
            case e_distanceJoint:
               _loc3_ = new b2DistanceJoint(param1 as b2DistanceJointDef);
               break;
            case e_mouseJoint:
               _loc3_ = new b2MouseJoint(param1 as b2MouseJointDef);
               break;
            case e_prismaticJoint:
               _loc3_ = new b2PrismaticJoint(param1 as b2PrismaticJointDef);
               break;
            case e_revoluteJoint:
               _loc3_ = new b2RevoluteJoint(param1 as b2RevoluteJointDef);
               break;
            case e_pulleyJoint:
               _loc3_ = new b2PulleyJoint(param1 as b2PulleyJointDef);
               break;
            case e_gearJoint:
               _loc3_ = new b2GearJoint(param1 as b2GearJointDef);
               break;
            case e_lineJoint:
               _loc3_ = new b2LineJoint(param1 as b2LineJointDef);
         }
         return _loc3_;
      }
      
      b2internal static function Destroy(param1:b2Joint, param2:*) : void
      {
      }
      
      public function GetType() : int
      {
         return m_type;
      }
      
      public function GetAnchor1() : b2Vec2
      {
         return null;
      }
      
      public function GetAnchor2() : b2Vec2
      {
         return null;
      }
      
      public function GetReactionForce(param1:Number) : b2Vec2
      {
         return null;
      }
      
      public function GetReactionTorque(param1:Number) : Number
      {
         return 0;
      }
      
      public function GetBody1() : b2Body
      {
         return m_body1;
      }
      
      public function GetBody2() : b2Body
      {
         return m_body2;
      }
      
      public function GetNext() : b2Joint
      {
         return m_next;
      }
      
      public function GetUserData() : *
      {
         return m_userData;
      }
      
      public function SetUserData(param1:*) : void
      {
         m_userData = param1;
      }
      
      b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
      }
      
      b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
      }
      
      b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         return false;
      }
      
      b2internal function ComputeXForm(param1:b2XForm, param2:b2Vec2, param3:b2Vec2, param4:Number) : void
      {
         param1.R.Set(param4);
         param1.position.SetV(b2Math.SubtractVV(param2,b2Math.b2MulMV(param1.R,param3)));
      }
   }
}

