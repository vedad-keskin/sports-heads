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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol425")]
   public dynamic class LevelBox_81 extends MovieClip
   {
      
      public var score_txt:TextField;
      
      public var name_txt:TextField;
      
      public var number_txt:TextField;
      
      public var numBtn:uint;
      
      public function LevelBox_81()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function mouseRelease(param1:MouseEvent) : void
      {
         if(Boolean(MovieClip(root).wonArray[numBtn - 1]) || (Boolean(numBtn == 1) || Boolean(MovieClip(root).wonArray[numBtn - 2])))
         {
            Utils.playSound("kickSound");
            MovieClip(root).startLevel(numBtn);
         }
      }
      
      internal function frame1() : *
      {
         stop();
         numBtn = uint(name.substr(2,10));
         if(numBtn == 0)
         {
            numBtn = 10;
         }
         number_txt.text = numBtn + "";
         name_txt.text = MovieClip(root).oppNameArray[numBtn - 1];
         score_txt.text = MovieClip(root).heroScoreArray[numBtn - 1] + " - " + MovieClip(root).oppScoreArray[numBtn - 1];
         if(MovieClip(root).wonArray[numBtn - 1])
         {
            gotoAndStop(3);
         }
         else
         {
            gotoAndStop(1);
            if(numBtn == 1)
            {
               gotoAndStop(2);
            }
            else if(MovieClip(root).wonArray[numBtn - 2])
            {
               gotoAndStop(2);
            }
         }
         Utils.addRollOver(this,"lightTint",0.5);
         addEventListener(MouseEvent.MOUSE_UP,mouseRelease);
      }
   }
}

