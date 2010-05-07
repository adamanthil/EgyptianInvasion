package EgyptianInvasion
{
	import flash.display.*;

	public class EFigure extends Sprite
	{
		private var figure:MovieClip;
		private var canvas:Stage;
		
		public function EFigure(asset:MovieClip, nodex:Number, nodey:Number, cvas:Stage)
		{
			figure = asset;
			figure.stop();
			this.canvas = cvas;
			x = nodex;
			y = nodey;
			addChild(figure);
		}
		
		
		public function walk():void {
			figure.gotoAndStop("walkRight");
		}
		
		public function stand():void {
			figure.gotoAndStop("stand");
		}
		public function updatePosition(positionX:Number, postionY:Number):void{
			
		}
	}
}