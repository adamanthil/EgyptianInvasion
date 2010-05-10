package EgyptianInvasion
{
	import assets.ToggleButton;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.Timer;
	
	import mx.core.BitmapAsset;
	
	public class SnakeRoom extends Trap
	{
		[Embed(source="../assets/img/snakeIconic.jpg")]
		private var RoomImage:Class;
		
		private var poisonamnt:Number;
		
		private var currentLevel;
		private var costUp;
		
		private var format:TextFormat;
		private var levelText:TextField;
		private var costText:TextField;
		
		private var upgradeButton:Button;
		
		public function SnakeRoom(nodex:Number, nodey:Number, canvas:Stage, refup:NodeManager)
		{
			currentLevel = 1;
			costUp = 8;
			poisonamnt = 1;
			
			super(nodex,nodey,canvas, refup);
			roomImage  = new RoomImage();
			roomImage.scaleX = 0.6;
			roomImage.scaleY = 0.6;
			roomImage.x = -15;
			roomImage.y = -15;
			addChild(roomImage);
			value = 6;
			
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
						this.costUp = 12;
						this.currentLevel = 2;
						this.poisonamnt = 1.5;
					}
					else if(this.currentLevel == 2)
					{
						((parent as NodeManager).parent as Main).getLevelManager().deductGold(costUp);
						this.costUp = 16;
						this.currentLevel = 3;
						this.poisonamnt = 2.5;
					}
					else if(this.currentLevel == 3)
					{
						((parent as NodeManager).parent as Main).getLevelManager().deductGold(costUp);
						this.costUp = 0;
						this.currentLevel = 4;
						this.poisonamnt = 5;
					}
					this.setLevelText();
					this.setCostText();
				}}
		}
		public override function processEnemy(guy:Enemy):Boolean
		{
			if(Math.sqrt(Math.pow(guy.x - x,2) + Math.pow(guy.y - y, 2)))
			{
				if(!guy.isDead())
				{
					if(currentInside.indexOf(guy) == -1)
					{
						guy.poison(poisonamnt);
						this.addGuy(guy);
						if( this.goldWithin > 0 )
							goldWithin = guy.giveGold(goldWithin);
					}
					if(guy.isDead())
					{
						(guy.parent as EnemyManager).removeEnemy(guy);
						deadGuys++;	
					}
				}
				if(triggerNode != null && !guy.isDead())
					triggerNode.trigger();
				return true;
			}
			else
			{
				this.removeGuy(guy);
				return false
			}
		}
		public override function getImpassible():Boolean
		{
		//	if(deadGuys > 30)
			//{
			//	return true;
			//}
			return false;
		}
	}
}