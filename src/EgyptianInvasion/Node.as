package EgyptianInvasion
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	//	import mx.*;
	
	public class Node extends Sprite {
		
		private var canvas:Stage;
		private var nodes:Array;
		private var selected:Boolean;
		private var currRad:Number;
		private var radiusInc:Boolean;
		private var time:Timer;
		private var placed:Boolean;
		private var isValid:Boolean;
		
		public function Node(nodex:Number, nodey:Number, canvas:Stage) {
			this.canvas = canvas;
			x = nodex;
			y = nodey;
			time = new Timer(10);
			graphics.beginFill(0xFF0000);
			graphics.drawCircle(0,0,5);
			graphics.endFill();
			graphics.lineStyle(1,0xFF2000);
			currRad = 10;
			radiusInc = false;
			graphics.drawCircle(0,0,currRad);
			//			canv.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			//			canv.addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
			canvas.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			time.addEventListener(TimerEvent.TIMER,TimeListener);
			time.start();
			nodes = new Array();
		}
		
		public function setSelected( select:Boolean):void {
			selected = select;
		}
		
		public function setPlaced ( place:Boolean):void	{
			placed = place;
		}
		
		public function setValid ( val:Boolean):void
		{
			isValid = val;
		}
		
		public function getPossibleAngle(nodeIn:Node):Boolean
		{
			var relx0:Number = (nodeIn.x - x)/Math.sqrt(Math.pow(nodeIn.x - x,2) + Math.pow(nodeIn.y - y,2));
			var rely0:Number = (nodeIn.y - y)/Math.sqrt(Math.pow(nodeIn.x - x,2) + Math.pow(nodeIn.y - y,2));
			for(var i:Number = 0; i < nodes.length;i++)
			{
				var relx1:Number = ((nodes[i] as Node).x - x)/Math.sqrt(Math.pow((nodes[i] as Node).x - x,2) + Math.pow((nodes[i] as Node).y - y,2));
				var rely1:Number = ((nodes[i] as Node).y - y)/Math.sqrt(Math.pow((nodes[i] as Node).x - x,2) + Math.pow((nodes[i] as Node).y - y,2));
				if(Math.acos(relx0 * relx1 + rely0* rely1) < Math.PI/6
					&& !(nodeIn == nodes[i] as Node))
					return true;
			}
			return false;
		}
		
		private function displayFaded():void
		{
			graphics.clear();
			if(radiusInc)
				currRad+=.1;
			else
				currRad-=.1;
			if(currRad <5)
				radiusInc = true;
			else if (currRad >10)
				radiusInc = false;
			if(!isValid)
				graphics.beginFill(0xFF0000,.5);
			if(isValid)
				graphics.beginFill(0x00FFEE,.5);
			graphics.drawCircle(0,0,5);
			graphics.endFill();
			graphics.lineStyle(1,0xFF2000,.5);
			if(selected)
				graphics.lineStyle(1.5, 0x00FF00,.5);
			graphics.drawCircle(0,0,currRad);
			var int:Number;
			int = 0;
			while(int < nodes.length)
			{
				graphics.moveTo(0,0);
				graphics.lineStyle(3, 0xFF0000,.5);
				graphics.lineTo((nodes[int] as Node).x - x,(nodes[int] as Node).y - y);
				graphics.moveTo(0,0);
				int++;
			}
		}
		
		private function displaySolid():void
		{
			graphics.clear();
			if(radiusInc)
				currRad+=.1;
			else
				currRad-=.1;
			if(currRad <5)
				radiusInc = true;
			else if (currRad >10)
				radiusInc = false;
			graphics.beginFill(0xFF0000);
			graphics.drawCircle(0,0,5);
			graphics.endFill();
			graphics.lineStyle(1,0xFF2000);
			if(selected)
				graphics.lineStyle(1.5, 0x00FF00);
			graphics.drawCircle(0,0,currRad);
			var int:Number;
			int = 0;
			while(int < nodes.length)
			{
				graphics.moveTo(0,0);
				graphics.lineStyle(3, 0xFF0000);
				if(!(nodes[int] as Node).placed)
					graphics.lineStyle(3, 0xFF0000,.5);
				graphics.lineTo((nodes[int] as Node).x - x,(nodes[int] as Node).y - y);
				graphics.moveTo(0,0);
				int++;
			}
		}
		
		public function TimeListener(e:TimerEvent):void	{
			if(placed)
				displaySolid();
			else
				displayFaded();
		}
		
		public function removeSibling(nod:Node):void {
			var int:Number;
			int = nodes.indexOf(nod);
			if(int != -1)
			{
				nodes[int] = nodes[nodes.length -1];
				nodes.pop();
			}
		}
		
		public function addSibling(nod:Node):void {
			nodes.push(nod);
			graphics.lineStyle(5,0xFF2000);
			graphics.moveTo(0,0);
			graphics.lineTo(nod.x,nod.y);
		}
		
		// Determines whether a path exists between nodes
		public function pathExists(n:Node):Boolean {
			return pathExistsRecursive(n,new Array());
		}
		
		private function pathExistsRecursive(n:Node, visited:Array):Boolean {
			if(n == this) {
				return true;
			}
			else if(visited.indexOf(n) >= 0) {
				return false;
			}
			else { // Not yet visited
				visited.push(n);
				var pathExists:Boolean = false;
				for(var i:int = 0; i < n.getSiblings().length; i++) {
					var exists:Boolean = pathExistsRecursive(n.getSiblings()[i],visited);
					if(exists) {
						pathExists = true;
						break;
					}
				}
				return pathExists;
			}
			
		}
		
		public function getSiblings():Array {
			return nodes;
		}
		
		public function mouseMoveListener(e:MouseEvent):void {
			if(!placed)
			{
				x = e.stageX;
				y = e.stageY;
			}
		}
	}
}