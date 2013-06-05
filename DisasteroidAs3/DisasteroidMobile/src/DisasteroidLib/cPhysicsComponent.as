package DisasteroidLib 
{
	/**
	 * ...
	 * @author James
	 */
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2FixtureDef;
	
	public class cPhysicsComponent 
	{
		public var Body:b2Body;
		//public var X:Number = 0.0;
		//public var Y:Number = 0.0;
		//public var Rotation:Number = 0.0;
		public var Health:Number = 100.0;
		public var ImpactCost:Number = 20.1;
		
		
		public function cPhysicsComponent( body:b2Body, fixtureDef:b2FixtureDef ) 
		{
			Body = body;
			Body.CreateFixture(fixtureDef);
		}
		//public function cPhysicsComponent( , x:Number, y:Number, r:Number = 0.0 )
		//{
		//	X = x;
		//	Y = y;
		//	Rotation = r;
		//}
	}

}