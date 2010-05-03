package EgyptianInvasion
{
	import flash.display.*;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	// Manages the creation and removal of enemies
	public class EnemyManager extends Sprite
	{
		private var canvas:Stage;
		private var main:Main;
		private var nodeMan:NodeManager;		
		private var enemies:Array;
		private var timer:Timer;
		private var spawnTimer:Timer;
		private var numEnemiesOnLevel:Number;
		private var spawnFrequency:Number;
		
		public function EnemyManager(main:Main, nodeMan:NodeManager)
		{
			this.canvas = main.stage;
			this.main = main;
			this.nodeMan = nodeMan;
			this.enemies = new Array();
			
			numEnemiesOnLevel = 20; // TODO WB will need to change this on per-level basis
			spawnFrequency = 1000; // One second
			
			spawnTimer = new Timer(spawnFrequency, numEnemiesOnLevel); // This line defines frequency and number of enemies to spawn
			spawnTimer.addEventListener(TimerEvent.TIMER,spawnTimeListener);
			
			timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER,timeListener);
			timer.start();
		}
		
		// Call "nextTimeInterval" on all enemies
		public function timeListener(e:TimerEvent):void	{
			for(var i:int = 0; i < enemies.length; i++) {
				enemies[i].nextTimeInterval();
			}
		}
		public function spawnTimeListener(e:TimerEvent):void	{
			var enemy:Enemy = new Enemy(nodeMan.getStartNode(), nodeMan.getEndNode() ,canvas)
			enemies.push(enemy);
			addChild(enemy);
			main.getLevelManager().displayEnemy(enemies.length);
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
				main.getLevelManager().displayEnemy(enemies.length);
				return true;
			}
		}
		
		public function beginInvasion():void {
			spawnTimer.start();
		}
	}
}