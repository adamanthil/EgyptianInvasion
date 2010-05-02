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
		private var moving:Boolean;	// Indicates whether the enemy is currently moving or deciding
		private var speed:Number;	// How fast we move
		private var visitedNodes:Array; // The set of nodes already visited
		private var distTraveled:Number;	// The distance we have traveled so far

		private var lastIntervalTime:Number;	// Stores the global time the last time nextInterval was called
		
		private var health:Number;
		private var goldAmt:Number;
		private var goldCapacity:Number;
		
		// Adds a reference to a bitmap at compile-time
		[Embed(source="../assets/img/enemy.jpg")] private var BGImage:Class;
		
		private var figure:EFigure;
		
		public function Enemy(startNode:Node, endNode:Node, canvas:Stage) {
			this.x = startNode.x;
			this.y = startNode.y;
			this.canvas = canvas;
			this.goalNode = endNode;
			this.targetNode = startNode;	// Make a decision at the start node first
			this.originNode = startNode;
			this.startNode = startNode;
			
			this.health = 100;
			this.goldAmt = 0;
			this.goldCapacity = 10;
			
			this.speed = 10;
			this.moving = false;	// We need to make a decision first
			this.visitedNodes = new Array();	// Initialize visited node array
			
			figure = new EFigure(-3,-3,canvas);
			figure.scaleX = 0.02;
			figure.scaleY = 0.02;
			figure.walk();
			addChild(figure);
		}
		
		// Decide what node to move to next
		private function makeDecision():void {
			// ---- Vaguely inspired by A* but modified to mimic an actual exploring agent -----------
			
			if(targetNode != null) {
				
				// Make a random move 20% of the time
				if(Math.random() > 0.20) {
					
					// Add node to visited nodes
					this.visitedNodes.push(targetNode);
					
					var siblings:Array = targetNode.getSiblings();
					var index:int = Math.floor(Math.random() * siblings.length);
					var potentialTarget:Node = Node(siblings[index]);
					var attempts:int = 0;
					while((potentialTarget == originNode || potentialTarget == startNode) && attempts < 5) {	// Make sure we don't go back exactly where we came from
						index = Math.floor(Math.random() * siblings.length);
						potentialTarget = siblings[index];
						attempts++;
					}
					
					// Set most recently visited node to the one we arrived at
					this.originNode = this.targetNode;
					
					this.targetNode = potentialTarget;
					this.moving = true;
				}
				else {
					// Determine distance traveled from previous node
					var prevXDist:Number = x - originNode.x;
					var prevYDist:Number = y - originNode.y;
					var prevDist:Number = Math.sqrt(Math.pow(prevXDist,2) + Math.pow(prevYDist,2));
					this.distTraveled += prevDist;
					
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
			}
		}
		
		// Moves a small amount
		private function move():void {
			if(targetNode != null) {
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
						targetNode = null;
					}
				}
				else {
					var deltaTime:Number = getTimer() - this.lastIntervalTime;
					var multiplier:Number = deltaTime / (1000.0/50);	// 50fps is "target"
					
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
		public function giveGold(goldAmt:int):Number {
			
			// Amount of gold that can still be carried
			var goldAdded:Number = this.goldCapacity - this.goldAmt;
			this.goldAmt += goldAdded;
			
			var goldLeft:Number = goldAmt - goldAdded;
			
			// If we have gold, move toward the exit
			if(goldAmt > 0) {
				this.goalNode = this.startNode;
			}
			else {
				this.goalNode = this.endNode;
			}
			
			// We need to make a new decision if we changed our goal
			this.moving = false;
			
			return goldLeft;
		}
		
		// ------ Functions that affect enemy in game - overridden by children if necessary -----
		
		// The enemy starts drowning
		public function setDrowning(drown:Boolean):Boolean {
			return true;
		}
		
		// enemy stays at node for x milliseconds
		public function setDelay(x:Number):Boolean {
			return true;
		}
		
		public function killSpikes():Boolean {
			this.health = 0;
			return true;
		}
		
		public function quicksand():Boolean {
			this.health = 0;
			return true;
		}

		public function damageFire():Boolean {
			this.health = 0;
			return true;
		}
		
		public function damageSnakes():Boolean {
			this.health = 0;
			return true;
		}
		
		// ----------------
	}
}