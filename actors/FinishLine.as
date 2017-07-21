package actors {
	
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Ease;
	
	public class FinishLine extends Entity {
		
		[Embed(source = "../../res/sfx/coins.mp3")] public static const LOOT_GET_SFX:Class;
		
		public var stamp:Image;
		public var emitter:Emitter;
		public var lootGetSFX:Sfx;
		
		public function FinishLine(xpos:Number, ypos:Number):void {
			stamp = Image.createRect(416, 32, 0xFFFF00);
			super(xpos, ypos, stamp);
			setHitbox(416, 32);
			type = "finish";
			
			emitter = new Emitter(new BitmapData(4, 4, false, 0xFFFF00));
			emitter.newType("COINS", [0]);
			emitter.setMotion("COINS", 0, 50, 1, 360, -40, -0.5, Ease.quartOut);
			emitter.relative = false;
			
			addGraphic(emitter);
			lootGetSFX = new Sfx(LOOT_GET_SFX);
		}
		
		public function getLoot():void {
			lootGetSFX.play();
			for (var i:uint = 0; i < 40; i++) {
				emitter.emit("COINS", x + (1 * width / 8), y + halfHeight);
				emitter.emit("COINS", x + (2 * width / 8), y + halfHeight);
				emitter.emit("COINS", x + (3 * width / 8), y + halfHeight);
				emitter.emit("COINS", x + (4 * width / 8), y + halfHeight);
				emitter.emit("COINS", x + (5 * width / 8), y + halfHeight);
				emitter.emit("COINS", x + (6 * width / 8), y + halfHeight);
				emitter.emit("COINS", x + (7 * width / 8), y + halfHeight);
			}
			
			if (y == 32) {
				y = FP.height - 96;
			} else {
				y = 32;
			}
		}
		
	}

}