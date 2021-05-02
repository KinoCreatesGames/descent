package game.objects;

class SpeedBoost extends Collectible {
	public var boost:Float;

	override public function setSprite() {
		loadGraphic(AssetPaths.energy_boost__png, false, 8, 8, false);
		boost = 25;
	}
}