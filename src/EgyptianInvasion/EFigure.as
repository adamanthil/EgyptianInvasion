package EgyptianInvasion
{
	import flash.display.*;

	public class EFigure extends Sprite
	{
		private var figure:MovieClip;
		private var canvas:Stage;
		private var poisoned:Boolean;
		
		public function EFigure(asset:MovieClip, nodex:Number, nodey:Number, cvas:Stage)
		{
			figure = asset;
			figure.stop();
			this.canvas = cvas;
			x = nodex;
			y = nodey;
			addChild(figure);
		}
		
		public function poison(poison:Boolean):void {
			poisoned = poison;
		}
		
		public function walk():void {
			if(poisoned) {
				figure.gotoAndStop("poisonedRight");
			}
			else {
				figure.gotoAndStop("walkRight");
			}
		}
		
		public function walkLeft():void{
			if(poisoned) {
				figure.gotoAndStop("poisonedLeft");
			}
			else {
				figure.gotoAndStop("walkLeft");
			}
		}
		
		public function stand():void {
			figure.gotoAndStop("stand");
		}
		public function updatePosition(positionX:Number, postionY:Number):void{
			
		}
	}
}