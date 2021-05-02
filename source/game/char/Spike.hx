package game.char;

class Spike extends Enemy {
	public function new(x:Float, y:Float) {
		super(x, y, [], null);
		health = 2;
	}

	override public function setSprite() {
		loadGraphic(AssetPaths.spike__png, true, 8, 8, true);
		// No Animation spike is spike.
	}
}