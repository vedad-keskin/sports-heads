package Box2D.Common
{
   import Box2D.Common.Math.b2Vec2;
   
   public class b2Settings
   {
      
      public static const VERSION:String = "2.0.2";
      
      public static const USHRT_MAX:int = 65535;
      
      public static const b2_pi:Number = Math.PI;
      
      public static const b2_maxManifoldPoints:int = 2;
      
      public static const b2_maxPolygonVertices:int = 8;
      
      public static const b2_linearSlop:Number = 0.005;
      
      public static const b2_angularSlop:Number = 2 / 180 * b2_pi;
      
      public static const b2_toiSlop:Number = 8 * b2_linearSlop;
      
      public static const b2_maxTOIContactsPerIsland:int = 32;
      
      public static const b2_maxTOIJointsPerIsland:int = 32;
      
      public static const b2_velocityThreshold:Number = 1;
      
      public static const b2_maxLinearCorrection:Number = 0.2;
      
      public static const b2_maxAngularCorrection:Number = 8 / 180 * b2_pi;
      
      public static const b2_maxLinearVelocity:Number = 6000;
      
      public static const b2_maxLinearVelocitySquared:Number = b2_maxLinearVelocity * b2_maxLinearVelocity;
      
      public static const b2_maxAngularVelocity:Number = 2500;
      
      public static const b2_maxAngularVelocitySquared:Number = b2_maxAngularVelocity * b2_maxAngularVelocity;
      
      public static const b2_contactBaumgarte:Number = 0.5;
      
      public static const b2_timeToSleep:Number = 0.5;
      
      public static const b2_linearSleepTolerance:Number = 0.01;
      
      public static const b2_angularSleepTolerance:Number = 2 / 180;
      
      public function b2Settings()
      {
         super();
      }
      
      public static function b2MixFriction(param1:Number, param2:Number) : Number
      {
         return Math.sqrt(param1 * param2);
      }
      
      public static function b2MixRestitution(param1:Number, param2:Number) : Number
      {
         return param1 > param2 ? param1 : param2;
      }
      
      public static function b2Assert(param1:Boolean) : void
      {
         var _loc2_:b2Vec2 = null;
         if(!param1)
         {
            ++_loc2_.x;
         }
      }
   }
}

