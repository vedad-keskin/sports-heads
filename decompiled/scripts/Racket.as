package
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol69")]
   public dynamic class Racket extends MovieClip
   {
      
      public function Racket()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      internal function frame1() : *
      {
         visible = false;
      }
   }
}

