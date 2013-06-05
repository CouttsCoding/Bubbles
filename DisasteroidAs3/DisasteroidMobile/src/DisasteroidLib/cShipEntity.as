package DisasteroidLib 
{
	/**
	 * ...
	 * @author James
	 */
	
	import Box2D.Common.Math.*;
	
	public class cShipEntity 
	{
		public var MaxLinearVelocity:Number = 8.0;
		public var MaxAngularVelocity:Number = 5.0;
		public var LinearPower:Number = 6.0;
		public var AngularPower:Number = 4.0;
		
		public var Physics:cPhysicsComponent;
		
		public function cShipEntity( physics:cPhysicsComponent ) 
		{
			Physics = physics;
		}
		
		public function AccelerateForward( accelFactor:Number = 1.0 ):void
		{
			var linearVel:b2Vec2 = Physics.Body.GetLinearVelocity();
			var currentVel:Number = linearVel.Normalize();
			var forceFactor:Number = MaxLinearVelocity - currentVel;
			if ( forceFactor > 0.0 )
			{
				var localForceVec:b2Vec2 = new b2Vec2( 0.0, forceFactor * LinearPower * accelFactor );
				Physics.Body.ApplyForce( Physics.Body.GetWorldVector( localForceVec ), Physics.Body.GetWorldCenter() );
			}
		}
		
		public function AccelerateBack( accelFactor:Number = 1.0 ):void
		{
			var linearVel:b2Vec2 = Physics.Body.GetLinearVelocity();
			var currentVel:Number = linearVel.Normalize();
			var forceFactor:Number = MaxLinearVelocity - currentVel;
			if ( forceFactor > 0.0 )
			{
				var localForceVec:b2Vec2 = new b2Vec2( 0.0, -forceFactor * LinearPower * accelFactor );
				Physics.Body.ApplyForce( Physics.Body.GetWorldVector( localForceVec ), Physics.Body.GetWorldCenter() );
			}
		}
		
		public function AccelerateRight( accelFactor:Number = 1.0 ):void
		{
			var linearVel:b2Vec2 = Physics.Body.GetLinearVelocity();
			var currentVel:Number = linearVel.Normalize();
			var forceFactor:Number = MaxLinearVelocity - currentVel;
			if ( forceFactor > 0.0 )
			{
				var localForceVec:b2Vec2 = new b2Vec2( forceFactor * LinearPower * accelFactor, 0.0 );
				Physics.Body.ApplyForce( Physics.Body.GetWorldVector( localForceVec ), Physics.Body.GetWorldCenter() );
			}
		}
		
		public function AccelerateLeft( accelFactor:Number = 1.0 ):void
		{
			var linearVel:b2Vec2 = Physics.Body.GetLinearVelocity();
			var currentVel:Number = linearVel.Normalize();
			var forceFactor:Number = MaxLinearVelocity - currentVel;
			if ( forceFactor > 0.0 )
			{
				var localForceVec:b2Vec2 = new b2Vec2( -forceFactor * LinearPower * accelFactor, 0.0 );
				Physics.Body.ApplyForce( Physics.Body.GetWorldVector( localForceVec ), Physics.Body.GetWorldCenter() );
			}
		}
		
		public function TurnLeft( turnFactor:Number = 1.0 ):void
		{
			var turn:Number = MaxAngularVelocity;
			turn += Physics.Body.GetAngularVelocity();
			if ( turn > 0.0 )
			{
				var torque:Number = -AngularPower * turnFactor * turn;
				Physics.Body.ApplyTorque( torque );
			}
		}
		
		public function TurnRight( turnFactor:Number = 1.0 ):void
		{
			var turn:Number = MaxAngularVelocity;
			turn -= Physics.Body.GetAngularVelocity();
			if ( turn > 0.0 )
			{
				var torque:Number = AngularPower * turnFactor * turn;
				Physics.Body.ApplyTorque( torque );
			}
		}
	}

}