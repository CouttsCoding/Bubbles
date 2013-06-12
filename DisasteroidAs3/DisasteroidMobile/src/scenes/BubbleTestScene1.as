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
	
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class BubbleTestScene1 extends Scene
	{
		// box2d variables
		public var World:b2World;
		public var BubbleBody:b2Body;
		public var VelocityIterations:int = 5;
		public var PositionIterations:int = 5;
		public var TimeStep:Number = 1.0 / 30.0;
		
		
		// graphics variables
		public var PixelsPerMeter:Number = 50;
		public var MetersPerPixel:Number = 1 / PixelsPerMeter;
		public var BubbleImage:Image;
		
		// accelerometer variables
		public var Accel:Accelerometer;
		public var AccelX:Number = 0.0;
		public var AccelY:Number = 0.0;
		public var AccelZ:Number = 0.0;
		
		/*! Constructor
		 */
		public function BubbleTestScene1() 
		{
			// add the per-frame update function
			addEventListener(EnterFrameEvent.ENTER_FRAME, UpdateFrame);
			
			// make the accelerometer
			Accel = new Accelerometer();
			Accel.setRequestedUpdateInterval( (1 / 30) * 1000);
			Accel.addEventListener(AccelerometerEvent.UPDATE, UpdateAccelerometer);
			
			
			// make the physics world
			var worldHalfWidth:Number = Constants.GameWidth * MetersPerPixel / 2;
			var worldHalfHeight:Number = Constants.GameHeight * MetersPerPixel / 2;
			var gravity:b2Vec2 = new b2Vec2(0.0, 0.0); // we handle gravity manually
			var bAllowBodiesToSleep:Boolean = true;
			// make the world
			World = new b2World(gravity, bAllowBodiesToSleep);
			
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
			
			
			// bubble size
			var bubbleWorldRadius:Number = 0.7;
			
			// set the bubble image
			BubbleImage = new Image(Assets.getTexture("Bubble1"));
			BubbleImage.x = Constants.CenterX;
			BubbleImage.y = Constants.CenterY;
			// set pivot values BEFORE adjusting width/height!!!
			BubbleImage.pivotX = BubbleImage.width / 2;
			BubbleImage.pivotY = BubbleImage.height / 2;
			BubbleImage.width = PixelsPerMeter * bubbleWorldRadius * 2;
			BubbleImage.height = PixelsPerMeter * bubbleWorldRadius * 2;
			
			addChild(BubbleImage);
			
			// set the bubble physics
			var bubbleShape:b2CircleShape = new b2CircleShape(bubbleWorldRadius);
			var bubbleBodyDef:b2BodyDef = new b2BodyDef();
			var bubbleFixtureDef:b2FixtureDef = new b2FixtureDef();
			bubbleBodyDef.type = b2Body.b2_dynamicBody;
			bubbleBodyDef.position.Set(0, 0);
			bubbleFixtureDef.shape = bubbleShape;
			bubbleFixtureDef.friction = 0.1;
			bubbleFixtureDef.density = 0.01;
			bubbleFixtureDef.restitution = 0.2;
			bubbleBodyDef.userData = BubbleImage;
			BubbleBody = World.CreateBody(bubbleBodyDef);
			BubbleBody.CreateFixture(bubbleFixtureDef);
		}
		
		/*! The per-frame update function
		 */
		public function UpdateFrame(e:EnterFrameEvent):void
		{
			
			var bubbleMass:Number = 0.01;
			var currentBubbleVelocity:b2Vec2 = BubbleBody.GetLinearVelocity();
			if ( currentBubbleVelocity.Length() < 1.0 )
			{
				var forceOnTheBubble:b2Vec2 = new b2Vec2(AccelX * bubbleMass, -AccelY * bubbleMass);
				BubbleBody.ApplyForce(forceOnTheBubble, BubbleBody.GetPosition());
			}
			
			World.Step(TimeStep, VelocityIterations, PositionIterations);
			World.ClearForces();
			
			// update the images
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
					//im.rotation = b.GetAngle();
				}
			}
		}
		
		/*! The accelerometer event listener function
		 */
		private function UpdateAccelerometer(e:AccelerometerEvent):void
		{
			AccelX = e.accelerationX;
			AccelY = e.accelerationY;
			AccelZ = e.accelerationZ;
		}
	}

}