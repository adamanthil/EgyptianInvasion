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
		public var flag:Number;

		public function EI(){
			//Object.register
			stage.addEventListener(MouseEvent.MOUSE_DOWN, drawLine);
			addNode.addEventListener(MouseEvent.CLICK, toggleDraw);
			enum = 1;
			flag = 0;
		}

		public function node():void{
		var newNode:SimpleButton = new Node_Btn();

		newNode.x = 50+enum*100;
		newNode.y = 200;
		addChild(newNode);
		enum++;
		}
		
		private function toggleDraw(e:MouseEvent):void{
			flag = 1-flag;
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