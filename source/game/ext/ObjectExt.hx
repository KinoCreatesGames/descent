package game.ext;

import flixel.FlxCamera;
import flixel.FlxObject;

function setScreenPosition(obj:FlxObject, point:FlxPoint, ?camera:FlxCamera) {
	if (camera == null) {
		camera = FlxG.camera;
	}

	if (obj.pixelPerfectPosition) {
		point.floor();
	}

	obj.setPosition((camera.scroll.x * obj.scrollFactor.x) + point.x,
		(camera.scroll.y * obj.scrollFactor.y) + point.y);
	return obj;
}