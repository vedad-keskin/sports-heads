package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol71")]
   public dynamic class Dust extends MovieClip
   {
      
      public var deleteme:Boolean;
      
      public var timer:uint;
      
      public var xspeed:Number;
      
      public var yspeed:Number;
      
      public function Dust()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function Update() : *
      {
         x += xspeed;
         y += yspeed;
         ++timer;
         width = 10 + timer / 2;
         height = 10 + timer / 2;
         alpha = (1 - timer / Utils.timingFrames(10)) * 0.6;
         if(timer > Utils.timingFrames(10))
         {
            deleteme = true;
         }
      }
      
      internal function frame1() : *
      {
      }
   }
}

