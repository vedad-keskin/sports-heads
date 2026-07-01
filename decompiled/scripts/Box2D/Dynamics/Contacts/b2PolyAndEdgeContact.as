package Box2D.Dynamics.Contacts
{
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.*;
   
   use namespace b2internal;
   
   public class b2PolyAndEdgeContact extends b2Contact
   {
      
      private static const s_evalCP:b2ContactPoint = new b2ContactPoint();
      
      private var m_manifolds:Array = [new b2Manifold()];
      
      private var m_manifold:b2Manifold;
      
      private var m0:b2Manifold = new b2Manifold();
      
      public function b2PolyAndEdgeContact(param1:b2Shape, param2:b2Shape)
      {
         super(param1,param2);
         m_manifold = m_manifolds[0];
         b2Settings.b2Assert(b2internal::m_shape1.m_type == b2Shape.e_polygonShape);
         b2Settings.b2Assert(b2internal::m_shape2.m_type == b2Shape.e_edgeShape);
         m_manifold.pointCount = 0;
      }
      
      public static function Create(param1:b2Shape, param2:b2Shape, param3:*) : b2Contact
      {
         return new b2PolyAndEdgeContact(param1,param2);
      }
      
      public static function Destroy(param1:b2Contact, param2:*) : void
      {
      }
      
      override b2internal function Evaluate(param1:b2ContactListener) : void
      {
         var _loc2_:int = 0;
         var _loc3_:b2Vec2 = null;
         var _loc4_:b2Vec2 = null;
         var _loc5_:b2ManifoldPoint = null;
         var _loc10_:b2ManifoldPoint = null;
         var _loc11_:Boolean = false;
         var _loc12_:uint = 0;
         var _loc13_:int = 0;
         var _loc6_:b2Body = m_shape1.m_body;
         var _loc7_:b2Body = m_shape2.m_body;
         m0.Set(m_manifold);
         b2CollidePolyAndEdge(m_manifold,m_shape1 as b2PolygonShape,_loc6_.m_xf,m_shape2 as b2EdgeShape,_loc7_.m_xf);
         var _loc8_:Array = [false,false];
         var _loc9_:b2ContactPoint = s_evalCP;
         _loc9_.shape1 = m_shape1;
         _loc9_.shape2 = m_shape2;
         _loc9_.friction = b2Settings.b2MixFriction(m_shape1.GetFriction(),m_shape2.GetFriction());
         _loc9_.restitution = b2Settings.b2MixRestitution(m_shape1.GetRestitution(),m_shape2.GetRestitution());
         if(m_manifold.pointCount > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < m_manifold.pointCount)
            {
               _loc10_ = m_manifold.points[_loc2_];
               _loc10_.normalImpulse = 0;
               _loc10_.tangentImpulse = 0;
               _loc11_ = false;
               _loc12_ = _loc10_.id._key;
               _loc13_ = 0;
               while(_loc13_ < m0.pointCount)
               {
                  if(_loc8_[_loc13_] != true)
                  {
                     _loc5_ = m0.points[_loc13_];
                     if(_loc5_.id._key == _loc12_)
                     {
                        _loc8_[_loc13_] = true;
                        _loc10_.normalImpulse = _loc5_.normalImpulse;
                        _loc10_.tangentImpulse = _loc5_.tangentImpulse;
                        _loc11_ = true;
                        if(param1 != null)
                        {
                           _loc9_.position = _loc6_.GetWorldPoint(_loc10_.localPoint1);
                           _loc3_ = _loc6_.GetLinearVelocityFromLocalPoint(_loc10_.localPoint1);
                           _loc4_ = _loc7_.GetLinearVelocityFromLocalPoint(_loc10_.localPoint2);
                           _loc9_.velocity.Set(_loc4_.x - _loc3_.x,_loc4_.y - _loc3_.y);
                           _loc9_.normal.SetV(m_manifold.normal);
                           _loc9_.separation = _loc10_.separation;
                           _loc9_.id.key = _loc12_;
                           param1.Persist(_loc9_);
                        }
                        break;
                     }
                  }
                  _loc13_++;
               }
               if(_loc11_ == false && param1 != null)
               {
                  _loc9_.position = _loc6_.GetWorldPoint(_loc10_.localPoint1);
                  _loc3_ = _loc6_.GetLinearVelocityFromLocalPoint(_loc10_.localPoint1);
                  _loc4_ = _loc7_.GetLinearVelocityFromLocalPoint(_loc10_.localPoint2);
                  _loc9_.velocity.Set(_loc4_.x - _loc3_.x,_loc4_.y - _loc3_.y);
                  _loc9_.normal.SetV(m_manifold.normal);
                  _loc9_.separation = _loc10_.separation;
                  _loc9_.id.key = _loc12_;
                  param1.Add(_loc9_);
               }
               _loc2_++;
            }
            m_manifoldCount = 1;
         }
         else
         {
            m_manifoldCount = 0;
         }
         if(param1 == null)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < m0.pointCount)
         {
            if(!_loc8_[_loc2_])
            {
               _loc5_ = m0.points[_loc2_];
               _loc9_.position = _loc6_.GetWorldPoint(_loc5_.localPoint1);
               _loc3_ = _loc6_.GetLinearVelocityFromLocalPoint(_loc5_.localPoint1);
               _loc4_ = _loc7_.GetLinearVelocityFromLocalPoint(_loc5_.localPoint2);
               _loc9_.velocity.Set(_loc4_.x - _loc3_.x,_loc4_.y - _loc3_.y);
               _loc9_.normal.SetV(m0.normal);
               _loc9_.separation = _loc5_.separation;
               _loc9_.id.key = _loc5_.id._key;
               param1.Remove(_loc9_);
            }
            _loc2_++;
         }
      }
      
      private function b2CollidePolyAndEdge(param1:b2Manifold, param2:b2PolygonShape, param3:b2XForm, param4:b2EdgeShape, param5:b2XForm) : void
      {
         var _loc6_:b2Mat22 = null;
         var _loc7_:b2Vec2 = null;
         var _loc8_:b2Vec2 = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:b2ManifoldPoint = null;
         var _loc12_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc48_:Number = NaN;
         param1.pointCount = 0;
         _loc6_ = param5.R;
         _loc7_ = param4.m_v1;
         var _loc13_:Number = param5.position.x + (_loc6_.col1.x * _loc7_.x + _loc6_.col2.x * _loc7_.y);
         var _loc14_:Number = param5.position.y + (_loc6_.col1.y * _loc7_.x + _loc6_.col2.y * _loc7_.y);
         _loc7_ = param4.m_v2;
         var _loc15_:Number = param5.position.x + (_loc6_.col1.x * _loc7_.x + _loc6_.col2.x * _loc7_.y);
         var _loc16_:Number = param5.position.y + (_loc6_.col1.y * _loc7_.x + _loc6_.col2.y * _loc7_.y);
         _loc7_ = param4.m_normal;
         var _loc17_:Number = _loc6_.col1.x * _loc7_.x + _loc6_.col2.x * _loc7_.y;
         var _loc18_:Number = _loc6_.col1.y * _loc7_.x + _loc6_.col2.y * _loc7_.y;
         _loc6_ = param3.R;
         _loc9_ = _loc13_ - param3.position.x;
         _loc10_ = _loc14_ - param3.position.y;
         var _loc19_:Number = _loc9_ * _loc6_.col1.x + _loc10_ * _loc6_.col1.y;
         var _loc20_:Number = _loc9_ * _loc6_.col2.x + _loc10_ * _loc6_.col2.y;
         _loc9_ = _loc15_ - param3.position.x;
         _loc10_ = _loc16_ - param3.position.y;
         var _loc21_:Number = _loc9_ * _loc6_.col1.x + _loc10_ * _loc6_.col1.y;
         var _loc22_:Number = _loc9_ * _loc6_.col2.x + _loc10_ * _loc6_.col2.y;
         var _loc23_:Number = _loc17_ * _loc6_.col1.x + _loc18_ * _loc6_.col1.y;
         var _loc24_:Number = _loc17_ * _loc6_.col2.x + _loc18_ * _loc6_.col2.y;
         var _loc26_:int = -1;
         var _loc27_:Number = -Number.MAX_VALUE;
         var _loc29_:int = -1;
         var _loc30_:Number = -Number.MAX_VALUE;
         var _loc31_:Number = -Number.MAX_VALUE;
         var _loc32_:Boolean = false;
         var _loc33_:int = -1;
         var _loc34_:int = param2.m_vertexCount;
         var _loc35_:Array = param2.m_vertices;
         var _loc36_:Array = param2.m_normals;
         var _loc37_:int = -1;
         var _loc38_:int = -1;
         var _loc39_:int = -1;
         var _loc40_:int = -1;
         var _loc41_:Number = 0;
         var _loc42_:Number = 0;
         var _loc43_:Number = 0;
         var _loc44_:Number = 0;
         var _loc45_:Number = Number.MAX_VALUE;
         _loc7_ = _loc35_[_loc34_ - 1];
         _loc41_ = (_loc7_.x - _loc19_) * _loc23_ + (_loc7_.y - _loc20_) * _loc24_;
         var _loc46_:int = 0;
         while(_loc46_ < _loc34_)
         {
            _loc7_ = _loc35_[_loc46_];
            _loc8_ = _loc36_[_loc46_];
            _loc25_ = (_loc19_ - _loc7_.x) * _loc8_.x + (_loc20_ - _loc7_.y) * _loc8_.y;
            _loc28_ = (_loc21_ - _loc7_.x) * _loc8_.x + (_loc22_ - _loc7_.y) * _loc8_.y;
            if(_loc28_ < _loc25_)
            {
               if(_loc28_ > _loc31_)
               {
                  _loc31_ = _loc28_;
                  _loc32_ = false;
                  _loc33_ = _loc46_;
               }
            }
            else if(_loc25_ > _loc31_)
            {
               _loc31_ = _loc25_;
               _loc32_ = true;
               _loc33_ = _loc46_;
            }
            if(_loc25_ > _loc27_)
            {
               _loc27_ = _loc25_;
               _loc26_ = _loc46_;
            }
            if(_loc28_ > _loc30_)
            {
               _loc30_ = _loc28_;
               _loc29_ = _loc46_;
            }
            _loc42_ = (_loc7_.x - _loc19_) * _loc23_ + (_loc7_.y - _loc20_) * _loc24_;
            if(_loc42_ >= 0 && _loc41_ < 0)
            {
               _loc39_ = _loc46_ == 0 ? int(_loc34_ - 1) : int(_loc46_ - 1);
               _loc40_ = _loc46_;
               _loc44_ = _loc41_;
            }
            else if(_loc42_ < 0 && _loc41_ >= 0)
            {
               _loc37_ = _loc46_ == 0 ? int(_loc34_ - 1) : int(_loc46_ - 1);
               _loc38_ = _loc46_;
               _loc43_ = _loc42_;
            }
            if(_loc42_ < _loc45_)
            {
               _loc45_ = _loc42_;
            }
            _loc41_ = _loc42_;
            _loc46_++;
         }
         if(_loc37_ == -1)
         {
            return;
         }
         if(_loc31_ > 0)
         {
            return;
         }
         if(_loc32_ && param4.m_cornerConvex1 || !_loc32_ && param4.m_cornerConvex2)
         {
            if(_loc31_ > _loc45_ + b2Settings.b2_linearSlop)
            {
               if(_loc32_)
               {
                  _loc6_ = param5.R;
                  _loc7_ = param4.m_cornerDir1;
                  _loc9_ = _loc6_.col1.x * _loc7_.x + _loc6_.col2.x * _loc7_.y;
                  _loc10_ = _loc6_.col1.y * _loc7_.x + _loc6_.col2.y * _loc7_.y;
                  _loc6_ = param3.R;
                  _loc13_ = _loc6_.col1.x * _loc9_ + _loc6_.col2.x * _loc10_;
                  _loc14_ = _loc6_.col1.y * _loc9_ + _loc6_.col2.y * _loc10_;
                  _loc8_ = _loc36_[_loc26_];
                  if(_loc8_.x * _loc13_ + _loc8_.y * _loc14_ >= 0)
                  {
                     return;
                  }
               }
               else
               {
                  _loc6_ = param5.R;
                  _loc7_ = param4.m_cornerDir2;
                  _loc9_ = _loc6_.col1.x * _loc7_.x + _loc6_.col2.x * _loc7_.y;
                  _loc10_ = _loc6_.col1.y * _loc7_.x + _loc6_.col2.y * _loc7_.y;
                  _loc6_ = param3.R;
                  _loc13_ = _loc6_.col1.x * _loc9_ + _loc6_.col2.x * _loc10_;
                  _loc14_ = _loc6_.col1.y * _loc9_ + _loc6_.col2.y * _loc10_;
                  _loc8_ = _loc36_[_loc29_];
                  if(_loc8_.x * _loc13_ + _loc8_.y * _loc14_ <= 0)
                  {
                     return;
                  }
               }
               _loc11_ = param1.points[0];
               param1.pointCount = 1;
               _loc6_ = param3.R;
               _loc8_ = _loc36_[_loc33_];
               param1.normal.x = _loc6_.col1.x * _loc8_.x + _loc6_.col2.x * _loc8_.y;
               param1.normal.y = _loc6_.col1.y * _loc8_.x + _loc6_.col2.y * _loc8_.y;
               _loc11_.separation = _loc31_;
               _loc11_.id.features.incidentEdge = _loc33_;
               _loc11_.id.features.incidentVertex = b2Collision.b2_nullFeature;
               _loc11_.id.features.referenceEdge = 0;
               _loc11_.id.features.flip = 0;
               if(_loc32_)
               {
                  _loc11_.localPoint1.x = _loc19_;
                  _loc11_.localPoint1.y = _loc20_;
                  _loc11_.localPoint2.x = param4.m_v1.x;
                  _loc11_.localPoint2.y = param4.m_v1.y;
               }
               else
               {
                  _loc11_.localPoint1.x = _loc21_;
                  _loc11_.localPoint1.y = _loc22_;
                  _loc11_.localPoint2.x = param4.m_v2.x;
                  _loc11_.localPoint2.y = param4.m_v2.y;
               }
               return;
            }
         }
         param1.normal.x = -_loc17_;
         param1.normal.y = -_loc18_;
         if(_loc38_ == _loc39_)
         {
            _loc11_ = param1.points[0];
            param1.pointCount = 1;
            _loc11_.id.features.incidentEdge = _loc38_;
            _loc11_.id.features.incidentVertex = b2Collision.b2_nullFeature;
            _loc11_.id.features.referenceEdge = 0;
            _loc11_.id.features.flip = 0;
            _loc7_ = _loc35_[_loc38_];
            _loc11_.localPoint1.x = _loc7_.x;
            _loc11_.localPoint1.y = _loc7_.y;
            _loc6_ = param3.R;
            _loc9_ = param3.position.x + (_loc6_.col1.x * _loc7_.x + _loc6_.col2.x * _loc7_.y) - param5.position.x;
            _loc10_ = param3.position.y + (_loc6_.col1.y * _loc7_.x + _loc6_.col2.y * _loc7_.y) - param5.position.y;
            _loc6_ = param5.R;
            _loc11_.localPoint2.x = _loc9_ * _loc6_.col1.x + _loc10_ * _loc6_.col1.y;
            _loc11_.localPoint2.y = _loc9_ * _loc6_.col2.x + _loc10_ * _loc6_.col2.y;
            _loc11_.separation = _loc43_;
            return;
         }
         param1.pointCount = 2;
         _loc9_ = -_loc24_;
         _loc10_ = _loc23_;
         _loc7_ = _loc35_[_loc38_];
         var _loc47_:Number = _loc9_ * (_loc7_.x - _loc19_) + _loc10_ * (_loc7_.y - _loc20_);
         _loc40_ = _loc38_ == _loc34_ - 1 ? 0 : int(_loc38_ + 1);
         _loc7_ = _loc35_[_loc39_];
         if(_loc40_ != _loc39_)
         {
            _loc39_ = _loc40_;
            _loc44_ = _loc23_ * (_loc7_.x - _loc19_) + _loc24_ * (_loc7_.y - _loc20_);
         }
         _loc48_ = _loc9_ * (_loc7_.x - _loc19_) + _loc10_ * (_loc7_.y - _loc20_);
         _loc11_ = param1.points[0];
         _loc11_.id.features.incidentEdge = _loc38_;
         _loc11_.id.features.incidentVertex = b2Collision.b2_nullFeature;
         _loc11_.id.features.referenceEdge = 0;
         _loc11_.id.features.flip = 0;
         if(_loc47_ > param4.m_length)
         {
            _loc11_.localPoint1.x = _loc21_;
            _loc11_.localPoint1.y = _loc22_;
            _loc11_.localPoint2.x = param4.m_v2.x;
            _loc11_.localPoint2.y = param4.m_v2.y;
            _loc12_ = (param4.m_length - _loc48_) / (_loc47_ - _loc48_);
            if(_loc12_ > 100 * Number.MIN_VALUE && _loc12_ < 1)
            {
               _loc11_.separation = _loc44_ * (1 - _loc12_) + _loc43_ * _loc12_;
            }
            else
            {
               _loc11_.separation = _loc43_;
            }
         }
         else
         {
            _loc7_ = _loc35_[_loc38_];
            _loc11_.localPoint1.x = _loc7_.x;
            _loc11_.localPoint1.y = _loc7_.y;
            _loc6_ = param3.R;
            _loc9_ = param3.position.x + (_loc6_.col1.x * _loc7_.x + _loc6_.col2.x * _loc7_.y) - param5.position.x;
            _loc10_ = param3.position.y + (_loc6_.col1.y * _loc7_.x + _loc6_.col2.y * _loc7_.y) - param5.position.y;
            _loc6_ = param5.R;
            _loc11_.localPoint2.x = _loc9_ * _loc6_.col1.x + _loc10_ * _loc6_.col1.y;
            _loc11_.localPoint2.y = _loc9_ * _loc6_.col2.x + _loc10_ * _loc6_.col2.y;
            _loc11_.separation = _loc43_;
         }
         _loc11_ = param1.points[1];
         _loc11_.id.features.incidentEdge = _loc39_;
         _loc11_.id.features.incidentVertex = b2Collision.b2_nullFeature;
         _loc11_.id.features.referenceEdge = 0;
         _loc11_.id.features.flip = 0;
         if(_loc48_ < 0)
         {
            _loc11_.localPoint1.x = _loc19_;
            _loc11_.localPoint1.y = _loc20_;
            _loc11_.localPoint2.x = param4.m_v1.x;
            _loc11_.localPoint2.y = param4.m_v1.y;
            _loc12_ = -_loc47_ / (_loc48_ - _loc47_);
            if(_loc12_ > 100 * Number.MIN_VALUE && _loc12_ < 1)
            {
               _loc11_.separation = _loc43_ * (1 - _loc12_) + _loc44_ * _loc12_;
            }
            else
            {
               _loc11_.separation = _loc44_;
            }
         }
         else
         {
            _loc7_ = _loc35_[_loc39_];
            _loc11_.localPoint1.x = _loc7_.x;
            _loc11_.localPoint1.y = _loc7_.y;
            _loc6_ = param3.R;
            _loc9_ = param3.position.x + (_loc6_.col1.x * _loc7_.x + _loc6_.col2.x * _loc7_.y) - param5.position.x;
            _loc10_ = param3.position.y + (_loc6_.col1.y * _loc7_.x + _loc6_.col2.y * _loc7_.y) - param5.position.y;
            _loc6_ = param5.R;
            _loc11_.localPoint2.x = _loc9_ * _loc6_.col1.x + _loc10_ * _loc6_.col1.y;
            _loc11_.localPoint2.y = _loc9_ * _loc6_.col2.x + _loc10_ * _loc6_.col2.y;
            _loc11_.separation = _loc44_;
         }
      }
      
      override public function GetManifolds() : Array
      {
         return m_manifolds;
      }
   }
}

