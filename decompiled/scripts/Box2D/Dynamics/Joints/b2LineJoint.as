package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.Math.b2XForm;
   import Box2D.Common.b2Settings;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2TimeStep;
   
   use namespace b2internal;
   
   public class b2LineJoint extends b2Joint
   {
      
      b2internal var m_localAnchor1:b2Vec2;
      
      b2internal var m_localAnchor2:b2Vec2;
      
      b2internal var m_localXAxis1:b2Vec2;
      
      private var m_localYAxis1:b2Vec2;
      
      private var m_axis:b2Vec2;
      
      private var m_perp:b2Vec2;
      
      private var m_s1:Number;
      
      private var m_s2:Number;
      
      private var m_a1:Number;
      
      private var m_a2:Number;
      
      private var m_K:b2Mat22;
      
      private var m_impulse:b2Vec2;
      
      private var m_motorMass:Number;
      
      private var m_motorImpulse:Number;
      
      private var m_lowerTranslation:Number;
      
      private var m_upperTranslation:Number;
      
      private var m_maxMotorForce:Number;
      
      private var m_motorSpeed:Number;
      
      private var m_enableLimit:Boolean;
      
      private var m_enableMotor:Boolean;
      
      private var m_limitState:int;
      
      public function b2LineJoint(param1:b2LineJointDef)
      {
         var _loc2_:b2Mat22 = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         b2internal::m_localAnchor1 = new b2Vec2();
         b2internal::m_localAnchor2 = new b2Vec2();
         b2internal::m_localXAxis1 = new b2Vec2();
         m_localYAxis1 = new b2Vec2();
         m_axis = new b2Vec2();
         m_perp = new b2Vec2();
         m_K = new b2Mat22();
         m_impulse = new b2Vec2();
         super(param1);
         b2internal::m_localAnchor1.SetV(param1.localAnchor1);
         b2internal::m_localAnchor2.SetV(param1.localAnchor2);
         b2internal::m_localXAxis1.SetV(param1.localAxis1);
         m_localYAxis1.x = -b2internal::m_localXAxis1.y;
         m_localYAxis1.y = b2internal::m_localXAxis1.x;
         m_impulse.SetZero();
         m_motorMass = 0;
         m_motorImpulse = 0;
         m_lowerTranslation = param1.lowerTranslation;
         m_upperTranslation = param1.upperTranslation;
         m_maxMotorForce = param1.maxMotorForce;
         m_motorSpeed = param1.motorSpeed;
         m_enableLimit = param1.enableLimit;
         m_enableMotor = param1.enableMotor;
         m_limitState = b2internal::e_inactiveLimit;
         m_axis.SetZero();
         m_perp.SetZero();
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
         return new b2Vec2(param1 * (m_impulse.x * m_perp.x + (m_motorImpulse + m_impulse.y) * m_axis.x),param1 * (m_impulse.x * m_perp.y + (m_motorImpulse + m_impulse.y) * m_axis.y));
      }
      
      override public function GetReactionTorque(param1:Number) : Number
      {
         return param1 * m_impulse.y;
      }
      
      public function GetJointTranslation() : Number
      {
         var _loc3_:b2Mat22 = null;
         var _loc1_:b2Body = m_body1;
         var _loc2_:b2Body = m_body2;
         var _loc4_:b2Vec2 = _loc1_.GetWorldPoint(m_localAnchor1);
         var _loc5_:b2Vec2 = _loc2_.GetWorldPoint(m_localAnchor2);
         var _loc6_:Number = _loc5_.x - _loc4_.x;
         var _loc7_:Number = _loc5_.y - _loc4_.y;
         var _loc8_:b2Vec2 = _loc1_.GetWorldVector(m_localXAxis1);
         return _loc8_.x * _loc6_ + _loc8_.y * _loc7_;
      }
      
      public function GetJointSpeed() : Number
      {
         var _loc3_:b2Mat22 = null;
         var _loc1_:b2Body = m_body1;
         var _loc2_:b2Body = m_body2;
         _loc3_ = _loc1_.m_xf.R;
         var _loc4_:Number = m_localAnchor1.x - _loc1_.m_sweep.localCenter.x;
         var _loc5_:Number = m_localAnchor1.y - _loc1_.m_sweep.localCenter.y;
         var _loc6_:Number = _loc3_.col1.x * _loc4_ + _loc3_.col2.x * _loc5_;
         _loc5_ = _loc3_.col1.y * _loc4_ + _loc3_.col2.y * _loc5_;
         _loc4_ = _loc6_;
         _loc3_ = _loc2_.m_xf.R;
         var _loc7_:Number = m_localAnchor2.x - _loc2_.m_sweep.localCenter.x;
         var _loc8_:Number = m_localAnchor2.y - _loc2_.m_sweep.localCenter.y;
         _loc6_ = _loc3_.col1.x * _loc7_ + _loc3_.col2.x * _loc8_;
         _loc8_ = _loc3_.col1.y * _loc7_ + _loc3_.col2.y * _loc8_;
         _loc7_ = _loc6_;
         var _loc9_:Number = _loc1_.m_sweep.c.x + _loc4_;
         var _loc10_:Number = _loc1_.m_sweep.c.y + _loc5_;
         var _loc11_:Number = _loc2_.m_sweep.c.x + _loc7_;
         var _loc12_:Number = _loc2_.m_sweep.c.y + _loc8_;
         var _loc13_:Number = _loc11_ - _loc9_;
         var _loc14_:Number = _loc12_ - _loc10_;
         var _loc15_:b2Vec2 = _loc1_.GetWorldVector(m_localXAxis1);
         var _loc16_:b2Vec2 = _loc1_.m_linearVelocity;
         var _loc17_:b2Vec2 = _loc2_.m_linearVelocity;
         var _loc18_:Number = _loc1_.m_angularVelocity;
         var _loc19_:Number = _loc2_.m_angularVelocity;
         return _loc13_ * (-_loc18_ * _loc15_.y) + _loc14_ * (_loc18_ * _loc15_.x) + (_loc15_.x * (_loc17_.x + -_loc19_ * _loc8_ - _loc16_.x - -_loc18_ * _loc5_) + _loc15_.y * (_loc17_.y + _loc19_ * _loc7_ - _loc16_.y - _loc18_ * _loc4_));
      }
      
      public function IsLimitEnabled() : Boolean
      {
         return m_enableLimit;
      }
      
      public function EnableLimit(param1:Boolean) : void
      {
         m_body1.WakeUp();
         m_body2.WakeUp();
         m_enableLimit = param1;
      }
      
      public function GetLowerLimit() : Number
      {
         return m_lowerTranslation;
      }
      
      public function GetUpperLimit() : Number
      {
         return m_upperTranslation;
      }
      
      public function SetLimits(param1:Number, param2:Number) : void
      {
         m_body1.WakeUp();
         m_body2.WakeUp();
         m_lowerTranslation = param1;
         m_upperTranslation = param2;
      }
      
      public function IsMotorEnabled() : Boolean
      {
         return m_enableMotor;
      }
      
      public function EnableMotor(param1:Boolean) : void
      {
         m_body1.WakeUp();
         m_body2.WakeUp();
         m_enableMotor = param1;
      }
      
      public function SetMotorSpeed(param1:Number) : void
      {
         m_body1.WakeUp();
         m_body2.WakeUp();
         m_motorSpeed = param1;
      }
      
      public function GetMotorSpeed() : Number
      {
         return m_motorSpeed;
      }
      
      public function SetMaxMotorForce(param1:Number) : void
      {
         m_body1.WakeUp();
         m_body2.WakeUp();
         m_maxMotorForce = param1;
      }
      
      public function GetMotorForce() : Number
      {
         return m_motorImpulse;
      }
      
      override b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc4_:b2Mat22 = null;
         var _loc5_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc2_:b2Body = m_body1;
         var _loc3_:b2Body = m_body2;
         m_localCenter1.SetV(_loc2_.GetLocalCenter());
         m_localCenter2.SetV(_loc3_.GetLocalCenter());
         var _loc6_:b2XForm = _loc2_.GetXForm();
         var _loc7_:b2XForm = _loc3_.GetXForm();
         _loc4_ = _loc2_.m_xf.R;
         var _loc8_:Number = m_localAnchor1.x - _loc2_.m_sweep.localCenter.x;
         var _loc9_:Number = m_localAnchor1.y - _loc2_.m_sweep.localCenter.y;
         _loc5_ = _loc4_.col1.x * _loc8_ + _loc4_.col2.x * _loc9_;
         _loc9_ = _loc4_.col1.y * _loc8_ + _loc4_.col2.y * _loc9_;
         _loc8_ = _loc5_;
         _loc4_ = _loc3_.m_xf.R;
         var _loc10_:Number = m_localAnchor2.x - _loc3_.m_sweep.localCenter.x;
         var _loc11_:Number = m_localAnchor2.y - _loc3_.m_sweep.localCenter.y;
         _loc5_ = _loc4_.col1.x * _loc10_ + _loc4_.col2.x * _loc11_;
         _loc11_ = _loc4_.col1.y * _loc10_ + _loc4_.col2.y * _loc11_;
         _loc10_ = _loc5_;
         var _loc12_:Number = _loc3_.m_sweep.c.x + _loc10_ - _loc2_.m_sweep.c.x - _loc8_;
         var _loc13_:Number = _loc3_.m_sweep.c.y + _loc11_ - _loc2_.m_sweep.c.y - _loc9_;
         m_invMass1 = _loc2_.m_invMass;
         m_invMass2 = _loc3_.m_invMass;
         m_invI1 = _loc2_.m_invI;
         m_invI2 = _loc3_.m_invI;
         m_axis.SetV(b2Math.b2MulMV(_loc6_.R,m_localXAxis1));
         m_a1 = (_loc12_ + _loc8_) * m_axis.y - (_loc13_ + _loc9_) * m_axis.x;
         m_a2 = _loc10_ * m_axis.y - _loc11_ * m_axis.x;
         m_motorMass = m_invMass1 + m_invMass2 + m_invI1 * m_a1 * m_a1 + m_invI2 * m_a2 * m_a2;
         m_motorMass = 1 / m_motorMass;
         m_perp.SetV(b2Math.b2MulMV(_loc6_.R,m_localYAxis1));
         m_s1 = (_loc12_ + _loc8_) * m_perp.y - (_loc13_ + _loc9_) * m_perp.x;
         m_s2 = _loc10_ * m_perp.y - _loc11_ * m_perp.x;
         var _loc14_:Number = m_invMass1;
         var _loc15_:Number = m_invMass2;
         var _loc16_:Number = m_invI1;
         var _loc17_:Number = m_invI2;
         m_K.col1.x = _loc14_ + _loc15_ + _loc16_ * m_s1 * m_s1 + _loc17_ * m_s2 * m_s2;
         m_K.col1.y = _loc16_ * m_s1 * m_a1 + _loc17_ * m_s2 * m_a2;
         m_K.col2.x = m_K.col1.y;
         m_K.col2.y = _loc14_ + _loc15_ + _loc16_ * m_a1 * m_a1 + _loc17_ * m_a2 * m_a2;
         if(m_enableLimit)
         {
            _loc18_ = m_axis.x * _loc12_ + m_axis.y * _loc13_;
            if(b2Math.b2Abs(m_upperTranslation - m_lowerTranslation) < 2 * b2Settings.b2_linearSlop)
            {
               m_limitState = e_equalLimits;
            }
            else if(_loc18_ <= m_lowerTranslation)
            {
               if(m_limitState != e_atLowerLimit)
               {
                  m_limitState = e_atLowerLimit;
                  m_impulse.y = 0;
               }
            }
            else if(_loc18_ >= m_upperTranslation)
            {
               if(m_limitState != e_atUpperLimit)
               {
                  m_limitState = e_atUpperLimit;
                  m_impulse.y = 0;
               }
            }
            else
            {
               m_limitState = e_inactiveLimit;
               m_impulse.y = 0;
            }
         }
         else
         {
            m_limitState = e_inactiveLimit;
         }
         if(m_enableMotor == false)
         {
            m_motorImpulse = 0;
         }
         if(param1.warmStarting)
         {
            m_impulse.x *= param1.dtRatio;
            m_impulse.y *= param1.dtRatio;
            m_motorImpulse *= param1.dtRatio;
            _loc19_ = m_impulse.x * m_perp.x + (m_motorImpulse + m_impulse.y) * m_axis.x;
            _loc20_ = m_impulse.x * m_perp.y + (m_motorImpulse + m_impulse.y) * m_axis.y;
            _loc21_ = m_impulse.x * m_s1 + (m_motorImpulse + m_impulse.y) * m_a1;
            _loc22_ = m_impulse.x * m_s2 + (m_motorImpulse + m_impulse.y) * m_a2;
            _loc2_.m_linearVelocity.x -= m_invMass1 * _loc19_;
            _loc2_.m_linearVelocity.y -= m_invMass1 * _loc20_;
            _loc2_.m_angularVelocity -= m_invI1 * _loc21_;
            _loc3_.m_linearVelocity.x += m_invMass2 * _loc19_;
            _loc3_.m_linearVelocity.y += m_invMass2 * _loc20_;
            _loc3_.m_angularVelocity += m_invI2 * _loc22_;
         }
         else
         {
            m_impulse.SetZero();
            m_motorImpulse = 0;
         }
      }
      
      override b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:b2Vec2 = null;
         var _loc19_:b2Vec2 = null;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc2_:b2Body = m_body1;
         var _loc3_:b2Body = m_body2;
         var _loc4_:b2Vec2 = _loc2_.m_linearVelocity;
         var _loc5_:Number = _loc2_.m_angularVelocity;
         var _loc6_:b2Vec2 = _loc3_.m_linearVelocity;
         var _loc7_:Number = _loc3_.m_angularVelocity;
         if(m_enableMotor && m_limitState != e_equalLimits)
         {
            _loc13_ = m_axis.x * (_loc6_.x - _loc4_.x) + m_axis.y * (_loc6_.y - _loc4_.y) + m_a2 * _loc7_ - m_a1 * _loc5_;
            _loc14_ = m_motorMass * (m_motorSpeed - _loc13_);
            _loc15_ = m_motorImpulse;
            _loc16_ = param1.dt * m_maxMotorForce;
            m_motorImpulse = b2Math.b2Clamp(m_motorImpulse + _loc14_,-_loc16_,_loc16_);
            _loc14_ = m_motorImpulse - _loc15_;
            _loc8_ = _loc14_ * m_axis.x;
            _loc9_ = _loc14_ * m_axis.y;
            _loc10_ = _loc14_ * m_a1;
            _loc11_ = _loc14_ * m_a2;
            _loc4_.x -= m_invMass1 * _loc8_;
            _loc4_.y -= m_invMass1 * _loc9_;
            _loc5_ -= m_invI1 * _loc10_;
            _loc6_.x += m_invMass2 * _loc8_;
            _loc6_.y += m_invMass2 * _loc9_;
            _loc7_ += m_invI2 * _loc11_;
         }
         var _loc12_:Number = m_perp.x * (_loc6_.x - _loc4_.x) + m_perp.y * (_loc6_.y - _loc4_.y) + m_s2 * _loc7_ - m_s1 * _loc5_;
         if(m_enableLimit && m_limitState != e_inactiveLimit)
         {
            _loc17_ = m_axis.x * (_loc6_.x - _loc4_.x) + m_axis.y * (_loc6_.y - _loc4_.y) + m_a2 * _loc7_ - m_a1 * _loc5_;
            _loc18_ = m_impulse.Copy();
            _loc19_ = m_K.Solve(new b2Vec2(),-_loc12_,-_loc17_);
            m_impulse.Add(_loc19_);
            if(m_limitState == e_atLowerLimit)
            {
               m_impulse.y = b2Math.b2Max(m_impulse.y,0);
            }
            else if(m_limitState == e_atUpperLimit)
            {
               m_impulse.y = b2Math.b2Min(m_impulse.y,0);
            }
            _loc20_ = -_loc12_ - (m_impulse.y - _loc18_.y) * m_K.col2.x;
            _loc21_ = _loc20_ / m_K.col1.x + _loc18_.x;
            m_impulse.x = _loc21_;
            _loc19_.x = m_impulse.x - _loc18_.x;
            _loc19_.y = m_impulse.y - _loc18_.y;
            _loc8_ = _loc19_.x * m_perp.x + _loc19_.y * m_axis.x;
            _loc9_ = _loc19_.x * m_perp.y + _loc19_.y * m_axis.y;
            _loc10_ = _loc19_.x * m_s1 + _loc19_.y * m_a1;
            _loc11_ = _loc19_.x * m_s2 + _loc19_.y * m_a2;
            _loc4_.x -= m_invMass1 * _loc8_;
            _loc4_.y -= m_invMass1 * _loc9_;
            _loc5_ -= m_invI1 * _loc10_;
            _loc6_.x += m_invMass2 * _loc8_;
            _loc6_.y += m_invMass2 * _loc9_;
            _loc7_ += m_invI2 * _loc11_;
         }
         else
         {
            _loc22_ = -_loc12_ / m_K.col1.x;
            m_impulse.x += _loc22_;
            _loc8_ = _loc22_ * m_perp.x;
            _loc9_ = _loc22_ * m_perp.y;
            _loc10_ = _loc22_ * m_s1;
            _loc11_ = _loc22_ * m_s2;
            _loc4_.x -= m_invMass1 * _loc8_;
            _loc4_.y -= m_invMass1 * _loc9_;
            _loc5_ -= m_invI1 * _loc10_;
            _loc6_.x += m_invMass2 * _loc8_;
            _loc6_.y += m_invMass2 * _loc9_;
            _loc7_ += m_invI2 * _loc11_;
         }
         _loc2_.m_linearVelocity.SetV(_loc4_);
         _loc2_.m_angularVelocity = _loc5_;
         _loc3_.m_linearVelocity.SetV(_loc6_);
         _loc3_.m_angularVelocity = _loc7_;
      }
      
      override b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc10_:b2Mat22 = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc4_:b2Body = m_body1;
         var _loc5_:b2Body = m_body2;
         var _loc6_:b2Vec2 = _loc4_.m_sweep.c;
         var _loc7_:Number = _loc4_.m_sweep.a;
         var _loc8_:b2Vec2 = _loc5_.m_sweep.c;
         var _loc9_:Number = _loc5_.m_sweep.a;
         var _loc16_:Number = 0;
         var _loc17_:Number = 0;
         var _loc18_:Boolean = false;
         var _loc19_:Number = 0;
         var _loc20_:b2Mat22 = new b2Mat22(_loc7_);
         var _loc21_:b2Mat22 = new b2Mat22(_loc9_);
         _loc10_ = _loc20_;
         var _loc22_:Number = m_localAnchor1.x - m_localCenter1.x;
         var _loc23_:Number = m_localAnchor1.y - m_localCenter1.y;
         _loc11_ = _loc10_.col1.x * _loc22_ + _loc10_.col2.x * _loc23_;
         _loc23_ = _loc10_.col1.y * _loc22_ + _loc10_.col2.y * _loc23_;
         _loc22_ = _loc11_;
         _loc10_ = _loc21_;
         var _loc24_:Number = m_localAnchor2.x - m_localCenter2.x;
         var _loc25_:Number = m_localAnchor2.y - m_localCenter2.y;
         _loc11_ = _loc10_.col1.x * _loc24_ + _loc10_.col2.x * _loc25_;
         _loc25_ = _loc10_.col1.y * _loc24_ + _loc10_.col2.y * _loc25_;
         _loc24_ = _loc11_;
         var _loc26_:Number = _loc8_.x + _loc24_ - _loc6_.x - _loc22_;
         var _loc27_:Number = _loc8_.y + _loc25_ - _loc6_.y - _loc23_;
         if(m_enableLimit)
         {
            m_axis = b2Math.b2MulMV(_loc20_,m_localXAxis1);
            m_a1 = (_loc26_ + _loc22_) * m_axis.y - (_loc27_ + _loc23_) * m_axis.x;
            m_a2 = _loc24_ * m_axis.y - _loc25_ * m_axis.x;
            _loc34_ = m_axis.x * _loc26_ + m_axis.y * _loc27_;
            if(b2Math.b2Abs(m_upperTranslation - m_lowerTranslation) < 2 * b2Settings.b2_linearSlop)
            {
               _loc19_ = b2Math.b2Clamp(_loc34_,-b2Settings.b2_maxLinearCorrection,b2Settings.b2_maxLinearCorrection);
               _loc16_ = b2Math.b2Abs(_loc34_);
               _loc18_ = true;
            }
            else if(_loc34_ <= m_lowerTranslation)
            {
               _loc19_ = b2Math.b2Clamp(_loc34_ - m_lowerTranslation + b2Settings.b2_linearSlop,-b2Settings.b2_maxLinearCorrection,0);
               _loc16_ = m_lowerTranslation - _loc34_;
               _loc18_ = true;
            }
            else if(_loc34_ >= m_upperTranslation)
            {
               _loc19_ = b2Math.b2Clamp(_loc34_ - m_upperTranslation + b2Settings.b2_linearSlop,0,b2Settings.b2_maxLinearCorrection);
               _loc16_ = _loc34_ - m_upperTranslation;
               _loc18_ = true;
            }
         }
         m_perp = b2Math.b2MulMV(_loc20_,m_localYAxis1);
         m_s1 = (_loc26_ + _loc22_) * m_perp.y - (_loc27_ + _loc23_) * m_perp.x;
         m_s2 = _loc24_ * m_perp.y - _loc25_ * m_perp.x;
         var _loc28_:b2Vec2 = new b2Vec2();
         var _loc29_:Number = m_perp.x * _loc26_ + m_perp.y * _loc27_;
         _loc16_ = b2Math.b2Max(_loc16_,b2Math.b2Abs(_loc29_));
         _loc17_ = 0;
         if(_loc18_)
         {
            _loc12_ = m_invMass1;
            _loc13_ = m_invMass2;
            _loc14_ = m_invI1;
            _loc15_ = m_invI2;
            m_K.col1.x = _loc12_ + _loc13_ + _loc14_ * m_s1 * m_s1 + _loc15_ * m_s2 * m_s2;
            m_K.col1.y = _loc14_ * m_s1 * m_a1 + _loc15_ * m_s2 * m_a2;
            m_K.col2.x = m_K.col1.y;
            m_K.col2.y = _loc12_ + _loc13_ + _loc14_ * m_a1 * m_a1 + _loc15_ * m_a2 * m_a2;
            m_K.Solve(_loc28_,-_loc29_,-_loc19_);
         }
         else
         {
            _loc12_ = m_invMass1;
            _loc13_ = m_invMass2;
            _loc14_ = m_invI1;
            _loc15_ = m_invI2;
            _loc35_ = _loc12_ + _loc13_ + _loc14_ * m_s1 * m_s1 + _loc15_ * m_s2 * m_s2;
            _loc36_ = -_loc29_ / _loc35_;
            _loc28_.x = _loc36_;
            _loc28_.y = 0;
         }
         var _loc30_:Number = _loc28_.x * m_perp.x + _loc28_.y * m_axis.x;
         var _loc31_:Number = _loc28_.x * m_perp.y + _loc28_.y * m_axis.y;
         var _loc32_:Number = _loc28_.x * m_s1 + _loc28_.y * m_a1;
         var _loc33_:Number = _loc28_.x * m_s2 + _loc28_.y * m_a2;
         _loc6_.x -= m_invMass1 * _loc30_;
         _loc6_.y -= m_invMass1 * _loc31_;
         _loc7_ -= m_invI1 * _loc32_;
         _loc8_.x += m_invMass2 * _loc30_;
         _loc8_.y += m_invMass2 * _loc31_;
         _loc9_ += m_invI2 * _loc33_;
         _loc4_.m_sweep.a = _loc7_;
         _loc5_.m_sweep.a = _loc9_;
         _loc4_.SynchronizeTransform();
         _loc5_.SynchronizeTransform();
         return _loc16_ <= b2Settings.b2_linearSlop && _loc17_ <= b2Settings.b2_angularSlop;
      }
   }
}

