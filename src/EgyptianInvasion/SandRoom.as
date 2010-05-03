package EgyptianInvasion
{
	import assets.ToggleButton;
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	import mx.core.BitmapAsset;
	
	public class SandRoom extends Trap
	{
		[Embed(source="../assets/img/quicksandIconic.jpg")]
		protected var RoomImage:Class;
		private var currentDrowning:Enemy;
		private var drowningCool:Number;
		
		private var drowningBar:DisplayBar;
		
		public function SandRoom(nodex:Number, nodey:Number, canvas:Stage, refup:NodeManager)
		{
			drowningBar = new DisplayBar(0x330000,0x663300,0);
			drowningCool = 0;
			currentDrowning = null;
			currentInside = new Array();
			super(nodex,nodey,canvas, refup);
			roomImage  = new RoomImage();
			roomImage.scaleX = 0.6;
			roomImage.scaleY = 0.6;
			roomImage.x = -15;
			roomImage.y = -15;
			addChild(roomImage);
			value = 5;
			
			graphics.beginFill(0x00FF00,.5);
			graphics.drawRect(roomImage.x,roomImage.y,roomImage.width,roomImage.height);
			//this.cacheAsBitmap = true;
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
			roomImage.x = -15;
			
			this.addChild(drowningBar);
			drowningBar.x = -15;
			drowningBar.y = 15;
			drowningBar.scaleY = .3;
			drowningBar.scaleX = .5;
			
		}
		protected override function displayFaded():void
		{
			graphics.clear();
			roomImage.alpha  = .5;
			if(isValid)
				this.blendMode = BlendMode.SUBTRACT;
			else
				this.blendMode = BlendMode.SCREEN;
		}
		protected override function TimeListener(e:TimerEvent):void	{
			if(drowningCool >= 0)
			{
				drowningBar.update((20-drowningCool)/20);
				drowningCool --;
			}
			else if(currentDrowning != null && currentDrowning.quicksand())
			{
				this.removeGuy(currentDrowning);
//				(currentDrowning.parent as EnemyManager).removeEnemy(currentDrowning);
				currentDrowning = null;
			}
			if(currentDrowning == null)
				drowningBar.update(0);
			if(placed)
				displaySolid();
			else
				displayFaded();
			
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
			if(Math.sqrt(Math.pow(guy.x - x,2) + Math.pow(guy.y - y, 2)) < size)
			{
				if(currentInside.indexOf(guy) == -1)
					addGuy(guy);
				if(currentDrowning == null && guy.setDrowning(true) && currentInside.length < 2 )
				{
					currentDrowning = guy;
					drowningCool = 20;
				}
				else if(currentDrowning != null && guy != currentDrowning && guy.setDelay(200))
				{
					currentDrowning = null;
					guy.setDrowning(false);
				}
				if(triggerNode != null && !guy.isDead())
					triggerNode.trigger();
				if(!guy.isDead() &&this.goldWithin > 0 )
					goldWithin = guy.giveGold(goldWithin,this);
				return true;
			}
			else
			{
				removeGuy(guy);
				trace(currentInside.length);
				return false
			}
			return false;
		}
	}
}