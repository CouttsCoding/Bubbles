package DisasteroidLib 
{
	/**
	 * ...
	 * @author James
	 */
	/*! A custom event for the ship controller
	 */
	import flash.events.Event;
	
	public class cShipControllerEvent extends Event
	{
		/*! Ship Commands
		 */
		public static const COM_TURN:String = "Turn";
		public static const COM_ACCELERATE:String = "Accelerate";
		public static const COM_WEAPONS:String = "Weapons";
		/*! Ship Sub-Commands
		 */
		public static const SUB_NONE:String = "None";
		//public static const SUB_TURNING_LEFT:String = "TurningLeft";
		//public static const SUB_TURNING_RIGHT:String = "TurningRight";
		//public static const SUB_TURNING_NONE:String = "TurningNone";
		//public static const SUB_ACCELERATE_FORWARD:String = "AccelerateForward";
		//public static const SUB_ACCELERATE_BACK:String = "AccelerateBack";
		
		/*! Ship Controller Event Type
		 */
		public static const EVENT:String = "ShipContollerEvent";
		
		/*! The specific command issued
		 */
		public var Command:String;
		public var SubCommand:String = SUB_NONE;
		
		/*! Modifier values
		 */
		public var ModifierA:Number = 0.0;
		public var ModifierB:Number = 0.0;
		public var ModifierC:Number = 0.0;
		public var ModifierD:Number = 0.0;
		
		public function cShipControllerEvent( type:String, command:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
			Command = command;
		}
		
		/*! Required for full use of a custom event
		 */
		override public function clone():Event
		{
			return new cShipControllerEvent( type, Command, bubbles, cancelable );
		}
	}

}