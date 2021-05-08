



void() vermis_wake1;
void() vermis_trans1;
void() vermis_idle1;

void() VermisFoundTarget =
{
	if (self.enemy.classname == "player")
	{	// let other monsters see this monster for a while
		sight_entity = self;
		sight_entity_time = time;
	}
	
	self.show_hostile = time + 1;		// wake up other monsters

	
	

	self.goalentity = self.enemy;
	
	if (self.coiled != 0)
	{
		self.think = vermis_wake1;
		sound (self, CHAN_VOICE, "vermis/sight.wav", 1, 0.4);
	}
	else
	{
		self.think = vermis_trans1;
		sound (self, CHAN_VOICE, "vermis/sight2.wav", 1, 0.4);
	}

	self.th_stand = vermis_idle1;	
	self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);
	self.nextthink = time + 0.1;
	self.shield = 1;
};


void() vermis_use =
{
	if (self.enemy)
		return;
	if (self.health <= 0)
		return;
	if (activator.items & IT_INVISIBILITY)
		return;
	if (activator.flags & FL_NOTARGET)
		return;
	if (activator.classname != "player")
		return;
	
// delay reaction so if the monster is teleported, its sound is still
// heard
	self.enemy = activator;

	self.nextthink = time + 0.1;
	self.think = VermisFoundTarget;
};






/*
===========
FindTarget

Self is currently not attacking anything, so try to find a target

Returns TRUE if an enemy was sighted

When a player fires a missile, the point of impact becomes a fakeplayer so
that monsters that see the impact will respond as if they had seen the
player.

To avoid spending too much time, only a single client (or fakeclient) is
checked each frame.  This means multi player games will have slightly
slower noticing monsters.
============
*/
float() VermisFindTarget =
{
	local entity	client;
	local float		r;

// if the first spawnflag bit is set, the monster will only wake up on
// really seeing the player, not another monster getting angry

// spawnflags & 3 is a big hack, because zombie crucified used the first
// spawn flag prior to the ambush flag, and I forgot about it, so the second
// spawn flag works as well
	if (sight_entity_time >= time - 0.1 && !(self.spawnflags & 3) )
	{
		client = sight_entity;
		if (client.enemy == self.enemy)
			return FALSE;
	}
	else
	{
		client = checkclient ();
		if (!client)
			return FALSE;	// current check entity isn't in PVS
	}

	if (client == self.enemy)
		return FALSE;

	if (client.flags & FL_NOTARGET)
		return FALSE;
	if (client.items & IT_INVISIBILITY)
		return FALSE;

	r = range (client);
	if (r == RANGE_FAR)
		return FALSE;
		
	if (!visible (client))
		return FALSE;

	if (r == RANGE_NEAR)
	{
		if (client.show_hostile < time && !infront (client))
			return FALSE;
	}
	else if (r == RANGE_MID)
	{
		if ( /* client.show_hostile < time || */ !infront (client))
			return FALSE;
	}
	
//
// got one
//

	self.enemy = client;
	if (self.enemy.classname != "player")
	{
		self.enemy = self.enemy.enemy;
		if (self.enemy.classname != "player")
		{
			self.enemy = world;
			return FALSE;
		}
	}
	
   
	VermisFoundTarget ();

	return TRUE;
};






void() vermis_start_go =
{



        if (!self.spawnflags & TRIGGER_SPAWN)
        {
                self.origin_z = self.origin_z + 1;      // raise off floor a bit
                //droptofloor();

        }


	
	self.takedamage = DAMAGE_AIM;

	self.ideal_yaw = self.angles * '0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 15;
	self.view_ofs = '0 0 25';
	self.use = vermis_use;
	
	self.flags = self.flags | FL_MONSTER;
	self.flags = self.flags | FL_FLY;
	
	self.pausetime = 99999999;
	self.th_stand ();




// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random()*0.5;

//below is long, it is to make sure it doesn't wake up on notarget mode or any other contigency
//otherwise, it will wake up to the activator.  obviously, this only works in conjunction with
// trigger_spawn, because a targetted monster would already be awake at this point.
        if (self.spawnflags & TRIGGER_SPAWN && self.spawnflags & TRIGGER_AWAKE && !activator.items & IT_INVISIBILITY && !activator.flags & FL_NOTARGET && activator.classname == "player")
        {
               self.enemy = activator;
               self.nextthink = time + 0.1;
               self.think = FoundTarget;
        }

        if (self.awake == 1 && !self.enemy.items & IT_INVISIBILITY && !self.enemy.flags & FL_NOTARGET && self.enemy.classname == "player")
        {
               self.nextthink = time + 0.1;
               self.think = FoundTarget;
        }

};


void() vermis_start =
{
// delay drop to floor to make sure all doors have been spawned
// spread think times so they don't all happen at same time
	if (!self.spawnflags & TRIGGER_SPAWN)
	{
		self.nextthink = self.nextthink + random()*0.5;
		self.think = vermis_start_go;
	}
	else
		vermis_start_go(); //make this instantaneous if it's being spawned.
	total_monsters = total_monsters + 1;
};