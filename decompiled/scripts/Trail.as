package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol98")]
   public dynamic class Trail extends MovieClip
   {
      
      public var deleteme:Boolean;
      
      public var timer:uint;
      
      public function Trail()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function Update() : *
      {
         ++timer;
         width = 16 * (1 - timer / Utils.timingFrames(20));
         height = 16 * (1 - timer / Utils.timingFrames(20));
         if(timer >= Utils.timingFrames(20))
         {
            deleteme = true;
         }
      }
      
      internal function frame1() : *
      {
      }
   }
}

