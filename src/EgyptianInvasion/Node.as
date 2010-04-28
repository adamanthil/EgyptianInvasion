package EgyptianInvasion
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	//	import mx.*;
	
	public class Node extends Sprite {
		
		public var canvas:Stage;
		public var nodes:Array;
		public var selected:Boolean;
		public var currRad:Number;
		public var radiusInc:Boolean;
		public var time:Timer;
		public var placed:Boolean;
		public var isValid:Boolean;
		public var size:Number;
		public var validAngles:Array;
		public var isConnectable:Boolean;
		
		public function Node(nodex:Number, nodey:Number, canvas:Stage) {
			//this.cacheAsBitmap = true;
			this.blendMode = BlendMode.LAYER;
			this.canvas = canvas;
			x = nodex;
			y = nodey;
			size = 5;
			time = new Timer(10);
			currRad = size;
			radiusInc = false;
			//			canv.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			//			canv.addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
			canvas.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			time.addEventListener(TimerEvent.TIMER,TimeListener);
			time.start();
			nodes = new Array();
		}
		public function connectable()
		{
			return isConnectable;
		}
		public function setSelected( select:Boolean):void {
			selected = select;
		}
		
		public function setPlaced ( place:Boolean):void	{
			placed = place;
		}
		public function isPlaced () :Boolean
		{
			return placed;
		}
		public function setValid ( val:Boolean):void
		{
			isValid = val;
		}
		public function getSize():Number
		{
			return size;
		}
		public function onPlaced(sup:NodeManager):void
		{
		}
		public function onInside(guys:EnemyManager):void
		{
			
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
				{
					return true;
				}
			}
			if(validAngles != null && validAngles.length >0)
			{
				var isValidAngle:Boolean = false;
				for(var j :Number = 0; j < validAngles.length; j +=2)
				{
					if(Math.acos(relx0) > validAngles[j] && Math.acos(relx0) < validAngles[j+1])
						isValidAngle = true;
				}
				if(isValidAngle)
					return false;
			}
			else
				return false;
			return true;
		}
		
		public function displayFaded():void
		{
			graphics.clear();
			if(radiusInc)
				currRad+=.1;
			else
				currRad-=.1;
			if(currRad <size)
				radiusInc = true;
			else if (currRad >size+5)
				radiusInc = false;
			
			
			if(!isValid)
				graphics.beginFill(0xFF0000,1);
			if(isValid)
				graphics.beginFill(0x00FFEE,1);
			graphics.drawCircle(0,0,size);
			graphics.endFill();
			
			graphics.lineStyle(1,0xFF2000,1);
			if(selected)
				graphics.lineStyle(1.5, 0x00FF00,.5);
			graphics.drawCircle(0,0,currRad);
			
			blendMode = BlendMode.NORMAL;
		}
		
		public function displaySolid():void
		{
			graphics.clear();
			
			if(radiusInc)
				currRad+=.1;
			else
				currRad-=.1;
			if(currRad <size)
				radiusInc = true;
			else if (currRad >size+5)
				radiusInc = false;
			graphics.beginFill(0xFF0000);
			graphics.drawCircle(0,0,size);
			graphics.endFill();
			
			graphics.lineStyle(1,0xFF2000);
			if(selected)
				graphics.lineStyle(1.5, 0x00FF00);
			graphics.drawCircle(0,0,currRad);
			blendMode = BlendMode.NORMAL;
			
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
		
		public function pathExistsRecursive(n:Node, visited:Array):Boolean {
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