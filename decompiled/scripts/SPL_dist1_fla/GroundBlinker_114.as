package SPL_dist1_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol519")]
   public dynamic class GroundBlinker_114 extends MovieClip
   {
      
      public function GroundBlinker_114()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      internal function frame1() : *
      {
         Utils.makeHighestDepth(this);
      }
   }
}

