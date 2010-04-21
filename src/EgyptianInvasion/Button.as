package EgyptianInvasion
{
	import flash.display.*;
	import flash.events.*;
	
	public class Button extends Sprite
	{
		private var canvas:Stage;
		private var down:Boolean;
		
		private var buttonAsset:MovieClip;
		private var mouseDown:Function;
		private var mouseClick:Function;
		
		public function Button(buttonAsset:MovieClip, nodex:Number, nodey:Number, canvas:Stage) 
		{
			this.buttonAsset = buttonAsset;
			buttonAsset.stop();
			down = false;
			x = nodex;
			y = nodey;
			this.canvas = canvas;
			addChild(buttonAsset);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		}
		
		public function setMouseDown(mouseDown:Function):void {
			this.mouseDown = mouseDown;
			this.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDown);
		}
		
		public function setMouseClick(mouseClick:Function):void {
			this.mouseClick = mouseClick;
			this.addEventListener(MouseEvent.CLICK, this.mouseClick);
		}
		
		public function getButtonAsset():MovieClip {
			return this.buttonAsset;
		}
		
		private function mouseOver (e:MouseEvent):void {
			buttonAsset.gotoAndStop("mouseOver");
		}
		
		private function mouseOut (e:MouseEvent):void {
			if (!down){
				buttonAsset.gotoAndStop("mouseUp");
			}
			else{
				buttonAsset.gotoAndStop("mouseDown");
			}
		}
		
		public function isDown ():Boolean{
			return down;
		}
		
		public function setDown(flag:Boolean):void{
			down = flag;
			if (down){
				buttonAsset.gotoAndStop("mouseDown");
			}
			else{
				buttonAsset.gotoAndStop("mouseUp");	
		    }
		}
	}
}