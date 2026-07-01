package Box2D.Collision
{
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   
   use namespace b2internal;
   
   public class b2PairManager
   {
      
      private var m_broadPhase:b2BroadPhase;
      
      private var m_callback:b2PairCallback;
      
      b2internal var m_pairs:Array;
      
      private var m_freePair:b2Pair;
      
      b2internal var m_pairCount:int;
      
      private var m_pairBuffer:Array;
      
      private var m_pairBufferCount:int;
      
      public function b2PairManager()
      {
         super();
         b2internal::m_pairs = new Array();
         m_pairBuffer = new Array();
         b2internal::m_pairCount = 0;
         m_pairBufferCount = 0;
         m_freePair = null;
      }
      
      public function Initialize(param1:b2BroadPhase, param2:b2PairCallback) : void
      {
         m_broadPhase = param1;
         m_callback = param2;
      }
      
      public function AddBufferedPair(param1:b2Proxy, param2:b2Proxy) : void
      {
         var _loc3_:b2Pair = AddPair(param1,param2);
         if(_loc3_.IsBuffered() == false)
         {
            _loc3_.SetBuffered();
            m_pairBuffer[m_pairBufferCount] = _loc3_;
            ++m_pairBufferCount;
         }
         _loc3_.ClearRemoved();
         if(b2BroadPhase.s_validate)
         {
            ValidateBuffer();
         }
      }
      
      public function RemoveBufferedPair(param1:b2Proxy, param2:b2Proxy) : void
      {
         var _loc3_:b2Pair = Find(param1,param2);
         if(_loc3_ == null)
         {
            return;
         }
         if(_loc3_.IsBuffered() == false)
         {
            _loc3_.SetBuffered();
            m_pairBuffer[m_pairBufferCount] = _loc3_;
            ++m_pairBufferCount;
         }
         _loc3_.SetRemoved();
         if(b2BroadPhase.s_validate)
         {
            ValidateBuffer();
         }
      }
      
      public function Commit() : void
      {
         var _loc1_:int = 0;
         var _loc3_:b2Pair = null;
         var _loc4_:b2Proxy = null;
         var _loc5_:b2Proxy = null;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < m_pairBufferCount)
         {
            _loc3_ = m_pairBuffer[_loc1_];
            _loc3_.ClearBuffered();
            _loc4_ = _loc3_.proxy1;
            _loc5_ = _loc3_.proxy2;
            if(_loc3_.IsRemoved())
            {
               if(_loc3_.IsFinal() == true)
               {
                  m_callback.PairRemoved(_loc4_.userData,_loc5_.userData,_loc3_.userData);
               }
               m_pairBuffer[_loc2_] = _loc3_;
               _loc2_++;
            }
            else if(_loc3_.IsFinal() == false)
            {
               _loc3_.userData = m_callback.PairAdded(_loc4_.userData,_loc5_.userData);
               _loc3_.SetFinal();
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = m_pairBuffer[_loc1_];
            RemovePair(_loc3_.proxy1,_loc3_.proxy2);
            _loc1_++;
         }
         m_pairBufferCount = 0;
         if(b2BroadPhase.s_validate)
         {
            ValidateTable();
         }
      }
      
      private function AddPair(param1:b2Proxy, param2:b2Proxy) : b2Pair
      {
         var _loc3_:b2Pair = param1.pairs[param2];
         if(_loc3_ != null)
         {
            return _loc3_;
         }
         if(m_freePair == null)
         {
            m_freePair = new b2Pair();
            m_pairs.push(m_freePair);
         }
         _loc3_ = m_freePair;
         m_freePair = _loc3_.next;
         _loc3_.proxy1 = param1;
         _loc3_.proxy2 = param2;
         _loc3_.status = 0;
         _loc3_.userData = null;
         _loc3_.next = null;
         param1.pairs[param2] = _loc3_;
         param2.pairs[param1] = _loc3_;
         ++m_pairCount;
         return _loc3_;
      }
      
      private function RemovePair(param1:b2Proxy, param2:b2Proxy) : *
      {
         var _loc3_:b2Pair = param1.pairs[param2];
         if(_loc3_ == null)
         {
            return null;
         }
         var _loc4_:* = _loc3_.userData;
         delete param1.pairs[param2];
         delete param2.pairs[param1];
         _loc3_.next = m_freePair;
         _loc3_.proxy1 = null;
         _loc3_.proxy2 = null;
         _loc3_.userData = null;
         _loc3_.status = 0;
         m_freePair = _loc3_;
         --m_pairCount;
         return _loc4_;
      }
      
      private function Find(param1:b2Proxy, param2:b2Proxy) : b2Pair
      {
         return param1.pairs[param2];
      }
      
      private function ValidateBuffer() : void
      {
      }
      
      private function ValidateTable() : void
      {
      }
   }
}

