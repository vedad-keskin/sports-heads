package Box2D.Dynamics
{
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.Contacts.*;
   import Box2D.Dynamics.Controllers.b2Controller;
   import Box2D.Dynamics.Controllers.b2ControllerEdge;
   import Box2D.Dynamics.Joints.*;
   
   use namespace b2internal;
   
   public class b2World
   {
      
      private static var m_warmStarting:Boolean;
      
      private static var m_continuousPhysics:Boolean;
      
      private static var s_jointColor:b2Color = new b2Color(0.5,0.8,0.8);
      
      private static var s_coreColor:b2Color = new b2Color(0.9,0.6,0.6);
      
      private static var s_xf:b2XForm = new b2XForm();
      
      b2internal var m_raycastUserData:*;
      
      b2internal var m_raycastSegment:b2Segment;
      
      b2internal var m_raycastNormal:b2Vec2 = new b2Vec2();
      
      b2internal var m_blockAllocator:*;
      
      b2internal var m_stackAllocator:*;
      
      b2internal var m_lock:Boolean;
      
      b2internal var m_broadPhase:b2BroadPhase;
      
      private var m_contactManager:b2ContactManager = new b2ContactManager();
      
      b2internal var m_bodyList:b2Body;
      
      private var m_jointList:b2Joint;
      
      b2internal var m_contactList:b2Contact;
      
      private var m_bodyCount:int;
      
      b2internal var m_contactCount:int;
      
      private var m_jointCount:int;
      
      private var m_controllerList:b2Controller;
      
      private var m_controllerCount:int;
      
      private var m_gravity:b2Vec2;
      
      private var m_allowSleep:Boolean;
      
      b2internal var m_groundBody:b2Body;
      
      private var m_destructionListener:b2DestructionListener;
      
      private var m_boundaryListener:b2BoundaryListener;
      
      b2internal var m_contactFilter:b2ContactFilter;
      
      b2internal var m_contactListener:b2ContactListener;
      
      private var m_debugDraw:b2DebugDraw;
      
      private var m_inv_dt0:Number;
      
      public function b2World(param1:b2AABB, param2:b2Vec2, param3:Boolean)
      {
         super();
         m_destructionListener = null;
         m_boundaryListener = null;
         b2internal::m_contactFilter = b2ContactFilter.b2_defaultFilter;
         b2internal::m_contactListener = null;
         m_debugDraw = null;
         b2internal::m_bodyList = null;
         b2internal::m_contactList = null;
         m_jointList = null;
         m_controllerList = null;
         m_bodyCount = 0;
         b2internal::m_contactCount = 0;
         m_jointCount = 0;
         m_controllerCount = 0;
         m_warmStarting = true;
         m_continuousPhysics = true;
         m_allowSleep = param3;
         m_gravity = param2;
         b2internal::m_lock = false;
         m_inv_dt0 = 0;
         m_contactManager.m_world = this;
         b2internal::m_broadPhase = new b2BroadPhase(param1,m_contactManager);
         var _loc4_:b2BodyDef = new b2BodyDef();
         b2internal::m_groundBody = CreateBody(_loc4_);
      }
      
      public function SetDestructionListener(param1:b2DestructionListener) : void
      {
         m_destructionListener = param1;
      }
      
      public function SetBoundaryListener(param1:b2BoundaryListener) : void
      {
         m_boundaryListener = param1;
      }
      
      public function SetContactFilter(param1:b2ContactFilter) : void
      {
         m_contactFilter = param1;
      }
      
      public function SetContactListener(param1:b2ContactListener) : void
      {
         m_contactListener = param1;
      }
      
      public function SetDebugDraw(param1:b2DebugDraw) : void
      {
         m_debugDraw = param1;
      }
      
      public function Validate() : void
      {
         m_broadPhase.Validate();
      }
      
      public function GetProxyCount() : int
      {
         return m_broadPhase.m_proxyCount;
      }
      
      public function GetPairCount() : int
      {
         return m_broadPhase.m_pairManager.m_pairCount;
      }
      
      public function CreateBody(param1:b2BodyDef) : b2Body
      {
         if(m_lock == true)
         {
            return null;
         }
         var _loc2_:b2Body = new b2Body(param1,this);
         _loc2_.m_prev = null;
         _loc2_.m_next = m_bodyList;
         if(m_bodyList)
         {
            m_bodyList.m_prev = _loc2_;
         }
         m_bodyList = _loc2_;
         ++m_bodyCount;
         return _loc2_;
      }
      
      public function DestroyBody(param1:b2Body) : void
      {
         var _loc5_:b2JointEdge = null;
         var _loc6_:b2ControllerEdge = null;
         var _loc7_:b2Shape = null;
         if(m_lock == true)
         {
            return;
         }
         var _loc2_:b2JointEdge = param1.m_jointList;
         while(_loc2_)
         {
            _loc5_ = _loc2_;
            _loc2_ = _loc2_.next;
            if(m_destructionListener)
            {
               m_destructionListener.SayGoodbyeJoint(_loc5_.joint);
            }
            DestroyJoint(_loc5_.joint);
         }
         var _loc3_:b2ControllerEdge = param1.m_controllerList;
         while(_loc3_)
         {
            _loc6_ = _loc3_;
            _loc3_ = _loc3_.nextController;
            _loc6_.controller.RemoveBody(param1);
         }
         var _loc4_:b2Shape = param1.m_shapeList;
         while(_loc4_)
         {
            _loc7_ = _loc4_;
            _loc4_ = _loc4_.m_next;
            if(m_destructionListener)
            {
               m_destructionListener.SayGoodbyeShape(_loc7_);
            }
            _loc7_.DestroyProxy(m_broadPhase);
            b2Shape.Destroy(_loc7_,m_blockAllocator);
         }
         if(param1.m_prev)
         {
            param1.m_prev.m_next = param1.m_next;
         }
         if(param1.m_next)
         {
            param1.m_next.m_prev = param1.m_prev;
         }
         if(param1 == m_bodyList)
         {
            m_bodyList = param1.m_next;
         }
         --m_bodyCount;
      }
      
      public function CreateJoint(param1:b2JointDef) : b2Joint
      {
         var _loc3_:b2Body = null;
         var _loc4_:b2Shape = null;
         var _loc2_:b2Joint = b2Joint.Create(param1,m_blockAllocator);
         _loc2_.m_prev = null;
         _loc2_.m_next = m_jointList;
         if(m_jointList)
         {
            m_jointList.m_prev = _loc2_;
         }
         m_jointList = _loc2_;
         ++m_jointCount;
         _loc2_.m_node1.joint = _loc2_;
         _loc2_.m_node1.other = _loc2_.m_body2;
         _loc2_.m_node1.prev = null;
         _loc2_.m_node1.next = _loc2_.m_body1.m_jointList;
         if(_loc2_.m_body1.m_jointList)
         {
            _loc2_.m_body1.m_jointList.prev = _loc2_.m_node1;
         }
         _loc2_.m_body1.m_jointList = _loc2_.m_node1;
         _loc2_.m_node2.joint = _loc2_;
         _loc2_.m_node2.other = _loc2_.m_body1;
         _loc2_.m_node2.prev = null;
         _loc2_.m_node2.next = _loc2_.m_body2.m_jointList;
         if(_loc2_.m_body2.m_jointList)
         {
            _loc2_.m_body2.m_jointList.prev = _loc2_.m_node2;
         }
         _loc2_.m_body2.m_jointList = _loc2_.m_node2;
         if(param1.collideConnected == false)
         {
            _loc3_ = param1.body1.m_shapeCount < param1.body2.m_shapeCount ? param1.body1 : param1.body2;
            _loc4_ = _loc3_.m_shapeList;
            while(_loc4_)
            {
               _loc4_.RefilterProxy(m_broadPhase,_loc3_.m_xf);
               _loc4_ = _loc4_.m_next;
            }
         }
         return _loc2_;
      }
      
      public function DestroyJoint(param1:b2Joint) : void
      {
         var _loc5_:b2Body = null;
         var _loc6_:b2Shape = null;
         var _loc2_:Boolean = param1.m_collideConnected;
         if(param1.m_prev)
         {
            param1.m_prev.m_next = param1.m_next;
         }
         if(param1.m_next)
         {
            param1.m_next.m_prev = param1.m_prev;
         }
         if(param1 == m_jointList)
         {
            m_jointList = param1.m_next;
         }
         var _loc3_:b2Body = param1.m_body1;
         var _loc4_:b2Body = param1.m_body2;
         _loc3_.WakeUp();
         _loc4_.WakeUp();
         if(param1.m_node1.prev)
         {
            param1.m_node1.prev.next = param1.m_node1.next;
         }
         if(param1.m_node1.next)
         {
            param1.m_node1.next.prev = param1.m_node1.prev;
         }
         if(param1.m_node1 == _loc3_.m_jointList)
         {
            _loc3_.m_jointList = param1.m_node1.next;
         }
         param1.m_node1.prev = null;
         param1.m_node1.next = null;
         if(param1.m_node2.prev)
         {
            param1.m_node2.prev.next = param1.m_node2.next;
         }
         if(param1.m_node2.next)
         {
            param1.m_node2.next.prev = param1.m_node2.prev;
         }
         if(param1.m_node2 == _loc4_.m_jointList)
         {
            _loc4_.m_jointList = param1.m_node2.next;
         }
         param1.m_node2.prev = null;
         param1.m_node2.next = null;
         b2Joint.Destroy(param1,m_blockAllocator);
         --m_jointCount;
         if(_loc2_ == false)
         {
            _loc5_ = _loc3_.m_shapeCount < _loc4_.m_shapeCount ? _loc3_ : _loc4_;
            _loc6_ = _loc5_.m_shapeList;
            while(_loc6_)
            {
               _loc6_.RefilterProxy(m_broadPhase,_loc5_.m_xf);
               _loc6_ = _loc6_.m_next;
            }
         }
      }
      
      public function AddController(param1:b2Controller) : b2Controller
      {
         param1.m_next = m_controllerList;
         param1.m_prev = null;
         m_controllerList = param1;
         param1.m_world = this;
         ++m_controllerCount;
         return param1;
      }
      
      public function RemoveController(param1:b2Controller) : void
      {
         if(param1.m_prev)
         {
            param1.m_prev.m_next = param1.m_next;
         }
         if(param1.m_next)
         {
            param1.m_next.m_prev = param1.m_prev;
         }
         if(m_controllerList == param1)
         {
            m_controllerList = param1.m_next;
         }
         --m_controllerCount;
      }
      
      public function CreateController(param1:b2Controller) : b2Controller
      {
         if(param1.m_world != this)
         {
            throw new Error("Controller can only be a member of one world");
         }
         param1.m_next = m_controllerList;
         param1.m_prev = null;
         if(m_controllerList)
         {
            m_controllerList.m_prev = param1;
         }
         m_controllerList = param1;
         ++m_controllerCount;
         param1.m_world = this;
         return param1;
      }
      
      public function DestroyController(param1:b2Controller) : void
      {
         param1.Clear();
         if(param1.m_next)
         {
            param1.m_next.m_prev = param1.m_prev;
         }
         if(param1.m_prev)
         {
            param1.m_prev.m_next = param1.m_next;
         }
         if(param1 == m_controllerList)
         {
            m_controllerList = param1.m_next;
         }
         --m_controllerCount;
      }
      
      public function Refilter(param1:b2Shape) : void
      {
         param1.RefilterProxy(m_broadPhase,param1.m_body.m_xf);
      }
      
      public function SetWarmStarting(param1:Boolean) : void
      {
         m_warmStarting = param1;
      }
      
      public function SetContinuousPhysics(param1:Boolean) : void
      {
         m_continuousPhysics = param1;
      }
      
      public function GetBodyCount() : int
      {
         return m_bodyCount;
      }
      
      public function GetJointCount() : int
      {
         return m_jointCount;
      }
      
      public function GetContactCount() : int
      {
         return m_contactCount;
      }
      
      public function SetGravity(param1:b2Vec2) : void
      {
         m_gravity = param1;
      }
      
      public function GetGravity() : b2Vec2
      {
         return m_gravity;
      }
      
      public function GetGroundBody() : b2Body
      {
         return m_groundBody;
      }
      
      public function Step(param1:Number, param2:int, param3:int) : void
      {
         m_lock = true;
         var _loc4_:b2TimeStep = new b2TimeStep();
         _loc4_.dt = param1;
         _loc4_.velocityIterations = param2;
         _loc4_.positionIterations = param3;
         if(param1 > 0)
         {
            _loc4_.inv_dt = 1 / param1;
         }
         else
         {
            _loc4_.inv_dt = 0;
         }
         _loc4_.dtRatio = m_inv_dt0 * param1;
         _loc4_.warmStarting = m_warmStarting;
         m_contactManager.Collide();
         if(_loc4_.dt > 0)
         {
            Solve(_loc4_);
         }
         if(m_continuousPhysics && _loc4_.dt > 0)
         {
            SolveTOI(_loc4_);
         }
         DrawDebugData();
         m_inv_dt0 = _loc4_.inv_dt;
         m_lock = false;
      }
      
      public function Query(param1:b2AABB, param2:Array, param3:int) : int
      {
         var _loc4_:Array = new Array(param3);
         var _loc5_:int = m_broadPhase.QueryAABB(param1,_loc4_,param3);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            param2[_loc6_] = _loc4_[_loc6_];
            _loc6_++;
         }
         return _loc5_;
      }
      
      public function InRange(param1:b2AABB) : Boolean
      {
         return m_broadPhase.InRange(param1);
      }
      
      public function Raycast(param1:b2Segment, param2:Array, param3:int, param4:Boolean, param5:*) : int
      {
         var _loc7_:int = 0;
         var _loc6_:Array = new Array(param3);
         m_raycastSegment = param1;
         m_raycastUserData = param5;
         if(param4)
         {
            _loc7_ = m_broadPhase.QuerySegment(param1,_loc6_,param3,RaycastSortKey);
         }
         else
         {
            _loc7_ = m_broadPhase.QuerySegment(param1,_loc6_,param3,RaycastSortKey2);
         }
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            param2[_loc8_] = _loc6_[_loc8_];
            _loc8_++;
         }
         return _loc7_;
      }
      
      public function RaycastOne(param1:b2Segment, param2:Array, param3:b2Vec2, param4:Boolean, param5:*) : b2Shape
      {
         var _loc6_:Array = new Array(1);
         var _loc7_:Number = Raycast(param1,_loc6_,1,param4,param5);
         if(_loc7_ == 0)
         {
            return null;
         }
         if(_loc7_ > 1)
         {
            trace(_loc7_);
         }
         var _loc8_:b2Shape = _loc6_[0];
         var _loc9_:b2XForm = _loc8_.GetBody().GetXForm();
         _loc8_.TestSegment(_loc9_,param2,param3,param1,1);
         return _loc8_;
      }
      
      public function GetBodyList() : b2Body
      {
         return m_bodyList;
      }
      
      public function GetJointList() : b2Joint
      {
         return m_jointList;
      }
      
      b2internal function Solve(param1:b2TimeStep) : void
      {
         var _loc2_:b2Body = null;
         var _loc10_:* = 0;
         var _loc11_:int = 0;
         var _loc12_:b2Body = null;
         var _loc13_:b2ContactEdge = null;
         var _loc14_:b2JointEdge = null;
         var _loc15_:Boolean = false;
         var _loc3_:b2Controller = m_controllerList;
         while(_loc3_)
         {
            _loc3_.Step(param1);
            _loc3_ = _loc3_.m_next;
         }
         var _loc4_:b2Island = new b2Island(m_bodyCount,m_contactCount,m_jointCount,m_stackAllocator,m_contactListener);
         _loc2_ = m_bodyList;
         while(_loc2_)
         {
            _loc2_.m_flags &= ~b2Body.e_islandFlag;
            _loc2_ = _loc2_.m_next;
         }
         var _loc5_:b2Contact = m_contactList;
         while(_loc5_)
         {
            _loc5_.m_flags &= ~b2Contact.e_islandFlag;
            _loc5_ = _loc5_.m_next;
         }
         var _loc6_:b2Joint = m_jointList;
         while(_loc6_)
         {
            _loc6_.m_islandFlag = false;
            _loc6_ = _loc6_.m_next;
         }
         var _loc7_:int = m_bodyCount;
         var _loc8_:Array = new Array(_loc7_);
         var _loc9_:b2Body = m_bodyList;
         while(_loc9_)
         {
            if(!(_loc9_.m_flags & (b2Body.e_islandFlag | b2Body.e_sleepFlag | b2Body.e_frozenFlag)))
            {
               if(!_loc9_.IsStatic())
               {
                  _loc4_.Clear();
                  _loc10_ = 0;
                  var _loc16_:Number;
                  _loc8_[_loc16_ = _loc10_++] = _loc9_;
                  _loc9_.m_flags |= b2Body.e_islandFlag;
                  while(_loc10_ > 0)
                  {
                     _loc2_ = _loc8_[--_loc10_];
                     _loc4_.AddBody(_loc2_);
                     _loc2_.m_flags &= ~b2Body.e_sleepFlag;
                     if(!_loc2_.IsStatic())
                     {
                        _loc13_ = _loc2_.m_contactList;
                        while(_loc13_)
                        {
                           if(!(_loc13_.contact.m_flags & (b2Contact.e_islandFlag | b2Contact.e_nonSolidFlag)))
                           {
                              if(_loc13_.contact.m_manifoldCount != 0)
                              {
                                 _loc4_.AddContact(_loc13_.contact);
                                 _loc13_.contact.m_flags |= b2Contact.e_islandFlag;
                                 _loc12_ = _loc13_.other;
                                 if(!(_loc12_.m_flags & b2Body.e_islandFlag))
                                 {
                                    var _loc17_:Number;
                                    _loc8_[_loc17_ = _loc10_++] = _loc12_;
                                    _loc12_.m_flags |= b2Body.e_islandFlag;
                                 }
                              }
                           }
                           _loc13_ = _loc13_.next;
                        }
                        _loc14_ = _loc2_.m_jointList;
                        while(_loc14_)
                        {
                           if(_loc14_.joint.m_islandFlag != true)
                           {
                              _loc4_.AddJoint(_loc14_.joint);
                              _loc14_.joint.m_islandFlag = true;
                              _loc12_ = _loc14_.other;
                              if(!(_loc12_.m_flags & b2Body.e_islandFlag))
                              {
                                 _loc8_[_loc17_ = _loc10_++] = _loc12_;
                                 _loc12_.m_flags |= b2Body.e_islandFlag;
                              }
                           }
                           _loc14_ = _loc14_.next;
                        }
                     }
                  }
                  _loc4_.Solve(param1,m_gravity,m_allowSleep);
                  _loc11_ = 0;
                  while(_loc11_ < _loc4_.m_bodyCount)
                  {
                     _loc2_ = _loc4_.m_bodies[_loc11_];
                     if(_loc2_.IsStatic())
                     {
                        _loc2_.m_flags &= ~b2Body.e_islandFlag;
                     }
                     _loc11_++;
                  }
               }
            }
            _loc9_ = _loc9_.m_next;
         }
         _loc2_ = m_bodyList;
         while(_loc2_)
         {
            if(!(_loc2_.m_flags & (b2Body.e_sleepFlag | b2Body.e_frozenFlag)))
            {
               if(!_loc2_.IsStatic())
               {
                  _loc15_ = _loc2_.SynchronizeShapes();
                  if(_loc15_ == false && m_boundaryListener != null)
                  {
                     m_boundaryListener.Violation(_loc2_);
                  }
               }
            }
            _loc2_ = _loc2_.m_next;
         }
         m_broadPhase.Commit();
      }
      
      b2internal function SolveTOI(param1:b2TimeStep) : void
      {
         var _loc2_:b2Body = null;
         var _loc3_:b2Shape = null;
         var _loc4_:b2Shape = null;
         var _loc5_:b2Body = null;
         var _loc6_:b2Body = null;
         var _loc7_:b2ContactEdge = null;
         var _loc8_:b2Joint = null;
         var _loc12_:b2Contact = null;
         var _loc13_:b2Contact = null;
         var _loc14_:Number = NaN;
         var _loc15_:b2Body = null;
         var _loc16_:* = 0;
         var _loc17_:* = 0;
         var _loc18_:b2JointEdge = null;
         var _loc19_:b2TimeStep = null;
         var _loc20_:int = 0;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:b2Body = null;
         var _loc24_:Boolean = false;
         var _loc9_:b2Island = new b2Island(m_bodyCount,b2Settings.b2_maxTOIContactsPerIsland,b2Settings.b2_maxTOIJointsPerIsland,m_stackAllocator,m_contactListener);
         var _loc10_:int = m_bodyCount;
         var _loc11_:Array = new Array(_loc10_);
         _loc2_ = m_bodyList;
         while(_loc2_)
         {
            _loc2_.m_flags &= ~b2Body.e_islandFlag;
            _loc2_.m_sweep.t0 = 0;
            _loc2_ = _loc2_.m_next;
         }
         _loc12_ = m_contactList;
         while(_loc12_)
         {
            _loc12_.m_flags &= ~(b2Contact.e_toiFlag | b2Contact.e_islandFlag);
            _loc12_ = _loc12_.m_next;
         }
         _loc8_ = m_jointList;
         while(_loc8_)
         {
            _loc8_.m_islandFlag = false;
            _loc8_ = _loc8_.m_next;
         }
         while(true)
         {
            _loc13_ = null;
            _loc14_ = 1;
            _loc12_ = m_contactList;
            for(; _loc12_; _loc12_ = _loc12_.m_next)
            {
               if(!(_loc12_.m_flags & (b2Contact.e_slowFlag | b2Contact.e_nonSolidFlag)))
               {
                  _loc21_ = 1;
                  if(_loc12_.m_flags & b2Contact.e_toiFlag)
                  {
                     _loc21_ = _loc12_.m_toi;
                  }
                  else
                  {
                     _loc3_ = _loc12_.m_shape1;
                     _loc4_ = _loc12_.m_shape2;
                     _loc5_ = _loc3_.m_body;
                     _loc6_ = _loc4_.m_body;
                     if((_loc5_.IsStatic() || _loc5_.IsSleeping()) && (_loc6_.IsStatic() || _loc6_.IsSleeping()))
                     {
                        continue;
                     }
                     _loc22_ = _loc5_.m_sweep.t0;
                     if(_loc5_.m_sweep.t0 < _loc6_.m_sweep.t0)
                     {
                        _loc22_ = _loc6_.m_sweep.t0;
                        _loc5_.m_sweep.Advance(_loc22_);
                     }
                     else if(_loc6_.m_sweep.t0 < _loc5_.m_sweep.t0)
                     {
                        _loc22_ = _loc5_.m_sweep.t0;
                        _loc6_.m_sweep.Advance(_loc22_);
                     }
                     _loc21_ = b2TimeOfImpact.TimeOfImpact(_loc12_.m_shape1,_loc5_.m_sweep,_loc12_.m_shape2,_loc6_.m_sweep);
                     if(_loc21_ > 0 && _loc21_ < 1)
                     {
                        _loc21_ = (1 - _loc21_) * _loc22_ + _loc21_;
                        if(_loc21_ > 1)
                        {
                           _loc21_ = 1;
                        }
                     }
                     _loc12_.m_toi = _loc21_;
                     _loc12_.m_flags |= b2Contact.e_toiFlag;
                  }
                  if(Number.MIN_VALUE < _loc21_ && _loc21_ < _loc14_)
                  {
                     _loc13_ = _loc12_;
                     _loc14_ = _loc21_;
                  }
               }
            }
            if(_loc13_ == null || 1 - 100 * Number.MIN_VALUE < _loc14_)
            {
               break;
            }
            _loc3_ = _loc13_.m_shape1;
            _loc4_ = _loc13_.m_shape2;
            _loc5_ = _loc3_.m_body;
            _loc6_ = _loc4_.m_body;
            _loc5_.Advance(_loc14_);
            _loc6_.Advance(_loc14_);
            _loc13_.Update(m_contactListener);
            _loc13_.m_flags &= ~b2Contact.e_toiFlag;
            if(_loc13_.m_manifoldCount != 0)
            {
               _loc15_ = _loc5_;
               if(_loc15_.IsStatic())
               {
                  _loc15_ = _loc6_;
               }
               _loc9_.Clear();
               _loc16_ = 0;
               _loc17_ = 0;
               _loc11_[_loc16_ + _loc17_++] = _loc15_;
               _loc15_.m_flags |= b2Body.e_islandFlag;
               while(_loc17_ > 0)
               {
                  _loc2_ = _loc11_[_loc16_++];
                  _loc17_--;
                  _loc9_.AddBody(_loc2_);
                  _loc2_.m_flags &= ~b2Body.e_sleepFlag;
                  if(!_loc2_.IsStatic())
                  {
                     _loc7_ = _loc2_.m_contactList;
                     while(_loc7_)
                     {
                        if(_loc9_.m_contactCount != _loc9_.m_contactCapacity)
                        {
                           if(!(_loc7_.contact.m_flags & (b2Contact.e_islandFlag | b2Contact.e_slowFlag | b2Contact.e_nonSolidFlag)))
                           {
                              if(_loc7_.contact.m_manifoldCount != 0)
                              {
                                 _loc9_.AddContact(_loc7_.contact);
                                 _loc7_.contact.m_flags |= b2Contact.e_islandFlag;
                                 _loc23_ = _loc7_.other;
                                 if(!(_loc23_.m_flags & b2Body.e_islandFlag))
                                 {
                                    if(_loc23_.IsStatic() == false)
                                    {
                                       _loc23_.Advance(_loc14_);
                                       _loc23_.WakeUp();
                                    }
                                    _loc11_[_loc16_ + _loc17_] = _loc23_;
                                    _loc17_++;
                                    _loc23_.m_flags |= b2Body.e_islandFlag;
                                 }
                              }
                           }
                        }
                        _loc7_ = _loc7_.next;
                     }
                  }
               }
               _loc18_ = _loc2_.m_jointList;
               while(_loc18_)
               {
                  if(_loc9_.m_jointCount != _loc9_.m_jointCapacity)
                  {
                     if(_loc18_.joint.m_islandFlag != true)
                     {
                        _loc9_.AddJoint(_loc18_.joint);
                        _loc18_.joint.m_islandFlag = true;
                        _loc23_ = _loc18_.other;
                        if(!(_loc23_.m_flags & b2Body.e_islandFlag))
                        {
                           if(!_loc23_.IsStatic())
                           {
                              _loc23_.Advance(_loc14_);
                              _loc23_.WakeUp();
                           }
                           _loc11_[_loc16_ + _loc17_] = _loc23_;
                           _loc17_++;
                           _loc23_.m_flags |= b2Body.e_islandFlag;
                        }
                     }
                  }
                  _loc18_ = _loc18_.next;
               }
               _loc19_ = new b2TimeStep();
               _loc19_.warmStarting = false;
               _loc19_.dt = (1 - _loc14_) * param1.dt;
               _loc19_.inv_dt = 1 / _loc19_.dt;
               _loc19_.dtRatio = 0;
               _loc19_.velocityIterations = param1.velocityIterations;
               _loc19_.positionIterations = param1.positionIterations;
               _loc9_.SolveTOI(_loc19_);
               _loc20_ = 0;
               while(_loc20_ < _loc9_.m_bodyCount)
               {
                  _loc2_ = _loc9_.m_bodies[_loc20_];
                  _loc2_.m_flags &= ~b2Body.e_islandFlag;
                  if(!(_loc2_.m_flags & (b2Body.e_sleepFlag | b2Body.e_frozenFlag)))
                  {
                     if(!_loc2_.IsStatic())
                     {
                        _loc24_ = _loc2_.SynchronizeShapes();
                        if(_loc24_ == false && m_boundaryListener != null)
                        {
                           m_boundaryListener.Violation(_loc2_);
                        }
                        _loc7_ = _loc2_.m_contactList;
                        while(_loc7_)
                        {
                           _loc7_.contact.m_flags &= ~b2Contact.e_toiFlag;
                           _loc7_ = _loc7_.next;
                        }
                     }
                  }
                  _loc20_++;
               }
               _loc20_ = 0;
               while(_loc20_ < _loc9_.m_contactCount)
               {
                  _loc12_ = _loc9_.m_contacts[_loc20_];
                  _loc12_.m_flags &= ~(b2Contact.e_toiFlag | b2Contact.e_islandFlag);
                  _loc20_++;
               }
               _loc20_ = 0;
               while(_loc20_ < _loc9_.m_jointCount)
               {
                  _loc8_ = _loc9_.m_joints[_loc20_];
                  _loc8_.m_islandFlag = false;
                  _loc20_++;
               }
               m_broadPhase.Commit();
            }
         }
      }
      
      b2internal function DrawJoint(param1:b2Joint) : void
      {
         var _loc11_:b2PulleyJoint = null;
         var _loc12_:b2Vec2 = null;
         var _loc13_:b2Vec2 = null;
         var _loc2_:b2Body = param1.m_body1;
         var _loc3_:b2Body = param1.m_body2;
         var _loc4_:b2XForm = _loc2_.m_xf;
         var _loc5_:b2XForm = _loc3_.m_xf;
         var _loc6_:b2Vec2 = _loc4_.position;
         var _loc7_:b2Vec2 = _loc5_.position;
         var _loc8_:b2Vec2 = param1.GetAnchor1();
         var _loc9_:b2Vec2 = param1.GetAnchor2();
         var _loc10_:b2Color = s_jointColor;
         switch(param1.m_type)
         {
            case b2Joint.e_distanceJoint:
               m_debugDraw.DrawSegment(_loc8_,_loc9_,_loc10_);
               break;
            case b2Joint.e_pulleyJoint:
               _loc11_ = param1 as b2PulleyJoint;
               _loc12_ = _loc11_.GetGroundAnchor1();
               _loc13_ = _loc11_.GetGroundAnchor2();
               m_debugDraw.DrawSegment(_loc12_,_loc8_,_loc10_);
               m_debugDraw.DrawSegment(_loc13_,_loc9_,_loc10_);
               m_debugDraw.DrawSegment(_loc12_,_loc13_,_loc10_);
               break;
            case b2Joint.e_mouseJoint:
               m_debugDraw.DrawSegment(_loc8_,_loc9_,_loc10_);
               break;
            default:
               if(_loc2_ != m_groundBody)
               {
                  m_debugDraw.DrawSegment(_loc6_,_loc8_,_loc10_);
               }
               m_debugDraw.DrawSegment(_loc8_,_loc9_,_loc10_);
               if(_loc3_ != m_groundBody)
               {
                  m_debugDraw.DrawSegment(_loc7_,_loc9_,_loc10_);
               }
         }
      }
      
      b2internal function DrawShape(param1:b2Shape, param2:b2XForm, param3:b2Color, param4:Boolean) : void
      {
         var _loc6_:b2CircleShape = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:Number = NaN;
         var _loc9_:b2Vec2 = null;
         var _loc10_:int = 0;
         var _loc11_:b2PolygonShape = null;
         var _loc12_:int = 0;
         var _loc13_:Array = null;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         var _loc16_:b2EdgeShape = null;
         var _loc5_:b2Color = s_coreColor;
         switch(param1.m_type)
         {
            case b2Shape.e_circleShape:
               _loc6_ = param1 as b2CircleShape;
               _loc7_ = b2Math.b2MulX(param2,_loc6_.m_localPosition);
               _loc8_ = _loc6_.m_radius;
               _loc9_ = param2.R.col1;
               m_debugDraw.DrawSolidCircle(_loc7_,_loc8_,_loc9_,param3);
               if(param4)
               {
                  m_debugDraw.DrawCircle(_loc7_,_loc8_ - b2Settings.b2_toiSlop,_loc5_);
               }
               break;
            case b2Shape.e_polygonShape:
               _loc11_ = param1 as b2PolygonShape;
               _loc12_ = _loc11_.GetVertexCount();
               _loc13_ = _loc11_.GetVertices();
               _loc14_ = new Array(b2Settings.b2_maxPolygonVertices);
               _loc10_ = 0;
               while(_loc10_ < _loc12_)
               {
                  _loc14_[_loc10_] = b2Math.b2MulX(param2,_loc13_[_loc10_]);
                  _loc10_++;
               }
               m_debugDraw.DrawSolidPolygon(_loc14_,_loc12_,param3);
               if(param4)
               {
                  _loc15_ = _loc11_.GetCoreVertices();
                  _loc10_ = 0;
                  while(_loc10_ < _loc12_)
                  {
                     _loc14_[_loc10_] = b2Math.b2MulX(param2,_loc15_[_loc10_]);
                     _loc10_++;
                  }
                  m_debugDraw.DrawPolygon(_loc14_,_loc12_,_loc5_);
               }
               break;
            case b2Shape.e_edgeShape:
               _loc16_ = param1 as b2EdgeShape;
               m_debugDraw.DrawSegment(b2Math.b2MulX(param2,_loc16_.GetVertex1()),b2Math.b2MulX(param2,_loc16_.GetVertex2()),param3);
               if(param4)
               {
                  m_debugDraw.DrawSegment(b2Math.b2MulX(param2,_loc16_.GetCoreVertex1()),b2Math.b2MulX(param2,_loc16_.GetCoreVertex2()),_loc5_);
               }
         }
      }
      
      b2internal function DrawDebugData() : void
      {
         var _loc2_:int = 0;
         var _loc3_:b2Body = null;
         var _loc4_:b2Shape = null;
         var _loc5_:b2Joint = null;
         var _loc6_:b2BroadPhase = null;
         var _loc11_:b2XForm = null;
         var _loc15_:Boolean = false;
         var _loc16_:b2Controller = null;
         var _loc17_:b2Pair = null;
         var _loc18_:b2Proxy = null;
         var _loc19_:b2Proxy = null;
         var _loc20_:b2Vec2 = null;
         var _loc21_:b2Vec2 = null;
         var _loc22_:b2Proxy = null;
         var _loc23_:b2PolygonShape = null;
         var _loc24_:b2OBB = null;
         var _loc25_:b2Vec2 = null;
         var _loc26_:b2Mat22 = null;
         var _loc27_:b2Vec2 = null;
         var _loc28_:Number = NaN;
         if(m_debugDraw == null)
         {
            return;
         }
         m_debugDraw.m_sprite.graphics.clear();
         var _loc1_:uint = m_debugDraw.GetFlags();
         var _loc7_:b2Vec2 = new b2Vec2();
         var _loc8_:b2Vec2 = new b2Vec2();
         var _loc9_:b2Vec2 = new b2Vec2();
         var _loc10_:b2Color = new b2Color(0,0,0);
         var _loc12_:b2AABB = new b2AABB();
         var _loc13_:b2AABB = new b2AABB();
         var _loc14_:Array = [new b2Vec2(),new b2Vec2(),new b2Vec2(),new b2Vec2()];
         if(_loc1_ & b2DebugDraw.e_shapeBit)
         {
            _loc15_ = (_loc1_ & b2DebugDraw.e_coreShapeBit) == b2DebugDraw.e_coreShapeBit;
            _loc3_ = m_bodyList;
            while(_loc3_)
            {
               _loc11_ = _loc3_.m_xf;
               _loc4_ = _loc3_.GetShapeList();
               while(_loc4_)
               {
                  if(_loc3_.IsStatic())
                  {
                     DrawShape(_loc4_,_loc11_,new b2Color(0.5,0.9,0.5),_loc15_);
                  }
                  else if(_loc3_.IsSleeping())
                  {
                     DrawShape(_loc4_,_loc11_,new b2Color(0.5,0.5,0.9),_loc15_);
                  }
                  else
                  {
                     DrawShape(_loc4_,_loc11_,new b2Color(0.9,0.9,0.9),_loc15_);
                  }
                  _loc4_ = _loc4_.m_next;
               }
               _loc3_ = _loc3_.m_next;
            }
         }
         if(_loc1_ & b2DebugDraw.e_jointBit)
         {
            _loc5_ = m_jointList;
            while(_loc5_)
            {
               DrawJoint(_loc5_);
               _loc5_ = _loc5_.m_next;
            }
         }
         if(_loc1_ & b2DebugDraw.e_controllerBit)
         {
            _loc16_ = m_controllerList;
            while(_loc16_)
            {
               _loc16_.Draw(m_debugDraw);
               _loc16_ = _loc16_.m_next;
            }
         }
         if(_loc1_ & b2DebugDraw.e_pairBit)
         {
            _loc6_ = m_broadPhase;
            _loc7_.Set(1 / _loc6_.m_quantizationFactor.x,1 / _loc6_.m_quantizationFactor.y);
            _loc10_.Set(0.9,0.9,0.3);
            for each(_loc17_ in _loc6_.m_pairManager.m_pairs)
            {
               _loc18_ = _loc17_.proxy1;
               _loc19_ = _loc17_.proxy2;
               if(!(!_loc18_ || !_loc19_))
               {
                  _loc12_.lowerBound.x = _loc6_.m_worldAABB.lowerBound.x + _loc7_.x * _loc6_.m_bounds[0][_loc18_.lowerBounds[0]].value;
                  _loc12_.lowerBound.y = _loc6_.m_worldAABB.lowerBound.y + _loc7_.y * _loc6_.m_bounds[1][_loc18_.lowerBounds[1]].value;
                  _loc12_.upperBound.x = _loc6_.m_worldAABB.lowerBound.x + _loc7_.x * _loc6_.m_bounds[0][_loc18_.upperBounds[0]].value;
                  _loc12_.upperBound.y = _loc6_.m_worldAABB.lowerBound.y + _loc7_.y * _loc6_.m_bounds[1][_loc18_.upperBounds[1]].value;
                  _loc13_.lowerBound.x = _loc6_.m_worldAABB.lowerBound.x + _loc7_.x * _loc6_.m_bounds[0][_loc19_.lowerBounds[0]].value;
                  _loc13_.lowerBound.y = _loc6_.m_worldAABB.lowerBound.y + _loc7_.y * _loc6_.m_bounds[1][_loc19_.lowerBounds[1]].value;
                  _loc13_.upperBound.x = _loc6_.m_worldAABB.lowerBound.x + _loc7_.x * _loc6_.m_bounds[0][_loc19_.upperBounds[0]].value;
                  _loc13_.upperBound.y = _loc6_.m_worldAABB.lowerBound.y + _loc7_.y * _loc6_.m_bounds[1][_loc19_.upperBounds[1]].value;
                  _loc8_.x = 0.5 * (_loc12_.lowerBound.x + _loc12_.upperBound.x);
                  _loc8_.y = 0.5 * (_loc12_.lowerBound.y + _loc12_.upperBound.y);
                  _loc9_.x = 0.5 * (_loc13_.lowerBound.x + _loc13_.upperBound.x);
                  _loc9_.y = 0.5 * (_loc13_.lowerBound.y + _loc13_.upperBound.y);
                  m_debugDraw.DrawSegment(_loc8_,_loc9_,_loc10_);
               }
            }
         }
         if(_loc1_ & b2DebugDraw.e_aabbBit)
         {
            _loc6_ = m_broadPhase;
            _loc20_ = _loc6_.m_worldAABB.lowerBound;
            _loc21_ = _loc6_.m_worldAABB.upperBound;
            _loc7_.Set(1 / _loc6_.m_quantizationFactor.x,1 / _loc6_.m_quantizationFactor.y);
            _loc10_.Set(0.9,0.3,0.9);
            _loc2_ = 0;
            while(_loc2_ < _loc6_.m_proxyPool.length)
            {
               _loc22_ = _loc6_.m_proxyPool[_loc2_];
               if(_loc22_.IsValid() != false)
               {
                  _loc12_.lowerBound.x = _loc20_.x + _loc7_.x * _loc6_.m_bounds[0][_loc22_.lowerBounds[0]].value;
                  _loc12_.lowerBound.y = _loc20_.y + _loc7_.y * _loc6_.m_bounds[1][_loc22_.lowerBounds[1]].value;
                  _loc12_.upperBound.x = _loc20_.x + _loc7_.x * _loc6_.m_bounds[0][_loc22_.upperBounds[0]].value;
                  _loc12_.upperBound.y = _loc20_.y + _loc7_.y * _loc6_.m_bounds[1][_loc22_.upperBounds[1]].value;
                  _loc14_[0].Set(_loc12_.lowerBound.x,_loc12_.lowerBound.y);
                  _loc14_[1].Set(_loc12_.upperBound.x,_loc12_.lowerBound.y);
                  _loc14_[2].Set(_loc12_.upperBound.x,_loc12_.upperBound.y);
                  _loc14_[3].Set(_loc12_.lowerBound.x,_loc12_.upperBound.y);
                  m_debugDraw.DrawPolygon(_loc14_,4,_loc10_);
               }
               _loc2_++;
            }
            _loc14_[0].Set(_loc20_.x,_loc20_.y);
            _loc14_[1].Set(_loc21_.x,_loc20_.y);
            _loc14_[2].Set(_loc21_.x,_loc21_.y);
            _loc14_[3].Set(_loc20_.x,_loc21_.y);
            m_debugDraw.DrawPolygon(_loc14_,4,new b2Color(0.3,0.9,0.9));
         }
         if(_loc1_ & b2DebugDraw.e_obbBit)
         {
            _loc10_.Set(0.5,0.3,0.5);
            _loc3_ = m_bodyList;
            while(_loc3_)
            {
               _loc11_ = _loc3_.m_xf;
               _loc4_ = _loc3_.GetShapeList();
               while(_loc4_)
               {
                  if(_loc4_.m_type == b2Shape.e_polygonShape)
                  {
                     _loc23_ = _loc4_ as b2PolygonShape;
                     _loc24_ = _loc23_.GetOBB();
                     _loc25_ = _loc24_.extents;
                     _loc14_[0].Set(-_loc25_.x,-_loc25_.y);
                     _loc14_[1].Set(_loc25_.x,-_loc25_.y);
                     _loc14_[2].Set(_loc25_.x,_loc25_.y);
                     _loc14_[3].Set(-_loc25_.x,_loc25_.y);
                     _loc2_ = 0;
                     while(_loc2_ < 4)
                     {
                        _loc26_ = _loc24_.R;
                        _loc27_ = _loc14_[_loc2_];
                        _loc28_ = _loc24_.center.x + (_loc26_.col1.x * _loc27_.x + _loc26_.col2.x * _loc27_.y);
                        _loc14_[_loc2_].y = _loc24_.center.y + (_loc26_.col1.y * _loc27_.x + _loc26_.col2.y * _loc27_.y);
                        _loc14_[_loc2_].x = _loc28_;
                        _loc26_ = _loc11_.R;
                        _loc28_ = _loc11_.position.x + (_loc26_.col1.x * _loc27_.x + _loc26_.col2.x * _loc27_.y);
                        _loc14_[_loc2_].y = _loc11_.position.y + (_loc26_.col1.y * _loc27_.x + _loc26_.col2.y * _loc27_.y);
                        _loc14_[_loc2_].x = _loc28_;
                        _loc2_++;
                     }
                     m_debugDraw.DrawPolygon(_loc14_,4,_loc10_);
                  }
                  _loc4_ = _loc4_.m_next;
               }
               _loc3_ = _loc3_.m_next;
            }
         }
         if(_loc1_ & b2DebugDraw.e_centerOfMassBit)
         {
            _loc3_ = m_bodyList;
            while(_loc3_)
            {
               _loc11_ = s_xf;
               _loc11_.R = _loc3_.m_xf.R;
               _loc11_.position = _loc3_.GetWorldCenter();
               m_debugDraw.DrawXForm(_loc11_);
               _loc3_ = _loc3_.m_next;
            }
         }
      }
      
      b2internal function RaycastSortKey(param1:b2Shape) : Number
      {
         if(Boolean(m_contactFilter) && !m_contactFilter.RayCollide(m_raycastUserData,param1))
         {
            return -1;
         }
         var _loc2_:b2Body = param1.GetBody();
         var _loc3_:b2XForm = _loc2_.GetXForm();
         var _loc4_:Array = [0];
         if(param1.TestSegment(_loc3_,_loc4_,m_raycastNormal,m_raycastSegment,1) == b2Shape.e_missCollide)
         {
            return -1;
         }
         return _loc4_[0];
      }
      
      b2internal function RaycastSortKey2(param1:b2Shape) : Number
      {
         if(Boolean(m_contactFilter) && !m_contactFilter.RayCollide(m_raycastUserData,param1))
         {
            return -1;
         }
         var _loc2_:b2Body = param1.GetBody();
         var _loc3_:b2XForm = _loc2_.GetXForm();
         var _loc4_:Array = [0];
         if(param1.TestSegment(_loc3_,_loc4_,m_raycastNormal,m_raycastSegment,1) != b2Shape.e_hitCollide)
         {
            return -1;
         }
         return _loc4_[0];
      }
   }
}

