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
		private var endNode:Node;	// Our eventual goal
		
		private var moving:Boolean;	// Indicates whether the enemy is currently moving or deciding
		private var targetNode:Node;	// Node we are moving toward
		private var speed:Number;	// How fast we move
		
		// Adds a reference to a bitmap at compile-time
		[Embed(source="../assets/img/enemy.jpg")] private var BGImage:Class;
		
		public function Enemy(startNode:Node, endNode:Node, canvas:Stage) {
			this.x = startNode.x;
			this.y = startNode.y;
			this.canvas = canvas;
			this.endNode = endNode;
			this.speed = 1;
			this.moving = false;	// We need to make a decision first
			
			// Load embedded background image from file and set size
			var photo:BitmapAsset = new BGImage();
			photo.scaleX = 0.01;
			photo.scaleY = 0.01;
			photo.x = -3;
			photo.y = -3;
			addChild(photo);
			
			// Draw yellow square0
			graphics.beginFill(0xFFFF00);
			graphics.drawRect(-4,-4,8,8);
			graphics.endFill();
			
			time = new Timer(10);
			time.addEventListener(TimerEvent.TIMER,timeListener);
			time.start();
			
		}
		
		// Decide where to move next
		private function makeDecision():void {
			this.targetNode = endNode;
			this.moving = true;
		}
		
		// Moves a small amount
		private function move():void {
			// Determine direction of node
			var xDist:Number = targetNode.x - this.x;
			var yDist:Number = targetNode.y - this.y;
			var dist:Number = Math.sqrt(Math.pow(xDist,2) + Math.pow(yDist,2));
			
			// Update distances
			if(xDist < speed/dist && yDist < speed/dist) {
				// If it's close set it exactly
				this.x = targetNode.x;
				this.y = targetNode.y;
				this.moving = false;
			}
			else {
				this.x += speed/dist * xDist;
				this.y += speed/dist * yDist;
			}
		}
		
		// At every time interval, determines whether to move or decide next movement
		public function timeListener(e:TimerEvent):void	{
			if(moving) {
				move();
			}
			else {
				makeDecision();
			}
		}
	}
}