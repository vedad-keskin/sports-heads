package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol108")]
   public dynamic class Ring extends MovieClip
   {
      
      public var deleteme:Boolean;
      
      public function Ring()
      {
         super();
         addFrameScript(0,frame1,9,frame10);
      }
      
      public function Update() : *
      {
      }
      
      internal function frame1() : *
      {
      }
      
      internal function frame10() : *
      {
         deleteme = true;
      }
   }
}

