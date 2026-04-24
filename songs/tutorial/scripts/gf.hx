function postCreate()
{
    gf.visible = false;
    dad.x += 200;
}

function onBeatHit()
{
    if (cameraController.currentTarget == 'opponent')
    {
        FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
    }
}