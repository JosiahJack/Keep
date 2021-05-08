void() kbar_precache =
{
      precache_model2("progs/v_kbar.mdl");
      precache_sound2("weapons/swoosh.wav");
      precache_sound2("weapons/slash.wav");
};


void() W_FireKbar =
{
	local	vector	source;
	local	vector	org;
      local vector      meatdir;

	makevectors (self.v_angle);
      meatdir_x = ((random () * 300.000) );
      meatdir_y = ((random () * 300.000) );
      meatdir_z = ((random () * 300.000) );
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
            Shoot_Blood (org,meatdir);
            Shoot_Blood (org,meatdir * 2);
            SpawnBlood (org,'0 0 0',400.000);
		T_Damage (trace_ent, self, self, 8);
            sound(trace_ent, CHAN_AUTO,"weapons/slash.wav",TRUE,ATTN_NORM);
	}
	else
	{	// hit wall
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};
