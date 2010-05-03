package EgyptianInvasion
{
	import flash.display.*;
	import flash.events.*;
	public class DisplayBar extends Sprite
	{
		private var amnt:Number;
		private var col1:uint;
		private var col2:uint;
		// do me a favor, only make the amount be a value between 0 and 1,
		//  otherwise wonky things will happen.
		public function DisplayBar(color1:Number,color2:Number,amount:Number)
		{
			graphics.clear();
			graphics.beginFill(color1);
			graphics.drawRect(0,0,50,6);
			graphics.endFill();
			graphics.beginFill(color2);
			graphics.drawRect(0,0,50 * amount,6);
			
			graphics.beginFill(color1+10);
			graphics.drawRect(0,6,50,4);
			graphics.endFill();
			graphics.beginFill(color2+10);
			graphics.drawRect(0,6,50 * amount,4);
			col1 = color1;
			col2 = color2;
			amnt = amount; 
		}
		public function update(amount:Number)
		{
			graphics.clear();
			graphics.beginFill(col1);
			graphics.drawRect(0,0,50,6);
			graphics.endFill();
			graphics.beginFill(col2);
			graphics.drawRect(0,0,50 * amount,6);
			
			graphics.beginFill(col1+130);
			graphics.drawRect(0,6,50,4);
			graphics.endFill();
			graphics.beginFill(col2+130);
			graphics.drawRect(0,6,50 * amount,4);
			amnt = amount; 
		}
	}
}