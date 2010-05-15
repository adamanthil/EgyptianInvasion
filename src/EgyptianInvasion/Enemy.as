// An enemy trying to find the pharaoh's treasure
package EgyptianInvasion
{	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.*;
	
	import org.osmf.events.TimeEvent;
	
	/* Abstract class.  Should be extended not instantiated */
	public class Enemy extends Sprite
	{
		private var canvas:Stage;
		private var startNode:Node;	// The fist node we start at (immutable after instantiation)
		private var endNode:Node;	// The end/tomb node where the gold exists (immutable after instantiation)
		private var goalNode:Node;	// Our eventual goal
		private var originNode:Node;	// The most recently visited Node
		private var targetNode:Node;	// Node we are moving toward
		
		private var moving:Boolean;	// Indicates whether the enemy is currently moving or deciding
		private var lastIntervalTime:Number;	// Stores the global time the last time nextInterval was called
		private var freezeMovement:Boolean; // Whether they should stop moving (because they are drowning)
		private var delayTime:Number;	// Time in milliseconds that movement should stop
		private var poisonTime:Number;	// The time when an enemy was last poisoned
		
		// -- Reinforcement Learning --------------
		private var explorationRate:Number; // The percent of the time to make a random move
		private static var discountRate:Number = 0.9; // gamma in the Q learning equations
		private static var isSARSALearning:Boolean = true;	// True if we are doing SARSA learning, otherwise MaxQ
		private static var lastId:int = 0;	// The last ID given to an enemy
		private var Id:int;	// A unique identifier (for testing and graphing RL things)
		private var currentReward:Number;	// cumulative reward the agent has received since the last decision step
		private var totalReward:Number;		// The total reward this enemy has received over its life
		private var visitedNodes:Array; // The set of nodes already visited
		private var actionIndices:Array; // The set of decisions made at each node
		private var hadGoldMemory:Array;	// Memory of whether the enemy had gold at a particular state
		// ----------------------------------------
		
		// Enemy type/instance variables
		private var health:Number;	// Accessors should ALWAYS be used so that rewards are updated appropriately
		protected var maxHealth:Number;
		protected var goldAmt:Number;
		protected var goldCapacity:Number;
		protected var speed:Number;	// How fast we move		
		protected var poisoned:Number;
		protected var secondsToDieOfPoison:Number;
		protected var poisonTimeout:Number;
		protected var pitSlots:int;	// Number of pit slots this enemy takes up
		
		protected var figure:EFigure;
		
		protected var healthBar:DisplayBar;
		protected var goldCarryingBar:DisplayBar;
		
		public function Enemy(figure:EFigure, startNode:Node, endNode:Node, canvas:Stage, explorationRate:Number, maxHealth:Number) {
			this.x = startNode.x;
			this.y = startNode.y;
			this.canvas = canvas;
			this.goalNode = endNode;
			this.targetNode = startNode;	// Make a decision at the start node first
			this.originNode = startNode;
			this.startNode = startNode;
			this.endNode = endNode;
			
			this.pitSlots = 1;
			this.maxHealth = maxHealth;
			this.health = maxHealth;
			this.goldAmt = 0;
			this.goldCapacity = 10;
			this.speed = 5;
			this.secondsToDieOfPoison = 30;
			this.poisonTimeout = 10;	// Enemies stop being poisoned after this amt of time
			
			this.delayTime = 0;
			this.lastIntervalTime = getTimer();
			this.moving = false;	// We need to make a decision first
			this.freezeMovement = false;
			
			this.figure = figure;
			figure.scaleX = 0.012;
			figure.scaleY = 0.012;
			this.walk();
			addChild(figure);
			figure.x = 3;
			figure.y = 0;
			
			healthBar = new DisplayBar(0xFF0000, 0x00FF00, 1);
			healthBar.scaleY = .3;
			healthBar.scaleX = .3;
			healthBar.x = -10;
			healthBar.y = -20;
			addChild(healthBar);
			
			goldCarryingBar = new DisplayBar(0x333333, 0xFFDD00, 0);
			goldCarryingBar.scaleY = .3;
			goldCarryingBar.scaleX = .3;
			goldCarryingBar.x = -10;
			goldCarryingBar.y = -15;
			addChild(goldCarryingBar);
			
			// -- Reinforcement Learning --------------
			lastId++;
			this.Id = lastId;	// Increment static counter and give a unique Id to this enemy
			this.explorationRate = explorationRate;
			this.currentReward = 0;
			this.totalReward = 0;
			this.visitedNodes = new Array();	// Initialize visited node array
			this.actionIndices = new Array();
			this.hadGoldMemory = new Array();
			// ----------------------------------------
		}
		
		public function getId():int {
			return this.Id;
		}
		
		// "Explores" to a semi-random new node
		private function getExploreDecision(currentNode:Node, prevNode:Node):int {	// Returns Q value of decision
			
			var index:int = Math.floor(Math.random() * currentNode.getNumSiblings());
			var potentialTarget:Node = currentNode.getSibling(index);
			
			// -- Makes exploring less random (won't traverse where we just were generally)
			var attempts:int = 0;
			while(potentialTarget == prevNode && attempts < 2) {	// Try 2 times to not go back exactly where we came from
				index = Math.floor(Math.random() * currentNode.getNumSiblings());
				potentialTarget = currentNode.getSibling(index);
				attempts++;
			}
			
			// Return index of decision
			return index;
		}
		
		// Decides the next node to visit based on the max Q value
		private function getMaxQDecision(currentNode:Node, prevNode:Node):int {	// Returns index of chosen node 
			
			// Loop through open set to find the best candidate to explore next
			var bestNode:Node = null;
			var bestIndex:int = 0;
			var bestQ:Number = Number.NEGATIVE_INFINITY;	// Best Q value we have found
			var bestNotLastIndex:int = -1;
			var bestNotLastQ:Number = Number.NEGATIVE_INFINITY;
			
			// Half the time look backwards, so we don't get stuck picking the same Q each time if they are all the same
			var backwards:Boolean = (Math.random() > 0.5);
			var i:int = (backwards ? currentNode.getNumSiblings() - 1: 0);
			while(i < currentNode.getNumSiblings() && !backwards || i >= 0 && backwards) {
				var node:Node = currentNode.getSibling(i);
				var q:Number = currentNode.getQValue(EnemyManager.getEnemyType(this),this.goldAmt > 0,i);
				
				if(q > bestQ) {
					bestQ = q;
					bestNode = node;
					bestIndex = i;
				}
				
				if(q > bestNotLastQ) {
					if(node != prevNode) {
						bestNotLastQ = q;
						bestNotLastIndex = i;	
					}
				}
				
				if(backwards) {
					i--;
				}
				else {
					i++;
				}
			}
			
			// Return index of decision
			if(bestNotLastIndex >= 0) {
				return bestNotLastIndex;
			}
			else {
				return bestIndex;
			}
		}
		
		// Decide what node to move to next (Uses Reinforcement Learning techniques)
		private function makeDecision():void {
			
			// We want to get out quickly, so it costs reward to make more decisions
			this.currentReward -= 10;
			
			// Decide our next move
			var chosenIndex:int;
			var maxQIndex:int = getMaxQDecision(targetNode,originNode);
			if(Math.random() < explorationRate) {	// Move randomly according to exploration rate
				chosenIndex = getExploreDecision(targetNode,originNode);
			}
			else { // Move according to MaxQ
				chosenIndex = maxQIndex;
			}
			
			// Update Q if we have a Q to update (have made at least 1 decision)
			if(visitedNodes.length > 0) {
				var nextQIndex:int = (Enemy.isSARSALearning ? chosenIndex : maxQIndex);
				var nextQ:Number = targetNode.getQValue(EnemyManager.getEnemyType(this),hadGoldMemory[hadGoldMemory.length - 1],nextQIndex);
				updateQ(nextQ);	
			}
			
			// Add node and decision to visited
			this.visitedNodes.push(targetNode);
			this.hadGoldMemory.push(this.goldAmt > 0);
			this.actionIndices.push(chosenIndex);
			
			// Set most recently visited node to the one we arrived at
			this.originNode = this.targetNode;
			
			// Set target
			this.targetNode = this.targetNode.getSibling(chosenIndex);
			
			// Start moving after we made the decision
			this.moving = true;
			this.walk();
		}
		
		// Called to update the Q value of the previously chosen action
		// Called when an enemy makes a decision or dies
		private function updateQ(nextQ:Number):void {
			var newQ:Number = this.currentReward + Enemy.discountRate * nextQ;	// Calculate the Q value to update at the previous decision
			var lastNode:Node = visitedNodes[visitedNodes.length - 1];
			lastNode.updateQValue(EnemyManager.getEnemyType(this),visitedNodes,hadGoldMemory,actionIndices,newQ);	// Update Q value of last state/action pair	
			
			this.totalReward += currentReward; // Add to total reward
			this.currentReward = 0;	// Reset current reward after Q is updated
		}
		
		// Called before an enemy is removed.  Updates final Q
		public function cleanUp():void {
			updateQ(0);	// Update final decision Q value.  nextQ is 0 because this is the terminal step
		}
		
		// Gets the value of the total reward this enemy has received over its life
		public function getTotalReward():Number {
			return this.totalReward;
		}
		
		// makes the figure walk the correct direction
		private function walk():void {
			if(targetNode.x < this.x) {
				figure.walkLeft();
			}
			else {
				figure.walkRight();
			}
		}
		
		// Moves a small amount
		private function move():void {
			if(targetNode != null && !freezeMovement && delayTime > 0) {
				// Determine distance from target
				var xDist:Number = targetNode.x - this.x;
				var yDist:Number = targetNode.y - this.y;
				var dist:Number = Math.sqrt(Math.pow(xDist,2) + Math.pow(yDist,2));
				
				// Determine total distance between this node and the last
				var distTotal:Number = Math.sqrt(Math.pow(targetNode.x - originNode.x,2) + Math.pow(targetNode.y - originNode.y,2));
				
				// Determine distance traveled since the last
				var distTraveled:Number = Math.sqrt(Math.pow(this.x - originNode.x,2) + Math.pow(this.y - originNode.y,2));
				
				// Update distances
				if(distTraveled >= distTotal) {	// reached the destination node
					this.x = targetNode.x;
					this.y = targetNode.y;
					this.moving = false;
					
					// If we've reached the destination, set target to null
					if(targetNode == goalNode) {
						originNode = targetNode;	// We are now at the target
						figure.stand();	// Standing animation
					}
				}
				else {
					
					var deltaTime:Number = getTimer() - this.lastIntervalTime;
					var multiplier:Number = deltaTime / (1000.0/12);	// 12fps is "target"
					
					this.x += speed/dist * multiplier * xDist;
					this.y += speed/dist * multiplier * yDist;
				}
			}
		}
		
		// Updates the health value, modifying the current reward appropriately
		protected function updateHealth(delta:Number):void {
			this.health += delta;
			this.currentReward += delta;	// Update reward according to health lost/gained (harder to learn due to poison)
		}
		
		// Sets the health value, modifying the current reward appropriately
		protected function setHealth(healthValue:Number):void {
			var newHealth:Number = Math.max(Math.min(healthValue,this.maxHealth),0);
			var delta:Number = newHealth - this.health;
			updateHealth(delta);
		}
		
		// At every time interval, determines whether to move or decide next movement.  Called by EnemyManager
		public function nextTimeInterval():void	{
			
			// Deal poison damage
			if(poisoned != 0) {
				var poisonedElapsed:Number = getTimer() - this.poisonTime;
				if(poisonedElapsed < this.poisonTimeout * 1000) {
					this.updateHealth(-1 * this.maxHealth * poisoned * ((getTimer() - this.lastIntervalTime) / (this.secondsToDieOfPoison * 1000)));
					healthBar.update(health/maxHealth);
				}
				else {
					this.poisoned = 0;
					this.figure.poison(false);
				}
			}
			
			// Pass ourselves to processEnemy on the 2 nodes we are between so we take damage, etc
			if(originNode != null) {
				originNode.processEnemy(this);
			}
			if(targetNode != null) {
				targetNode.processEnemy(this);
			}
			
			if(moving) {
				move();
			}
			else {
				makeDecision();
			}
			
			// Update last interval time to keep movement framerate independent
			this.delayTime -= (this.lastIntervalTime - getTimer());
			this.lastIntervalTime = getTimer();
		}
		
		public function getOriginNode():Node {
			return this.originNode;
		}
		
		public function getHealth():Number {
			return this.health;
		}
		public function isDead():Boolean
		{
			return this.health == 0;
		}
		
		public function getGold():Number {
			return this.goldAmt;
		}
		
		// Gives gold to the enemy.  Number returned is amt of gold left after enemy takes as much as he can carry
		public function giveGold(goldAm:Number, alwaysPositive:Boolean = false):Number {
			
			// Amount of gold that can still be carried
			var goldAdded:Number = Math.max(Math.min(this.goldCapacity - this.goldAmt,goldAm),this.goldAmt * -1 /* dont take away more gold than we have */);
			this.goldAmt += goldAdded;
			
			var goldLeft:Number = goldAm - goldAdded;
			
			// Add reward for getting gold (don't give a negative reward for taking it away unless "alwaysPositive" i.e. we're at the start room)
			this.currentReward += (alwaysPositive ? Math.abs(10 * goldAdded) : Math.max(10 * goldAdded,0));
			
			goldCarryingBar.update(this.goldAmt/goldCapacity);			
			return goldLeft;
		}
		
		// ------ Functions that affect enemy in game - overridden by children if necessary -----
		
		// The enemy starts drowning
		public function freeze(frozen:Boolean, freezingNode:Node):Boolean {
			freezeMovement = frozen;
			if(frozen) {
				this.x = freezingNode.x;
				this.y = freezingNode.y;
			}
			return true;	// by default, enemies will freeze if a node wants them to
		}
		
		// enemy stays at node for x milliseconds
		public function setDelay(x:Number):Boolean {
			this.delayTime = x;
			return true;
		}
		
		public function killSpikes():Boolean {
			this.setHealth(0);
			healthBar.update(health/maxHealth);
			return true;
		}
		
		public function quicksand():Boolean {
			this.setHealth(0);
			healthBar.update(health/maxHealth);
			return true;
		}

		public function damageFire():Boolean {
			this.updateHealth(-75);
			healthBar.update(health/maxHealth);
			return true;
		}
		public function totalBurn():Boolean {
			this.setHealth(0);
			healthBar.update(health/maxHealth);
			return true;
		}
		
		public function poison(amnt:Number):Boolean {
			this.currentReward -= 20 * amnt;
			this.poisoned = amnt;
			this.figure.poison(true);
			this.poisonTime = getTimer();
			return true;	// By default enemies can be poisoned
		}
		
		public function isPoisoned():Number {
			return this.poisoned;
		}
		
		public function getPitSlots():int {
			return this.pitSlots;
		}
		// ----------------
	}
}