	package EgyptianInvasion
	{
		import assets.ToggleButton;
		
		import flash.display.*;
		import flash.events.*;
		import flash.utils.Timer;
		
		import mx.core.BitmapAsset;
		
		public class PitRoom extends Trap
		{
			[Embed(source="../assets/img/pitIconic.jpg")]
			private var RoomImage:Class;
			private var fireTimeLeft:Number;
			
			
			[Embed(source="../assets/img/pitIconicDeactivate.jpg")]
			private var DeactivateImage:Class;
			private var deactivateImage:BitmapAsset;
			private var button:Button;
			
			public function PitRoom(nodex:Number, nodey:Number, canvas:Stage, refup:NodeManager)
			{
				active = false;
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
				var activeButton:Button = new Button(new assets.ToggleButton(),0,-20,"pit button",canvas,sup.parent as Main);
				activeButton.addEventListener(MouseEvent.CLICK, activeTrigger);
				this.addChild(activeButton);
				button = activeButton;
				roomImage.x = -15;
			}
			public override function processEnemy(guy:Enemy):Boolean
			{
				if(Math.sqrt(Math.pow(guy.x - x,2) + Math.pow(guy.y - y, 2)) < size)
				{
					this.addGuy(guy);
					if(!guy.isDead())
					{
						if(this.active && deadGuys < 30)
							guy.killSpikes();
						if(guy.isDead())
							deadGuys++;
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
				roomImage.alpha = 1;
				deactivateImage.alpha = 1;
				if(this.selected)
				{
					roomImage.alpha = .5;
					deactivateImage.alpha = .5;
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