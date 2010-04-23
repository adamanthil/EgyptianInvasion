package EgyptianInvasion
{
	import assets.*;
	
	import flash.display.*;
	import flash.events.*;
	
	public class Main extends Sprite {

		private var buildingPhase:Boolean;	// indicates if game is in the building phase
		
		private var placeNodeButton:Button;
		private var beginInvasionButton:Button;
		
		private var ui:UI; // Our compartmentalized UI
		
		private var NodeMan:NodeManager;
		public function Main () {
			// Start in building phase
			this.buildingPhase = true;
			NodeMan = new NodeManager(stage,this);
			this.addChild(NodeMan);
			
			var bg:MovieClip = new BackgroundTest();
			bg.scaleX = 0.7;
			bg.scaleY = 0.7;
			bg.x = 200;
			bg.y = 200;
			this.addChild(bg);
			
			ui = new UI(0,0,stage);
			this.addChild(ui);
			
			placeNodeButton = new Button(new assets.ToggleButton(), 50,100, "Add Node",stage);
			placeNodeButton.setMouseDown(Main.addNodeHandler);
			this.addChild(placeNodeButton);
			
			var pyramid:Pyramid = new Pyramid(new assets.pyramid2(), 300,250,stage);
			pyramid.scaleX = 0.7;
			//pyramid.scaleY = 0.7;
			this.addChild(pyramid);
			
			var changeNodeButton:Button = new Button(new assets.ToggleButton(), 50,50, "Change Node",stage);
			this.addChild(changeNodeButton);
			
			beginInvasionButton = new Button(new assets.ToggleButton(), 50, 150, "Begin Invasion", stage);
			beginInvasionButton.setMouseDown(Main.beginInvasionHandler);
			this.addChild(beginInvasionButton);
			
			stage.frameRate = 100;			
			
			
			
			var enemy:Enemy = new Enemy(NodeMan.getStartNode(),stage);
			this.addChild(enemy);
		}
		public function getPlaceNodeButton():Button
		{
			return placeNodeButton;
		}
		public function getNodeManager():NodeManager
		{
			return NodeMan;
		}
		
		

		// -- Button Event Handlers -------------------------
		
		// Event handler for adding a node on a mouseDown button click
		public static var addNodeHandler:Function = function (e:MouseEvent):void {
			var button:Button = Button(e.currentTarget);
			var buttonAsset:MovieClip = MovieClip(button.getButtonAsset());
			
			if (button.isDown()){
				button.setDown(false);
				Main(button.parent).getNodeManager().setToggledNode(null);
			}
			else {
				button.setDown(true);
				Main(button.parent).getNodeManager().addNode(new Node(e.stageX, e.stageY, Main(button.parent).stage));
			}
		}
		public static var beginInvasionHandler:Function = function (e:MouseEvent):void {
			var button:Button = Button(e.currentTarget);
			var buttonAsset:MovieClip = MovieClip(button.getButtonAsset());
			
			if (!button.isDown()){
				button.setDown(false);
				this.buildingPhase = false;
				
				trace(Main(button.parent).getNodeManager().getStartNode().pathExists(Main(button.parent).getNodeManager().getEndNode()));
			}
		}
		
	}
}