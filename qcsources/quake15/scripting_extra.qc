float FLAG_REMOVE_PARTICLES = 2;
float FLAG_REMOVE_ACTOR = 4;
float FLAG_HIDE = 8;
float FLAG_SPAWN_PART = 16;

void() actor_anim =
{
	if (self.frame < self.height)
	{
		self.frame++;
		self.think = actor_anim;
		self.nextthink = time + self.speed;
		
	}
	else if (self.spawnflags & FLAG_REMOVE_PARTICLES)
		self.traileffectnum = particleeffectnum(string_null);
	//if (self.frame >= self.height && self.spawnflags & 2)
		

}

void() actor_throw =
{
	newmis = spawn();
	
	setmodel (newmis, self.mdl);
	setsize (newmis, '-16 -16 -24', '16 16 40');
	setorigin(newmis, self.oldorigin + self.view_ofs);
	
	setmodel (self, "progs/null.spr");
	if(self.noise)
		sound7(newmis, CHAN_AUTO, self.noise, 1, ATTN_NORM, SNDSPD);
	
	if (self.partname)
		newmis.traileffectnum = particleeffectnum(self.partname);
		
	newmis.angles = self.angles;
	newmis.movetype = MOVETYPE_TOSS;
	newmis.velocity = self.velocity;
	newmis.frame = self.frame;
	newmis.height = self.height;
	newmis.speed = self.speed;
	newmis.spawnflags = self.spawnflags;
	
	
	if (self.spawnflags & FLAG_REMOVE_ACTOR)
	{
		newmis.solid = SOLID_TRIGGER;
		newmis.touch = SUB_Remove;
	}
	
	if (self.height)
	{
		newmis.think = actor_anim;
		newmis.nextthink = time;
	}
	
}

void() misc_actor = 
{
	if (CTF_ENABLED && !(self.spawnflags & 4096))
	{
		remove(self);
		return;
	}
	// Is the model defined using the noise key?
	if (!self.mdl) {
		dprint("\b[MISCMDL]\b Missing model to load\n");
		remove(self);
		return;
	}
	precache_model (self.mdl);
	
	if(self.noise)
		precache_sound (self.noise);
	
	self.solid = SOLID_NOT;				// No world interaction
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	self.oldorigin = self.origin;		// Store for later
	
	if (self.spawnflags & FLAG_HIDE)
		self.effects = self.effects | EF_NODRAW;
	
	setmodel (self, self.mdl);
	setsize (self, self.mins , self.maxs);
	setorigin(self, self.oldorigin + self.view_ofs);
	
	self.use = actor_throw;
	
}