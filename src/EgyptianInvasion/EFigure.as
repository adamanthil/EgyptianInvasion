package EgyptianInvasion
{
	import flash.display.Sprite;
	import flash.display.Stage;

	public class EFigure extends Sprite
	{
		private var figure:EnemyFigure;
		private var canvas:Stage;
		
		public function EFigure(nodex:Number, nodey:Number, cvas:Stage)
		{
			figure = new EnemyFigure();
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