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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol521")]
   public dynamic class score_mc_115 extends MovieClip
   {
      
      public var score_txt:TextField;
      
      public var timer:uint;
      
      public function score_mc_115()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function Update() : *
      {
         ++timer;
         if(timer < Utils.timingFrames(100))
         {
            y = 160;
            x = 400;
            alpha = (Utils.timingFrames(100) - timer) / Utils.timingFrames(100);
         }
         else
         {
            y = -1000;
         }
      }
      
      public function displaySelf() : *
      {
         y = 160;
         x = 400;
         alpha = 1;
         Utils.makeHighestDepth(this);
         timer = 0;
         score_txt.text = MovieClip(root).scoreLeft + " - " + MovieClip(root).scoreRight;
      }
      
      public function writeText(param1:String) : *
      {
         Utils.makeHighestDepth(this);
         timer = 0;
         score_txt.text = param1;
      }
      
      internal function frame1() : *
      {
         timer = 0;
         Utils.makeHighestDepth(this);
      }
   }
}

