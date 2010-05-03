package EgyptianInvasion
{
	import flash.display.*;
	import flash.display.Stage;
	import flash.events.*;
	import flash.utils.Timer;
	public class NodePaths extends Sprite
	{
		
		private var sup:NodeManager
		private var canvas:Stage;
		public function NodePaths(refup:NodeManager)
		{
			this.blendMode = BlendMode.ERASE;
			sup = refup;
			canvas = sup.getCanvas();
		}
		public function update():void
		{
			graphics.clear();
			for(var i:Number = 0; i <sup.getNodes().length; i++)
			{
				var int:Number;
				int = 0;
				var node:Node = sup.getNodes()[i] as Node;
				var nodes:Array =(sup.getNodes()[i] as Node).getSiblings(); 
				while(int < nodes.length)
				{
					graphics.moveTo(node.drawToPointX(),node.drawToPointY());
					graphics.lineStyle(10, 0xFF0000);
					if(!(nodes[int] as Node).isPlaced())
						graphics.lineStyle(10, 0xFF0000,1);
					
					graphics.lineTo((nodes[int] as Node).drawToPointX(),(nodes[int] as Node).drawToPointY());
					graphics.moveTo(0,0);
					int++;
				}
			}
		}
	}
}