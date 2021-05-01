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
	}

	override public function setSprite() {
		makeGraphic(8, 8, KColor.YELLOW);
	}
}