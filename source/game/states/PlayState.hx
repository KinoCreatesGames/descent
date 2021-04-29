package game.states;

import flixel.text.FlxText;
import flixel.FlxState;

class PlayState extends FlxState {
	public var player:Player;
	public var enemyGrp:FlxTypedGroup<Enemy>;
	public var playerBulletGrp:FlxTypedGroup<Bullet>;

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
		var enemy = new Turtle(32, 32);
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

		FlxG.overlap(player, enemyGrp, playerTouchEnemy);
	}

	public function playerTouchEnemy(player:Player, enemy:Enemy) {
		// Player Only takes 1 damage
		player.takeDamage();
	}

	public function crossHairTouchEnemy(crossHair:FlxSprite, enemy:Enemy) {
		trace('Overlap enemy');
		player.currentTarget = enemy;
	}
}