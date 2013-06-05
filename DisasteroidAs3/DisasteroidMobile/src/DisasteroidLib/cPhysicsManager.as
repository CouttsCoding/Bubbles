package DisasteroidLib 
{
	/**
	 * ...
	 * @author James
	 */
	
	 
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.events.Event;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	public class cPhysicsManager
	{
		public var mWorld:b2World;
		public var mVelocityIterations:int = 10;
		public var mPositionIterations:int = 10;
		public var mTimeStep:Number = 1.0 / 30.0;
		public var mComponents:Dictionary;
		
		public function cPhysicsManager()
		{
			mComponents = new Dictionary();
			
			// Add event for main loop
			//addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
			
			// Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0.0,0.0);
			
			var bAllowSleep:Boolean = false;
			mWorld = new b2World(gravity, bAllowSleep);
		}
		
		public function Update():void
		{
			mWorld.Step(mTimeStep, mVelocityIterations, mPositionIterations);
			// do stuff with the bodies ?
		}
	
		public function CreateBody( bodyDef:b2BodyDef, shape:b2Shape, fixtureDef:b2FixtureDef ):cPhysicsComponent
		{
			//mComponents[name] = new cPhysicsComponent();
			//bodyDef.userData = mComponents[name];
			
			fixtureDef.shape = shape;
			return new cPhysicsComponent( mWorld.CreateBody(bodyDef), fixtureDef );
			
			//comp.Body.CreateFixture(fixtureDef);
			
			//return body;
		}
	}
	
}