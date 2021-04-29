package game.char;

class BouncePad extends Enemy {
	public function new(x:Float, y:Float) {
		super(x, y, null, null);
	}

	override public function setSprite() {
		makeGraphic(8, 8, KColor.DARK_BYZANTIUM);
	}
}