package Box2D.Collision
{
   import Box2D.Common.*;
   import Box2D.Common.Math.*;
   
   use namespace b2internal;
   
   public class b2Manifold
   {
      
      public var points:Array;
      
      public var normal:b2Vec2;
      
      public var pointCount:int = 0;
      
      public function b2Manifold()
      {
         super();
         points = new Array(b2Settings.b2_maxManifoldPoints);
         var _loc1_:int = 0;
         while(_loc1_ < b2Settings.b2_maxManifoldPoints)
         {
            points[_loc1_] = new b2ManifoldPoint();
            _loc1_++;
         }
         normal = new b2Vec2();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < b2Settings.b2_maxManifoldPoints)
         {
            (points[_loc1_] as b2ManifoldPoint).Reset();
            _loc1_++;
         }
         normal.SetZero();
         pointCount = 0;
      }
      
      public function Set(param1:b2Manifold) : void
      {
         pointCount = param1.pointCount;
         var _loc2_:int = 0;
         while(_loc2_ < b2Settings.b2_maxManifoldPoints)
         {
            (points[_loc2_] as b2ManifoldPoint).Set(param1.points[_loc2_]);
            _loc2_++;
         }
         normal.SetV(param1.normal);
      }
   }
}

