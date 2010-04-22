package EgyptianInvasion 
{
	import assets.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import mx.core.BitmapAsset;
	
	public class UI extends Sprite {
		private var nodeButtons:Array;
		
		private var loader:Loader;
		
		private var canvas:Stage;
		
		// Adds a reference to a bitmap at compile-time
		[Embed(source="../assets/img/uiBG.jpg")]
		private var BGImage:Class;
		
		public function UI (startX:Number, startY:Number, canvas:Stage) {
			
			this.canvas = canvas;
			x = startX;
			y = startY;
			nodeButtons = new Array(); // Need to initialize arrays to use them
			
			// Adds BitmapAsset from embedded class BGImage above, positioning / scaling needs standardizing
			// See commented out loading code to see how to load bitmaps at run time (undesired, image pops in if its large
			var photo:BitmapAsset = new BGImage();
			photo.scaleX = 0.6;
			photo.scaleY = 0.6;
			photo.x = -50;
			photo.y = 0;
			addChild(photo);
			
			// Instantiates loader, tells it to wait to add contents until INIT event, and begins loading contents from image file
			/*loader = new Loader();	
			loader.contentLoaderInfo.addEventListener(Event.INIT,initListener);
			loader.load(new URLRequest("../assets/img/uiBG.jpg"));*/
			
			var removeNodeButton:Button = new Button(new assets.ToggleButton(), 0,50, "Remove Node",stage);
			addChild(removeNodeButton); // TODO WB For some reason addChildAt makes things crash here
			nodeButtons.push(removeNodeButton);
			
			var placeNodeButton:Button = new Button(new assets.ToggleButton(), 0,100, "Add Node", stage);
			addChild(placeNodeButton);
			nodeButtons.push(placeNodeButton);
			
			var beginInvasionButton:Button = new Button(new assets.ToggleButton(), 0, 150, "Begin Invasion!", stage);
			addChild(beginInvasionButton);
			nodeButtons.push(beginInvasionButton);
		}
		
		/*private function mouseDownListener (e:MouseEvent):void {
			
			
		}
		
		private function aListener(e:KeyboardEvent):void
		{

		}
		
		private function mouseUpListener (e:MouseEvent):void {

		}*/
	
		// Event listener that adds bg image to UI once it is done loading
		/*private function initListener (e:Event):void {
			// TODO WB scaling and positioning needs to be standardized better, for now this is reasonably unsloppy looking
			// but very randomly hard-coded
			loader.content.scaleX = 0.6;
			loader.content.scaleY = 0.6;
			loader.content.x = -50;
			loader.content.y = 0;
			addChildAt(loader.content,0); // Have to add at 0 to get it behind the buttons
		}*/
		
	}

}