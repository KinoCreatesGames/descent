package game.ui;

class PlayerHUD extends FlxTypedGroup<FlxSprite> {
	public var position:FlxPoint;
	public var depthText:FlxText;
	public var scoreText:FlxText;
	public var healthVisual:Array<FlxSprite>;

	public function new(x:Float, y:Float) {
		super();
		position = new FlxPoint(x, y);
		create();
	}

	public function create() {
		createScore();
		createDepth();
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

	public function updateScore(value:Int) {
		var score = '${value}'.lpad('0', 3);
		scoreText.text = 'Score ${score}';
	}

	public function updateDepth(value:Float) {
		var depth = '${value}'.lpad('0', 3);
		depthText.text = 'Depth ${depth}';
	}
}