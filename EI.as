package
{
	import flash.display.*;
	import flash.events.*;
	
	public class EI extends Sprite {
		public var enum:Number;
		var prevx:Number;
	    var prevy:Number;
	    var currx:Number;
	    var curry:Number;
		var scenery:Main;
		public var flag:Number;
		public var canvas:Stage;
		public var addNodeFlag:Number;

		public function EI(theScene:Main, canv:Stage){
			//Object.register
			scenery = theScene;
			canvas = canv;
	//		addNode.addEventListener(MouseEvent.CLICK, toggleAddNode);
		//	changeNode.addEventListener(MouseEvent.CLICK, toggleDraw);
			//stage.addEventListener(MouseEvent.CLICK, mouseDownEvent);
			
			enum = 1;
			flag = 0;
			addNodeFlag = 0;
		}
		public function node():void{
		var newNode:Node = new Node(50+enum*100,200,canvas);
		scenery.addNode(newNode);
		enum++;
		}

		private function toggleAddNode(e:MouseEvent):void{
			addNodeFlag = 1-addNodeFlag;
			flag = 0;
		}
		
		private function toggleDraw(e:MouseEvent):void{
			flag = 1-flag;
			addNodeFlag = 0;
		}
		
		private function mouseDownEvent (e:MouseEvent):void{
			if (addNodeFlag == 1){
				var newNode:Node = new Node(e.stageX, e.stageY,canvas);
				scenery.addNode(newNode);
			}
			else if (flag == 1){
				drawLine(e);
				}
			else{
				trace("in mousedown");
			}
		}
		
	   private function drawLine (e:MouseEvent):void {
		   if (flag == 1){
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
}