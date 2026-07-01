package
{
   import fl.motion.Color;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   
   public class RollOverObject
   {
      
      public var mc:MovieClip;
      
      public var str:String;
      
      public var num:Number;
      
      public function RollOverObject(param1:MovieClip, param2:String, param3:Number)
      {
         super();
         mc = param1;
         str = param2;
         num = param3;
      }
      
      public function doRollOver(param1:Event) : *
      {
         var _loc2_:Color = new Color();
         if(str == "lightTint")
         {
            _loc2_.setTint(16777215,num);
            mc.transform.colorTransform = _loc2_;
         }
         if(str == "darkTint")
         {
            _loc2_.setTint(0,num);
            mc.transform.colorTransform = _loc2_;
         }
         if(str == "alpha")
         {
            mc.alpha = num;
         }
         var _loc3_:GlowFilter = new GlowFilter();
         _loc3_.alpha = 0.5;
         _loc3_.quality = 1;
         if(str == "lightGlow")
         {
            _loc3_.color = 16777215;
            _loc3_.blurX = num;
            _loc3_.blurY = num;
            mc.filters = [_loc3_];
         }
         if(str == "darkGlow")
         {
            _loc3_.color = 0;
            _loc3_.blurX = num;
            _loc3_.blurY = num;
            mc.filters = [_loc3_];
         }
         if(str == "frame")
         {
            mc.gotoAndStop(2);
         }
      }
      
      public function doRollOut(param1:Event) : *
      {
         var _loc2_:Color = new Color();
         if(str == "lightTint")
         {
            _loc2_.setTint(16777215,0);
            mc.transform.colorTransform = _loc2_;
         }
         if(str == "darkTint")
         {
            _loc2_.setTint(0,0);
            mc.transform.colorTransform = _loc2_;
         }
         if(str == "alpha")
         {
            mc.alpha = 100;
         }
         if(str == "lightGlow")
         {
            mc.filters = [];
         }
         if(str == "darkGlow")
         {
            mc.filters = [];
         }
         if(str == "frame")
         {
            mc.gotoAndStop(1);
         }
      }
   }
}

