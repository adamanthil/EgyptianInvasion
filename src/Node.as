package
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;
	
	//	import mx.*;
	
	public class Node extends Sprite
	{
		var nodes:Array;
		var selected:Boolean;
		var canv:Stage;
		var currRad:Number;
		var radiusInc:Boolean;
		var time:Timer;
		var placed:Boolean;
		var isValid:Boolean;
		
		public function Node(nodex:Number, nodey:Number, canvas:Stage)
		{
			canv = canvas;
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
			canv.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveListener);
			time.addEventListener(TimerEvent.TIMER,TimeListener);
			time.start();
			nodes = new Array();
		}
		public function setSelected( select:Boolean)
		{
			selected = select;
		}
		public function setPlaced ( place:Boolean)
		{
			placed = place;
		}
		private function displayFaded()
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
			graphics.beginFill(0xFF0000,.5);
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
		private function displaySolid()
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
		public function TimeListener(e:TimerEvent)
		{
			if(placed)
				displaySolid();
			else
				displayFaded();
		}
		public function removeSibling(nod:Node)
		{
			var int:Number;
			int = nodes.indexOf(nod);
			if(int != -1)
			{
				nodes[int] = nodes[nodes.length -1];
				nodes.pop();
			}
		}
		public function addSibling(nod:Node)
		{
			nodes.push(nod);
			graphics.lineStyle(5,0xFF2000);
			graphics.moveTo(0,0);
			graphics.lineTo(nod.x,nod.y);
		}
		public function mouseMoveListener(e:MouseEvent)
		{
			if(!placed)
			{
				x = e.stageX;
				y = e.stageY;
			}
		}
	}
}