package DisasteroidLib 
{
	/**
	 * ...
	 * @author James
	 */
	
	import flash.events.AccelerometerEvent;
	import flash.sensors.Accelerometer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/*! A controller for a ship
	 * 
	 */
	public class cShipController extends EventDispatcher
	{
		/*! The data used by the controller
		 */
		public var AccelerometerX:Number = 0.0;
		public var AccelerometerY:Number = 0.0;
		public var AccelerometerZ:Number = 0.0;
		
		/*! We are currently accelerating (linearly)
		 */
		public var bLinearAcc:Boolean = false;
		/*! We are currently turning
		 */
		public var bAngularAcc:Boolean = false;
		/*! Our current acceleration value
		 */
		public var LinearAcceleration:Number = 0.0;
		/*! Our current turning value
		 */
		public var AngularAcceleration:Number = 0.0;
		
		/*! The accelerometer
		 */
		var mAccelerometer:Accelerometer;
		
		public function cShipController() 
		{
			mAccelerometer = new Accelerometer();
			mAccelerometer.setRequestedUpdateInterval( (1 / 30) * 1000);
			mAccelerometer.addEventListener(AccelerometerEvent.UPDATE, accelerometerUpdate);
		}
		
		/*! Changes the update interval for the accelerometer
		 */
		public function SetAccelerometerInterval( interval:Number ):void
		{
			mAccelerometer.setRequestedUpdateInterval( interval );
		}
		
		public function GetRotation_PosXUp():Number
		{
			return Math.atan2( AccelerometerZ, -AccelerometerY );
		}
		
		/*! The accelerometer event listener function
		 */
		private function accelerometerUpdate(e:AccelerometerEvent):void
		{
			AccelerometerX = e.accelerationX;
			AccelerometerY = e.accelerationY;
			AccelerometerZ = e.accelerationZ;
			
			this.dispatchEvent(new cShipControllerEvent(cShipControllerEvent.EVENT, cShipControllerEvent.COM_TURN ) );
		}
		
	}

}