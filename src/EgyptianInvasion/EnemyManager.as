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
		private var numEnemiesKilled:int;
		private var spawnFrequency:Number;
		
		// -- Reinforcement Learning -------
		private var explorationRate:Number = 0.5;	// Start exploring a lot to make sure we don't get stuck, decrease quickly
		private var minExplorationRate:Number = 0.05;	// Exploration rate will never fall below this value
		private var explorationRateDecay:Number = 0.75;	// Geometric decay
		// ---------------------------------
		
		public function EnemyManager(main:Main)
		{
			this.canvas = main.stage;
			this.main = main;
			
			// Initialize to level 1
			this.numEnemiesRemaining = LevelManager.getNumEnemiesAtLevel(1);
			this.numEnemiesOnLevel = LevelManager.getNumEnemiesAtLevel(1);
			
			//spawnFrequency = 1500; // in milliseconds
			spawnFrequency = 10000;	// for RL tests
			
			reInitialize();
		}
		
		// Gets the type of an enemy (used by RL to determine which Q values to use)
		public static function getEnemyType(en:Enemy):int {
			if(en is BigEnemy) {
				return 1;
			}
			else {	// Default (VanillaEnemy)
				return 0;
			}
		}
		
		// Returns the number of enemy types current supported
		public static function getNumEnemyTypes():int {
			return 2;
		}
		
		public function removeTimer():void{
			spawnTimer.removeEventListener(TimerEvent.TIMER, spawnTimeListener);
			timer.removeEventListener(TimerEvent.TIMER, timeListener);
		}
		public function reInitialize():void {
			
			
			numEnemiesRemaining = numEnemiesOnLevel;
			numEnemiesKilled = 0;
			this.enemies = new Array();
			
			spawnTimer = new Timer(spawnFrequency, numEnemiesRemaining); // This line defines frequency and number of enemies to spawn
			spawnTimer.addEventListener(TimerEvent.TIMER,spawnTimeListener);
			
			//timer = new Timer(10);
			timer = new Timer(1);	// For RL tests
			timer.addEventListener(TimerEvent.TIMER,timeListener);
			timer.start();
			
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
			
			// Set exploration rate for this enemy and decay it
			var alpha:Number = this.explorationRate;
			this.explorationRate = Math.max(explorationRate * explorationRateDecay,minExplorationRate);
			
			if(Math.random() < 0.2) {	// Spaw BigEnemy 20% of the time
				enemy = new BigEnemy(main.getNodeManager().getStartNode(), main.getNodeManager().getEndNode() ,canvas, alpha);
			}
			else {
				enemy = new VanillaEnemy(main.getNodeManager().getStartNode(), main.getNodeManager().getEndNode() ,canvas, alpha);
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
				numEnemiesKilled++;	// Increment number of enemies killed
				
				// Check for winning game (removed last enemy)
				if(numEnemiesKilled == numEnemiesOnLevel) {
					main.getLevelManager().popWinWin();
				}
				
				// Perform final cleanup tasks before pointer is deleted by garbage collector
				enemy.cleanUp();
				
				// Trace final reward for graphing/analysis
				trace(enemy.getId() + "\t" + getEnemyType(enemy) + "\t" + enemy.getTotalReward());
				
				return true;
			}
		}
		
		public function getNumEnemiesOnLevel():Number{
			return numEnemiesOnLevel;
		}
		
		public function setNumEnemiesOnLevel(n:Number):void {
			numEnemiesOnLevel = n;
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