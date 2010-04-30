package EgyptianInvasion
{
	import assets.ToggleButton;
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	import mx.core.BitmapAsset;
	
	public class FireRoom extends Node
	{
		[Embed(source="../assets/img/fireIconic.jpg")]
		private var RoomImage:Class;
		private var roomImage:BitmapAsset;
		private var deadGuys:Number;
		private var onFire:Boolean;
		private var fireTimeLeft:Number;
		
		public function FireRoom(nodex:Number, nodey:Number, canvas:Stage, refup:NodeManager)
		{
			onFire = false;
			fireTimeLeft = 0;
			super(nodex,nodey,canvas, refup);
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
			size = 20;
			time.start();
			nodes = new Array();
			isConnectable = false;
		}
		public override function onPlaced(sup:NodeManager):void
		{
			if((nodes[0] as Node).x < x)
			{
				var inbetween:Node = new Node(x - 20, y, canvas,sup);
				(nodes[0] as Node).addSibling(inbetween);
				sup.addNodeDirect(inbetween);
				inbetween.addSibling(nodes[0] as Node);
				inbetween.addSibling(this);
				(nodes[0] as Node).removeSibling(this);
				this.addSibling(inbetween);
				this.removeSibling(nodes[0]);
				
				var otherSide:Node = new Node(x+20,y,canvas,sup);
				this.addSibling(otherSide);
				sup.addNodeDirect(otherSide);
				otherSide.addSibling(this);
				inbetween.setPlaced(true);
				otherSide.setPlaced(true);
			}
			else
			{
				var inbetween:Node = new Node (x + 20, y, canvas, sup);
				(nodes[0] as Node).addSibling(inbetween);
				sup.addNodeDirect(inbetween);
				inbetween.addSibling(nodes[0] as Node);
				inbetween.addSibling(this);
				(nodes[0] as Node).removeSibling(this);
				this.addSibling(inbetween);
				this.removeSibling(nodes[0]);
				
				var otherSide:Node = new Node(x-20,y,canvas, sup);
				this.addSibling(otherSide);
				sup.addNodeDirect(otherSide);
				otherSide.addSibling(this);
				inbetween.setPlaced(true);
				otherSide.setPlaced(true);
			}
			var fireButton:Button = new Button(new assets.ToggleButton(),x,y+15,"firebutton",canvas,sup.parent as Main);
			fireButton.addEventListener(MouseEvent.CLICK, fireTrigger);
			this.addChild(fireButton);
			roomImage.x = -15;
		}
		public var fireTrigger:Function = function (e:MouseEvent):void {
			var button:Button = Button(e.currentTarget);
			
			if (!button.isDown() && fireTimeLeft < -1000){
				this.trigger();				
			}
		}
		public override function displayFaded():void
		{
			graphics.clear();
			roomImage.alpha  = .5;
			if(isValid)
				this.blendMode = BlendMode.SUBTRACT;
			else
				this.blendMode = BlendMode.SCREEN;
		}
		public override function drawToPointX():Number
		{
			if(!placed &&(nodes[0] as Node).x < x)
			{
				return x - 20;
			}
			else if (!placed)
			{
				return x + 20;
			}
			return x;
		}
		public override function processEnemy(guy:Enemy):Boolean
		{
			/*if(Math.sqrt(Math.pow(guy.x - x,2) + Math.pow(guy.y - y, 2)) < size && guy.hasBeenOutside())
			{
				if(!guy.isDead())
				{
					if(onFire)
						guy.fireAttack();
					if(guy.isDead())
						deadGuys++;
				}
				if(triggerNode != null && !guy.isDead())
					triggerNode.trigger();
				return true;
			}
			else
			{
				return false
			}*/
			return false;
		}
		public override function TimeListener(e:TimerEvent):void	{
			if(placed)
				displaySolid();
			else
				displayFaded();

				fireTimeLeft--;
			if(fireTimeLeft <0)
				onFire = false;
		}
		public override function trigger():void
		{
			onFire = true;
			fireTimeLeft = 1000;
		}
		public override function getImpassible():Boolean
		{
			return false;
		}
		public function getOnFire():Boolean
		{
			return this.onFire;
		}
		public override function displaySolid():void
		{
			this.blendMode = BlendMode.NORMAL;
			graphics.clear();
			roomImage.alpha = 1;
			if(this.triggerNode != null)
			{
				graphics.moveTo(0,0);
				graphics.lineStyle(1, 0x00FF00);
				
				graphics.lineTo(triggerNode.drawToPointX(),triggerNode.drawToPointY());
				graphics.moveTo(0,0);
			}
		}
		public override function mouseMoveListener(e:MouseEvent):void {
			if(!placed)
			{
				x = e.stageX;
				y = e.stageY;
				if(e.stageX > (nodes[0] as Node).x)
					x += 20;
				else
					x -= 20;
			} 
		}
	}
}