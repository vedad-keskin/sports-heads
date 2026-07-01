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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol543")]
   public dynamic class PauseBut_125 extends MovieClip
   {
      
      public var _root:MovieClip;
      
      public function PauseBut_125()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function Click(param1:Event) : void
      {
         if(currentFrame == 1)
         {
            _root.pauseGame = true;
            gotoAndStop(2);
         }
         else if(currentFrame == 2)
         {
            _root.pauseGame = false;
            gotoAndStop(1);
         }
      }
      
      internal function frame1() : *
      {
         _root = MovieClip(root);
         gotoAndStop(1);
         addEventListener(MouseEvent.CLICK,Click);
      }
   }
}

