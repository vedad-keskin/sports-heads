package Box2D.Dynamics
{
   public class b2TimeStep
   {
      
      public var dt:Number;
      
      public var inv_dt:Number;
      
      public var dtRatio:Number;
      
      public var velocityIterations:int;
      
      public var positionIterations:int;
      
      public var warmStarting:Boolean;
      
      public function b2TimeStep()
      {
         super();
      }
   }
}

