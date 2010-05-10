package EgyptianInvasion 
{
	import assets.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	
	import mx.core.BitmapAsset;
	
	public class UI extends Sprite {
		private var removeNodeBtn:Button;
		private var beginInvasionBtn:Button;
		private var popout:PopoutMenu; // Reference our addnode submenu
		// Check on whether path from begin->end exists, display BeginInvasion appropraitely.
		private var pathExists:Boolean; 
		
		// Some credits text
		private var credits:TextField;
		private var format:TextFormat
		
		// Here only as example of how to do run-time image loading
		// private var loader:Loader;
		
		private var canvas:Stage; // Pass this to keep things all on the same stage, rather than local to the class's stage
		private var main:Main; // Hold a ref to main so we can make ref to other managers
		
		// Adds a reference to a bitmap at compile-time
		[Embed(source="../assets/img/uiBG.jpg")]
		private var BGImage:Class;
		
		public function UI (startX:Number, startY:Number, canvasRef:Stage, mainRef:Main) {
			
			canvas = canvasRef;
			main = mainRef;

			x = startX;
			y = startY;
			
			// Adds BitmapAsset from embedded class BGImage above, positioning / scaling needs standardizing
			// See commented out loading code to see how to load bitmaps at run time (undesired, image pops in if its large
			var photo:BitmapAsset = new BGImage();
			photo.scaleX = 0.6;
			photo.scaleY = 0.5;
			photo.x = -50;
			photo.y = 0;
			addChild(photo);
			
			// Instantiates loader, tells it to wait to add contents until INIT event, and begins loading contents from image file
			/*loader = new Loader();	
			loader.contentLoaderInfo.addEventListener(Event.INIT,initListener);
			loader.load(new URLRequest("../assets/img/uiBG.jpg"));*/
			
			removeNodeBtn = new Button(new assets.ToggleButton(), 10,50, "Delete Node (D)",canvas, main);
			removeNodeBtn.addEventListener(MouseEvent.MOUSE_DOWN, removeNodeMouseHandler);
			addChild(removeNodeBtn); // TODO WB For some reason addChildAt makes things crash here
			
			beginInvasionBtn = new Button(new assets.ToggleButton(), 10, 150, "Begin Invasion! (B)", canvas, main);
			canvas.addEventListener(KeyboardEvent.KEY_DOWN, keysHandler);
			beginInvasionBtn.addEventListener(MouseEvent.MOUSE_DOWN, beginInvasionMouseHandler);
			addChild(beginInvasionBtn);
			beginInvasionBtn.visible = false;
			
			popout = new PopoutMenu(10, 0, canvas, main);
			addChild(popout);
			
			
			format = new TextFormat();
			format.color = 0x663300; 
			format.size = 7; 
			
			credits = new TextField();
			credits.autoSize=TextFieldAutoSize.LEFT;
			credits.text = "A game by:\n -Andrew Bender\n -Will Buck\n -Jordan Moxon\n -and Li Qiao." +
				"\nMusic by:\n José the Bronx Rican \n at OverClocked Remix\n http://www.ocremix.org";
			credits.setTextFormat(format);
			credits.selectable = false;
			credits.x = -30;
			credits.y = 200;
			
			addChild(credits);
		}
		
		public function getPopout():PopoutMenu { return popout;}
		
		public function beginInvasionMouseHandler(e:MouseEvent):void {
			// If there is a path from start to end, begin the invasion!
			if(main.getNodeManager().getStartNode().pathExists(main.getNodeManager().getEndNode())) {
				beginInvasionBtn.visible = false;
				main.setBuildPhase(false);
				main.getEnemyManager().beginInvasion();
			}	
		}
		
		public function removeNodeMouseHandler(e:MouseEvent):void {
			main.getNodeManager().removeNode();
		}
		
		public function keysHandler(e:KeyboardEvent):void {
			if(e.charCode == 98) // B for BeginInvasion
			{	
				if(main.getNodeManager().getStartNode().pathExists(main.getNodeManager().getEndNode())) 
				{
					beginInvasionBtn.visible = false;
					main.setBuildPhase(false);			
					main.getEnemyManager().beginInvasion();
				}
			}
			else if(e.charCode == 100) // D for DeleteNode
			{
				main.getNodeManager().removeNode();
			}
	
		}
		
		public function setPathExists(b:Boolean):void
		{
			pathExists = b;
			if (pathExists && main.getBuildPhase())
				beginInvasionBtn.visible = true;
			else
				beginInvasionBtn.visible = false;
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