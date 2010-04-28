package EgyptianInvasion
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	import mx.core.BitmapAsset;
	
	public class SnakeRoom extends Node
	{
		[Embed(source="../assets/img/snakeIconic.jpg")]
		private var RoomImage:Class;
		private var roomImage:BitmapAsset;
		public function SnakeRoom(nodex:Number, nodey:Number, canvas:Stage)
		{
			super(nodex,nodey,canvas);
			roomImage  = new RoomImage();
			roomImage.scaleX = 0.6;
			roomImage.scaleY = 0.6;
			roomImage.x = -15;
			roomImage.y = -15;
			addChild(roomImage);
			//this.cacheAsBitmap = true;
			this.blendMode = BlendMode.LAYER;
			canvas = canvas;
			x = nodex;
			y = nodey;
			size = 10;
			time.start();
			nodes = new Array();
			isConnectable = false;
		}
		public override function onPlaced(sup:NodeManager):void
		{
			if((nodes[0] as Node).x < x)
			{
				x = x + 20;
				var inbetween:Node = new Node(x - 20, y, canvas);
				(nodes[0] as Node).addSibling(inbetween);
				sup.addNodeDirect(inbetween);
				inbetween.addSibling(nodes[0] as Node);
				inbetween.addSibling(this);
				(nodes[0] as Node).removeSibling(this);
				this.removeSibling(nodes[0]);
				this.addSibling(inbetween);
				this.removeSibling(nodes[0]);
				
				var otherSide:Node = new Node(x+20,y,canvas);
				this.addSibling(otherSide);
				sup.addNodeDirect(otherSide);
				otherSide.addSibling(this);
				inbetween.setPlaced(true);
				otherSide.setPlaced(true);
			}
			else
			{
				x = x - 20;
				var inbetween:Node = new Node (x + 20, y, canvas);
				(nodes[0] as Node).addSibling(inbetween);
				sup.addNodeDirect(inbetween);
				inbetween.addSibling(nodes[0] as Node);
				inbetween.addSibling(this);
				(nodes[0] as Node).removeSibling(this);
				this.addSibling(inbetween);
				this.removeSibling(nodes[0]);
				
				var otherSide:Node = new Node(x-20,y,canvas);
				this.addSibling(otherSide);
				sup.addNodeDirect(otherSide);
				otherSide.addSibling(this);
				inbetween.setPlaced(true);
				otherSide.setPlaced(true);
			}
			roomImage.x = -15;
		}
		public override function onInside(guys:EnemyManager):void
		{
			
		}
		public override function displayFaded():void
		{
			graphics.clear();
			roomImage.alpha  = .5;
		}
		public override function displaySolid():void
		{
			graphics.clear();
			roomImage.alpha = 1;
		}
		public override function mouseMoveListener(e:MouseEvent):void {
			if(!placed)
			{
				x = e.stageX;
				y = e.stageY;
				if(e.stageX > (nodes[0] as Node).x)
					roomImage.x = 5;
				else
					roomImage.x = -35
			} 
		}
	}
}