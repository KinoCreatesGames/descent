package game.objects;

class SpeedBoost extends Collectible {
	override public function setSprite() {
		makeGraphic(8, 8, KColor.GREEN);
	}
}