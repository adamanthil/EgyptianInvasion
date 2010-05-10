	package EgyptianInvasion
	{
		import assets.ToggleButton;
		
		import flash.display.*;
		import flash.events.*;
		import flash.utils.Timer;
		
		import flash.text.*;
		
		import mx.core.BitmapAsset;
		
		public class PitRoom extends Trap
		{
			[Embed(source="../assets/img/pitIconic.jpg")]
			private var RoomImage:Class;
			private var fireTimeLeft:Number;
			
			
			[Embed(source="../assets/img/pitIconicDeactivate.jpg")]
			private var DeactivateImage:Class;
			private var deactivateImage:BitmapAsset;
			
			[Embed(source="../assets/img/pitIconicFull.jpg")]
			private var FullImage:Class;
			private var fullImage:BitmapAsset;
			private var button:Button;
			
			private var deadguyBar:DisplayBar;
			
			private var depthOfPit:Number;
			
			private var currentLevel;
			private var costUp;
			
			private var format:TextFormat;
			private var levelText:TextField;
			private var costText:TextField;
			
			private var upgradeButton:Button;
			
			public function PitRoom(nodex:Number, nodey:Number, canvas:Stage, refup:NodeManager)
			{
				active = true;
				super(nodex,nodey,canvas, refup);
				
				currentLevel = 1;
				costUp = 50;
				depthOfPit = 10;
				
				fullImage  = new FullImage();
				fullImage.scaleX = 0.6;
				fullImage.scaleY = 0.6;
				fullImage.x = -15;
				fullImage.y = -15;
				addChild(fullImage);
				
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
				
				value = 8;
				
				deadguyBar = new DisplayBar(0x000000,0xEEEEEE,1);
				graphics.beginFill(0x00FF00,.5);
				graphics.drawRect(roomImage.x,roomImage.y,roomImage.width,roomImage.height);
				deadGuys = 0;
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
			public function activeTrigger(e:MouseEvent):void {
				var button:Button = Button(e.currentTarget);
				
				if (!button.isDown()){
					this.trigger();				
				}
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
				var activeButton:Button = new Button(new assets.ToggleButton(),0,20,"pit button",canvas,sup.parent as Main);
				activeButton.addEventListener(MouseEvent.CLICK, activeTrigger);
				activeButton.scaleX = .25;
				activeButton.scaleY = .25;
				this.addChild(activeButton);
				button = activeButton;
				roomImage.x = -15;
				
				this.addChild(deadguyBar);
				deadguyBar.x = -15;
				deadguyBar.y = 10;
				deadguyBar.scaleY = .3;
				deadguyBar.scaleX = .5;
				deadguyBar.update(0);
				
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
			private function upgrade(e:MouseEvent):void
			{
				var button:Button = Button(e.currentTarget);
				
				if (!button.isDown()){
					if(((parent as NodeManager).parent as Main).getLevelManager().getGoldAmt() >= this.costUp)
					{
						if(this.currentLevel == 1)
						{
							((parent as NodeManager).parent as Main).getLevelManager().deductGold(costUp);
							this.costUp = 100;
							this.currentLevel = 2;
							this.depthOfPit = 18;
						}
						else if(this.currentLevel == 2)
						{
							((parent as NodeManager).parent as Main).getLevelManager().deductGold(costUp);
							this.costUp = 150;
							this.currentLevel = 3;
							this.depthOfPit = 28;
						}
						else if(this.currentLevel == 3)
						{
							((parent as NodeManager).parent as Main).getLevelManager().deductGold(costUp);
							this.costUp = 0;
							this.currentLevel = 4;
							this.depthOfPit = 45;
						}
						this.setLevelText();
						this.setCostText();
					}}
			}
			public override function processEnemy(guy:Enemy):Boolean
			{
				if(Math.sqrt(Math.pow(guy.x - x,2) + Math.pow(guy.y - y, 2)) < size)
				{
					if(!guy.isDead())
					{
						if(this.active && deadGuys < depthOfPit)
						{
							if(currentInside.indexOf(guy) == -1)
							{
								this.addGuy(guy);
								guy.killSpikes();
								if(!guy.isDead() &&this.goldWithin > 0 )
									goldWithin = guy.giveGold(goldWithin);
							}
							if(guy.isDead())
								deadGuys+=guy.getPitSlots();
							deadguyBar.update(deadGuys/depthOfPit);
							if(deadGuys==depthOfPit)
							{
								roomImage.alpha = 0;
								deactivateImage.alpha = 0;
							}
						}
					}
					if(triggerNode != null && !guy.isDead())
						triggerNode.trigger();
					return true;
				}
				else
				{
					this.removeGuy(guy);
					return false;
				}
				return false;
			}
			
			public override function trigger():void
			{
				this.active = !this.active;
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
				if(this.deadGuys >= depthOfPit)
				{
					deactivateImage.alpha = 0;
					roomImage.alpha = 0;
				}
				else
				{
					roomImage.alpha = 1;
					deactivateImage.alpha = 1;
				}
				if(this.selected)
				{
					roomImage.alpha = .5;
					deactivateImage.alpha = .5;
					fullImage.alpha = .35;
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