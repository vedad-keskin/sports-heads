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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol238")]
   public dynamic class AchAward_17 extends MovieClip
   {
      
      public var timer:int;
      
      public function AchAward_17()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function onFrame(param1:Event) : void
      {
         ++timer;
         if(timer < 200)
         {
            alpha = 1;
            x = 10;
            y = 10;
            Utils.makeHighestDepth(this);
         }
         else
         {
            x = -1000;
            y = -1000;
         }
         if(timer > 100 && timer < 200)
         {
            alpha = 1 - (timer - 100) / 100;
         }
      }
      
      public function Award(param1:int) : *
      {
         trace("AWARD AWARDED " + param1);
         if(!MovieClip(root)["ach" + param1] && !MovieClip(root).TwoPlayers || !MovieClip(root)["ach" + param1] && param1 == 7)
         {
            Utils.playSound("cheerSound");
            MovieClip(root)["ach" + param1] = true;
            gotoAndStop(param1);
            x = 10;
            y = 10;
            timer = 0;
            Utils.makeHighestDepth(this);
            MovieClip(root).saveGame();
         }
      }
      
      internal function frame1() : *
      {
         Utils.makeHighestDepth(this);
         timer = 10000;
         addEventListener(Event.ENTER_FRAME,onFrame);
      }
   }
}

