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
				//var nodes:Array =(sup.getNodes()[i] as Node).getSiblings();
				while(int < node.getNumSiblings())
				{
					graphics.moveTo(node.drawToPointX(),node.drawToPointY());
					graphics.lineStyle(10, 0xFF0000);
					if(!node.getSibling(int).isPlaced()) {
						graphics.lineStyle(10, 0xFF0000,1);
					}
					graphics.lineTo(node.getSibling(int).drawToPointX(),node.getSibling(int).drawToPointY());
					graphics.moveTo(0,0);
					int++;
				}
			}
		}
	}
}