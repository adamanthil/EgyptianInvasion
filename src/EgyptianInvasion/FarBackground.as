package EgyptianInvasion
{
	import flash.display.Sprite;

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import mx.core.BitmapAsset;
	public class FarBackground extends Sprite
	{
		[Embed(source="../assets/img/pyramid_background.jpg")]
		private var farBGimage:Class;
		public function FarBackground()
		{
			var photo:BitmapAsset = new farBGimage();
			photo.scaleX = 0.5;
			photo.scaleY = 0.41;
			photo.x = -70;
			photo.y = 0;
			addChild(photo);
		}
	}
}