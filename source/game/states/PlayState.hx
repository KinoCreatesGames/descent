package game.states;

import game.ui.PlayerHUD;
import game.objects.SpeedBoost;
import game.objects.Collectible;
import flixel.text.FlxText;
import flixel.FlxState;

enum EnemyType {
	EPad;
	ETurtle;
	ESpike;
}

class PlayState extends FlxState {
	public var player:Player;
	public var enemyGrp:FlxTypedGroup<Enemy>;
	public var playerBulletGrp:FlxTypedGroup<Bullet>;
	public var collectibleGrp:FlxTypedGroup<Collectible>;
	public var HUD:PlayerHUD;
	public var score:Int = 0;
	// Bonus Points from killing enemies
	public var enemyBonus:Int = 0;

	public static inline var SPAWN_TIME:Float = 1.5;
	public static inline var ENEMY_POINTS:Int = 150;

	public var spawnTimer:Float = 0;

	override public function create() {
		// camera.zoom = 2;
		super.create();
		bgColor = KColor.BEAU_BLUE;
		createGroups();
		createPlayer();
		createPlayerHUD();
		player.addCrossHair();
	}

	public function createPlayer() {
		player = new Player(24, 24, playerBulletGrp);
		add(player);
		FlxG.camera.follow(player, TOPDOWN_TIGHT, 1);
	}

	public function createPlayerHUD() {
		HUD = new PlayerHUD(0, 0, cast player.health);
		add(HUD);
	}

	public function createGroups() {
		enemyGrp = new FlxTypedGroup<Enemy>(200);
		playerBulletGrp = new FlxTypedGroup<Bullet>(50);

		add(playerBulletGrp);
		add(enemyGrp);
	}

	public function setupSignals() {
		player.damageSignal.add(HUD.updateHealth);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		processHUD(elapsed);
		processSpawning(elapsed);
		processDespawning();
		updateCursorPosition(elapsed);
		processCollisions();
	}

	function processHUD(elapsed:Float) {
		var depth = player.getPosition().y;
		score = Math.floor(depth / 10);
		var finalScore = score + enemyBonus;
		HUD.updateDepth(depth);
		HUD.updateScore(finalScore);
	}

	public function processSpawning(elapsed:Float) {
		if (spawnTimer > SPAWN_TIME) {
			spawnTimer = 0;
			// Spawn Enemies and Power Ups outside of view
			var tileCount = Math.floor(FlxG.width / 8);
			for (i in 0...tileCount) {
				if (i % 2 == 0) {
					var types = [EPad, ETurtle, ESpike];
					var element = types[FlxG.random.int(0, types.length - 1)];
					var x = i * 8;
					var y = FlxG.height + 48;
					var enemy = switch (element) {
						case EPad:
							new BouncePad(0, 0);
						case ETurtle:
							new Turtle(0, 0);
						case ESpike:
							new Spike(0, 0);
					}
					enemy.setScreenPosition(FlxPoint.weak(x, y));
					enemyGrp.add(enemy);
				}
			}
		}
		spawnTimer += elapsed;
	}

	public function processDespawning() {
		enemyGrp.members.iter((member) -> {
			if (member.getScreenPosition().y < 0) {
				member.kill();
			}
		});
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

		var enemyType:Class<Enemy> = Type.getClass(enemy);
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
		if (!enemy.alive) {
			HUD.updateScore(ENEMY_POINTS);
		}
		bullet.kill();
	}

	public function crossHairTouchEnemy(crossHair:FlxSprite, enemy:Enemy) {
		trace('Overlap enemy');
		player.currentTarget = enemy;
	}
}