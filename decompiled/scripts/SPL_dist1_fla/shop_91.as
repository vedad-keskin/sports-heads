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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol495")]
   public dynamic class shop_91 extends MovieClip
   {
      
      public var upPoints:TextField;
      
      public var b0:SimpleButton;
      
      public var b1:SimpleButton;
      
      public var b2:SimpleButton;
      
      public var warningText:TextField;
      
      public var b3:SimpleButton;
      
      public var b4:SimpleButton;
      
      public var up0:TextField;
      
      public var up1:TextField;
      
      public var b5:SimpleButton;
      
      public var up2:TextField;
      
      public var b6:SimpleButton;
      
      public var up3:TextField;
      
      public var up4:TextField;
      
      public var up5:TextField;
      
      public var up6:TextField;
      
      public function shop_91()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function upClick(param1:MouseEvent) : *
      {
         var _loc2_:String = String(param1.target.name);
         var _loc3_:int = int(_loc2_.substr(1,1));
         trace("*** UPGRADE POINTS *** " + MovieClip(root).upgradePoints);
         if(MovieClip(root).upgradePoints > MovieClip(root).upgradeList[1][_loc3_] - 1)
         {
            if(MovieClip(root).upgradeList[0][_loc3_] < MovieClip(root).upgradeList[3][_loc3_])
            {
               MovieClip(root).upgradePoints = MovieClip(root).upgradePoints - MovieClip(root).upgradeList[1][_loc3_];
               ++MovieClip(root).upgradeList[0][_loc3_];
               fillUpgrades();
               MovieClip(root).saveGame();
            }
            else
            {
               warningText.text = String("** Limit Reached **");
            }
         }
         else
         {
            warningText.text = String("Not enough cash !");
         }
         trace("*** UPGRADE POINTS AFTERS*** " + MovieClip(root).upgradePoints);
      }
      
      public function fillUpgrades() : *
      {
         this.upPoints.text = String("£ " + MovieClip(root).upgradePoints);
         var _loc1_:int = 0;
         while(_loc1_ <= 6)
         {
            this["up" + _loc1_].text = String(MovieClip(root).upgradeList[0][_loc1_]);
            _loc1_++;
         }
      }
      
      internal function frame1() : *
      {
         b0.addEventListener(MouseEvent.MOUSE_UP,upClick);
         b1.addEventListener(MouseEvent.MOUSE_UP,upClick);
         b2.addEventListener(MouseEvent.MOUSE_UP,upClick);
         b3.addEventListener(MouseEvent.MOUSE_UP,upClick);
         b4.addEventListener(MouseEvent.MOUSE_UP,upClick);
         b5.addEventListener(MouseEvent.MOUSE_UP,upClick);
         b6.addEventListener(MouseEvent.MOUSE_UP,upClick);
         if(!MovieClip(root).BEAR_HEAD)
         {
            b6.visible = false;
         }
         fillUpgrades();
      }
   }
}

