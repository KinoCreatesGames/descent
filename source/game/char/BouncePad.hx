package game.char;

class BouncePad extends Enemy {
	public function new(x:Float, y:Float) {
		super(x, y, null, null);
	}

	override public function setSprite() {
		loadGraphic(AssetPaths.bouncepad__png, true, 8, 8, true);
		this.immovable = true;
		animation.add('idle', [0], 6);
		animation.add('bounce', [1, 2, 0], 6);
		animation.finishCallback = (animName) -> {
			if (animName.contains('bounce')) {
				animation.play('idle');
			}
		};
	}
}