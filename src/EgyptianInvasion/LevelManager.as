package EgyptianInvasion
{
	import assets.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.*;
	
	import mx.core.SoundAsset;
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
		private var levelText:TextField;
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
		
		// TODO COMMENT BACK IN FOR FINAL BUILD
		[Embed(source="../assets/sound/Sonic_&_Knuckles_Sand_in_My_Shoe_OC_ReMix.mp3")]
		public static var Track1Sound:Class;
		public static var Track1FX:SoundAsset = new Track1Sound() as SoundAsset;
		
		
		public function LevelManager(m:Main, em:EnemyManager, nm:NodeManager, can:Stage,ui:UI)
		{	
			// Set all the level manager's references to the other managers
			this.main = m;
			this.enMan = em;
			this.noMan = nm;
			this.ui = ui;
			this.canvas =can;
			
			currLevel = 1;
			currGold = 250;
			prevGold = currGold;
			interest = 0.2;
			
			// Sets up start and end nodes for the level, with a position
			setStartEndNode();
			
			// Defines a text format to use for all our fields
			format = new TextFormat();
			format.color = 0x112222; 
			format.size = 10; 
			
			// Instantiate and initialize all our text displays
			levelText = new TextField();
			totalGoldText = new TextField();
			enemyOnBoardText = new TextField();
			currentGoldCostText = new TextField();
			enemiesRemainingText = new TextField();
			
			displayLevel();
			displayGold(currGold);
			displayEnemiesOnBoard(0);
			displayCurrentPlacementCost(0);
			displayEnemiesToCome(main.getEnemyManager().getNumEnemiesOnLevel());
			
			// Adds the text to the main display
			main.addChild(levelText);
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
			
			// TODO COMMENT BACK IN FOR FINAL BUILD
			// Play background music
			Track1FX.play(0,500); // Music loops for ~30 to 40 hours, if someone has it on that long they should probably stop anyway.
		}		
		
		public function canSpawnBigEnemy():Boolean{
			if (currLevel >= 2)
				return true;
			else
				return false;
		}
		
		public function canSpawnHatEnemy():Boolean{
			if (currLevel >= 3)
				return true;
			else
				return false;
		}
		
		public function isFireRoomAvailable():Boolean{
			return true;
		}
		
		public function isPitRoomAvailable():Boolean{
			if (currLevel >= 2)
				return true;
			else
				return false;
		}
		
		public function isSnakeRoomAvailable():Boolean{
			return true;
		}
		
		public function isSandRoomAvailable():Boolean{
			if (currLevel >= 3)
				return true;
			else
				return false;
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
			if (currLevel == 1){
				noMan.setEndNodePosition(420,250);
			}
			else if (currLevel == 2|| currLevel ==3){
				noMan.setEndNodePosition(200,300);
			}
			else { // if (currLevel >= 4) 
				noMan.setEndNodePosition(250,100);
			}
			
		}
		
		private function calculateGold(gold:Number):void{
			currGold = gold*(1.0+interest);
		}
		
		public function nextLevel(gold:Number):void{
			currLevel++;
			calculateGold(gold);
			reInitialize();//initialize nodemanger and enemymanager
			setStartEndNode();
		}
		
		private function setNumEnemiesAtLevel():void {
			if (currLevel == 1){
				this.enMan.setNumEnemiesOnLevel(30);
			}
			else if (currLevel == 2){
				this.enMan.setNumEnemiesOnLevel(50);
			}
			else if (currLevel == 3){
				this.enMan.setNumEnemiesOnLevel(70);
			}
			else if (currLevel == 4){
				this.enMan.setNumEnemiesOnLevel(100);
			}
			else {
				// Exponentially increase enemies after level 4
				this.enMan.setNumEnemiesOnLevel(100 + 2 ^ currLevel);
			}
		}
		
		private function reInitialize():void{
			enMan.removeTimer();
			this.main.removeChild(enMan);
			enMan = new EnemyManager(this.main);
			this.main.addChild(enMan);
			this.main.setEnemyManager(enMan);
			this.setNumEnemiesAtLevel();
			this.enMan.reInitialize();//set the right number and re-initialize everything
			
			this.main.setBuildPhase(true);
			this.main.removeChild(noMan);
			noMan = new NodeManager(this.main,69,365,200,300);
			this.main.addChild(noMan);
			this.main.setNodeManager(noMan);
			var uiIndex:Number = this.main.numChildren;
			this.main.setChildIndex(noMan,uiIndex - 1);//make sure that ui is NOT on top of node manager
			this.main.setChildIndex(enMan,uiIndex -1);
			this.main.setChildIndex(ui,uiIndex -1);
			this.setStartEndNode();//reset start end nodes

			this.main.setChildIndex(this.startPop,this.main.numChildren -1);
			displayLevel();
			displayEnemiesOnBoard(0);
			displayEnemiesToCome(main.getEnemyManager().getNumEnemiesOnLevel()); // Show the player what they will be facing
			displayGold(currGold);
		}
		
		// Displays the current level
		public function displayLevel():void {
			levelText.autoSize=TextFieldAutoSize.LEFT;
			levelText.text = "LEVEL: "+ currLevel;
			levelText.setTextFormat(format);
			levelText.x = 370;
			levelText.y = 70;
			levelText.selectable = false;			
		}
		
		// Function to initialize and edit the value of the total player gold
		public function displayGold(gold:Number):void {
			totalGoldText.autoSize=TextFieldAutoSize.LEFT;
			totalGoldText.text = "GOLD LEFT: "+ gold.toFixed(2);
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
			currentGoldCostText.x = 320;
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
		
		public function popWinWin():void{
			//main.removeChild(startPop);// the start pop up is just hiding, remove it after a level
			if (currGold > 0){
				startPop.gotoAndStop("maximize");
				startPop.addChild(nextButton);
				
				startTitle.text = "You Have Successfully Defended!  Proceed to Level "+ (currLevel+1)+"!";
				
				/*
				if (currLevel <4){
					startTitle.text = "You Have Successfully Defended!  Proceed to Level "+ (currLevel+1)+"!";
				}
				else{
					startTitle.text = "Congrats!! You Have Killed All the Enemies and Defended Your Treasures Well!!";
				}
				*/
				
				startPop.addChild(startTitle);
			}
		}
		
		public function getGoldAmt():Number{
			return currGold;
		}
	}
}