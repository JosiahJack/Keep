void() W_Precache = 
{
	precache_sound("necros/drivshft.wav");
	precache_sound("weapons/expl1.wav");
	precache_sound("weapons/plasexpl.wav");
	precache_sound("weapons/r_exp3.wav");
	precache_sound("weapons/rocket1i.wav");
	precache_sound("weapons/sgun1.wav");
	precache_sound("weapons/guncock.wav");
	precache_sound("weapons/ric1.wav");
	precache_sound("weapons/ric2.wav");
	precache_sound("weapons/ric3.wav");
	precache_sound("weapons/spike2.wav");
	precache_sound("weapons/tink1.wav");
	precache_sound("weapons/grenade.wav");
	precache_sound("weapons/bounce.wav");
	precache_sound("weapons/shotgn2.wav");
	precache_sound("weapons/lancfire.wav");
	precache_sound("weapons/dryfire.wav");
};

void(float soundnum, vector org, float ambvolume, float atten) spawnambient = 
{
	WriteByte(MSG_ALL, SVC_SPAWNSTATICSOUND);
	WriteCoord(MSG_ALL, org_x);
	WriteCoord(MSG_ALL, org_y);
	WriteCoord(MSG_ALL, org_z);
	WriteByte(MSG_ALL, soundnum);
	WriteByte(MSG_ALL, ambvolume * 255);
	WriteByte(MSG_ALL, atten * TRIGGER_SPAWN);
};

void() ambient_generalpurpose = 
{
	precache_sound(self.noise);
	if (!(self.volume))
	{
		self.volume = WEAPON_SHOTGUN;
	}
	if (!(self.speed))
	{
		self.speed = ATTN_STATIC;
	}
	if (self.speed == CONTENT_EMPTY)
	{
		self.speed = MSG_BROADCAST;
	}
	ambientsound(self.origin, self.noise, self.volume, self.speed);
};

void() ambient_driveshaft_use = 
{
	spawnambient(WEAPON_SHOTGUN, self.origin, WEAPON_SHOTGUN, 1.5);
};

void() ambient_driveshaft = 
{
	self.use = ambient_driveshaft_use;
};

