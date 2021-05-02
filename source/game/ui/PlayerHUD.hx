package game.ui;

import flixel.math.FlxMath;

class PlayerHUD extends FlxTypedGroup<FlxSprite> {
	public var position:FlxPoint;
	public var depthText:FlxText;
	public var scoreText:FlxText;
	public var currentHealth:Int;
	public var healthVisual:Array<FlxSprite>;

	public function new(x:Float, y:Float, health:Int) {
		super();
		position = new FlxPoint(x, y);
		currentHealth = health;
		create();
	}

	public function create() {
		createHealth();
		createScore();
		createDepth();
		members.iter((member) -> {
			member.scrollFactor.set(0, 0);
		});
	}

	public function createHealth() {
		healthVisual = [];
		var x = position.x;
		var y = position.y;
		var spacing = 8;
		var padding = 24;

		for (i in 0...currentHealth) {
			var healthSprite = new FlxSprite(padding * x, y);
			healthSprite.loadGraphic(AssetPaths.heart_descent__png, false, 8,
				8, false);
			healthVisual.push(healthSprite);
			add(healthSprite);
			x += 16 + spacing;
		}
	}

	public function createScore() {
		scoreText = new FlxText(20, 20, -1, 'Score', Globals.FONT_N);
		scoreText.screenCenterHorz();
		add(scoreText);
	}

	public function createDepth() {
		var pos = position;
		depthText = new FlxText(20, 20, -1, 'Depth', Globals.FONT_N);
		add(depthText);
	}

	public function updateHealth(value:Int) {
		var val:Int = cast(healthVisual.length - currentHealth).clampf(0, 3);
		if (currentHealth < value) {
			if (!healthVisual[0].visible) healthVisual.reverse();
			healthVisual.slice(0, value).iter(showHealth);
		} else if (currentHealth > value) {
			if (healthVisual[0].visible) healthVisual.reverse();
			healthVisual.slice(0, val).iter(hideHealth);
		}
		currentHealth = value;
	}

	public function updateScore(value:Int) {
		var score = '${value}'.lpad('0', 3);
		scoreText.text = 'Score ${score}';
	}

	public function updateDepth(value:Float) {
		var depth = '${FlxMath.roundDecimal(value, 2)}'.lpad('0', 3);

		depthText.text = 'Depth ${depth}';
	}

	public function showHealth(health:FlxSprite) {
		health.visible = true;
	}

	public function hideHealth(health:FlxSprite) {
		health.visible = false;
	}
}