package game.char;

class Spike extends Enemy {
	public function new(x:Float, y:Float) {
		super(x, y, [], null);
	}

	override public function setSprite() {
		makeGraphic(8, 8, KColor.RED);
	}
}