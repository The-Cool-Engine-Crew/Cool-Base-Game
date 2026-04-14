function postCreate() {
	
}

function postStageCreate()
{
	cameraController.lock(640,460);
}

function onCountdownStarted()
{
	for (i in 0...cpuStrums.members.length) {
		cpuStrums.members[i].visible = false;
		cpuStrums.members[i].alpha = 0;
	}

	for (i in 0...playerStrums.members.length) {
		playerStrums.members[i].x -= (FlxG.width / 4);
	}
}