package
{
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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol27")]
   public dynamic class Trapezoid_Prop extends MovieClip
   {
      
      public function Trapezoid_Prop()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function spawnProp() : void
      {
         MovieClip(root).blueprints.spawnTrapezoid(x,y,GetSize(true) / 2,rotation);
      }
      
      public function GetSize(param1:Boolean) : int
      {
         var _loc2_:* = new Hexagon_Prop();
         _loc2_.rotation = rotation;
         _loc2_.width = width;
         _loc2_.height = height;
         _loc2_.rotation = 0;
         var _loc3_:int = int(_loc2_.width);
         var _loc4_:int = int(_loc2_.height);
         _loc2_ = null;
         if(param1)
         {
            return _loc3_;
         }
         return _loc4_;
      }
      
      internal function frame1() : *
      {
      }
   }
}

