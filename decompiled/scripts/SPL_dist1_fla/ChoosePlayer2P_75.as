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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol416")]
   public dynamic class ChoosePlayer2P_75 extends MovieClip
   {
      
      public var lf1:MovieClip;
      
      public var specialsBut:SimpleButton;
      
      public var lf2:MovieClip;
      
      public var tpSpecialsText:TextField;
      
      public var tpLeft:MovieClip;
      
      public var tpRight:MovieClip;
      
      public var tpWalls:MovieClip;
      
      public var tpGameTypeText:TextField;
      
      public var Head1:MovieClip;
      
      public var Head2:MovieClip;
      
      public var rf1:MovieClip;
      
      public var specialText:TextField;
      
      public var rf2:MovieClip;
      
      public var tpGtBut:SimpleButton;
      
      public var headLimit:*;
      
      public function ChoosePlayer2P_75()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function tpGtButHit(param1:Event) : *
      {
         ++MovieClip(root).tpGameType;
         if(MovieClip(root).tpGameType > MovieClip(root).tpGameTypeList.length - 1)
         {
            MovieClip(root).tpGameType = 0;
         }
         Update();
      }
      
      public function specialsButHit(param1:Event) : *
      {
         ++MovieClip(root).tpSpecials;
         if(MovieClip(root).tpSpecials > MovieClip(root).tpSpecialsList.length - 1)
         {
            MovieClip(root).tpSpecials = 0;
         }
         Update();
      }
      
      public function tpLeftHit(param1:Event) : *
      {
         if(MovieClip(root).tpPitch > 2)
         {
            --MovieClip(root).tpPitch;
         }
         Update();
      }
      
      public function tpRightHit(param1:Event) : *
      {
         if(MovieClip(root).tpPitch < 20)
         {
            ++MovieClip(root).tpPitch;
         }
         Update();
      }
      
      public function mouseRelease1(param1:Event) : *
      {
         if(MovieClip(root).tpskin1 > 1)
         {
            --MovieClip(root).tpskin1;
         }
         Update();
      }
      
      public function mouseRelease2(param1:Event) : *
      {
         if(MovieClip(root).tpskin1 < headLimit)
         {
            ++MovieClip(root).tpskin1;
         }
         Update();
      }
      
      public function mouseRelease3(param1:Event) : *
      {
         if(MovieClip(root).tpskin2 > 1)
         {
            --MovieClip(root).tpskin2;
         }
         Update();
      }
      
      public function mouseRelease4(param1:Event) : *
      {
         if(MovieClip(root).tpskin2 < headLimit)
         {
            ++MovieClip(root).tpskin2;
         }
         Update();
      }
      
      public function Update() : *
      {
         Head1.gotoAndStop(MovieClip(root).tpskin1);
         Head2.gotoAndStop(MovieClip(root).tpskin2);
         tpSpecialsText.text = String(MovieClip(root).tpSpecialsList[MovieClip(root).tpSpecials]);
         tpGameTypeText.text = String(MovieClip(root).tpGameTypeList[MovieClip(root).tpGameType]);
         tpWalls.gotoAndStop(MovieClip(root).tpPitch);
      }
      
      internal function frame1() : *
      {
         lf1.addEventListener(MouseEvent.MOUSE_UP,mouseRelease1);
         rf1.addEventListener(MouseEvent.MOUSE_UP,mouseRelease2);
         lf2.addEventListener(MouseEvent.MOUSE_UP,mouseRelease3);
         rf2.addEventListener(MouseEvent.MOUSE_UP,mouseRelease4);
         tpLeft.addEventListener(MouseEvent.MOUSE_UP,tpLeftHit);
         tpRight.addEventListener(MouseEvent.MOUSE_UP,tpRightHit);
         tpGtBut.addEventListener(MouseEvent.MOUSE_UP,tpGtButHit);
         specialsBut.addEventListener(MouseEvent.MOUSE_UP,specialsButHit);
         MovieClip(root).SPECIAL_HEADS = true;
         headLimit = MovieClip(root).teamList.length;
         specialText.text = String("");
         if(MovieClip(root).SPECIAL_HEADS)
         {
            headLimit = 30;
            specialText.text = String("** CLASSIC PLAYERS UNLOCKED **");
         }
         Update();
      }
   }
}
