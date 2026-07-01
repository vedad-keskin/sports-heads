package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol96")]
   public dynamic class GreenRing extends MovieClip
   {
      
      public var deleteme:Boolean;
      
      public function GreenRing()
      {
         super();
         addFrameScript(0,frame1,7,frame8);
      }
      
      public function Update() : *
      {
      }
      
      internal function frame1() : *
      {
      }
      
      internal function frame8() : *
      {
         deleteme = true;
      }
   }
}

