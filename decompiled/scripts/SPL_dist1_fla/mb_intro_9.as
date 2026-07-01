package SPL_dist1_fla
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol212")]
   public dynamic class mb_intro_9 extends MovieClip
   {
      
      public var exp:MovieClip;
      
      public function mb_intro_9()
      {
         super();
         addFrameScript(0,frame1,40,frame41);
      }
      
      public function mouseRelease(param1:MouseEvent) : *
      {
         var _loc2_:URLRequest = new URLRequest("http://www.mousebreaker.com/");
         navigateToURL(_loc2_,"_blank");
      }
      
      internal function frame1() : *
      {
         addEventListener(MouseEvent.MOUSE_UP,mouseRelease);
         Utils.addRollOver(this,"lightTint",0.5);
      }
      
      internal function frame41() : *
      {
         MovieClip(root).play();
      }
   }
}

