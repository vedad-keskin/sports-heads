package
{
   public class JMath
   {
      
      public function JMath()
      {
         super();
         trace("init");
      }
      
      public static function collCheck(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int) : *
      {
         var _loc10_:* = param2 - param1;
         var _loc11_:* = param4 - param3;
         var _loc12_:* = param6 - param5;
         var _loc13_:* = param8 - param7;
         var _loc14_:* = (-_loc11_ * (param1 - param5) + _loc10_ * (param3 - param7)) / (-_loc12_ * _loc11_ + _loc10_ * _loc13_);
         var _loc15_:* = (_loc12_ * (param3 - param7) - _loc13_ * (param1 - param5)) / (-_loc12_ * _loc11_ + _loc10_ * _loc13_);
         var _loc16_:* = -1;
         if(_loc14_ > 0 && _loc14_ < 1 && _loc15_ > 0 && _loc15_ < 1)
         {
            _loc16_ = _loc15_;
         }
         return _loc16_;
      }
      
      public static function testInterval(param1:int, param2:int) : *
      {
         var _loc3_:* = false;
         if(Math.floor(param1 / param2) == param1 / param2)
         {
            _loc3_ = true;
         }
         return _loc3_;
      }
      
      public static function getLimit(param1:int, param2:int) : *
      {
         var _loc3_:* = param1;
         if(param1 > param2)
         {
            _loc3_ = param2;
         }
         return _loc3_;
      }
      
      public static function getX(param1:int) : *
      {
         var _loc2_:* = param1 * (Math.PI / 180);
         return Math.sin(_loc2_);
      }
      
      public static function getY(param1:int) : *
      {
         var _loc2_:* = param1 * (Math.PI / 180);
         return -Math.cos(_loc2_);
      }
      
      public static function rangeTest(param1:int, param2:int, param3:int, param4:int, param5:int) : *
      {
         if(Math.abs(param1 - param3) < param5 && Math.abs(param2 - param4) < param5)
         {
            return true;
         }
         return false;
      }
      
      public static function getAngle(param1:Number, param2:Number, param3:Number, param4:Number) : *
      {
         var _loc5_:* = Math.sqrt((param1 - param3) * (param1 - param3) + (param2 - param4) * (param2 - param4));
         var _loc6_:* = 180 / Math.PI * Math.acos((param2 - param4) / _loc5_);
         if(param1 > param3)
         {
            _loc6_ = 360 - 180 / Math.PI * Math.acos((param2 - param4) / _loc5_);
         }
         return _loc6_;
      }
      
      public static function getHyp(param1:*, param2:*, param3:*, param4:*) : *
      {
         return Math.sqrt((param1 - param3) * (param1 - param3) + (param2 - param4) * (param2 - param4));
      }
      
      public static function getRand(param1:*) : *
      {
         return Math.floor(Math.random() * param1);
      }
   }
}

