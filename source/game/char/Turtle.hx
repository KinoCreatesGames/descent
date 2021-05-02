package game.char;

import flixel.util.FlxPath;

/**
 * Turtle AI, move left and right
 */
class Turtle extends Enemy {
	public static inline var TURTLE_SPEED:Float = 50;

	public function new(x:Float, y:Float) {
		var dir = FlxG.random.sign();
		var loopPath = [new FlxPoint(0, y), new FlxPoint(FlxG.width, y)];
		super(x, y, loopPath, null);
		this.path = new FlxPath(this.walkPath);
		var pathType = dir == -1 ? FlxPath.LOOP_FORWARD : FlxPath.LOOP_BACKWARD;
		this.path.start(null, TURTLE_SPEED, pathType);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		// updateAnim(elapsed);
	}

	public function updateAnim(elapsed) {
		animation.play('moving');
	}

	override public function setSprite() {
		loadGraphic(AssetPaths.turtle_descent__png, true, 8, 8, true);
		animation.add('moving', [1, 0, 2], 6);
		animation.play('moving');
	}
}