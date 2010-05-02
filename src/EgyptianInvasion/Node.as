package EgyptianInvasion
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	//	import mx.*;
	
	public class Node extends Sprite {
		
		protected var canvas:Stage;
		protected var nodes:Array;
		protected var selected:Boolean;
		protected var currRad:Number;
		protected var radiusInc:Boolean;
		protected var time:Timer;
		protected var placed:Boolean;
		protected var isValid:Boolean;
		protected var size:Number;
		protected var validAngles:Array;
		protected var isConnectable:Boolean;
		protected var sup:NodeManager;
		protected var triggerNode:Node; //node that this one will trigger.
		protected var isTrigPlace:Boolean;//utility variable, so we can tell when the player wants to make a trigger connection
										//between nodes.
		protected var goldWithin:Number;
		protected var value:Number;
		protected var pathVal:Number;
		
		public function Node(nodex:Number, nodey:Number, canvas:Stage, refup:NodeManager) {
			//this.cacheAsBitmap = true;
			value = 0;
			pathVal = .05;
			this.isConnectable = true;
			isTrigPlace = false;
			sup = refup;
			this.blendMode = BlendMode.LAYER;
			this.canvas = canvas;
			x = nodex;
			y = nodey;
			size = 2;
			time = new Timer(100);
			currRad = size;
			radiusInc = false;
			//			canv.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			//			canv.addEventListener(MouseEvent.MOUSE_UP, mouseUpListener);
			canvas.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			time.addEventListener(TimerEvent.TIMER,TimeListener);
			time.start();
			nodes = new Array();
		}
		public function getPathCost():Number{
			return pathVal;
		}
		public function getNodeCost():Number{
			return value;
		}
		public function connectable():Boolean {
			return isConnectable;
		}
		
		public function drawToPointX():Number {
			return x;
		}
		
		public function drawToPointY():Number {
			return y;	
		}
		
		// Determines if the enemy should be affected based on its current position (if it is within the range of the node)
		// Called by the Enemy class
		public function processEnemy(guy:Enemy):Boolean {
			if(Math.sqrt(Math.pow(guy.x - x,2) + Math.pow(guy.y - y, 2)) < size)
			{
				if(triggerNode != null && !guy.isDead())
					triggerNode.trigger();
				return true;
			}
			else
			{
				return false;
			}
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
		public function getImpassible(): Boolean
		{
			return false;
		}
		public function trigger():void
		{
			
		}
		public function setValid ( val:Boolean):void
		{
			isValid = val;
		}
		public function getSize():Number
		{
			return size;
		}
		public function addGold(gold:Number):void {
			this.goldWithin += gold;
		}
		
		public function onPlaced(sup:NodeManager):void {
		
		}
		
		public function getPossibleAngle(nodeIn:Node):Boolean {
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
	/*		if(validAngles != null && validAngles.length >0)
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
				return false;*/
			return false;
		}
		
		protected function displayFaded():void {
			graphics.clear();
			if(radiusInc)
				currRad+=.1;
			else
				currRad-=.1;
			if(currRad <size)
				radiusInc = true;
			else if (currRad >size+5)
				radiusInc = false;
			
			
			if(!isValid && !this.isTrigPlace)
				graphics.beginFill(0xFF0000,1);
			if(isValid && !this.isTrigPlace)
				graphics.beginFill(0x00FFEE,1);
			if(!this.isTrigPlace)
			{
				graphics.drawCircle(0,0,size);
				graphics.endFill();
				graphics.lineStyle(1,0xFF2000,1);
			}
			else if(isValid)
				graphics.lineStyle(1,0x00FF00,.8);
			else
				graphics.lineStyle(1, 0x0FF000,.8)
			if(selected)
				graphics.lineStyle(1.5, 0x00FF00,.5);
			graphics.drawCircle(0,0,currRad);
			if(this.triggerNode != null)
			{
				graphics.moveTo(0,0);
				graphics.lineStyle(1, 0x00FF00);
			
				graphics.lineTo(triggerNode.drawToPointX(),triggerNode.drawToPointY());
				graphics.moveTo(0,0);
			}
			blendMode = BlendMode.NORMAL;
		}
		
		protected function displaySolid():void {
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
			if(this.triggerNode != null)
			{
				graphics.moveTo(0,0);
				graphics.lineStyle(1, 0x00FF00);
				
				graphics.lineTo(triggerNode.drawToPointX(),triggerNode.drawToPointY());
				graphics.moveTo(0,0);
			}
			
		}
		
		public function setPlaceTrig(trig:Boolean):void {
			this.isTrigPlace = trig;
		}
		
		public function setTrigger(trig:Node):void {
			this.triggerNode = trig;
		}
		
		public function getTrigPlace():Boolean {
			return this.isTrigPlace;
		}
		
		protected function TimeListener(e:TimerEvent):void	{
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
		
		protected function mouseMoveListener(e:MouseEvent):void {
			if(!placed)
			{
				x = e.stageX;
				y = e.stageY;
			}
		}
	}
}