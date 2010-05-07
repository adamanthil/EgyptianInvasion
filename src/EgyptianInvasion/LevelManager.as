package EgyptianInvasion
{
	import assets.popUpWin;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	
	import mx.managers.*;
	
	public class LevelManager extends Sprite
	{
		private var currLevel:Number;
		private var currGold:Number;
		private var prevGold:Number;
		private var main:Main;
		private var enMan:EnemyManager;
		private var noMan:NodeManager;
		private var ui:UI;
		private var canvas:Stage;
		private var interest:Number;
		private var loader:URLLoader;
		private var s_x:String;
		private var totalGoldText:TextField;
		private var enemyOnBoardText:TextField;
		private var currentGoldCostText:TextField;
		private var enemiesRemainingText:TextField;
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
			// Set all the level manager's references to the other managers
			this.main = m;
			this.enMan = em;
			this.noMan = nm;
			this.ui = ui;
			this.canvas =can;
						
			currLevel = 1;
			currGold = 100;
			prevGold = currGold;
			interest = 0.3;
			
			// Sets up start and end nodes for the level, with a position
			setStartEndNode();
			
			// Defines a text format to use for all our fields
			format = new TextFormat();
			format.color = 0x112222; 
			format.size = 10; 
			
			// Instantiate and initialize all our text displays
			totalGoldText = new TextField();
			enemyOnBoardText = new TextField();
			currentGoldCostText = new TextField();
			enemiesRemainingText = new TextField();
			
			displayGold(currGold);
			displayEnemiesOnBoard(0);
			displayCurrentPlacementCost(0);
			displayEnemiesToCome(main.getEnemyManager().getNumEnemiesOnLevel());
			
			// Adds the text to the main display
			main.addChild(totalGoldText);
			main.addChild(enemyOnBoardText);
			main.addChild(currentGoldCostText);
			main.addChild(enemiesRemainingText);
			
			// Instantiates the starting splash screen
			getStartPop();
			
			// Instantiates the buttons used for playing again or moving to the next level
			againButton = new Button(new assets.ToggleButton(), 0,0, "TRY AGAIN!",canvas, main);
			againButton.addEventListener(MouseEvent.MOUSE_DOWN, againPressed);
			
			nextButton = new Button(new assets.ToggleButton(), 0,0, "NEXT LEVEL",canvas, main);
			nextButton.addEventListener(MouseEvent.MOUSE_DOWN, nextPressed);
		}
		
		//start pop up window
		private function getStartPop():void{
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
			var titleFormat:TextFormat = new TextFormat();
			titleFormat.font = "Tw Cen MT";
			titleFormat.size = 20;
			startTitle.setTextFormat(titleFormat);
			startTitle.x = -150;
			startTitle.y = -100;
			startPop.addChild(startTitle);
		}
		
		// Minimizes the start splash and reveals the game board
		private function startPressed(e:MouseEvent):void{
			startPop.gotoAndStop("minimize");
			startPop.removeChild(startButton);
			startPop.removeChild(startTitle);
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
			this.enMan.removeTimer();
			this.main.setBuildPhase(true);
			this.main.removeChild(noMan);
			noMan = new NodeManager(this.main,69,365,200,300);
			this.main.addChild(noMan);
			this.main.setNodeManager(noMan);
			//this.main.setChildIndex(noMan,this.main.numChildren - 1);
			
			this.main.removeChild(this.ui);
			this.ui = new UI(50,0,this.main.stage,this.main);
			this.main.addChild(ui);
			this.main.setUI(this.ui);
			
			this.main.removeChild(enMan);
			enMan = new EnemyManager(this.main);
			this.main.addChild(enMan);
			this.main.setEnemyManager(enMan);
			
			this.main.setChildIndex(this.startPop,this.main.numChildren -1);
			displayEnemiesOnBoard(0);
			displayGold(currGold);
			//levelMan = new LevelManager(this,enemyMan,nodeMan,stage,ui);
		}
		
		// Function to initialize and edit the value of the total player gold
		public function displayGold(gold:Number):void{
			totalGoldText.autoSize=TextFieldAutoSize.LEFT;
			totalGoldText.text = "GOLD LEFT: "+ gold;
			totalGoldText.setTextFormat(format);
			totalGoldText.x = 420;
			totalGoldText.y = 10;
			totalGoldText.selectable = false;			
		}
		
		// Function to initialize and edit the value of the enemies currently in play
		public function displayEnemiesOnBoard(amtEnemy:Number):void{
			enemyOnBoardText.autoSize=TextFieldAutoSize.LEFT;
			enemyOnBoardText.text = "ENEMIES ON BOARD: "+ amtEnemy;
			enemyOnBoardText.setTextFormat(format);
			enemyOnBoardText.x = 300;
			enemyOnBoardText.y = 10;
			enemyOnBoardText.selectable = false;	
			if (main.getBuildPhase()==false && amtEnemy == 0){
				//popWinWin();
			}
		}
		
		// Auxillary method to simply deduct from the displayed amount of gold
		public function deductGold(amount:Number):void{
			currGold -=amount;
			totalGoldText.text = "GOLD LEFT: " + currGold.toFixed(2);
			totalGoldText.setTextFormat(format);
			if (main.getBuildPhase()==false && currGold <= 0){
				popLoseWin();
			}
		}
		// Function to initialize and edit the value of cost of placing the currently selected node, taking path cost into consideration
		public function displayCurrentPlacementCost(amount:Number):void{
			/** TODO to be ediited */
			currentGoldCostText.autoSize=TextFieldAutoSize.LEFT;
			currentGoldCostText.text = "CURRENT PLACEMENT COST: "+ amount.toFixed(2);
			currentGoldCostText.setTextFormat(format);
			currentGoldCostText.x = 350;
			currentGoldCostText.y = 30;
			currentGoldCostText.selectable = false;
		}
		// Function to initialize and edit the value of Enemies still to come into play
		public function displayEnemiesToCome(amount:Number):void{
			enemiesRemainingText.autoSize=TextFieldAutoSize.LEFT;
			enemiesRemainingText.text = "ENEMIES YET TO COME: "+ amount;
			enemiesRemainingText.setTextFormat(format);
			//myTextField_txt.text.
			enemiesRemainingText.x = 350;
			enemiesRemainingText.y = 50;
			enemiesRemainingText.selectable = false;
		}
		
		private function againPressed(e:MouseEvent):void{
			/**to be edited*/
			startPop.gotoAndStop("minimize");
			startPop.removeChild(againButton);
			startPop.removeChild(startTitle);
			currGold = prevGold;
			reInitialize();
		}
		
		private function nextPressed(e:MouseEvent):void{
			/**to be edited*/
			startPop.gotoAndStop("minimize");
			startPop.removeChild(nextButton);
			startPop.removeChild(startTitle);
			calculateGold(currGold);
			nextLevel(currGold);
			prevGold = currGold;
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