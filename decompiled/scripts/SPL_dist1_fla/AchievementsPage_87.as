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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol460")]
   public dynamic class AchievementsPage_87 extends MovieClip
   {
      
      public var ab12:MovieClip;
      
      public var ab13:MovieClip;
      
      public var ab1:MovieClip;
      
      public var ab14:MovieClip;
      
      public var ab2:MovieClip;
      
      public var ab15:MovieClip;
      
      public var ab3:MovieClip;
      
      public var ab16:MovieClip;
      
      public var ab4:MovieClip;
      
      public var ab17:MovieClip;
      
      public var ab5:MovieClip;
      
      public var ab6:MovieClip;
      
      public var ab7:MovieClip;
      
      public var ab8:MovieClip;
      
      public var ab9:MovieClip;
      
      public var ab10:MovieClip;
      
      public var ab11:MovieClip;
      
      public function AchievementsPage_87()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function Update() : *
      {
         var _loc1_:uint = 1;
         while(_loc1_ <= 17)
         {
            if(MovieClip(root)["ach" + _loc1_])
            {
               this["ab" + _loc1_].gotoAndStop(2);
            }
            else
            {
               this["ab" + _loc1_].gotoAndStop(1);
            }
            _loc1_++;
         }
      }
      
      public function displaySelf() : *
      {
         y = 0;
         Utils.makeHighestDepth(this);
         Update();
      }
      
      public function hideSelf() : *
      {
         y = -1000;
      }
      
      internal function frame1() : *
      {
      }
   }
}

