	package EgyptianInvasion
	{
		import assets.ToggleButton;
		
		import flash.display.*;
		import flash.events.*;
		import flash.utils.Timer;
		
		import mx.core.BitmapAsset;
		
		public class SpikeRoom extends Node
		{
			[Embed(source="../assets/img/pitIconic.jpg")]
			private var RoomImage:Class;
			private var roomImage:BitmapAsset;
			private var deadGuys:Number;
			private var active:Boolean;
			
			public function SpikeRoom(nodex:Number, nodey:Number, canvas:Stage, refup:NodeManager)
			{
				active = false;
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
					this.removeSibling(nodes[0]);
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
				var activeButton:Button = new Button(new assets.ToggleButton(),x,y+15,"spike button",canvas,sup.parent as Main);
				activeButton.addEventListener(MouseEvent.CLICK, activeTrigger);
				this.addChild(activeButton);
				roomImage.x = -15;
			}
			public var activeTrigger:Function = function (e:MouseEvent):void {
				var button:Button = Button(e.currentTarget);
				
				if (!button.isDown()){
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
						if(this.active && deadGuys < 30)
							guy.spikeAttack();
						if(guy.isDead())
							deadGuys++;
					}
					if(triggerNode != null && !guy.isDead())
						triggerNode.trigger();
					return true;
				}
				else
				{
					return false;
				}*/
				return false;
			}
			public override function TimeListener(e:TimerEvent):void	{
				if(placed)
					displaySolid();
				else
					displayFaded();
				
			}
			public override function trigger():void
			{
				this.active = !this.active;
			}
			public override function getImpassible():Boolean
			{
				return false;
			}
			public function activeNAAT():Boolean
			{
				return this.active;
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