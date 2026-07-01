package
{
   import flash.display.MovieClip;
   
   public class SuperMath
   {
      
      public function SuperMath()
      {
         super();
      }
      
      public static function pythag(param1:*, param2:*, param3:*) : Number
      {
         if(param1 == "x")
         {
            return Math.sqrt(param3 * param3 - param2 * param2);
         }
         if(param2 == "x")
         {
            return Math.sqrt(param3 * param3 - param1 * param1);
         }
         return Math.sqrt(param1 * param1 + param2 * param2);
      }
      
      public static function getDistance(param1:MovieClip, param2:MovieClip) : Number
      {
         var _loc3_:Number = Math.abs(param1.x - param2.x);
         var _loc4_:Number = Math.abs(param1.y - param2.y);
         return Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
      }
   }
}

