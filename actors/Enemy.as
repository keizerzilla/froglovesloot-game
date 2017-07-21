package actors {
	
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import core.Config;
	
	public class Enemy extends Entity {
		
		public const SIZE:uint = 32;
		
		public var direction:Number;
		public var armor:Image;
		public var originalPosition:Point;
		
		public function Enemy(xpos:Number, ypos:Number):void {
			type = "enemy";
			direction = xpos > 0 ? -1 : 1;
			armor = Image.createRect(SIZE, SIZE, 0xFFFFFF);
			
			originalPosition = new Point(xpos, ypos);
			
			setHitbox(SIZE, SIZE);
			super(originalPosition.x, originalPosition.y, armor);
		}
		
		override public function update():void {
			super.update();
			moveBy(direction * Config.ENEMY_SPEED * FP.elapsed, 0);
			
			if (direction > 0) {
				if (x - 1 > FP.width) {
					x = 0;
				}
			} else {
				if (x + width + 1 < 0) {
					x = FP.width;
				}
			}
		}
		
		public function reverse():void {
			direction = -direction;
		}
		
	}

}