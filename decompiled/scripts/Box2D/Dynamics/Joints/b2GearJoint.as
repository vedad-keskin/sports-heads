package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2Settings;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2TimeStep;
   
   use namespace b2internal;
   
   public class b2GearJoint extends b2Joint
   {
      
      private var m_ground1:b2Body;
      
      private var m_ground2:b2Body;
      
      private var m_revolute1:b2RevoluteJoint;
      
      private var m_prismatic1:b2PrismaticJoint;
      
      private var m_revolute2:b2RevoluteJoint;
      
      private var m_prismatic2:b2PrismaticJoint;
      
      private var m_groundAnchor1:b2Vec2;
      
      private var m_groundAnchor2:b2Vec2;
      
      private var m_localAnchor1:b2Vec2;
      
      private var m_localAnchor2:b2Vec2;
      
      private var m_J:b2Jacobian;
      
      private var m_constant:Number;
      
      private var m_ratio:Number;
      
      private var m_mass:Number;
      
      private var m_impulse:Number;
      
      public function b2GearJoint(param1:b2GearJointDef)
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         m_groundAnchor1 = new b2Vec2();
         m_groundAnchor2 = new b2Vec2();
         m_localAnchor1 = new b2Vec2();
         m_localAnchor2 = new b2Vec2();
         m_J = new b2Jacobian();
         super(param1);
         var _loc2_:int = param1.joint1.m_type;
         var _loc3_:int = param1.joint2.m_type;
         m_revolute1 = null;
         m_prismatic1 = null;
         m_revolute2 = null;
         m_prismatic2 = null;
         m_ground1 = param1.joint1.m_body1;
         b2internal::m_body1 = param1.joint1.m_body2;
         if(_loc2_ == b2Joint.e_revoluteJoint)
         {
            m_revolute1 = param1.joint1 as b2RevoluteJoint;
            m_groundAnchor1.SetV(m_revolute1.m_localAnchor1);
            m_localAnchor1.SetV(m_revolute1.m_localAnchor2);
            _loc4_ = m_revolute1.GetJointAngle();
         }
         else
         {
            m_prismatic1 = param1.joint1 as b2PrismaticJoint;
            m_groundAnchor1.SetV(m_prismatic1.m_localAnchor1);
            m_localAnchor1.SetV(m_prismatic1.m_localAnchor2);
            _loc4_ = m_prismatic1.GetJointTranslation();
         }
         m_ground2 = param1.joint2.m_body1;
         b2internal::m_body2 = param1.joint2.m_body2;
         if(_loc3_ == b2Joint.e_revoluteJoint)
         {
            m_revolute2 = param1.joint2 as b2RevoluteJoint;
            m_groundAnchor2.SetV(m_revolute2.m_localAnchor1);
            m_localAnchor2.SetV(m_revolute2.m_localAnchor2);
            _loc5_ = m_revolute2.GetJointAngle();
         }
         else
         {
            m_prismatic2 = param1.joint2 as b2PrismaticJoint;
            m_groundAnchor2.SetV(m_prismatic2.m_localAnchor1);
            m_localAnchor2.SetV(m_prismatic2.m_localAnchor2);
            _loc5_ = m_prismatic2.GetJointTranslation();
         }
         m_ratio = param1.ratio;
         m_constant = _loc4_ + m_ratio * _loc5_;
         m_impulse = 0;
      }
      
      override public function GetAnchor1() : b2Vec2
      {
         return m_body1.GetWorldPoint(m_localAnchor1);
      }
      
      override public function GetAnchor2() : b2Vec2
      {
         return m_body2.GetWorldPoint(m_localAnchor2);
      }
      
      override public function GetReactionForce(param1:Number) : b2Vec2
      {
         return new b2Vec2(param1 * m_impulse * m_J.linear2.x,param1 * m_impulse * m_J.linear2.y);
      }
      
      override public function GetReactionTorque(param1:Number) : Number
      {
         var _loc2_:b2Mat22 = m_body2.m_xf.R;
         var _loc3_:Number = m_localAnchor1.x - m_body2.m_sweep.localCenter.x;
         var _loc4_:Number = m_localAnchor1.y - m_body2.m_sweep.localCenter.y;
         var _loc5_:Number = _loc2_.col1.x * _loc3_ + _loc2_.col2.x * _loc4_;
         _loc4_ = _loc2_.col1.y * _loc3_ + _loc2_.col2.y * _loc4_;
         _loc3_ = _loc5_;
         var _loc6_:Number = m_impulse * m_J.linear2.x;
         var _loc7_:Number = m_impulse * m_J.linear2.y;
         return param1 * (m_impulse * m_J.angular2 - _loc3_ * _loc7_ + _loc4_ * _loc6_);
      }
      
      public function GetRatio() : Number
      {
         return m_ratio;
      }
      
      override b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:b2Mat22 = null;
         var _loc11_:b2Vec2 = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc2_:b2Body = m_ground1;
         var _loc3_:b2Body = m_ground2;
         var _loc4_:b2Body = m_body1;
         var _loc5_:b2Body = m_body2;
         var _loc14_:Number = 0;
         m_J.SetZero();
         if(m_revolute1)
         {
            m_J.angular1 = -1;
            _loc14_ += _loc4_.m_invI;
         }
         else
         {
            _loc10_ = _loc2_.m_xf.R;
            _loc11_ = m_prismatic1.m_localXAxis1;
            _loc6_ = _loc10_.col1.x * _loc11_.x + _loc10_.col2.x * _loc11_.y;
            _loc7_ = _loc10_.col1.y * _loc11_.x + _loc10_.col2.y * _loc11_.y;
            _loc10_ = _loc4_.m_xf.R;
            _loc8_ = m_localAnchor1.x - _loc4_.m_sweep.localCenter.x;
            _loc9_ = m_localAnchor1.y - _loc4_.m_sweep.localCenter.y;
            _loc13_ = _loc10_.col1.x * _loc8_ + _loc10_.col2.x * _loc9_;
            _loc9_ = _loc10_.col1.y * _loc8_ + _loc10_.col2.y * _loc9_;
            _loc8_ = _loc13_;
            _loc12_ = _loc8_ * _loc7_ - _loc9_ * _loc6_;
            m_J.linear1.Set(-_loc6_,-_loc7_);
            m_J.angular1 = -_loc12_;
            _loc14_ += _loc4_.m_invMass + _loc4_.m_invI * _loc12_ * _loc12_;
         }
         if(m_revolute2)
         {
            m_J.angular2 = -m_ratio;
            _loc14_ += m_ratio * m_ratio * _loc5_.m_invI;
         }
         else
         {
            _loc10_ = _loc3_.m_xf.R;
            _loc11_ = m_prismatic2.m_localXAxis1;
            _loc6_ = _loc10_.col1.x * _loc11_.x + _loc10_.col2.x * _loc11_.y;
            _loc7_ = _loc10_.col1.y * _loc11_.x + _loc10_.col2.y * _loc11_.y;
            _loc10_ = _loc5_.m_xf.R;
            _loc8_ = m_localAnchor2.x - _loc5_.m_sweep.localCenter.x;
            _loc9_ = m_localAnchor2.y - _loc5_.m_sweep.localCenter.y;
            _loc13_ = _loc10_.col1.x * _loc8_ + _loc10_.col2.x * _loc9_;
            _loc9_ = _loc10_.col1.y * _loc8_ + _loc10_.col2.y * _loc9_;
            _loc8_ = _loc13_;
            _loc12_ = _loc8_ * _loc7_ - _loc9_ * _loc6_;
            m_J.linear2.Set(-m_ratio * _loc6_,-m_ratio * _loc7_);
            m_J.angular2 = -m_ratio * _loc12_;
            _loc14_ += m_ratio * m_ratio * (_loc5_.m_invMass + _loc5_.m_invI * _loc12_ * _loc12_);
         }
         m_mass = 1 / _loc14_;
         if(param1.warmStarting)
         {
            _loc4_.m_linearVelocity.x += _loc4_.m_invMass * m_impulse * m_J.linear1.x;
            _loc4_.m_linearVelocity.y += _loc4_.m_invMass * m_impulse * m_J.linear1.y;
            _loc4_.m_angularVelocity += _loc4_.m_invI * m_impulse * m_J.angular1;
            _loc5_.m_linearVelocity.x += _loc5_.m_invMass * m_impulse * m_J.linear2.x;
            _loc5_.m_linearVelocity.y += _loc5_.m_invMass * m_impulse * m_J.linear2.y;
            _loc5_.m_angularVelocity += _loc5_.m_invI * m_impulse * m_J.angular2;
         }
         else
         {
            m_impulse = 0;
         }
      }
      
      override b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc2_:b2Body = m_body1;
         var _loc3_:b2Body = m_body2;
         var _loc4_:Number = m_J.Compute(_loc2_.m_linearVelocity,_loc2_.m_angularVelocity,_loc3_.m_linearVelocity,_loc3_.m_angularVelocity);
         var _loc5_:Number = -m_mass * _loc4_;
         m_impulse += _loc5_;
         _loc2_.m_linearVelocity.x += _loc2_.m_invMass * _loc5_ * m_J.linear1.x;
         _loc2_.m_linearVelocity.y += _loc2_.m_invMass * _loc5_ * m_J.linear1.y;
         _loc2_.m_angularVelocity += _loc2_.m_invI * _loc5_ * m_J.angular1;
         _loc3_.m_linearVelocity.x += _loc3_.m_invMass * _loc5_ * m_J.linear2.x;
         _loc3_.m_linearVelocity.y += _loc3_.m_invMass * _loc5_ * m_J.linear2.y;
         _loc3_.m_angularVelocity += _loc3_.m_invI * _loc5_ * m_J.angular2;
      }
      
      override b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc2_:Number = 0;
         var _loc3_:b2Body = m_body1;
         var _loc4_:b2Body = m_body2;
         if(m_revolute1)
         {
            _loc5_ = m_revolute1.GetJointAngle();
         }
         else
         {
            _loc5_ = m_prismatic1.GetJointTranslation();
         }
         if(m_revolute2)
         {
            _loc6_ = m_revolute2.GetJointAngle();
         }
         else
         {
            _loc6_ = m_prismatic2.GetJointTranslation();
         }
         var _loc7_:Number = m_constant - (_loc5_ + m_ratio * _loc6_);
         var _loc8_:Number = -m_mass * _loc7_;
         _loc3_.m_sweep.c.x += _loc3_.m_invMass * _loc8_ * m_J.linear1.x;
         _loc3_.m_sweep.c.y += _loc3_.m_invMass * _loc8_ * m_J.linear1.y;
         _loc3_.m_sweep.a += _loc3_.m_invI * _loc8_ * m_J.angular1;
         _loc4_.m_sweep.c.x += _loc4_.m_invMass * _loc8_ * m_J.linear2.x;
         _loc4_.m_sweep.c.y += _loc4_.m_invMass * _loc8_ * m_J.linear2.y;
         _loc4_.m_sweep.a += _loc4_.m_invI * _loc8_ * m_J.angular2;
         _loc3_.SynchronizeTransform();
         _loc4_.SynchronizeTransform();
         return _loc2_ < b2Settings.b2_linearSlop;
      }
   }
}

