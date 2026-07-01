package Box2D.Dynamics
{
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.Contacts.*;
   import Box2D.Dynamics.Controllers.b2ControllerEdge;
   import Box2D.Dynamics.Joints.*;
   
   use namespace b2internal;
   
   public class b2Body
   {
      
      private static var s_massData:b2MassData = new b2MassData();
      
      private static var s_xf1:b2XForm = new b2XForm();
      
      b2internal static var e_frozenFlag:uint = 2;
      
      b2internal static var e_islandFlag:uint = 4;
      
      b2internal static var e_sleepFlag:uint = 8;
      
      b2internal static var e_allowSleepFlag:uint = 16;
      
      b2internal static var e_bulletFlag:uint = 32;
      
      b2internal static var e_fixedRotationFlag:uint = 64;
      
      b2internal static var e_staticType:uint = 1;
      
      b2internal static var e_dynamicType:uint = 2;
      
      b2internal static var e_maxTypes:uint = 3;
      
      b2internal var m_flags:uint;
      
      private var m_type:int;
      
      b2internal var m_islandIndex:int;
      
      b2internal var m_xf:b2XForm = new b2XForm();
      
      b2internal var m_sweep:b2Sweep = new b2Sweep();
      
      b2internal var m_linearVelocity:b2Vec2 = new b2Vec2();
      
      b2internal var m_angularVelocity:Number;
      
      b2internal var m_force:b2Vec2 = new b2Vec2();
      
      b2internal var m_torque:Number;
      
      b2internal var m_world:b2World;
      
      b2internal var m_prev:b2Body;
      
      b2internal var m_next:b2Body;
      
      b2internal var m_shapeList:b2Shape;
      
      b2internal var m_shapeCount:int;
      
      b2internal var m_controllerList:b2ControllerEdge;
      
      b2internal var m_controllerCount:int;
      
      b2internal var m_jointList:b2JointEdge;
      
      b2internal var m_contactList:b2ContactEdge;
      
      b2internal var m_mass:Number;
      
      b2internal var m_invMass:Number;
      
      b2internal var m_I:Number;
      
      b2internal var m_invI:Number;
      
      b2internal var m_linearDamping:Number;
      
      b2internal var m_angularDamping:Number;
      
      b2internal var m_sleepTime:Number;
      
      public var m_userData:*;
      
      public function b2Body(param1:b2BodyDef, param2:b2World)
      {
         super();
         b2internal::m_flags = 0;
         if(param1.isBullet)
         {
            b2internal::m_flags |= b2internal::e_bulletFlag;
         }
         if(param1.fixedRotation)
         {
            b2internal::m_flags |= b2internal::e_fixedRotationFlag;
         }
         if(param1.allowSleep)
         {
            b2internal::m_flags |= b2internal::e_allowSleepFlag;
         }
         if(param1.isSleeping)
         {
            b2internal::m_flags |= b2internal::e_sleepFlag;
         }
         b2internal::m_world = param2;
         b2internal::m_xf.position.SetV(param1.position);
         b2internal::m_xf.R.Set(param1.angle);
         b2internal::m_sweep.localCenter.SetV(param1.massData.center);
         b2internal::m_sweep.t0 = 1;
         b2internal::m_sweep.a0 = b2internal::m_sweep.a = param1.angle;
         var _loc3_:b2Mat22 = b2internal::m_xf.R;
         var _loc4_:b2Vec2 = b2internal::m_sweep.localCenter;
         b2internal::m_sweep.c.x = _loc3_.col1.x * _loc4_.x + _loc3_.col2.x * _loc4_.y;
         b2internal::m_sweep.c.y = _loc3_.col1.y * _loc4_.x + _loc3_.col2.y * _loc4_.y;
         b2internal::m_sweep.c.x += b2internal::m_xf.position.x;
         b2internal::m_sweep.c.y += b2internal::m_xf.position.y;
         b2internal::m_sweep.c0.SetV(b2internal::m_sweep.c);
         b2internal::m_jointList = null;
         b2internal::m_controllerList = null;
         b2internal::m_contactList = null;
         b2internal::m_controllerCount = 0;
         b2internal::m_prev = null;
         b2internal::m_next = null;
         b2internal::m_linearDamping = param1.linearDamping;
         b2internal::m_angularDamping = param1.angularDamping;
         b2internal::m_force.Set(0,0);
         b2internal::m_torque = 0;
         b2internal::m_linearVelocity.SetZero();
         b2internal::m_angularVelocity = 0;
         b2internal::m_sleepTime = 0;
         b2internal::m_invMass = 0;
         b2internal::m_I = 0;
         b2internal::m_invI = 0;
         b2internal::m_mass = param1.massData.mass;
         if(b2internal::m_mass > 0)
         {
            b2internal::m_invMass = 1 / b2internal::m_mass;
         }
         if((b2internal::m_flags & b2Body.e_fixedRotationFlag) == 0)
         {
            b2internal::m_I = param1.massData.I;
         }
         if(b2internal::m_I > 0)
         {
            b2internal::m_invI = 1 / b2internal::m_I;
         }
         if(b2internal::m_invMass == 0 && b2internal::m_invI == 0)
         {
            m_type = b2internal::e_staticType;
         }
         else
         {
            m_type = b2internal::e_dynamicType;
         }
         m_userData = param1.userData;
         b2internal::m_shapeList = null;
         b2internal::m_shapeCount = 0;
      }
      
      private function connectEdges(param1:b2EdgeShape, param2:b2EdgeShape, param3:Number) : Number
      {
         var _loc4_:Number = Math.atan2(param2.GetDirectionVector().y,param2.GetDirectionVector().x);
         var _loc5_:Number = Math.tan((_loc4_ - param3) * 0.5);
         var _loc6_:b2Vec2 = b2Math.MulFV(_loc5_,param2.GetDirectionVector());
         _loc6_ = b2Math.SubtractVV(_loc6_,param2.GetNormalVector());
         _loc6_ = b2Math.MulFV(b2Settings.b2_toiSlop,_loc6_);
         _loc6_ = b2Math.AddVV(_loc6_,param2.GetVertex1());
         var _loc7_:b2Vec2 = b2Math.AddVV(param1.GetDirectionVector(),param2.GetDirectionVector());
         _loc7_.Normalize();
         var _loc8_:Boolean = b2Math.b2Dot(param1.GetDirectionVector(),param2.GetNormalVector()) > 0;
         param1.SetNextEdge(param2,_loc6_,_loc7_,_loc8_);
         param2.SetPrevEdge(param1,_loc6_,_loc7_,_loc8_);
         return _loc4_;
      }
      
      public function CreateShape(param1:b2ShapeDef) : b2Shape
      {
         var _loc3_:b2EdgeChainDef = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2Vec2 = null;
         var _loc6_:int = 0;
         var _loc7_:b2EdgeShape = null;
         var _loc8_:b2EdgeShape = null;
         var _loc9_:b2EdgeShape = null;
         var _loc10_:Number = NaN;
         if(m_world.m_lock == true)
         {
            return null;
         }
         if(param1.type == b2Shape.e_edgeShape)
         {
            _loc3_ = param1 as b2EdgeChainDef;
            if(_loc3_.isALoop)
            {
               _loc4_ = _loc3_.vertices[_loc3_.vertexCount - 1];
               _loc6_ = 0;
            }
            else
            {
               _loc4_ = _loc3_.vertices[0];
               _loc6_ = 1;
            }
            _loc7_ = null;
            _loc8_ = null;
            _loc9_ = null;
            _loc10_ = 0;
            while(_loc6_ < _loc3_.vertexCount)
            {
               _loc5_ = _loc3_.vertices[_loc6_];
               _loc9_ = new b2EdgeShape(_loc4_,_loc5_,param1);
               _loc9_.m_next = m_shapeList;
               m_shapeList = _loc9_;
               ++m_shapeCount;
               _loc9_.m_body = this;
               _loc9_.CreateProxy(m_world.m_broadPhase,m_xf);
               _loc9_.UpdateSweepRadius(m_sweep.localCenter);
               if(_loc8_ == null)
               {
                  _loc7_ = _loc9_;
                  _loc10_ = Math.atan2(_loc9_.GetDirectionVector().y,_loc9_.GetDirectionVector().x);
               }
               else
               {
                  _loc10_ = connectEdges(_loc8_,_loc9_,_loc10_);
               }
               _loc8_ = _loc9_;
               _loc4_ = _loc5_;
               _loc6_++;
            }
            if(_loc3_.isALoop)
            {
               connectEdges(_loc8_,_loc7_,_loc10_);
            }
            return _loc7_;
         }
         var _loc2_:b2Shape = b2Shape.Create(param1,m_world.m_blockAllocator);
         _loc2_.m_next = m_shapeList;
         m_shapeList = _loc2_;
         ++m_shapeCount;
         _loc2_.m_body = this;
         _loc2_.CreateProxy(m_world.m_broadPhase,m_xf);
         _loc2_.UpdateSweepRadius(m_sweep.localCenter);
         return _loc2_;
      }
      
      public function DestroyShape(param1:b2Shape) : void
      {
         if(m_world.m_lock == true)
         {
            return;
         }
         param1.DestroyProxy(m_world.m_broadPhase);
         var _loc2_:b2Shape = m_shapeList;
         var _loc3_:b2Shape = null;
         var _loc4_:Boolean = false;
         while(_loc2_ != null)
         {
            if(_loc2_ == param1)
            {
               if(_loc3_)
               {
                  _loc3_.m_next = param1.m_next;
               }
               else
               {
                  m_shapeList = param1.m_next;
               }
               _loc4_ = true;
               break;
            }
            _loc3_ = _loc2_;
            _loc2_ = _loc2_.m_next;
         }
         param1.m_body = null;
         param1.m_next = null;
         --m_shapeCount;
         b2Shape.Destroy(param1,m_world.m_blockAllocator);
      }
      
      public function SetMass(param1:b2MassData) : void
      {
         var _loc2_:b2Shape = null;
         if(m_world.m_lock == true)
         {
            return;
         }
         m_invMass = 0;
         m_I = 0;
         m_invI = 0;
         m_mass = param1.mass;
         if(m_mass > 0)
         {
            m_invMass = 1 / m_mass;
         }
         if((m_flags & b2Body.e_fixedRotationFlag) == 0)
         {
            m_I = param1.I;
         }
         if(m_I > 0)
         {
            m_invI = 1 / m_I;
         }
         m_sweep.localCenter.SetV(param1.center);
         var _loc3_:b2Mat22 = m_xf.R;
         var _loc4_:b2Vec2 = m_sweep.localCenter;
         m_sweep.c.x = _loc3_.col1.x * _loc4_.x + _loc3_.col2.x * _loc4_.y;
         m_sweep.c.y = _loc3_.col1.y * _loc4_.x + _loc3_.col2.y * _loc4_.y;
         m_sweep.c.x += m_xf.position.x;
         m_sweep.c.y += m_xf.position.y;
         m_sweep.c0.SetV(m_sweep.c);
         _loc2_ = m_shapeList;
         while(_loc2_)
         {
            _loc2_.UpdateSweepRadius(m_sweep.localCenter);
            _loc2_ = _loc2_.m_next;
         }
         var _loc5_:int = m_type;
         if(m_invMass == 0 && m_invI == 0)
         {
            m_type = e_staticType;
         }
         else
         {
            m_type = e_dynamicType;
         }
         if(_loc5_ != m_type)
         {
            _loc2_ = m_shapeList;
            while(_loc2_)
            {
               _loc2_.RefilterProxy(m_world.m_broadPhase,m_xf);
               _loc2_ = _loc2_.m_next;
            }
         }
      }
      
      public function SetMassFromShapes() : void
      {
         var _loc1_:b2Shape = null;
         if(m_world.m_lock == true)
         {
            return;
         }
         m_mass = 0;
         m_invMass = 0;
         m_I = 0;
         m_invI = 0;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:b2MassData = s_massData;
         _loc1_ = m_shapeList;
         while(_loc1_)
         {
            _loc1_.ComputeMass(_loc4_);
            m_mass += _loc4_.mass;
            _loc2_ += _loc4_.mass * _loc4_.center.x;
            _loc3_ += _loc4_.mass * _loc4_.center.y;
            m_I += _loc4_.I;
            _loc1_ = _loc1_.m_next;
         }
         if(m_mass > 0)
         {
            m_invMass = 1 / m_mass;
            _loc2_ *= m_invMass;
            _loc3_ *= m_invMass;
         }
         if(m_I > 0 && (m_flags & e_fixedRotationFlag) == 0)
         {
            m_I -= m_mass * (_loc2_ * _loc2_ + _loc3_ * _loc3_);
            m_invI = 1 / m_I;
         }
         else
         {
            m_I = 0;
            m_invI = 0;
         }
         m_sweep.localCenter.Set(_loc2_,_loc3_);
         var _loc5_:b2Mat22 = m_xf.R;
         var _loc6_:b2Vec2 = m_sweep.localCenter;
         m_sweep.c.x = _loc5_.col1.x * _loc6_.x + _loc5_.col2.x * _loc6_.y;
         m_sweep.c.y = _loc5_.col1.y * _loc6_.x + _loc5_.col2.y * _loc6_.y;
         m_sweep.c.x += m_xf.position.x;
         m_sweep.c.y += m_xf.position.y;
         m_sweep.c0.SetV(m_sweep.c);
         _loc1_ = m_shapeList;
         while(_loc1_)
         {
            _loc1_.UpdateSweepRadius(m_sweep.localCenter);
            _loc1_ = _loc1_.m_next;
         }
         var _loc7_:int = m_type;
         if(m_invMass == 0 && m_invI == 0)
         {
            m_type = e_staticType;
         }
         else
         {
            m_type = e_dynamicType;
         }
         if(_loc7_ != m_type)
         {
            _loc1_ = m_shapeList;
            while(_loc1_)
            {
               _loc1_.RefilterProxy(m_world.m_broadPhase,m_xf);
               _loc1_ = _loc1_.m_next;
            }
         }
      }
      
      public function SetXForm(param1:b2Vec2, param2:Number) : Boolean
      {
         var _loc3_:b2Shape = null;
         var _loc7_:Boolean = false;
         if(m_world.m_lock == true)
         {
            return true;
         }
         if(IsFrozen())
         {
            return false;
         }
         m_xf.R.Set(param2);
         m_xf.position.SetV(param1);
         var _loc4_:b2Mat22 = m_xf.R;
         var _loc5_:b2Vec2 = m_sweep.localCenter;
         m_sweep.c.x = _loc4_.col1.x * _loc5_.x + _loc4_.col2.x * _loc5_.y;
         m_sweep.c.y = _loc4_.col1.y * _loc5_.x + _loc4_.col2.y * _loc5_.y;
         m_sweep.c.x += m_xf.position.x;
         m_sweep.c.y += m_xf.position.y;
         m_sweep.c0.SetV(m_sweep.c);
         m_sweep.a0 = m_sweep.a = param2;
         var _loc6_:Boolean = false;
         _loc3_ = m_shapeList;
         while(_loc3_)
         {
            _loc7_ = _loc3_.Synchronize(m_world.m_broadPhase,m_xf,m_xf);
            if(_loc7_ == false)
            {
               _loc6_ = true;
               break;
            }
            _loc3_ = _loc3_.m_next;
         }
         if(_loc6_ == true)
         {
            m_flags |= e_frozenFlag;
            m_linearVelocity.SetZero();
            m_angularVelocity = 0;
            _loc3_ = m_shapeList;
            while(_loc3_)
            {
               _loc3_.DestroyProxy(m_world.m_broadPhase);
               _loc3_ = _loc3_.m_next;
            }
            return false;
         }
         m_world.m_broadPhase.Commit();
         return true;
      }
      
      public function GetXForm() : b2XForm
      {
         return m_xf;
      }
      
      public function GetPosition() : b2Vec2
      {
         return m_xf.position;
      }
      
      public function GetAngle() : Number
      {
         return m_sweep.a;
      }
      
      public function GetWorldCenter() : b2Vec2
      {
         return m_sweep.c;
      }
      
      public function GetLocalCenter() : b2Vec2
      {
         return m_sweep.localCenter;
      }
      
      public function SetLinearVelocity(param1:b2Vec2) : void
      {
         m_linearVelocity.SetV(param1);
      }
      
      public function GetLinearVelocity() : b2Vec2
      {
         return m_linearVelocity;
      }
      
      public function SetAngularVelocity(param1:Number) : void
      {
         m_angularVelocity = param1;
      }
      
      public function GetAngularVelocity() : Number
      {
         return m_angularVelocity;
      }
      
      public function ApplyForce(param1:b2Vec2, param2:b2Vec2) : void
      {
         if(IsSleeping())
         {
            WakeUp();
         }
         m_force.x += param1.x;
         m_force.y += param1.y;
         m_torque += (param2.x - m_sweep.c.x) * param1.y - (param2.y - m_sweep.c.y) * param1.x;
      }
      
      public function ApplyTorque(param1:Number) : void
      {
         if(IsSleeping())
         {
            WakeUp();
         }
         m_torque += param1;
      }
      
      public function ApplyImpulse(param1:b2Vec2, param2:b2Vec2) : void
      {
         if(IsSleeping())
         {
            WakeUp();
         }
         m_linearVelocity.x += m_invMass * param1.x;
         m_linearVelocity.y += m_invMass * param1.y;
         m_angularVelocity += m_invI * ((param2.x - m_sweep.c.x) * param1.y - (param2.y - m_sweep.c.y) * param1.x);
      }
      
      public function GetMass() : Number
      {
         return m_mass;
      }
      
      public function GetInertia() : Number
      {
         return m_I;
      }
      
      public function GetWorldPoint(param1:b2Vec2) : b2Vec2
      {
         var _loc2_:b2Mat22 = m_xf.R;
         var _loc3_:b2Vec2 = new b2Vec2(_loc2_.col1.x * param1.x + _loc2_.col2.x * param1.y,_loc2_.col1.y * param1.x + _loc2_.col2.y * param1.y);
         _loc3_.x += m_xf.position.x;
         _loc3_.y += m_xf.position.y;
         return _loc3_;
      }
      
      public function GetWorldVector(param1:b2Vec2) : b2Vec2
      {
         return b2Math.b2MulMV(m_xf.R,param1);
      }
      
      public function GetLocalPoint(param1:b2Vec2) : b2Vec2
      {
         return b2Math.b2MulXT(m_xf,param1);
      }
      
      public function GetLocalVector(param1:b2Vec2) : b2Vec2
      {
         return b2Math.b2MulTMV(m_xf.R,param1);
      }
      
      public function GetLinearVelocityFromWorldPoint(param1:b2Vec2) : b2Vec2
      {
         return new b2Vec2(m_linearVelocity.x - m_angularVelocity * (param1.y - m_sweep.c.y),m_linearVelocity.y + m_angularVelocity * (param1.x - m_sweep.c.x));
      }
      
      public function GetLinearVelocityFromLocalPoint(param1:b2Vec2) : b2Vec2
      {
         var _loc2_:b2Mat22 = m_xf.R;
         var _loc3_:b2Vec2 = new b2Vec2(_loc2_.col1.x * param1.x + _loc2_.col2.x * param1.y,_loc2_.col1.y * param1.x + _loc2_.col2.y * param1.y);
         _loc3_.x += m_xf.position.x;
         _loc3_.y += m_xf.position.y;
         return new b2Vec2(m_linearVelocity.x - m_angularVelocity * (_loc3_.y - m_sweep.c.y),m_linearVelocity.y + m_angularVelocity * (_loc3_.x - m_sweep.c.x));
      }
      
      public function GetLinearDamping() : Number
      {
         return m_linearDamping;
      }
      
      public function SetLinearDamping(param1:Number) : void
      {
         m_linearDamping = param1;
      }
      
      public function GetAngularDamping() : Number
      {
         return m_angularDamping;
      }
      
      public function SetAngularDamping(param1:Number) : void
      {
         m_angularDamping = param1;
      }
      
      public function IsBullet() : Boolean
      {
         return (m_flags & e_bulletFlag) == e_bulletFlag;
      }
      
      public function SetBullet(param1:Boolean) : void
      {
         if(param1)
         {
            m_flags |= e_bulletFlag;
         }
         else
         {
            m_flags &= ~e_bulletFlag;
         }
      }
      
      public function IsFixedRotation() : Boolean
      {
         return (m_flags & e_fixedRotationFlag) == e_fixedRotationFlag;
      }
      
      public function SetFixedRotation(param1:Boolean) : void
      {
         if(param1)
         {
            m_angularVelocity = 0;
            m_invI = 0;
            m_flags |= e_fixedRotationFlag;
         }
         else if(m_I > 0)
         {
            m_invI = 1 / m_I;
            m_flags &= e_fixedRotationFlag;
         }
      }
      
      public function IsStatic() : Boolean
      {
         return m_type == e_staticType;
      }
      
      public function SetStatic() : void
      {
         if(m_type == e_staticType)
         {
            return;
         }
         m_mass = 0;
         m_invMass = 0;
         m_I = 0;
         m_invI = 0;
         m_type = e_staticType;
         var _loc1_:b2Shape = m_shapeList;
         while(_loc1_)
         {
            _loc1_.RefilterProxy(m_world.m_broadPhase,m_xf);
            _loc1_ = _loc1_.m_next;
         }
      }
      
      public function IsDynamic() : Boolean
      {
         return m_type == e_dynamicType;
      }
      
      public function IsFrozen() : Boolean
      {
         return (m_flags & e_frozenFlag) == e_frozenFlag;
      }
      
      public function IsSleeping() : Boolean
      {
         return (m_flags & e_sleepFlag) == e_sleepFlag;
      }
      
      public function IsAllowSleeping() : Boolean
      {
         return (m_flags & e_allowSleepFlag) == e_allowSleepFlag;
      }
      
      public function AllowSleeping(param1:Boolean) : void
      {
         if(param1)
         {
            m_flags |= e_allowSleepFlag;
         }
         else
         {
            m_flags &= ~e_allowSleepFlag;
            WakeUp();
         }
      }
      
      public function WakeUp() : void
      {
         m_flags &= ~e_sleepFlag;
         m_sleepTime = 0;
      }
      
      public function PutToSleep() : void
      {
         m_flags |= e_sleepFlag;
         m_sleepTime = 0;
         m_linearVelocity.SetZero();
         m_angularVelocity = 0;
         m_force.SetZero();
         m_torque = 0;
      }
      
      public function GetShapeList() : b2Shape
      {
         return m_shapeList;
      }
      
      public function GetJointList() : b2JointEdge
      {
         return m_jointList;
      }
      
      public function GetControllerList() : b2ControllerEdge
      {
         return m_controllerList;
      }
      
      public function GetNext() : b2Body
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
      
      public function GetWorld() : b2World
      {
         return m_world;
      }
      
      public function AddToLinearVelocity(param1:Number, param2:Number) : void
      {
         WakeUp();
         var _loc3_:b2Vec2 = new b2Vec2(GetLinearVelocity().x + param1,GetLinearVelocity().y + param2);
         SetLinearVelocity(_loc3_);
      }
      
      public function AddToAngularVelocity(param1:Number, param2:Number) : void
      {
         WakeUp();
         SetAngularVelocity(GetAngularVelocity() + param1);
         if(GetAngularVelocity() > param2)
         {
            SetAngularVelocity(param2);
         }
         if(GetAngularVelocity() < param2 * -1)
         {
            SetAngularVelocity(param2 * -1);
         }
      }
      
      b2internal function SynchronizeShapes() : Boolean
      {
         var _loc4_:b2Shape = null;
         var _loc1_:b2XForm = s_xf1;
         _loc1_.R.Set(m_sweep.a0);
         var _loc2_:b2Mat22 = _loc1_.R;
         var _loc3_:b2Vec2 = m_sweep.localCenter;
         _loc1_.position.x = m_sweep.c0.x - (_loc2_.col1.x * _loc3_.x + _loc2_.col2.x * _loc3_.y);
         _loc1_.position.y = m_sweep.c0.y - (_loc2_.col1.y * _loc3_.x + _loc2_.col2.y * _loc3_.y);
         var _loc5_:Boolean = true;
         _loc4_ = m_shapeList;
         while(_loc4_)
         {
            _loc5_ = _loc4_.Synchronize(m_world.m_broadPhase,_loc1_,m_xf);
            if(_loc5_ == false)
            {
               break;
            }
            _loc4_ = _loc4_.m_next;
         }
         if(_loc5_ == false)
         {
            m_flags |= e_frozenFlag;
            m_linearVelocity.SetZero();
            m_angularVelocity = 0;
            _loc4_ = m_shapeList;
            while(_loc4_)
            {
               _loc4_.DestroyProxy(m_world.m_broadPhase);
               _loc4_ = _loc4_.m_next;
            }
            return false;
         }
         return true;
      }
      
      b2internal function SynchronizeTransform() : void
      {
         m_xf.R.Set(m_sweep.a);
         var _loc1_:b2Mat22 = m_xf.R;
         var _loc2_:b2Vec2 = m_sweep.localCenter;
         m_xf.position.x = m_sweep.c.x - (_loc1_.col1.x * _loc2_.x + _loc1_.col2.x * _loc2_.y);
         m_xf.position.y = m_sweep.c.y - (_loc1_.col1.y * _loc2_.x + _loc1_.col2.y * _loc2_.y);
      }
      
      b2internal function IsConnected(param1:b2Body) : Boolean
      {
         var _loc2_:b2JointEdge = m_jointList;
         while(_loc2_)
         {
            if(_loc2_.other == param1)
            {
               return _loc2_.joint.m_collideConnected == false;
            }
            _loc2_ = _loc2_.next;
         }
         return false;
      }
      
      b2internal function Advance(param1:Number) : void
      {
         m_sweep.Advance(param1);
         m_sweep.c.SetV(m_sweep.c0);
         m_sweep.a = m_sweep.a0;
         SynchronizeTransform();
      }
   }
}

