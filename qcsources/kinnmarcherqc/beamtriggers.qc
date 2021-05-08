
float BEAM_VISIBLE = 1;

//because a dest of '0 0 0' is taken as null, when there's a (small) chance it might not be
vector(entity t) beamtrigger_origin =
{
	if (t.origin == '0 0 0')
		return '0 0 1';
		
	return t.origin;
};

//the generic tripwire firing function...
entity(vector p1, vector p2, entity ignore) beamtrigger_fire =
{
	local entity temp;
	local float len, step, D;
	local vector dir, ang;	
	
	if (ignore == world)
		ignore = self;
		
	traceline(p1, p2, FALSE, ignore);	//ignore cannot be world for some reason - that seems to mean "ignore everything"
	
	//dprint(trace_ent.classname);dprint("\n");
	
	ang = vectoangles(p2 - p1);
	makevectors(ang);
	self.movedir = v_right;
		
	if (trace_fraction != 1)
	{	
		temp = other;
		other = trace_ent;
		self.touch();
		other = temp;
	}	
	
	if (self.state == BEAM_VISIBLE)	//can make it visible for development purposes
	{	
		len = vlen(p2 - p1);
		dir = normalize(p2 - p1);		
		D = 30*self.wait;
		if (D > 15)
			D = 15;
		for (step = 0; step < len; step = step + 16)		
			particle(p1 + dir*step, '0 0 0', 104, D);	//bdw - can tweak this if you can be arsed
		//show the movedir...	
		dir = (p1 + p2)*0.5;				
		particle(dir, self.movedir*300, 40, 50);
	}
	
	return trace_ent;
};

void() beamtrigger_fire_all =
{
	local entity hit;

	hit = beamtrigger_fire(self.origin, self.dest, self);
	
	self.think = beamtrigger_fire_all;
	self.nextthink = time + self.wait;
	
	if (self.dest1 == '0 0 0') return;		
	hit = beamtrigger_fire(self.dest, self.dest1, hit);	
	if (self.dest2 == '0 0 0') return;		
	hit = beamtrigger_fire(self.dest1, self.dest2, hit);	
	if (self.dest3 == '0 0 0') return;		
	hit = beamtrigger_fire(self.dest2, self.dest3, hit);	
	if (self.dest4 == '0 0 0') return;		
	hit = beamtrigger_fire(self.dest3, self.dest4, hit);	
	if (self.dest5 == '0 0 0') return;		
	hit = beamtrigger_fire(self.dest4, self.dest5, hit);	
	if (self.pos1 == '0 0 0') return;		
	hit = beamtrigger_fire(self.dest5, self.pos1, hit);	
	if (self.pos2 == '0 0 0') return;		
	hit = beamtrigger_fire(self.pos1, self.pos2, hit);	
	if (self.angles1 == '0 0 0') return;		
	hit = beamtrigger_fire(self.pos2, self.angles1, hit);	
	if (self.angles2 == '0 0 0') return;		
	hit = beamtrigger_fire(self.angles1, self.angles2, hit);	
};	

entity(entity t) beamtrigger_nexttarget =
{
	local entity temp;
	
	if (t.target == "")
	{
		remove(t);
		return world;
	}
	
	temp = t;
	t = find(world, targetname, t.target);
	remove(temp);		
	return t;
};

//generic beam trigger setup function...
void() beamtrigger_go =
{
	local entity t;

	t = find(world, targetname, self.target);
		
	if (!t)	
	{
		objerror("tripwire can't find target\n");
		return;	//important!!! objerror's don't actually exit the function!
	}
		
	self.dest = beamtrigger_origin(t);
	
	self.think = beamtrigger_fire_all;
	self.nextthink = time + random()*self.wait;	//don't fire them all in sync
	
	t = beamtrigger_nexttarget(t); if (!t) return; self.dest1 = beamtrigger_origin(t);
	t = beamtrigger_nexttarget(t); if (!t) return; self.dest2 = beamtrigger_origin(t);
	t = beamtrigger_nexttarget(t); if (!t) return; self.dest3 = beamtrigger_origin(t);
	t = beamtrigger_nexttarget(t); if (!t) return; self.dest4 = beamtrigger_origin(t);
	t = beamtrigger_nexttarget(t); if (!t) return; self.dest5 = beamtrigger_origin(t);
	//use any old crap to store vectors...
	t = beamtrigger_nexttarget(t); if (!t) return; self.pos1 = beamtrigger_origin(t);
	t = beamtrigger_nexttarget(t); if (!t) return; self.pos2 = beamtrigger_origin(t);
	t = beamtrigger_nexttarget(t); if (!t) return; self.angles1 = beamtrigger_origin(t);
	t = beamtrigger_nexttarget(t); if (!t) return; self.angles2 = beamtrigger_origin(t);
	
	if (t.target != "")
		dprint("warning: beamtrigger has too many nodes\n");
	
	//last one needs removing too...
	remove(t);
};	

void() beamtrigger_use =
{
	self.state = !self.state;
};

void() beamtrigger_generic =
{
	if (!self.wait)
		self.wait = 0.5;	
		
	//self.classname = "beamtrigger";	//for ent selector		
	self.solid = SOLID_NOT; //just to be sure
	self.state = 0;			//don't hack state from the editor
	self.targetname = "";	//guarantee nothing can use() it except the ent selector
	self.use = beamtrigger_use;
		
	self.think = beamtrigger_go;
	self.nextthink = time + 0.1;//wait for targets to spawn
};

void() beamtrigger_monsterjump =
{
	if (!self.speed)
		self.speed = 200;
	if (!self.height)
		self.height = 200;
	self.touch = trigger_monsterjump_touch;

	beamtrigger_generic();
};