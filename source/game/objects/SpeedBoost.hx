package game.objects;

class SpeedBoost extends Collectible {
	public var boost:Float;

	override public function setSprite() {
		makeGraphic(8, 8, KColor.GREEN);
		boost = 25;
	}
}