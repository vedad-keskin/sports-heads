package SPL_dist1_fla
{
   import flash.display.MovieClip;
   import flash.events.ProgressEvent;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol181")]
   public dynamic class pb_Preloader_2 extends MovieClip
   {
      
      public var percent_txt:TextField;
      
      public var circle:MovieClip;
      
      public var percent:Number;
      
      public var oldPercent:Number;
      
      public function pb_Preloader_2()
      {
         super();
         addFrameScript(0,frame1,39,frame40);
      }
      
      public function loading(param1:ProgressEvent) : void
      {
         percent = Math.round(param1.bytesLoaded / param1.bytesTotal * 100);
         if(oldPercent < percent)
         {
            oldPercent = percent;
            spawnPBCO();
         }
         percent_txt.text = percent + "";
         circle.width = percent * 0.6;
         circle.height = percent * 0.6;
         if(percent == 100)
         {
            finished();
         }
      }
      
      public function finished() : *
      {
         percent_txt.text = "100";
         circle.width = 60;
         circle.height = 60;
         MovieClip(parent).loaderInfo.removeEventListener(ProgressEvent.PROGRESS,loading);
         play();
      }
      
      public function spawnPBCO() : *
      {
         var _loc1_:Pbco = new Pbco();
         _loc1_.x = 0;
         _loc1_.y = 0;
         _loc1_.rotation = Math.random() * 360;
         addChild(_loc1_);
      }
      
      internal function frame1() : *
      {
         stop();
         MovieClip(parent).stop();
         percent = 0;
         oldPercent = 0;
         circle.width = 0;
         circle.height = 0;
         MovieClip(parent).loaderInfo.addEventListener(ProgressEvent.PROGRESS,loading);
         if(MovieClip(parent).loaderInfo.bytesLoaded == MovieClip(parent).loaderInfo.bytesTotal)
         {
            finished();
         }
      }
      
      internal function frame40() : *
      {
         stop();
      }
   }
}

