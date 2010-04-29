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
		private var sampleDesc:BitmapAsset;
		
		public function PopoutMenu (startX:Number, startY:Number, canvasRef:Stage, mainRef:Main) {
			
			canvas = canvasRef;
			main = mainRef;
			
			x = startX;
			y = startY;
			
			// Root Button is what everything pop out of
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

			pitTrapBtn = new Button(new assets.ToggleButton(), 100,30, "Pit Room", canvas, main);
			pitTrapBtn.visible = false;
			addChild(pitTrapBtn);
			
			snakeTrapBtn = new Button(new assets.ToggleButton(), 100,60, "Snake Room", canvas, main);
			snakeTrapBtn.visible = false;
			addChild(snakeTrapBtn);
			
			quickTrapBtn = new Button(new assets.ToggleButton(), 100,90, "Quicksand Room", canvas, main);
			quickTrapBtn.visible = false;
			addChild(quickTrapBtn);
			
			fireTrapBtn = new Button(new assets.ToggleButton(), 100,120, "Fire Room", canvas, main);
			fireTrapBtn.visible = false;
			addChild(fireTrapBtn);
			
			connectNodeBtn = new Button(new assets.ToggleButton(), 100, 150, "Connection Node", canvas, main);
			connectNodeBtn.visible = false;
			addChild(connectNodeBtn);
			
			// Add the description objects here
			sampleDesc = new BGImage();
			sampleDesc.scaleX = 1.2;
			sampleDesc.scaleY = 0.5;
			sampleDesc.x = 150;
			sampleDesc.y = -120;
			sampleDesc.visible = false;
			addChild(sampleDesc);
			
			addEventListener(MouseEvent.MOUSE_OVER, popoutChoicesHandler);
			addEventListener(MouseEvent.MOUSE_OUT, hideChoicesHandler);
			
			pitTrapBtn.addEventListener(MouseEvent.MOUSE_OVER, popoutDescription);
			pitTrapBtn.addEventListener(MouseEvent.MOUSE_OUT, hideDescription);
			pitTrapBtn.addEventListener(MouseEvent.MOUSE_DOWN, addNodeHandler);
		}
		
		// Accessor Methods
		public function getRootBtn():Button {return rootBtn;}
		public function getPitTrapBtn():Button {return pitTrapBtn;}
		public function getSnakeTrapBtn():Button {return snakeTrapBtn;}
		public function getQuickTrapBtn():Button {return quickTrapBtn;}
		public function getFireTrapBtn():Button {return fireTrapBtn;}
		public function getConnectNodeBtn():Button {return connectNodeBtn;}
		
		public function popoutChoicesHandler(e:MouseEvent):void {
			setSubMenuVisibility(true);
		}
		public function hideChoicesHandler(e:MouseEvent):void {
			setSubMenuVisibility(false);
		}
		
		public function popoutDescription(e:MouseEvent):void {
			sampleDesc.visible = true;
		}
		public function hideDescription(e:MouseEvent):void {
			sampleDesc.visible = false;
		}
		public function addNodeHandler(e:MouseEvent):void {
			main.getNodeManager().addNode(new Node(0, 0, canvas));
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
		// Shouldn't need mutator methods for any reason I can think of
	}
}