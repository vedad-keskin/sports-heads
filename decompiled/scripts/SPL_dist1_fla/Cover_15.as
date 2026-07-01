package SPL_dist1_fla
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol218")]
   public dynamic class Cover_15 extends MovieClip
   {
      
      public var inside:MovieClip;
      
      public var bmd:BitmapData;
      
      public var bm:Bitmap;
      
      public function Cover_15()
      {
         super();
         addFrameScript(0,frame1,19,frame20);
      }
      
      public function displaySelf() : *
      {
         bmd.draw(MovieClip(root));
         play();
         y = 0;
         Utils.makeHighestDepth(this);
      }
      
      internal function frame1() : *
      {
         stop();
         Utils.makeHighestDepth(this);
         bmd = new BitmapData(800,600,true,0);
         bm = new Bitmap(bmd);
         inside.addChild(bm);
      }
      
      internal function frame20() : *
      {
         y = -2000;
         inside.removeChild(bm);
         bm = null;
      }
   }
}

