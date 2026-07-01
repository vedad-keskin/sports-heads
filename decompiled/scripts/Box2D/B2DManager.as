package Box2D
{
   import Box2D.Collision.*;
   import Box2D.Collision.Shapes.*;
   import Box2D.Common.Math.*;
   import Box2D.Dynamics.*;
   import Box2D.Dynamics.Joints.*;
   import flash.display.MovieClip;
   
   public class B2DManager
   {
      
      public static var Root:MovieClip;
      
      public function B2DManager()
      {
         super();
      }
      
      public static function init(param1:MovieClip) : void
      {
         Root = param1;
      }
      
      public static function spawnCircleBody(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:int, param9:MovieClip) : b2Body
      {
         var _loc10_:b2BodyDef = null;
         var _loc11_:b2CircleDef = null;
         _loc10_ = new b2BodyDef();
         _loc10_.position.x = param2;
         _loc10_.position.y = param3;
         _loc11_ = new b2CircleDef();
         _loc11_.radius = param4;
         _loc11_.density = param5;
         _loc11_.friction = param6;
         _loc11_.restitution = param7;
         _loc11_.filter.groupIndex = param8;
         _loc10_.userData = param9;
         _loc10_.userData.width = 2 * Root.worldScale * param4;
         _loc10_.userData.height = 2 * Root.worldScale * param4;
         Root[param1] = Root.m_world.CreateBody(_loc10_);
         Root[param1].CreateShape(_loc11_);
         Root[param1].SetMassFromShapes();
         Root.addChild(_loc10_.userData);
         return Root[param1];
      }
      
      public static function spawnFixedRotCircleBody(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:int, param9:MovieClip) : b2Body
      {
         var _loc10_:b2BodyDef = null;
         _loc10_ = new b2BodyDef();
         _loc10_.position.x = param2;
         _loc10_.position.y = param3;
         var _loc11_:b2CircleDef = new b2CircleDef();
         _loc11_.radius = param4;
         _loc11_.density = param5;
         _loc11_.friction = param6;
         _loc11_.restitution = param7;
         _loc11_.filter.groupIndex = param8;
         _loc10_.userData = param9;
         _loc10_.userData.width = 2 * Root.worldScale * param4;
         _loc10_.userData.height = 2 * Root.worldScale * param4;
         _loc10_.fixedRotation = true;
         Root[param1] = Root.m_world.CreateBody(_loc10_);
         Root[param1].CreateShape(_loc11_);
         Root[param1].SetMassFromShapes();
         Root.addChild(_loc10_.userData);
         return Root[param1];
      }
      
      public static function spawnBoxBody(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:int, param10:MovieClip) : b2Body
      {
         var _loc11_:b2BodyDef = null;
         _loc11_ = new b2BodyDef();
         _loc11_.position.x = param2;
         _loc11_.position.y = param3;
         var _loc12_:b2PolygonDef = new b2PolygonDef();
         _loc12_.SetAsBox(param4 / 2,param5 / 2);
         _loc12_.density = param6;
         _loc12_.friction = param7;
         _loc12_.restitution = param8;
         _loc12_.filter.groupIndex = param9;
         _loc11_.userData = param10;
         _loc11_.userData.width = param4 * Root.worldScale;
         _loc11_.userData.height = param5 * Root.worldScale;
         Root[param1] = Root.m_world.CreateBody(_loc11_);
         Root[param1].CreateShape(_loc12_);
         Root[param1].SetMassFromShapes();
         Root.addChild(_loc11_.userData);
         return Root[param1];
      }
      
      public static function spawnFixedRotBoxBody(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:int, param10:MovieClip) : b2Body
      {
         var _loc11_:b2BodyDef = new b2BodyDef();
         _loc11_.position.x = param2;
         _loc11_.position.y = param3;
         var _loc12_:b2PolygonDef = new b2PolygonDef();
         _loc12_.SetAsBox(param4 / 2,param5 / 2);
         _loc12_.density = param6;
         _loc12_.friction = param7;
         _loc12_.restitution = param8;
         _loc12_.filter.groupIndex = param9;
         _loc11_.userData = param10;
         _loc11_.userData.width = param4 * Root.worldScale;
         _loc11_.userData.height = param5 * Root.worldScale;
         _loc11_.fixedRotation = true;
         Root[param1] = Root.m_world.CreateBody(_loc11_);
         Root[param1].CreateShape(_loc12_);
         Root[param1].SetMassFromShapes();
         Root.addChild(_loc11_.userData);
         return Root[param1];
      }
      
      public static function spawnEquilateralBody(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:int, param9:MovieClip) : b2Body
      {
         var _loc10_:b2BodyDef = new b2BodyDef();
         _loc10_.position.x = param2;
         _loc10_.position.y = param3;
         var _loc11_:b2PolygonDef = new b2PolygonDef();
         _loc11_.vertexCount = 3;
         _loc11_.vertices[0].Set(0,-1 * param4);
         _loc11_.vertices[1].Set(0.865 * param4,0.5 * param4);
         _loc11_.vertices[2].Set(-0.865 * param4,0.5 * param4);
         _loc11_.density = param5;
         _loc11_.friction = param6;
         _loc11_.restitution = param7;
         _loc11_.filter.groupIndex = param8;
         _loc10_.userData = param9;
         _loc10_.userData.width = 0.865 * param4 * 2 * Root.worldScale;
         _loc10_.userData.height = (1 * param4 + 0.5 * param4) * Root.worldScale;
         Root[param1] = Root.m_world.CreateBody(_loc10_);
         Root[param1].CreateShape(_loc11_);
         Root[param1].SetMassFromShapes();
         Root.addChild(_loc10_.userData);
         return Root[param1];
      }
      
      public static function spawnIsocRightBody(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:int, param9:MovieClip) : b2Body
      {
         var _loc10_:b2BodyDef = new b2BodyDef();
         _loc10_.position.x = param2;
         _loc10_.position.y = param3;
         var _loc11_:b2PolygonDef = new b2PolygonDef();
         _loc11_.vertexCount = 3;
         _loc11_.vertices[0].Set(0,0);
         _loc11_.vertices[1].Set(0,-param4);
         _loc11_.vertices[2].Set(param4,0);
         _loc11_.density = param5;
         _loc11_.friction = param6;
         _loc11_.restitution = param7;
         _loc11_.filter.groupIndex = param8;
         _loc10_.userData = param9;
         _loc10_.userData.width = param4 * Root.worldScale;
         _loc10_.userData.height = param4 * Root.worldScale;
         Root[param1] = Root.m_world.CreateBody(_loc10_);
         Root[param1].CreateShape(_loc11_);
         Root[param1].SetMassFromShapes();
         Root.addChild(_loc10_.userData);
         return Root[param1];
      }
      
      public static function spawnTrapezoidBody(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:int, param9:MovieClip) : b2Body
      {
         var _loc10_:b2BodyDef = new b2BodyDef();
         _loc10_.position.x = param2;
         _loc10_.position.y = param3;
         var _loc11_:b2PolygonDef = new b2PolygonDef();
         _loc11_.vertexCount = 4;
         _loc11_.vertices[0].Set(-1 * param4 / 4,-1 * param4 / 4);
         _loc11_.vertices[1].Set(param4 / 4,-1 * param4 / 4);
         _loc11_.vertices[2].Set(param4 / 2,param4 / 4);
         _loc11_.vertices[3].Set(-1 * param4 / 2,param4 / 4);
         _loc11_.density = param5;
         _loc11_.friction = param6;
         _loc11_.restitution = param7;
         _loc11_.filter.groupIndex = param8;
         _loc10_.userData = param9;
         _loc10_.userData.width = param4 * Root.worldScale;
         _loc10_.userData.height = param4 / 2 * Root.worldScale;
         Root[param1] = Root.m_world.CreateBody(_loc10_);
         Root[param1].CreateShape(_loc11_);
         Root[param1].SetMassFromShapes();
         Root.addChild(_loc10_.userData);
         return Root[param1];
      }
      
      public static function spawnHexagonBody(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:int, param9:MovieClip) : b2Body
      {
         var _loc10_:b2BodyDef = new b2BodyDef();
         _loc10_.position.x = param2;
         _loc10_.position.y = param3;
         var _loc11_:b2PolygonDef = new b2PolygonDef();
         _loc11_.vertexCount = 6;
         _loc11_.vertices[0].Set(param4 * 0.5,-1 * param4 * 0.866);
         _loc11_.vertices[1].Set(param4,0);
         _loc11_.vertices[2].Set(param4 * 0.5,param4 * 0.866);
         _loc11_.vertices[3].Set(-1 * param4 * 0.5,param4 * 0.866);
         _loc11_.vertices[4].Set(-1 * param4,0);
         _loc11_.vertices[5].Set(-1 * param4 * 0.5,-1 * param4 * 0.866);
         _loc11_.density = param5;
         _loc11_.friction = param6;
         _loc11_.restitution = param7;
         _loc11_.filter.groupIndex = param8;
         _loc10_.userData = param9;
         _loc10_.userData.width = param4 * 2 * Root.worldScale;
         _loc10_.userData.height = param4 * 1.732 * Root.worldScale;
         Root[param1] = Root.m_world.CreateBody(_loc10_);
         Root[param1].CreateShape(_loc11_);
         Root[param1].SetMassFromShapes();
         Root.addChild(_loc10_.userData);
         return Root[param1];
      }
      
      public static function spawnLineFromArray(param1:uint, param2:uint, param3:int, param4:Number, param5:Boolean, param6:Array, param7:uint, param8:Number, param9:Number, param10:Boolean, param11:int) : MovieClip
      {
         var _loc12_:MovieClip = null;
         var _loc13_:uint = 0;
         var _loc14_:b2EdgeChainDef = null;
         if(param7 == 1)
         {
            _loc12_ = new MovieClip();
            Root.addChild(_loc12_);
            _loc12_.graphics.lineStyle(param2,param1);
            _loc12_.graphics.moveTo(param6[0],param6[1]);
            if(param3 >= 0)
            {
               _loc12_.graphics.beginFill(param3);
            }
            if(param5)
            {
               _loc14_ = new b2EdgeChainDef();
               _loc14_.friction = param8;
               _loc14_.restitution = param9;
            }
            _loc13_ = 0;
            while(_loc13_ < param6.length)
            {
               _loc12_.graphics.lineTo(param6[_loc13_],param6[_loc13_ + 1]);
               if(param5)
               {
                  _loc14_.vertices.push(new b2Vec2(param6[_loc13_] / Root.worldScale,param6[_loc13_ + 1] / Root.worldScale));
               }
               _loc13_ += 2;
            }
            if(param3 >= 0)
            {
               _loc12_.graphics.endFill();
            }
            if(param5)
            {
               _loc14_.isALoop = param10;
               _loc14_.vertexCount = _loc14_.vertices.length;
               Root.m_world.GetGroundBody().CreateShape(_loc14_);
            }
            return _loc12_;
         }
         return null;
      }
      
      public static function spawnLineFromArrayReturnShape(param1:uint, param2:uint, param3:int, param4:Number, param5:Boolean, param6:Array, param7:uint, param8:Number, param9:Number, param10:Boolean, param11:int) : *
      {
         var _loc12_:MovieClip = null;
         var _loc13_:uint = 0;
         var _loc14_:b2EdgeChainDef = null;
         var _loc15_:* = undefined;
         if(param7 == 1)
         {
            _loc12_ = new MovieClip();
            Root.addChild(_loc12_);
            _loc12_.graphics.lineStyle(param2,param1);
            _loc12_.graphics.moveTo(param6[0],param6[1]);
            if(param3 >= 0)
            {
               _loc12_.graphics.beginFill(param3,param4);
            }
            if(param5)
            {
               _loc14_ = new b2EdgeChainDef();
               _loc14_.friction = param8;
               _loc14_.restitution = param9;
            }
            _loc13_ = 0;
            while(_loc13_ < param6.length)
            {
               _loc12_.graphics.lineTo(param6[_loc13_],param6[_loc13_ + 1]);
               if(param5)
               {
                  _loc14_.vertices.push(new b2Vec2(param6[_loc13_] / Root.worldScale,param6[_loc13_ + 1] / Root.worldScale));
               }
               _loc13_ += 2;
            }
            if(param3 >= 0)
            {
               _loc12_.graphics.endFill();
            }
            if(param5)
            {
               _loc14_.isALoop = param10;
               _loc14_.vertexCount = _loc14_.vertices.length;
               _loc15_ = Root.m_world.GetGroundBody().CreateShape(_loc14_);
               _loc15_.SetUserData(_loc12_);
               return _loc15_;
            }
            return _loc12_;
         }
         return null;
      }
      
      public static function spawnJoint(param1:String, param2:String, param3:String, param4:Number, param5:b2Vec2) : b2RevoluteJoint
      {
         var _loc6_:b2RevoluteJointDef = new b2RevoluteJointDef();
         _loc6_.Initialize(Root[param2],Root[param3],param5);
         _loc6_.maxMotorTorque = param4;
         _loc6_.motorSpeed = 0;
         _loc6_.enableMotor = true;
         Root[param1] = Root.m_world.CreateJoint(_loc6_);
         return Root[param1];
      }
      
      public static function spawnStaticBoxBody(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:int, param10:MovieClip) : b2Body
      {
         var _loc11_:b2BodyDef = new b2BodyDef();
         _loc11_.position.x = param2;
         _loc11_.position.y = param3;
         var _loc12_:b2PolygonDef = new b2PolygonDef();
         _loc12_.SetAsBox(param4 / 2,param5 / 2);
         _loc12_.density = param6;
         _loc12_.friction = param7;
         _loc12_.restitution = param8;
         _loc12_.filter.groupIndex = param9;
         _loc11_.userData = param10;
         _loc11_.userData.width = param4 * Root.worldScale;
         _loc11_.userData.height = param5 * Root.worldScale;
         Root[param1] = Root.m_world.CreateBody(_loc11_);
         Root[param1].CreateShape(_loc12_);
         Root[param1].SetMassFromShapes();
         Root.addChild(_loc11_.userData);
         return Root[param1];
      }
   }
}

