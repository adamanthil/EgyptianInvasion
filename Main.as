package
{
	import flash.display.*;
	import flash.events.*;
	
	import mx.*;x
	
	public class Scene extends Sprite {
		public var selectedNode:Node;
		public var tombNode:Node; //EndNode
		public var enterNode:Node; //startnode
		public var allNodes:Array;
		public var uiChild:UIClass;
		public var enemyList:Array;
		public var mapfile:mapSubClass;
		public var submap:mapSubClass;
		public var building:Boolean;
		
		public var ToggledNode:Node;
		
		public function Scene () {
			stage.frameRate = 100;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUPListener);
			
			var baseNode = new Node();
			allNodes.add(baseNode);
			selectedNode = baseNode;
			enterNode = baseNode;
			
			var finalNode = new Node();
			tombNode = finalNode;
			
			//parent.addChild(a1);
			//parent.setChildIndex(this,0);
		}
		
		private function mouseDownListener (e:MouseEvent):void {
			if(e.buttonDown && e.stageX != x && e.stageX != y)
			{
				
				graphics.clear();
				
				graphics.lineStyle(3, 0xFF0000);
				prevx = currx;
				prevy = curry;
				currx = e.stageX;
				curry = e.stageY;
				graphics.moveTo(currx,curry);
				graphics.lineTo(prevx,prevy);
			}
			
		}
	}
}