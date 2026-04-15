var lightningTimer:Float = 3.0;
var lightningActive:Bool = true;
var lightning = null;
var skyAdditive = null;
var foregroundMultiply = null;
var additionalLighten = null;

function postCreate() {
	boyfriend.color = 0xFFDEDEDE;
	dad.color = 0xFFDEDEDE;
	gf.color = 0xFF888888;
	lightningActive = true;

	dad.scale.set(1.6, 1.6);
	boyfriend.scale.set(1.6, 1.6);
}

function onStageCreate() {
	lightning = stage.getElement('lightning');
	skyAdditive = stage.getElement('skyAdditive');
	foregroundMultiply = stage.getElement('foregroundMultiply');
	additionalLighten = stage.getElement('additionalLighten');
}

function onUpdate(elapsed) {
	if (lightningActive) {
		lightningTimer -= FlxG.elapsed;
	} else {
		lightningTimer = 1;
	}

	if (lightningTimer <= 0) {
		applyLightning();
		lightningTimer = FlxG.random.float(7, 15);
	}
}

function applyLightning():Void {
	var LIGHTNING_FULL_DURATION = 1.5;
	var LIGHTNING_FADE_DURATION = 0.3;

	skyAdditive.visible = true;
	skyAdditive.alpha = 0.7;
	FlxTween.tween(skyAdditive, {alpha: 0.0}, LIGHTNING_FULL_DURATION, {
		onComplete: cleanupLightning, // Make sure to call this only once!
	});

	foregroundMultiply.visible = true;
	foregroundMultiply.alpha = 0.64;
	FlxTween.tween(foregroundMultiply, {alpha: 0.0}, LIGHTNING_FULL_DURATION);

	additionalLighten.visible = true;
	additionalLighten.alpha = 0.3;
	FlxTween.tween(additionalLighten, {alpha: 0.0}, LIGHTNING_FADE_DURATION);

	lightning.visible = true;
	lightning.animation.play('strike');

	if (FlxG.random.bool(65)) {
		lightning.x = FlxG.random.int(-250, 280);
	} else {
		lightning.x = FlxG.random.int(780, 900);
	}

	// Darken characters
	var bf = chars.bf();
	FlxTween.color(bf, LIGHTNING_FADE_DURATION, 0xFF606060, 0xFFDEDEDE);
	var dad = chars.dad();
	FlxTween.color(dad, LIGHTNING_FADE_DURATION, 0xFF606060, 0xFFDEDEDE);
	var gf = chars.gf();
	FlxTween.color(gf, LIGHTNING_FADE_DURATION, 0xFF606060, 0xFF888888);

	// Sound
	if (!inCutscene)
		FlxG.sound.play(Paths.soundRandomStage('Lightning', 1, 3), 1.0);
}

function cleanupLightning(tween:FlxTween):Void {
	skyAdditive.visible = false;
	foregroundMultiply.visible = false;
	additionalLighten.visible = false;
	lightning.visible = false;
}
