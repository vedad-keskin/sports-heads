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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol102")]
   public dynamic class Block_Prop extends MovieClip
   {
      
      public function Block_Prop()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function spawnProp() : void
      {
         MovieClip(root).blueprints.spawnBlock(x,y,GetSize(true),GetSize(false),rotation);
      }
      
      public function GetSize(param1:Boolean) : int
      {
         if(param1)
         {
            return scaleX * 50;
         }
         return scaleY * 50;
      }
      
      internal function frame1() : *
      {
      }
   }
}

