package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol93")]
   public dynamic class RedRing extends MovieClip
   {
      
      public var deleteme:Boolean;
      
      public function RedRing()
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

