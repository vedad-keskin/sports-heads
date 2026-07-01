package Box2D.Collision
{
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   
   use namespace b2internal;
   
   public class b2BroadPhase
   {
      
      public static var s_validate:Boolean = false;
      
      public static const b2_invalid:uint = b2Settings.USHRT_MAX;
      
      public static const b2_nullEdge:uint = b2Settings.USHRT_MAX;
      
      b2internal var m_pairManager:b2PairManager;
      
      b2internal var m_proxyPool:Array;
      
      private var m_freeProxy:b2Proxy;
      
      b2internal var m_bounds:Array;
      
      private var m_querySortKeys:Array;
      
      private var m_queryResults:Array;
      
      private var m_queryResultCount:int;
      
      b2internal var m_worldAABB:b2AABB;
      
      b2internal var m_quantizationFactor:b2Vec2;
      
      b2internal var m_proxyCount:int;
      
      private var m_timeStamp:uint;
      
      public function b2BroadPhase(param1:b2AABB, param2:b2PairCallback)
      {
         var _loc3_:int = 0;
         b2internal::m_pairManager = new b2PairManager();
         b2internal::m_proxyPool = new Array();
         b2internal::m_bounds = new Array();
         m_querySortKeys = new Array();
         m_queryResults = new Array();
         b2internal::m_quantizationFactor = new b2Vec2();
         super();
         b2internal::m_pairManager.Initialize(this,param2);
         b2internal::m_worldAABB = param1;
         b2internal::m_proxyCount = 0;
         b2internal::m_bounds = new Array(2);
         _loc3_ = 0;
         while(_loc3_ < 2)
         {
            b2internal::m_bounds[_loc3_] = new Array();
            _loc3_++;
         }
         var _loc4_:Number = param1.upperBound.x - param1.lowerBound.x;
         var _loc5_:Number = param1.upperBound.y - param1.lowerBound.y;
         b2internal::m_quantizationFactor.x = b2Settings.USHRT_MAX / _loc4_;
         b2internal::m_quantizationFactor.y = b2Settings.USHRT_MAX / _loc5_;
         m_timeStamp = 1;
         m_queryResultCount = 0;
      }
      
      public static function BinarySearch(param1:Array, param2:int, param3:uint) : uint
      {
         var _loc6_:int = 0;
         var _loc7_:b2Bound = null;
         var _loc4_:int = 0;
         var _loc5_:int = param2 - 1;
         while(_loc4_ <= _loc5_)
         {
            _loc6_ = (_loc4_ + _loc5_) / 2;
            _loc7_ = param1[_loc6_];
            if(_loc7_.value > param3)
            {
               _loc5_ = _loc6_ - 1;
            }
            else
            {
               if(_loc7_.value >= param3)
               {
                  return uint(_loc6_);
               }
               _loc4_ = _loc6_ + 1;
            }
         }
         return uint(_loc4_);
      }
      
      public function InRange(param1:b2AABB) : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         _loc2_ = param1.lowerBound.x;
         _loc3_ = param1.lowerBound.y;
         _loc2_ -= m_worldAABB.upperBound.x;
         _loc3_ -= m_worldAABB.upperBound.y;
         _loc4_ = m_worldAABB.lowerBound.x;
         _loc5_ = m_worldAABB.lowerBound.y;
         _loc4_ -= param1.upperBound.x;
         _loc5_ -= param1.upperBound.y;
         _loc2_ = b2Math.b2Max(_loc2_,_loc4_);
         _loc3_ = b2Math.b2Max(_loc3_,_loc5_);
         return b2Math.b2Max(_loc2_,_loc3_) < 0;
      }
      
      public function CreateProxy(param1:b2AABB, param2:*) : b2Proxy
      {
         var _loc3_:uint = 0;
         var _loc4_:b2Proxy = null;
         var _loc5_:int = 0;
         var _loc6_:* = 0;
         var _loc11_:Array = null;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         var _loc16_:b2Bound = null;
         var _loc17_:b2Bound = null;
         var _loc18_:b2Bound = null;
         var _loc19_:b2Proxy = null;
         if(!m_freeProxy)
         {
            m_freeProxy = m_proxyPool[m_proxyCount] = new b2Proxy();
            m_freeProxy.next = null;
            m_freeProxy.timeStamp = 0;
            m_freeProxy.overlapCount = b2_invalid;
            m_freeProxy.userData = null;
            _loc5_ = 0;
            while(_loc5_ < 2)
            {
               _loc6_ = int(m_proxyCount * 2);
               var _loc20_:Number;
               m_bounds[_loc5_][_loc20_ = _loc6_++] = new b2Bound();
               m_bounds[_loc5_][_loc6_] = new b2Bound();
               _loc5_++;
            }
         }
         _loc4_ = m_freeProxy;
         m_freeProxy = _loc4_.next;
         _loc4_.overlapCount = 0;
         _loc4_.userData = param2;
         var _loc7_:uint = 2 * m_proxyCount;
         var _loc8_:Array = new Array();
         var _loc9_:Array = new Array();
         ComputeBounds(_loc8_,_loc9_,param1);
         var _loc10_:int = 0;
         while(_loc10_ < 2)
         {
            _loc11_ = m_bounds[_loc10_];
            _loc14_ = [_loc12_];
            _loc15_ = [_loc13_];
            Query(_loc14_,_loc15_,_loc8_[_loc10_],_loc9_[_loc10_],_loc11_,_loc7_,_loc10_);
            _loc12_ = uint(_loc14_[0]);
            _loc13_ = uint(_loc15_[0]);
            _loc11_.splice(_loc13_,0,_loc11_[_loc11_.length - 1]);
            --_loc11_.length;
            _loc11_.splice(_loc12_,0,_loc11_[_loc11_.length - 1]);
            --_loc11_.length;
            _loc13_++;
            _loc16_ = _loc11_[_loc12_];
            _loc17_ = _loc11_[_loc13_];
            _loc16_.value = _loc8_[_loc10_];
            _loc16_.proxy = _loc4_;
            _loc17_.value = _loc9_[_loc10_];
            _loc17_.proxy = _loc4_;
            _loc18_ = _loc11_[int(_loc12_ - 1)];
            _loc16_.stabbingCount = _loc12_ == 0 ? 0 : _loc18_.stabbingCount;
            _loc18_ = _loc11_[int(_loc13_ - 1)];
            _loc17_.stabbingCount = _loc18_.stabbingCount;
            _loc3_ = _loc12_;
            while(_loc3_ < _loc13_)
            {
               _loc18_ = _loc11_[_loc3_];
               ++_loc18_.stabbingCount;
               _loc3_++;
            }
            _loc3_ = _loc12_;
            while(_loc3_ < _loc7_ + 2)
            {
               _loc16_ = _loc11_[_loc3_];
               _loc19_ = _loc16_.proxy;
               if(_loc16_.IsLower())
               {
                  _loc19_.lowerBounds[_loc10_] = _loc3_;
               }
               else
               {
                  _loc19_.upperBounds[_loc10_] = _loc3_;
               }
               _loc3_++;
            }
            _loc10_++;
         }
         ++m_proxyCount;
         _loc5_ = 0;
         while(_loc5_ < m_queryResultCount)
         {
            m_pairManager.AddBufferedPair(_loc4_,m_queryResults[_loc5_]);
            _loc5_++;
         }
         m_pairManager.Commit();
         m_queryResultCount = 0;
         IncrementTimeStamp();
         return _loc4_;
      }
      
      public function DestroyProxy(param1:b2Proxy) : void
      {
         var _loc2_:b2Bound = null;
         var _loc3_:b2Bound = null;
         var _loc7_:Array = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:int = 0;
         var _loc13_:uint = 0;
         var _loc14_:int = 0;
         var _loc15_:b2Proxy = null;
         var _loc4_:int = 2 * m_proxyCount;
         var _loc5_:int = 0;
         while(_loc5_ < 2)
         {
            _loc7_ = m_bounds[_loc5_];
            _loc8_ = uint(param1.lowerBounds[_loc5_]);
            _loc9_ = uint(param1.upperBounds[_loc5_]);
            _loc2_ = _loc7_[_loc8_];
            _loc10_ = _loc2_.value;
            _loc3_ = _loc7_[_loc9_];
            _loc11_ = _loc3_.value;
            _loc7_.splice(_loc9_,1);
            _loc7_.splice(_loc8_,1);
            _loc7_.push(_loc2_);
            _loc7_.push(_loc3_);
            _loc12_ = _loc4_ - 2;
            _loc13_ = _loc8_;
            while(_loc13_ < _loc12_)
            {
               _loc2_ = _loc7_[_loc13_];
               _loc15_ = _loc2_.proxy;
               if(_loc2_.IsLower())
               {
                  _loc15_.lowerBounds[_loc5_] = _loc13_;
               }
               else
               {
                  _loc15_.upperBounds[_loc5_] = _loc13_;
               }
               _loc13_++;
            }
            _loc12_ = _loc9_ - 1;
            _loc14_ = int(_loc8_);
            while(_loc14_ < _loc12_)
            {
               _loc2_ = _loc7_[_loc14_];
               --_loc2_.stabbingCount;
               _loc14_++;
            }
            Query([0],[0],_loc10_,_loc11_,_loc7_,_loc4_ - 2,_loc5_);
            _loc5_++;
         }
         var _loc6_:int = 0;
         while(_loc6_ < m_queryResultCount)
         {
            m_pairManager.RemoveBufferedPair(param1,m_queryResults[_loc6_]);
            _loc6_++;
         }
         m_pairManager.Commit();
         m_queryResultCount = 0;
         IncrementTimeStamp();
         param1.userData = null;
         param1.overlapCount = b2_invalid;
         param1.lowerBounds[0] = b2_invalid;
         param1.lowerBounds[1] = b2_invalid;
         param1.upperBounds[0] = b2_invalid;
         param1.upperBounds[1] = b2_invalid;
         param1.next = m_freeProxy;
         m_freeProxy = param1;
         --m_proxyCount;
      }
      
      public function MoveProxy(param1:b2Proxy, param2:b2AABB) : void
      {
         var _loc3_:Array = null;
         var _loc4_:* = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:b2Bound = null;
         var _loc8_:b2Bound = null;
         var _loc9_:b2Bound = null;
         var _loc10_:uint = 0;
         var _loc11_:b2Proxy = null;
         var _loc15_:Array = null;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:uint = 0;
         var _loc19_:uint = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:b2Proxy = null;
         if(param1 == null)
         {
            return;
         }
         if(param2.IsValid() == false)
         {
            return;
         }
         var _loc12_:uint = 2 * m_proxyCount;
         var _loc13_:b2BoundValues = new b2BoundValues();
         ComputeBounds(_loc13_.lowerValues,_loc13_.upperValues,param2);
         var _loc14_:b2BoundValues = new b2BoundValues();
         _loc5_ = 0;
         while(_loc5_ < 2)
         {
            _loc7_ = m_bounds[_loc5_][param1.lowerBounds[_loc5_]];
            _loc14_.lowerValues[_loc5_] = _loc7_.value;
            _loc7_ = m_bounds[_loc5_][param1.upperBounds[_loc5_]];
            _loc14_.upperValues[_loc5_] = _loc7_.value;
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < 2)
         {
            _loc15_ = m_bounds[_loc5_];
            _loc16_ = uint(param1.lowerBounds[_loc5_]);
            _loc17_ = uint(param1.upperBounds[_loc5_]);
            _loc18_ = uint(_loc13_.lowerValues[_loc5_]);
            _loc19_ = uint(_loc13_.upperValues[_loc5_]);
            _loc7_ = _loc15_[_loc16_];
            _loc20_ = _loc18_ - _loc7_.value;
            _loc7_.value = _loc18_;
            _loc7_ = _loc15_[_loc17_];
            _loc21_ = _loc19_ - _loc7_.value;
            _loc7_.value = _loc19_;
            if(_loc20_ < 0)
            {
               _loc6_ = _loc16_;
               while(_loc6_ > 0 && _loc18_ < (_loc15_[int(_loc6_ - 1)] as b2Bound).value)
               {
                  _loc7_ = _loc15_[_loc6_];
                  _loc8_ = _loc15_[int(_loc6_ - 1)];
                  _loc22_ = _loc8_.proxy;
                  ++_loc8_.stabbingCount;
                  if(_loc8_.IsUpper() == true)
                  {
                     if(TestOverlap(_loc13_,_loc22_))
                     {
                        m_pairManager.AddBufferedPair(param1,_loc22_);
                     }
                     _loc3_ = _loc22_.upperBounds;
                     _loc4_ = int(_loc3_[_loc5_]);
                     _loc4_ = _loc4_ + 1;
                     _loc3_[_loc5_] = _loc4_;
                     ++_loc7_.stabbingCount;
                  }
                  else
                  {
                     _loc3_ = _loc22_.lowerBounds;
                     _loc4_ = int(_loc3_[_loc5_]);
                     _loc4_ = _loc4_ + 1;
                     _loc3_[_loc5_] = _loc4_;
                     --_loc7_.stabbingCount;
                  }
                  _loc3_ = param1.lowerBounds;
                  _loc4_ = int(_loc3_[_loc5_]);
                  _loc4_ = _loc4_ - 1;
                  _loc3_[_loc5_] = _loc4_;
                  _loc7_.Swap(_loc8_);
                  _loc6_--;
               }
            }
            if(_loc21_ > 0)
            {
               _loc6_ = _loc17_;
               while(_loc6_ < _loc12_ - 1 && (_loc15_[int(_loc6_ + 1)] as b2Bound).value <= _loc19_)
               {
                  _loc7_ = _loc15_[_loc6_];
                  _loc9_ = _loc15_[int(_loc6_ + 1)];
                  _loc11_ = _loc9_.proxy;
                  ++_loc9_.stabbingCount;
                  if(_loc9_.IsLower() == true)
                  {
                     if(TestOverlap(_loc13_,_loc11_))
                     {
                        m_pairManager.AddBufferedPair(param1,_loc11_);
                     }
                     _loc3_ = _loc11_.lowerBounds;
                     _loc4_ = int(_loc3_[_loc5_]);
                     _loc4_ = _loc4_ - 1;
                     _loc3_[_loc5_] = _loc4_;
                     ++_loc7_.stabbingCount;
                  }
                  else
                  {
                     _loc3_ = _loc11_.upperBounds;
                     _loc4_ = int(_loc3_[_loc5_]);
                     _loc4_ = _loc4_ - 1;
                     _loc3_[_loc5_] = _loc4_;
                     --_loc7_.stabbingCount;
                  }
                  _loc3_ = param1.upperBounds;
                  _loc4_ = int(_loc3_[_loc5_]);
                  _loc4_ = _loc4_ + 1;
                  _loc3_[_loc5_] = _loc4_;
                  _loc7_.Swap(_loc9_);
                  _loc6_++;
               }
            }
            if(_loc20_ > 0)
            {
               _loc6_ = _loc16_;
               while(_loc6_ < _loc12_ - 1 && (_loc15_[int(_loc6_ + 1)] as b2Bound).value <= _loc18_)
               {
                  _loc7_ = _loc15_[_loc6_];
                  _loc9_ = _loc15_[int(_loc6_ + 1)];
                  _loc11_ = _loc9_.proxy;
                  --_loc9_.stabbingCount;
                  if(_loc9_.IsUpper())
                  {
                     if(TestOverlap(_loc14_,_loc11_))
                     {
                        m_pairManager.RemoveBufferedPair(param1,_loc11_);
                     }
                     _loc3_ = _loc11_.upperBounds;
                     _loc4_ = int(_loc3_[_loc5_]);
                     _loc4_ = _loc4_ - 1;
                     _loc3_[_loc5_] = _loc4_;
                     --_loc7_.stabbingCount;
                  }
                  else
                  {
                     _loc3_ = _loc11_.lowerBounds;
                     _loc4_ = int(_loc3_[_loc5_]);
                     _loc4_ = _loc4_ - 1;
                     _loc3_[_loc5_] = _loc4_;
                     ++_loc7_.stabbingCount;
                  }
                  _loc3_ = param1.lowerBounds;
                  _loc4_ = int(_loc3_[_loc5_]);
                  _loc4_ = _loc4_ + 1;
                  _loc3_[_loc5_] = _loc4_;
                  _loc7_.Swap(_loc9_);
                  _loc6_++;
               }
            }
            if(_loc21_ < 0)
            {
               _loc6_ = _loc17_;
               while(_loc6_ > 0 && _loc19_ < (_loc15_[int(_loc6_ - 1)] as b2Bound).value)
               {
                  _loc7_ = _loc15_[_loc6_];
                  _loc8_ = _loc15_[int(_loc6_ - 1)];
                  _loc22_ = _loc8_.proxy;
                  --_loc8_.stabbingCount;
                  if(_loc8_.IsLower() == true)
                  {
                     if(TestOverlap(_loc14_,_loc22_))
                     {
                        m_pairManager.RemoveBufferedPair(param1,_loc22_);
                     }
                     _loc3_ = _loc22_.lowerBounds;
                     _loc4_ = int(_loc3_[_loc5_]);
                     _loc4_ = _loc4_ + 1;
                     _loc3_[_loc5_] = _loc4_;
                     --_loc7_.stabbingCount;
                  }
                  else
                  {
                     _loc3_ = _loc22_.upperBounds;
                     _loc4_ = int(_loc3_[_loc5_]);
                     _loc4_ = _loc4_ + 1;
                     _loc3_[_loc5_] = _loc4_;
                     ++_loc7_.stabbingCount;
                  }
                  _loc3_ = param1.upperBounds;
                  _loc4_ = int(_loc3_[_loc5_]);
                  _loc4_ = _loc4_ - 1;
                  _loc3_[_loc5_] = _loc4_;
                  _loc7_.Swap(_loc8_);
                  _loc6_--;
               }
            }
            _loc5_++;
         }
      }
      
      public function Commit() : void
      {
         m_pairManager.Commit();
      }
      
      public function QueryAABB(param1:b2AABB, param2:*, param3:int) : int
      {
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc12_:b2Proxy = null;
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         ComputeBounds(_loc4_,_loc5_,param1);
         var _loc8_:Array = [_loc6_];
         var _loc9_:Array = [_loc7_];
         Query(_loc8_,_loc9_,_loc4_[0],_loc5_[0],m_bounds[0],2 * m_proxyCount,0);
         Query(_loc8_,_loc9_,_loc4_[1],_loc5_[1],m_bounds[1],2 * m_proxyCount,1);
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         while(_loc11_ < m_queryResultCount && _loc10_ < param3)
         {
            _loc12_ = m_queryResults[_loc11_];
            param2[_loc11_] = _loc12_.userData;
            _loc11_++;
            _loc10_++;
         }
         m_queryResultCount = 0;
         IncrementTimeStamp();
         return _loc10_;
      }
      
      public function Validate() : void
      {
         var _loc1_:b2Pair = null;
         var _loc2_:b2Proxy = null;
         var _loc3_:b2Proxy = null;
         var _loc4_:Boolean = false;
         var _loc6_:b2Bound = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:b2Bound = null;
         var _loc5_:int = 0;
         while(_loc5_ < 2)
         {
            _loc6_ = m_bounds[_loc5_];
            _loc7_ = 2 * m_proxyCount;
            _loc8_ = 0;
            _loc9_ = 0;
            while(_loc9_ < _loc7_)
            {
               _loc10_ = _loc6_[_loc9_];
               if(_loc10_.IsLower() == true)
               {
                  _loc8_++;
               }
               else
               {
                  _loc8_--;
               }
               _loc9_++;
            }
            _loc5_++;
         }
      }
      
      public function QuerySegment(param1:b2Segment, param2:*, param3:int, param4:Function) : int
      {
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:b2Proxy = null;
         var _loc18_:uint = 0;
         var _loc19_:uint = 0;
         var _loc22_:int = 0;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:b2Proxy = null;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc5_:Number = 1;
         var _loc6_:Number = (param1.p2.x - param1.p1.x) * m_quantizationFactor.x;
         var _loc7_:Number = (param1.p2.y - param1.p1.y) * m_quantizationFactor.y;
         var _loc8_:int = _loc6_ < -Number.MIN_VALUE ? -1 : (_loc6_ > Number.MIN_VALUE ? 1 : 0);
         var _loc9_:int = _loc7_ < -Number.MIN_VALUE ? -1 : (_loc7_ > Number.MIN_VALUE ? 1 : 0);
         var _loc10_:Number = m_quantizationFactor.x * (param1.p1.x - m_worldAABB.lowerBound.x);
         var _loc11_:Number = m_quantizationFactor.y * (param1.p1.y - m_worldAABB.lowerBound.y);
         var _loc12_:Array = new Array();
         var _loc13_:Array = new Array();
         _loc12_[0] = uint(_loc10_) & b2Settings.USHRT_MAX - 1;
         _loc12_[1] = uint(_loc11_) & b2Settings.USHRT_MAX - 1;
         _loc13_[0] = _loc12_[0] + 1;
         _loc13_[1] = _loc12_[1] + 1;
         var _loc14_:Array = new Array();
         var _loc20_:Array = [_loc18_];
         var _loc21_:Array = [_loc19_];
         Query(_loc20_,_loc21_,_loc12_[0],_loc13_[0],m_bounds[0],2 * m_proxyCount,0);
         if(_loc8_ >= 0)
         {
            _loc15_ = _loc21_[0] - 1;
         }
         else
         {
            _loc15_ = int(_loc20_[0]);
         }
         Query(_loc20_,_loc21_,_loc12_[1],_loc13_[1],m_bounds[1],2 * m_proxyCount,1);
         if(_loc9_ >= 0)
         {
            _loc16_ = _loc21_[0] - 1;
         }
         else
         {
            _loc16_ = int(_loc20_[0]);
         }
         if(param4 != null)
         {
            _loc23_ = 0;
            while(_loc23_ < m_queryResultCount)
            {
               m_querySortKeys[_loc23_] = param4(m_queryResults[_loc23_].userData);
               _loc23_++;
            }
            _loc23_ = 0;
            while(_loc23_ < m_queryResultCount - 1)
            {
               _loc24_ = Number(m_querySortKeys[_loc23_]);
               _loc25_ = Number(m_querySortKeys[_loc23_ + 1]);
               if(_loc24_ < 0 ? _loc25_ >= 0 : _loc24_ > _loc25_ && _loc25_ >= 0)
               {
                  m_querySortKeys[_loc23_ + 1] = _loc24_;
                  m_querySortKeys[_loc23_] = _loc25_;
                  _loc26_ = m_queryResults[_loc23_ + 1];
                  m_queryResults[_loc23_ + 1] = m_queryResults[_loc23_];
                  m_queryResults[_loc23_] = _loc26_;
                  if(--_loc23_ == -1)
                  {
                     _loc23_ = 1;
                  }
               }
               else
               {
                  _loc23_++;
               }
            }
            while(m_queryResultCount > 0 && m_querySortKeys[m_queryResultCount - 1] < 0)
            {
               --m_queryResultCount;
            }
         }
         _loc27_ = 0;
         _loc28_ = 0;
         _loc15_ += _loc8_ >= 0 ? 1 : -1;
         if(!(_loc15_ < 0 || _loc15_ >= m_proxyCount * 2))
         {
            if(_loc8_ != 0)
            {
               _loc27_ = (m_bounds[0][_loc15_].value - _loc10_) / _loc6_;
            }
            _loc16_ += _loc9_ >= 0 ? 1 : -1;
            if(!(_loc16_ < 0 || _loc16_ >= m_proxyCount * 2))
            {
               if(_loc9_ != 0)
               {
                  _loc28_ = (m_bounds[1][_loc16_].value - _loc11_) / _loc7_;
               }
               while(true)
               {
                  if(_loc9_ == 0 || _loc8_ != 0 && _loc27_ < _loc28_)
                  {
                     if(_loc27_ > _loc5_)
                     {
                        break;
                     }
                     if(_loc8_ > 0 ? Boolean(m_bounds[0][_loc15_].IsLower()) : Boolean(m_bounds[0][_loc15_].IsUpper()))
                     {
                        _loc17_ = m_bounds[0][_loc15_].proxy;
                        if(_loc9_ >= 0)
                        {
                           if(_loc17_.lowerBounds[1] <= _loc16_ - 1 && _loc17_.upperBounds[1] >= _loc16_)
                           {
                              if(param4 != null)
                              {
                                 AddProxyResult(_loc17_,param3,param4);
                              }
                              else
                              {
                                 m_queryResults[m_queryResultCount] = _loc17_;
                                 ++m_queryResultCount;
                              }
                           }
                        }
                        else if(_loc17_.lowerBounds[1] <= _loc16_ && _loc17_.upperBounds[1] >= _loc16_ + 1)
                        {
                           if(param4 != null)
                           {
                              AddProxyResult(_loc17_,param3,param4);
                           }
                           else
                           {
                              m_queryResults[m_queryResultCount] = _loc17_;
                              ++m_queryResultCount;
                           }
                        }
                     }
                     if(param4 != null && m_queryResultCount == param3 && m_queryResultCount > 0 && _loc27_ > m_querySortKeys[m_queryResultCount - 1])
                     {
                        break;
                     }
                     if(_loc8_ > 0)
                     {
                        if(++_loc15_ == m_proxyCount * 2)
                        {
                           break;
                        }
                     }
                     else if(--_loc15_ < 0)
                     {
                        break;
                     }
                     _loc27_ = (m_bounds[0][_loc15_].value - _loc10_) / _loc6_;
                  }
                  else
                  {
                     if(_loc28_ > _loc5_)
                     {
                        break;
                     }
                     if(_loc9_ > 0 ? Boolean(m_bounds[1][_loc16_].IsLower()) : Boolean(m_bounds[1][_loc16_].IsUpper()))
                     {
                        _loc17_ = m_bounds[1][_loc16_].proxy;
                        if(_loc8_ >= 0)
                        {
                           if(_loc17_.lowerBounds[0] <= _loc15_ - 1 && _loc17_.upperBounds[0] >= _loc15_)
                           {
                              if(param4 != null)
                              {
                                 AddProxyResult(_loc17_,param3,param4);
                              }
                              else
                              {
                                 m_queryResults[m_queryResultCount] = _loc17_;
                                 ++m_queryResultCount;
                              }
                           }
                        }
                        else if(_loc17_.lowerBounds[0] <= _loc15_ && _loc17_.upperBounds[0] >= _loc15_ + 1)
                        {
                           if(param4 != null)
                           {
                              AddProxyResult(_loc17_,param3,param4);
                           }
                           else
                           {
                              m_queryResults[m_queryResultCount] = _loc17_;
                              ++m_queryResultCount;
                           }
                        }
                     }
                     if(param4 != null && m_queryResultCount == param3 && m_queryResultCount > 0 && _loc28_ > m_querySortKeys[m_queryResultCount - 1])
                     {
                        break;
                     }
                     if(_loc9_ > 0)
                     {
                        if(++_loc16_ == m_proxyCount * 2)
                        {
                           break;
                        }
                     }
                     else if(--_loc16_ < 0)
                     {
                        break;
                     }
                     _loc28_ = (m_bounds[1][_loc16_].value - _loc11_) / _loc7_;
                  }
               }
            }
         }
         _loc22_ = 0;
         _loc23_ = 0;
         while(_loc23_ < m_queryResultCount && _loc22_ < param3)
         {
            _loc17_ = m_queryResults[_loc23_];
            param2[_loc23_] = _loc17_.userData;
            _loc23_++;
            _loc22_++;
         }
         m_queryResultCount = 0;
         IncrementTimeStamp();
         return _loc22_;
      }
      
      private function ComputeBounds(param1:Array, param2:Array, param3:b2AABB) : void
      {
         var _loc4_:Number = param3.lowerBound.x;
         var _loc5_:Number = param3.lowerBound.y;
         _loc4_ = b2Math.b2Min(_loc4_,m_worldAABB.upperBound.x);
         _loc5_ = b2Math.b2Min(_loc5_,m_worldAABB.upperBound.y);
         _loc4_ = b2Math.b2Max(_loc4_,m_worldAABB.lowerBound.x);
         _loc5_ = b2Math.b2Max(_loc5_,m_worldAABB.lowerBound.y);
         var _loc6_:Number = param3.upperBound.x;
         var _loc7_:Number = param3.upperBound.y;
         _loc6_ = b2Math.b2Min(_loc6_,m_worldAABB.upperBound.x);
         _loc7_ = b2Math.b2Min(_loc7_,m_worldAABB.upperBound.y);
         _loc6_ = b2Math.b2Max(_loc6_,m_worldAABB.lowerBound.x);
         _loc7_ = b2Math.b2Max(_loc7_,m_worldAABB.lowerBound.y);
         param1[0] = uint(m_quantizationFactor.x * (_loc4_ - m_worldAABB.lowerBound.x)) & b2Settings.USHRT_MAX - 1;
         param2[0] = uint(m_quantizationFactor.x * (_loc6_ - m_worldAABB.lowerBound.x)) & 0xFFFF | 1;
         param1[1] = uint(m_quantizationFactor.y * (_loc5_ - m_worldAABB.lowerBound.y)) & b2Settings.USHRT_MAX - 1;
         param2[1] = uint(m_quantizationFactor.y * (_loc7_ - m_worldAABB.lowerBound.y)) & 0xFFFF | 1;
      }
      
      private function TestOverlapValidate(param1:b2Proxy, param2:b2Proxy) : Boolean
      {
         var _loc4_:Array = null;
         var _loc5_:b2Bound = null;
         var _loc6_:b2Bound = null;
         var _loc3_:int = 0;
         while(_loc3_ < 2)
         {
            _loc4_ = m_bounds[_loc3_];
            _loc5_ = _loc4_[param1.lowerBounds[_loc3_]];
            _loc6_ = _loc4_[param2.upperBounds[_loc3_]];
            if(_loc5_.value > _loc6_.value)
            {
               return false;
            }
            _loc5_ = _loc4_[param1.upperBounds[_loc3_]];
            _loc6_ = _loc4_[param2.lowerBounds[_loc3_]];
            if(_loc5_.value < _loc6_.value)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public function TestOverlap(param1:b2BoundValues, param2:b2Proxy) : Boolean
      {
         var _loc4_:Array = null;
         var _loc5_:b2Bound = null;
         var _loc3_:int = 0;
         while(_loc3_ < 2)
         {
            _loc4_ = m_bounds[_loc3_];
            _loc5_ = _loc4_[param2.upperBounds[_loc3_]];
            if(param1.lowerValues[_loc3_] > _loc5_.value)
            {
               return false;
            }
            _loc5_ = _loc4_[param2.lowerBounds[_loc3_]];
            if(param1.upperValues[_loc3_] < _loc5_.value)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      private function Query(param1:Array, param2:Array, param3:uint, param4:uint, param5:Array, param6:uint, param7:int) : void
      {
         var _loc10_:b2Bound = null;
         var _loc12_:* = 0;
         var _loc13_:* = 0;
         var _loc14_:b2Proxy = null;
         var _loc8_:uint = BinarySearch(param5,param6,param3);
         var _loc9_:uint = BinarySearch(param5,param6,param4);
         var _loc11_:uint = _loc8_;
         while(_loc11_ < _loc9_)
         {
            _loc10_ = param5[_loc11_];
            if(_loc10_.IsLower())
            {
               IncrementOverlapCount(_loc10_.proxy);
            }
            _loc11_++;
         }
         if(_loc8_ > 0)
         {
            _loc12_ = int(_loc8_ - 1);
            _loc10_ = param5[_loc12_];
            _loc13_ = int(_loc10_.stabbingCount);
            while(_loc13_)
            {
               _loc10_ = param5[_loc12_];
               if(_loc10_.IsLower())
               {
                  _loc14_ = _loc10_.proxy;
                  if(_loc8_ <= _loc14_.upperBounds[param7])
                  {
                     IncrementOverlapCount(_loc10_.proxy);
                     _loc13_--;
                  }
               }
               _loc12_--;
            }
         }
         param1[0] = _loc8_;
         param2[0] = _loc9_;
      }
      
      private function IncrementOverlapCount(param1:b2Proxy) : void
      {
         if(param1.timeStamp < m_timeStamp)
         {
            param1.timeStamp = m_timeStamp;
            param1.overlapCount = 1;
         }
         else
         {
            param1.overlapCount = 2;
            m_queryResults[m_queryResultCount] = param1;
            ++m_queryResultCount;
         }
      }
      
      private function IncrementTimeStamp() : void
      {
         var _loc1_:uint = 0;
         if(m_timeStamp == b2Settings.USHRT_MAX)
         {
            _loc1_ = 0;
            while(_loc1_ < m_proxyPool.length)
            {
               (m_proxyPool[_loc1_] as b2Proxy).timeStamp = 0;
               _loc1_++;
            }
            m_timeStamp = 1;
         }
         else
         {
            ++m_timeStamp;
         }
      }
      
      private function AddProxyResult(param1:b2Proxy, param2:Number, param3:Function) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:b2Proxy = null;
         var _loc4_:Number = param3(param1.userData);
         if(_loc4_ < 0)
         {
            return;
         }
         var _loc5_:Number = 0;
         while(_loc5_ < m_queryResultCount && m_querySortKeys[_loc5_] < _loc4_)
         {
            _loc5_++;
         }
         var _loc6_:Number = _loc4_;
         var _loc7_:b2Proxy = param1;
         m_queryResultCount += 1;
         if(m_queryResultCount > param2)
         {
            m_queryResultCount = param2;
         }
         while(_loc5_ < m_queryResultCount)
         {
            _loc8_ = Number(m_querySortKeys[_loc5_]);
            _loc9_ = m_queryResults[_loc5_];
            m_querySortKeys[_loc5_] = _loc6_;
            m_queryResults[_loc5_] = _loc7_;
            _loc6_ = _loc8_;
            _loc7_ = _loc9_;
            _loc5_++;
         }
      }
   }
}

