package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class TimeFunction
   {
      
      public var Root:MovieClip;
      
      public var frms:uint;
      
      public var funct:Function;
      
      public var timer:uint;
      
      public function TimeFunction(param1:MovieClip, param2:uint, param3:Function)
      {
         super();
         Root = param1;
         frms = param2;
         funct = param3;
         timer = 0;
         Root.addEventListener(Event.ENTER_FRAME,onFrame);
      }
      
      public function onFrame(param1:Event) : *
      {
         ++timer;
         if(timer == frms)
         {
            if(funct != null)
            {
               funct();
               Utils.deleteInstance(this);
            }
         }
      }
   }
}

