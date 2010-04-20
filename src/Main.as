package
{
	import flash.display.*;
	import flash.events.*;
	
	import mx.core.ButtonAsset;
	
	//	import mx.*;
	
	public class Main extends Sprite {
		public var selectedNode:Node;
		public var tombNode:Node; //EndNode
		public var enterNode:Node; //startnode
		public var allNodes:Array;
		//		public var uiChild:UIClass;
		public var enemyList:Array;
		//		public var mapfile:mapSubClass;
		//	public var submap:mapSubClass;
		public var building:Boolean;
		
		public var ToggledNode:Node;
		public var btn:ToggleBtn;
		
		public var prevx:Number;
		public var prevy:Number;
		public var currx:Number;
		public var curry:Number;
		public var overallInt:EI;
		private var cantset;
		
		public function Main () {
			overallInt = new EI(this,stage);
			allNodes = new Array();
			var bg:MovieClip = new BackgroundTest();
			bg.scaleX = 0.7;
			bg.scaleY = 0.7;
			bg.x = 200;
			bg.y = 200;
			btn = new ToggleBtn(100,100, stage);
			this.addChild(bg);
			this.addChild(btn);
			stage.frameRate = 100;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,aListener);
			
			var baseNode = new Node(70,70,stage);
			allNodes.push(baseNode);
			selectedNode = baseNode;
			baseNode.setSelected(true);
			enterNode = baseNode;
			baseNode.setPlaced(true);
			
			var finalNode = new Node(300,200,stage);
			tombNode = finalNode;
			allNodes.push(tombNode);
			this.addChild(baseNode);
			this.addChild(finalNode);
			tombNode.setPlaced(true);
			//parent.addChild(a1);
			//parent.setChildIndex(this,0);
		}
		public function addNode(toggle:Node)
		{
			ToggledNode = toggle;
			ToggledNode.addSibling(selectedNode);
			selectedNode.addSibling(ToggledNode);
			ToggledNode.setPlaced(false);
			this.addChild(ToggledNode);
			cantset = true;
		}
		private function mouseDownListener (e:MouseEvent):void {
			if(ToggledNode == null || cantset)
			{
				var count:Number;
				count = 0;
				while(count < allNodes.length)
				{
					if(Math.sqrt(Math.pow((e.stageX -(allNodes[count] as Node).x),2) +
						Math.pow((e.stageY -(allNodes[count] as Node).y),2)) < 10)
					{
						selectedNode.setSelected(false);
						selectedNode = allNodes[count];
						selectedNode.setSelected(true);
					}
					count++;
				}
			}
			else
			{
				var potentialNode:Node;
				var count:Number;
				count = 0;
				while(count < allNodes.length)
				{
					if(Math.sqrt(Math.pow((e.stageX -(allNodes[count] as Node).x),2) +
						Math.pow((e.stageY -(allNodes[count] as Node).y),2)) < 10)
						potentialNode = allNodes[count];
					count++;
				}
				if(potentialNode == null)
				{
					ToggledNode.setPlaced(true);
					allNodes.push(ToggledNode);
				}
				else
				{
					potentialNode.addSibling(selectedNode);
					selectedNode.addSibling(potentialNode);
					this.removeChild(ToggledNode);
					selectedNode.removeSibling(ToggledNode);
				}
				ToggledNode = null;
				btn.down = false;
				btn.btn.gotoAndStop("mouseUp");
			}
			
		}
		
		private function aListener(e:KeyboardEvent)
		{
			if(e.charCode == 97)
			{
				ToggledNode = new Node(0,0,stage);
				ToggledNode.addSibling(selectedNode);
				selectedNode.addSibling(ToggledNode);
				ToggledNode.setPlaced(false);
				this.addChild(ToggledNode);
			}
		}
		
		private function mouseUpListener (e:MouseEvent):void {
			cantset = false;
		}
		
	}
}