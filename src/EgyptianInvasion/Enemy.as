// An enemy trying to find the pharaoh's treasure
package EgyptianInvasion
{
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class Enemy extends Sprite
	{
		private var canvas:Stage;
		
		public function Enemy(startNode:Node, canvas:Stage)
		{
			this.x = startNode.x;
			this.y = startNode.y;
			this.canvas = canvas;
			
			graphics.beginFill(0xFFFF00);
			graphics.drawRect(-4,-4,8,8);
			graphics.endFill();
			
		}
	}
}