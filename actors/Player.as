package actors {
	
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Ease;
	
	public class Player extends Entity {
		
		[Embed(source = "../../res/sfx/explosion.mp3")] public static const EXPLOSION_SOUND:Class;
		[Embed(source = "../../res/sfx/jumpHigh.mp3")] public static const JUMP_UP:Class;
		[Embed(source = "../../res/sfx/jumpLow.mp3")] public static const JUMP_DOWN:Class;
		
		public const SIZE:uint = 32;
		public const SPEED:Number = 200;
		
		public var stamp:Image;
		public var lives:uint;
		public var emitter:Emitter;
		public var explosionSFX:Sfx;
		public var jumpUP:Sfx;
		public var jumpDOWN:Sfx;
		
		public function Player(xpos:Number, ypos:Number):void {
			stamp = Image.createRect(SIZE, SIZE, 0x00FA01);
			
			setHitbox(SIZE, SIZE);
			super(xpos, ypos, stamp);
			
			type = "player";
			lives = 3;
			
			emitter = new Emitter(new BitmapData(5, 5, false, 0x00FF00), 5, 5);
			emitter.newType("explosion", [0]);
			emitter.setMotion("explosion", 0, 50, 2, 360, -40, -0.5, Ease.quartOut);
			emitter.relative = false;
			
			addGraphic(emitter);
			
			explosionSFX = new Sfx(EXPLOSION_SOUND);
			jumpDOWN = new Sfx(JUMP_DOWN);
			jumpUP = new Sfx(JUMP_UP);
		}
		
		public function input():void {
			if (Input.pressed(Key.UP)) {
				if (y - 2 * height > 0) {
					y -= 2 * height;
					jumpUP.play();
				}
			} else if (Input.pressed(Key.DOWN)) {
				if (y + 2 * height < FP.height - 64) {
					y += 2 * height;
					jumpDOWN.play();
				}
			} else if (Input.check(Key.LEFT)) {
				moveBy(-1 * SPEED * FP.elapsed, 0, "map");
			} else if (Input.check(Key.RIGHT)) {
				moveBy(SPEED * FP.elapsed, 0, "map");
			}
		}
		
		public function die():void {
			explosionSFX.play();
			lives--;
			collidable = false;
			stamp.visible = false;
			for (var i:uint = 0; i < 80; i++) {
				emitter.emit("explosion", centerX, centerY);
			}
		}
		
		public function reborn(xpos:Number, ypos:Number):void {
			collidable = true;
			stamp.visible = true;
			x = xpos;
			y = ypos;
		}
		
	}

}