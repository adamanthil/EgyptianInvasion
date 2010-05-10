package EgyptianInvasion
{
	import assets.ToggleButton;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.Timer;
	
	import mx.core.BitmapAsset;
	
	public class SandRoom extends Trap
	{
		[Embed(source="../assets/img/quicksandIconic.jpg")]
		protected var RoomImage:Class;
		private var totalDrown:Number;
		private var drowningTime:Number;
		private var currentDrowning:Array;
		private var drowningCool:Array;
		
		private var currentLevel;
		private var costUp;
		
		private var format:TextFormat;
		private var levelText:TextField;
		private var costText:TextField;
		
		private var drowningBar:Array;
		private var upgradeButton:Button;
		
		public function SandRoom(nodex:Number, nodey:Number, canvas:Stage, refup:NodeManager)
		{
			currentLevel = 1;
			costUp = 40;
			
			totalDrown = 1;
			drowningTime = 2.5;
			drowningBar = new Array();
			drowningBar.push(new DisplayBar(0x330000,0x663300,0));
			drowningCool = new Array();
			drowningCool.push(0);
			currentDrowning = new Array();
			
			currentInside = new Array();
			super(nodex,nodey,canvas, refup);
			roomImage  = new RoomImage();
			size = 7;
			roomImage.scaleX = 0.6;
			roomImage.scaleY = 0.6;
			roomImage.x = -15;
			roomImage.y = -15;
			addChild(roomImage);
			value = 10;
			
			graphics.beginFill(0x00FF00,.5);
			graphics.drawRect(roomImage.x,roomImage.y,roomImage.width,roomImage.height);
			
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
			//this.cacheAsBitmap = true;
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
			roomImage.x = -15;
			
			var activeButton:Button = new Button(new assets.ToggleButton(),15,-11,"++",canvas,sup.parent as Main);
			activeButton.addEventListener(MouseEvent.CLICK, upgrade);
			activeButton.scaleX = .12;
			activeButton.scaleY = .25;
			this.addChild(activeButton);
			upgradeButton = activeButton;
			
			(parent as NodeManager).getSelected().setSelected(false);
			otherSide.setSelected(true);
			(parent as NodeManager).setSelected(otherSide);
			
			this.addChild(drowningBar[0]);
			drowningBar[0].x = -15;
			drowningBar[0].y = 15;
			drowningBar[0].scaleY = .3;
			drowningBar[0].scaleX = .5;
			
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
					this.costUp = 60;
					this.currentLevel = 2;
					currentDrowning.push(null);
					drowningCool.push(null);
					drowningBar.push(new DisplayBar(0x330000,0x663300,0));
					totalDrown++;
					this.addChild(drowningBar[1]);
					drowningBar[1].x = -15;
					drowningBar[1].y = 19;
					drowningBar[1].scaleY = .3;
					drowningBar[1].scaleX = .5;
					this.drowningTime = 2.1;
				}
				else if(this.currentLevel == 2)
				{
					((parent as NodeManager).parent as Main).getLevelManager().deductGold(costUp);
					this.costUp = 90;
					this.currentLevel = 3;
					currentDrowning.push(null);
					drowningCool.push(null);
					drowningBar.push(new DisplayBar(0x330000,0x663300,0));
					totalDrown++;
					this.addChild(drowningBar[2]);
					drowningBar[2].x = -15;
					drowningBar[2].y = 23;
					drowningBar[2].scaleY = .3;
					drowningBar[2].scaleX = .5;
					this.drowningTime = 1.8;
				}
				else if(this.currentLevel == 3)
				{
					((parent as NodeManager).parent as Main).getLevelManager().deductGold(costUp);
					this.costUp = 0;
					this.currentLevel = 4;
					currentDrowning.push(null);
					drowningCool.push(null);
					drowningBar.push(new DisplayBar(0x330000,0x663300,0));
					totalDrown++;
					this.addChild(drowningBar[3]);
					drowningBar[3].x = -15;
					drowningBar[3].y = 27;
					drowningBar[3].scaleY = .3;
					drowningBar[3].scaleX = .5;
					this.drowningTime = 1.4;
				}
				this.setLevelText();
				this.setCostText();
			}}
		}
		protected override function displayFaded():void
		{
			graphics.clear();
			roomImage.alpha  = .5;
			if(isValid)
				this.blendMode = BlendMode.ADD;
			else
				this.blendMode = BlendMode.SUBTRACT;
		}
		protected override function TimeListener(e:TimerEvent):void	{
			for(var i:Number = 0; i < this.totalDrown;i++)
			{
				if(drowningCool[i] >= 0)
				{
					drowningBar[i].update((drowningTime*10-drowningCool[i])/(drowningTime*10));
					drowningCool[i] --;
				}
				else if(currentDrowning[i] != null && currentDrowning[i].quicksand())
				{
					this.removeGuy(currentDrowning[i]);
	//				(currentDrowning.parent as EnemyManager).removeEnemy(currentDrowning);
					currentDrowning[i] = null;
				}
				if(currentDrowning[i] == null)
					drowningBar[i].update(0);
			}
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
				{
					addGuy(guy);
					if(!guy.isDead() &&this.goldWithin > 0 )
						goldWithin = guy.giveGold(goldWithin);
				for(var i:Number = 0; i < this.totalDrown; i++)
				{
				if(currentDrowning[i] == null && currentDrowning.indexOf(guy) == -1 && currentInside.length < totalDrown+1  && guy.freeze(true,this) )
				{
					currentDrowning[i] = guy;
					drowningCool[i] = this.drowningTime *10;
				}
				else if(currentDrowning[i] != null && currentDrowning.indexOf(guy) ==-1 && guy.setDelay(20))
				{
					var full:Boolean = false;
					for(var j:Number = 0; j < this.totalDrown; j++)
					{
						if(currentDrowning[j] == null)
							full = false;
					}
					if(full || currentInside.length >= totalDrown+1)
					{
						currentDrowning[i].freeze(false,this);
						currentDrowning[i] = null;
					}
				}
				}
				if(triggerNode != null && !guy.isDead())
					triggerNode.trigger();
				}
				return true;
			}
			else
			{
				removeGuy(guy);
				trace(currentInside.length);
				return false
			}
			for(var i:Number = 0; i < currentInside.length; i++)
			{
				if((currentInside[i] as Enemy).isDead())
					removeGuy(currentInside[i]);
			}
			return false;
		}
	}
}