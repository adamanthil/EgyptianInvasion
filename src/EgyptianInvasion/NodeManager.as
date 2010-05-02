package EgyptianInvasion
{
	import assets.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	/*
	The NodeManager class is a manager for a set of nodes on a scene. this is primarily created
	to free space in main to avoid the code becoming a hideous monster.
	*/
	public class NodeManager extends Sprite
	{
		private var canvas:Stage; // the stage class that is propogated throughout our code
		private var sup:Main; //super-class Main is stored here, so it can reference other components in the game
		private var tombNode:Node; // End Node
		private var enterNode:Node; // Start Node
		private var allNodes:Array; // an array with all of the existing nodes in the web.
		
		private var selectedNode:Node;	// existing node that is "selected"
		private var toggledNode:Node;	// new node being placed
		private var cantSet:Boolean; //a boolean value, true when the player is being prevented from placing a node.
		private var time:Timer;
		private var nodePath:NodePaths;
		private var Pyram:Pyramid;
		
		public function NodeManager(refup:Main, startx:Number, starty:Number,endx:Number,endy:Number)
		{
			nodePath = new NodePaths(this);
			this.addChild(nodePath);
			this.blendMode = BlendMode.LAYER;
			allNodes = new Array();
			canvas = refup.stage;
			sup = refup;
			canvas.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			canvas.addEventListener(KeyboardEvent.KEY_DOWN,keyListener);
			canvas.addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
			canvas.addEventListener(MouseEvent.MOUSE_MOVE, mouseMovListener);
			
			var pyramid:Pyramid = new Pyramid(new assets.pyramid2(), 300,250,canvas, false);
			pyramid.scaleX = 0.7;
			this.addChildAt(pyramid,0);
			Pyram = pyramid;
			var baseNode:Node = new StartRoom(startx,starty,canvas, this);
			allNodes.push(baseNode);
			selectedNode = baseNode;
			baseNode.setSelected(true);
			enterNode = baseNode;
			baseNode.setPlaced(true);
			var finalNode:Node = new Node(endx,endy,canvas,this);
			tombNode = finalNode;
			allNodes.push(tombNode);
			this.addChild(baseNode);
			this.addChild(finalNode);
			tombNode.setPlaced(true);
			time = new Timer(5);
			time.start();

			time.addEventListener(TimerEvent.TIMER,TimeListener);
		}
		public function setStartNodePosition(x:Number, y:Number):void
		{
			enterNode.x = x;
			enterNode.y = y;
		}
		public function setEndNodePosition(x:Number, y:Number):void
		{
			tombNode.x = x;
			tombNode.y = y;
		}
		public function getCanvas ():Stage
		{
			return canvas;
		}
		public function getNodes():Array
		{
			return allNodes;
		}
		private function TimeListener(e:TimerEvent):void
		{
			nodePath.update();
		}
		public function setToggledNode(set:Node): void
		{
			toggledNode = set;
		}
		//returns the enterance node for the node web.
		public function getStartNode(): Node
		{
			return enterNode;
		}
		
		//returns the tomb-end node for the node web.
		public function getEndNode():Node {
			return this.tombNode;
		}
		//sets the toggledNode for the node manager. this 
		// has the direct upshot of making this node the
		// node that the player is in the process of placing.
		public function addNode(toggle:Node):void
		{
			if(this.selectedNode.connectable() && toggledNode ==null)
			{
				toggledNode = toggle;
				toggledNode.addSibling(selectedNode);
				selectedNode.addSibling(toggledNode);
				toggledNode.setPlaced(false);
				this.addChild(toggledNode);
				cantSet = true;
			}
		}
		public function addTrigger(toggle:Node):void
		{
			if(toggledNode == null)
			{
				toggledNode = toggle;
				toggledNode.addSibling(selectedNode);
				toggledNode.setPlaced(false);
				toggledNode.setPlaceTrig(true);
				this.addChild(toggledNode);
				cantSet = true;
			}
		}
		
		private function mouseDownListener (e:MouseEvent):void {
			if(toggledNode == null || cantSet)
			{
				var count:Number;
				count = 0;
				while(count < allNodes.length)
				{
					if(Math.sqrt(Math.pow((e.stageX -(allNodes[count] as Node).x),2) +
						Math.pow((e.stageY -(allNodes[count] as Node).y),2)) < 10 && toggledNode == null)
					{
						selectedNode.setSelected(false);
						selectedNode = allNodes[count];
						selectedNode.setSelected(true);
					}
					count++;
				}
				cantSet = true;
			}
			else
			{
				var potentialNode:Node;
				count = 0;
				while(count < allNodes.length)
				{
					if(Math.sqrt(Math.pow((e.stageX -(allNodes[count] as Node).x),2) +
						Math.pow((e.stageY -(allNodes[count] as Node).y),2)) < (allNodes[count] as Node).getSize()+5)
						potentialNode = allNodes[count];
					count++;
				}
				if(!toggledNode.connectable())
					potentialNode = null;
				if(potentialNode == null)
				{
					toggledNode.setPlaced(true);
					allNodes.push(toggledNode);
					toggledNode.onPlaced(this);
					sup.getLevelManager().deductGold(toggledNode.getPathCost()*(Math.sqrt(Math.pow(toggledNode.x - selectedNode.x,2) + Math.pow(toggledNode.y - selectedNode.y,2))) + toggledNode.getNodeCost())
					sup.getUI().setPathExists(enterNode.pathExists(tombNode));
				}
				else if(!toggledNode.getTrigPlace())
				{
					potentialNode.addSibling(selectedNode);
					selectedNode.addSibling(potentialNode);
					this.removeChild(toggledNode);
					selectedNode.removeSibling(toggledNode);
					sup.getLevelManager().deductGold(toggledNode.getPathCost()*(Math.sqrt(Math.pow(potentialNode.x - selectedNode.x,2) + Math.pow(potentialNode.y - selectedNode.y,2))))
					sup.getUI().setPathExists(enterNode.pathExists(tombNode));
				}
				else
				{
					selectedNode.setTrigger(potentialNode);
					this.removeChild(toggledNode);
					selectedNode.removeSibling(toggledNode);
				}
				toggledNode = null;
				//sup.getUI().getPlaceNodeButton().setDown(false);
			}
			
		}
		private function keyListener(e:KeyboardEvent):void
		{
			if(e.charCode == 97)
			{
				/*toggledNode = new Node(0,0,canvas);
				toggledNode.addSibling(selectedNode);
				selectedNode.addSibling(toggledNode);
				toggledNode.setPlaced(false);
				this.addChild(toggledNode);*/
				addNode(new Node(0,0,canvas,this));
			}
			if(e.keyCode == Keyboard.ESCAPE && toggledNode != null)
			{
				this.removeChild(toggledNode);
				selectedNode.removeSibling(toggledNode);
				toggledNode = null;
				sup.getPlaceNodeButton().setDown(false);
			}
			if(e.charCode == 100)
			{
				removeNode();
			}
		}
		private function mouseUpListener (e:MouseEvent):void {
			cantSet = false;
			mouseMovListener(e);
		}
		public function addNodeDirect(nod:Node)
		{
			this.addChild(nod);
			this.allNodes.push(nod);
		}
		private function removeNode():void
		{
			if(selectedNode !=enterNode && selectedNode != tombNode)
			{
				var temp:Node = selectedNode;
				for(var i:Number = 0; i < allNodes.length; i++)
				{
					var temptemp:Node = allNodes[i];
					temptemp.removeSibling(temp);
					temp.removeSibling(temptemp);
				}
				this.removeChild(temp);
				var int:Number;
				int = allNodes.indexOf(selectedNode);
				if(int != -1)
				{
					allNodes[int] = allNodes[allNodes.length -1];
					allNodes.pop();
				}
				selectedNode = enterNode;
			}
			sup.getUI().setPathExists(enterNode.pathExists(tombNode));
		}
		private function findIntersect(x0:Number,y0:Number,x1:Number,y1:Number,
									   x2:Number,y2:Number,x3:Number,y3:Number):Array
		{
			
			// mx + b form:: m1 = y1-y0 / x1 - x0 ;b1 = -m1*x0 + y0 
			// second eqn :: m2 = y3-y2 / x3 - x2 ;b2 = -m2*x2 + y2
			// intersect calculation: m1 * x + b1 = m2 * x + b2
			// intersect x = (b2 -b1) / (m1 - m2)
			// intersect y = m1 * x + b1
			var m1:Number = (y1-y0) / (x1 - x0);
			var b1:Number = (-m1 * x0 +  y0);
			var m2:Number = (y3-y2 )/ (x3 - x2);
			var b2:Number = (-m2 * x2 + y2);
			var ret:Array = new Array();
			if(m1!=m2)
			{
				ret.push((b2 - b1) / (m1 - m2));
			}
			else
			{
				ret.push(10000);
			}
			ret.push(m1 * ret[0] + b1);
			var eval1:Boolean;
			var eval2:Boolean;
			var eval3:Boolean;
			var eval4:Boolean;
			if(x0 > x1)
			{
				if((ret[0] < x0 && ret[0] > x1))
				{
					eval1 = true;
				}
			}
			else
			{
				if((ret[0] > x0 && ret[0] < x1))
				{
					eval1 = true;
				}
			}
			
			if(x2 > x3)
			{
				if((ret[0] < x2 && ret[0] > x3))
				{
					eval2 = true;
				}
			}
			else
			{
				if((ret[0] > x2 && ret[0] < x3))
				{
					eval2 = true;
				}
			}
			
			if(y0 > y1)
			{
				if((ret[1] < y0 && ret[1] > y1))
				{
					eval3 = true;
				}
			}
			else
			{
				if((ret[1] > y0 && ret[1] < y1))
				{
					eval3 = true;
				}
			}
			
			if(y2 > y3)
			{
				if((ret[1] < y2 && ret[1] > y3))
				{
					eval4 = true;
				}
			}
			else
			{
				if((ret[1] > y2 && ret[1] < y3))
				{
					eval4 = true;
				}
			}
			if(!(eval1&&eval2&&eval3&&eval4))
			{
				ret[0] = null;
				ret[1] = null;
			}
			return ret;
		}
		private function findIntersectperp(x0:Number,y0:Number,x1:Number,y1:Number,
										   x2:Number,y2:Number, size:Number):Array
		{
			var m1:Number = (y1-y0) / (x1 - x0);
			var b1:Number = (-m1 * x0 +  y0);
			var m2:Number = -1/m1;
			var b2:Number = (-m2 * x2 + y2);
			var ret:Array = new Array();
			ret.push((b2 - b1) / (m1 - m2));
			ret.push(m1 * ret[0] + b1);
			var eval1:Boolean = false;
			var eval3:Boolean = false;
			if(x0 > x1)
			{
				if((ret[0] < x0 && ret[0] > x1))
				{
					eval1 = true;
				}
			}
			else
			{
				if((ret[0] > x0 && ret[0] < x1))
				{
					eval1 = true;
				}
			}
			
			if(y0 > y1)
			{
				if((ret[1] < y0 && ret[1] > y1))
				{
					eval3 = true;
				}
			}
			else
			{
				if((ret[1] > y0 && ret[1] < y1))
				{
					eval3 = true;
				}
			}
			if(!(eval1&&eval3) || Math.sqrt(Math.pow(ret[0] - x2,2) + Math.pow(ret[1] - y2,2)) > size)
			{
				ret[0] = null;
				ret[1] = null;
			}
			return ret;
		}
		private function mouseMovListener (e:MouseEvent):void {
			if(toggledNode != null)
			{
				var angleclose:Boolean = selectedNode.getPossibleAngle(toggledNode);
				var intersected:Boolean;
				var tooclose:Boolean;
				//				var inbounds:Boolean = inStructure(toggledNode.x,toggledNode.y);
				for(var i:Number = 0; i < allNodes.length;i++)
				{
					var intersect:Array;
					for(var j:Number = 0; j < (allNodes[i] as Node).getSiblings().length; j++)
					{
						intersect = findIntersect((allNodes[i] as Node).x,(allNodes[i] as Node).y, 
							((allNodes[i] as Node).getSiblings()[j] as Node).x,((allNodes[i] as Node).getSiblings()[j] as Node).y, 
							selectedNode.x,selectedNode.y,toggledNode.x,toggledNode.y);
						if(intersect[0] != null && intersect[1] != null && (allNodes[i] as Node) != selectedNode &&(allNodes[i] as Node) != toggledNode
							&&((allNodes[i] as Node).getSiblings()[j] as Node) != selectedNode &&((allNodes[i] as Node).getSiblings()[j] as Node) != toggledNode) 
						{
							intersected = true;
						}
						intersect = findIntersectperp((allNodes[i] as Node).x,(allNodes[i] as Node).y, 
							((allNodes[i] as Node).getSiblings()[j] as Node).x,((allNodes[i] as Node).getSiblings()[j] as Node).y,
							toggledNode.x,toggledNode.y, toggledNode.getSize());
						if(intersect[0] != null && intersect[1] != null && (allNodes[i] as Node) != selectedNode &&(allNodes[i] as Node) != toggledNode
							&&((allNodes[i] as Node).getSiblings()[j] as Node) != selectedNode &&((allNodes[i] as Node).getSiblings()[j] as Node) != toggledNode)
						{
							tooclose = true;
						}
					}
					intersect = findIntersectperp(selectedNode.x,selectedNode.y,toggledNode.x,toggledNode.y,
						allNodes[i].x,allNodes[i].y,allNodes[i].getSize());
					if(intersect[0] != null && intersect[1] != null && (allNodes[i] as Node) != selectedNode &&(allNodes[i] as Node) != toggledNode)
					{
						tooclose = true;
					}
					if(!toggledNode.connectable()&& (Math.sqrt(Math.pow((allNodes[i] as Node).x -toggledNode.x,2) + Math.pow((allNodes[i] as Node).y - toggledNode.y,2)))<Math.max(toggledNode.getSize(), (allNodes[i]as Node).getSize()))
					{
						tooclose = true;
					}
				}
				var connect:Boolean;
				var potentialNode:Node;
				var count:Number;
				count = 0;
				while(count < allNodes.length)
				{
					if(Math.sqrt(Math.pow((e.stageX -(allNodes[count] as Node).x),2) +
						Math.pow((e.stageY -(allNodes[count] as Node).y),2)) < (allNodes[count] as Node).getSize()+5)
						potentialNode = allNodes[count];
					count++;
				}
				if(potentialNode != null && selectedNode.connectable() && potentialNode.connectable())
				{
					var subangleclose:Boolean = potentialNode.getPossibleAngle(selectedNode) && selectedNode.getPossibleAngle(toggledNode);
					var subintersected:Boolean;
					var subtooclose:Boolean;
					
					for(i = 0; i < allNodes.length;i++)
					{
						var intersect:Array;
						for(j = 0; j < (allNodes[i] as Node).getSiblings().length; j++)
						{
							intersect = findIntersect((allNodes[i] as Node).x,(allNodes[i] as Node).y, 

								((allNodes[i] as Node).getSiblings()[j] as Node).x,((allNodes[i] as Node).getSiblings()[j] as Node).y, 
								potentialNode.x,potentialNode.y,potentialNode.x,potentialNode.y);
							
							if(intersect[0] != null && intersect[1] != null && (allNodes[i] as Node) != potentialNode &&(allNodes[i] as Node) != potentialNode
								&&((allNodes[i] as Node).getSiblings()[j] as Node) != potentialNode &&((allNodes[i] as Node).getSiblings()[j] as Node) != potentialNode) 
							{
								subintersected = true;
							}
							intersect = findIntersectperp((allNodes[i] as Node).x,(allNodes[i] as Node).y, 
								((allNodes[i] as Node).getSiblings()[j] as Node).x,((allNodes[i] as Node).getSiblings()[j] as Node).y,
								potentialNode.x,potentialNode.y, potentialNode.getSize());
							if(intersect[0] != null && intersect[1] != null && (allNodes[i] as Node) != potentialNode &&(allNodes[i] as Node) != potentialNode
								&&((allNodes[i] as Node).getSiblings()[j] as Node) != potentialNode &&((allNodes[i] as Node).getSiblings()[j] as Node) != potentialNode)
							{
								subtooclose = true;
							}
							
						}
						intersect = findIntersectperp(selectedNode.x,selectedNode.y, 
							potentialNode.x,potentialNode.y,
							allNodes[i].x,allNodes[i].y, potentialNode.getSize());
						if(intersect[0] != null && intersect[1] != null && (allNodes[i] as Node) != potentialNode &&(allNodes[i] as Node) != potentialNode )
						{
							subtooclose = true;
						}
					}
					if(!toggledNode.getTrigPlace())
					{
						connect = !(subintersected || subtooclose || subangleclose || angleclose);
					}
					else
						connect = true;
				}
				var inside:Boolean = Pyram.hitTestPoint(toggledNode.x,toggledNode.y,true);
				inside = inside && Pyram.hitTestPoint(toggledNode.x + 25,toggledNode.y,true);
				inside = inside && Pyram.hitTestPoint(toggledNode.x - 25,toggledNode.y,true);
				var hasTheCash:Boolean = true;
				
				
				toggledNode.setValid(inside && hasTheCash &&(!(tooclose||angleclose||intersected) || connect && potentialNode != null));
				cantSet = !inside||!hasTheCash||(tooclose||angleclose||intersected) && !(connect && potentialNode != null);
				if(toggledNode.getTrigPlace())
				{
					toggledNode.setValid(inside && hasTheCash && connect && potentialNode != null);
					cantSet =!inside||!hasTheCash || !(connect && potentialNode != null);
				}
				//conditions and crap ya know.
			}
		}	
	}
}