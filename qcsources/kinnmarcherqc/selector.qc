float() EntSelectorSafeCheck =
{
	if (!cvar("developer"))
		return FALSE;

	if (self.trigger_field == world)
	{
		dprint("error! entity selector doesn't exist!\n");
		return FALSE;
	}
	
	if (self.trigger_field.classname != "ent_selector")
	{
		dprint("error! entity selector has wrong classname!\n");
		return FALSE;
	}
	
	return TRUE;
};

float() EntSelectorActive =
{
	if (!EntSelectorSafeCheck())
		return FALSE;			
	if (self.trigger_field.state == FALSE)
	{
		dprint("entity selector is not active\n");
		return FALSE;	
	}
	if (self.trigger_field.enemy == world)
	{
		dprint("entity selector hasn't selected anything\n");
		return FALSE;
	}
		
	return TRUE;
};		

void() EntSelectorScan =
{
	local entity e, best_ent, selector, beam;
	local vector dir, e_org;
	local float dot, best_dot;
	
	if (!EntSelectorSafeCheck())
		return;	
	
	selector = self.trigger_field;	
	
	if (selector.state == FALSE)
		return;
	
	makevectors(self.v_angle);	
	
	best_dot = 0.95;
	best_ent = world;	
	
	for(e = nextent(world); e != world; e = nextent(e))	//bdw - frikqcc for loop
	{
		if (e.flags & FL_NOSELECT)
			continue;		
			
		e_org = (e.absmax + e.absmin)*0.5;
	
		dir = e_org - (self.origin + self.view_ofs);
	
		if (vlen(dir) < 1000)
		{
			traceline(self.origin + self.view_ofs, e_org, FALSE, self);
			
			if ( (trace_fraction == 1) || (trace_ent == e) )
			{	
				dir = normalize(dir);
				dot = dir * v_forward;
						
				if (dot > best_dot)
					best_ent = e;
			}
		}		
	}	

	if (best_ent == world)
	{
		selector.model = "";
		selector.enemy = world;
		
		return;
	}
	
	if (best_ent != selector.enemy)
	{
		if (selector.voice_finished < time)
		{
			sound(self, CHAN_AUTO, "misc/talk.wav", 0.7, ATTN_NORM);	
			
			if (best_ent.classname != "")
			{
				dprint(best_ent.classname);
				dprint("\n");
			}				
			else
				dprint("(unknown classname)\n");
			
			
			selector.voice_finished = time + 0.2;
		}
	}
	
	setmodel(selector, "sprites/misc/select_y.spr");
	//selector.model = "sprites/misc/select_y.spr";
	
	if (best_ent.use)
	{
			if ( (best_ent.targetname != "") && (best_ent.use != SUB_Null) )
				setmodel(selector, "sprites/misc/select_r.spr");	
				//selector.model = "sprites/misc/select_r.spr";
	}		
	
	selector.enemy = best_ent;	
	
	/*if (best_ent.classname == "beamtrigger")
	{
		selector.trigger_field = best_ent;
		best_ent.spawnflags = best_ent.spawnflags | 1;	//make it visible
	}
	else if (selector.trigger_field)
	{
			beam = selector.trigger_field;
			if (beam.classname != "beamtrigger")
				objerror("selector trigger_field is not a beamtrigger!\n");
			else
				beam.spawnflags = beam.spawnflags - (beam.spawnflags & 1);
				
			selector.trigger_field = world;
	}*/
	
	e_org = (best_ent.absmax + best_ent.absmin)*0.5;	
	dir = e_org - (self.origin + self.view_ofs);	
	dir = normalize(dir);		
	
	e_org = e_org - dir*20;
	
	/*if (best_ent.flags & FL_MONSTER)
	{
		e_org_z = e_org_z + 8;
		
		if (best_ent.health > 0)
			e_org = e_org + best_ent.view_ofs;
	}
	else if (best_ent.flags & FL_ITEM)	
		e_org_z = e_org_z + 16;*/
	
	setorigin(selector, e_org);
	
	//if (best_ent.model == "")
	//	org = best_ent.origin;	
};

void() EntSelector_ToggleState =
{
	if (!EntSelectorSafeCheck())
		return;	
		
	self.trigger_field.state = !self.trigger_field.state;
	
	if (self.trigger_field.state)
		dprint("entity selector activated\n");
	else
	{
		self.trigger_field.model = "";
		self.trigger_field.enemy = world;
		dprint("entity selector de-activated\n");
	}		
};

void() EntSelector_Kill =
{
	local entity selector;	

	if (!EntSelectorActive())
		return;	
		
	selector = self.trigger_field;
		
	T_Damage(selector.enemy, selector, self, selector.enemy.health + 10);
};

void() EntSelector_Use =
{
	local entity oldself;	
	local float notarg;
	
	if (!EntSelectorActive())
		return;		
	
	oldself = self;
	self = self.trigger_field.enemy;
		
	if (self.use != SUB_Null)
	{
		if (self.use)
		{
			activator = oldself;
			
			if ((self.flags & FL_MONSTER) && (activator.flags & FL_NOTARGET))	//use this to wake up monsters even in notarget mode
			{
				notarg = TRUE;
				activator.flags = activator.flags - FL_NOTARGET;
			}			
			self.use();
			if (notarg)
				activator.flags = activator.flags | FL_NOTARGET;
		}
	}
	
	self = oldself;	
};

void() EntSelector_Touch =
{
	local entity oldself;	

	if (!EntSelectorActive())
		return;			
	
	oldself = self;
	self = self.trigger_field.enemy;
		
	if (self.touch != SUB_Null)
	{
		if (self.touch)
		{
			other = oldself;
			self.touch();
		}
	}
	
	self = oldself;
};

void() EntSelector_Print =
{
	if (!EntSelectorActive())
		return;			
	
	eprint(self.trigger_field.enemy);	
};