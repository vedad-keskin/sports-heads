package SPL_dist1_fla
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol377")]
   public dynamic class titleFacebookBut_73 extends MovieClip
   {
      
      public function titleFacebookBut_73()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function mouseRelease(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = new URLRequest("http://www.facebook.com/pages/Sports-Heads/253664764679084");
         navigateToURL(_loc2_,"_blank");
      }
      
      internal function frame1() : *
      {
         Utils.addRollOver(this,"lightTint",0.5);
         addEventListener(MouseEvent.MOUSE_UP,mouseRelease);
      }
   }
}

