package EgyptianInvasion
{
	import flash.display.*;
	
	// Manages the creation and removal of enemies
	public class EnemyManager extends Sprite
	{
		private var canvas:Stage;
		private var main:Main;
		private var nodeMan:NodeManager;		
		private var enemies:Array;
		
		public function EnemyManager(main:Main, nodeMan:NodeManager)
		{
			this.canvas = main.stage;
			this.main = main;
			this.nodeMan = nodeMan;
		}
		
		// Removes an enemy and returns the gold it's carying to the most recently visited node
		public function removeEnemy(enemy:Enemy):Boolean {
			var index:int = enemies.indexOf(enemy);
			if(index < 0) {
				return false;	
			}
			else {
				// remove enemy from array and display
				removeChild(enemy);
				
				// Since you can only remove the last item, replace the one we want to remove with the one currently at the end
				enemies[index] = enemies[enemies.length -1];
				enemies.pop();
				
				return true;
			}
		}
		
		public function beginInvasion():void {
			var enemy:Enemy = new Enemy(nodeMan.getStartNode(), nodeMan.getEndNode() ,canvas)
			enemies.push(enemy);
			addChild(enemy);
		}
	}
}