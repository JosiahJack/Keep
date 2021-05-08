//-----------------------------------------------------
// Mechanical Laser-shooting Turret
//-----------------------------------------------------

$cd acs/progs/turret
$origin 0 -6 24
$base base		
$skin skin

$frame tur1 tur2 tur3 tur4



void() turret_scan;
void(vector org, vector dest) LaunchLaser;
void(string gibname, float dm, vector ddir) ThrowRubble;

void(vector org, vector vec) T_LaunchLaser =
{
	local	vector	vec;
		
	sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	vec = normalize(vec);
	
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	//newmis.effects = EF_DIMLIGHT;

	setmodel (newmis, "progs/turlaser.mdl");
	setsize (newmis, '0 0 0', '0 0 0');		

	setorigin (newmis, org);

	newmis.velocity = vec * 800;
	newmis.angles = vectoangles(newmis.velocity);

	newmis.nextthink = time + 5;
	newmis.think = SUB_Remove;
	newmis.touch = Laser_Touch;
};

void(float offset) t_firelaser =
{
local vector org, go, mep;
local float lead;

	makevectors(self.angles);
	org = self.origin + v_forward*12 + '0 0 24';

	lead = vlen(self.enemy.origin - org) / 1000;
	mep = self.enemy.velocity;
	mep_z = 0;
	go = (self.enemy.origin + mep * lead) + (v_right*offset);
	go = go - org;

	traceline(org, self.enemy.origin, FALSE, world);
	if (trace_fraction > 0.9)
	   T_LaunchLaser(org, go);

	self.attack_finished = time + 2;
};

void() t_facetarget =
{
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin); 
	if (self.angles_y != self.ideal_yaw)
	{
		if (self.t_width < time)
		{
		    sound (self, CHAN_AUTO, "turret/tur_move.wav", 1, ATTN_NORM); //play turn sound
		    self.t_width = time + 0.3;
		}
		self.angles_y = self.ideal_yaw;
	}
};

void()	turret_attack1	=[ $tur1, turret_attack2 ] {t_facetarget (); t_firelaser (-18); };
void()	turret_attack2	=[ $tur2, turret_attack3 ] {t_facetarget (); t_firelaser (0); }; 
void()	turret_attack3	=[ $tur3, turret_attack4 ] {t_facetarget (); t_firelaser (18); };
void()	turret_attack4	=[ $tur4, turret_target ] {t_facetarget (); };

void() turret_target =
{
	if (self.enemy.health <= 0)
	{
		self.think = turret_scan;
		self.nextthink = time + 0.3;
		return;
	}
	
	t_facetarget ();
	self.enemy = checkclient();

	if (self.attack_finished < time)
	{
		if (self.enemy)
		{
			turret_attack1 ();
			return;
		}
	}

	self.nextthink = time + 0.1;
};

void() turret_scan =
{
	self.enemy = checkclient();
	if(!(self.enemy))
	{
		self.nextthink = time + 0.3;
		return;
	}
	
	//Turret found enemy, attack!
	self.think = turret_target;
	self.nextthink = time + 0.1;
};

void() turret_go =
{
	self.think = turret_scan;
	self.nextthink = time + 0.1;
};

void() turret_die =
{
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, (self.origin_z + 8));

	sound (self, CHAN_WEAPON, "turret/tur_gib.wav", 1, ATTN_NORM);

	if (self.health > -50)
		self.health = -55;

      ThrowRubble ("progs/tgib1.mdl", self.health, self.dest);
      ThrowRubble ("progs/tgib2.mdl", self.health, self.dest);
      ThrowRubble ("progs/tgib3.mdl", self.health, self.dest);
      ThrowRubble ("progs/tgib4.mdl", self.health, self.dest);
      ThrowRubble ("progs/tgib5.mdl", self.health, self.dest);
	remove(self);
};

void() turret_use =
{
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_STEP;
	self.flags = self.flags | FL_MONSTER;
	setmodel (self, "progs/turret.mdl");
	setsize (self, '-32 -32 0', '32 32 56');
	self.health = 250;

	self.th_die = turret_die;
	self.th_pain = SUB_Null;
	self.th_stand = turret_go;
	self.th_walk = turret_go;
	self.th_run = turret_go;
	self.th_missile = turret_go;
	self.th_melee = turret_go;

	self.nextthink = time + 0.5;
	self.think = turret_scan;
};

void() monster_lt =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_model ("progs/turret.mdl");
	precache_model ("progs/turlaser.mdl");
	precache_model ("progs/tgib1.mdl");
	precache_model ("progs/tgib2.mdl");
	precache_model ("progs/tgib3.mdl");
	precache_model ("progs/tgib4.mdl");
	precache_model ("progs/tgib5.mdl");
	//precache_sound2 ("turret/las_hit.wav");
	precache_sound2 ("enforcer/enfire.wav");
	precache_sound2 ("turret/tur_move.wav");
	precache_sound2 ("turret/tur_gib.wav");
	precache_sound2 ("ambience/brik_hit.wav");
	precache_sound2 ("ambience/brikhit2.wav");

	setmodel (self, "progs/turret.mdl");

	setsize (self, '-32 -32 0', '32 32 56');
	self.use = turret_use;
	total_monsters = total_monsters + 1;
	StartItem ();
};
