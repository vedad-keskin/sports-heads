package SPL_dist1_fla
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol512")]
   public dynamic class Scores_102 extends MovieClip
   {
      
      public var teamLeft_txt:TextField;
      
      public var walls:MovieClip;
      
      public var sr_txt:TextField;
      
      public var sl_txt:TextField;
      
      public var teamRight_txt:TextField;
      
      public function Scores_102()
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

