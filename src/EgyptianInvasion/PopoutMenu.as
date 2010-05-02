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
		
		[Embed(source="../assets/img/pitDesc.jpg")]
		private var PitDescImage:Class;
		
		private var photo:BitmapAsset;
		private var sampleDesc:BitmapAsset;
		private var samplePitDesc:BitmapAsset;
		
		public function PopoutMenu (startX:Number, startY:Number, canvasRef:Stage, mainRef:Main) {
			
			canvas = canvasRef;
			main = mainRef;
			
			x = startX;
			y = startY;
			
			// Root Button is what everything will pop out of, add it first
			rootBtn = new Button(new assets.ToggleButton(), 0,100, "Add Node...", canvas, main);
			addChild(rootBtn);
			
			// Use scaled down UIbg for popout bg
			photo = new BGImage();
			photo.scaleX = 0.5;
			photo.scaleY = 0.3;
			photo.x = 50;
			photo.y = 0;
			photo.visible = false;
			addChild(photo);
			
			// Add the description objects here
			sampleDesc = new BGImage();
			sampleDesc.scaleX = 1.2;
			sampleDesc.scaleY = 0.5;
			sampleDesc.x = 150;
			sampleDesc.y = -120;
			sampleDesc.visible = false;
			addChild(sampleDesc);
			
			samplePitDesc = new PitDescImage();
			samplePitDesc.scaleX = 0.5;
			samplePitDesc.scaleY = 0.5;
			samplePitDesc.x = 150;
			samplePitDesc.y = -120;
			samplePitDesc.visible = false;
			addChild(samplePitDesc);

			// Add the other buttons
			pitTrapBtn = new Button(new assets.ToggleButton(), 100,30, "Pit Room (Q)", canvas, main);
			pitTrapBtn.visible = false;
			pitTrapBtn.setDescription(samplePitDesc);
			addChild(pitTrapBtn);
			
			snakeTrapBtn = new Button(new assets.ToggleButton(), 100,60, "Snake Room (W)", canvas, main);
			snakeTrapBtn.visible = false;
			addChild(snakeTrapBtn);
			
			quickTrapBtn = new Button(new assets.ToggleButton(), 100,90, "Quicksand Room (E)", canvas, main);
			quickTrapBtn.visible = false;
			addChild(quickTrapBtn);
			
			fireTrapBtn = new Button(new assets.ToggleButton(), 100,120, "Fire Room (R)", canvas, main);
			fireTrapBtn.visible = false;
			addChild(fireTrapBtn);
			
			connectNodeBtn = new Button(new assets.ToggleButton(), 100, 150, "Connection Node (A)", canvas, main);
			connectNodeBtn.visible = false;
			connectNodeBtn.setDescription(sampleDesc);
			addChild(connectNodeBtn);
			

			
			addEventListener(MouseEvent.MOUSE_OVER, popoutChoicesHandler);
			addEventListener(MouseEvent.MOUSE_OUT, hideChoicesHandler);
			canvas.addEventListener(KeyboardEvent.KEY_DOWN, keysHandler);
			
			pitTrapBtn.addEventListener(MouseEvent.MOUSE_OVER, popoutDescription);
			pitTrapBtn.addEventListener(MouseEvent.MOUSE_OUT, hideDescription);
			pitTrapBtn.addEventListener(MouseEvent.MOUSE_DOWN, addPitNodeHandler);
			
			fireTrapBtn.addEventListener(MouseEvent.MOUSE_DOWN, addFireNodeHandler);
			
			snakeTrapBtn.addEventListener(MouseEvent.MOUSE_DOWN, addSnakeNodeHandler);
			
			quickTrapBtn.addEventListener(MouseEvent.MOUSE_DOWN, addSandNodeHandler);
			
			connectNodeBtn.addEventListener(MouseEvent.MOUSE_OVER, popoutDescription);
			connectNodeBtn.addEventListener(MouseEvent.MOUSE_OUT, hideDescription);
			connectNodeBtn.addEventListener(MouseEvent.MOUSE_DOWN, addConnectNodeHandler);
		}
		
		// Accessor Methods
		public function getRootBtn():Button {return rootBtn;}
		public function getPitTrapBtn():Button {return pitTrapBtn;}
		public function getSnakeTrapBtn():Button {return snakeTrapBtn;}
		public function getQuickTrapBtn():Button {return quickTrapBtn;}
		public function getFireTrapBtn():Button {return fireTrapBtn;}
		public function getConnectNodeBtn():Button {return connectNodeBtn;}
		// Shouldn't need mutator methods for any reason I can think of
		
		public function popoutChoicesHandler(e:MouseEvent):void {
			setSubMenuVisibility(true);
		}
		public function hideChoicesHandler(e:MouseEvent):void {
			setSubMenuVisibility(false);
		}
		
		public function popoutDescription(e:MouseEvent):void {
			var button:Button = Button(e.currentTarget);
			button.getDescription().visible = true;
		}
		public function hideDescription(e:MouseEvent):void {
			var button:Button = Button(e.currentTarget);
			button.getDescription().visible = false;
		}
		
		public function addFireNodeHandler(e:MouseEvent):void {
			main.getNodeManager().addNode(new FireRoom(0, 0, canvas, main.getNodeManager()));
		}

		public function addPitNodeHandler(e:MouseEvent):void {
			main.getNodeManager().addNode(new PitRoom(0, 0, canvas, main.getNodeManager()));
		}
		
		public function addSnakeNodeHandler(e:MouseEvent):void {
			main.getNodeManager().addNode(new SnakeRoom(0, 0, canvas, main.getNodeManager()));
		}
		
		public function addSandNodeHandler(e:MouseEvent):void {
			main.getNodeManager().addNode(new SandRoom(0, 0, canvas, main.getNodeManager()));
		}
		
		public function addConnectNodeHandler(e:MouseEvent):void {
			main.getNodeManager().addNode(new Node(0, 0, canvas, main.getNodeManager()));
		}
		
		public function keysHandler(e:KeyboardEvent):void {
			if(e.charCode == 97) // A for Add Connecting Node
			{
				main.getNodeManager().addNode(new Node(0, 0, canvas, main.getNodeManager()));
			}
			else if(e.charCode == 101) // E is for QuickSand nodes
			{
				main.getNodeManager().addNode(new SandRoom(0, 0, canvas, main.getNodeManager()));
			}
			else if(e.charCode == 113) // Q is for Pit nodes
			{
				main.getNodeManager().addNode(new PitRoom(0, 0, canvas, main.getNodeManager()));
			}
			else if(e.charCode == 114) // R is for Fire nodes
			{
				main.getNodeManager().addNode(new FireRoom(0, 0, canvas, main.getNodeManager()));
			}
			else if(e.charCode == 119) // W is for Snake nodes
			{
				main.getNodeManager().addNode(new SnakeRoom(0, 0, canvas, main.getNodeManager()));
			}
		}
		
		
		
		// Shortcut to expand / collapse submenu rather than do all this explicitly each time
		public function setSubMenuVisibility(b:Boolean):void
		{
			photo.visible = b;
			pitTrapBtn.visible = b;
			snakeTrapBtn.visible = b;
			quickTrapBtn.visible = b;
			fireTrapBtn.visible = b;
			connectNodeBtn.visible = b;
		}
	}
}