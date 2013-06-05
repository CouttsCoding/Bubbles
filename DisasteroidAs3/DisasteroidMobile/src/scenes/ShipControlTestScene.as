package scenes 
{
	/**
	 * ...
	 * @author James
	 */
	
	import DisasteroidLib.cShipController;
	import DisasteroidLib.cShipControllerEvent;
	import DisasteroidLib.Graphics.cTeeterTexture;
	import DisasteroidLib.Graphics.cAnimatedTexture;
	
	import utils.cSliderControl;
	
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.display.Image;
    import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class ShipControlTestScene  extends Scene
	{
		public var Slider:cSliderControl;
		public var Controller:cShipController;
		var TeeterShip:cTeeterTexture;
		var Flame:cAnimatedTexture;
		var FlameScale:Number = 2.0;
		
		public function ShipControlTestScene() 
		{
			addEventListener(EnterFrameEvent.ENTER_FRAME, UpdateFrame);
			addEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, OnRemovedFromStage);
			
			var buttonTexture:Texture = Assets.getTexture("ButtonSquare");
			Slider = new cSliderControl( buttonTexture, Constants.CenterX, buttonTexture.height, 50.0, false );
			addChild(Slider);
			
			
			Controller = new cShipController();
			Controller.addEventListener( cShipControllerEvent.EVENT, ControllerUpdate );
			
			var texture:Texture = Assets.getTexture("AtlasFighterShipTexture");
			var xml:XML = XML(Assets.create("AtlasFighterShipXml"));
			var shipAtlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			TeeterShip = new cTeeterTexture(shipAtlas.getTextures(), Constants.Pi_Div_6);
			TeeterShip.x = Constants.CenterX;
			TeeterShip.y = Constants.CenterY;
			TeeterShip.rotation = Constants.Pi_Div_2;
            addChild(TeeterShip);
			
			var flameTex:Texture = Assets.getTexture("AtlasFlameTexture");
			var flameXml:XML = XML(Assets.create("AtlasFlameXml"));
			var flameAtlas:TextureAtlas = new TextureAtlas(flameTex, flameXml);
			
			Flame = new cAnimatedTexture(flameAtlas.getTextures());
			Flame.bLooping = true;
			Flame.bPlaying = true;
			Flame.x = Constants.CenterX - TeeterShip.width;
			Flame.y = Constants.CenterY;
			Flame.rotation = -Constants.Pi_Div_2;
			var sliderValue:Number = 0.5;
			Flame.scaleX = FlameScale * sliderValue;
			Flame.scaleY = FlameScale * sliderValue;
			addChild(Flame);
			
		}
		
		private function ControllerUpdate(e:cShipControllerEvent):void
		{
			var shipAngle:Number = Math.atan2(Controller.AccelerometerY, Math.abs(Controller.AccelerometerZ));
			TeeterShip.SetTilt(shipAngle);
		}
		
		private function UpdateFrame(e:EnterFrameEvent):void
		{
			Flame.StepFrame();
			var sliderValue:Number = ( Slider.CurrentValue + 1.0 ) * 0.5;
			Flame.scaleX = FlameScale * sliderValue;
			Flame.scaleY = FlameScale * sliderValue;
			
			Flame.x = TeeterShip.x - ( TeeterShip.width ) - ( Flame.width );
			Flame.y = TeeterShip.y + ( TeeterShip.height * 0.5 ) + ( Flame.height * 0.5 );
		}
		
		private function OnAddedToStage(event:Event):void
        {
            
        }
        
        private function OnRemovedFromStage(event:Event):void
        {
            
        }
        
        public override function dispose():void
        {
            removeEventListener(Event.REMOVED_FROM_STAGE, OnRemovedFromStage);
            removeEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);
            super.dispose();
        }
	}

}