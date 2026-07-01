package Box2D.Collision.Shapes
{
   import Box2D.Collision.b2AABB;
   import Box2D.Collision.b2BroadPhase;
   import Box2D.Collision.b2Proxy;
   import Box2D.Collision.b2Segment;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.Math.b2XForm;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   
   use namespace b2internal;
   
   public class b2Shape
   {
      
      private static var s_proxyAABB:b2AABB = new b2AABB();
      
      private static var s_syncAABB:b2AABB = new b2AABB();
      
      private static var s_resetAABB:b2AABB = new b2AABB();
      
      b2internal static const e_unknownShape:int = -1;
      
      b2internal static const e_circleShape:int = 0;
      
      b2internal static const e_polygonShape:int = 1;
      
      b2internal static const e_edgeShape:int = 2;
      
      b2internal static const e_shapeTypeCount:int = 3;
      
      public static const e_hitCollide:int = 1;
      
      public static const e_missCollide:int = 0;
      
      public static const e_startsInsideCollide:int = -1;
      
      b2internal var m_type:int;
      
      b2internal var m_next:b2Shape;
      
      b2internal var m_body:b2Body;
      
      b2internal var m_sweepRadius:Number;
      
      b2internal var m_density:Number;
      
      b2internal var m_friction:Number;
      
      b2internal var m_restitution:Number;
      
      private var m_proxy:b2Proxy;
      
      private var m_filter:b2FilterData;
      
      private var m_isSensor:Boolean;
      
      private var m_userData:*;
      
      public function b2Shape(param1:b2ShapeDef)
      {
         super();
         m_userData = param1.userData;
         b2internal::m_friction = param1.friction;
         b2internal::m_restitution = param1.restitution;
         b2internal::m_density = param1.density;
         b2internal::m_body = null;
         b2internal::m_sweepRadius = 0;
         b2internal::m_next = null;
         m_proxy = null;
         m_filter = param1.filter.Copy();
         m_isSensor = param1.isSensor;
      }
      
      b2internal static function Create(param1:b2ShapeDef, param2:*) : b2Shape
      {
         switch(param1.type)
         {
            case e_circleShape:
               return new b2CircleShape(param1);
            case e_polygonShape:
               return new b2PolygonShape(param1);
            default:
               return null;
         }
      }
      
      b2internal static function Destroy(param1:b2Shape, param2:*) : void
      {
         var _loc3_:b2EdgeShape = null;
         switch(param1.m_type)
         {
            case e_edgeShape:
               _loc3_ = param1 as b2EdgeShape;
               if(_loc3_.m_nextEdge != null)
               {
                  _loc3_.m_nextEdge.m_prevEdge = null;
               }
               if(_loc3_.m_prevEdge != null)
               {
                  _loc3_.m_prevEdge.m_nextEdge = null;
               }
         }
      }
      
      public function GetType() : int
      {
         return m_type;
      }
      
      public function IsSensor() : Boolean
      {
         return m_isSensor;
      }
      
      public function SetSensor(param1:Boolean) : void
      {
         m_isSensor = param1;
      }
      
      public function SetFilterData(param1:b2FilterData) : void
      {
         m_filter = param1.Copy();
      }
      
      public function GetFilterData() : b2FilterData
      {
         return m_filter.Copy();
      }
      
      public function GetBody() : b2Body
      {
         return m_body;
      }
      
      public function GetNext() : b2Shape
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
      
      public function TestPoint(param1:b2XForm, param2:b2Vec2) : Boolean
      {
         return false;
      }
      
      public function TestSegment(param1:b2XForm, param2:Array, param3:b2Vec2, param4:b2Segment, param5:Number) : int
      {
         return e_missCollide;
      }
      
      public function ComputeAABB(param1:b2AABB, param2:b2XForm) : void
      {
      }
      
      public function ComputeSweptAABB(param1:b2AABB, param2:b2XForm, param3:b2XForm) : void
      {
      }
      
      public function ComputeMass(param1:b2MassData) : void
      {
      }
      
      public function ComputeSubmergedArea(param1:b2Vec2, param2:Number, param3:b2XForm, param4:b2Vec2) : Number
      {
         return 0;
      }
      
      public function GetSweepRadius() : Number
      {
         return m_sweepRadius;
      }
      
      public function GetFriction() : Number
      {
         return m_friction;
      }
      
      public function SetFriction(param1:Number) : void
      {
         m_friction = param1;
      }
      
      public function GetRestitution() : Number
      {
         return m_restitution;
      }
      
      public function SetRestitution(param1:Number) : void
      {
         m_restitution = param1;
      }
      
      b2internal function CreateProxy(param1:b2BroadPhase, param2:b2XForm) : void
      {
         var _loc3_:b2AABB = s_proxyAABB;
         ComputeAABB(_loc3_,param2);
         var _loc4_:Boolean = param1.InRange(_loc3_);
         if(_loc4_)
         {
            m_proxy = param1.CreateProxy(_loc3_,this);
         }
         else
         {
            m_proxy = null;
         }
      }
      
      b2internal function DestroyProxy(param1:b2BroadPhase) : void
      {
         if(m_proxy)
         {
            param1.DestroyProxy(m_proxy);
            m_proxy = null;
         }
      }
      
      b2internal function Synchronize(param1:b2BroadPhase, param2:b2XForm, param3:b2XForm) : Boolean
      {
         if(m_proxy == null)
         {
            return false;
         }
         var _loc4_:b2AABB = s_syncAABB;
         ComputeSweptAABB(_loc4_,param2,param3);
         if(param1.InRange(_loc4_))
         {
            param1.MoveProxy(m_proxy,_loc4_);
            return true;
         }
         return false;
      }
      
      b2internal function RefilterProxy(param1:b2BroadPhase, param2:b2XForm) : void
      {
         if(m_proxy == null)
         {
            return;
         }
         param1.DestroyProxy(m_proxy);
         var _loc3_:b2AABB = s_resetAABB;
         ComputeAABB(_loc3_,param2);
         var _loc4_:Boolean = param1.InRange(_loc3_);
         if(_loc4_)
         {
            m_proxy = param1.CreateProxy(_loc3_,this);
         }
         else
         {
            m_proxy = null;
         }
      }
      
      b2internal function UpdateSweepRadius(param1:b2Vec2) : void
      {
      }
   }
}

