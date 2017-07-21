package actors {
	
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	public class MuteButton extends Entity {
		
		[Embed(source = "../../res/img/mute_button.png")] public static const MUTE_BUTTON_GRAPHICS:Class;
		
		public var isMuted:Boolean;
		public var sheet:Spritemap;
		
		public function MuteButton():void {
			isMuted = false;
			setHitbox(32, 32);
			sheet = new Spritemap(MUTE_BUTTON_GRAPHICS, 32, 32);
			sheet.add("ON", [0]);
			sheet.add("OFF", [1]);
			super(FP.width - width, 0, sheet);
			sheet.play("ON");
		}
		
		override public function update():void {
			super.update();
			if (collidePoint(x, y, Input.mouseX, Input.mouseY)) {
				if (Input.mousePressed) {
					if (isMuted) {
						Main.theme.resume();
						sheet.play("ON");
					} else {
						Main.theme.stop();
						sheet.play("OFF");
					}
					isMuted = !isMuted;
				}
			}
		}
		
	}

}