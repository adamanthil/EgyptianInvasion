package EgyptianInvasion
{
	import flash.display.Stage;
	
	public class BigEnemy extends Enemy
	{
		public function BigEnemy(startNode:Node, endNode:Node, canvas:Stage)
		{
			var figure:EFigure = new EFigure(new EnemyFigure2(),-3,-3,canvas);
			super(figure, startNode, endNode, canvas);
			this.maxHealth = 200;
			this.health = maxHealth;
			this.speed = 2;
			this.pitSlots = 2;
			
			figure.scaleX = 0.02;
			figure.scaleY = 0.02;
			
			healthBar.scaleX = 0.4;
			goldCarryingBar.scaleX = 0.4;
		}
		
		// Big enemies are immmune to poison
		public override function poison(amnt:Number):Boolean {
			return false;
		}
	}
}