package game.states;

import game.objects.SpeedBoost;
import game.objects.Collectible;
import flixel.text.FlxText;
import flixel.FlxState;

class PlayState extends FlxState {
	public var player:Player;
	public var enemyGrp:FlxTypedGroup<Enemy>;
	public var playerBulletGrp:FlxTypedGroup<Bullet>;
	public var collectibleGrp:FlxTypedGroup<Collectible>;

	override public function create() {
		super.create();
		bgColor = KColor.BEAU_BLUE;
		createGroups();
		createPlayer();
		player.addCrossHair();
	}

	public function createPlayer() {
		player = new Player(24, 24, playerBulletGrp);
		add(player);
		FlxG.camera.follow(player, TOPDOWN_TIGHT, 1);
	}

	public function createGroups() {
		enemyGrp = new FlxTypedGroup<Enemy>();
		var enemy = new Turtle(40, 40);
		enemyGrp.add(enemy);

		playerBulletGrp = new FlxTypedGroup<Bullet>(50);

		add(playerBulletGrp);
		add(enemyGrp);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updateCursorPosition(elapsed);
		processCollisions();
	}

	public function updateCursorPosition(elapsed:Float) {
		var scrnPos = FlxG.mouse.getScreenPosition();
		var diffX = FlxG.mouse.x - scrnPos.y;
		var diffY = FlxG.mouse.y - scrnPos.y;

		player.crossHair.setPosition(scrnPos.x, scrnPos.y);
	}

	public function processCollisions() {
		enemyGrp.members.iter((enemy) -> {
			if (player.crossHair.overlaps(enemy, true)) {
				player.currentTarget = enemy;
			} else {
				player.currentTarget = null;
			}
		});

		FlxG.collide(player, enemyGrp, playerTouchEnemy);
		FlxG.overlap(player, collectibleGrp, playerTouchCollectible);
		FlxG.overlap(playerBulletGrp, enemyGrp, playerBulletTouchEnemy);
	}

	public function playerTouchEnemy(player:Player, enemy:Enemy) {
		// Player Only takes 1 damage

		var enemyType = Type.getClass(enemy);
		switch (enemyType) {
			case BouncePad:

			case Spike:
				player.takeDamage();
				enemy.kill();
			case Turtle:
		}
	}

	public function playerTouchCollectible(player:Player,
			collectible:Collectible) {
		var collectibleType = Type.getClass(collectible);
		switch (collectibleType) {
			case SpeedBoost:
				var bonus:SpeedBoost = cast collectible;
				player.addSpeedBonus(bonus.boost);
				collectible.kill();
		}
	}

	public function playerBulletTouchEnemy(bullet:Bullet, enemy:Enemy) {
		enemy.takeDamage();
		bullet.kill();
	}

	public function crossHairTouchEnemy(crossHair:FlxSprite, enemy:Enemy) {
		trace('Overlap enemy');
		player.currentTarget = enemy;
	}
}