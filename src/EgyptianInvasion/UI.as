package EgyptianInvasion 
{
	import assets.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import mx.core.BitmapAsset;
	
	public class UI extends Sprite {
		private var removeNodeBtn:Button;
		private var placeNodeBtn:Button;
		private var beginInvasionBtn:Button;
		private var popout:PopoutMenu; // Reference our addnode submenu
		
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
			photo.scaleY = 0.6;
			photo.x = -50;
			photo.y = 0;
			addChild(photo);
			
			// Instantiates loader, tells it to wait to add contents until INIT event, and begins loading contents from image file
			/*loader = new Loader();	
			loader.contentLoaderInfo.addEventListener(Event.INIT,initListener);
			loader.load(new URLRequest("../assets/img/uiBG.jpg"));*/
			
			removeNodeBtn= new Button(new assets.ToggleButton(), 10,50, "Remove Node",canvas, main);
			addChild(removeNodeBtn); // TODO WB For some reason addChildAt makes things crash here
			
			placeNodeBtn = new Button(new assets.ToggleButton(), 10,100, "Add Node", canvas, main);
			placeNodeBtn.addEventListener(MouseEvent.MOUSE_DOWN, addNodeHandler);
			//addEventListener(MouseEvent.MOUSE_DOWN, addNodeAlt);
			addChild(placeNodeBtn);
			
			var beginInvasionBtn:Button = new Button(new assets.ToggleButton(), 10, 150, "Begin Invasion!", canvas, main);
			beginInvasionBtn.setMouseDown(beginInvasionHandler);
			addChild(beginInvasionBtn);
			
			popout = new PopoutMenu(10, 150, canvas, main);
			addChild(popout);
		}
		
		public function getPopout():PopoutMenu { return popout;}
			
		public function addNodeAlt(e:MouseEvent):void
		{
			if(e.target == placeNodeBtn)
			{
				// If button already down, untoggle it (?)
				if (placeNodeBtn.isDown()){
					placeNodeBtn.setDown(false);
					main.getNodeManager().setToggledNode(null);
					//Main(placeNodeBtn.parent).nodeMan.setToggledNode(null);
				}
					// Otherwise, add a new node
				else {
					placeNodeBtn.setDown(true);
					main.getNodeManager().addNode(new Node(0, 0, canvas));
				}
			}
		}
		
		// Event handler for adding a node on a mouseDown button click
		public function addNodeHandler(e:MouseEvent):void {
			var button:Button = Button(e.currentTarget);
			
			// If button already down, untoggle it (?)
			if (button.isDown()){
				button.setDown(false);
				main.getNodeManager().setToggledNode(null);
				//Main(button.parent).nodeMan.setToggledNode(null);
			}
			// Otherwise, add a new node
			else {
				button.setDown(true);
				main.getNodeManager().addNode(new Node(0, 0, button.getCanvas()));
			}
		}
		
		public function beginInvasionHandler(e:MouseEvent):void {
			var button:Button = Button(e.currentTarget);

			if (!button.isDown()){
				// If there is a path from start to end, begin the invasion!
				if(main.getNodeManager().getStartNode().pathExists(main.getNodeManager().getEndNode())) {
					button.setDown(false);
					main.setBuildPhase(false);
					
					main.getEnemyManager().beginInvasion();
				}
				
			}
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