/*
void(float soundid, vector org, entity reciever, float vol, float atten) spawnambient =
{
	local float i;
	
	//msg_entity = reciever;
	
	WriteByte(MSG_ALL, 6);
	WriteByte(MSG_ALL, 3);
	i = floor (vol * 255);
	
	WriteByte(MSG_ALL, i);
	WriteShort(MSG_ALL, 0); //Client is the reciever (0 on the ent list)
	
	WriteByte(MSG_ALL, 0); //channel
	WriteByte(MSG_ALL, soundid);
	
	WriteCoord(MSG_ALL, org_x);
	WriteCoord(MSG_ALL, org_y);
	WriteCoord(MSG_ALL, org_z);
};
//new ambient sound starter hack
*/
/*
float SVC_SPAWNSTATICSOUND = 29;
void(float soundnum, vector org, float ambvolume, float atten) spawnambient =
{
	WriteByte(MSG_ALL, SVC_SPAWNSTATICSOUND);
	WriteCoord(MSG_ALL, org_x);
	WriteCoord(MSG_ALL, org_y);
	WriteCoord(MSG_ALL, org_z);
	WriteByte(MSG_ALL, soundnum);
	WriteByte(MSG_ALL, ambvolume * 255); //translate this into a value between 0 and 255...
	WriteByte(MSG_ALL, atten * 64);
};
*/


// called by worldspawn
void() W_Precache =
{
	//precache_sound ("necros/sec_shft.wav"); // Sound Number 1!



	//precache_model ("progs/beam.mdl");
	precache_sound ("weapons/expl1.wav");
	precache_sound ("weapons/r_exp3.wav");	// new rocket explosion
	precache_sound ("weapons/rocket1i.wav");	// spike gun
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/guncock.wav");	// player shotgun
	precache_sound ("weapons/ric1.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");	// ricochet (used in c code)
	precache_sound ("weapons/spike2.wav");	// super spikes
	precache_sound ("weapons/tink1.wav");	// spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav");	// grenade launcher
	precache_sound ("weapons/bounce.wav");		// grenade bounce
	precache_sound ("weapons/shotgn2.wav");	// super shotgun
	
	//precache_sound ("weapons/lancfire.wav");	// plasma lance
	//precache_sound ("weapons/lncfire2.wav");	// plasma lance
	//precache_sound ("weapons/lncfire3.wav");	// plasma lance
	//precache_sound ("weapons/dryfire.wav");		// plasma lance
	//precache_sound ("weapons/click.wav");		// plasma lance
};


