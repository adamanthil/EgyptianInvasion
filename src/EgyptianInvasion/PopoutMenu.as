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
		
		private var photo:BitmapAsset;
		
		private var fireDesc:fireExp;
		private var pitDesc:pitExp;
		private var quickDesc:sandExp;
		private var snakeDesc:snakeExp;
		
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
			fireDesc = new fireExp();
			fireDesc.scaleX = 0.4;
			fireDesc.scaleY = 0.4;
			fireDesc.x = 270;
			fireDesc.y = 120;
			fireDesc.visible = false;
			addChild(fireDesc);
			
			pitDesc = new pitExp();
			pitDesc.scaleX = 0.4;
			pitDesc.scaleY = 0.4;
			pitDesc.x = 270;
			pitDesc.y = 120;
			pitDesc.visible = false;
			addChild(pitDesc);
			
			quickDesc = new sandExp();
			quickDesc.scaleX = 0.4;
			quickDesc.scaleY = 0.4;
			quickDesc.x = 270;
			quickDesc.y = 120;
			quickDesc.visible = false;
			addChild(quickDesc);
			
			snakeDesc = new snakeExp();
			snakeDesc.scaleX = 0.4;
			snakeDesc.scaleY = 0.4;
			snakeDesc.x = 270;
			snakeDesc.y = 120;
			snakeDesc.visible = false;
			addChild(snakeDesc);
			
			// Add the other buttons
			connectNodeBtn = new Button(new assets.ToggleButton(), 100, 30, "Connection Node (A)", canvas, main);
			connectNodeBtn.visible = false;
			addChild(connectNodeBtn);
			
			snakeTrapBtn = new Button(new assets.ToggleButton(), 100,60, "Snake Room (S)", canvas, main);
			snakeTrapBtn.visible = false;
			snakeTrapBtn.setDescription(snakeDesc); 
			addChild(snakeTrapBtn);
			
			fireTrapBtn = new Button(new assets.ToggleButton(), 100,90, "Fire Room (F)", canvas, main);
			fireTrapBtn.visible = false;
			fireTrapBtn.setDescription(fireDesc);
			addChild(fireTrapBtn);
			
			pitTrapBtn = new Button(new assets.ToggleButton(), 100,120, "Pit Room (P)", canvas, main);
			pitTrapBtn.visible = false;
			pitTrapBtn.setDescription(pitDesc);
			addChild(pitTrapBtn);
			
			quickTrapBtn = new Button(new assets.ToggleButton(), 100,150, "Quicksand Room (Q)", canvas, main);
			quickTrapBtn.visible = false;
			quickTrapBtn.setDescription(quickDesc);
			addChild(quickTrapBtn);		
			
			addEventListener(MouseEvent.MOUSE_OVER, popoutChoicesHandler);
			addEventListener(MouseEvent.MOUSE_OUT, hideChoicesHandler);
			canvas.addEventListener(KeyboardEvent.KEY_DOWN, keysHandler);
			
			pitTrapBtn.addEventListener(MouseEvent.MOUSE_OVER, popoutDescription);
			pitTrapBtn.addEventListener(MouseEvent.MOUSE_OUT, hideDescription);
			pitTrapBtn.addEventListener(MouseEvent.MOUSE_DOWN, addPitNodeHandler);
			
			fireTrapBtn.addEventListener(MouseEvent.MOUSE_OVER, popoutDescription);
			fireTrapBtn.addEventListener(MouseEvent.MOUSE_OUT, hideDescription);
			fireTrapBtn.addEventListener(MouseEvent.MOUSE_DOWN, addFireNodeHandler);
			
			snakeTrapBtn.addEventListener(MouseEvent.MOUSE_OVER, popoutDescription);
			snakeTrapBtn.addEventListener(MouseEvent.MOUSE_OUT, hideDescription);
			snakeTrapBtn.addEventListener(MouseEvent.MOUSE_DOWN, addSnakeNodeHandler);
			
			quickTrapBtn.addEventListener(MouseEvent.MOUSE_OVER, popoutDescription);
			quickTrapBtn.addEventListener(MouseEvent.MOUSE_OUT, hideDescription);
			quickTrapBtn.addEventListener(MouseEvent.MOUSE_DOWN, addSandNodeHandler);
			
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
			if(main.getBuildPhase())
				setSubMenuVisibility(true);
		}
		public function hideChoicesHandler(e:MouseEvent):void {
			setSubMenuVisibility(false);
		}
		
		public function popoutDescription(e:MouseEvent):void {
			var button:Button = Button(e.currentTarget);
			button.getDescription().gotoAndStop("startFrame");
			button.getDescription().visible = true;
			button.getDescription().play();
		}
		public function hideDescription(e:MouseEvent):void {
			var button:Button = Button(e.currentTarget);
			button.getDescription().visible = false;
			button.getDescription().stop();
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
			if(main.getBuildPhase())
			{
				if(e.charCode == 97) // A for Add Connecting Node
				{
					main.getNodeManager().addNode(new Node(0, 0, canvas, main.getNodeManager()));
				}
				else if(e.charCode == 113 && main.getLevelManager().isSandRoomAvailable()) // Q is for QuickSand nodes
				{
					main.getNodeManager().addNode(new SandRoom(0, 0, canvas, main.getNodeManager()));
				}
				else if(e.charCode == 112 && main.getLevelManager().isPitRoomAvailable()) // P is for Pit nodes
				{
					main.getNodeManager().addNode(new PitRoom(0, 0, canvas, main.getNodeManager()));
				}
				else if(e.charCode == 102 && main.getLevelManager().isFireRoomAvailable()) // F is for Fire nodes
				{
					main.getNodeManager().addNode(new FireRoom(0, 0, canvas, main.getNodeManager()));
				}
				else if(e.charCode == 115 && main.getLevelManager().isSnakeRoomAvailable()) // S is for Snake nodes
				{
					main.getNodeManager().addNode(new SnakeRoom(0, 0, canvas, main.getNodeManager()));
				}
			}
		}
		
		
		
		// Shortcut to expand / collapse submenu rather than do all this explicitly each time
		public function setSubMenuVisibility(b:Boolean):void
		{
			photo.visible = b;
			if(main.getLevelManager().isPitRoomAvailable())
				pitTrapBtn.visible = b;
			if(main.getLevelManager().isSnakeRoomAvailable())
				snakeTrapBtn.visible = b;
			if(main.getLevelManager().isSandRoomAvailable())
				quickTrapBtn.visible = b;
			if(main.getLevelManager().isFireRoomAvailable())
				fireTrapBtn.visible = b;
			connectNodeBtn.visible = b;
		}
	}
}