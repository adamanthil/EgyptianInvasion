package EgyptianInvasion
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import mx.core.BitmapAsset;
	
	public class Button extends Sprite
	{
		private var canvas:Stage;
		private var down:Boolean;
		
		private var buttonAsset:MovieClip;
		private var mouseDown:Function;
		private var mouseClick:Function;
		private var text:TextField;
		private var format:TextFormat;
		private var main:Main;
		
		private var descPopout:BitmapAsset;
		
		public function Button(buttonAsset:MovieClip, nodex:Number, nodey:Number, label:String, canvas:Stage, main:Main) 
		{
			this.buttonAsset = buttonAsset;
			buttonAsset.stop();
			down = false;
			x = nodex;
			y = nodey;
			this.canvas = canvas;
			this.main = main;
			addChild(buttonAsset);
			format = new TextFormat();
			format.color = 0xFFFF32; 
			//format.size = 48; 
			
			text = new TextField();
			text.selectable = false;
			text.appendText(label);
			text.setTextFormat(format);
			text.autoSize = TextFieldAutoSize.CENTER;
			text.x = -(text.textWidth/2)-1;
			text.y =  - (text.textHeight/2)-1;
			addChild(text);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		}
		
		// Accessor methods
		public function getMain():Main					{return main;}
		public function getCanvas():Stage				{return canvas;}
		public function isDown ():Boolean				{return down;}
		public function getDescription():BitmapAsset 	{return descPopout;}
		public function getButtonAsset():MovieClip 		{return this.buttonAsset;}
		
		// Mutator methods
		public function setDescription(b:BitmapAsset):void	{descPopout = b;}
		
		
		// Event Handlers
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