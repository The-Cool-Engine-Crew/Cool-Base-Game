function onBeatHit(beat)
{
	if (storyDifficulty < 3)
	{	
		if (beat % 8 == 7)
		{
			if (boyfriend != null && boyfriend.hasAnimation('hey'))
				characterController.playSpecialAnim(boyfriend, 'hey');

			if (gf != null && gf.hasAnimation('cheer'))
				characterController.playSpecialAnim(gf, 'cheer');
		}
	}
}