// An enemy trying to find the pharaoh's treasure
package EgyptianInvasion
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.*;
	
	import org.osmf.events.TimeEvent;
	
	public class Enemy extends Sprite
	{
		private var canvas:Stage;
		private var startNode:Node;	// The fist node we start at
		private var endNode:Node;	// The end/tomb node where the gold exists
		private var goalNode:Node;	// Our eventual goal
		private var originNode:Node;	// The most recently visited Node
		private var targetNode:Node;	// Node we are moving toward
		private var visitedNodes:Array; // The set of nodes already visited
		
		private var moving:Boolean;	// Indicates whether the enemy is currently moving or deciding
		private var lastIntervalTime:Number;	// Stores the global time the last time nextInterval was called
		private var freezeMovement:Boolean; // Whether they should stop moving (because they are drowning)
		private var delayTime:Number;	// Time in milliseconds that movement should stop
		
		private var health:Number;
		private var maxHealth:Number;
		private var goldAmt:Number;
		private var goldCapacity:Number;
		private var speed:Number;	// How fast we move		
		private var figure:EFigure;
		
		private var healthBar:DisplayBar;
		private var goldCarryingBar:DisplayBar;
		
		public function Enemy(startNode:Node, endNode:Node, canvas:Stage) {
			this.x = startNode.x;
			this.y = startNode.y;
			this.canvas = canvas;
			this.goalNode = endNode;
			this.targetNode = startNode;	// Make a decision at the start node first
			this.originNode = startNode;
			this.startNode = startNode;
			this.endNode = endNode;
			
			this.maxHealth = 100;
			this.health = 100;
			this.goldAmt = 0;
			this.goldCapacity = 10;
			this.speed = 5;
			
			this.delayTime = 0;
			this.lastIntervalTime = getTimer();
			this.moving = false;	// We need to make a decision first
			this.freezeMovement = false;
			this.visitedNodes = new Array();	// Initialize visited node array
			
			figure = new EFigure(-3,-3,canvas);
			figure.scaleX = 0.02;
			figure.scaleY = 0.02;
			figure.walk();
			addChild(figure);
			
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
		}
		
		// "Explores" to a semi-random new node
		private function makeExploreDecision(reachedGoal:Boolean = false):void {
			
			// If we have reached our goal, use the goal node as the target
			var reachedNode:Node;
			if(reachedGoal) {
				reachedNode = goalNode;
			}
			else {
				reachedNode = targetNode;
			}
			
			// Add node to visited nodes
			this.visitedNodes.push(reachedNode);
			
			var siblings:Array = reachedNode.getSiblings();
			var index:int = Math.floor(Math.random() * siblings.length);
			var potentialTarget:Node = Node(siblings[index]);
			var attempts:int = 0;
			while((potentialTarget == originNode || potentialTarget == startNode) && attempts < 5) {	// Try 5 times to not go back exactly where we came from
				index = Math.floor(Math.random() * siblings.length);
				potentialTarget = siblings[index];
				attempts++;
			}
			
			// Set most recently visited node to the one we arrived at
			this.originNode = reachedNode;
			
			this.targetNode = potentialTarget;
			this.moving = true;
		}
		
		// Heuristically decides the next node to visit
		private function makeHeuristicDecision():void {
			this.visitedNodes.push(targetNode);
			
			// Loop through open set to find the best candidate to explore next
			var bestNode:Node = null;
			var bestUnvisitedNode:Node = null;
			var bestNotLastNode:Node = null;	// Best node that isn't the one we just came from
			var bestNotLastHeuristic:Number = Number.MAX_VALUE;
			var bestUnvisitedHeuristic:Number = Number.MAX_VALUE;
			var bestHeuristic:Number = Number.MAX_VALUE;	// Estimated distance to the goal for visiting the node
			for(var i:int = 0; i < targetNode.getSiblings().length; i++) {
				var node:Node = targetNode.getSiblings()[i];
				var dist:Number = Math.sqrt(Math.pow(x - node.x,2) + Math.pow(y - node.y,2));
				
				var remainingEstimate:Number = Math.sqrt(Math.pow(node.x - goalNode.x,2) + Math.pow(node.y - goalNode.y,2));
				var distEstimate:Number = dist + remainingEstimate;
				
				// Save if best node (and not where we are)
				if(distEstimate < bestHeuristic && node != targetNode) {
					bestHeuristic = distEstimate;
					bestNode = node;
				}
				
				// Save best node that is not the last node
				if(distEstimate < bestNotLastHeuristic && node != originNode) {
					bestNotLastHeuristic = distEstimate;
					bestNotLastNode = node;
				}
				
				// Save if unvisited and best
				if(visitedNodes.indexOf(node) < 0 && distEstimate < bestUnvisitedHeuristic) {
					bestUnvisitedHeuristic = bestHeuristic;
					bestUnvisitedNode = node;
				}
			}
			
			// Set most recently visited node to the one we arrived at
			this.originNode = this.targetNode;
			
			// Set target and start moving again
			this.moving = true;
			// First try unvisited, then not last, then best overall
			if(bestUnvisitedNode != null) {
				this.targetNode = bestUnvisitedNode
			}
			else if(bestNotLastNode != null) {
				this.targetNode = bestNotLastNode;
			}
			else {
				this.targetNode = bestNode;
			}
		}
		
		// Decide what node to move to next
		private function makeDecision():void {
			// ---- Vaguely inspired by A* but modified to mimic an actual exploring agent -----------
			
			// If no target node (because we reached it). Wait 10 cycles (in case we are given gold by the node) and then start exploring
			if(targetNode == null) {
				makeExploreDecision(true);	// Explore without a goal 
			}
			else {	// There is a target mode
				// Make a random move 20% of the time if branching factor > 2
				if(Math.random() > 0.20 && targetNode.getSiblings().length > 2) {
					makeExploreDecision();
				}
				else {
					makeHeuristicDecision();
				}
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
						figure.stand();
						originNode = targetNode;	// We are now at the target
						targetNode = null;
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
		
		// At every time interval, determines whether to move or decide next movement.  Called by EnemyManager
		public function nextTimeInterval():void	{
			
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
		public function giveGold(goldAm:Number):Number {
			
			// Amount of gold that can still be carried
			var goldAdded:Number = Math.max(Math.min(this.goldCapacity - this.goldAmt,goldAm),this.goldAmt * -1 /* dont take away more gold than we have */);
			this.goldAmt += goldAdded;
			
			var goldLeft:Number = goldAm - goldAdded;
			
			// If we have gold, move toward the exit
			if(goldAmt > 0) {
				this.goalNode = this.startNode;
				this.visitedNodes = new Array();
			}
			else {
				this.goalNode = this.endNode;
			}
			
			// We need to make a new decision if we changed our goal
			//this.moving = false;
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
			this.health = 0;
			healthBar.update(health/maxHealth);
			return true;
		}
		
		public function quicksand():Boolean {
			this.health = 0;
			healthBar.update(health/maxHealth);
			return true;
		}

		public function damageFire():Boolean {
			this.health -= 25;
			healthBar.update(health/maxHealth);
			return true;
		}
		
		public function damageSnakes():Boolean {
			this.health = 0;
			healthBar.update(health/maxHealth);
			return true;
		}
		
		// ----------------
	}
}