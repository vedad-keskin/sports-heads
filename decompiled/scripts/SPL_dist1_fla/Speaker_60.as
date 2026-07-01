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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol348")]
   public dynamic class Speaker_60 extends MovieClip
   {
      
      public var _root:MovieClip;
      
      public function Speaker_60()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function Click(param1:Event) : void
      {
         if(currentFrame == 1)
         {
            _root.muteSound = true;
            gotoAndStop(2);
         }
         else if(currentFrame == 2)
         {
            _root.muteSound = false;
            gotoAndStop(1);
         }
      }
      
      internal function frame1() : *
      {
         _root = MovieClip(root);
         if(_root.muteSound)
         {
            gotoAndStop(2);
         }
         else
         {
            gotoAndStop(1);
         }
         addEventListener(MouseEvent.CLICK,Click);
      }
   }
}

