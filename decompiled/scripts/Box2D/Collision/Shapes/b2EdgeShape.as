package Box2D.Collision.Shapes
{
   import Box2D.Collision.*;
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.*;
   
   use namespace b2internal;
   
   public class b2EdgeShape extends b2Shape
   {
      
      private var s_supportVec:b2Vec2 = new b2Vec2();
      
      b2internal var m_v1:b2Vec2 = new b2Vec2();
      
      b2internal var m_v2:b2Vec2 = new b2Vec2();
      
      b2internal var m_coreV1:b2Vec2 = new b2Vec2();
      
      b2internal var m_coreV2:b2Vec2 = new b2Vec2();
      
      b2internal var m_length:Number;
      
      b2internal var m_normal:b2Vec2 = new b2Vec2();
      
      b2internal var m_direction:b2Vec2 = new b2Vec2();
      
      b2internal var m_cornerDir1:b2Vec2 = new b2Vec2();
      
      b2internal var m_cornerDir2:b2Vec2 = new b2Vec2();
      
      b2internal var m_cornerConvex1:Boolean;
      
      b2internal var m_cornerConvex2:Boolean;
      
      b2internal var m_nextEdge:b2EdgeShape;
      
      b2internal var m_prevEdge:b2EdgeShape;
      
      public function b2EdgeShape(param1:b2Vec2, param2:b2Vec2, param3:b2ShapeDef)
      {
         super(param3);
         b2internal::m_type = b2internal::e_edgeShape;
         b2internal::m_prevEdge = null;
         b2internal::m_nextEdge = null;
         b2internal::m_v1 = param1;
         b2internal::m_v2 = param2;
         b2internal::m_direction.Set(b2internal::m_v2.x - b2internal::m_v1.x,b2internal::m_v2.y - b2internal::m_v1.y);
         b2internal::m_length = b2internal::m_direction.Normalize();
         b2internal::m_normal.Set(b2internal::m_direction.y,-b2internal::m_direction.x);
         b2internal::m_coreV1.Set(-b2Settings.b2_toiSlop * (b2internal::m_normal.x - b2internal::m_direction.x) + b2internal::m_v1.x,-b2Settings.b2_toiSlop * (b2internal::m_normal.y - b2internal::m_direction.y) + b2internal::m_v1.y);
         b2internal::m_coreV2.Set(-b2Settings.b2_toiSlop * (b2internal::m_normal.x + b2internal::m_direction.x) + b2internal::m_v2.x,-b2Settings.b2_toiSlop * (b2internal::m_normal.y + b2internal::m_direction.y) + b2internal::m_v2.y);
         b2internal::m_cornerDir1 = b2internal::m_normal;
         b2internal::m_cornerDir2.Set(-b2internal::m_normal.x,-b2internal::m_normal.y);
      }
      
      override public function TestPoint(param1:b2XForm, param2:b2Vec2) : Boolean
      {
         return false;
      }
      
      override public function TestSegment(param1:b2XForm, param2:Array, param3:b2Vec2, param4:b2Segment, param5:Number) : int
      {
         var _loc6_:b2Mat22 = null;
         var _loc12_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc7_:Number = param4.p2.x - param4.p1.x;
         var _loc8_:Number = param4.p2.y - param4.p1.y;
         _loc6_ = param1.R;
         var _loc9_:Number = param1.position.x + (_loc6_.col1.x * m_v1.x + _loc6_.col2.x * m_v1.y);
         var _loc10_:Number = param1.position.y + (_loc6_.col1.y * m_v1.x + _loc6_.col2.y * m_v1.y);
         var _loc11_:Number = param1.position.y + (_loc6_.col1.y * m_v2.x + _loc6_.col2.y * m_v2.y) - _loc10_;
         _loc12_ = -(param1.position.x + (_loc6_.col1.x * m_v2.x + _loc6_.col2.x * m_v2.y) - _loc9_);
         var _loc13_:Number = 100 * Number.MIN_VALUE;
         var _loc14_:Number = -(_loc7_ * _loc11_ + _loc8_ * _loc12_);
         if(_loc14_ > _loc13_)
         {
            _loc15_ = param4.p1.x - _loc9_;
            _loc16_ = param4.p1.y - _loc10_;
            _loc17_ = _loc15_ * _loc11_ + _loc16_ * _loc12_;
            if(0 <= _loc17_ && _loc17_ <= param5 * _loc14_)
            {
               _loc18_ = -_loc7_ * _loc16_ + _loc8_ * _loc15_;
               if(-_loc13_ * _loc14_ <= _loc18_ && _loc18_ <= _loc14_ * (1 + _loc13_))
               {
                  _loc17_ /= _loc14_;
                  param2[0] = _loc17_;
                  _loc19_ = Math.sqrt(_loc11_ * _loc11_ + _loc12_ * _loc12_);
                  param3.x = _loc11_ / _loc19_;
                  param3.y = _loc12_ / _loc19_;
                  return e_hitCollide;
               }
            }
         }
         return e_missCollide;
      }
      
      override public function ComputeAABB(param1:b2AABB, param2:b2XForm) : void
      {
         var _loc3_:b2Mat22 = param2.R;
         var _loc4_:Number = param2.position.x + (_loc3_.col1.x * m_v1.x + _loc3_.col2.x * m_v1.y);
         var _loc5_:Number = param2.position.y + (_loc3_.col1.y * m_v1.x + _loc3_.col2.y * m_v1.y);
         var _loc6_:Number = param2.position.x + (_loc3_.col1.x * m_v2.x + _loc3_.col2.x * m_v2.y);
         var _loc7_:Number = param2.position.y + (_loc3_.col1.y * m_v2.x + _loc3_.col2.y * m_v2.y);
         if(_loc4_ < _loc6_)
         {
            param1.lowerBound.x = _loc4_;
            param1.upperBound.x = _loc6_;
         }
         else
         {
            param1.lowerBound.x = _loc6_;
            param1.upperBound.x = _loc4_;
         }
         if(_loc5_ < _loc7_)
         {
            param1.lowerBound.y = _loc5_;
            param1.upperBound.y = _loc7_;
         }
         else
         {
            param1.lowerBound.y = _loc7_;
            param1.upperBound.y = _loc5_;
         }
      }
      
      override public function ComputeSweptAABB(param1:b2AABB, param2:b2XForm, param3:b2XForm) : void
      {
         var _loc4_:b2Mat22 = null;
         _loc4_ = param2.R;
         var _loc5_:Number = param2.position.x + (_loc4_.col1.x * m_v1.x + _loc4_.col2.x * m_v1.y);
         var _loc6_:Number = param2.position.y + (_loc4_.col1.y * m_v1.x + _loc4_.col2.y * m_v1.y);
         var _loc7_:Number = param2.position.x + (_loc4_.col1.x * m_v2.x + _loc4_.col2.x * m_v2.y);
         var _loc8_:Number = param2.position.y + (_loc4_.col1.y * m_v2.x + _loc4_.col2.y * m_v2.y);
         _loc4_ = param3.R;
         var _loc9_:Number = param3.position.x + (_loc4_.col1.x * m_v1.x + _loc4_.col2.x * m_v1.y);
         var _loc10_:Number = param3.position.y + (_loc4_.col1.y * m_v1.x + _loc4_.col2.y * m_v1.y);
         var _loc11_:Number = param3.position.x + (_loc4_.col1.x * m_v2.x + _loc4_.col2.x * m_v2.y);
         var _loc12_:Number = param3.position.y + (_loc4_.col1.y * m_v2.x + _loc4_.col2.y * m_v2.y);
         param1.lowerBound.x = ((_loc5_ < _loc7_ ? _loc5_ : _loc7_) < _loc9_ ? (_loc5_ < _loc7_ ? _loc5_ : _loc7_) : _loc9_) < _loc11_ ? ((_loc5_ < _loc7_ ? _loc5_ : _loc7_) < _loc9_ ? (_loc5_ < _loc7_ ? _loc5_ : _loc7_) : _loc9_) : _loc11_;
         param1.lowerBound.y = ((_loc6_ < _loc8_ ? _loc6_ : _loc8_) < _loc10_ ? (_loc6_ < _loc8_ ? _loc6_ : _loc8_) : _loc10_) < _loc12_ ? ((_loc6_ < _loc8_ ? _loc6_ : _loc8_) < _loc10_ ? (_loc6_ < _loc8_ ? _loc6_ : _loc8_) : _loc10_) : _loc12_;
         param1.upperBound.x = ((_loc5_ > _loc7_ ? _loc5_ : _loc7_) > _loc9_ ? (_loc5_ > _loc7_ ? _loc5_ : _loc7_) : _loc9_) > _loc11_ ? ((_loc5_ > _loc7_ ? _loc5_ : _loc7_) > _loc9_ ? (_loc5_ > _loc7_ ? _loc5_ : _loc7_) : _loc9_) : _loc11_;
         param1.upperBound.y = ((_loc6_ > _loc8_ ? _loc6_ : _loc8_) > _loc10_ ? (_loc6_ > _loc8_ ? _loc6_ : _loc8_) : _loc10_) > _loc12_ ? ((_loc6_ > _loc8_ ? _loc6_ : _loc8_) > _loc10_ ? (_loc6_ > _loc8_ ? _loc6_ : _loc8_) : _loc10_) : _loc12_;
      }
      
      override public function ComputeMass(param1:b2MassData) : void
      {
         param1.mass = 0;
         param1.center.SetV(m_v1);
         param1.I = 0;
      }
      
      override public function ComputeSubmergedArea(param1:b2Vec2, param2:Number, param3:b2XForm, param4:b2Vec2) : Number
      {
         var _loc5_:b2Vec2 = new b2Vec2(param1.x * param2,param1.y * param2);
         var _loc6_:b2Vec2 = b2Math.b2MulX(param3,m_v1);
         var _loc7_:b2Vec2 = b2Math.b2MulX(param3,m_v2);
         var _loc8_:Number = b2Math.b2Dot(param1,_loc6_) - param2;
         var _loc9_:Number = b2Math.b2Dot(param1,_loc7_) - param2;
         if(_loc8_ > 0)
         {
            if(_loc9_ > 0)
            {
               return 0;
            }
            _loc6_.x = -_loc9_ / (_loc8_ - _loc9_) * _loc6_.x + _loc8_ / (_loc8_ - _loc9_) * _loc7_.x;
            _loc6_.y = -_loc9_ / (_loc8_ - _loc9_) * _loc6_.y + _loc8_ / (_loc8_ - _loc9_) * _loc7_.y;
         }
         else if(_loc9_ > 0)
         {
            _loc7_.x = -_loc9_ / (_loc8_ - _loc9_) * _loc6_.x + _loc8_ / (_loc8_ - _loc9_) * _loc7_.x;
            _loc7_.y = -_loc9_ / (_loc8_ - _loc9_) * _loc6_.y + _loc8_ / (_loc8_ - _loc9_) * _loc7_.y;
         }
         param4.x = (_loc5_.x + _loc6_.x + _loc7_.x) / 3;
         param4.y = (_loc5_.y + _loc6_.y + _loc7_.y) / 3;
         return 0.5 * ((_loc6_.x - _loc5_.x) * (_loc7_.y - _loc5_.y) - (_loc6_.y - _loc5_.y) * (_loc7_.x - _loc5_.x));
      }
      
      public function GetLength() : Number
      {
         return m_length;
      }
      
      public function GetVertex1() : b2Vec2
      {
         return m_v1;
      }
      
      public function GetVertex2() : b2Vec2
      {
         return m_v2;
      }
      
      public function GetCoreVertex1() : b2Vec2
      {
         return m_coreV1;
      }
      
      public function GetCoreVertex2() : b2Vec2
      {
         return m_coreV2;
      }
      
      public function GetNormalVector() : b2Vec2
      {
         return m_normal;
      }
      
      public function GetDirectionVector() : b2Vec2
      {
         return m_direction;
      }
      
      public function GetCorner1Vector() : b2Vec2
      {
         return m_cornerDir1;
      }
      
      public function GetCorner2Vector() : b2Vec2
      {
         return m_cornerDir2;
      }
      
      public function Corner1IsConvex() : Boolean
      {
         return m_cornerConvex1;
      }
      
      public function Corner2IsConvex() : Boolean
      {
         return m_cornerConvex2;
      }
      
      public function GetFirstVertex(param1:b2XForm) : b2Vec2
      {
         var _loc2_:b2Mat22 = param1.R;
         return new b2Vec2(param1.position.x + (_loc2_.col1.x * m_coreV1.x + _loc2_.col2.x * m_coreV1.y),param1.position.y + (_loc2_.col1.y * m_coreV1.x + _loc2_.col2.y * m_coreV1.y));
      }
      
      public function GetNextEdge() : b2EdgeShape
      {
         return m_nextEdge;
      }
      
      public function GetPrevEdge() : b2EdgeShape
      {
         return m_prevEdge;
      }
      
      public function Support(param1:b2XForm, param2:Number, param3:Number) : b2Vec2
      {
         var _loc4_:b2Mat22 = param1.R;
         var _loc5_:Number = param1.position.x + (_loc4_.col1.x * m_coreV1.x + _loc4_.col2.x * m_coreV1.y);
         var _loc6_:Number = param1.position.y + (_loc4_.col1.y * m_coreV1.x + _loc4_.col2.y * m_coreV1.y);
         var _loc7_:Number = param1.position.x + (_loc4_.col1.x * m_coreV2.x + _loc4_.col2.x * m_coreV2.y);
         var _loc8_:Number = param1.position.y + (_loc4_.col1.y * m_coreV2.x + _loc4_.col2.y * m_coreV2.y);
         if(_loc5_ * param2 + _loc6_ * param3 > _loc7_ * param2 + _loc8_ * param3)
         {
            s_supportVec.x = _loc5_;
            s_supportVec.y = _loc6_;
         }
         else
         {
            s_supportVec.x = _loc7_;
            s_supportVec.y = _loc8_;
         }
         return s_supportVec;
      }
      
      override b2internal function UpdateSweepRadius(param1:b2Vec2) : void
      {
         var _loc2_:Number = m_coreV1.x - param1.x;
         var _loc3_:Number = m_coreV1.y - param1.y;
         var _loc4_:Number = _loc2_ * _loc2_ + _loc3_ * _loc3_;
         _loc2_ = m_coreV2.x - param1.x;
         _loc3_ = m_coreV2.y - param1.y;
         var _loc5_:Number = _loc2_ * _loc2_ + _loc3_ * _loc3_;
         m_sweepRadius = Math.sqrt(_loc4_ > _loc5_ ? _loc4_ : _loc5_);
      }
      
      b2internal function SetPrevEdge(param1:b2EdgeShape, param2:b2Vec2, param3:b2Vec2, param4:Boolean) : void
      {
         m_prevEdge = param1;
         m_coreV1 = param2;
         m_cornerDir1 = param3;
         m_cornerConvex1 = param4;
      }
      
      b2internal function SetNextEdge(param1:b2EdgeShape, param2:b2Vec2, param3:b2Vec2, param4:Boolean) : void
      {
         m_nextEdge = param1;
         m_coreV2 = param2;
         m_cornerDir2 = param3;
         m_cornerConvex2 = param4;
      }
   }
}

