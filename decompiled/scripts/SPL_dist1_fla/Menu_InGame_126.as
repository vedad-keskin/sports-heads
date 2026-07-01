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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol549")]
   public dynamic class Menu_InGame_126 extends MovieClip
   {
      
      public var warning:MovieClip;
      
      public function Menu_InGame_126()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function mouseOverMe(param1:MouseEvent) : void
      {
         warning.visible = true;
      }
      
      public function mouseOffMe(param1:MouseEvent) : void
      {
         warning.visible = false;
      }
      
      public function mouseRelease(param1:MouseEvent) : void
      {
         if(!MovieClip(root).inGoal)
         {
            MovieClip(root).menuCalled();
         }
      }
      
      internal function frame1() : *
      {
         warning.visible = false;
         addEventListener(MouseEvent.MOUSE_UP,mouseRelease);
         addEventListener(MouseEvent.MOUSE_OVER,mouseOverMe);
         addEventListener(MouseEvent.MOUSE_OUT,mouseOffMe);
      }
   }
}

