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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol525")]
   public dynamic class Counter_116 extends MovieClip
   {
      
      public function Counter_116()
      {
         super();
         addFrameScript(0,frame1,2,frame3,89,frame90);
      }
      
      public function DisplaySelf() : *
      {
         y = 50;
         x = 400;
         gotoAndPlay(2);
         Utils.makeHighestDepth(this);
      }
      
      internal function frame1() : *
      {
         Utils.makeHighestDepth(this);
         stop();
      }
      
      internal function frame3() : *
      {
         Utils.makeHighestDepth(this);
      }
      
      internal function frame90() : *
      {
         if(MovieClip(root) != null)
         {
            MovieClip(root).pauseGame = false;
            y = -1000;
         }
      }
   }
}

