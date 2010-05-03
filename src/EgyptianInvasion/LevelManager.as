package EgyptianInvasion
{
	import assets.popUpWin;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	
	import mx.managers.*;
	
	public class LevelManager
	{
		private var currLevel:Number;
		private var currGold:Number;
		private var main:Main;
		private var enMan:EnemyManager;
		private var noMan:NodeManager;
		private var ui:UI;
		private var canvas:Stage;
		private var interest:Number;
		private var loader:URLLoader;
		private var s_x:String;
		private var goldTextField:TextField;
		private var enemyTextField:TextField;
		private var format:TextFormat;
		private var nodeLimit:Number;
		private var startPop:popUpWin;
		private var startButton:Button;
		private var startTitle:TextField;
		
		private var againButton:Button;
		private var nextButton:Button;
		
		public const fireRoomCost:Number = 100;
		public const pitRoomCost:Number = 20;
		public const snakeRoomCost:Number = 50;
		public const quickSoundCost:Number = 80;
		
		public function LevelManager(m:Main, em:EnemyManager, nm:NodeManager, can:Stage,ui:UI)
		{
			/*nm = new NodeManager(m);
			m.addChild(nm);
			
			ui = new UI(50,0,can,m);
			m.addChild(ui);
			
			
			em = new EnemyManager(m,nm);*/
			
			format = new TextFormat();
			format.color = 0x112222; 
			format.size = 10; 
			
			this.main = m;
			this.enMan = em;
			this.noMan = nm;
			this.ui = ui;
			this.canvas =can;
			//this.nodeLimit = 30;
			currLevel = 1;
			currGold = 100;
			interest = 0.3;
			setStartEndNode();
			goldTextField = new TextField();
			enemyTextField = new TextField();
			displayGold(currGold);
			displayEnemy(0);
			main.addChild(goldTextField);
			main.addChild(enemyTextField);
			getStartPop();
			//main.remove
			
			againButton = new Button(new assets.ToggleButton(), 0,0, "TRY AGAIN!",canvas, main);
			againButton.addEventListener(MouseEvent.MOUSE_DOWN, againPressed);
			
			nextButton = new Button(new assets.ToggleButton(), 0,0, "NEXT LEVEL",canvas, main);
			nextButton.addEventListener(MouseEvent.MOUSE_DOWN, nextPressed);
		}
		
		private function getStartPop(){//start pop up window
			startPop = new popUpWin();
			startPop.x = 250;
			startPop.y = 200;
			startPop.stop();
			startPop.gotoAndStop("cover");
			main.addChild(startPop);
			startButton = new Button(new assets.ToggleButton(), 0,0, "START",canvas, main);
			startButton.addEventListener(MouseEvent.MOUSE_DOWN, startPressed);
			startPop.addChild(startButton);
			startTitle = new TextField();
			startTitle.autoSize=TextFieldAutoSize.LEFT;
			startTitle.text = "WELCOME TO EGYPTIAN INVASION!!!";
			var titleFormat = new TextFormat();
			titleFormat.font = "Tw Cen MT";
			titleFormat.size = 20;
			startTitle.setTextFormat(titleFormat);
			startTitle.x = -150;
			startTitle.y = -100;
			startPop.addChild(startTitle);
		}
		
		private function startPressed(e:MouseEvent){
			startPop.gotoAndStop("minimize");
			startPop.removeChild(startButton);
			startPop.removeChild(startTitle);
			
			//main.removeChild(startPop);
		}
		
		public function setStartEndNode():void{
			loader = new URLLoader();
			
			//telling the loader that we are dealing with variables here.
			//loader.dataFormat = URLLoaderDataFormat.VARIABLES;
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			
			loader.addEventListener(Event.COMPLETE, nodeLoading);
			
			//Here we tell our loading which file to extract from.
			loader.load(new URLRequest("../assets/level1content.txt"));
			//if (loader.
			
			/*var s_y:Number = loader.data.start_y;
			var e_x:Number = loader.data.final_x;
			var e_y:Number = loader.data.final_y;
			*/
			s_x = "data?"+loader.data;
		}
		
		private function nodeLoading (e:Event):void {
			//content_1.text = loader.data.var_1
			//content_2.text = loader.data.var_2
			//goldTextField.text = "data?"+loader.data;
		}
		private function calculateGold(gold:Number):void{
			currGold = gold*(1+interest);
		}
		
		public function nextLevel(gold:Number):void{
			currLevel++;
			calculateGold(gold);
			reInitialize();//initialize nodemanger and enemymanager
			setStartEndNode();
			displayGold(currGold);
		}
		
		private function reInitialize():void{
			
		}
		
		public function displayGold(gold:Number):void{
			//myTextField_txt.wordWrap=true;
			goldTextField.autoSize=TextFieldAutoSize.LEFT;
			goldTextField.text = "GOLD LEFT: "+ gold;
			goldTextField.setTextFormat(format);
			//myTextField_txt.text.
			goldTextField.x = 450;
			goldTextField.y = 10;
			goldTextField.selectable = false;			
		}
		
		public function displayEnemy(amtEnemy:Number):void{
			//myTextField_txt.wordWrap=true;
			enemyTextField.autoSize=TextFieldAutoSize.LEFT;
			enemyTextField.text = "ENEMIES LEFT: "+ amtEnemy;
			enemyTextField.setTextFormat(format);
			enemyTextField.x = 350;
			enemyTextField.y = 10;
			enemyTextField.selectable = false;	
			if (main.getBuildPhase()==false && amtEnemy == 0){
				//popWinWin();
			}
			
		}
		
		public function deductGold(amount:Number):void{
			currGold -=amount;
			goldTextField.text = "GOLD LEFT: " + currGold.toFixed(2);
			goldTextField.setTextFormat(format);
			if (main.getBuildPhase()==false && currGold <= 0){
				//popLoseWin();
			}
		}
		
		private function againPressed(e:MouseEvent):void{
			/**to be edited*/
			startPop.gotoAndStop("minimize");
			startPop.removeChild(againButton);
			startPop.removeChild(startTitle);
		}
		
		private function nextPressed(e:MouseEvent):void{
			/**to be edited*/
			startPop.gotoAndStop("minimize");
			startPop.removeChild(nextButton);
			startPop.removeChild(startTitle);
			calculateGold(currGold);
			nextLevel(currGold);
		}
		
		private function popLoseWin():void{
			//main.removeChild(startPop);// the start pop up is just hiding, remove it after a level
			
			startPop.gotoAndStop("maximize");
			
			
			startPop.addChild(againButton);
			
			startTitle.text = "Oops, you probably just miss a little bit! Try building again!!";

			startPop.addChild(startTitle);
		}
		
		private function popWinWin():void{
			//main.removeChild(startPop);// the start pop up is just hiding, remove it after a level
			
			startPop.gotoAndStop("maximize");
			
			
			startPop.addChild(nextButton);
			
			startTitle.text = "Oops, you probably just miss a little bit! Try building again!!";
			
			startPop.addChild(startTitle);
		}
		
		public function setInterest(amount:Number):void{
			interest = amount;
		}
		
		public function getGoldAmt():Number{
			return currGold;
		}
	}
}