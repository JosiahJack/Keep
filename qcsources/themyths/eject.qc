void(vector org, vector dir) eject_shell = 
{
	local float fut;
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.solid = SOLID_BBOX;
	newmis.angles = vectoangles(dir);
	newmis.classname = "shellcasing";
	newmis.touch = SUB_Null;
	newmis.nextthink = time + WEAPON_ROCKET;
	newmis.think = SUB_Remove;
	setmodel(newmis, "progs/shell.mdl");
	setsize(newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin(newmis, org);
	fut = random() * MOVETYPE_FLY;
	if (fut > MSG_BROADCAST && fut < WEAPON_SHOTGUN)
	{
		newmis.velocity_x = 75 + 80 * random();
		newmis.velocity_y = 20 + 80 * random();
		newmis.velocity_z = 100 + 80 * random();
	}
	if (fut > WEAPON_SHOTGUN && fut < FL_SWIM)
	{
		newmis.velocity_x = 50 + 80 * random();
		newmis.velocity_y = 50 + 80 * random();
		newmis.velocity_z = 80 + 80 * random();
	}
	if (fut > FL_SWIM && fut < MOVETYPE_WALK)
	{
		newmis.velocity_x = SVC_SETVIEWANGLES + 80 * random();
		newmis.velocity_y = 25 + 80 * random();
		newmis.velocity_z = MAX_CHARMER_DISTANCE + 80 * random();
	}
	if (fut > MOVETYPE_WALK && fut < MOVETYPE_STEP)
	{
		newmis.velocity_x = 75 + 80 * random();
		newmis.velocity_y = 50 + 80 * random();
		newmis.velocity_z = 100 + 80 * random();
	}
	if (fut > MOVETYPE_STEP && fut < MOVETYPE_FLY)
	{
		newmis.velocity_x = 40 + 80 * random();
		newmis.velocity_y = SVC_SETVIEWANGLES + 80 * random();
		newmis.velocity_z = 75 + 80 * random();
	}
	fut = random() * MOVETYPE_STEP;
	if (fut > MSG_BROADCAST && fut < WEAPON_SHOTGUN)
	{
		newmis.avelocity_x = 300 + 80 * random();
		newmis.avelocity_y = 300 + 80 * random();
		newmis.avelocity_z = 300 + 80 * random();
	}
	if (fut > WEAPON_SHOTGUN && fut < FL_SWIM)
	{
		newmis.avelocity_x = MIN_CHARMER_DISTANCE + 80 * random();
		newmis.avelocity_y = 300 + 80 * random();
		newmis.avelocity_z = 100 + 80 * random();
	}
	if (fut > FL_SWIM && fut < MOVETYPE_WALK)
	{
		newmis.avelocity_x = MAX_CHARMER_DISTANCE + 80 * random();
		newmis.avelocity_y = 100 + 80 * random();
		newmis.avelocity_z = MSG_BROADCAST + 80 * random();
	}
	if (fut > MOVETYPE_WALK && fut < MOVETYPE_STEP)
	{
		newmis.avelocity_x = 400 + 80 * random();
		newmis.avelocity_y = MAX_CHARMER_DISTANCE + 80 * random();
		newmis.avelocity_z = 100 + 80 * random();
	}
};

