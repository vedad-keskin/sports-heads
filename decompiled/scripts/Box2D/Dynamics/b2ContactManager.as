package Box2D.Dynamics
{
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.Contacts.*;
   
   use namespace b2internal;
   
   public class b2ContactManager extends b2PairCallback
   {
      
      private static const s_evalCP:b2ContactPoint = new b2ContactPoint();
      
      b2internal var m_world:b2World;
      
      private var m_nullContact:b2NullContact = new b2NullContact();
      
      private var m_destroyImmediate:Boolean;
      
      public function b2ContactManager()
      {
         super();
         b2internal::m_world = null;
         m_destroyImmediate = false;
      }
      
      override public function PairAdded(param1:*, param2:*) : *
      {
         var _loc3_:b2Shape = param1 as b2Shape;
         var _loc4_:b2Shape = param2 as b2Shape;
         var _loc5_:b2Body = _loc3_.m_body;
         var _loc6_:b2Body = _loc4_.m_body;
         if(_loc5_.IsStatic() && _loc6_.IsStatic())
         {
            return m_nullContact;
         }
         if(_loc3_.m_body == _loc4_.m_body)
         {
            return m_nullContact;
         }
         if(_loc6_.IsConnected(_loc5_))
         {
            return m_nullContact;
         }
         if(m_world.m_contactFilter != null && m_world.m_contactFilter.ShouldCollide(_loc3_,_loc4_) == false)
         {
            return m_nullContact;
         }
         var _loc7_:b2Contact = b2Contact.Create(_loc3_,_loc4_,m_world.m_blockAllocator);
         if(_loc7_ == null)
         {
            return m_nullContact;
         }
         _loc3_ = _loc7_.m_shape1;
         _loc4_ = _loc7_.m_shape2;
         _loc5_ = _loc3_.m_body;
         _loc6_ = _loc4_.m_body;
         _loc7_.m_prev = null;
         _loc7_.m_next = m_world.m_contactList;
         if(m_world.m_contactList != null)
         {
            m_world.m_contactList.m_prev = _loc7_;
         }
         m_world.m_contactList = _loc7_;
         _loc7_.m_node1.contact = _loc7_;
         _loc7_.m_node1.other = _loc6_;
         _loc7_.m_node1.prev = null;
         _loc7_.m_node1.next = _loc5_.m_contactList;
         if(_loc5_.m_contactList != null)
         {
            _loc5_.m_contactList.prev = _loc7_.m_node1;
         }
         _loc5_.m_contactList = _loc7_.m_node1;
         _loc7_.m_node2.contact = _loc7_;
         _loc7_.m_node2.other = _loc5_;
         _loc7_.m_node2.prev = null;
         _loc7_.m_node2.next = _loc6_.m_contactList;
         if(_loc6_.m_contactList != null)
         {
            _loc6_.m_contactList.prev = _loc7_.m_node2;
         }
         _loc6_.m_contactList = _loc7_.m_node2;
         ++m_world.m_contactCount;
         return _loc7_;
      }
      
      override public function PairRemoved(param1:*, param2:*, param3:*) : void
      {
         if(param3 == null)
         {
            return;
         }
         var _loc4_:b2Contact = param3 as b2Contact;
         if(_loc4_ == m_nullContact)
         {
            return;
         }
         Destroy(_loc4_);
      }
      
      public function Destroy(param1:b2Contact) : void
      {
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:b2Manifold = null;
         var _loc11_:int = 0;
         var _loc12_:b2ManifoldPoint = null;
         var _loc13_:b2Vec2 = null;
         var _loc14_:b2Vec2 = null;
         var _loc2_:b2Shape = param1.m_shape1;
         var _loc3_:b2Shape = param1.m_shape2;
         var _loc4_:b2Body = _loc2_.m_body;
         var _loc5_:b2Body = _loc3_.m_body;
         var _loc6_:b2ContactPoint = s_evalCP;
         _loc6_.shape1 = param1.m_shape1;
         _loc6_.shape2 = param1.m_shape2;
         _loc6_.friction = b2Settings.b2MixFriction(_loc2_.GetFriction(),_loc3_.GetFriction());
         _loc6_.restitution = b2Settings.b2MixRestitution(_loc2_.GetRestitution(),_loc3_.GetRestitution());
         var _loc7_:int = param1.m_manifoldCount;
         if(_loc7_ > 0 && Boolean(m_world.m_contactListener))
         {
            _loc8_ = param1.GetManifolds();
            _loc9_ = 0;
            while(_loc9_ < _loc7_)
            {
               _loc10_ = _loc8_[_loc9_];
               _loc6_.normal.SetV(_loc10_.normal);
               _loc11_ = 0;
               while(_loc11_ < _loc10_.pointCount)
               {
                  _loc12_ = _loc10_.points[_loc11_];
                  _loc6_.position = _loc4_.GetWorldPoint(_loc12_.localPoint1);
                  _loc13_ = _loc4_.GetLinearVelocityFromLocalPoint(_loc12_.localPoint1);
                  _loc14_ = _loc5_.GetLinearVelocityFromLocalPoint(_loc12_.localPoint2);
                  _loc6_.velocity.Set(_loc14_.x - _loc13_.x,_loc14_.y - _loc13_.y);
                  _loc6_.separation = _loc12_.separation;
                  _loc6_.id.key = _loc12_.id._key;
                  m_world.m_contactListener.Remove(_loc6_);
                  _loc11_++;
               }
               _loc9_++;
            }
         }
         if(param1.m_prev)
         {
            param1.m_prev.m_next = param1.m_next;
         }
         if(param1.m_next)
         {
            param1.m_next.m_prev = param1.m_prev;
         }
         if(param1 == m_world.m_contactList)
         {
            m_world.m_contactList = param1.m_next;
         }
         if(param1.m_node1.prev)
         {
            param1.m_node1.prev.next = param1.m_node1.next;
         }
         if(param1.m_node1.next)
         {
            param1.m_node1.next.prev = param1.m_node1.prev;
         }
         if(param1.m_node1 == _loc4_.m_contactList)
         {
            _loc4_.m_contactList = param1.m_node1.next;
         }
         if(param1.m_node2.prev)
         {
            param1.m_node2.prev.next = param1.m_node2.next;
         }
         if(param1.m_node2.next)
         {
            param1.m_node2.next.prev = param1.m_node2.prev;
         }
         if(param1.m_node2 == _loc5_.m_contactList)
         {
            _loc5_.m_contactList = param1.m_node2.next;
         }
         b2Contact.Destroy(param1,m_world.m_blockAllocator);
         --m_world.m_contactCount;
      }
      
      public function Collide() : void
      {
         var _loc2_:b2Body = null;
         var _loc3_:b2Body = null;
         var _loc1_:b2Contact = m_world.m_contactList;
         while(_loc1_)
         {
            _loc2_ = _loc1_.m_shape1.m_body;
            _loc3_ = _loc1_.m_shape2.m_body;
            if(!(_loc2_.IsSleeping() && _loc3_.IsSleeping()))
            {
               _loc1_.Update(m_world.m_contactListener);
            }
            _loc1_ = _loc1_.m_next;
         }
      }
   }
}

