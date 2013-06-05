package scenes 
{
	/**
	 * ...
	 * @author James
	 */
	import Box2D.Dynamics.b2Body;
	import DisasteroidLib.cShipController;
	import DisasteroidLib.cShipControllerEvent;
	import DisasteroidLib.cPhysicsComponent;
	import DisasteroidLib.cPhysicsManager;
	import DisasteroidLib.cShipEntity;
	
	import starling.events.EnterFrameEvent;
	import starling.display.Image;
    import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	public class ControlledBodyTestScene  extends Scene
	{
		var mController:cShipController;
		var myImage:Image;
		var mPhysicsMan:cPhysicsManager;
		//var mPhysics:cPhysicsComponent;
		var mShip:cShipEntity;
		
		public function ControlledBodyTestScene() 
		{
			addEventListener(EnterFrameEvent.ENTER_FRAME, UpdateFrame );
			
			mPhysicsMan = new cPhysicsManager();
			
			
			
			var fixtureDef:b2FixtureDef;
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			fixtureDef = new b2FixtureDef();
			var circleShape:b2CircleShape = new b2CircleShape( 4.0 );
			
			fixtureDef.shape = circleShape;
			fixtureDef.density = 1.0;
			fixtureDef.friction = 0.5;
			fixtureDef.restitution = 0.2;
			bodyDef.position.Set( 0, 0 );
			
			mShip = new cShipEntity( mPhysicsMan.CreateBody(bodyDef, circleShape, fixtureDef) );
			
			
			
			mController = new cShipController();
			mController.addEventListener( cShipControllerEvent.EVENT, controllerUpdate );
			
			var atlas:TextureAtlas = Assets.getTextureAtlas();
			
            myImage = new Image(atlas.getTexture("flight_00"));
            myImage.x = Constants.CenterX;
            myImage.y = Constants.CenterY;
			myImage.pivotX = myImage.width / 2;
			myImage.pivotY = myImage.height / 2;
            addChild(myImage);
		}
		
		private function controllerUpdate(e:cShipControllerEvent):void
		{
			//myImage.rotation = mController.GetRotation_PosXUp();
			
			mShip.AccelerateForward(mController.AccelerometerX);
			mShip.AccelerateRight(mController.AccelerometerY);
		}
		
		private function UpdateFrame(e:EnterFrameEvent):void
		{
			mPhysicsMan.Update();
			mShip.Physics.Body.ApplyTorque(mController.AccelerometerZ);
			myImage.rotation = mShip.Physics.Body.GetAngle();
			//var pos:b2Vec2 = mShip.Physics.Body.GetPosition();
			//myImage.x = pos.x;
			//myImage.y = pos.y;
		}
	}

}