import funkin.audio.MusicManager;

var secretPattern:Array<String> = ["LEFT", "RIGHT", "LEFT", "RIGHT", "UP", "DOWN", "UP", "DOWN"];
var stepActual:Int = 0;
var discoMode:Bool = false;
var discoHue:Float = 0.0;

function onUpdatePost(elapsed) {
	var inputActual:String = "";

	if (controls.LEFT_P)
		inputActual = "LEFT";
	else if (controls.RIGHT_P)
		inputActual = "RIGHT";
	else if (controls.UP_P)
		inputActual = "UP";
	else if (controls.DOWN_P)
		inputActual = "DOWN";

	if (inputActual != "") {
		if (inputActual == secretPattern[stepActual]) {
			stepActual++;
			if (stepActual >= secretPattern.length) {
				onDiscoMode();
				stepActual = 0;
			}
		} else {
			var newStep = 0;
			if (stepActual > 0) {
				var temp = stepActual - 1;
				while (temp > 0 && secretPattern[temp] != inputActual)
					temp--;
				if (secretPattern[temp] == inputActual)
					newStep = temp + 1;
			}
			if (newStep == 0 && inputActual == secretPattern[0])
				newStep = 1;
			stepActual = newStep;
		}
	}

	if (discoMode) {
		discoHue = (discoHue + elapsed * 30) % 360;

		var colLogo = FlxColor.fromHSB(discoHue, 0.7, 1.0);
		var colGf   = FlxColor.fromHSB((discoHue + 90) % 360, 0.7, 1.0);
		var colText = FlxColor.fromHSB((discoHue + 180) % 360, 0.7, 1.0);
		var colBg   = FlxColor.fromHSB((discoHue + 270) % 360, 0.4, 0.9);

		if (logoBl != null)    logoBl.color    = colLogo;
		if (gfDance != null)   gfDance.color   = colGf;
		if (titleText != null) titleText.color = colText;
		if (bg != null)        bg.color        = colBg;
	}
}

function onDiscoMode() {
	trace("=== DISCO MODE ON ===");
	if (discoMode) return;
	discoMode = true;

	MusicManager.play('girlfriendsRingtone/girlfriendsRingtone', 0.7, true);
	FlxG.camera.flash(FlxColor.WHITE, 0.5);
}
