package EgyptianInvasion
{
	import flash.display.*;
	
	// Manages the creation and removal of enemies
	public class EnemyManager
	{
		private var canvas:Stage;
		private var main:Main;
		private var nodeMan:NodeManager;		
		
		public function EnemyManager(main:Main, nodeMan:NodeManager)
		{
			this.canvas = main.stage;
			this.main = main;
			this.nodeMan = nodeMan;
		}
		
		public function beginInvasion():void {
			main.addChild(new Enemy(nodeMan.getStartNode(), nodeMan.getEndNode() ,canvas));
		}
	}
}