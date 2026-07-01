package
{
   import flash.display.MovieClip;
   import flash.events.ContextMenuEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   
   public class Utils
   {
      
      public static var Root:MovieClip;
      
      public function Utils()
      {
         super();
      }
      
      public static function init(param1:MovieClip) : void
      {
         Root = param1;
      }
      
      public static function isOnSite(param1:String) : Boolean
      {
         if(Root.loaderInfo.url.indexOf(param1) == -1)
         {
            return false;
         }
         return true;
      }
      
      public static function ChangeRightClickMenu() : void
      {
         var _loc1_:ContextMenu = new ContextMenu();
         _loc1_.hideBuiltInItems();
         var _loc2_:ContextMenuItem = new ContextMenuItem("kChamp Games");
         _loc2_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,gotoKCG);
         _loc1_.customItems.push(_loc2_);
         Root.contextMenu = _loc1_;
      }
      
      public static function gotoKCG(param1:ContextMenuEvent) : void
      {
         var _loc2_:String = "http://www.kchampgames.com/";
         var _loc3_:URLRequest = new URLRequest(_loc2_);
         navigateToURL(_loc3_,"_blank");
      }
      
      public static function addRollOver(param1:MovieClip, param2:String, param3:Number) : void
      {
         var _loc4_:RollOverObject = new RollOverObject(param1,param2,param3);
         param1.addEventListener(MouseEvent.ROLL_OVER,_loc4_.doRollOver);
         param1.addEventListener(MouseEvent.ROLL_OUT,_loc4_.doRollOut);
      }
      
      public static function makeHighestDepth(param1:MovieClip) : *
      {
         if(MovieClip(param1.parent) != null)
         {
            param1.parent.setChildIndex(param1,param1.parent.numChildren - 1);
         }
      }
      
      public static function removeMC(param1:MovieClip) : *
      {
         if(MovieClip(param1.parent) != null)
         {
            param1.parent.setChildIndex(param1,param1.parent.numChildren - 1);
            param1.parent.removeChild(param1);
            param1 = null;
         }
      }
      
      public static function playSound(param1:String) : *
      {
         if(!Root.muteSound)
         {
            Root[param1].play(0,1);
         }
      }
      
      public static function dateToString(param1:Date) : String
      {
         var _loc2_:Array = new Array("January","February","March","April","May","June","July","August","September","October","November","December");
         return _loc2_[param1.getMonth()] + " " + param1.getDate() + ", " + param1.getFullYear();
      }
      
      public static function addTimeFunction(param1:uint, param2:Function) : *
      {
         var _loc3_:TimeFunction = new TimeFunction(Root,param1,param2);
      }
      
      public static function deleteInstance(param1:*) : *
      {
         param1 = null;
      }
   }
}

