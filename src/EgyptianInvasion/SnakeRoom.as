package EgyptianInvasion
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	import mx.core.BitmapAsset;
	
	public class SnakeRoom extends Trap
	{
		[Embed(source="../assets/img/snakeIconic.jpg")]
		private var RoomImage:Class;
		
		public function SnakeRoom(nodex:Number, nodey:Number, canvas:Stage, refup:NodeManager)
		{
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
		public override function processEnemy(guy:Enemy):Boolean
		{
			if(Math.sqrt(Math.pow(guy.x - x,2) + Math.pow(guy.y - y, 2)))
			{
				if(!guy.isDead())
				{
					if(currentInside.indexOf(guy) == -1)
						guy.damageSnakes();
					this.addGuy(guy);
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