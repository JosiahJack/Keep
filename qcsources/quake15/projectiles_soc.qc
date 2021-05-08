void() SpawnExplosion_think =
{
	self.frame = self.frame + 1;
	if (self.frame > self.count) SUB_Remove();
	else self.nextthink = time + self.speed;
};

void(float sprite_type, vector org, string expl_sound) SpawnExplosion =
{
	local string spr_name;
	local float spr_count, spr_speed;
	
	spr_count = -1;
	if (sprite_type == EXPLODE_SMALL) {
		spr_name = "progs/s_explod.spr";
		spr_count = 5;
		spr_speed = 0.1;
	}
	else if (sprite_type == EXPLODE_MED) {
		spr_name = "progs/s_explodmed.spr";
		spr_count = 13;
		spr_speed = 0.05;
	}
	else if (sprite_type == EXPLODE_BIG) {
		spr_name = "progs/s_explodbig.spr";
		spr_count = 16;
		spr_speed = 0.05;
	}
	else if (sprite_type == EXPLODE_SMALLP) {
		if (ext_dppart)
			pointparticles(particleeffectnum(DPP_TEPLASMA), org, '0 0 0', 1);
		else {
			spr_name = "progs/s_explodsmallp.spr";
			spr_count = 12;
			spr_speed = 0.05;
		}
	}
	else if (sprite_type == EXPLODE_BIGP) {
		if (ext_dppart)
			pointparticles(particleeffectnum(DPP_TELRGPLASMA), org, '0 0 0', 1);
		else {
			spr_name = "progs/s_explodbigp.spr";
			spr_count = 12;
			spr_speed = 0.05;
		}
	}
	else if (sprite_type == EXPLODE_ELEC) {
		if (ext_dppart)
			pointparticles(particleeffectnum(DPP_TEPLASMA), org, '0 0 0', 1);
		else {
			spr_name = "progs/s_plasma.spr";
			spr_count = 4;
			spr_speed = 0.1;
		}
	}
	else if (sprite_type == EXPLODE_PUFF) {
		spr_name = "progs/s_smoke.spr";
		spr_count = 6;
		spr_speed = 0.05;
	}
	else return;
	
	if (spr_count > 0) {
		newmis = spawn();
		newmis.classgroup = CG_TEMPENT;
		newmis.movetype = MOVETYPE_NONE;
		newmis.solid = SOLID_NOT;
		
		setmodel(newmis, spr_name);
		setorigin(newmis, org);
		setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
		newmis.alpha = 0.7;			// Slightly transparent
		newmis.effects = 32;		// Additive blending
		newmis.count = spr_count;	// Total frames
		newmis.speed = spr_speed;	// Frame speed

		if (expl_sound != "") sound(newmis, CHAN_WEAPON, expl_sound, 1, ATTN_NORM);
		newmis.think = SpawnExplosion_think;
		newmis.nextthink = time + newmis.speed;
	}
};
