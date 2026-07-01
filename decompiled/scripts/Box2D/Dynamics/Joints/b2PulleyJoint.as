package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2Settings;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2TimeStep;
   
   use namespace b2internal;
   
   public class b2PulleyJoint extends b2Joint
   {
      
      b2internal static const b2_minPulleyLength:Number = 2;
      
      private var m_ground:b2Body;
      
      private var m_groundAnchor1:b2Vec2;
      
      private var m_groundAnchor2:b2Vec2;
      
      private var m_localAnchor1:b2Vec2;
      
      private var m_localAnchor2:b2Vec2;
      
      private var m_u1:b2Vec2;
      
      private var m_u2:b2Vec2;
      
      private var m_constant:Number;
      
      private var m_ratio:Number;
      
      private var m_maxLength1:Number;
      
      private var m_maxLength2:Number;
      
      private var m_pulleyMass:Number;
      
      private var m_limitMass1:Number;
      
      private var m_limitMass2:Number;
      
      private var m_impulse:Number;
      
      private var m_limitImpulse1:Number;
      
      private var m_limitImpulse2:Number;
      
      private var m_state:int;
      
      private var m_limitState1:int;
      
      private var m_limitState2:int;
      
      public function b2PulleyJoint(param1:b2PulleyJointDef)
      {
         var _loc2_:b2Mat22 = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         m_groundAnchor1 = new b2Vec2();
         m_groundAnchor2 = new b2Vec2();
         m_localAnchor1 = new b2Vec2();
         m_localAnchor2 = new b2Vec2();
         m_u1 = new b2Vec2();
         m_u2 = new b2Vec2();
         super(param1);
         m_ground = b2internal::m_body1.m_world.m_groundBody;
         m_groundAnchor1.x = param1.groundAnchor1.x - m_ground.m_xf.position.x;
         m_groundAnchor1.y = param1.groundAnchor1.y - m_ground.m_xf.position.y;
         m_groundAnchor2.x = param1.groundAnchor2.x - m_ground.m_xf.position.x;
         m_groundAnchor2.y = param1.groundAnchor2.y - m_ground.m_xf.position.y;
         m_localAnchor1.SetV(param1.localAnchor1);
         m_localAnchor2.SetV(param1.localAnchor2);
         m_ratio = param1.ratio;
         m_constant = param1.length1 + m_ratio * param1.length2;
         m_maxLength1 = b2Math.b2Min(param1.maxLength1,m_constant - m_ratio * b2internal::b2_minPulleyLength);
         m_maxLength2 = b2Math.b2Min(param1.maxLength2,(m_constant - b2internal::b2_minPulleyLength) / m_ratio);
         m_impulse = 0;
         m_limitImpulse1 = 0;
         m_limitImpulse2 = 0;
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
         return new b2Vec2(param1 * m_impulse * m_u2.x,param1 * m_impulse * m_u2.y);
      }
      
      override public function GetReactionTorque(param1:Number) : Number
      {
         return 0;
      }
      
      public function GetGroundAnchor1() : b2Vec2
      {
         var _loc1_:b2Vec2 = m_ground.m_xf.position.Copy();
         _loc1_.Add(m_groundAnchor1);
         return _loc1_;
      }
      
      public function GetGroundAnchor2() : b2Vec2
      {
         var _loc1_:b2Vec2 = m_ground.m_xf.position.Copy();
         _loc1_.Add(m_groundAnchor2);
         return _loc1_;
      }
      
      public function GetLength1() : Number
      {
         var _loc1_:b2Vec2 = m_body1.GetWorldPoint(m_localAnchor1);
         var _loc2_:Number = m_ground.m_xf.position.x + m_groundAnchor1.x;
         var _loc3_:Number = m_ground.m_xf.position.y + m_groundAnchor1.y;
         var _loc4_:Number = _loc1_.x - _loc2_;
         var _loc5_:Number = _loc1_.y - _loc3_;
         return Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_);
      }
      
      public function GetLength2() : Number
      {
         var _loc1_:b2Vec2 = m_body2.GetWorldPoint(m_localAnchor2);
         var _loc2_:Number = m_ground.m_xf.position.x + m_groundAnchor2.x;
         var _loc3_:Number = m_ground.m_xf.position.y + m_groundAnchor2.y;
         var _loc4_:Number = _loc1_.x - _loc2_;
         var _loc5_:Number = _loc1_.y - _loc3_;
         return Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_);
      }
      
      public function GetRatio() : Number
      {
         return m_ratio;
      }
      
      override b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc2_:b2Body = null;
         var _loc4_:b2Mat22 = null;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         _loc2_ = m_body1;
         var _loc3_:b2Body = m_body2;
         _loc4_ = _loc2_.m_xf.R;
         var _loc5_:Number = m_localAnchor1.x - _loc2_.m_sweep.localCenter.x;
         var _loc6_:Number = m_localAnchor1.y - _loc2_.m_sweep.localCenter.y;
         var _loc7_:Number = _loc4_.col1.x * _loc5_ + _loc4_.col2.x * _loc6_;
         _loc6_ = _loc4_.col1.y * _loc5_ + _loc4_.col2.y * _loc6_;
         _loc5_ = _loc7_;
         _loc4_ = _loc3_.m_xf.R;
         var _loc8_:Number = m_localAnchor2.x - _loc3_.m_sweep.localCenter.x;
         var _loc9_:Number = m_localAnchor2.y - _loc3_.m_sweep.localCenter.y;
         _loc7_ = _loc4_.col1.x * _loc8_ + _loc4_.col2.x * _loc9_;
         _loc9_ = _loc4_.col1.y * _loc8_ + _loc4_.col2.y * _loc9_;
         _loc8_ = _loc7_;
         var _loc10_:Number = _loc2_.m_sweep.c.x + _loc5_;
         var _loc11_:Number = _loc2_.m_sweep.c.y + _loc6_;
         var _loc12_:Number = _loc3_.m_sweep.c.x + _loc8_;
         var _loc13_:Number = _loc3_.m_sweep.c.y + _loc9_;
         var _loc14_:Number = m_ground.m_xf.position.x + m_groundAnchor1.x;
         var _loc15_:Number = m_ground.m_xf.position.y + m_groundAnchor1.y;
         var _loc16_:Number = m_ground.m_xf.position.x + m_groundAnchor2.x;
         var _loc17_:Number = m_ground.m_xf.position.y + m_groundAnchor2.y;
         m_u1.Set(_loc10_ - _loc14_,_loc11_ - _loc15_);
         m_u2.Set(_loc12_ - _loc16_,_loc13_ - _loc17_);
         var _loc18_:Number = m_u1.Length();
         var _loc19_:Number = m_u2.Length();
         if(_loc18_ > b2Settings.b2_linearSlop)
         {
            m_u1.Multiply(1 / _loc18_);
         }
         else
         {
            m_u1.SetZero();
         }
         if(_loc19_ > b2Settings.b2_linearSlop)
         {
            m_u2.Multiply(1 / _loc19_);
         }
         else
         {
            m_u2.SetZero();
         }
         var _loc20_:Number = m_constant - _loc18_ - m_ratio * _loc19_;
         if(_loc20_ > 0)
         {
            m_state = e_inactiveLimit;
            m_impulse = 0;
         }
         else
         {
            m_state = e_atUpperLimit;
         }
         if(_loc18_ < m_maxLength1)
         {
            m_limitState1 = e_inactiveLimit;
            m_limitImpulse1 = 0;
         }
         else
         {
            m_limitState1 = e_atUpperLimit;
         }
         if(_loc19_ < m_maxLength2)
         {
            m_limitState2 = e_inactiveLimit;
            m_limitImpulse2 = 0;
         }
         else
         {
            m_limitState2 = e_atUpperLimit;
         }
         var _loc21_:Number = _loc5_ * m_u1.y - _loc6_ * m_u1.x;
         var _loc22_:Number = _loc8_ * m_u2.y - _loc9_ * m_u2.x;
         m_limitMass1 = _loc2_.m_invMass + _loc2_.m_invI * _loc21_ * _loc21_;
         m_limitMass2 = _loc3_.m_invMass + _loc3_.m_invI * _loc22_ * _loc22_;
         m_pulleyMass = m_limitMass1 + m_ratio * m_ratio * m_limitMass2;
         m_limitMass1 = 1 / m_limitMass1;
         m_limitMass2 = 1 / m_limitMass2;
         m_pulleyMass = 1 / m_pulleyMass;
         if(param1.warmStarting)
         {
            m_impulse *= param1.dtRatio;
            m_limitImpulse1 *= param1.dtRatio;
            m_limitImpulse2 *= param1.dtRatio;
            _loc23_ = (-m_impulse - m_limitImpulse1) * m_u1.x;
            _loc24_ = (-m_impulse - m_limitImpulse1) * m_u1.y;
            _loc25_ = (-m_ratio * m_impulse - m_limitImpulse2) * m_u2.x;
            _loc26_ = (-m_ratio * m_impulse - m_limitImpulse2) * m_u2.y;
            _loc2_.m_linearVelocity.x += _loc2_.m_invMass * _loc23_;
            _loc2_.m_linearVelocity.y += _loc2_.m_invMass * _loc24_;
            _loc2_.m_angularVelocity += _loc2_.m_invI * (_loc5_ * _loc24_ - _loc6_ * _loc23_);
            _loc3_.m_linearVelocity.x += _loc3_.m_invMass * _loc25_;
            _loc3_.m_linearVelocity.y += _loc3_.m_invMass * _loc26_;
            _loc3_.m_angularVelocity += _loc3_.m_invI * (_loc8_ * _loc26_ - _loc9_ * _loc25_);
         }
         else
         {
            m_impulse = 0;
            m_limitImpulse1 = 0;
            m_limitImpulse2 = 0;
         }
      }
      
      override b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc4_:b2Mat22 = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc2_:b2Body = m_body1;
         var _loc3_:b2Body = m_body2;
         _loc4_ = _loc2_.m_xf.R;
         var _loc5_:Number = m_localAnchor1.x - _loc2_.m_sweep.localCenter.x;
         var _loc6_:Number = m_localAnchor1.y - _loc2_.m_sweep.localCenter.y;
         var _loc7_:Number = _loc4_.col1.x * _loc5_ + _loc4_.col2.x * _loc6_;
         _loc6_ = _loc4_.col1.y * _loc5_ + _loc4_.col2.y * _loc6_;
         _loc5_ = _loc7_;
         _loc4_ = _loc3_.m_xf.R;
         var _loc8_:Number = m_localAnchor2.x - _loc3_.m_sweep.localCenter.x;
         var _loc9_:Number = m_localAnchor2.y - _loc3_.m_sweep.localCenter.y;
         _loc7_ = _loc4_.col1.x * _loc8_ + _loc4_.col2.x * _loc9_;
         _loc9_ = _loc4_.col1.y * _loc8_ + _loc4_.col2.y * _loc9_;
         _loc8_ = _loc7_;
         if(m_state == e_atUpperLimit)
         {
            _loc10_ = _loc2_.m_linearVelocity.x + -_loc2_.m_angularVelocity * _loc6_;
            _loc11_ = _loc2_.m_linearVelocity.y + _loc2_.m_angularVelocity * _loc5_;
            _loc12_ = _loc3_.m_linearVelocity.x + -_loc3_.m_angularVelocity * _loc9_;
            _loc13_ = _loc3_.m_linearVelocity.y + _loc3_.m_angularVelocity * _loc8_;
            _loc18_ = -(m_u1.x * _loc10_ + m_u1.y * _loc11_) - m_ratio * (m_u2.x * _loc12_ + m_u2.y * _loc13_);
            _loc19_ = m_pulleyMass * -_loc18_;
            _loc20_ = m_impulse;
            m_impulse = b2Math.b2Max(0,m_impulse + _loc19_);
            _loc19_ = m_impulse - _loc20_;
            _loc14_ = -_loc19_ * m_u1.x;
            _loc15_ = -_loc19_ * m_u1.y;
            _loc16_ = -m_ratio * _loc19_ * m_u2.x;
            _loc17_ = -m_ratio * _loc19_ * m_u2.y;
            _loc2_.m_linearVelocity.x += _loc2_.m_invMass * _loc14_;
            _loc2_.m_linearVelocity.y += _loc2_.m_invMass * _loc15_;
            _loc2_.m_angularVelocity += _loc2_.m_invI * (_loc5_ * _loc15_ - _loc6_ * _loc14_);
            _loc3_.m_linearVelocity.x += _loc3_.m_invMass * _loc16_;
            _loc3_.m_linearVelocity.y += _loc3_.m_invMass * _loc17_;
            _loc3_.m_angularVelocity += _loc3_.m_invI * (_loc8_ * _loc17_ - _loc9_ * _loc16_);
         }
         if(m_limitState1 == e_atUpperLimit)
         {
            _loc10_ = _loc2_.m_linearVelocity.x + -_loc2_.m_angularVelocity * _loc6_;
            _loc11_ = _loc2_.m_linearVelocity.y + _loc2_.m_angularVelocity * _loc5_;
            _loc18_ = -(m_u1.x * _loc10_ + m_u1.y * _loc11_);
            _loc19_ = -m_limitMass1 * _loc18_;
            _loc20_ = m_limitImpulse1;
            m_limitImpulse1 = b2Math.b2Max(0,m_limitImpulse1 + _loc19_);
            _loc19_ = m_limitImpulse1 - _loc20_;
            _loc14_ = -_loc19_ * m_u1.x;
            _loc15_ = -_loc19_ * m_u1.y;
            _loc2_.m_linearVelocity.x += _loc2_.m_invMass * _loc14_;
            _loc2_.m_linearVelocity.y += _loc2_.m_invMass * _loc15_;
            _loc2_.m_angularVelocity += _loc2_.m_invI * (_loc5_ * _loc15_ - _loc6_ * _loc14_);
         }
         if(m_limitState2 == e_atUpperLimit)
         {
            _loc12_ = _loc3_.m_linearVelocity.x + -_loc3_.m_angularVelocity * _loc9_;
            _loc13_ = _loc3_.m_linearVelocity.y + _loc3_.m_angularVelocity * _loc8_;
            _loc18_ = -(m_u2.x * _loc12_ + m_u2.y * _loc13_);
            _loc19_ = -m_limitMass2 * _loc18_;
            _loc20_ = m_limitImpulse2;
            m_limitImpulse2 = b2Math.b2Max(0,m_limitImpulse2 + _loc19_);
            _loc19_ = m_limitImpulse2 - _loc20_;
            _loc16_ = -_loc19_ * m_u2.x;
            _loc17_ = -_loc19_ * m_u2.y;
            _loc3_.m_linearVelocity.x += _loc3_.m_invMass * _loc16_;
            _loc3_.m_linearVelocity.y += _loc3_.m_invMass * _loc17_;
            _loc3_.m_angularVelocity += _loc3_.m_invI * (_loc8_ * _loc17_ - _loc9_ * _loc16_);
         }
      }
      
      override b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         var _loc4_:b2Mat22 = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc2_:b2Body = m_body1;
         var _loc3_:b2Body = m_body2;
         var _loc5_:Number = m_ground.m_xf.position.x + m_groundAnchor1.x;
         var _loc6_:Number = m_ground.m_xf.position.y + m_groundAnchor1.y;
         var _loc7_:Number = m_ground.m_xf.position.x + m_groundAnchor2.x;
         var _loc8_:Number = m_ground.m_xf.position.y + m_groundAnchor2.y;
         var _loc24_:Number = 0;
         if(m_state == e_atUpperLimit)
         {
            _loc4_ = _loc2_.m_xf.R;
            _loc9_ = m_localAnchor1.x - _loc2_.m_sweep.localCenter.x;
            _loc10_ = m_localAnchor1.y - _loc2_.m_sweep.localCenter.y;
            _loc23_ = _loc4_.col1.x * _loc9_ + _loc4_.col2.x * _loc10_;
            _loc10_ = _loc4_.col1.y * _loc9_ + _loc4_.col2.y * _loc10_;
            _loc9_ = _loc23_;
            _loc4_ = _loc3_.m_xf.R;
            _loc11_ = m_localAnchor2.x - _loc3_.m_sweep.localCenter.x;
            _loc12_ = m_localAnchor2.y - _loc3_.m_sweep.localCenter.y;
            _loc23_ = _loc4_.col1.x * _loc11_ + _loc4_.col2.x * _loc12_;
            _loc12_ = _loc4_.col1.y * _loc11_ + _loc4_.col2.y * _loc12_;
            _loc11_ = _loc23_;
            _loc13_ = _loc2_.m_sweep.c.x + _loc9_;
            _loc14_ = _loc2_.m_sweep.c.y + _loc10_;
            _loc15_ = _loc3_.m_sweep.c.x + _loc11_;
            _loc16_ = _loc3_.m_sweep.c.y + _loc12_;
            m_u1.Set(_loc13_ - _loc5_,_loc14_ - _loc6_);
            m_u2.Set(_loc15_ - _loc7_,_loc16_ - _loc8_);
            _loc17_ = m_u1.Length();
            _loc18_ = m_u2.Length();
            if(_loc17_ > b2Settings.b2_linearSlop)
            {
               m_u1.Multiply(1 / _loc17_);
            }
            else
            {
               m_u1.SetZero();
            }
            if(_loc18_ > b2Settings.b2_linearSlop)
            {
               m_u2.Multiply(1 / _loc18_);
            }
            else
            {
               m_u2.SetZero();
            }
            _loc19_ = m_constant - _loc17_ - m_ratio * _loc18_;
            _loc24_ = b2Math.b2Max(_loc24_,-_loc19_);
            _loc19_ = b2Math.b2Clamp(_loc19_ + b2Settings.b2_linearSlop,-b2Settings.b2_maxLinearCorrection,0);
            _loc20_ = -m_pulleyMass * _loc19_;
            _loc13_ = -_loc20_ * m_u1.x;
            _loc14_ = -_loc20_ * m_u1.y;
            _loc15_ = -m_ratio * _loc20_ * m_u2.x;
            _loc16_ = -m_ratio * _loc20_ * m_u2.y;
            _loc2_.m_sweep.c.x += _loc2_.m_invMass * _loc13_;
            _loc2_.m_sweep.c.y += _loc2_.m_invMass * _loc14_;
            _loc2_.m_sweep.a += _loc2_.m_invI * (_loc9_ * _loc14_ - _loc10_ * _loc13_);
            _loc3_.m_sweep.c.x += _loc3_.m_invMass * _loc15_;
            _loc3_.m_sweep.c.y += _loc3_.m_invMass * _loc16_;
            _loc3_.m_sweep.a += _loc3_.m_invI * (_loc11_ * _loc16_ - _loc12_ * _loc15_);
            _loc2_.SynchronizeTransform();
            _loc3_.SynchronizeTransform();
         }
         if(m_limitState1 == e_atUpperLimit)
         {
            _loc4_ = _loc2_.m_xf.R;
            _loc9_ = m_localAnchor1.x - _loc2_.m_sweep.localCenter.x;
            _loc10_ = m_localAnchor1.y - _loc2_.m_sweep.localCenter.y;
            _loc23_ = _loc4_.col1.x * _loc9_ + _loc4_.col2.x * _loc10_;
            _loc10_ = _loc4_.col1.y * _loc9_ + _loc4_.col2.y * _loc10_;
            _loc9_ = _loc23_;
            _loc13_ = _loc2_.m_sweep.c.x + _loc9_;
            _loc14_ = _loc2_.m_sweep.c.y + _loc10_;
            m_u1.Set(_loc13_ - _loc5_,_loc14_ - _loc6_);
            _loc17_ = m_u1.Length();
            if(_loc17_ > b2Settings.b2_linearSlop)
            {
               m_u1.x *= 1 / _loc17_;
               m_u1.y *= 1 / _loc17_;
            }
            else
            {
               m_u1.SetZero();
            }
            _loc19_ = m_maxLength1 - _loc17_;
            _loc24_ = b2Math.b2Max(_loc24_,-_loc19_);
            _loc19_ = b2Math.b2Clamp(_loc19_ + b2Settings.b2_linearSlop,-b2Settings.b2_maxLinearCorrection,0);
            _loc20_ = -m_limitMass1 * _loc19_;
            _loc13_ = -_loc20_ * m_u1.x;
            _loc14_ = -_loc20_ * m_u1.y;
            _loc2_.m_sweep.c.x += _loc2_.m_invMass * _loc13_;
            _loc2_.m_sweep.c.y += _loc2_.m_invMass * _loc14_;
            _loc2_.m_sweep.a += _loc2_.m_invI * (_loc9_ * _loc14_ - _loc10_ * _loc13_);
            _loc2_.SynchronizeTransform();
         }
         if(m_limitState2 == e_atUpperLimit)
         {
            _loc4_ = _loc3_.m_xf.R;
            _loc11_ = m_localAnchor2.x - _loc3_.m_sweep.localCenter.x;
            _loc12_ = m_localAnchor2.y - _loc3_.m_sweep.localCenter.y;
            _loc23_ = _loc4_.col1.x * _loc11_ + _loc4_.col2.x * _loc12_;
            _loc12_ = _loc4_.col1.y * _loc11_ + _loc4_.col2.y * _loc12_;
            _loc11_ = _loc23_;
            _loc15_ = _loc3_.m_sweep.c.x + _loc11_;
            _loc16_ = _loc3_.m_sweep.c.y + _loc12_;
            m_u2.Set(_loc15_ - _loc7_,_loc16_ - _loc8_);
            _loc18_ = m_u2.Length();
            if(_loc18_ > b2Settings.b2_linearSlop)
            {
               m_u2.x *= 1 / _loc18_;
               m_u2.y *= 1 / _loc18_;
            }
            else
            {
               m_u2.SetZero();
            }
            _loc19_ = m_maxLength2 - _loc18_;
            _loc24_ = b2Math.b2Max(_loc24_,-_loc19_);
            _loc19_ = b2Math.b2Clamp(_loc19_ + b2Settings.b2_linearSlop,-b2Settings.b2_maxLinearCorrection,0);
            _loc20_ = -m_limitMass2 * _loc19_;
            _loc15_ = -_loc20_ * m_u2.x;
            _loc16_ = -_loc20_ * m_u2.y;
            _loc3_.m_sweep.c.x += _loc3_.m_invMass * _loc15_;
            _loc3_.m_sweep.c.y += _loc3_.m_invMass * _loc16_;
            _loc3_.m_sweep.a += _loc3_.m_invI * (_loc11_ * _loc16_ - _loc12_ * _loc15_);
            _loc3_.SynchronizeTransform();
         }
         return _loc24_ < b2Settings.b2_linearSlop;
      }
   }
}

