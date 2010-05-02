package EgyptianInvasion
{
	import assets.*;
	
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.*;
	
	import mx.core.BitmapAsset;
	public class NearBackground extends Sprite
	{
		[Embed(source="../assets/img/nearBack3.jpg")]
		private var nearBGimage:Class;
		private var canvas:Stage;
		public function NearBackground(stag:Stage)
		{
			canvas = stag;
			blendMode = BlendMode.LAYER;
			var photo:BitmapAsset = new nearBGimage();
			photo.scaleX = 0.4;
			photo.scaleY = 0.41;
			photo.x = -70
			photo.y = 0;
			addChild(photo);
			var pyramid:Pyramid = new Pyramid(new assets.pyramid2(), 300,250,canvas, true);
			pyramid.scaleX = 0.7;
			this.addChildAt(pyramid,1);
		}
	}
}