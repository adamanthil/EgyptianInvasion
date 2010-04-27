package EgyptianInvasion 
{
	import assets.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import mx.core.BitmapAsset;
	
	public dynamic class PopoutMenu extends Sprite {
		
		private var rootBtn:Button;
		private var pitTrapBtn:Button;
		private var snakeTrapBtn:Button;
		private var quickTrapBtn:Button;
		private var fireTrapBtn:Button;
		private var connectNodeBtn:Button;
		
		private var canvas:Stage; // Pass this to keep things all on the same stage, rather than local to the class's stage
		private var main:Main; // Hold a ref to main so we can make ref to other managers
		
		// Adds a reference to a bitmap at compile-time
		[Embed(source="../assets/img/uiBG.jpg")]
		private var BGImage:Class;
		
		public function PopoutMenu (startX:Number, startY:Number, canvasRef:Stage, mainRef:Main) {
			
			canvas = canvasRef;
			main = mainRef;
			
			x = startX;
			y = startY;
			
			// Adds BitmapAsset from embedded class BGImage above, positioning / scaling needs standardizing
			// See commented out loading code to see how to load bitmaps at run time (undesired, image pops in if its large
			var photo:BitmapAsset = new BGImage();
			photo.scaleX = 0.5;
			photo.scaleY = 0.3;
			photo.x = 50;
			photo.y = 0;
			addChild(photo);
			
			// Instantiates loader, tells it to wait to add contents until INIT event, and begins loading contents from image file
			/*loader = new Loader();	
			loader.contentLoaderInfo.addEventListener(Event.INIT,initListener);
			loader.load(new URLRequest("../assets/img/uiBG.jpg"));*/
			
			rootBtn = new Button(new assets.ToggleButton(), 0,100, "Add Node...", canvas, main);
			addChild(rootBtn);
			pitTrapBtn = new Button(new assets.ToggleButton(), 100,30, "Pit Room", canvas, main);
			addChild(pitTrapBtn);
			snakeTrapBtn = new Button(new assets.ToggleButton(), 100,60, "Snake Room", canvas, main);
			addChild(snakeTrapBtn);
			quickTrapBtn = new Button(new assets.ToggleButton(), 100,90, "Quicksand Room", canvas, main);
			addChild(quickTrapBtn);
			fireTrapBtn = new Button(new assets.ToggleButton(), 100,120, "Fire Room", canvas, main);
			addChild(fireTrapBtn);
			connectNodeBtn = new Button(new assets.ToggleButton(), 100, 150, "Connection Node", canvas, main);
			addChild(connectNodeBtn);
			
			
		}
		/*		
		public var popoutChoicesHandler:Function = function (e:MouseEvent):void {
		return;
		}*/
	}
}