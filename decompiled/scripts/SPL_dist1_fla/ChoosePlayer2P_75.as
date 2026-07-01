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
      
      public static const CLASSIC_HEAD_LAST:int = 28;
      
      public static const BEAR_HEAD_FRAME:int = 30;
      
      public static const RIBERY_HEAD_FRAME:int = 31;
      
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
      
      public function normalizeHeadSkin(param1:int) : int
      {
         if(param1 == BEAR_HEAD_FRAME || param1 == RIBERY_HEAD_FRAME)
         {
            return param1;
         }
         if(param1 >= 1 && param1 <= CLASSIC_HEAD_LAST)
         {
            return param1;
         }
         if(param1 == 29)
         {
            return CLASSIC_HEAD_LAST;
         }
         return 1;
      }
      
      public function prevHeadSkin(param1:int) : int
      {
         param1 = normalizeHeadSkin(param1);
         if(param1 == RIBERY_HEAD_FRAME)
         {
            return BEAR_HEAD_FRAME;
         }
         if(param1 == BEAR_HEAD_FRAME)
         {
            return CLASSIC_HEAD_LAST;
         }
         if(param1 <= 1)
         {
            return RIBERY_HEAD_FRAME;
         }
         return param1 - 1;
      }
      
      public function nextHeadSkin(param1:int) : int
      {
         param1 = normalizeHeadSkin(param1);
         if(param1 == CLASSIC_HEAD_LAST)
         {
            return BEAR_HEAD_FRAME;
         }
         if(param1 == BEAR_HEAD_FRAME)
         {
            return RIBERY_HEAD_FRAME;
         }
         if(param1 == RIBERY_HEAD_FRAME)
         {
            return 1;
         }
         return param1 + 1;
      }
      
      public function mouseRelease1(param1:Event) : *
      {
         MovieClip(root).tpskin1 = prevHeadSkin(MovieClip(root).tpskin1);
         Update();
      }
      
      public function mouseRelease2(param1:Event) : *
      {
         MovieClip(root).tpskin1 = nextHeadSkin(MovieClip(root).tpskin1);
         Update();
      }
      
      public function mouseRelease3(param1:Event) : *
      {
         MovieClip(root).tpskin2 = prevHeadSkin(MovieClip(root).tpskin2);
         Update();
      }
      
      public function mouseRelease4(param1:Event) : *
      {
         MovieClip(root).tpskin2 = nextHeadSkin(MovieClip(root).tpskin2);
         Update();
      }
      
      public function Update() : *
      {
         MovieClip(root).tpskin1 = normalizeHeadSkin(MovieClip(root).tpskin1);
         MovieClip(root).tpskin2 = normalizeHeadSkin(MovieClip(root).tpskin2);
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
         headLimit = RIBERY_HEAD_FRAME;
         specialText.text = String("** CLASSIC PLAYERS UNLOCKED **");
         Update();
      }
   }
}
