void() precache_aoa = //precache all models and sounds for aoa weapons
{
	//#aoa precache sounds
	precache_sound ("aoa/melee_meat.wav");
	precache_sound ("aoa/axhit3.wav");
	precache_sound ("aoa/acidhit.wav");
	precache_sound ("aoa/radius.wav");
	precache_sound ("aoa/sword1a.wav");
	precache_sound ("aoa/sword2a.wav");
	precache_sound ("aoa/sword1b.wav");
	precache_sound ("aoa/sword2b.wav");
	precache_sound ("aoa/rapier_meat.wav");
	precache_sound ("aoa/rapier_meat2.wav");
	precache_sound ("aoa/rapier_meat3.wav");
	precache_sound ("aoa/staffhit.wav");
	precache_sound ("aoa/staffexplode.wav");
	precache_sound ("aoa/staffshot.wav");
	precache_sound ("aoa/staffexplode.wav");
	precache_sound ("aoa/melee_meat.wav");
	precache_sound ("aoa/swing2.wav");
	precache_sound ("aoa/gauntlet_att.wav");
	precache_sound ("aoa/gauntlet_att2.wav");
	precache_sound ("aoa/gauntlet_att3.wav");
	precache_sound ("aoa/gauntlet_att4.wav");
	precache_sound ("aoa/heartbeat.wav");
	precache_sound ("aoa/gibacid.wav");
	precache_sound ("aoa/heal.wav");
	precache_sound ("aoa/drainhealth.wav");
	precache_sound ("aoa/corruption.wav");
	precache_sound ("aoa/crossshot.wav");
	precache_sound ("aoa/thndr.wav");
	precache_sound ("aoa/iceattack.wav");
	precache_sound ("aoa/vortex.wav");
	precache_sound ("aoa/whisper1.wav");
	precache_sound ("aoa/whisper2.wav");
	precache_sound ("aoa/whisper3.wav");
	precache_sound ("aoa/whisper4.wav");
	precache_sound ("aoa/sanguinator_atk1.wav");
	precache_sound ("aoa/sanguinator_atk2.wav");
	precache_sound ("aoa/sanguinator_atk3.wav");
	precache_sound ("blob/hit1.wav");
	precache_sound ("player/axhit2.wav");
	precache_sound ("kurok/weapons/ax1.wav");
	precache_sound ("hknight/hit.wav");
	precache_sound ("shambler/sboom.wav");
	precache_sound ("weapons/ax1.wav");
	precache_sound ("aoa/rockattack.wav");
	precache_sound ("aoa/fastboulder.wav");
	precache_sound ("aoa/slowboulder.wav");
	
	
	//#aoa precache models
	precache_model ("progs/aoa/ghostrapier.mdl");
	precache_model ("progs/aoa/radius.mdl");
	precache_model ("progs/aoa/bolt4.mdl");
	precache_model ("progs/aoa/test.mdl");
	precache_model ("progs/aoa/icespike.mdl");
	precache_model ("progs/aoa/greenembers.mdl");
	precache_model ("progs/aoa/void_shard.mdl");
	precache_model ("progs/aoa/drainhit.mdl");
	precache_model ("progs/aoa/drainmiss.mdl");
	precache_model ("progs/aoa/spark.mdl");
	precache_model ("progs/aoa/ad_gungnir_impact.mdl");
	precache_model ("progs/aoa/spark.mdl");
	precache_model ("progs/aoa/bloodorb_small.mdl");
	precache_model ("progs/aoa/bloodorb1.mdl");
	precache_model ("progs/aoa/boneshard.mdl");
	precache_model ("progs/aoa/bloodembers.mdl");
	precache_model ("progs/aoa/player_rapier.mdl");
	precache_model ("progs/aoa/player_scimitar.mdl");
	precache_model ("progs/aoa/ammo_voidshards.mdl");
	precache_model ("progs/aoa/ammo_voidshards_big.mdl");
	precache_model ("progs/aoa/ammo_elemental.mdl");
	precache_model ("progs/aoa/ammo_elemental_big.mdl");
	precache_model ("progs/aoa/ammo_bloodcrystals.mdl");
	precache_model ("progs/aoa/ammo_bloodcrystals_big.mdl");
	precache_model ("progs/aoa/player_rapier.mdl");
	precache_model ("progs/aoa/vortex.mdl");
	precache_model ("progs/aoa/boulder.mdl");
	precache_model ("progs/aoa/greyorb.mdl");
	precache_model ("progs/aoa/greyorbprojectile.mdl");
	precache_model ("progs/aoa/divetarget.mdl");
	precache_model ("progs/aoa/proj_flak_shell.mdl"); //flak cannon projectile
	precache_model ("progs/aoa/proj_flak_shrapnel.mdl"); //flak shrapnel
	precache_model ("progs/aoa/ghostrapier.mdl");
	precache_model ("progs/aoa/sphere.mdl");
	precache_model ("progs/aoa/g_scimitar.mdl");
	precache_model ("progs/aoa/g_rapier.mdl");
	precache_model ("progs/aoa/g_ice.mdl");		
	precache_model ("progs/aoa/g_mace.mdl");		
	precache_model ("progs/aoa/g_voidstaff.mdl");
	precache_model ("progs/aoa/g_flak.mdl");
	precache_model ("progs/aoa/g_gungnir.mdl");
	precache_model ("progs/aoa/g_sanguinators.mdl");
	precache_model ("progs/aoa/glow.mdl");
	precache_model ("progs/aoa/tessla.mdl");
	precache_model ("progs/aoa/bloodsphere.mdl");



	//precache_model ("progs/aoa/tessla.mdl");
};

void(string a, string b, string c, string d) aoaprint =
{
	dprint(a);
	dprint(b);
	dprint(c);
	dprint(d);
	dprint("\n");
};


void(string playerModel) setPlayerModel = //sets the player model to the string value, and sets appropriate mins/maxs
{
	setmodel(self, playerModel);
	setsize (self, '-16 -16 -24', '16 16 32');
	setorigin (self, self.origin);
	self.view_ofs = '0 0 22';
};

//healing utility called by health-draining melee weapons like the Mace
void(entity target, float hlth, float maxHealth) TriggerHeal =
{
	
	if (target.health > maxHealth)
		return;
	else if (target.health + hlth < maxHealth)
		target.health = target.health + hlth;
	else
		target.health = maxHealth;
	sound(target, CHAN_AUTO, "aoa/heal.wav", 0.6, ATTN_NORM);
};

/*
=====================================================================
Mirror Player Model (for testing player animations)	#mirror
=====================================================================
*/
void() mirrorPlayerModel =
{
	if (time > self.attack_finished)
	{
		remove(self);
		return;
	}	
	setmodel (self, self.owner.model);
	self.skin = self.owner.skin;
	self.frame = self.owner.frame;
	// self.angles = self.owner.angles; this makes is difficult to see the front of the mirror
	self.nextthink = time + 0.1;
	self.think = mirrorPlayerModel;

};

void() spawnPlayerModel =
{
	local entity playerModel;
	
	playerModel = spawn();
	playerModel.owner = self;
	playerModel.skin = self.skin;
	playerModel.frame = self.frame;
	playerModel.attack_finished = time + 60;
	setmodel (playerModel, self.model);
	setsize (playerModel, '0 0 0', '0 0 0');
	setorigin (playerModel, self.origin);
	playerModel.nextthink = time + 0.1;
	playerModel.think = mirrorPlayerModel;
};
//===========================END OF MIRROR PLAYER MODEL====================================


void(float frames) LoopFrames =
{
	if (self.frame >= frames)
		self.frame = 0;
	else
		self.frame = self.frame + 1;
};

/*
=====================================================================
Beam - for emulating lightning gun effect	#beam #ryanscissorhands
=====================================================================
*/

void() randomTwist =
{
	if (time > self.attack_finished)
	{
		remove(self);
		return;
	}
	
	/*local float spin;
	
	spin = random()*2000 + 1500;
	if (random() > 0.5)
		spin = spin * (-1);
	
	self.avelocity_z = spin;
	self.angles_z = random()*360;
	*/
	
	self.angles_z = random()*720;
	
	self.nextthink = time + 0.001;
	self.think = randomTwist;
};

void(vector org, vector dir, string model, float duration) SpawnBeamSegment =
{
	local entity segment;
	
	makevectors(self.v_angle);
	segment = spawn();
	segment.owner = self;
	segment.angles = vectoangles(v_forward);
	segment.movetype = MOVETYPE_FLY;
	segment.solid = SOLID_NOT;
	
	setmodel(segment, model);
	setsize(segment, '0 0 0', '0 0 0');
	setorigin (segment, org);
	segment.attack_finished = time + duration;
	segment.nextthink = time + 0.03;
	segment.think = randomTwist;
};

void(vector org, vector dest, string model, float duration) MakeBeam =
{
	local float span;
	local vector nextSegment;
	span = vlen(dest-org);
	nextSegment = org;
	while (span > 32)
	{
		makevectors(dest - org);
		SpawnBeamSegment(nextSegment, v_forward, model, duration);
		nextSegment = nextSegment + v_forward*32;
		span = span - 32;
	}
};

//========================END OF BEAM===================================================================================================================================================================

/*
======================================================================================================
Vector Utilities
======================================================================================================
*/
void (vector org) TestThisVector = //this function is designed to test locations by spawning a floating projectile at the given vector
{
	local	entity	test;
	test = spawn();
	setmodel (test, "progs/aoa/test.mdl");		
	setorigin (test, org);
	test.nextthink = time + 4;
	test.think = SUB_Remove;
};


//Line of Sight methods
float(entity targ, entity inflictor) HasLOS =
{
	
	traceline(inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	else
		return FALSE;
};

float(vector point1, vector point2) InLOS =
{
	
	traceline(point1, point2, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	else
		return FALSE;
};

vector ignoreVertical(vector bearing) = //returns a normalized vector with no vertical component
{
	local vector upless;
	upless = bearing;
	upless_z = 0; // this removes the vertical or 'z' component
	upless = normalize(upless);
	return upless;
};

void(string model, vector org) TestModel =
{
	local entity ModelPreview;
	
	ModelPreview = spawn();
	ModelPreview.owner = self;
	ModelPreview.nextthink = time + 10;
	ModelPreview.think = SUB_Remove;
	ModelPreview.movetype = MOVETYPE_TOSS;
	
	setmodel (ModelPreview, model);
	setsize( ModelPreview, '0 0 0', '0 0 0');
	setorigin (ModelPreview, org);
};

/*
===================================================================
Randomization Functions - ryanscissorhands
===================================================================
*/

float rnd (float min, float max) = //returns a random value between min and max
{
	local float result;
	result = min + random()*(max - min);
	return result;
};

vector spread(vector variance) = //returns a randomized vector within +/-  the input vector’s bounds
{
	local float x, y, z;
	local vector result;

	x = fabs(variance_x);
	y = fabs(variance_y);
	z = fabs(variance_z);

	result_x = rnd(-x, x);
	result_y = rnd(-y, y);
	result_z = rnd(-z, z);

	return result;
};

float(entity target) CountFlakAmmo =
{
	local float nails, rockets;
	
	nails = target.ammo_nails /8;
	rockets = target.ammo_rockets/2;
	if (nails > rockets)
		return rockets;
	else
		return nails;
};
//======END OF RANDOMIZATION FUNCTIONS==================================