package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Mat33;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.Math.b2Vec3;
   import Box2D.Common.b2Settings;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2TimeStep;
   
   use namespace b2internal;
   
   public class b2RevoluteJoint extends b2Joint
   {
      
      private static var tImpulse:b2Vec2 = new b2Vec2();
      
      private var K:b2Mat22 = new b2Mat22();
      
      private var K1:b2Mat22 = new b2Mat22();
      
      private var K2:b2Mat22 = new b2Mat22();
      
      private var K3:b2Mat22 = new b2Mat22();
      
      b2internal var m_localAnchor1:b2Vec2 = new b2Vec2();
      
      b2internal var m_localAnchor2:b2Vec2 = new b2Vec2();
      
      private var m_impulse:b2Vec3 = new b2Vec3();
      
      private var m_motorImpulse:Number;
      
      private var m_mass:b2Mat33 = new b2Mat33();
      
      private var m_motorMass:Number;
      
      private var m_enableMotor:Boolean;
      
      private var m_maxMotorTorque:Number;
      
      private var m_motorSpeed:Number;
      
      private var m_enableLimit:Boolean;
      
      private var m_referenceAngle:Number;
      
      private var m_lowerAngle:Number;
      
      private var m_upperAngle:Number;
      
      private var m_limitState:int;
      
      public function b2RevoluteJoint(param1:b2RevoluteJointDef)
      {
         super(param1);
         b2internal::m_localAnchor1.SetV(param1.localAnchor1);
         b2internal::m_localAnchor2.SetV(param1.localAnchor2);
         m_referenceAngle = param1.referenceAngle;
         m_impulse.SetZero();
         m_motorImpulse = 0;
         m_lowerAngle = param1.lowerAngle;
         m_upperAngle = param1.upperAngle;
         m_maxMotorTorque = param1.maxMotorTorque;
         m_motorSpeed = param1.motorSpeed;
         m_enableLimit = param1.enableLimit;
         m_enableMotor = param1.enableMotor;
         m_limitState = b2internal::e_inactiveLimit;
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
         return new b2Vec2(param1 * m_impulse.x,param1 * m_impulse.y);
      }
      
      override public function GetReactionTorque(param1:Number) : Number
      {
         return param1 * m_impulse.z;
      }
      
      public function GetJointAngle() : Number
      {
         return m_body2.m_sweep.a - m_body1.m_sweep.a - m_referenceAngle;
      }
      
      public function GetJointSpeed() : Number
      {
         return m_body2.m_angularVelocity - m_body1.m_angularVelocity;
      }
      
      public function IsLimitEnabled() : Boolean
      {
         return m_enableLimit;
      }
      
      public function EnableLimit(param1:Boolean) : void
      {
         m_enableLimit = param1;
      }
      
      public function GetLowerLimit() : Number
      {
         return m_lowerAngle;
      }
      
      public function GetUpperLimit() : Number
      {
         return m_upperAngle;
      }
      
      public function SetLimits(param1:Number, param2:Number) : void
      {
         m_lowerAngle = param1;
         m_upperAngle = param2;
      }
      
      public function IsMotorEnabled() : Boolean
      {
         m_body1.WakeUp();
         m_body2.WakeUp();
         return m_enableMotor;
      }
      
      public function EnableMotor(param1:Boolean) : void
      {
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
      
      public function SetMaxMotorTorque(param1:Number) : void
      {
         m_maxMotorTorque = param1;
      }
      
      public function GetMotorTorque() : Number
      {
         return m_maxMotorTorque;
      }
      
      override b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc2_:b2Body = null;
         var _loc3_:b2Body = null;
         var _loc4_:b2Mat22 = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         _loc2_ = m_body1;
         _loc3_ = m_body2;
         if(m_enableMotor || m_enableLimit)
         {
         }
         _loc4_ = _loc2_.m_xf.R;
         _loc6_ = m_localAnchor1.x - _loc2_.m_sweep.localCenter.x;
         _loc7_ = m_localAnchor1.y - _loc2_.m_sweep.localCenter.y;
         _loc5_ = _loc4_.col1.x * _loc6_ + _loc4_.col2.x * _loc7_;
         _loc7_ = _loc4_.col1.y * _loc6_ + _loc4_.col2.y * _loc7_;
         _loc6_ = _loc5_;
         _loc4_ = _loc3_.m_xf.R;
         var _loc8_:Number = m_localAnchor2.x - _loc3_.m_sweep.localCenter.x;
         var _loc9_:Number = m_localAnchor2.y - _loc3_.m_sweep.localCenter.y;
         _loc5_ = _loc4_.col1.x * _loc8_ + _loc4_.col2.x * _loc9_;
         _loc9_ = _loc4_.col1.y * _loc8_ + _loc4_.col2.y * _loc9_;
         _loc8_ = _loc5_;
         var _loc10_:Number = _loc2_.m_invMass;
         var _loc11_:Number = _loc3_.m_invMass;
         var _loc12_:Number = _loc2_.m_invI;
         var _loc13_:Number = _loc3_.m_invI;
         m_mass.col1.x = _loc10_ + _loc11_ + _loc7_ * _loc7_ * _loc12_ + _loc9_ * _loc9_ * _loc13_;
         m_mass.col2.x = -_loc7_ * _loc6_ * _loc12_ - _loc9_ * _loc8_ * _loc13_;
         m_mass.col3.x = -_loc7_ * _loc12_ - _loc9_ * _loc13_;
         m_mass.col1.y = m_mass.col2.x;
         m_mass.col2.y = _loc10_ + _loc11_ + _loc6_ * _loc6_ * _loc12_ + _loc8_ * _loc8_ * _loc13_;
         m_mass.col3.y = _loc6_ * _loc12_ + _loc8_ * _loc13_;
         m_mass.col1.z = m_mass.col3.x;
         m_mass.col2.z = m_mass.col3.y;
         m_mass.col3.z = _loc12_ + _loc13_;
         m_motorMass = 1 / (_loc12_ + _loc13_);
         if(m_enableMotor == false)
         {
            m_motorImpulse = 0;
         }
         if(m_enableLimit)
         {
            _loc14_ = _loc3_.m_sweep.a - _loc2_.m_sweep.a - m_referenceAngle;
            if(b2Math.b2Abs(m_upperAngle - m_lowerAngle) < 2 * b2Settings.b2_angularSlop)
            {
               m_limitState = e_equalLimits;
            }
            else if(_loc14_ <= m_lowerAngle)
            {
               if(m_limitState != e_atLowerLimit)
               {
                  m_impulse.z = 0;
               }
               m_limitState = e_atLowerLimit;
            }
            else if(_loc14_ >= m_upperAngle)
            {
               if(m_limitState != e_atUpperLimit)
               {
                  m_impulse.z = 0;
               }
               m_limitState = e_atUpperLimit;
            }
            else
            {
               m_limitState = e_inactiveLimit;
               m_impulse.z = 0;
            }
         }
         else
         {
            m_limitState = e_inactiveLimit;
         }
         if(param1.warmStarting)
         {
            m_impulse.x *= param1.dtRatio;
            m_impulse.y *= param1.dtRatio;
            m_motorImpulse *= param1.dtRatio;
            _loc15_ = m_impulse.x;
            _loc16_ = m_impulse.y;
            _loc2_.m_linearVelocity.x -= _loc10_ * _loc15_;
            _loc2_.m_linearVelocity.y -= _loc10_ * _loc16_;
            _loc2_.m_angularVelocity -= _loc12_ * (_loc6_ * _loc16_ - _loc7_ * _loc15_ + m_motorImpulse + m_impulse.z);
            _loc3_.m_linearVelocity.x += _loc11_ * _loc15_;
            _loc3_.m_linearVelocity.y += _loc11_ * _loc16_;
            _loc3_.m_angularVelocity += _loc13_ * (_loc8_ * _loc16_ - _loc9_ * _loc15_ + m_motorImpulse + m_impulse.z);
         }
         else
         {
            m_impulse.SetZero();
            m_motorImpulse = 0;
         }
      }
      
      override b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc4_:b2Mat22 = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:b2Vec2 = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:b2Vec3 = null;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:b2Vec2 = null;
         var _loc2_:b2Body = m_body1;
         var _loc3_:b2Body = m_body2;
         var _loc12_:b2Vec2 = _loc2_.m_linearVelocity;
         var _loc13_:Number = _loc2_.m_angularVelocity;
         var _loc14_:b2Vec2 = _loc3_.m_linearVelocity;
         var _loc15_:Number = _loc3_.m_angularVelocity;
         var _loc16_:Number = _loc2_.m_invMass;
         var _loc17_:Number = _loc3_.m_invMass;
         var _loc18_:Number = _loc2_.m_invI;
         var _loc19_:Number = _loc3_.m_invI;
         if(m_enableMotor && m_limitState != e_equalLimits)
         {
            _loc20_ = _loc15_ - _loc13_ - m_motorSpeed;
            _loc21_ = m_motorMass * -_loc20_;
            _loc22_ = m_motorImpulse;
            _loc23_ = param1.dt * m_maxMotorTorque;
            m_motorImpulse = b2Math.b2Clamp(m_motorImpulse + _loc21_,-_loc23_,_loc23_);
            _loc21_ = m_motorImpulse - _loc22_;
            _loc13_ -= _loc18_ * _loc21_;
            _loc15_ += _loc19_ * _loc21_;
         }
         if(m_enableLimit && m_limitState != e_inactiveLimit)
         {
            _loc4_ = _loc2_.m_xf.R;
            _loc8_ = m_localAnchor1.x - _loc2_.m_sweep.localCenter.x;
            _loc9_ = m_localAnchor1.y - _loc2_.m_sweep.localCenter.y;
            _loc5_ = _loc4_.col1.x * _loc8_ + _loc4_.col2.x * _loc9_;
            _loc9_ = _loc4_.col1.y * _loc8_ + _loc4_.col2.y * _loc9_;
            _loc8_ = _loc5_;
            _loc4_ = _loc3_.m_xf.R;
            _loc10_ = m_localAnchor2.x - _loc3_.m_sweep.localCenter.x;
            _loc11_ = m_localAnchor2.y - _loc3_.m_sweep.localCenter.y;
            _loc5_ = _loc4_.col1.x * _loc10_ + _loc4_.col2.x * _loc11_;
            _loc11_ = _loc4_.col1.y * _loc10_ + _loc4_.col2.y * _loc11_;
            _loc10_ = _loc5_;
            _loc24_ = _loc14_.x + -_loc15_ * _loc11_ - _loc12_.x - -_loc13_ * _loc9_;
            _loc25_ = _loc14_.y + _loc15_ * _loc10_ - _loc12_.y - _loc13_ * _loc8_;
            _loc26_ = _loc15_ - _loc13_;
            _loc27_ = m_mass.Solve33(new b2Vec3(),-_loc24_,-_loc25_,-_loc26_);
            if(m_limitState == e_equalLimits)
            {
               m_impulse.Add(_loc27_);
            }
            else if(m_limitState == e_atLowerLimit)
            {
               _loc6_ = m_impulse.z + _loc27_.z;
               if(_loc6_ < 0)
               {
                  _loc7_ = m_mass.Solve22(new b2Vec2(),-_loc24_,-_loc25_);
                  _loc27_.x = _loc7_.x;
                  _loc27_.y = _loc7_.y;
                  _loc27_.z = -m_impulse.z;
                  m_impulse.x += _loc7_.x;
                  m_impulse.y += _loc7_.y;
                  m_impulse.z = 0;
               }
            }
            else if(m_limitState == e_atUpperLimit)
            {
               _loc6_ = m_impulse.z + _loc27_.z;
               if(_loc6_ > 0)
               {
                  _loc7_ = m_mass.Solve22(new b2Vec2(),-_loc24_,-_loc25_);
                  _loc27_.x = _loc7_.x;
                  _loc27_.y = _loc7_.y;
                  _loc27_.z = -m_impulse.z;
                  m_impulse.x += _loc7_.x;
                  m_impulse.y += _loc7_.y;
                  m_impulse.z = 0;
               }
            }
            _loc12_.x -= _loc16_ * _loc27_.x;
            _loc12_.y -= _loc16_ * _loc27_.y;
            _loc13_ -= _loc18_ * (_loc8_ * _loc27_.y - _loc9_ * _loc27_.x + _loc27_.z);
            _loc14_.x += _loc17_ * _loc27_.x;
            _loc14_.y += _loc17_ * _loc27_.y;
            _loc15_ += _loc19_ * (_loc10_ * _loc27_.y - _loc11_ * _loc27_.x + _loc27_.z);
         }
         else
         {
            _loc4_ = _loc2_.m_xf.R;
            _loc8_ = m_localAnchor1.x - _loc2_.m_sweep.localCenter.x;
            _loc9_ = m_localAnchor1.y - _loc2_.m_sweep.localCenter.y;
            _loc5_ = _loc4_.col1.x * _loc8_ + _loc4_.col2.x * _loc9_;
            _loc9_ = _loc4_.col1.y * _loc8_ + _loc4_.col2.y * _loc9_;
            _loc8_ = _loc5_;
            _loc4_ = _loc3_.m_xf.R;
            _loc10_ = m_localAnchor2.x - _loc3_.m_sweep.localCenter.x;
            _loc11_ = m_localAnchor2.y - _loc3_.m_sweep.localCenter.y;
            _loc5_ = _loc4_.col1.x * _loc10_ + _loc4_.col2.x * _loc11_;
            _loc11_ = _loc4_.col1.y * _loc10_ + _loc4_.col2.y * _loc11_;
            _loc10_ = _loc5_;
            _loc28_ = _loc14_.x + -_loc15_ * _loc11_ - _loc12_.x - -_loc13_ * _loc9_;
            _loc29_ = _loc14_.y + _loc15_ * _loc10_ - _loc12_.y - _loc13_ * _loc8_;
            _loc30_ = m_mass.Solve22(new b2Vec2(),-_loc28_,-_loc29_);
            m_impulse.x += _loc30_.x;
            m_impulse.y += _loc30_.y;
            _loc12_.x -= _loc16_ * _loc30_.x;
            _loc12_.y -= _loc16_ * _loc30_.y;
            _loc13_ -= _loc18_ * (_loc8_ * _loc30_.y - _loc9_ * _loc30_.x);
            _loc14_.x += _loc17_ * _loc30_.x;
            _loc14_.y += _loc17_ * _loc30_.y;
            _loc15_ += _loc19_ * (_loc10_ * _loc30_.y - _loc11_ * _loc30_.x);
         }
         _loc2_.m_linearVelocity.SetV(_loc12_);
         _loc2_.m_angularVelocity = _loc13_;
         _loc3_.m_linearVelocity.SetV(_loc14_);
         _loc3_.m_angularVelocity = _loc15_;
      }
      
      override b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:b2Mat22 = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc5_:b2Body = m_body1;
         var _loc6_:b2Body = m_body2;
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         if(m_enableLimit && m_limitState != e_inactiveLimit)
         {
            _loc25_ = _loc6_.m_sweep.a - _loc5_.m_sweep.a - m_referenceAngle;
            _loc26_ = 0;
            if(m_limitState == e_equalLimits)
            {
               _loc3_ = b2Math.b2Clamp(_loc25_,-b2Settings.b2_maxAngularCorrection,b2Settings.b2_maxAngularCorrection);
               _loc26_ = -m_motorMass * _loc3_;
               _loc7_ = b2Math.b2Abs(_loc3_);
            }
            else if(m_limitState == e_atLowerLimit)
            {
               _loc3_ = _loc25_ - m_lowerAngle;
               _loc7_ = -_loc3_;
               _loc3_ = b2Math.b2Clamp(_loc3_ + b2Settings.b2_angularSlop,-b2Settings.b2_maxAngularCorrection,0);
               _loc26_ = -m_motorMass * _loc3_;
            }
            else if(m_limitState == e_atUpperLimit)
            {
               _loc3_ = _loc25_ - m_upperAngle;
               _loc7_ = _loc3_;
               _loc3_ = b2Math.b2Clamp(_loc3_ - b2Settings.b2_angularSlop,0,b2Settings.b2_maxAngularCorrection);
               _loc26_ = -m_motorMass * _loc3_;
            }
            _loc5_.m_sweep.a -= _loc5_.m_invI * _loc26_;
            _loc6_.m_sweep.a += _loc6_.m_invI * _loc26_;
            _loc5_.SynchronizeTransform();
            _loc6_.SynchronizeTransform();
         }
         _loc4_ = _loc5_.m_xf.R;
         var _loc12_:Number = m_localAnchor1.x - _loc5_.m_sweep.localCenter.x;
         var _loc13_:Number = m_localAnchor1.y - _loc5_.m_sweep.localCenter.y;
         _loc9_ = _loc4_.col1.x * _loc12_ + _loc4_.col2.x * _loc13_;
         _loc13_ = _loc4_.col1.y * _loc12_ + _loc4_.col2.y * _loc13_;
         _loc12_ = _loc9_;
         _loc4_ = _loc6_.m_xf.R;
         var _loc14_:Number = m_localAnchor2.x - _loc6_.m_sweep.localCenter.x;
         var _loc15_:Number = m_localAnchor2.y - _loc6_.m_sweep.localCenter.y;
         _loc9_ = _loc4_.col1.x * _loc14_ + _loc4_.col2.x * _loc15_;
         _loc15_ = _loc4_.col1.y * _loc14_ + _loc4_.col2.y * _loc15_;
         _loc14_ = _loc9_;
         var _loc16_:Number = _loc6_.m_sweep.c.x + _loc14_ - _loc5_.m_sweep.c.x - _loc12_;
         var _loc17_:Number = _loc6_.m_sweep.c.y + _loc15_ - _loc5_.m_sweep.c.y - _loc13_;
         var _loc18_:Number = _loc16_ * _loc16_ + _loc17_ * _loc17_;
         var _loc19_:Number;
         _loc8_ = _loc19_ = Math.sqrt(_loc18_);
         var _loc20_:Number = _loc5_.m_invMass;
         var _loc21_:Number = _loc6_.m_invMass;
         var _loc22_:Number = _loc5_.m_invI;
         var _loc23_:Number = _loc6_.m_invI;
         var _loc24_:Number = 10 * b2Settings.b2_linearSlop;
         if(_loc18_ > _loc24_ * _loc24_)
         {
            _loc27_ = _loc16_ / _loc19_;
            _loc28_ = _loc17_ / _loc19_;
            _loc29_ = _loc20_ + _loc21_;
            _loc30_ = 1 / _loc29_;
            _loc10_ = _loc30_ * -_loc16_;
            _loc11_ = _loc30_ * -_loc17_;
            _loc31_ = 0.5;
            _loc5_.m_sweep.c.x -= _loc31_ * _loc20_ * _loc10_;
            _loc5_.m_sweep.c.y -= _loc31_ * _loc20_ * _loc11_;
            _loc6_.m_sweep.c.x += _loc31_ * _loc21_ * _loc10_;
            _loc6_.m_sweep.c.y += _loc31_ * _loc21_ * _loc11_;
            _loc16_ = _loc6_.m_sweep.c.x + _loc14_ - _loc5_.m_sweep.c.x - _loc12_;
            _loc17_ = _loc6_.m_sweep.c.y + _loc15_ - _loc5_.m_sweep.c.y - _loc13_;
         }
         K1.col1.x = _loc20_ + _loc21_;
         K1.col2.x = 0;
         K1.col1.y = 0;
         K1.col2.y = _loc20_ + _loc21_;
         K2.col1.x = _loc22_ * _loc13_ * _loc13_;
         K2.col2.x = -_loc22_ * _loc12_ * _loc13_;
         K2.col1.y = -_loc22_ * _loc12_ * _loc13_;
         K2.col2.y = _loc22_ * _loc12_ * _loc12_;
         K3.col1.x = _loc23_ * _loc15_ * _loc15_;
         K3.col2.x = -_loc23_ * _loc14_ * _loc15_;
         K3.col1.y = -_loc23_ * _loc14_ * _loc15_;
         K3.col2.y = _loc23_ * _loc14_ * _loc14_;
         K.SetM(K1);
         K.AddM(K2);
         K.AddM(K3);
         K.Solve(tImpulse,-_loc16_,-_loc17_);
         _loc10_ = tImpulse.x;
         _loc11_ = tImpulse.y;
         _loc5_.m_sweep.c.x -= _loc5_.m_invMass * _loc10_;
         _loc5_.m_sweep.c.y -= _loc5_.m_invMass * _loc11_;
         _loc5_.m_sweep.a -= _loc5_.m_invI * (_loc12_ * _loc11_ - _loc13_ * _loc10_);
         _loc6_.m_sweep.c.x += _loc6_.m_invMass * _loc10_;
         _loc6_.m_sweep.c.y += _loc6_.m_invMass * _loc11_;
         _loc6_.m_sweep.a += _loc6_.m_invI * (_loc14_ * _loc11_ - _loc15_ * _loc10_);
         _loc5_.SynchronizeTransform();
         _loc6_.SynchronizeTransform();
         return _loc8_ <= b2Settings.b2_linearSlop && _loc7_ <= b2Settings.b2_angularSlop;
      }
   }
}

