// An enemy trying to find the pharaoh's treasure
package EgyptianInvasion
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class Enemy extends Sprite
	{
		private var canvas:Stage;
		private var time:Timer;
		
		
		public function Enemy(startNode:Node, canvas:Stage)
		{
			this.x = startNode.x;
			this.y = startNode.y;
			this.canvas = canvas;
			
			graphics.beginFill(0xFFFF00);
			graphics.drawRect(-4,-4,8,8);
			graphics.endFill();
			
			time = new Timer(10);
			time.addEventListener(TimerEvent.TIMER,timeListener);
			time.start();
			
		}
		
		private function makeDecision():void {
			
		}
		
		private function takeStep():void {
			
		}
		
		public function timeListener(e:TimerEvent):void	{
			takeStep();
		}
	}
}