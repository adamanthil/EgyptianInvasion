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
		private var enemies:Array;
		private var timer:Timer;
		private var spawnTimer:Timer;
		private var numEnemiesOnLevel:Number;
		private var numEnemiesRemaining:Number;
		private var spawnFrequency:Number;
		
		public function EnemyManager(main:Main)
		{
			this.canvas = main.stage;
			this.main = main;
			this.enemies = new Array();
			
			//numEnemiesOnLevel = 1; // TODO WB will need to change this on per-level basis
			numEnemiesOnLevel = 80; // TODO WB will need to change this on per-level basis
			numEnemiesRemaining = numEnemiesOnLevel;
			spawnFrequency = 1000; // One second
			
			spawnTimer = new Timer(spawnFrequency, numEnemiesRemaining); // This line defines frequency and number of enemies to spawn
			spawnTimer.addEventListener(TimerEvent.TIMER,spawnTimeListener);
			
			timer = new Timer(10);
			timer.addEventListener(TimerEvent.TIMER,timeListener);
			timer.start();
		}
		
		public function removeTimer():void {
			spawnTimer.removeEventListener(TimerEvent.TIMER, spawnTimeListener);
			timer.removeEventListener(TimerEvent.TIMER, timeListener);
		}
		// Call "nextTimeInterval" on all enemies
		public function timeListener(e:TimerEvent):void	{
			
			// iterate backwards becaues we may delete enemies
			for(var i:int = enemies.length - 1; i >= 0; i--) {
				// Remove dead enemies
				if(Enemy(enemies[i]).getHealth() <= 0) {
					removeEnemy(Enemy(enemies[i]));
				}
				else {
					enemies[i].nextTimeInterval();
				}
			}
		}
		public function spawnTimeListener(e:TimerEvent):void {
			var enemy:Enemy;
			if(Math.random() < 0.2) {	// Spaw BigEnemy 20% of the time
				enemy = new BigEnemy(main.getNodeManager().getStartNode(), main.getNodeManager().getEndNode() ,canvas);
			}
			else {
				enemy = new VanillaEnemy(main.getNodeManager().getStartNode(), main.getNodeManager().getEndNode() ,canvas);
			}
			enemies.push(enemy);
			numEnemiesRemaining--;
			main.getLevelManager().displayEnemiesToCome(numEnemiesRemaining);
			addChild(enemy);
			main.getLevelManager().displayEnemiesOnBoard(enemies.length);
		}
		
		// Removes an enemy and returns the gold it's carying to the most recently visited node
		public function removeEnemy(enemy:Enemy):Boolean {
			var index:int = enemies.indexOf(enemy);
			if(index < 0) {
				return false;	
			}
			else {
				
				// Transfer gold being carried to most recently visited node
				(enemies[index] as Enemy).getOriginNode().addGold((enemies[index] as Enemy).getGold());
				
				// ---- remove enemy from array and display ------
				// Since you can only remove the last item, replace the one we want to remove with the one currently at the end
				enemies[index] = enemies[enemies.length -1];
				enemies.pop();
				main.getLevelManager().displayEnemiesOnBoard(enemies.length);
				
				removeChild(enemy);
				return true;
			}
			
		}
		
		public function getNumEnemiesOnLevel():Number{
			return numEnemiesOnLevel;
		}
		
		public function beginInvasion():void {
			spawnTimer.start();
		}
		
		public function hasEnemies():Boolean {
			if(enemies.length == 0) {
				return false;
			}
			else {
				return true;
			}
		}
	}
}