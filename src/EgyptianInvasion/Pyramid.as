package EgyptianInvasion
{
	import flash.display.*;
	import flash.events.*;
	public class Pyramid extends Sprite
	{
		private var canvas:Stage;
		private var inside:Boolean;
		
		private var asset:MovieClip;
		
		public function Pyramid(asset:MovieClip, nodex:Number, nodey:Number, canvas:Stage, erase:Boolean)
		{
			if(erase)
				this.blendMode = BlendMode.ERASE;
			this.asset = asset;
			this.canvas = canvas;
			x=nodex;
			y=nodey;
			addChild(asset);
			inside = false;
//			this.cacheAsBitmap =true;
			canvas.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		}
		
		
		private function mouseMove (e:MouseEvent):void {
			
			//inside = false;
			if (hitTestPoint(canvas.mouseX, canvas.mouseY,true)){
			//visible = false;
				inside = true;
			}
			else{
			//visible = true;
				inside = false;
			}
		}
		
		public function isInside():Boolean{
			return inside;
		}
	}
}