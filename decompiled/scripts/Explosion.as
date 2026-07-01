package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol65")]
   public dynamic class Explosion extends MovieClip
   {
      
      public var deleteme:Boolean;
      
      public function Explosion()
      {
         super();
         addFrameScript(0,frame1,20,frame21);
      }
      
      public function Update() : *
      {
      }
      
      internal function frame1() : *
      {
      }
      
      internal function frame21() : *
      {
         deleteme = true;
      }
   }
}

