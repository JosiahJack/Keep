void () ashot_precache =
 {
   precache_model2 ("progs/v_ashot.mdl");
   precache_sound2 ("weapons/ashotfir.wav");
   precache_sound2 ("weapons/ashotcok.wav");
};

void() W_FireAssaultShotgun =
{
	local vector dir;
	self.punchangle_x = -2;
     	self.currentammo = self.ammo_shells = self.ammo_shells - 2;
	dir = aim (self, 100000);
	FireMossberg (12, dir, '0.14 0.08 0.0');
};

