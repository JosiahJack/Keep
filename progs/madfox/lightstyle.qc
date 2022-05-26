//Decompiled code. Please respect the original copyright.

void(float level) LightLevel ={
static string levels[] = {"m","l","k","j","i","h","g","f","e","d","c","b","a"};
lightstyle(0, levels[level]);
};

void() FadeOut2 =
{
	if ((fadeent.fadestep < HOOK_ON))
	{
		fadeent.fadestep = HOOK_ON;
		return;
	}
	fadeent.fadestep = (fadeent.fadestep - HOOK_ON);
	LightLevel(fadeent.fadestep);
	fadeent.think = FadeOut2;
	fadeent.nextthink = (time + 0.1);
	return;
};

void() LightFadeOut =
{
	fadeent.fadestep = 13;
	FadeOut2();
	return;
};

void() FadeIn2 =
{
	if ((fadeent.fadestep > 13))
	{
		fadeent.fadestep = 13;
		return;
	}
	fadeent.fadestep = (fadeent.fadestep + HOOK_ON);
	LightLevel(fadeent.fadestep);
	fadeent.think = FadeIn2;
	fadeent.nextthink = (time + 0.1);
	return;
};

void() LightFadeIn =
{
	fadeent.fadestep = HOOK_ON;
	FadeIn2();
};
