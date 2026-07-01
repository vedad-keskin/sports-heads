package
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol74")]
   public dynamic class Bomb extends MovieClip
   {
      
      public var deleteme:Boolean;
      
      public var yspeed:Number;
      
      public function Bomb()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function Update() : *
      {
         yspeed += 0.1;
         y += yspeed;
         if(y >= 470)
         {
            y = 470;
            Explode();
         }
      }
      
      public function Explode() : *
      {
         if(SuperMath.getDistance(this,MovieClip(root).hero.GetUserData()) < 50)
         {
            MovieClip(root).hero.GetUserData().base.gotoAndStop(3);
            MovieClip(root).heroBombed = true;
         }
         if(SuperMath.getDistance(this,MovieClip(root).opp.GetUserData()) < 50)
         {
            MovieClip(root).opp.GetUserData().base.gotoAndStop(3);
            MovieClip(root).oppBombed = true;
         }
         spawnExplosion();
         deleteme = true;
      }
      
      public function spawnExplosion() : *
      {
         var _loc1_:Explosion = null;
         Utils.playSound("explosionSound");
         _loc1_ = new Explosion();
         _loc1_.x = x;
         _loc1_.y = y;
         _loc1_.deleteme = false;
         MovieClip(root).myEffects.addItems(_loc1_);
         MovieClip(root).addChild(_loc1_);
      }
      
      internal function frame1() : *
      {
      }
   }
}

