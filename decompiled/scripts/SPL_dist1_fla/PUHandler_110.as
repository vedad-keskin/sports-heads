package SPL_dist1_fla
{
   import Box2D.*;
   import Box2D.Common.Math.b2Vec2;
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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol515")]
   public dynamic class PUHandler_110 extends MovieClip
   {
      
      public var heroPUSpeedTimer:uint;
      
      public var heroPUJumpTimer:uint;
      
      public var heroPUIceTimer:uint;
      
      public var heroPUBombsTimer:uint;
      
      public var heroPUSizeTimer:uint;
      
      public var heroPUBreakTimer:uint;
      
      public var oppPUSpeedTimer:uint;
      
      public var oppPUJumpTimer:uint;
      
      public var oppPUIceTimer:uint;
      
      public var oppPUBombsTimer:uint;
      
      public var oppPUSizeTimer:uint;
      
      public var oppPUBreakTimer:uint;
      
      public var PUFireTimer:uint;
      
      public var PUSizeTimer:uint;
      
      public var PUBouncyTimer:uint;
      
      public var PUStreakerTimer:uint;
      
      public function PUHandler_110()
      {
         super();
         addFrameScript(0,frame1);
      }
      
      public function Update() : *
      {
         ++heroPUSpeedTimer;
         ++heroPUJumpTimer;
         ++heroPUIceTimer;
         ++heroPUBombsTimer;
         ++heroPUSizeTimer;
         ++heroPUBreakTimer;
         ++oppPUSpeedTimer;
         ++oppPUJumpTimer;
         ++oppPUIceTimer;
         ++oppPUBombsTimer;
         ++oppPUSizeTimer;
         ++oppPUBreakTimer;
         ++PUFireTimer;
         ++PUSizeTimer;
         ++PUBouncyTimer;
         ++PUStreakerTimer;
         if(heroPUSpeedTimer == Utils.timingFrames(200))
         {
            MovieClip(root).hero.GetUserData().bolt.gotoAndStop(1);
            MovieClip(root).heroPUSpeed = 1;
         }
         if(heroPUJumpTimer == Utils.timingFrames(200))
         {
            MovieClip(root).heroPUJump = 1;
         }
         if(heroPUIceTimer == Utils.timingFrames(200))
         {
            MovieClip(root).hero.GetUserData().base.gotoAndStop(1);
            MovieClip(root).heroPUFreeze = false;
         }
         if(heroPUBombsTimer == Utils.timingFrames(600))
         {
            MovieClip(root).heroPUBombs = false;
            resetGoalSizes();
         }
         if(heroPUSizeTimer == Utils.timingFrames(600))
         {
            MovieClip(root).makeHeroNormal();
         }
         if(heroPUBreakTimer == Utils.timingFrames(200))
         {
            MovieClip(root).heroLegBroken = false;
            MovieClip(root).HERORACKET.gotoAndStop(1);
         }
         if(oppPUSpeedTimer == Utils.timingFrames(200))
         {
            MovieClip(root).opp.GetUserData().bolt.gotoAndStop(1);
            MovieClip(root).oppPUSpeed = 1;
         }
         if(oppPUJumpTimer == Utils.timingFrames(200))
         {
            MovieClip(root).oppPUJump = 1;
         }
         if(oppPUIceTimer == Utils.timingFrames(200))
         {
            MovieClip(root).opp.GetUserData().base.gotoAndStop(1);
            MovieClip(root).oppPUFreeze = false;
         }
         if(oppPUBombsTimer == Utils.timingFrames(600))
         {
            MovieClip(root).oppPUBombs = false;
            resetGoalSizes();
         }
         if(oppPUSizeTimer == Utils.timingFrames(600))
         {
            MovieClip(root).makeOppNormal();
         }
         if(oppPUBreakTimer == Utils.timingFrames(400))
         {
            MovieClip(root).oppLegBroken = false;
            MovieClip(root).OPPRACKET.gotoAndStop(1);
         }
         if(PUFireTimer == Utils.timingFrames(700))
         {
            MovieClip(root).PUFire = false;
            if(MovieClip(root).oppBombed)
            {
               MovieClip(root).opp.GetUserData().base.gotoAndStop(1);
            }
            MovieClip(root).oppBombed = false;
            if(MovieClip(root).heroBombed)
            {
               MovieClip(root).hero.GetUserData().base.gotoAndStop(1);
            }
            MovieClip(root).heroBombed = false;
         }
         if(PUSizeTimer == Utils.timingFrames(400))
         {
            MovieClip(root).PUSize = 1;
            MovieClip(root).updateBall();
         }
         if(PUBouncyTimer == Utils.timingFrames(200))
         {
            MovieClip(root).PUBouncy = 1;
            MovieClip(root).updateBall();
         }
         if(PUStreakerTimer == Utils.timingFrames(1000))
         {
            MovieClip(root).removeBody(MovieClip(root).streaker);
            MovieClip(root).streakerAlive = false;
         }
         if(PUFireTimer == Utils.timingFrames(1))
         {
            MovieClip(root).spawnBomb();
         }
         if(PUFireTimer == Utils.timingFrames(40))
         {
            MovieClip(root).spawnBomb();
         }
         if(PUFireTimer == Utils.timingFrames(80))
         {
            MovieClip(root).spawnBomb();
         }
      }
      
      public function bonusIsGo() : *
      {
         Utils.playSound("coinSound");
         MovieClip(root).makeHeroBig();
         heroPUSizeTimer = 0;
      }
      
      public function smallGoalIsGo() : *
      {
         MovieClip(root).scoreMC.writeText("Small Goal");
         MovieClip(root).top2Hit.y = 370;
         MovieClip(root).goalmc2.gotoAndStop(3);
         MovieClip(root).goal2Hit.y = 400;
         MovieClip(root).goal2Hit.height = 60;
         MovieClip(root).rightGoalPost.SetXForm(new b2Vec2(760,385),0);
         MovieClip(root).oppPUBombs = true;
         oppPUBombsTimer = 0;
      }
      
      public function smallGoalIsGo2() : *
      {
         MovieClip(root).top1Hit.y = 370;
         MovieClip(root).goalmc1.gotoAndStop(3);
         MovieClip(root).goal1Hit.y = 400;
         MovieClip(root).goal1Hit.height = 60;
         MovieClip(root).leftGoalPost.SetXForm(new b2Vec2(40,385),0);
         MovieClip(root).heroPUBombs = true;
         heroPUBombsTimer = 0;
      }
      
      public function bigGoalIsGo() : *
      {
         MovieClip(root).scoreMC.writeText("Big Goal");
         MovieClip(root).top1Hit.y = 290;
         MovieClip(root).goalmc1.gotoAndStop(2);
         MovieClip(root).goal1Hit.y = 320;
         MovieClip(root).goal1Hit.height = 140;
         MovieClip(root).leftGoalPost.SetXForm(new b2Vec2(40,305),0);
         MovieClip(root).oppPUBombs = true;
         oppPUBombsTimer = 0;
      }
      
      public function bigGoalIsGo2() : *
      {
         MovieClip(root).top2Hit.y = 290;
         MovieClip(root).goalmc2.gotoAndStop(2);
         MovieClip(root).goal2Hit.y = 320;
         MovieClip(root).goal2Hit.height = 140;
         MovieClip(root).rightGoalPost.SetXForm(new b2Vec2(760,305),0);
         MovieClip(root).oppPUBombs = true;
         MovieClip(root).heroPUBombs = true;
         heroPUBombsTimer = 0;
      }
      
      public function gotOne(param1:String, param2:MovieClip) : *
      {
         Utils.playSound("coinSound");
         if(param1 == "hero")
         {
            if(param2 is PU_Speed_Good)
            {
               MovieClip(root).scoreMC.writeText("Super Speed");
               MovieClip(root).hero.GetUserData().bolt.gotoAndStop(2);
               MovieClip(root).heroPUSpeed = 2;
               heroPUSpeedTimer = 0;
            }
            else if(param2 is PU_Speed_Bad)
            {
               MovieClip(root).scoreMC.writeText("Slow Speed");
               MovieClip(root).hero.GetUserData().bolt.gotoAndStop(3);
               MovieClip(root).heroPUSpeed = 0;
               heroPUSpeedTimer = 0;
            }
            else if(param2 is PU_Jump_Good)
            {
               MovieClip(root).scoreMC.writeText("Super Jump");
               MovieClip(root).heroPUJump = 2;
               heroPUJumpTimer = 0;
            }
            else if(param2 is PU_Jump_Bad)
            {
               MovieClip(root).scoreMC.writeText("Low Jump");
               MovieClip(root).heroPUJump = 0;
               heroPUJumpTimer = 0;
            }
            else if(param2 is PU_Ice_Good)
            {
               MovieClip(root).scoreMC.writeText("Freeze");
               MovieClip(root).opp.GetUserData().base.gotoAndStop(2);
               MovieClip(root).oppPUFreeze = true;
               oppPUIceTimer = 0;
            }
            else if(param2 is PU_Ice_Bad)
            {
               MovieClip(root).scoreMC.writeText("Freeze");
               MovieClip(root).hero.GetUserData().base.gotoAndStop(2);
               MovieClip(root).heroPUFreeze = true;
               heroPUIceTimer = 0;
            }
            else if(param2 is PU_Bombs_Good)
            {
               MovieClip(root).scoreMC.writeText("Big Goal");
               MovieClip(root).top1Hit.y = 290;
               MovieClip(root).goalmc1.gotoAndStop(2);
               MovieClip(root).goal1Hit.y = 320;
               MovieClip(root).goal1Hit.height = 140;
               MovieClip(root).leftGoalPost.SetXForm(new b2Vec2(40,305),0);
               MovieClip(root).oppPUBombs = true;
               oppPUBombsTimer = 0;
            }
            else if(param2 is PU_Bombs_Bad)
            {
               MovieClip(root).scoreMC.writeText("Small Goal");
               MovieClip(root).top1Hit.y = 370;
               MovieClip(root).goalmc1.gotoAndStop(3);
               MovieClip(root).goal1Hit.y = 400;
               MovieClip(root).goal1Hit.height = 60;
               MovieClip(root).leftGoalPost.SetXForm(new b2Vec2(40,385),0);
               MovieClip(root).heroPUBombs = true;
               heroPUBombsTimer = 0;
            }
            else if(param2 is PU_Size_Good)
            {
               MovieClip(root).makeHeroBig();
               heroPUSizeTimer = 0;
            }
            else if(param2 is PU_Size_Bad)
            {
               MovieClip(root).makeHeroSmall();
               heroPUSizeTimer = 0;
            }
            else if(param2 is PU_Break_Good)
            {
               MovieClip(root).oppLegBroken = true;
               MovieClip(root).OPPRACKET.gotoAndStop(2);
               oppPUBreakTimer = 0;
            }
            else if(param2 is PU_Break_Bad)
            {
               MovieClip(root).heroLegBroken = true;
               MovieClip(root).HERORACKET.gotoAndStop(2);
               heroPUBreakTimer = 0;
            }
         }
         else if(param2 is PU_Speed_Good)
         {
            MovieClip(root).scoreMC.writeText("Super Speed");
            MovieClip(root).opp.GetUserData().bolt.gotoAndStop(2);
            MovieClip(root).oppPUSpeed = 2;
            oppPUSpeedTimer = 0;
         }
         else if(param2 is PU_Speed_Bad)
         {
            MovieClip(root).scoreMC.writeText("Slow Speed");
            MovieClip(root).opp.GetUserData().bolt.gotoAndStop(3);
            MovieClip(root).oppPUSpeed = 0;
            oppPUSpeedTimer = 0;
         }
         else if(param2 is PU_Jump_Good)
         {
            MovieClip(root).scoreMC.writeText("Super Jump");
            MovieClip(root).oppPUJump = 2;
            oppPUJumpTimer = 0;
         }
         else if(param2 is PU_Jump_Bad)
         {
            MovieClip(root).scoreMC.writeText("Low Jump");
            MovieClip(root).oppPUJump = 0;
            oppPUJumpTimer = 0;
         }
         else if(param2 is PU_Ice_Good)
         {
            MovieClip(root).scoreMC.writeText("Freeze");
            MovieClip(root).hero.GetUserData().base.gotoAndStop(2);
            MovieClip(root).heroPUFreeze = true;
            heroPUIceTimer = 0;
         }
         else if(param2 is PU_Ice_Bad)
         {
            MovieClip(root).scoreMC.writeText("Freeze");
            MovieClip(root).opp.GetUserData().base.gotoAndStop(2);
            MovieClip(root).oppPUFreeze = true;
            oppPUIceTimer = 0;
         }
         else if(param2 is PU_Bombs_Good)
         {
            MovieClip(root).scoreMC.writeText("Big Goal");
            MovieClip(root).top2Hit.y = 290;
            MovieClip(root).goalmc2.gotoAndStop(2);
            MovieClip(root).goal2Hit.y = 320;
            MovieClip(root).goal2Hit.height = 140;
            MovieClip(root).rightGoalPost.SetXForm(new b2Vec2(760,305),0);
            MovieClip(root).oppPUBombs = true;
            MovieClip(root).heroPUBombs = true;
            heroPUBombsTimer = 0;
         }
         else if(param2 is PU_Bombs_Bad)
         {
            MovieClip(root).scoreMC.writeText("Small Goal");
            MovieClip(root).top2Hit.y = 370;
            MovieClip(root).goalmc2.gotoAndStop(3);
            MovieClip(root).goal2Hit.y = 400;
            MovieClip(root).goal2Hit.height = 60;
            MovieClip(root).rightGoalPost.SetXForm(new b2Vec2(760,385),0);
            MovieClip(root).oppPUBombs = true;
            oppPUBombsTimer = 0;
         }
         else if(param2 is PU_Size_Good)
         {
            MovieClip(root).makeOppBig();
            oppPUSizeTimer = 0;
         }
         else if(param2 is PU_Size_Bad)
         {
            MovieClip(root).makeOppSmall();
            oppPUSizeTimer = 0;
         }
         else if(param2 is PU_Break_Good)
         {
            MovieClip(root).heroLegBroken = true;
            MovieClip(root).HERORACKET.gotoAndStop(2);
            heroPUBreakTimer = 0;
         }
         else if(param2 is PU_Break_Bad)
         {
            MovieClip(root).oppLegBroken = true;
            MovieClip(root).OPPRACKET.gotoAndStop(2);
            oppPUBreakTimer = 0;
         }
         if(param2 is PU_Fireground_Neu)
         {
            MovieClip(root).scoreMC.writeText("Bombs");
            MovieClip(root).PUFire = true;
            PUFireTimer = 0;
         }
         else if(param2 is PU_Bigball_Neu)
         {
            MovieClip(root).scoreMC.writeText("Big Ball");
            MovieClip(root).PUSize = 2;
            MovieClip(root).updateBall();
            PUSizeTimer = 0;
         }
         else if(param2 is PU_Bouncyball_Neu)
         {
            MovieClip(root).scoreMC.writeText("Bouncy Ball");
            MovieClip(root).PUBouncy = 2;
            MovieClip(root).updateBall();
            PUSizeTimer = 0;
         }
         else if(param2 is PU_Smallball_Neu)
         {
            MovieClip(root).scoreMC.writeText("Small Ball");
            MovieClip(root).PUSize = 0;
            MovieClip(root).updateBall();
            PUBouncyTimer = 0;
         }
         else if(param2 is PU_Deadball_Neu)
         {
            MovieClip(root).scoreMC.writeText("Dead Ball");
            MovieClip(root).PUBouncy = 0;
            MovieClip(root).updateBall();
            PUBouncyTimer = 0;
         }
         else if(param2 is PU_Streaker_Neu)
         {
            MovieClip(root).spawnStreaker();
            PUStreakerTimer = 0;
         }
      }
      
      public function resetGoalSizes() : *
      {
         MovieClip(root).top1Hit.y = 330;
         MovieClip(root).goalmc1.gotoAndStop(1);
         MovieClip(root).goal1Hit.y = 360;
         MovieClip(root).goal1Hit.height = 100;
         MovieClip(root).leftGoalPost.SetXForm(new b2Vec2(40,345),0);
         MovieClip(root).heroPUBombs = true;
         MovieClip(root).top2Hit.y = 330;
         MovieClip(root).goalmc2.gotoAndStop(1);
         MovieClip(root).goal2Hit.y = 360;
         MovieClip(root).goal2Hit.height = 100;
         MovieClip(root).rightGoalPost.SetXForm(new b2Vec2(760,345),0);
         MovieClip(root).oppPUBombs = true;
      }
      
      internal function frame1() : *
      {
         heroPUSpeedTimer = 10000;
         heroPUJumpTimer = 10000;
         heroPUIceTimer = 10000;
         heroPUBombsTimer = 10000;
         heroPUSizeTimer = 10000;
         heroPUBreakTimer = 10000;
         oppPUSpeedTimer = 10000;
         oppPUJumpTimer = 10000;
         oppPUIceTimer = 10000;
         oppPUBombsTimer = 10000;
         oppPUSizeTimer = 10000;
         oppPUBreakTimer = 10000;
         PUFireTimer = 10000;
         PUSizeTimer = 10000;
         PUBouncyTimer = 10000;
         PUStreakerTimer = 10000;
      }
   }
}

