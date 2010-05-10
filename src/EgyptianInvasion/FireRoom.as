package EgyptianInvasion
{
	import assets.ToggleButton;
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	import flash.text.*;
	
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
		
		private var burnCoolRat:Number;
		
		private var fireCoolBar:DisplayBar;
		private var fireBlastBar:DisplayBar;
		
		private var currentLevel;
		private var costUp;
		
		private var format:TextFormat;
		private var levelText:TextField;
		private var costText:TextField;
		
		private var upgradeButton:Button;		
		
		private var uber:Boolean;
		
		public function FireRoom(nodex:Number, nodey:Number, canvas:Stage, refup:NodeManager)
		{
			currentLevel = 1;
			costUp = 90;
			uber = false;
			burnCoolRat = 1;
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
			
			format = new TextFormat();
			format.color = 0x221167; 
			format.size = 6; 
			
			// Instantiate and initialize all our text displays
			levelText = new TextField();
			levelText.x = -20;
			levelText.y = -25;
			setLevelText();
			
			costText = new TextField();
			costText.x = -5;
			costText.y = -25;
			setCostText();
			this.addChild(levelText);
			this.addChild(costText);
		}
		private function setLevelText():void
		{
			levelText.autoSize=TextFieldAutoSize.LEFT;
			levelText.text = "lvl: "+ this.currentLevel;
			levelText.setTextFormat(format);
			levelText.selectable = false;	
		}
		private function setCostText()
		{
			costText.autoSize=TextFieldAutoSize.LEFT;
			costText.text = "++: "+ this.costUp;
			costText.setTextFormat(format);
			costText.selectable = false;	
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
			var activeButton:Button = new Button(new assets.ToggleButton(),0,20,"fire button",canvas,sup.parent as Main);
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
			
			var activeButton:Button = new Button(new assets.ToggleButton(),15,-11,"++",canvas,sup.parent as Main);
			activeButton.addEventListener(MouseEvent.CLICK, upgrade);
			activeButton.scaleX = .12;
			activeButton.scaleY = .25;
			this.addChild(activeButton);
			upgradeButton = activeButton;
			
			
			(parent as NodeManager).getSelected().setSelected(false);
			otherSide.setSelected(true);
			(parent as NodeManager).setSelected(otherSide);
		}
		public function activeTrigger(e:MouseEvent):void {
			var button:Button = Button(e.currentTarget);
			
			if (!button.isDown() && fireTimeLeft < -1 * this.burnCoolRat * 25){
				this.trigger();				
			}
		}
		private function upgrade(e:MouseEvent):void
		{
			var button:Button = Button(e.currentTarget);
			
			if (!button.isDown()){
				if(((parent as NodeManager).parent as Main).getLevelManager().getGoldAmt() >= this.costUp)
				{
					if(this.currentLevel == 1)
					{
						((parent as NodeManager).parent as Main).getLevelManager().deductGold(costUp);
						this.costUp = 130;
						this.currentLevel = 2;
						this.burnCoolRat = .6;
					}
					else if(this.currentLevel == 2)
					{
						((parent as NodeManager).parent as Main).getLevelManager().deductGold(costUp);
						this.costUp = 200;
						this.currentLevel = 3;
						this.burnCoolRat = .3;
					}
					else if(this.currentLevel == 3)
					{
						((parent as NodeManager).parent as Main).getLevelManager().deductGold(costUp);
						this.costUp = 0;
						this.currentLevel = 4;
						this.burnCoolRat = .5;
						this.uber = true;
					}
					this.setLevelText();
					this.setCostText();
				}}
		}
		public override function processEnemy(guy:Enemy):Boolean
		{
			if(Math.sqrt(Math.pow(guy.x - x,2) + Math.pow(guy.y - y, 2)) < this.size)
			{
				if(!guy.isDead() && this.active)
				{
					if(currentInside.indexOf(guy) == -1)
					{
						if(this.uber)
						{
							guy.totalBurn();
						}
						else
						{
							guy.damageFire();
						}
						this.addGuy(guy);
						if( this.goldWithin > 0 )
							goldWithin = guy.giveGold(goldWithin);
					}
					if(guy.isDead())
					{
						deadGuys++;	
					}
				}
				if(triggerNode != null && !guy.isDead())
					triggerNode.trigger();
				if(!guy.isDead() &&this.goldWithin > 0 )
					goldWithin = guy.giveGold(goldWithin);
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
			if(fireTimeLeft >= -1 * this.burnCoolRat * 25)
			{
				this.fireCoolBar.update((fireTimeLeft+this.burnCoolRat *25)/(25 + this.burnCoolRat *25));
			}
			if(fireTimeLeft >= 0)
			{
				this.fireBlastBar.update((fireTimeLeft)/(25));
			}
			if(fireTimeLeft <0)
				active = false;
		}
		public override function trigger():void
		{
			if ( fireTimeLeft < -1 * this.burnCoolRat * 25)
			{	
				active = true;
				fireTimeLeft = 25;
			}
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
		public override function toString():String
		{
			return "BURN";
		}
	}
}