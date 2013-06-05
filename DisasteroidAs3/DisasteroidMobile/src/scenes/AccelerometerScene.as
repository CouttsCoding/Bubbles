package scenes 
{
	/**
	 * ...
	 * @author James
	 */
	import DisasteroidLib.cShipController;
	import DisasteroidLib.cShipControllerEvent;
	import starling.display.Image;
    import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class AccelerometerScene extends Scene
	{
		var mController:cShipController;
		var myImage:Image;
		
		public function AccelerometerScene() 
		{
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
			myImage.rotation = mController.GetRotation_PosXUp();
		}

	}

}