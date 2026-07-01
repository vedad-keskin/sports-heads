package Box2D.Collision.Shapes
{
   import Box2D.Common.b2internal;
   
   use namespace b2internal;
   
   public class b2EdgeChainDef extends b2ShapeDef
   {
      
      public var vertices:Array;
      
      public var vertexCount:int;
      
      public var isALoop:Boolean;
      
      public function b2EdgeChainDef()
      {
         super();
         type = b2Shape.e_edgeShape;
         vertexCount = 0;
         isALoop = true;
         vertices = [];
      }
   }
}

