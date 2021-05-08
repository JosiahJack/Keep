/*
==============================================================================

OLD ONE STATUE

==============================================================================
*/

void() statue_die =
{
	vector spawnspot;
		
	/* Statue explosion */
	
	local	vector	oldo;
	local	float	x, y, z;
	local	float	r;
	local entity	n;

	sound (self, CHAN_VOICE, "blob/death1.wav", 1, ATTN_NONE);
	sound (self, CHAN_ITEM, "blob/death1.wav", 1, ATTN_NONE);
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NONE);
	
	self.solid = SOLID_NOT;
	oldo = self.origin;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	
	z = 16;
	while (z <= 96)
	{
		x = -64;
		while (x <= 64)
		{
			y = -64;
			while (y <= 64)
			{
				self.origin_x = oldo_x + x;
				self.origin_y = oldo_y + y;
				self.origin_z = oldo_z + z;

				r = random();
				if (r < 0.3)				
					ThrowGib ("progs/vgib1.mdl", -60);
				else if (r < 0.6)
					ThrowGib ("progs/vgib2.mdl", -60);
				else
					ThrowGib ("progs/vgib3.mdl", -60);
				y = y + 32;
			}
			x = x + 32;
		}
		z = z + 64;
	}
	
	/* Tar babies */
	float cpt = 0;
	do
	{
		makevectors (self.mangle);
		spawnspot = self.oldorigin + 36 * v_forward;

		spawn_something("monster_tarbaby", spawnspot, self.angles, 1, FALSE, damage_attacker);

		self.mangle_y += 120;
		cpt++;
	} while(cpt<3-self.frags);

	/* Targets */
	
	SUB_UseTargets();
	remove(self);
};

/*QUAKED monster_oldone_statue (1 0 0) (-24 -24 -6) (24 24 38)
*/
void() monster_oldone_statue =
{
	self.frags = self.frame;
	self.frame = 0;
	
	if(self.frags==1)
		self.model="progs/shstathf.mdl";
	else
		self.model="progs/shstat.mdl";
	
	precache_model2 (self.model);
	precache_model2 ("progs/vgib1.mdl");
	precache_model2 ("progs/vgib2.mdl");
	precache_model2 ("progs/vgib3.mdl");

	precache_sound2 ("blob/death1.wav");

	self.classname="shub_statue";
	self.health=75;
	self.th_die = statue_die;
	self.takedamage = DAMAGE_YES;
	self.solid = SOLID_BBOX;
	self.oldorigin = self.origin + '0 0 128'/*'0 0 18'*/; //Central reference point for spawning tarbabies
	self.mangle = self.angles + '0 -60 0';
	
	setmodel (self, self.model);
	setsize (self, '-24 -24 -6', '24 24 38');
};

