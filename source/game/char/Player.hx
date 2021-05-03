package game.char;

import flixel.util.FlxSignal;
import flixel.math.FlxVector;
import flixel.math.FlxMath;

class Player extends FlxSprite {
	public static inline var MOVE_SPEED:Float = 120;
	public static inline var DRAG_X:Float = 100;
	public static inline var GRAVITY:Float = 100;
	public static inline var INVINCIBLE_TIME:Float = 1.5;

	public var invincible:Bool = false;
	public var crossHair:FlxSprite;
	public var currentTarget:Enemy;
	public var bulletGrp:FlxTypedGroup<Bullet>;
	public var speedBonus:Float;
	public var damageSignal:FlxTypedSignal<Int -> Void>;

	public static inline var BULLET_SPEED:Float = 400;

	public function new(x:Float, y:Float, bulletGrp:FlxTypedGroup<Bullet>) {
		super(x, y);
		drag.x = DRAG_X;
		this.bulletGrp = bulletGrp;
		speedBonus = 0;
		this.health = 3;
		create();
	}

	public function create() {
		createAnimation();
		createSignal();
		createBullets();
		createPlayer();
		createCrossHair();
	}

	public function createAnimation() {
		loadGraphic(AssetPaths.player_cat__png, true, 8, 8, true);
		animation.add('falling', [0, 1, 2], 6);
		animation.play('falling');
	}

	public function createSignal() {
		damageSignal = new FlxTypedSignal<Int -> Void>();
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
		if (!invincible) {
			this.health -= val;
			FlxG.camera.shake(0.01, 0.2);
			invincible = true;
			// Sends a signal on the current player health
			damageSignal.dispatch(cast this.health);
			this.flicker(INVINCIBLE_TIME, 0.04, true, (_) -> {
				invincible = false;
			});
		}
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

	public function addSpeedBonus(value:Float) {
		speedBonus += value;
	}

	public function updateMovement(elapsed:Float) {
		var left = FlxG.keys.anyPressed([A, LEFT]);
		var right = FlxG.keys.anyPressed([D, RIGHT]);
		this.maxVelocity.set(MOVE_SPEED, MOVE_SPEED + speedBonus);
		velocity.x = 0;
		var direction = 1;

		if (left || right) {
			if (left) {}
			direction = -1;
			if (right) {
				direction = 1;
			}
			velocity.x = direction * MOVE_SPEED;
		}
		acceleration.y = GRAVITY + speedBonus;
		// Bind the X value of the sprite character on x axis
		this.x = FlxMath.bound(this.x, 0, FlxG.width);
	}
}