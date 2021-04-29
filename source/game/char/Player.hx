package game.char;

import flixel.math.FlxVector;
import flixel.math.FlxMath;

class Player extends FlxSprite {
	public static inline var MOVE_SPEED:Float = 120;
	public static inline var DRAG_X:Float = 100;
	public static inline var GRAVITY:Float = 100;

	public var crossHair:FlxSprite;
	public var currentTarget:Enemy;
	public var bulletGrp:FlxTypedGroup<Bullet>;

	public static inline var BULLET_SPEED:Float = 150;

	public function new(x:Float, y:Float, bulletGrp:FlxTypedGroup<Bullet>) {
		super(x, y);
		drag.x = DRAG_X;
		this.bulletGrp = bulletGrp;
		makeGraphic(8, 8, KColor.WHITE);
		create();
	}

	public function create() {
		createBullets();
		createPlayer();
		createCrossHair();
	}

	public function createBullets() {
		for (i in 0...bulletGrp.maxSize) {
			var bullet = new Bullet();
			bullet.kill();
			bullet.makeGraphic(4, 4, KColor.WHITE);
			bulletGrp.add(bullet);
		}
	}

	public function createPlayer() {}

	public function createCrossHair() {
		var pos = getPosition();
		crossHair = new FlxSprite(pos.x, pos.y);
		crossHair.loadGraphic(AssetPaths.cross_hair__png, true, 8, 8, true);
		crossHair.animation.add('std', [0]);
		crossHair.animation.add('target', [1]);
		crossHair.scrollFactor.set(0, 0);
		// FlxG.mouse.load(crossHair.framePixels);
	}

	public function addCrossHair() {
		if (crossHair != null) {
			FlxG.state.add(crossHair);
		}
	}

	public function takeDamage(?val:Int) {
		val = val == null ? 1 : val;
		this.health -= val;
		FlxG.camera.shake(0.01, 0.2);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updateFire(elapsed);
		updateCrossHair(elapsed);
		updateMovement(elapsed);
	}

	public function updateFire(elapsed:Float) {
		var pt = this.getScreenPosition();
		var pt2 = crossHair.getPosition();
		var ptR = this.getPosition();
		var result = new FlxVector(pt2.x - pt.x, pt2.y - pt.y).normalize();
		var spacing = 4;

		if (FlxG.mouse.justPressed) {
			var bullet = bulletGrp.recycle();
			bullet.setPosition(ptR.x + spacing, ptR.y);
			var angle = result.degreesBetween(FlxPoint.weak(1, 0));

			bullet.getPosition().rotate(ptR, angle);
			bullet.velocity.set(result.x * BULLET_SPEED,
				result.y * BULLET_SPEED);
		}
	}

	public function updateCrossHair(elapsed:Float) {
		if (crossHair != null) {
			if (currentTarget != null) {
				crossHair.animation.play('target');
			} else {
				crossHair.animation.play('std');
			}
		}
	}

	public function updateMovement(elapsed:Float) {
		var left = FlxG.keys.anyPressed([A, LEFT]);
		var right = FlxG.keys.anyPressed([D, RIGHT]);
		velocity.x = 0;
		var direction = 1;
		// var mousePos = FlxG.mouse.getWorldPosition()
		// 	.copyTo(FlxPoint.weak(0, 0));
		// var scPos = FlxG.mouse.getScreenPosition();
		// crossHair.setPosition(scPos.x, scPos.y);
		// crossHair.setPosition(FlxG.mouse.x, FlxG.mouse.y);

		if (left || right) {
			if (left) {}
			direction = -1;
			if (right) {
				direction = 1;
			}
			velocity.x = direction * MOVE_SPEED;
		}
		// acceleration.y = GRAVITY;
		// Bind the X value of the sprite character on x axis
		this.x = FlxMath.bound(this.x, 0, FlxG.width);
	}
}