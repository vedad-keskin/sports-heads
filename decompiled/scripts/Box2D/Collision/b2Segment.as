package Box2D.Collision
{
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   
   use namespace b2internal;
   
   public class b2Segment
   {
      
      public var p1:b2Vec2 = new b2Vec2();
      
      public var p2:b2Vec2 = new b2Vec2();
      
      public function b2Segment()
      {
         super();
      }
      
      public function TestSegment(param1:Array, param2:b2Vec2, param3:b2Segment, param4:Number) : Boolean
      {
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc5_:b2Vec2 = param3.p1;
         var _loc6_:Number = param3.p2.x - _loc5_.x;
         var _loc7_:Number = param3.p2.y - _loc5_.y;
         var _loc8_:Number = p2.x - p1.x;
         var _loc9_:Number;
         var _loc10_:Number = _loc9_ = p2.y - p1.y;
         var _loc11_:Number = -_loc8_;
         var _loc12_:Number = 100 * Number.MIN_VALUE;
         var _loc13_:Number = -(_loc6_ * _loc10_ + _loc7_ * _loc11_);
         if(_loc13_ > _loc12_)
         {
            _loc14_ = _loc5_.x - p1.x;
            _loc15_ = _loc5_.y - p1.y;
            _loc16_ = _loc14_ * _loc10_ + _loc15_ * _loc11_;
            if(0 <= _loc16_ && _loc16_ <= param4 * _loc13_)
            {
               _loc17_ = -_loc6_ * _loc15_ + _loc7_ * _loc14_;
               if(-_loc12_ * _loc13_ <= _loc17_ && _loc17_ <= _loc13_ * (1 + _loc12_))
               {
                  _loc16_ /= _loc13_;
                  _loc18_ = Math.sqrt(_loc10_ * _loc10_ + _loc11_ * _loc11_);
                  _loc10_ /= _loc18_;
                  _loc11_ /= _loc18_;
                  param1[0] = _loc16_;
                  param2.Set(_loc10_,_loc11_);
                  return true;
               }
            }
         }
         return false;
      }
      
      public function Extend(param1:b2AABB) : void
      {
         ExtendForward(param1);
         ExtendBackward(param1);
      }
      
      public function ExtendForward(param1:b2AABB) : void
      {
         var _loc4_:Number = NaN;
         var _loc2_:Number = p2.x - p1.x;
         var _loc3_:Number = p2.y - p1.y;
         _loc4_ = Math.min(_loc2_ > 0 ? (param1.upperBound.x - p1.x) / _loc2_ : (_loc2_ < 0 ? (param1.lowerBound.x - p1.x) / _loc2_ : Number.POSITIVE_INFINITY),_loc3_ > 0 ? (param1.upperBound.y - p1.y) / _loc3_ : (_loc3_ < 0 ? (param1.lowerBound.y - p1.y) / _loc3_ : Number.POSITIVE_INFINITY));
         p2.x = p1.x + _loc2_ * _loc4_;
         p2.y = p1.y + _loc3_ * _loc4_;
      }
      
      public function ExtendBackward(param1:b2AABB) : void
      {
         var _loc4_:Number = NaN;
         var _loc2_:Number = -p2.x + p1.x;
         var _loc3_:Number = -p2.y + p1.y;
         _loc4_ = Math.min(_loc2_ > 0 ? (param1.upperBound.x - p2.x) / _loc2_ : (_loc2_ < 0 ? (param1.lowerBound.x - p2.x) / _loc2_ : Number.POSITIVE_INFINITY),_loc3_ > 0 ? (param1.upperBound.y - p2.y) / _loc3_ : (_loc3_ < 0 ? (param1.lowerBound.y - p2.y) / _loc3_ : Number.POSITIVE_INFINITY));
         p1.x = p2.x + _loc2_ * _loc4_;
         p1.y = p2.y + _loc3_ * _loc4_;
      }
   }
}

