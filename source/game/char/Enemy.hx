package game.char;

import flixel.math.FlxVelocity;

class Enemy extends game.char.Actor {
	public static inline var GRAVITY:Float = 100;

	public var walkPath:Array<FlxPoint>;
	public var points:Int;

	public function new(x:Float, y:Float, path:Array<FlxPoint>,
			monsterData:MonsterData) {
		super(x, y, monsterData);
		walkPath = path;
		if (monsterData != null) {
			points = monsterData.points;
		}
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updateMovement(elapsed);
	}

	public function updateMovement(elapsed:Float) {}
}