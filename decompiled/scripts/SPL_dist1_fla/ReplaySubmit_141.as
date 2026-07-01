package SPL_dist1_fla
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol604")]
   public dynamic class ReplaySubmit_141 extends MovieClip
   {
      
      public function ReplaySubmit_141()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function mouseRelease(param1:MouseEvent) : *
      {
         var _loc2_:URLRequest = new URLRequest("http://www.mousebreaker.com/games/sportsheadsfootballchampion/playgame");
         navigateToURL(_loc2_,"_self");
      }
      
      internal function frame1() : *
      {
         Utils.addRollOver(this,"lightTint",0.5);
         addEventListener(MouseEvent.MOUSE_UP,mouseRelease);
      }
   }
}

