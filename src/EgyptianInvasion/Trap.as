package EgyptianInvasion
{
		import assets.ToggleButton;
		
		import flash.display.*;
		import flash.events.*;
		import flash.utils.Timer;
		
		import mx.core.BitmapAsset;
		//PLEASE NOTE: do not use this class as any actual instantiation. the fact that traps must define their own
		// images forces all methods called from the generic trap to fail when this is not defined. Thus, you will
		// have to instantiate a specific trap to use.
		// Entertainingly, this particular incongruity of never actually instantiating the roomImage doesn't appear to bother
		//  the actionscript compiler. I recognize that this is a bit of a perilous way to do things. However, an interface doesn't
		//  do everything I want this generic class to do, so until we meet later, please forgive this slight offense in terms of
		//  mildly unstable code.
		public class Trap extends Node
		{
			
			protected var roomImage:BitmapAsset;
			protected var deadGuys:Number;
			protected var active:Boolean;
			protected var currentInside:Array;
			
			public function Trap(nodex:Number, nodey:Number, canvas:Stage, refup:NodeManager)
			{
				currentInside = new Array();
				super(nodex,nodey,canvas, refup);
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
				roomImage.x = -15;
			}
			protected override function displayFaded():void
			{
				graphics.clear();
				roomImage.alpha  = .5;
				if(isValid)
					this.blendMode = BlendMode.SCREEN;
				else
					this.blendMode = BlendMode.SUBTRACT;
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
					addGuy(guy);
					if(triggerNode != null && !guy.isDead())
						triggerNode.trigger();
					return true;
				}
				else
				{
					removeGuy(guy);
					return false;
				}
				return false;
			}
			protected function addGuy(guy:Enemy)
			{
				currentInside.push(guy);
			}
			protected function removeGuy(guy:Enemy)
			{
				var int:Number;
				int = currentInside.indexOf(guy);
				if(int != -1)
				{
					currentInside[int] = currentInside[currentInside.length -1];
					currentInside.pop();
				}
			}
			protected override function TimeListener(e:TimerEvent):void	{
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
			protected override function displaySolid():void
			{
				this.blendMode = BlendMode.NORMAL;
				if(this.selected)
				{
					graphics.beginFill(0x00FF00,.5);
					graphics.drawRect(roomImage.x,roomImage.y,roomImage.width,roomImage.height);
					
				}
				roomImage.alpha = 1;
				if(this.selected)
					roomImage.alpha = .5;
				if(this.triggerNode != null)
				{
					graphics.moveTo(0,0);
					graphics.lineStyle(1, 0x00FF00);
					
					graphics.lineTo(triggerNode.drawToPointX(),triggerNode.drawToPointY());
					graphics.moveTo(0,0);
				}
			}
			protected override function mouseMoveListener(e:MouseEvent):void {
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