package Box2D.Dynamics.Joints
{
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2TimeStep;
   
   use namespace b2internal;
   
   public class b2MouseJoint extends b2Joint
   {
      
      private var K:b2Mat22;
      
      private var K1:b2Mat22;
      
      private var K2:b2Mat22;
      
      private var m_localAnchor:b2Vec2;
      
      private var m_target:b2Vec2;
      
      private var m_impulse:b2Vec2;
      
      private var m_mass:b2Mat22;
      
      private var m_C:b2Vec2;
      
      private var m_maxForce:Number;
      
      private var m_frequencyHz:Number;
      
      private var m_dampingRatio:Number;
      
      private var m_beta:Number;
      
      private var m_gamma:Number;
      
      public function b2MouseJoint(param1:b2MouseJointDef)
      {
         var _loc3_:Number = NaN;
         K = new b2Mat22();
         K1 = new b2Mat22();
         K2 = new b2Mat22();
         m_localAnchor = new b2Vec2();
         m_target = new b2Vec2();
         m_impulse = new b2Vec2();
         m_mass = new b2Mat22();
         m_C = new b2Vec2();
         super(param1);
         m_target.SetV(param1.target);
         var _loc2_:Number = m_target.x - b2internal::m_body2.m_xf.position.x;
         _loc3_ = m_target.y - b2internal::m_body2.m_xf.position.y;
         var _loc4_:b2Mat22 = b2internal::m_body2.m_xf.R;
         m_localAnchor.x = _loc2_ * _loc4_.col1.x + _loc3_ * _loc4_.col1.y;
         m_localAnchor.y = _loc2_ * _loc4_.col2.x + _loc3_ * _loc4_.col2.y;
         m_maxForce = param1.maxForce;
         m_impulse.SetZero();
         m_frequencyHz = param1.frequencyHz;
         m_dampingRatio = param1.dampingRatio;
         m_beta = 0;
         m_gamma = 0;
      }
      
      override public function GetAnchor1() : b2Vec2
      {
         return m_target;
      }
      
      override public function GetAnchor2() : b2Vec2
      {
         return m_body2.GetWorldPoint(m_localAnchor);
      }
      
      override public function GetReactionForce(param1:Number) : b2Vec2
      {
         return new b2Vec2(param1 * m_impulse.x,param1 * m_impulse.y);
      }
      
      override public function GetReactionTorque(param1:Number) : Number
      {
         return 0;
      }
      
      public function SetTarget(param1:b2Vec2) : void
      {
         if(m_body2.IsSleeping())
         {
            m_body2.WakeUp();
         }
         m_target = param1;
      }
      
      override b2internal function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc2_:b2Body = null;
         var _loc7_:b2Mat22 = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         _loc2_ = m_body2;
         var _loc3_:Number = _loc2_.GetMass();
         var _loc4_:Number = 2 * Math.PI * m_frequencyHz;
         var _loc5_:Number = 2 * _loc3_ * m_dampingRatio * _loc4_;
         var _loc6_:Number = _loc3_ * _loc4_ * _loc4_;
         m_gamma = 1 / (param1.dt * (_loc5_ + param1.dt * _loc6_));
         m_beta = param1.dt * _loc6_ * m_gamma;
         _loc7_ = _loc2_.m_xf.R;
         _loc8_ = m_localAnchor.x - _loc2_.m_sweep.localCenter.x;
         _loc9_ = m_localAnchor.y - _loc2_.m_sweep.localCenter.y;
         var _loc10_:Number = _loc7_.col1.x * _loc8_ + _loc7_.col2.x * _loc9_;
         _loc9_ = _loc7_.col1.y * _loc8_ + _loc7_.col2.y * _loc9_;
         _loc8_ = _loc10_;
         var _loc11_:Number = _loc2_.m_invMass;
         var _loc12_:Number = _loc2_.m_invI;
         K1.col1.x = _loc11_;
         K1.col2.x = 0;
         K1.col1.y = 0;
         K1.col2.y = _loc11_;
         K2.col1.x = _loc12_ * _loc9_ * _loc9_;
         K2.col2.x = -_loc12_ * _loc8_ * _loc9_;
         K2.col1.y = -_loc12_ * _loc8_ * _loc9_;
         K2.col2.y = _loc12_ * _loc8_ * _loc8_;
         K.SetM(K1);
         K.AddM(K2);
         K.col1.x += m_gamma;
         K.col2.y += m_gamma;
         K.GetInverse(m_mass);
         m_C.x = _loc2_.m_sweep.c.x + _loc8_ - m_target.x;
         m_C.y = _loc2_.m_sweep.c.y + _loc9_ - m_target.y;
         _loc2_.m_angularVelocity *= 0.98;
         m_impulse.x *= param1.dtRatio;
         m_impulse.y *= param1.dtRatio;
         _loc2_.m_linearVelocity.x += _loc11_ * m_impulse.x;
         _loc2_.m_linearVelocity.y += _loc11_ * m_impulse.y;
         _loc2_.m_angularVelocity += _loc12_ * (_loc8_ * m_impulse.y - _loc9_ * m_impulse.x);
      }
      
      override b2internal function SolveVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc3_:b2Mat22 = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:b2Body = m_body2;
         _loc3_ = _loc2_.m_xf.R;
         var _loc6_:Number = m_localAnchor.x - _loc2_.m_sweep.localCenter.x;
         var _loc7_:Number = m_localAnchor.y - _loc2_.m_sweep.localCenter.y;
         _loc4_ = _loc3_.col1.x * _loc6_ + _loc3_.col2.x * _loc7_;
         _loc7_ = _loc3_.col1.y * _loc6_ + _loc3_.col2.y * _loc7_;
         _loc6_ = _loc4_;
         var _loc8_:Number = _loc2_.m_linearVelocity.x + -_loc2_.m_angularVelocity * _loc7_;
         var _loc9_:Number = _loc2_.m_linearVelocity.y + _loc2_.m_angularVelocity * _loc6_;
         _loc3_ = m_mass;
         _loc4_ = _loc8_ + m_beta * m_C.x + m_gamma * m_impulse.x;
         _loc5_ = _loc9_ + m_beta * m_C.y + m_gamma * m_impulse.y;
         var _loc10_:Number = -(_loc3_.col1.x * _loc4_ + _loc3_.col2.x * _loc5_);
         var _loc11_:Number = -(_loc3_.col1.y * _loc4_ + _loc3_.col2.y * _loc5_);
         var _loc12_:Number = m_impulse.x;
         var _loc13_:Number = m_impulse.y;
         m_impulse.x += _loc10_;
         m_impulse.y += _loc11_;
         var _loc14_:Number = param1.dt * m_maxForce;
         if(m_impulse.LengthSquared() > _loc14_ * _loc14_)
         {
            m_impulse.Multiply(_loc14_ / m_impulse.Length());
         }
         _loc10_ = m_impulse.x - _loc12_;
         _loc11_ = m_impulse.y - _loc13_;
         _loc2_.m_linearVelocity.x += _loc2_.m_invMass * _loc10_;
         _loc2_.m_linearVelocity.y += _loc2_.m_invMass * _loc11_;
         _loc2_.m_angularVelocity += _loc2_.m_invI * (_loc6_ * _loc11_ - _loc7_ * _loc10_);
      }
      
      override b2internal function SolvePositionConstraints(param1:Number) : Boolean
      {
         return true;
      }
   }
}

