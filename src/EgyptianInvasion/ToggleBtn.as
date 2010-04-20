package EgyptianInvasion
{
	import flash.display.*;
	import flash.events.*;
	
	public class ToggleBtn extends Sprite
	{
		private var canvas:Stage;
		private var btn:MovieClip;
		private var down:Boolean;
		
		public function ToggleBtn(nodex:Number, nodey:Number, canvas:Stage) 
		{
			btn = new ToggleButton();
			btn.stop();
			down = false;
			x = nodex;
			y = nodey;
			this.canvas = canvas;
			addChild(btn);
			btn.addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			btn.addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			btn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
		}
		
		private function mouseOver (e:MouseEvent):void {
			btn.gotoAndStop("mouseOver");
			
		}
		
		private function mouseOut (e:MouseEvent):void {
			if (!down){
				btn.gotoAndStop("mouseUp");
			}
			else{
				btn.gotoAndStop("mouseDown");
			}
		}
		
		private function mouseDown (e:MouseEvent):void {
			
			if (down){
				btn.gotoAndStop("mouseUp");
				down = false;
				(parent as Main).setToggledNode(null);
			}
			else {
				btn.gotoAndStop("mouseDown");
				down = true;
				(parent as Main).addNode(new Node(e.stageX,e.stageY,canvas));
			}
		}
		
		public function isDown ():Boolean{
			return down;
		}
		
		public function setDown(flag:Boolean):void{
			down = flag;
			if (down){
				btn.gotoAndStop("mouseDown");
			}
			else{
				btn.gotoAndStop("mouseUp");	
		    }
		}
	}
}