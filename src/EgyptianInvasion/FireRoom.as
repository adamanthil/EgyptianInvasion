package EgyptianInvasion
{
	import assets.ToggleButton;
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	import mx.core.BitmapAsset;
	
	public class FireRoom extends Trap
	{
		[Embed(source="../assets/img/fireIconic.jpg")]
		private var RoomImage:Class;
		private var fireTimeLeft:Number = 0;
		
		[Embed(source="../assets/img/fireIconicDeactive.jpg")]
		private var DeactivateImage:Class;
		private var deactivateImage:BitmapAsset;
		private var button:Button;
		
		private var fireCoolBar:DisplayBar;
		private var fireBlastBar:DisplayBar;
		
		public function FireRoom(nodex:Number, nodey:Number, canvas:Stage, refup:NodeManager)
		{
			fireCoolBar = new DisplayBar(0xF00F00,0x888888,1);
			fireBlastBar = new DisplayBar(0xAAAAAA,0xFF6600,1);
			fireTimeLeft = 0;
			super(nodex,nodey,canvas, refup);
			
			
			deactivateImage  = new DeactivateImage();
			deactivateImage.scaleX = 0.6;
			deactivateImage.scaleY = 0.6;
			deactivateImage.x = -15;
			deactivateImage.y = -15;
			addChild(deactivateImage);
			
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
			var activeButton:Button = new Button(new assets.ToggleButton(),0,-20,"fire button",canvas,sup.parent as Main);
			activeButton.addEventListener(MouseEvent.CLICK, activeTrigger);
			activeButton.scaleX = .3;
			activeButton.scaleY = .3;
			this.addChild(activeButton);
			button = activeButton;
			roomImage.x = -15;
			this.addChild(fireCoolBar);
			fireCoolBar.x = -15;
			fireCoolBar.y = 10;
			fireCoolBar.scaleY = .3;
			fireCoolBar.scaleX = .5;
			
			this.addChild(fireBlastBar);
			fireBlastBar.x = -15;
			fireBlastBar.y = 15;
			fireBlastBar.scaleY = .3;
			fireBlastBar.scaleX = .5;
		}
		public function activeTrigger(e:MouseEvent):void {
			var button:Button = Button(e.currentTarget);
			
			if (!button.isDown() && fireTimeLeft < -25){
				this.trigger();				
			}
		}
		public override function processEnemy(guy:Enemy):Boolean
		{
			if(Math.sqrt(Math.pow(guy.x - x,2) + Math.pow(guy.y - y, 2)))
			{
				if(!guy.isDead() && this.active)
				{
					if(currentInside.indexOf(guy) == -1)
					{
						guy.damageFire();
						this.addGuy(guy);
					}
					if(guy.isDead())
					{
						deadGuys++;	
					}
					else
					{
						if( this.goldWithin > 0 )
							goldWithin = guy.giveGold(goldWithin,this);
					}
				}
				if(triggerNode != null && !guy.isDead())
					triggerNode.trigger();
				if(!guy.isDead() &&this.goldWithin > 0 )
					goldWithin = guy.giveGold(goldWithin,this);
				return true;
			}
			else
			{
				this.removeGuy(guy);
				return false
			}
		}
		protected override function TimeListener(e:TimerEvent):void	{
			if(placed)
				displaySolid();
			else
				displayFaded();

			fireTimeLeft--;
			if(fireTimeLeft >= -25)
			{
				this.fireCoolBar.update((fireTimeLeft+25)/50);
			}
			if(fireTimeLeft >= 0)
			{
				this.fireBlastBar.update((fireTimeLeft)/25);
			}
			if(fireTimeLeft <0)
				active = false;
		}
		public override function trigger():void
		{
			active = true;
			fireTimeLeft = 25;
		}
		public override function getImpassible():Boolean
		{
			return false;
		}
		public function getOnFire():Boolean
		{
			return this.active;
		}
		protected override function displaySolid():void
		{
			this.blendMode = BlendMode.NORMAL;
			graphics.clear();
			if(this.selected)
			{
				graphics.beginFill(0x00FF00,.5);
				graphics.drawRect(roomImage.x,roomImage.y,roomImage.width,roomImage.height);
				
			}
			roomImage.alpha = 1;
			deactivateImage.alpha = 1;
			if(this.selected)
			{
				deactivateImage.alpha = .5;
				roomImage.alpha = .5;
			}
			if(!active)
			{
				roomImage.alpha = 0;
			}
			if(this.triggerNode != null)
			{
				graphics.moveTo(0,0);
				graphics.lineStyle(1, 0x00FF00);
				
				graphics.lineTo(triggerNode.drawToPointX(),triggerNode.drawToPointY());
				graphics.moveTo(0,0);
			}
		}
	}
}