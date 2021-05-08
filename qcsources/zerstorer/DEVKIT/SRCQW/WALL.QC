float SPAWN_GLASS = 2;

void() brik_touch =
{
	if (self.velocity == '0 0 0')
	{
		self.avelocity = '0 0 0';
		self.solid = SOLID_NOT;
		self.touch = SUB_Null;
		self.think = SUB_Remove;
		self.nextthink = time + (6 * random()) + 2;
		return;
	}
	if (!(self.cnt))
		return;

	if (self.attack_finished < time)
	if (pointcontents(self.origin) > -3)
	{
	//bounce sound
		if (self.cnt == 1)
		 sound (self, CHAN_AUTO, "ambience/brik_hit.wav", 1, ATTN_NORM);   
		else
		 sound (self, CHAN_AUTO, "ambience/brikhit2.wav", 1, ATTN_NORM);   

		self.attack_finished = time + 0.3;
	}
};


void(string gibname, float dm, vector ddir) ThrowRubble=
{
local	entity new;
local float sndrnd;

	new = spawn();
	sndrnd = random();
	// new.origin = self.origin doesnt work because the origin
	// is at world (0,0,0).
	new.origin_x = self.absmin_x + (random() * self.size_x);
	new.origin_y = self.absmin_y + (random() * self.size_y);
	new.origin_z = self.absmin_z + (random() * self.size_z);
	setmodel (new, gibname);
	setsize (new, '0 0 0', '0 0 0');

	if (sndrnd < 0.25)
		new.cnt = 1;
	else if (sndrnd < 0.5)
		new.cnt = 2;

	if (gibname == "progs/tgib1.mdl" || gibname == "progs/tgib2.mdl")
		new.cnt = 1;
	if (gibname == "progs/tgib3.mdl" || gibname == "progs/tgib4.mdl")
		new.cnt = 2;

	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_TRIGGER;
	new.touch = brik_touch;
	new.avelocity_x = random()*600;
	new.avelocity_y = random()*600;
	new.avelocity_z = random()*600;
	new.think = SUB_Remove;
	new.ltime = time;
	new.nextthink = time + 10 + random()*10;
	new.frame = 0;
	new.flags = 0;
};

void () wall_killed =
// called when the wall is destroyed.
// throws gibs (rubble).
{
	local entity sndspot;
	local float rubble_count = 0;

	sndspot = spawn();
	sndspot.origin = self.absmin;
	setorigin(sndspot, sndspot.origin);
	sound (sndspot, CHAN_AUTO, "ambience/wall01.wav", 1, ATTN_NORM);
	remove(sndspot);
	// determine volume of destroyed wall and throw rubble accordingly
	rubble_count = (self.size_x * self.size_y * self.size_z) / 64000;
	if (rubble_count > 5)
		rubble_count = 6;

      if (self.spawnflags & SPAWN_GLASS)
      {
          while (rubble_count > -1) {
			self.dest_x = (random() * 100) - 50;
			self.dest_y = (random() * 100) - 50;
			self.dest_z = (random() * 100) - 50;
                ThrowRubble ("progs/rubble4.mdl", -100, self.dest);
                ThrowRubble ("progs/rubble4.mdl", -100, self.dest);
                ThrowRubble ("progs/rubble4.mdl", -100, self.dest);
                ThrowRubble ("progs/rubble4.mdl", -100, self.dest);
                ThrowRubble ("progs/rubble4.mdl", -100, self.dest);
                ThrowRubble ("progs/rubble4.mdl", -100, self.dest);
                ThrowRubble ("progs/rubble4.mdl", -100, self.dest);
                ThrowRubble ("progs/rubble4.mdl", -100, self.dest);
                ThrowRubble ("progs/rubble4.mdl", -100, self.dest);
                ThrowRubble ("progs/rubble4.mdl", -100, self.dest);
                ThrowRubble ("progs/rubble4.mdl", -100, self.dest);
                ThrowRubble ("progs/rubble4.mdl", -100, self.dest);
                ThrowRubble ("progs/rubble4.mdl", -100, self.dest);
                ThrowRubble ("progs/rubble4.mdl", -100, self.dest);
                ThrowRubble ("progs/rubble4.mdl", -100, self.dest);
                ThrowRubble ("progs/rubble4.mdl", -100, self.dest);
                ThrowRubble ("progs/rubble4.mdl", -100, self.dest);
                ThrowRubble ("progs/rubble4.mdl", -100, self.dest);
                rubble_count = rubble_count - 1;
           }
        }
        else
        {
             while (rubble_count > -1) {
			self.dest_x = (random() * 100) - 50;
			self.dest_y = (random() * 100) - 50;
			self.dest_z = (random() * 100) - 50;
                 ThrowRubble ("progs/rubble1.mdl", self.health, self.dest);
                 ThrowRubble ("progs/rubble2.mdl", self.health, self.dest);
                 ThrowRubble ("progs/rubble3.mdl", self.health, self.dest);
                 rubble_count = rubble_count - 1;
             }
        }
        activator = self;
	  SUB_UseTargets();
        if (self.classname != "monster_demon1")
             remove(self);
};

void() wall_pain =
{
	if(self.health > 0)
		self.health = self.max_health;
};

void() wall_use =
{
	self.health = -100;
	self.dest_x = (random() * 10) - 5;
	self.dest_y = (random() * 10) - 5;
	self.dest_z = (random() * 10) - 5;
	wall_killed();
};

/*QUAKED exploding_wall
When the exploding wall is shot, it "gibs" into rubble.
"target"	all entities with a matching targetname will be used when killed
"health"	the amount of damage needed to destroy the wall instead of touched
*/
void() exploding_wall =
{
	setmodel (self, self.model);
	// precache rubble models
	if (self.spawnflags & SPAWN_GLASS)
      	precache_model("progs/rubble4.mdl");
	else
	{
		precache_model("progs/rubble1.mdl");
		precache_model("progs/rubble2.mdl");
		precache_model("progs/rubble3.mdl");
		// precache sounds
		precache_sound("ambience/wall01.wav");
		precache_sound("ambience/brik_hit.wav");
		precache_sound("ambience/brikhit2.wav");
	}
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;

	if (self.health)
	{
		self.max_health = self.health;
		self.th_die = wall_killed;
		self.takedamage = DAMAGE_YES;
	}
	else
	{
		self.max_health = 100;
		self.th_die = wall_killed;
		self.takedamage = DAMAGE_YES;
	}
	self.th_pain = wall_pain;
	if (self.targetname)
	{
		self.use = wall_use;
		self.max_health = 10000;
	}
};
