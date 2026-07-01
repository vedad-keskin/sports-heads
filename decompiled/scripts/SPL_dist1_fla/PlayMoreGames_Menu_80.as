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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol419")]
   public dynamic class PlayMoreGames_Menu_80 extends MovieClip
   {
      
      public function PlayMoreGames_Menu_80()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function mousePress(param1:MouseEvent) : *
      {
         var _loc2_:URLRequest = new URLRequest("http://www.mousebreaker.com/?utm_source=SportsHeadsFballChamps&utm_medium=generic&utm_campaign=distribution");
         navigateToURL(_loc2_,"blank");
         MovieClip(root).stopMusicBecauseClick();
      }
      
      internal function frame1() : *
      {
         Utils.addRollOver(this,"lightTint",0.5);
         addEventListener(MouseEvent.MOUSE_DOWN,mousePress);
      }
   }
}

