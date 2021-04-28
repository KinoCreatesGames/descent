package game.states;

import flixel.text.FlxText;
import flixel.FlxState;

class PlayState extends FlxState {
	public var player:Player;
	public var enemyGrp:FlxTypedGroup<Enemy>;

	override public function create() {
		super.create();
		bgColor = KColor.BEAU_BLUE;
		createPlayer();
		createGroups();
		player.addCrossHair();
	}

	public function createPlayer() {
		player = new Player(24, 24);
		add(player);
		FlxG.camera.follow(player, TOPDOWN, 2);
	}

	public function createGroups() {
		enemyGrp = new FlxTypedGroup<Enemy>();
		var enemy = new Enemy(32, 32, [], null);
		enemyGrp.add(enemy);
		add(enemyGrp);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		processCollisions();
	}

	public function processCollisions() {
		enemyGrp.members.iter((enemy) -> {
			if (player.crossHair.overlaps(enemy, true)) {
				player.currentTarget = enemy;
			} else {
				player.currentTarget = null;
			}
		});
		// if (!FlxG.overlap(player.crossHair, enemyGrp, crossHairTouchEnemy)) {
		// 	player.currentTarget = null;
		// }
	}

	public function crossHairTouchEnemy(crossHair:FlxSprite, enemy:Enemy) {
		trace('Overlap enemy');
		player.currentTarget = enemy;
	}
}