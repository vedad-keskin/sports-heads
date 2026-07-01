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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol351")]
   public dynamic class MusicNote_61 extends MovieClip
   {
      
      public var _root:MovieClip;
      
      public function MusicNote_61()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function Click(param1:Event) : void
      {
         if(currentFrame == 1)
         {
            _root.loopChannel.stop();
            _root.loopChannel2.stop();
            _root.muteMusic = true;
            gotoAndStop(2);
         }
         else if(currentFrame == 2)
         {
            _root.loopChannel = _root.loopSound.play(0,999);
            _root.loopChannel2 = _root.loopSound2.play(0,999);
            _root.muteMusic = false;
            gotoAndStop(1);
         }
      }
      
      internal function frame1() : *
      {
         _root = MovieClip(root);
         if(_root.muteMusic)
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

