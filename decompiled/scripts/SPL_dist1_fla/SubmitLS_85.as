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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol433")]
   public dynamic class SubmitLS_85 extends MovieClip
   {
      
      public var clickable:Boolean;
      
      public function SubmitLS_85()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function mouseRelease(param1:MouseEvent) : void
      {
         if(clickable)
         {
            Utils.playSound("kickSound");
            MovieClip(root).removeLeague();
            MovieClip(root).gotoAndStop("results");
         }
      }
      
      internal function frame1() : *
      {
         Utils.addRollOver(this,"lightTint",0.5);
         addEventListener(MouseEvent.MOUSE_UP,mouseRelease);
      }
   }
}

