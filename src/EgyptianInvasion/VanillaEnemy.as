package EgyptianInvasion
{
	import flash.display.Stage;

	// Standard Enemy
	public class VanillaEnemy extends Enemy
	{
		public function VanillaEnemy(startNode:Node, endNode:Node, canvas:Stage)
		{
			var figure:EFigure = new EFigure(new EnemyFigure2(),-3,-3,canvas);
			super(figure, startNode, endNode, canvas);
		}
	}
}