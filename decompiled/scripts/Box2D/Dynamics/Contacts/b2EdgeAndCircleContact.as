package Box2D.Dynamics.Contacts
{
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.*;
   
   use namespace b2internal;
   
   public class b2EdgeAndCircleContact extends b2Contact
   {
      
      private static const s_evalCP:b2ContactPoint = new b2ContactPoint();
      
      private var m_manifolds:Array = [new b2Manifold()];
      
      private var m_manifold:b2Manifold;
      
      private var m0:b2Manifold = new b2Manifold();
      
      public function b2EdgeAndCircleContact(param1:b2Shape, param2:b2Shape)
      {
         super(param1,param2);
         m_manifold = m_manifolds[0];
         m_manifold.pointCount = 0;
         var _loc3_:b2ManifoldPoint = m_manifold.points[0];
         _loc3_.normalImpulse = 0;
         _loc3_.tangentImpulse = 0;
      }
      
      public static function Create(param1:b2Shape, param2:b2Shape, param3:*) : b2Contact
      {
         return new b2EdgeAndCircleContact(param1,param2);
      }
      
      public static function Destroy(param1:b2Contact, param2:*) : void
      {
      }
      
      override b2internal function Evaluate(param1:b2ContactListener) : void
      {
         var _loc2_:b2Vec2 = null;
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2ManifoldPoint = null;
         var _loc8_:b2ManifoldPoint = null;
         var _loc5_:b2Body = m_shape1.m_body;
         var _loc6_:b2Body = m_shape2.m_body;
         m0.Set(m_manifold);
         b2CollideEdgeAndCircle(m_manifold,m_shape1 as b2EdgeShape,_loc5_.m_xf,m_shape2 as b2CircleShape,_loc6_.m_xf);
         var _loc7_:b2ContactPoint = s_evalCP;
         _loc7_.shape1 = m_shape1;
         _loc7_.shape2 = m_shape2;
         _loc7_.friction = b2Settings.b2MixFriction(m_shape1.GetFriction(),m_shape2.GetFriction());
         _loc7_.restitution = b2Settings.b2MixRestitution(m_shape1.GetRestitution(),m_shape2.GetRestitution());
         if(m_manifold.pointCount > 0)
         {
            m_manifoldCount = 1;
            _loc8_ = m_manifold.points[0];
            if(m0.pointCount == 0)
            {
               _loc8_.normalImpulse = 0;
               _loc8_.tangentImpulse = 0;
               if(param1)
               {
                  _loc7_.position = _loc5_.GetWorldPoint(_loc8_.localPoint1);
                  _loc2_ = _loc5_.GetLinearVelocityFromLocalPoint(_loc8_.localPoint1);
                  _loc3_ = _loc6_.GetLinearVelocityFromLocalPoint(_loc8_.localPoint2);
                  _loc7_.velocity.Set(_loc3_.x - _loc2_.x,_loc3_.y - _loc2_.y);
                  _loc7_.normal.SetV(m_manifold.normal);
                  _loc7_.separation = _loc8_.separation;
                  _loc7_.id.key = _loc8_.id._key;
                  param1.Add(_loc7_);
               }
            }
            else
            {
               _loc4_ = m0.points[0];
               _loc8_.normalImpulse = _loc4_.normalImpulse;
               _loc8_.tangentImpulse = _loc4_.tangentImpulse;
               if(param1)
               {
                  _loc7_.position = _loc5_.GetWorldPoint(_loc8_.localPoint1);
                  _loc2_ = _loc5_.GetLinearVelocityFromLocalPoint(_loc8_.localPoint1);
                  _loc3_ = _loc6_.GetLinearVelocityFromLocalPoint(_loc8_.localPoint2);
                  _loc7_.velocity.Set(_loc3_.x - _loc2_.x,_loc3_.y - _loc2_.y);
                  _loc7_.normal.SetV(m_manifold.normal);
                  _loc7_.separation = _loc8_.separation;
                  _loc7_.id.key = _loc8_.id._key;
                  param1.Persist(_loc7_);
               }
            }
         }
         else
         {
            m_manifoldCount = 0;
            if(m0.pointCount > 0 && Boolean(param1))
            {
               _loc4_ = m0.points[0];
               _loc7_.position = _loc5_.GetWorldPoint(_loc4_.localPoint1);
               _loc2_ = _loc5_.GetLinearVelocityFromLocalPoint(_loc4_.localPoint1);
               _loc3_ = _loc6_.GetLinearVelocityFromLocalPoint(_loc4_.localPoint2);
               _loc7_.velocity.Set(_loc3_.x - _loc2_.x,_loc3_.y - _loc2_.y);
               _loc7_.normal.SetV(m0.normal);
               _loc7_.separation = _loc4_.separation;
               _loc7_.id.key = _loc4_.id._key;
               param1.Remove(_loc7_);
            }
         }
      }
      
      private function b2CollideEdgeAndCircle(param1:b2Manifold, param2:b2EdgeShape, param3:b2XForm, param4:b2CircleShape, param5:b2XForm) : void
      {
         var _loc6_:b2Mat22 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:b2ManifoldPoint = null;
         var _loc21_:Number = NaN;
         var _loc24_:Number = NaN;
         param1.pointCount = 0;
         _loc6_ = param5.R;
         _loc7_ = param4.m_localPosition;
         var _loc13_:Number = param5.position.x + (_loc6_.col1.x * _loc7_.x + _loc6_.col2.x * _loc7_.y);
         var _loc14_:Number = param5.position.y + (_loc6_.col1.y * _loc7_.x + _loc6_.col2.y * _loc7_.y);
         _loc6_ = param3.R;
         _loc10_ = _loc13_ - param3.position.x;
         _loc11_ = _loc14_ - param3.position.y;
         var _loc15_:Number = _loc10_ * _loc6_.col1.x + _loc11_ * _loc6_.col1.y;
         var _loc16_:Number = _loc10_ * _loc6_.col2.x + _loc11_ * _loc6_.col2.y;
         var _loc17_:b2Vec2 = param2.m_normal;
         var _loc18_:b2Vec2 = param2.m_v1;
         var _loc19_:b2Vec2 = param2.m_v2;
         var _loc20_:Number = param4.m_radius;
         var _loc22_:Number = (_loc15_ - _loc18_.x) * param2.m_direction.x + (_loc16_ - _loc18_.y) * param2.m_direction.y;
         var _loc23_:Boolean = false;
         if(_loc22_ <= 0)
         {
            _loc8_ = _loc15_ - _loc18_.x;
            _loc9_ = _loc16_ - _loc18_.y;
            if(_loc8_ * param2.m_cornerDir1.x + _loc9_ * param2.m_cornerDir1.y < 0)
            {
               return;
            }
            _loc8_ = _loc13_ - (param3.position.x + (_loc6_.col1.x * _loc18_.x + _loc6_.col2.x * _loc18_.y));
            _loc9_ = _loc14_ - (param3.position.y + (_loc6_.col1.y * _loc18_.x + _loc6_.col2.y * _loc18_.y));
         }
         else if(_loc22_ >= param2.m_length)
         {
            _loc8_ = _loc15_ - _loc19_.x;
            _loc9_ = _loc16_ - _loc19_.y;
            if(_loc8_ * param2.m_cornerDir2.x + _loc9_ * param2.m_cornerDir2.y > 0)
            {
               return;
            }
            _loc8_ = _loc13_ - (param3.position.x + (_loc6_.col1.x * _loc19_.x + _loc6_.col2.x * _loc19_.y));
            _loc9_ = _loc14_ - (param3.position.y + (_loc6_.col1.y * _loc19_.x + _loc6_.col2.y * _loc19_.y));
         }
         else
         {
            _loc21_ = (_loc15_ - _loc18_.x) * _loc17_.x + (_loc16_ - _loc18_.y) * _loc17_.y;
            if(_loc21_ > _loc20_ || _loc21_ < -_loc20_)
            {
               return;
            }
            _loc21_ -= _loc20_;
            _loc6_ = param3.R;
            param1.normal.x = _loc6_.col1.x * _loc17_.x + _loc6_.col2.x * _loc17_.y;
            param1.normal.y = _loc6_.col1.y * _loc17_.x + _loc6_.col2.y * _loc17_.y;
            _loc23_ = true;
         }
         if(!_loc23_)
         {
            _loc24_ = _loc8_ * _loc8_ + _loc9_ * _loc9_;
            if(_loc24_ > _loc20_ * _loc20_)
            {
               return;
            }
            if(_loc24_ < Number.MIN_VALUE)
            {
               _loc21_ = -_loc20_;
               param1.normal.x = _loc6_.col1.x * _loc17_.x + _loc6_.col2.x * _loc17_.y;
               param1.normal.y = _loc6_.col1.y * _loc17_.x + _loc6_.col2.y * _loc17_.y;
            }
            else
            {
               _loc24_ = Math.sqrt(_loc24_);
               _loc8_ /= _loc24_;
               _loc9_ /= _loc24_;
               _loc21_ = _loc24_ - _loc20_;
               param1.normal.x = _loc8_;
               param1.normal.y = _loc9_;
            }
         }
         _loc12_ = param1.points[0];
         param1.pointCount = 1;
         _loc12_.id.key = 0;
         _loc12_.separation = _loc21_;
         _loc13_ -= _loc20_ * param1.normal.x;
         _loc14_ -= _loc20_ * param1.normal.y;
         _loc10_ = _loc13_ - param3.position.x;
         _loc11_ = _loc14_ - param3.position.y;
         _loc12_.localPoint1.x = _loc10_ * _loc6_.col1.x + _loc11_ * _loc6_.col1.y;
         _loc12_.localPoint1.y = _loc10_ * _loc6_.col2.x + _loc11_ * _loc6_.col2.y;
         _loc6_ = param5.R;
         _loc10_ = _loc13_ - param5.position.x;
         _loc11_ = _loc14_ - param5.position.y;
         _loc12_.localPoint2.x = _loc10_ * _loc6_.col1.x + _loc11_ * _loc6_.col1.y;
         _loc12_.localPoint2.y = _loc10_ * _loc6_.col2.x + _loc11_ * _loc6_.col2.y;
      }
      
      override public function GetManifolds() : Array
      {
         return m_manifolds;
      }
   }
}

