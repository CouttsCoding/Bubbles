package scenes 
{
	/**
	 * ...
	 * @author James
	 */
	
	import starling.display.Image;
    import starling.textures.Texture;
	import starling.textures.TextureAtlas
	import starling.events.EnterFrameEvent;
	import starling.display.Sprite;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Common.*;
	import Box2D.Common.Math.*;
	
	import DisasteroidLib.cShipController;
	import DisasteroidLib.cShipControllerEvent;
	
	public class Box2DTestScene extends Scene
	{
		public var World:b2World;
		public var Bomb:b2Body;
		public var VelocityIterations:int = 5;
		public var PositionIterations:int = 5;
		public var TimeStep:Number = 1.0 / 30.0;
		
		
		//public var PhysicalScale:Number = 10.0;
		
		public var PixelsPerMeter:Number = 50;
		public var MetersPerPixel:Number = 1 / PixelsPerMeter;
		
		public var Controller:cShipController;
		public var MyCircleImage:Image;
		public var MyCircleImage2:Image;
		public var MyBody:b2Body;
		public var MyBody2:b2Body;
		
		public function Box2DTestScene()
		{
			addEventListener(EnterFrameEvent.ENTER_FRAME, UpdateFrame);
			//addEventListener(cShipControllerEvent.EVENT, UpdateController);
			
			Controller = new cShipController();
			Controller.addEventListener(cShipControllerEvent.EVENT, UpdateController);
			
			var circleWorldRadius:Number = 0.7;
			var circle2WorldRadius:Number = 0.3;
			
			// the asteroids
			MyCircleImage = new Image(Assets.getTexture("Asteroid"));
			MyCircleImage.x = Constants.CenterX;
			MyCircleImage.y = Constants.CenterY;
			// set pivot values BEFORE adjusting width/height!!!
			MyCircleImage.pivotX = MyCircleImage.width / 2;
			MyCircleImage.pivotY = MyCircleImage.height / 2;
			MyCircleImage.width = PixelsPerMeter * circleWorldRadius * 2;
			MyCircleImage.height = PixelsPerMeter * circleWorldRadius * 2;
			
			addChild(MyCircleImage);
			
			MyCircleImage2 = new Image(Assets.getTexture("Asteroid"));
			MyCircleImage2.x = Constants.CenterX;
			MyCircleImage2.y = Constants.CenterY;
			MyCircleImage2.pivotX = MyCircleImage2.width / 2;
			MyCircleImage2.pivotY = MyCircleImage2.height / 2;
			MyCircleImage2.width = PixelsPerMeter * circle2WorldRadius * 2;
			MyCircleImage2.height = PixelsPerMeter * circle2WorldRadius * 2;
			
			
			addChild(MyCircleImage2);
			
			// world sizing
			var worldHalfWidth:Number = Constants.GameWidth * MetersPerPixel / 2;
			var worldHalfHeight:Number = Constants.GameHeight * MetersPerPixel / 2;
			
			// set some gravity
			var gravity:b2Vec2 = new b2Vec2(0.0, 0.0);
			// allow bodies to sleep
			var bAllowBodiesToSleep:Boolean = true;
			
			// make the world
			World = new b2World(gravity, bAllowBodiesToSleep);
			
			// make the circle body
			var circleShape:b2CircleShape = new b2CircleShape(circleWorldRadius);
			var circleBodyDef:b2BodyDef = new b2BodyDef();
			var circleFixtureDef:b2FixtureDef = new b2FixtureDef();
			circleBodyDef.type = b2Body.b2_dynamicBody;
			circleBodyDef.position.Set(0, 0);
			circleFixtureDef.shape = circleShape;
			circleFixtureDef.friction = 0.1;
			circleFixtureDef.density = 0.1;
			circleFixtureDef.restitution = 0.2;
			circleBodyDef.userData = MyCircleImage;
			MyBody = World.CreateBody(circleBodyDef);
			MyBody.CreateFixture(circleFixtureDef);
			
			circleShape = new b2CircleShape(circle2WorldRadius);
			circleBodyDef = new b2BodyDef();
			circleFixtureDef = new b2FixtureDef();
			circleBodyDef.type = b2Body.b2_dynamicBody;
			circleBodyDef.position.Set(worldHalfWidth*0.5, worldHalfHeight*0.5);
			circleFixtureDef.shape = circleShape;
			circleFixtureDef.friction = 0.1;
			circleFixtureDef.density = 0.1;
			circleFixtureDef.restitution = 0.2;
			circleBodyDef.userData = MyCircleImage2;
			MyBody2 = World.CreateBody(circleBodyDef);
			MyBody2.CreateFixture(circleFixtureDef);
			
			// make the bordering walls
			var wall:b2PolygonShape = new b2PolygonShape();
			var wallBodyDef:b2BodyDef = new b2BodyDef();
			var wallBody:b2Body;
			var wallHalfDepth:Number = MetersPerPixel*0.5;
			
			// left
			wallBodyDef.position.Set((-worldHalfWidth - wallHalfDepth), 0);
			wall.SetAsBox( wallHalfDepth, worldHalfHeight);
			wallBody = World.CreateBody(wallBodyDef);
			wallBody.CreateFixture2(wall);
			// right
			wallBodyDef.position.Set((worldHalfWidth + wallHalfDepth), 0);
			wall.SetAsBox(wallHalfDepth, worldHalfHeight);
			wallBody = World.CreateBody(wallBodyDef);
			wallBody.CreateFixture2(wall);
			// bottom 
			wallBodyDef.position.Set(0, worldHalfHeight + wallHalfDepth);
			wall.SetAsBox(worldHalfWidth, wallHalfDepth);
			wallBody = World.CreateBody(wallBodyDef);
			wallBody.CreateFixture2(wall);
			// top
			wallBodyDef.position.Set(0, (-worldHalfHeight - wallHalfDepth));
			wall.SetAsBox(worldHalfWidth, wallHalfDepth);
			wallBody = World.CreateBody(wallBodyDef);
			wallBody.CreateFixture2(wall);
		}
		
		public function UpdateController(e:cShipControllerEvent):void
		{
			//MyBody.ApplyForce(new b2Vec2(-Controller.AccelerometerX, Controller.AccelerometerY), MyBody.GetPosition());
		}
		
		public function UpdateFrame(e:EnterFrameEvent):void
		{
			MyBody.ApplyForce(new b2Vec2( -Controller.AccelerometerX, Controller.AccelerometerY), MyBody.GetPosition());
			MyBody2.ApplyForce(new b2Vec2(-Controller.AccelerometerX, Controller.AccelerometerY), MyBody2.GetPosition());
			
			World.Step(TimeStep, VelocityIterations, PositionIterations);
			World.ClearForces();
			
			// draw the bodies
			for (var b:b2Body = World.GetBodyList(); b; b = b.GetNext())
			{
				if (b.GetUserData() == null)
				{
					continue;
				}
				if (b.GetUserData() is Image)
				{
					var im:Image = b.GetUserData() as Image;
					im.x = Constants.CenterX + (b.GetPosition().x * PixelsPerMeter);
					im.y = Constants.CenterY + (b.GetPosition().y * PixelsPerMeter);
					im.rotation = b.GetAngle();
				}
			}
		}

	}

}