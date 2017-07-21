package core {
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.masks.Grid;
	
	public class Map extends Entity {
		
		public function Map(image:Graphic, grid:Grid):void {
			super(0, 0, image, grid);
			type = "map";
		}
	}

}