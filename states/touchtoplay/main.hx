import funkin.system.CursorManager;

var _img:FlxSprite     = null;
var _pulse             = null;
var _clicked:Bool      = false;

function onCreate() {
    FlxG.camera.bgColor = FlxColor.BLACK;

    CursorManager.show();

    _img = new FlxSprite();
    _img.loadGraphic(Paths.image('touchHereToPlay'));
    _img.scrollFactor.set(0, 0);

    var maxW:Float = FlxG.width  * 0.80;
    var maxH:Float = FlxG.height * 0.80;
    if (_img.width > maxW || _img.height > maxH) {
        var sc:Float = Math.min(maxW / _img.width, maxH / _img.height);
        _img.scale.set(sc, sc);
        _img.updateHitbox();
    }

    _img.screenCenter();
    _img.alpha = 0;
    add(_img);

    FlxTween.tween(_img, {alpha: 1.0}, 0.6, {
        ease: FlxEase.quadOut,
        onComplete: function(_) {
            _pulse = FlxTween.tween(_img, {alpha: 0.40}, 0.9, {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            });
        }
    });
}

function onUpdate(elapsed:Float) {
    if (_clicked) return;

    var pressed:Bool = FlxG.mouse.justPressed;

    if (!pressed && FlxG.touches.list != null) {
        for (touch in FlxG.touches.list) {
            if (touch.justPressed) { pressed = true; break; }
        }
    }

    if (!pressed) return;

    _clicked = true;

    if (_pulse != null) {
        _pulse.cancel();
        _pulse = null;
    }

    FlxTween.tween(_img, {alpha: 0}, 0.4, {
        ease: FlxEase.quadIn,
        onComplete: function(_) {
            switchState('title');
            CursorManager.hide();
        }
    });
}

function onDestroy() {
    if (_pulse != null) {
        _pulse.cancel();
        _pulse = null;
    }
}
