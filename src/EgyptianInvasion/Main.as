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
		private var nodeMan:NodeManager;
		private var enemyMan:EnemyManager;
		private var levelMan:LevelManager;
		
		public function Main () {
			// Start in building phase
			this.buildingPhase = true;
			this.blendMode = BlendMode.LAYER;
			
			this.addChild(new FarBackground());			
			this.addChild(new NearBackground(stage));			
			
			/*placeNodeButton = new Button(new assets.ToggleButton(), 50,100, "Add Node",stage);
			placeNodeButton.setMouseDown(addNodeHandler);
			this.addChild(placeNodeButton);
			
			var changeNodeButton:Button = new Button(new assets.ToggleButton(), 50,50, "Change Node",stage);
			this.addChild(changeNodeButton);
			
			beginInvasionButton = new Button(new assets.ToggleButton(), 50, 150, "Begin Invasion", stage);
			beginInvasionButton.setMouseDown(beginInvasionHandler);
			this.addChild(beginInvasionButton);*/
			
			nodeMan = new NodeManager(this,69,365,200,300);
			this.addChild(nodeMan);
			
			this.setChildIndex(nodeMan,this.numChildren - 1);
			
			ui = new UI(50,0,stage,this);
			this.addChild(ui);
			
			ui.getPopout().getFireTrapBtn().visible = false;
			
			enemyMan = new EnemyManager(this);
			addChild(enemyMan);
			levelMan = new LevelManager(this,enemyMan,nodeMan,stage,ui);
			
			stage.frameRate = 100;			
			
		}
		public function getPlaceNodeButton():Button
		{
			return ui.getPopout().getPitTrapBtn();
		}
		public function getLevelManager():LevelManager
		{
			return this.levelMan;
		}
		public function getNodeManager():NodeManager
		{
			return nodeMan;
		}
		public function setNodeManager(nm:NodeManager):void
		{
			nodeMan = nm;
		}
		
		public function getEnemyManager():EnemyManager
		{
			return enemyMan;
		}
		
		public function setEnemyManager(em:EnemyManager):void
		{
			enemyMan = em;
		}
		
		public function getUI():UI
		{
			return ui;
		}
		
		public function setUI(ui:UI):void
		{
			this.ui = ui;
		}
		
		public function getBuildPhase():Boolean {return buildingPhase;}
		public function setBuildPhase(b:Boolean):void {buildingPhase = b;
		if(!b)
		{
			trace("drawing stopping...");
			nodeMan.stopDraw();
		}}
		
		// -- Button Event Handlers -------------------------
		
		// Event handler for adding a node on a mouseDown button click
		public var addNodeHandler:Function = function (e:MouseEvent):void {
			var button:Button = Button(e.currentTarget);
			var buttonAsset:MovieClip = MovieClip(button.getButtonAsset());
			
			if (button.isDown()){
				button.setDown(false);
				Main(button.parent).nodeMan.setToggledNode(null);
			}
			else {
				button.setDown(true);
				Main(button.parent).nodeMan.addNode(new Node(e.stageX, e.stageY, Main(button.parent).stage,(button.parent as Main).getNodeManager()));
			}
		}
			
		public var beginInvasionHandler:Function = function (e:MouseEvent):void {
			var button:Button = Button(e.currentTarget);
			var buttonAsset:MovieClip = MovieClip(button.getButtonAsset());
			
			if (!button.isDown()){
				// If there is a path from start to end, begin the invasion!
				if(Main(button.parent).nodeMan.getStartNode().pathExists(Main(button.parent).nodeMan.getEndNode())) {
					button.setDown(false);
					this.buildingPhase = false;
					
					Main(button.parent).enemyMan.beginInvasion();
				}
				
			}
		}
		
	}
}