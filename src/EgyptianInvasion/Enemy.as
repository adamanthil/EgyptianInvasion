// An enemy trying to find the pharaoh's treasure
package EgyptianInvasion
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.BitmapAsset;
	
	public class Enemy extends Sprite
	{
		private var canvas:Stage;
		private var time:Timer;
		private var startNode:Node;	// The fist node we start at
		private var endNode:Node;	// Our eventual goal
		private var originNode:Node;	// The most recently visited Node
		private var targetNode:Node;	// Node we are moving toward
		private var moving:Boolean;	// Indicates whether the enemy is currently moving or deciding
		private var speed:Number;	// How fast we move
		private var visitedNodes:Array; // The set of nodes already visited
		private var distTraveled:Number;	// The distance we have traveled so far
		
		private var health:Number;
		
		// Adds a reference to a bitmap at compile-time
		[Embed(source="../assets/img/enemy.jpg")] private var BGImage:Class;
		
		private var figure:EFigure;
		
		public function Enemy(startNode:Node, endNode:Node, canvas:Stage) {
			this.x = startNode.x;
			this.y = startNode.y;
			this.canvas = canvas;
			this.endNode = endNode;
			this.targetNode = startNode;	// Make a decision at the start node first
			this.originNode = startNode;
			this.startNode = startNode;
			
			this.health = 100;
			this.speed = 1;
			this.moving = false;	// We need to make a decision first
			this.visitedNodes = new Array();	// Initialize visited node array
			
			figure = new EFigure(-3,-3,canvas);
			figure.scaleX = 0.02;
			figure.scaleY = 0.02;
			figure.walk();
			addChild(figure);
			
			// Load embedded background image from file and set size
			/*var photo:BitmapAsset = new BGImage();
			photo.scaleX = 0.01;
			photo.scaleY = 0.01;
			photo.x = -3;
			photo.y = -3;
			addChild(photo);
			
			// Draw yellow square0
			graphics.beginFill(0xFFFF00);
			graphics.drawRect(-4,-4,8,8);
			graphics.endFill();*/
			
			time = new Timer(10);
			time.addEventListener(TimerEvent.TIMER,timeListener);
			time.start();
			
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
						
						var remainingEstimate:Number = Math.sqrt(Math.pow(node.x - endNode.x,2) + Math.pow(node.y - endNode.y,2));
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
				if(distTraveled >= distTotal) {//reach
					this.x = targetNode.x;
					this.y = targetNode.y;
					this.moving = false;
					
					
					// If we've reached the destination, set target to null
					if(targetNode == endNode) {
						figure.stand();
						targetNode = null;
					}
				}
				else {
					this.x += speed/dist * xDist;
					this.y += speed/dist * yDist;
				}
			}
		}
		
		// At every time interval, determines whether to move or decide next movement
		public function timeListener(e:TimerEvent):void	{
			
			// Pass ourselves to processEnemy on the 2 nodes we are between so we take damage, etc
			originNode.processEnemy(this);
			targetNode.processEnemy(this);
			
			if(moving) {
				move();
			}
			else {
				makeDecision();
			}
		}
		
		public function getHealth():Number {
			return this.health;
		}
		
		// ------ Functions that affect enemy in game - overridden by children if necessary -----
		
		// The enemy starts drowning
		public function setDrowning():Boolean {
			this.health = 0;
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
			
			asd
			fa
			sdf
			asd
			fa
			sdf
			as
			dfd
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