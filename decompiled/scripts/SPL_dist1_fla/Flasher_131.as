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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol567")]
   public dynamic class Flasher_131 extends MovieClip
   {
      
      public var timer:int;
      
      public function Flasher_131()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function Update() : *
      {
         ++timer;
         if(timer < Utils.timingFrames(6) || timer > Utils.timingFrames(12) && timer < Utils.timingFrames(18))
         {
            y = 5;
         }
         else
         {
            y = -1000;
         }
         if(Boolean(MovieClip(root).timeMode) && Boolean(MovieClip(root).timeLeft == 10) && MovieClip(root).timeLeftBitch == 0)
         {
            doThing();
         }
      }
      
      public function doThing() : *
      {
         timer = 0;
      }
      
      internal function frame1() : *
      {
         timer = 1000;
      }
   }
}

