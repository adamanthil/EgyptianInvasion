// An enemy trying to find the pharaoh's treasure
package EgyptianInvasion
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Enemy extends Sprite
	{
		private var canvas:Stage;
		private var time:Timer;
		private var moving:Boolean;	// Indicates whether the enemy is currently moving or deciding
		private var targetNode:Node;	// Node we are moving toward
		private var speed:Number;	// How fast we move
		
		public function Enemy(startNode:Node, canvas:Stage) {
			this.x = startNode.x;
			this.y = startNode.y;
			this.canvas = canvas;
			this.speed = 1;
			this.moving = false;	// We need to make a decision first
			
			graphics.beginFill(0xFFFF00);
			graphics.drawRect(-4,-4,8,8);
			graphics.endFill();
			
			time = new Timer(10);
			time.addEventListener(TimerEvent.TIMER,timeListener);
			time.start();
			
		}
		
		// Decide where to move next
		private function makeDecision():void {
			
		}
		
		// Moves a small amount
		private function move():void {
			
		}
		
		// At every time interval, determines whether to move or decide next movement
		public function timeListener(e:TimerEvent):void	{
			move();
		}
	}
}