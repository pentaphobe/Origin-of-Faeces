package
{
	import flash.net.SharedObject;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class ScoreWorld extends World
	{
//		private var scoreTexts:Graphiclist;
		private var scoreText:Text = new Text("", 0, 0);
		private var scoresFile:SharedObject;
		private var gotName:Boolean = false;
		private var name:String = "nobody";
		private var textInput:TextBox;
		private var title:Image = new Image(Assets.HIGHSCORE);
		private var leaderBoard:Array = [
			// defaults
			{name:'darwin', distance:700, hearts:50},
			{name:'librarian', distance:700, hearts:40},
			{name:'ishmael', distance:650,  hearts:30},
			{name:'koko', distance:623, hearts:20},
			{name:'kong', distance:600, hearts:50},
			{name:'bubbles', distance:500, hearts:80},
			{name:'zaius', distance:450, hearts:10},
			{name:'specter', distance:400, hearts:20},
			{name:'massa', distance:300, hearts:100},
			{name:'heston', distance:-23, hearts:0},
		];
		public function ScoreWorld()
		{
			super();

		}
		override public function begin():void {
			textInput = new TextBox("your name:", this.nameCallback,0, 0);
			scoresFile = SharedObject.getLocal("leaderBoard");	
			
			// for testing purposes
//			scoresFile.clear();
			
			//			scoreTexts = new Graphiclist();
			//			for (var i:int=0;i<10;i++) {
			//				scoreTexts.add(new Text("", 10, i * 16));
			//			}
			//			add(new Entity(0, 0, scoreTexts));
			var titleBox:Entity = add(new Entity(FP.screen.width / 2 - title.width / 2, -5, title));
			add(new Entity(titleBox.x + 18, 65, scoreText));
			updateScores();
			
			var lowestScore:Number = leaderBoard[leaderBoard.length-1].combined || 0;
			if (calculateCombined(HUD.distanceRun / 16.0, HUD.pickups['brains'] || 0) > lowestScore) {
				add(textInput);	
			} else {
				gotName = true;
			}
			
			
			super.begin();
		}
		override public function update():void {
			super.update();
			if (!gotName) return;
			if (Input.pressed(Key.SPACE) || Input.pressed(Key.ESCAPE)) {
				FP.world = new MenuWorld;
			}
		}
		public function nameCallback(name:String):void {
			remove(textInput);
			gotName = true;
			this.name = name;
			addScore();			
		}
		public function updateScores():void {
			if (scoresFile.data.leaderBoard != null) {				
				leaderBoard = scoresFile.data.leaderBoard;
			} else {
				// calculate the combined score for the default set
				updateCombined();
			}
			leaderBoard.sortOn("combined", Array.NUMERIC | Array.DESCENDING);
			
			showScores();

		}
		public function addScore():void {
			var distance:Number = HUD.distanceRun / 16.0;
			var hearts:Number = HUD.pickups['brains'] || 0;
			var combined:Number = calculateCombined(HUD.distanceRun / 16.0, hearts);
			var entry:Object = {name:name, distance:distance, hearts:hearts, combined:combined};
			for (var i in leaderBoard) {
				if (distance > leaderBoard[i].distance) {
					leaderBoard.splice(i, 0, entry);
					leaderBoard.length = 10;
					break;
				}
			}
			scoresFile.data.leaderBoard = leaderBoard;
			scoresFile.flush();	
			showScores();

		}
		public function showScores():void {
			scoreText.text = "";
			for (var i in leaderBoard) {	
//				scoreTexts.children[i].text += i + " : " + leaderBoard[i].name + " " + leaderBoard[i].distance + "m";
				scoreText.text += i + " : " + leaderBoard[i].name + " " + leaderBoard[i].distance + "m, " + leaderBoard[i].hearts + " hearts\n";
			}			
		}
		override public function end():void {
			removeAll();
		}
		public function calculateCombined(distance:Number, hearts:Number):Number {
			return distance * 500 + hearts * 300;
		}
		public function updateCombined():void {
			leaderBoard.forEach(function (obj) {
				obj.combined = calculateCombined(obj.distance, obj.hearts);
			});
		}
	}
}