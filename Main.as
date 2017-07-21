package {
	
	import core.Game;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	
	public class Main extends Engine {
		
		[Embed(source = "../res/doc/credits.txt", mimeType = "application/octet-stream")] public static const CREDITS:Class;
		[Embed(source = "../res/music/main_theme_frogger.mp3")] public static const THEME:Class;
		[Embed(source = "../res/music/intro_frogger.mp3")] public static const INTRO:Class;
		
		public static var theme:Sfx;
		public static var intro:Sfx;
		
		public function Main():void {
			super(480, 640);
			FP.world = new Game();
			theme = new Sfx(THEME);
			intro = new Sfx(INTRO);
			FP.volume = 0.5;
		}
		
	}
	
}