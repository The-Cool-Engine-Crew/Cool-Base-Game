import funkin.system.CursorManager;

var _img:FlxSprite = null;
var _clicked:Bool = false;
var _baseScale:Float = 1.0;
var _colorFactor:Float = 1.0;

function onCreate() {
    if (_img != null) return;
    
	FlxG.camera.bgColor = FlxColor.BLACK;

	CursorManager.show();

	_img = new FlxSprite();
	_img.loadGraphic(Paths.image('touchHereToPlay'));
	_img.scrollFactor.set(0, 0);

	var maxW:Float = FlxG.width * 0.80;
	var maxH:Float = FlxG.height * 0.80;
	if (_img.width > maxW || _img.height > maxH) {
		var sc:Float = Math.min(maxW / _img.width, maxH / _img.height);
		_img.scale.set(sc, sc);
		_img.updateHitbox();
	}

	_baseScale = _img.scale.x;

	_img.screenCenter();
	add(_img);
}

function onUpdate(elapsed:Float) {
    if (_clicked || _img == null) return;

    var targetBright:Float = 1.0;
	var targetScale:Float = _baseScale;
    if (FlxG.mouse.overlaps(_img)) {
        targetScale = _baseScale * 1.05;
        targetBright = 0.7;
    }
    
    var currentScale:Float = _img.scale.x + (targetScale - _img.scale.x) * (elapsed * 15);
    _img.scale.set(currentScale, currentScale);

    _colorFactor = _colorFactor + (targetBright - _colorFactor) * (elapsed * 10);
    var colorVal:Int = Std.int(_colorFactor * 255);
    _img.color = FlxColor.fromRGB(colorVal, colorVal, colorVal);

    var pressed:Bool = false;

    if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(_img)) {
        pressed = true;
    }

    if (!pressed && FlxG.touches.list != null) {
        for (touch in FlxG.touches.list) {
            if (touch.justPressed && touch.overlaps(_img)) { 
                pressed = true;
                break; 
            }
        }
    }

	if (!pressed)
		return;

	_clicked = true;

    _img.color = 0xFFFFFF;

	FlxTween.tween(_img, {alpha: 0}, 0.4, {
		ease: FlxEase.quadIn,
		onComplete: function(_) {
			switchState('title');
			CursorManager.hide();
		}
	});
}
