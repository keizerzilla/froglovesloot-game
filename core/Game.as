package core {
	
	import actors.Enemy;
	import actors.FinishLine;
	import actors.MuteButton;
	import actors.Player;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.graphics.Image;
	
	public class Game extends World{
		
		[Embed(source = "../../res/ogmo/map.oel", mimeType = "application/octet-stream")] public static const MAP:Class;
		
		public const STATE_INITING:uint = 0;
		public const STATE_RUNNING:uint = 1;
		public const STATE_FAILURE:uint = 2;
		public const STATE_FINISH:uint = 3;
		
		public var currentState:uint;
		public var player:Player;
		public var lootText:Text;
		public var finishLine:FinishLine;
		public var loot:int;
		public var mapImage:Graphic;
		public var mapGrid:Grid;
		public var map:Map;
		public var timer:Number;
		public var checkpoint:Point;
		public var muteButton:MuteButton;
		public var enemies:Array;
		
		public function Game():void {
			loot = -1;
			lootText = new Text("");
			lootText.align = "center";
			lootText.size = 32;
			Config.ENEMY_SPEED = Config.MINIMUM_ENEMY_SPEED;
			enemies = new Array();
			loadMap();
			updateLoot();
			timer = 0;
			checkpoint = new Point(player.x, player.y);
			muteButton = new MuteButton();
		}
		
		override public function begin():void {
			super.begin();
			FP.screen.color = 0x000000;
			setState(STATE_INITING);
			addGraphic(lootText);
			add(map);
			add(finishLine);
			add(player);
			add(muteButton);
			//Main.theme.loop();
			Main.intro.play();
		}
		
		public function updateUI():void {
			lootText.text = "LIVES: " + player.lives + "       LOOT: " + loot;
			lootText.x = FP.halfWidth - lootText.width / 2;
			lootText.y = FP.height - lootText.height + 4;
		}
		
		public function updateCheckPoint():void {
			checkpoint.x = finishLine.x + finishLine.halfWidth - player.halfWidth;
			checkpoint.y = finishLine.y;
		}
		
		public function setState(state:uint):void {
			currentState = state;
		}
		
		public function updateInitingState():void {
			/*timer += FP.elapsed;
			if (timer < 4) {
				finishLine.stamp.alpha = 1 + (Math.sin(2.5 * timer * Math.PI)) * 0.5;
			} else {
				timer = 0;
				addList(enemies);
				setState(STATE_RUNNING);
			}*/
			
			if (!Main.intro.playing) {
				addList(enemies);
				setState(STATE_RUNNING);
				Main.theme.loop();
			}
		}
		
		public function updateLoot():void {
			loot++;
			updateUI();
			Config.ENEMY_SPEED += 12;
			var e:Enemy = null;
			for each(e in enemies) {
				e.armor.color -= 0x001111;
			}
		}
		
		public function updateRunningState():void {
			player.input();
			
			if (player.collide("enemy", player.x, player.y)) {
				player.die();
				setState(STATE_FAILURE);
			}
			
			if (player.collideWith(finishLine, player.x, player.y)) {
				updateCheckPoint();
				finishLine.getLoot();
				updateLoot();
			}
		}
		
		public function updateFailureState():void {
			if (player.lives == 0) {
				Main.theme.stop();
				setState(STATE_FINISH);
			} else {
				if (timer < 2) {
					timer += FP.elapsed;
				} else {
					timer = 0;
				    player.reborn(checkpoint.x, checkpoint.y);
					updateUI();
					setState(STATE_RUNNING);
				}
			}
		}
		
		public function updateFinishState():void {
			lootText.size = 16;
			lootText.text = "GAME OVER ): LOOT: " + loot + "\n[UP] TO TRY AGAIN";
			lootText.x = FP.halfWidth - lootText.width / 2;
			lootText.y = FP.height - lootText.height + 2;
			if (Input.pressed(Key.UP)) {
				FP.world = new Game();
			}
		}
		
		override public function update():void {
			super.update();
			
			switch(currentState) {
				case STATE_INITING:
					updateInitingState();
					break;
				case STATE_RUNNING:
					updateRunningState();
					break;
				case STATE_FAILURE:
					updateFailureState();
					break;
				case STATE_FINISH:
					updateFinishState();
					break;
				default:
					trace("SOMETHING WENT WRONG, CAPTAIN!");
					break;
			}
		}
		
		public function loadMap():void {
			var mapXML:XML = FP.getXML(MAP);
			var node:XML = null;
			
			mapGrid = new Grid(uint(mapXML.@width), uint(mapXML.@height), 32, 32, 0, 0);
			mapGrid.loadFromString(String(mapXML.grid), "", "\n");
			
			player = new Player(int(mapXML.entities.player.@x), int(mapXML.entities.player.@y));
			finishLine = new FinishLine(int(mapXML.entities.finish.@x), int(mapXML.entities.finish.@y));
			
			for each(node in mapXML.entities.enemy) {
				var e:Enemy = new Enemy(int(node.@x), int(node.@y));
				e.layer = 10;
				enemies.push(e);
			}
			
			if (mapImage == null) {
				var mi:Image = new Image(mapGrid.data);
				mi.color = 0x2F4F4F;
				mi.scale = 32;
				mapImage = mi;
			}
			
			map = new Map(mapImage, mapGrid);
		}
		
	}

}