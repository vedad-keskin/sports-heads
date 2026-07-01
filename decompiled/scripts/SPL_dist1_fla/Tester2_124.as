package SPL_dist1_fla
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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol539")]
   public dynamic class Tester2_124 extends MovieClip
   {
      
      public function Tester2_124()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function mouseRelease(param1:MouseEvent) : void
      {
         MovieClip(root).timeLeft = 5;
         MovieClip(root).scoreLeft = 2;
         MovieClip(root).scoreRight = 7;
      }
      
      internal function frame1() : *
      {
         addEventListener(MouseEvent.MOUSE_UP,mouseRelease);
      }
   }
}

