function postCreate() {
    bg.shader = null;
    bg.loadGraphic(Paths.getGraphic('menu/freakyMenu'));
    centerOptions();
}

function onSelectionChanged(curSelected:Int) {
	centerOptions();
}

function centerOptions() {
	menuItems.forEach(function(spr:FunkinSprite) {
		spr.x = (FlxG.width / 2) - (spr.width / 2) - 15;
		spr.centerOffsets();

		if (spr.get_animName() == 'selected'){
            switch (spr.ID)
            {
                case 0:
                    spr.offset.x -= 30;
                case 1:
                    spr.offset.x -= 23;
                case 3:
                    spr.offset.x += 5;
                default:
                    spr.offset.x -= 10;
            }
        }
	});
}
