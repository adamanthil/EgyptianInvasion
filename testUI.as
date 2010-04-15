package
{
	import flash.display.*;
	import flash.events.*;
	
	public class testUI extends Sprite
	{
		var buttonArr:Array = new Array(3);
		
		var container:Sprite = new Sprite();
		var n1Button:Sprite = new Sprite();
		var n2Button:Sprite = new Sprite();
		var n3Button:Sprite = new Sprite();
		
		public function testUI()
		{					
			buttonArr.push(n1Button, n2Button, n3Button);
			
			// Set line thickness to one pixel
			container.graphics.lineStyle(1);
			
			// Draw a blue rectangle
			container.graphics.beginFill(0x0000FF, 1);
			container.graphics.drawRect(0, 0, 150, 300);
	
			// Show rectAndCircle on screen by adding it to the display list
			addChildAt(container, 0);
			
			n1Button.graphics.lineStyle(2,0x000000);
			// Draw a blue rectangle
			n1Button.graphics.beginFill(0x00FF00, 1);
			n1Button.graphics.drawRect(25, 18, 100, 76);
			addChildAt(n1Button, 1);
			n1Button.addEventListener(MouseEvent.CLICK, clickListener);
			
			n2Button.graphics.lineStyle(2,0x000000);
			// Draw a blue rectangle
			n2Button.graphics.beginFill(0xFF0000, 1);
			n2Button.graphics.drawRect(25, 112, 100, 76);			
			addChildAt(n2Button, 1);
			n2Button.addEventListener(MouseEvent.CLICK, clickListener);
			
			n3Button.graphics.lineStyle(2,0x000000);
			// Draw a blue rectangle
			n3Button.graphics.beginFill(0x00FF00, 1);
			n3Button.graphics.drawRect(25, 206, 100, 76);	
			addChildAt(n3Button, 1);
			n3Button.addEventListener(MouseEvent.CLICK, clickListener);
		}
		
		private function clickListener (e:MouseEvent):void 
		{
			DisplayObject(e.target).alpha = 0.3;
			buttonToggleCheck(e);
		}
		
		private function buttonToggleCheck (e:MouseEvent):void
		{
			for each(var b:Sprite in buttonArr)
			{
				if(b != e.target)
				{
					DisplayObject(b).alpha = 1;
				}
			}
		}

	}
}