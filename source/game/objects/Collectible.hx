package game.objects;

class Collectible extends FlxSprite {
	public static inline var VARIANCE:Float = 4;

	public var elapsedTime:Float;
	public var initialX:Float;

	public function new(x:Float, y:Float) {
		super(x, y);
		initialX = x;
		setSprite();
	}

	public function setSprite() {}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		waveBounce(elapsed);
	}

	public function waveBounce(elapsed:Float) {
		elapsedTime += elapsed;
		this.x = this.initialX + Math.sin(elapsedTime) * VARIANCE;
	}
}