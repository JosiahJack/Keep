entity(entity victim, vector org, string gibname) PM_SpawnBrains = 
{
	local entity blood;
	blood = spawn();
	blood.solid = SOLID_NOT;
	blood.movetype = MOVETYPE_TOSS;
	blood.owner = victim;
	setorigin(blood, org);
	setmodel(blood, gibname);
	setsize(blood, VEC_ORIGIN, VEC_ORIGIN);
	blood.avelocity_x = (random() - 0.5) * 1200;
	blood.avelocity_y = (random() - 0.5) * 1200;
	blood.avelocity_z = (random() - 0.5) * 1200;
	blood.nextthink = time + 0.5 + random();
	blood.think = SUB_Remove;
	return blood;
};

void(entity victim, vector org, string gibname) PM_BloodShower = 
{
	local entity blood;
	org_z = org_z + SPAWN_RESPAWN;
	blood = PM_SpawnBrains(victim, org, gibname);
	blood.velocity_x = (random() - 0.5) * 80;
	blood.velocity_y = (random() - 0.5) * 80;
	blood.velocity_z = random() * 100 + 250;
};

void(entity victim, entity bullet, float mag, string gibname) PM_BloodSpurt = 
{
	local entity blood;
	blood = PM_SpawnBrains(victim, bullet.origin, gibname);
	blood.velocity = normalize(bullet.velocity);
	blood.velocity = blood.velocity * mag;
};

