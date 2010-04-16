package
{
	import flash.display.*;
	import flash.events.*;
	
	public class SimpleScribble extends Sprite {
		var prevx:Number;
		var prevy:Number;
		var currx:Number;
		var curry:Number;
		public function SimpleScribble () {
			x =0;
			y = 0;
			prevx = 0;
			prevy =0;
			stage.frameRate = 100;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownListener);
			
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