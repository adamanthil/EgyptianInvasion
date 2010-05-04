package EgyptianInvasion
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	import mx.core.BitmapAsset;
	
	public class StartRoom extends Trap
	{
		[Embed(source="../assets/img/startRoom.jpg")]
		private var RoomImage:Class;
		public function StartRoom(nodex:Number, nodey:Number, canvas:Stage, refup:NodeManager)
		{
			super(nodex,nodey,canvas,refup);
			roomImage  = new RoomImage();
			roomImage.scaleX = 0.4;
			roomImage.scaleY = 0.4;
			roomImage.x = -8;
			roomImage.y = -8;
			addChild(roomImage);
			//this.cacheAsBitmap = true;
			this.blendMode = BlendMode.LAYER;
			canvas = canvas;
			x = nodex;
			y = nodey;
			size = 10;
			time.start();
			nodes = new Array();
			isConnectable = true;
		}
		public override function processEnemy(guy:Enemy):Boolean
		{
			if(Math.sqrt(Math.pow(guy.x - x,2) + Math.pow(guy.y - y, 2)) < size && guy.getGold() > 0)
			{
				(sup.parent as Main).getLevelManager().deductGold(guy.getGold());
				guy.giveGold(-1 * guy.getGold());	// Remove his gold before we kill him
				(guy.parent as EnemyManager).removeEnemy(guy);
				return true;
			}
			else
				return false;
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
			if(this.selected)
				roomImage.alpha = .5;
		}
	}
}