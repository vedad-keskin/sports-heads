package SPL_dist1_fla
{
   import Box2D.*;
   import Box2D.Dynamics.*;
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol499")]
   public dynamic class Blueprints_94 extends MovieClip
   {
      
      public function Blueprints_94()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function spawnProps() : void
      {
         spawnInitProps();
         var _loc1_:* = 0;
         while(_loc1_ <= numChildren - 1)
         {
            MovieClip(getChildAt(_loc1_)).spawnProp();
            _loc1_++;
         }
         Utils.makeHighestDepth(MovieClip(root).cover);
      }
      
      public function spawnInitProps() : void
      {
      }
      
      public function spawnBlock(param1:int, param2:int, param3:uint, param4:uint, param5:Number) : *
      {
         var _loc6_:b2Body = B2DManager.spawnBoxBody("body",param1,param2,param3,param4,0,0.5,0,0,new InvisBlock());
         _loc6_.SetXForm(_loc6_.GetPosition(),param5 * Math.PI / 180);
      }
      
      public function spawnCircle(param1:int, param2:int, param3:uint, param4:Number) : *
      {
         B2DManager.spawnCircleBody("body",param1,param2,param3,0,0.5,0,0,new InvisCircle());
      }
      
      public function spawnRightTriangle(param1:int, param2:int, param3:uint, param4:Number) : *
      {
         var _loc5_:b2Body = B2DManager.spawnIsocRightBody("body",param1,param2,param3,1,0,1,0,new RightTriangle());
         _loc5_.SetXForm(_loc5_.GetPosition(),param4 * Math.PI / 180);
      }
      
      public function spawnEquilateral(param1:int, param2:int, param3:uint, param4:Number) : *
      {
         var _loc5_:b2Body = B2DManager.spawnEquilateralBody("body",param1,param2,param3,1,0,1,0,new Equilateral());
         _loc5_.SetXForm(_loc5_.GetPosition(),param4 * Math.PI / 180);
      }
      
      public function spawnHexagon(param1:int, param2:int, param3:uint, param4:Number) : *
      {
         var _loc5_:b2Body = B2DManager.spawnHexagonBody("body",param1,param2,param3,1,0,1,0,new Hexagon());
         _loc5_.SetXForm(_loc5_.GetPosition(),param4 * Math.PI / 180);
      }
      
      public function spawnTrapezoid(param1:int, param2:int, param3:uint, param4:Number) : *
      {
         var _loc5_:b2Body = B2DManager.spawnTrapezoidBody("body",param1,param2,param3,1,0,1,0,new Trapezoid());
         _loc5_.SetXForm(_loc5_.GetPosition(),param4 * Math.PI / 180);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

