package Box2D.Dynamics.Contacts
{
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.*;
   
   use namespace b2internal;
   
   public class b2ContactSolver
   {
      
      private var m_step:b2TimeStep;
      
      private var m_allocator:*;
      
      b2internal var m_constraints:Array;
      
      private var m_constraintCount:int;
      
      public function b2ContactSolver(param1:b2TimeStep, param2:Array, param3:int, param4:*)
      {
         var _loc5_:b2Contact = null;
         var _loc6_:int = 0;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Mat22 = null;
         var _loc10_:b2Shape = null;
         var _loc11_:b2Shape = null;
         var _loc12_:b2Body = null;
         var _loc13_:b2Body = null;
         var _loc14_:int = 0;
         var _loc15_:Array = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:int = 0;
         var _loc25_:b2Manifold = null;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:b2ContactConstraint = null;
         var _loc29_:uint = 0;
         var _loc30_:b2ManifoldPoint = null;
         var _loc31_:b2ContactConstraintPoint = null;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc39_:Number = NaN;
         var _loc40_:Number = NaN;
         var _loc41_:Number = NaN;
         var _loc42_:Number = NaN;
         var _loc43_:Number = NaN;
         var _loc44_:Number = NaN;
         var _loc45_:Number = NaN;
         var _loc46_:Number = NaN;
         var _loc47_:Number = NaN;
         var _loc48_:b2ContactConstraintPoint = null;
         var _loc49_:b2ContactConstraintPoint = null;
         var _loc50_:Number = NaN;
         var _loc51_:Number = NaN;
         var _loc52_:Number = NaN;
         var _loc53_:Number = NaN;
         var _loc54_:Number = NaN;
         var _loc55_:Number = NaN;
         var _loc56_:Number = NaN;
         var _loc57_:Number = NaN;
         var _loc58_:Number = NaN;
         var _loc59_:Number = NaN;
         var _loc60_:Number = NaN;
         var _loc61_:Number = NaN;
         m_step = new b2TimeStep();
         b2internal::m_constraints = new Array();
         super();
         m_step.dt = param1.dt;
         m_step.inv_dt = param1.inv_dt;
         m_step.positionIterations = param1.positionIterations;
         m_step.velocityIterations = param1.velocityIterations;
         m_allocator = param4;
         m_constraintCount = 0;
         _loc6_ = 0;
         while(_loc6_ < param3)
         {
            _loc5_ = param2[_loc6_];
            m_constraintCount += _loc5_.m_manifoldCount;
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < m_constraintCount)
         {
            b2internal::m_constraints[_loc6_] = new b2ContactConstraint();
            _loc6_++;
         }
         var _loc9_:int = 0;
         _loc6_ = 0;
         while(_loc6_ < param3)
         {
            _loc5_ = param2[_loc6_];
            _loc10_ = _loc5_.m_shape1;
            _loc11_ = _loc5_.m_shape2;
            _loc12_ = _loc10_.m_body;
            _loc13_ = _loc11_.m_body;
            _loc14_ = _loc5_.m_manifoldCount;
            _loc15_ = _loc5_.GetManifolds();
            _loc16_ = b2Settings.b2MixFriction(_loc10_.GetFriction(),_loc11_.GetFriction());
            _loc17_ = b2Settings.b2MixRestitution(_loc10_.GetRestitution(),_loc11_.GetRestitution());
            _loc18_ = _loc12_.m_linearVelocity.x;
            _loc19_ = _loc12_.m_linearVelocity.y;
            _loc20_ = _loc13_.m_linearVelocity.x;
            _loc21_ = _loc13_.m_linearVelocity.y;
            _loc22_ = _loc12_.m_angularVelocity;
            _loc23_ = _loc13_.m_angularVelocity;
            _loc24_ = 0;
            while(_loc24_ < _loc14_)
            {
               _loc25_ = _loc15_[_loc24_];
               _loc26_ = _loc25_.normal.x;
               _loc27_ = _loc25_.normal.y;
               _loc28_ = b2internal::m_constraints[_loc9_];
               _loc28_.body1 = _loc12_;
               _loc28_.body2 = _loc13_;
               _loc28_.manifold = _loc25_;
               _loc28_.normal.x = _loc26_;
               _loc28_.normal.y = _loc27_;
               _loc28_.pointCount = _loc25_.pointCount;
               _loc28_.friction = _loc16_;
               _loc28_.restitution = _loc17_;
               _loc29_ = 0;
               while(_loc29_ < _loc28_.pointCount)
               {
                  _loc30_ = _loc25_.points[_loc29_];
                  _loc31_ = _loc28_.points[_loc29_];
                  _loc31_.normalImpulse = _loc30_.normalImpulse;
                  _loc31_.tangentImpulse = _loc30_.tangentImpulse;
                  _loc31_.separation = _loc30_.separation;
                  _loc31_.localAnchor1.SetV(_loc30_.localPoint1);
                  _loc31_.localAnchor2.SetV(_loc30_.localPoint2);
                  _loc8_ = _loc12_.m_xf.R;
                  _loc34_ = _loc30_.localPoint1.x - _loc12_.m_sweep.localCenter.x;
                  _loc35_ = _loc30_.localPoint1.y - _loc12_.m_sweep.localCenter.y;
                  _loc32_ = _loc8_.col1.x * _loc34_ + _loc8_.col2.x * _loc35_;
                  _loc35_ = _loc8_.col1.y * _loc34_ + _loc8_.col2.y * _loc35_;
                  _loc34_ = _loc32_;
                  _loc31_.r1.Set(_loc34_,_loc35_);
                  _loc8_ = _loc13_.m_xf.R;
                  _loc36_ = _loc30_.localPoint2.x - _loc13_.m_sweep.localCenter.x;
                  _loc37_ = _loc30_.localPoint2.y - _loc13_.m_sweep.localCenter.y;
                  _loc32_ = _loc8_.col1.x * _loc36_ + _loc8_.col2.x * _loc37_;
                  _loc37_ = _loc8_.col1.y * _loc36_ + _loc8_.col2.y * _loc37_;
                  _loc36_ = _loc32_;
                  _loc31_.r2.Set(_loc36_,_loc37_);
                  _loc38_ = _loc34_ * _loc27_ - _loc35_ * _loc26_;
                  _loc39_ = _loc36_ * _loc27_ - _loc37_ * _loc26_;
                  _loc38_ *= _loc38_;
                  _loc39_ *= _loc39_;
                  _loc40_ = _loc12_.m_invMass + _loc13_.m_invMass + _loc12_.m_invI * _loc38_ + _loc13_.m_invI * _loc39_;
                  _loc31_.normalMass = 1 / _loc40_;
                  _loc41_ = _loc12_.m_mass * _loc12_.m_invMass + _loc13_.m_mass * _loc13_.m_invMass;
                  _loc41_ = _loc41_ + (_loc12_.m_mass * _loc12_.m_invI * _loc38_ + _loc13_.m_mass * _loc13_.m_invI * _loc39_);
                  _loc31_.equalizedMass = 1 / _loc41_;
                  _loc42_ = _loc27_;
                  _loc43_ = -_loc26_;
                  _loc44_ = _loc34_ * _loc43_ - _loc35_ * _loc42_;
                  _loc45_ = _loc36_ * _loc43_ - _loc37_ * _loc42_;
                  _loc44_ *= _loc44_;
                  _loc45_ *= _loc45_;
                  _loc46_ = _loc12_.m_invMass + _loc13_.m_invMass + _loc12_.m_invI * _loc44_ + _loc13_.m_invI * _loc45_;
                  _loc31_.tangentMass = 1 / _loc46_;
                  _loc31_.velocityBias = 0;
                  if(_loc31_.separation > 0)
                  {
                     _loc31_.velocityBias = -60 * _loc31_.separation;
                  }
                  else
                  {
                     _loc32_ = _loc20_ + -_loc23_ * _loc37_ - _loc18_ - -_loc22_ * _loc35_;
                     _loc33_ = _loc21_ + _loc23_ * _loc36_ - _loc19_ - _loc22_ * _loc34_;
                     _loc47_ = _loc28_.normal.x * _loc32_ + _loc28_.normal.y * _loc33_;
                     if(_loc47_ < -b2Settings.b2_velocityThreshold)
                     {
                        _loc31_.velocityBias += -_loc28_.restitution * _loc47_;
                     }
                  }
                  _loc29_++;
               }
               if(_loc28_.pointCount == 2)
               {
                  _loc48_ = _loc28_.points[0];
                  _loc49_ = _loc28_.points[1];
                  _loc50_ = _loc12_.m_invMass;
                  _loc51_ = _loc12_.m_invI;
                  _loc52_ = _loc13_.m_invMass;
                  _loc53_ = _loc13_.m_invI;
                  _loc54_ = _loc48_.r1.x * _loc27_ - _loc48_.r1.y * _loc26_;
                  _loc55_ = _loc48_.r2.x * _loc27_ - _loc48_.r2.y * _loc26_;
                  _loc56_ = _loc49_.r1.x * _loc27_ - _loc49_.r1.y * _loc26_;
                  _loc57_ = _loc49_.r2.x * _loc27_ - _loc49_.r2.y * _loc26_;
                  _loc58_ = _loc50_ + _loc52_ + _loc51_ * _loc54_ * _loc54_ + _loc53_ * _loc55_ * _loc55_;
                  _loc59_ = _loc50_ + _loc52_ + _loc51_ * _loc56_ * _loc56_ + _loc53_ * _loc57_ * _loc57_;
                  _loc60_ = _loc50_ + _loc52_ + _loc51_ * _loc54_ * _loc56_ + _loc53_ * _loc55_ * _loc57_;
                  _loc61_ = 100;
                  if(_loc58_ * _loc58_ < _loc61_ * (_loc58_ * _loc59_ - _loc60_ * _loc60_))
                  {
                     _loc28_.K.col1.Set(_loc58_,_loc60_);
                     _loc28_.K.col2.Set(_loc60_,_loc59_);
                     _loc28_.K.GetInverse(_loc28_.normalMass);
                  }
                  else
                  {
                     _loc28_.pointCount = 1;
                  }
               }
               _loc9_++;
               _loc24_++;
            }
            _loc6_++;
         }
      }
      
      public function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc2_:b2Vec2 = null;
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Mat22 = null;
         var _loc6_:b2ContactConstraint = null;
         var _loc7_:b2Body = null;
         var _loc8_:b2Body = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:b2ContactConstraintPoint = null;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:b2ContactConstraintPoint = null;
         var _loc5_:int = 0;
         while(_loc5_ < m_constraintCount)
         {
            _loc6_ = m_constraints[_loc5_];
            _loc7_ = _loc6_.body1;
            _loc8_ = _loc6_.body2;
            _loc9_ = _loc7_.m_invMass;
            _loc10_ = _loc7_.m_invI;
            _loc11_ = _loc8_.m_invMass;
            _loc12_ = _loc8_.m_invI;
            _loc13_ = _loc6_.normal.x;
            _loc15_ = _loc14_ = _loc6_.normal.y;
            _loc16_ = -_loc13_;
            if(param1.warmStarting)
            {
               _loc19_ = _loc6_.pointCount;
               _loc18_ = 0;
               while(_loc18_ < _loc19_)
               {
                  _loc20_ = _loc6_.points[_loc18_];
                  _loc20_.normalImpulse *= param1.dtRatio;
                  _loc20_.tangentImpulse *= param1.dtRatio;
                  _loc21_ = _loc20_.normalImpulse * _loc13_ + _loc20_.tangentImpulse * _loc15_;
                  _loc22_ = _loc20_.normalImpulse * _loc14_ + _loc20_.tangentImpulse * _loc16_;
                  _loc7_.m_angularVelocity -= _loc10_ * (_loc20_.r1.x * _loc22_ - _loc20_.r1.y * _loc21_);
                  _loc7_.m_linearVelocity.x -= _loc9_ * _loc21_;
                  _loc7_.m_linearVelocity.y -= _loc9_ * _loc22_;
                  _loc8_.m_angularVelocity += _loc12_ * (_loc20_.r2.x * _loc22_ - _loc20_.r2.y * _loc21_);
                  _loc8_.m_linearVelocity.x += _loc11_ * _loc21_;
                  _loc8_.m_linearVelocity.y += _loc11_ * _loc22_;
                  _loc18_++;
               }
            }
            else
            {
               _loc19_ = _loc6_.pointCount;
               _loc18_ = 0;
               while(_loc18_ < _loc19_)
               {
                  _loc23_ = _loc6_.points[_loc18_];
                  _loc23_.normalImpulse = 0;
                  _loc23_.tangentImpulse = 0;
                  _loc18_++;
               }
            }
            _loc5_++;
         }
      }
      
      public function SolveVelocityConstraints() : void
      {
         var _loc1_:int = 0;
         var _loc2_:b2ContactConstraintPoint = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
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
         var _loc23_:b2Mat22 = null;
         var _loc24_:b2Vec2 = null;
         var _loc26_:b2ContactConstraint = null;
         var _loc27_:b2Body = null;
         var _loc28_:b2Body = null;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:b2Vec2 = null;
         var _loc32_:b2Vec2 = null;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc39_:Number = NaN;
         var _loc40_:Number = NaN;
         var _loc41_:Number = NaN;
         var _loc42_:Number = NaN;
         var _loc43_:int = 0;
         var _loc44_:Number = NaN;
         var _loc45_:b2ContactConstraintPoint = null;
         var _loc46_:b2ContactConstraintPoint = null;
         var _loc47_:Number = NaN;
         var _loc48_:Number = NaN;
         var _loc49_:Number = NaN;
         var _loc50_:Number = NaN;
         var _loc51_:Number = NaN;
         var _loc52_:Number = NaN;
         var _loc53_:Number = NaN;
         var _loc54_:Number = NaN;
         var _loc55_:Number = NaN;
         var _loc56_:Number = NaN;
         var _loc57_:Number = NaN;
         var _loc58_:Number = NaN;
         var _loc59_:Number = NaN;
         var _loc25_:int = 0;
         while(_loc25_ < m_constraintCount)
         {
            _loc26_ = m_constraints[_loc25_];
            _loc27_ = _loc26_.body1;
            _loc28_ = _loc26_.body2;
            _loc29_ = _loc27_.m_angularVelocity;
            _loc30_ = _loc28_.m_angularVelocity;
            _loc31_ = _loc27_.m_linearVelocity;
            _loc32_ = _loc28_.m_linearVelocity;
            _loc33_ = _loc27_.m_invMass;
            _loc34_ = _loc27_.m_invI;
            _loc35_ = _loc28_.m_invMass;
            _loc36_ = _loc28_.m_invI;
            _loc37_ = _loc26_.normal.x;
            _loc39_ = _loc38_ = _loc26_.normal.y;
            _loc40_ = -_loc37_;
            _loc41_ = _loc26_.friction;
            _loc43_ = _loc26_.pointCount;
            if(_loc26_.pointCount == 1)
            {
               _loc2_ = _loc26_.points[0];
               _loc7_ = _loc32_.x + -_loc30_ * _loc2_.r2.y - _loc31_.x - -_loc29_ * _loc2_.r1.y;
               _loc8_ = _loc32_.y + _loc30_ * _loc2_.r2.x - _loc31_.y - _loc29_ * _loc2_.r1.x;
               _loc9_ = _loc7_ * _loc37_ + _loc8_ * _loc38_;
               _loc11_ = -_loc2_.normalMass * (_loc9_ - _loc2_.velocityBias);
               _loc10_ = _loc7_ * _loc39_ + _loc8_ * _loc40_;
               _loc12_ = _loc2_.tangentMass * -_loc10_;
               _loc13_ = b2Math.b2Max(_loc2_.normalImpulse + _loc11_,0);
               _loc11_ = _loc13_ - _loc2_.normalImpulse;
               _loc44_ = _loc41_ * _loc2_.normalImpulse;
               _loc14_ = b2Math.b2Clamp(_loc2_.tangentImpulse + _loc12_,-_loc44_,_loc44_);
               _loc12_ = _loc14_ - _loc2_.tangentImpulse;
               _loc15_ = _loc11_ * _loc37_ + _loc12_ * _loc39_;
               _loc16_ = _loc11_ * _loc38_ + _loc12_ * _loc40_;
               _loc31_.x -= _loc33_ * _loc15_;
               _loc31_.y -= _loc33_ * _loc16_;
               _loc29_ -= _loc34_ * (_loc2_.r1.x * _loc16_ - _loc2_.r1.y * _loc15_);
               _loc32_.x += _loc35_ * _loc15_;
               _loc32_.y += _loc35_ * _loc16_;
               _loc30_ += _loc36_ * (_loc2_.r2.x * _loc16_ - _loc2_.r2.y * _loc15_);
               _loc2_.normalImpulse = _loc13_;
               _loc2_.tangentImpulse = _loc14_;
            }
            else
            {
               _loc45_ = _loc26_.points[0];
               _loc46_ = _loc26_.points[1];
               _loc47_ = _loc45_.normalImpulse;
               _loc48_ = _loc46_.normalImpulse;
               _loc49_ = _loc32_.x - _loc30_ * _loc45_.r2.y - _loc31_.x + _loc29_ * _loc45_.r1.y;
               _loc50_ = _loc32_.y + _loc30_ * _loc45_.r2.x - _loc31_.y - _loc29_ * _loc45_.r1.x;
               _loc51_ = _loc32_.x - _loc30_ * _loc46_.r2.y - _loc31_.x + _loc29_ * _loc46_.r1.y;
               _loc52_ = _loc32_.y + _loc30_ * _loc46_.r2.x - _loc31_.y - _loc29_ * _loc46_.r1.x;
               _loc53_ = _loc49_ * _loc37_ + _loc50_ * _loc38_;
               _loc54_ = _loc51_ * _loc37_ + _loc52_ * _loc38_;
               _loc55_ = _loc53_ - _loc45_.velocityBias;
               _loc56_ = _loc54_ - _loc46_.velocityBias;
               _loc23_ = _loc26_.K;
               _loc55_ -= _loc23_.col1.x * _loc47_ + _loc23_.col2.x * _loc48_;
               _loc56_ -= _loc23_.col1.y * _loc47_ + _loc23_.col2.y * _loc48_;
               _loc57_ = 0.001;
               _loc23_ = _loc26_.normalMass;
               _loc58_ = -(_loc23_.col1.x * _loc55_ + _loc23_.col2.x * _loc56_);
               _loc59_ = -(_loc23_.col1.y * _loc55_ + _loc23_.col2.y * _loc56_);
               if(_loc58_ >= 0 && _loc59_ >= 0)
               {
                  _loc17_ = _loc58_ - _loc47_;
                  _loc18_ = _loc59_ - _loc48_;
                  _loc19_ = _loc17_ * _loc37_;
                  _loc20_ = _loc17_ * _loc38_;
                  _loc21_ = _loc18_ * _loc37_;
                  _loc22_ = _loc18_ * _loc38_;
                  _loc31_.x -= _loc33_ * (_loc19_ + _loc21_);
                  _loc31_.y -= _loc33_ * (_loc20_ + _loc22_);
                  _loc29_ -= _loc34_ * (_loc45_.r1.x * _loc20_ - _loc45_.r1.y * _loc19_ + _loc46_.r1.x * _loc22_ - _loc46_.r1.y * _loc21_);
                  _loc32_.x += _loc35_ * (_loc19_ + _loc21_);
                  _loc32_.y += _loc35_ * (_loc20_ + _loc22_);
                  _loc30_ += _loc36_ * (_loc45_.r2.x * _loc20_ - _loc45_.r2.y * _loc19_ + _loc46_.r2.x * _loc22_ - _loc46_.r2.y * _loc21_);
                  _loc45_.normalImpulse = _loc58_;
                  _loc46_.normalImpulse = _loc59_;
               }
               else
               {
                  _loc58_ = -_loc45_.normalMass * _loc55_;
                  _loc59_ = 0;
                  _loc53_ = 0;
                  _loc54_ = _loc26_.K.col1.y * _loc58_ + _loc56_;
                  if(_loc58_ >= 0 && _loc54_ >= 0)
                  {
                     _loc17_ = _loc58_ - _loc47_;
                     _loc18_ = _loc59_ - _loc48_;
                     _loc19_ = _loc17_ * _loc37_;
                     _loc20_ = _loc17_ * _loc38_;
                     _loc21_ = _loc18_ * _loc37_;
                     _loc22_ = _loc18_ * _loc38_;
                     _loc31_.x -= _loc33_ * (_loc19_ + _loc21_);
                     _loc31_.y -= _loc33_ * (_loc20_ + _loc22_);
                     _loc29_ -= _loc34_ * (_loc45_.r1.x * _loc20_ - _loc45_.r1.y * _loc19_ + _loc46_.r1.x * _loc22_ - _loc46_.r1.y * _loc21_);
                     _loc32_.x += _loc35_ * (_loc19_ + _loc21_);
                     _loc32_.y += _loc35_ * (_loc20_ + _loc22_);
                     _loc30_ += _loc36_ * (_loc45_.r2.x * _loc20_ - _loc45_.r2.y * _loc19_ + _loc46_.r2.x * _loc22_ - _loc46_.r2.y * _loc21_);
                     _loc45_.normalImpulse = _loc58_;
                     _loc46_.normalImpulse = _loc59_;
                  }
                  else
                  {
                     _loc58_ = 0;
                     _loc59_ = -_loc46_.normalMass * _loc56_;
                     _loc53_ = _loc26_.K.col2.x * _loc59_ + _loc55_;
                     _loc54_ = 0;
                     if(_loc59_ >= 0 && _loc53_ >= 0)
                     {
                        _loc17_ = _loc58_ - _loc47_;
                        _loc18_ = _loc59_ - _loc48_;
                        _loc19_ = _loc17_ * _loc37_;
                        _loc20_ = _loc17_ * _loc38_;
                        _loc21_ = _loc18_ * _loc37_;
                        _loc22_ = _loc18_ * _loc38_;
                        _loc31_.x -= _loc33_ * (_loc19_ + _loc21_);
                        _loc31_.y -= _loc33_ * (_loc20_ + _loc22_);
                        _loc29_ -= _loc34_ * (_loc45_.r1.x * _loc20_ - _loc45_.r1.y * _loc19_ + _loc46_.r1.x * _loc22_ - _loc46_.r1.y * _loc21_);
                        _loc32_.x += _loc35_ * (_loc19_ + _loc21_);
                        _loc32_.y += _loc35_ * (_loc20_ + _loc22_);
                        _loc30_ += _loc36_ * (_loc45_.r2.x * _loc20_ - _loc45_.r2.y * _loc19_ + _loc46_.r2.x * _loc22_ - _loc46_.r2.y * _loc21_);
                        _loc45_.normalImpulse = _loc58_;
                        _loc46_.normalImpulse = _loc59_;
                     }
                     else
                     {
                        _loc58_ = 0;
                        _loc59_ = 0;
                        _loc53_ = _loc55_;
                        _loc54_ = _loc56_;
                        if(_loc53_ >= 0 && _loc54_ >= 0)
                        {
                           _loc17_ = _loc58_ - _loc47_;
                           _loc18_ = _loc59_ - _loc48_;
                           _loc19_ = _loc17_ * _loc37_;
                           _loc20_ = _loc17_ * _loc38_;
                           _loc21_ = _loc18_ * _loc37_;
                           _loc22_ = _loc18_ * _loc38_;
                           _loc31_.x -= _loc33_ * (_loc19_ + _loc21_);
                           _loc31_.y -= _loc33_ * (_loc20_ + _loc22_);
                           _loc29_ -= _loc34_ * (_loc45_.r1.x * _loc20_ - _loc45_.r1.y * _loc19_ + _loc46_.r1.x * _loc22_ - _loc46_.r1.y * _loc21_);
                           _loc32_.x += _loc35_ * (_loc19_ + _loc21_);
                           _loc32_.y += _loc35_ * (_loc20_ + _loc22_);
                           _loc30_ += _loc36_ * (_loc45_.r2.x * _loc20_ - _loc45_.r2.y * _loc19_ + _loc46_.r2.x * _loc22_ - _loc46_.r2.y * _loc21_);
                           _loc45_.normalImpulse = _loc58_;
                           _loc46_.normalImpulse = _loc59_;
                        }
                     }
                  }
               }
               _loc1_ = 0;
               while(_loc1_ < _loc26_.pointCount)
               {
                  _loc2_ = _loc26_.points[_loc1_];
                  _loc7_ = _loc32_.x - _loc30_ * _loc2_.r2.y - _loc31_.x + _loc29_ * _loc2_.r1.y;
                  _loc8_ = _loc32_.y + _loc30_ * _loc2_.r2.x - _loc31_.y - _loc29_ * _loc2_.r1.x;
                  _loc10_ = _loc7_ * _loc39_ + _loc8_ * _loc40_;
                  _loc12_ = _loc2_.tangentMass * -_loc10_;
                  _loc44_ = _loc41_ * _loc2_.normalImpulse;
                  _loc14_ = b2Math.b2Clamp(_loc2_.tangentImpulse + _loc12_,-_loc44_,_loc44_);
                  _loc12_ = _loc14_ - _loc2_.tangentImpulse;
                  _loc15_ = _loc12_ * _loc39_;
                  _loc16_ = _loc12_ * _loc40_;
                  _loc31_.x -= _loc33_ * _loc15_;
                  _loc31_.y -= _loc33_ * _loc16_;
                  _loc29_ -= _loc34_ * (_loc2_.r1.x * _loc16_ - _loc2_.r1.y * _loc15_);
                  _loc32_.x += _loc35_ * _loc15_;
                  _loc32_.y += _loc35_ * _loc16_;
                  _loc30_ += _loc36_ * (_loc2_.r2.x * _loc16_ - _loc2_.r2.y * _loc15_);
                  _loc2_.tangentImpulse = _loc14_;
                  _loc1_++;
               }
            }
            _loc27_.m_angularVelocity = _loc29_;
            _loc28_.m_angularVelocity = _loc30_;
            _loc25_++;
         }
      }
      
      public function FinalizeVelocityConstraints() : void
      {
         var _loc2_:b2ContactConstraint = null;
         var _loc3_:b2Manifold = null;
         var _loc4_:int = 0;
         var _loc5_:b2ManifoldPoint = null;
         var _loc6_:b2ContactConstraintPoint = null;
         var _loc1_:int = 0;
         while(_loc1_ < m_constraintCount)
         {
            _loc2_ = m_constraints[_loc1_];
            _loc3_ = _loc2_.manifold;
            _loc4_ = 0;
            while(_loc4_ < _loc2_.pointCount)
            {
               _loc5_ = _loc3_.points[_loc4_];
               _loc6_ = _loc2_.points[_loc4_];
               _loc5_.normalImpulse = _loc6_.normalImpulse;
               _loc5_.tangentImpulse = _loc6_.tangentImpulse;
               _loc4_++;
            }
            _loc1_++;
         }
      }
      
      public function SolvePositionConstraints(param1:Number) : Boolean
      {
         var _loc3_:b2Mat22 = null;
         var _loc4_:b2Vec2 = null;
         var _loc6_:b2ContactConstraint = null;
         var _loc7_:b2Body = null;
         var _loc8_:b2Body = null;
         var _loc9_:b2Vec2 = null;
         var _loc10_:Number = NaN;
         var _loc11_:b2Vec2 = null;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:b2ContactConstraintPoint = null;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc36_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc2_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < m_constraintCount)
         {
            _loc6_ = m_constraints[_loc5_];
            _loc7_ = _loc6_.body1;
            _loc8_ = _loc6_.body2;
            _loc9_ = _loc7_.m_sweep.c;
            _loc10_ = _loc7_.m_sweep.a;
            _loc11_ = _loc8_.m_sweep.c;
            _loc12_ = _loc8_.m_sweep.a;
            _loc13_ = _loc7_.m_mass * _loc7_.m_invMass;
            _loc14_ = _loc7_.m_mass * _loc7_.m_invI;
            _loc15_ = _loc8_.m_mass * _loc8_.m_invMass;
            _loc16_ = _loc8_.m_mass * _loc8_.m_invI;
            _loc17_ = _loc6_.normal.x;
            _loc18_ = _loc6_.normal.y;
            _loc19_ = _loc6_.pointCount;
            _loc20_ = 0;
            while(_loc20_ < _loc19_)
            {
               _loc21_ = _loc6_.points[_loc20_];
               _loc3_ = _loc7_.m_xf.R;
               _loc4_ = _loc7_.m_sweep.localCenter;
               _loc22_ = _loc21_.localAnchor1.x - _loc4_.x;
               _loc23_ = _loc21_.localAnchor1.y - _loc4_.y;
               _loc26_ = _loc3_.col1.x * _loc22_ + _loc3_.col2.x * _loc23_;
               _loc23_ = _loc3_.col1.y * _loc22_ + _loc3_.col2.y * _loc23_;
               _loc22_ = _loc26_;
               _loc3_ = _loc8_.m_xf.R;
               _loc4_ = _loc8_.m_sweep.localCenter;
               _loc24_ = _loc21_.localAnchor2.x - _loc4_.x;
               _loc25_ = _loc21_.localAnchor2.y - _loc4_.y;
               _loc26_ = _loc3_.col1.x * _loc24_ + _loc3_.col2.x * _loc25_;
               _loc25_ = _loc3_.col1.y * _loc24_ + _loc3_.col2.y * _loc25_;
               _loc24_ = _loc26_;
               _loc27_ = _loc9_.x + _loc22_;
               _loc28_ = _loc9_.y + _loc23_;
               _loc29_ = _loc11_.x + _loc24_;
               _loc30_ = _loc11_.y + _loc25_;
               _loc31_ = _loc29_ - _loc27_;
               _loc32_ = _loc30_ - _loc28_;
               _loc33_ = _loc31_ * _loc17_ + _loc32_ * _loc18_ + _loc21_.separation;
               _loc2_ = b2Math.b2Min(_loc2_,_loc33_);
               _loc34_ = param1 * b2Math.b2Clamp(_loc33_ + b2Settings.b2_linearSlop,-b2Settings.b2_maxLinearCorrection,0);
               _loc35_ = -_loc21_.equalizedMass * _loc34_;
               _loc36_ = _loc35_ * _loc17_;
               _loc37_ = _loc35_ * _loc18_;
               _loc9_.x -= _loc13_ * _loc36_;
               _loc9_.y -= _loc13_ * _loc37_;
               _loc10_ -= _loc14_ * (_loc22_ * _loc37_ - _loc23_ * _loc36_);
               _loc7_.m_sweep.a = _loc10_;
               _loc7_.SynchronizeTransform();
               _loc11_.x += _loc15_ * _loc36_;
               _loc11_.y += _loc15_ * _loc37_;
               _loc12_ += _loc16_ * (_loc24_ * _loc37_ - _loc25_ * _loc36_);
               _loc8_.m_sweep.a = _loc12_;
               _loc8_.SynchronizeTransform();
               _loc20_++;
            }
            _loc5_++;
         }
         return _loc2_ >= -1.5 * b2Settings.b2_linearSlop;
      }
   }
}

