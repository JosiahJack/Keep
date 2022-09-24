//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Zerstorer
//
//
// Distribution / Copyright / Permissions 
//
// Please do not use any of these assets in ANY COMMERCIAL PROJECT.
// and remember to give credit if you use any of these assets. Please credit
// the appropriate authors of the various content used.  Refer to the credits
// folder.
//				  
// The QC files in this MOD are based on 1.06 source files by ID Software.
// These files are released under the terms of GNU General Public License v2 or
// later. You may use the source files as a base to build your own MODs as long
// as you release them under the same license and make the source available.
// Please also give proper credit. Check http://www.gnu.org for details.
//
// Quake is a registered trademark of id Software, Inc.
//
// All of these resources may be electronically distributed only at 
// NO CHARGE to the recipient.
//
// Stats:
// Entity count: 1
// Function count: 
//
// Implements: BloodCube Powerups
//
// Description:
// A new powerup.  The Cube is alive, and when you touch it you become its
// master.  The cube will start circling above your head, and will atack any
// monsters on sight.  If you don't feed the Cube plenty of gibs, it will get
// hungry and start to feed off of your blood.
//=============================================================================

void() StartCube;
void() Cube_die;
void() Cube_control;

// A new attack style for the BloodCube.
void(vector start, vector end, entity attacker, entity targ) CubeAttack = {
	Particle_Beam(start,end,73,225,40,TRUE);
	if(deathmatch) {
	   if (targ.health < self.dmg) T_Damage(targ,attacker,attacker,self.dmg * 5,DAMARMOR);
	   else T_Damage(targ,attacker,attacker,self.dmg,DAMARMOR);
	} else {
	   if (targ.health < (self.dmg + 10)) T_Damage(targ,attacker,attacker.owner,self.dmg * 5,DAMARMOR);
	   else T_Damage(targ,attacker,attacker.owner,self.dmg,DAMARMOR);
	}
		
	if (self.t_width < time) {
		sound (self, CHAN_AUTO, "zerstorer/cube/bc_attck.wav", 1, ATTN_NORM);
		self.t_width = time + 0.4;
	}
};

// Used to traverse linked list to shoot lightning at all visible enemies.
void() Shoot_all = {
	if(self.aiment) {
	   if(self.aiment.health > 0)
	   if(visible(self.aiment)) {
		   traceline (self.owner.origin, self.aiment.origin, TRUE, self.owner);
		   CubeAttack (self.owner.origin, (self.aiment.origin + '0 0 16'), self.owner, self.aiment);
	   }
	   self.aiment = self.aiment.aiment;
	   self.nextthink = time + 0.01;
	} else remove(self);
};

// Looks through linked list and removes all dead entities.  If this is a
// multiplayer game, give owner a frag.
void() FeedMe = {
    local entity shooter, temp;

	temp = self;
	while (self.aiment) {
        if(self.aiment.health <= 0) {
            self.aiment = self.aiment.aiment;
            if (deathmatch || coop) temp.owner.frags = temp.owner.frags + 1;
        }
        self = self.aiment;
	}
	self = temp;
	if (self.aiment == world) {
		self.avelocity = '0 100 0';
		return;
	}
	shooter = spawn();
	shooter.aiment = self.aiment;
	shooter.origin = self.origin;
	shooter.owner = self;
	shooter.think = Shoot_all;
	shooter.nextthink = time + 0.01;
};

void(vector cdest) FeedonPlayer = {
    local vector	spray,vec;
    local float		t;

	spray = cdest - self.owner.origin;
	particle (self.owner.origin + '0 0 24', spray, 225, 70);
	sound (self, CHAN_AUTO, "zerstorer/cube/bc_attck.wav", 1, ATTN_NORM);
	T_Damage(self.owner, self, self,1,DAMARMOR);
	self.invisible_time = time + 2;    // suck blood again in 2 secs
};


// Looks for all entities within the range given by self.meleerange, and creates a
// linked list of all possible targets.	self.aiment is the link field.
void() LookforBlood = {
    local entity head, linker;

	linker = self;
	head = findradius(self.origin, self.meleerange);
	
	while (head) {
		if (head.flags & FL_MONSTER || head.flags & FL_CLIENT)
		if (head.health > 0 && head != self.owner) {
		   if (visible(head)) {
		 	linker.aiment = head;
			linker = head;
		   }
		}
		head = head.chain;
	}

	if (self.aiment) {
		self.enemy = self.aiment;
		self.avelocity = '0 500 0';
	}
};

// Used to calculate the cubes velocity to get it to the next position.
void(vector tdest, float tspeed, void() func) blood_CalcMove = {
    local vector vdestdelta;
    local float len, traveltime;

	self.finaldest = tdest;
	self.think = func;
	if (tdest == self.origin) {
		self.velocity = '0 0 0';
		self.nextthink = time + 0.05;
		return;
	}

	vdestdelta = tdest - self.origin;
	len = vlen (vdestdelta);
	traveltime = len / tspeed;
	if (traveltime < 0.01) {
		self.velocity = '0 0 0';
		self.nextthink = time + 0.01;
		return;
	}

	self.nextthink = time + traveltime;
	self.velocity = vdestdelta * (1/traveltime);
};

/* ---------------------------------------------------- */
/* | Cube_control - This is called by the Cube every  | */
/* | 0.5 seconds.  It assigns the cube a destination  | */
/* | and also scans the area for enemies.  Also keeps | */
/* | track of all the timers.	 It's a bit too big.	| */
/* ---------------------------------------------------- */
void() Cube_control = {
    local vector	cdest;
    local float		clen, cuspeed;

	if (self.owner.view_ofs == '0 0 0')
	{
		self.velocity = '0 0 0';
		self.think = Cube_control;
		self.nextthink = time + 0.5;
		return;
	}

	if (self.cnt == 0)
		cdest = self.owner.origin + '0 36 52';
	else if (self.cnt == 1)
		cdest = self.owner.origin + '25 25 52';
	else if (self.cnt == 2)
		cdest = self.owner.origin + '36 0 52';
	else if (self.cnt == 3)
		cdest = self.owner.origin + '25 -25 52';
	else if (self.cnt == 4)
		cdest = self.owner.origin + '0 -36 52';
	else if (self.cnt == 5)
		cdest = self.owner.origin + '-25 -25 52';
	else if (self.cnt == 6)
		cdest = self.owner.origin + '-36 0 52';
	else
		cdest = self.owner.origin + '-25 25 52';

	traceline(self.origin + '0 0 16', cdest, TRUE, self);
	//dprint(ftos(trace_fraction));dprint(" = trace_fraction\n");
	if (trace_fraction < 1)
		cdest = self.owner.origin + '0 0 48';
	traceline(self.origin, cdest + '0 0 32', TRUE, self);
	if (trace_fraction < 1)
		cdest = cdest - '0 0 16';
	clen = vlen(cdest - self.origin);
	if(clen > 500)
	{
		//sprint(self.owner, "The BloodCube teleports\n");
		setorigin (self, (self.owner.origin + '0 0 24'));
		self.velocity = '0 0 0';
		self.think = Cube_control;
		self.nextthink = time + 0.1;
		return;
	}
	if(clen < 50)
		cuspeed = clen * 2;
	else
		cuspeed = clen * 4;

	self.cnt = self.cnt + 1;
	if (self.cnt >= 8)
		self.cnt = 0;

	LookforBlood();	   //dhm: this sets self.aiment if a target is found
	if(self.aiment != world)
	 if(self.attack_finished < time) {
		FeedMe();
		self.attack_finished = time + self.delay;
	 }

	if(self.invincible_finished < time)
	 {
		sound(self, CHAN_ITEM, "zerstorer/cube/bc_hngry.wav", 1, ATTN_NORM);
		self.invincible_finished = time + 30;
	 }
	
	if(self.invisible_time < time)
		FeedonPlayer(cdest);

	if(self.radsuit_finished < (time+5))
	 if(self.rad_time < time)
	 {
		sound(other, CHAN_AUTO, "zerstorer/cube/bc_activ.wav", 1, ATTN_NORM);
		stuffcmd(self.owner, "bf\n");
		sprint(self.owner, "The Sanguinoch grows weary of you\n");
		self.rad_time = time + 5.5;
	 }
	if(self.radsuit_finished < time)
	{
		sprint(self.owner, "The Sanguinoch has left you\n");
		Cube_die();
		return;
	}
	if(self.owner.health <= 0)
	{
		Cube_die();
		return;
	}

	blood_CalcMove(cdest, cuspeed, Cube_control);
};

// If it sees that it will hit a wall, it centers itself above player until
// next call to Control_cube.
void() bloodcb_touch = {
	if (self.state == STATE_OFF) return;
	if (other.flags & FL_MONSTER) return;
	if (other.health <= 0 || !(other.flags & FL_CLIENT)) {
		if (self.state == STATE_ON) self.velocity = ((self.owner.origin + '0 0 48') - self.origin)*2;
		return;
	}
	if (other == self.enemy) {
		if (self.invincible_time < time) {
		   sprint(other, "The Sanguinoch doesn't want you anymore\n");
		   self.invincible_time = time + 2;
		}
		return;
	}
	if (self.state == STATE_ON) return; // Already has an owner!

	self.owner = other;
	self.state = STATE_ON;	//Cube is in the AWAKE state now
	self.cnt = 0;
	self.radsuit_finished = time + self.attack_lifetime;
	self.invincible_finished = time + 12;   //time until hungry sound
	self.invisible_time = time + 2;
	sprint(other, "The Sanguinoch befriends you\n");
	sound(other, CHAN_AUTO, "zerstorer/cube/bc_activ.wav", 1, ATTN_NORM);
	stuffcmd (other, "bf\n");
	if (!deathmatch) SUB_UseTargets ();
	self.nextthink = time + 0.2;
	self.think = Cube_control;
};

void() Cube_stop = {
	self.velocity = '0 0 0';
	self.think = StartCube;
	self.nextthink = time + 300;
};

void() Cube_sleep = { blood_CalcMove(self.origin - '0 0 32', 20, Cube_stop); };

// Called when cube leaves the player for any reason.  The cube will just lower
// itself a few feet and wait for someone else to pick it up.  The same player
// cannot pick it up twice in a row
void() Cube_die = {
    local vector spot;

    // dhm: in single play, gone.
	if(!(deathmatch) && !(coop)) {
		self.think = SUB_Remove;
		self.nextthink = time + 0.1;
		return;
	}

	self.enemy = self.owner;
	self.aiment = world;
	self.owner = world;
	self.solid = SOLID_NOT;
	self.state = STATE_OFF;
	self.velocity = '0 0 0';
	setorigin(self, self.oldorigin);
	self.mdl = self.model;
	self.model = "";
	self.nextthink = time + 300;
	self.think = StartCube;
};

void() StartCube = {
	self.state = STATE_DISABLED;
	self.netname = "BloodCube";
	setorigin(self, self.origin);
	if (deathmatch) self.solid = SOLID_TRIGGER;
	else self.solid = SOLID_BBOX;

	self.flags = self.flags | FL_ITEM;
	self.movetype = MOVETYPE_FLY;	
	self.velocity = '0 0 0';
	self.avelocity = '0 100 0';
	self.model = self.mdl;
	setmodel (self, "progs/zerstorer/bloodcb.mdl");
	setsize (self, '-1 -1 -1', '1 1 1');
};

// QUAKED item_bloodcube (0 .5 .8) (-16 -16 -24) (16 16 32)
void() item_bloodcube = { // [ENTITY]
	if (deathmatch) {
		self.dmg = 15;
        self.delay = 0.25;
		self.meleerange = 300;
        self.attack_lifetime = 30;
		SUB_UseTargets ();
	} else {
        self.dmg = 20;
        self.delay = 0.1;
        self.meleerange = 400;
        self.attack_lifetime = 40;
    }

	self.classname = "BloodCube";
	self.touch = bloodcb_touch;
	self.oldorigin = self.origin;
	precache_model("progs/zerstorer/bloodcb.mdl");
	precache_sound("zerstorer/cube/bc_activ.wav");
	precache_sound("zerstorer/cube/bc_hngry.wav");
	precache_sound("zerstorer/cube/bc_gulp.wav");
	precache_sound("zerstorer/cube/bc_attck.wav");
	self.nextthink = time + 0.2;
	self.think = StartCube;
};

// Used by flying gibs to guide them into the Bloodcube.
void() SeekCube = {
    local vector	vdestdelta;
    local float		len, traveltime, addhealth;

	if (deathmatch) addhealth = 7;
	else addhealth = 3;

	if(self.enemy == world || self.enemy.state == STATE_OFF) {
		self.movetype = MOVETYPE_BOUNCE;
		self.think = RemoveGib;
		self.nextthink = time + GIB_FADETIME + random() * GIB_FADETIME;
		return;
	}

	if(!(visible(self.enemy))) {
		self.movetype = MOVETYPE_BOUNCE;
		self.think = RemoveGib;
		self.nextthink = time + GIB_FADETIME + random() * GIB_FADETIME;
		return;
	}

	vdestdelta = self.enemy.origin - self.origin;
	len = vlen (vdestdelta);
	traveltime = len / 300;
	if (traveltime < 0.2) {
		if (self.enemy.super_time < time) {
			sound(self.enemy, CHAN_ITEM, "zerstorer/cube/bc_gulp.wav", 1, ATTN_NORM);
			self.enemy.super_time = time + 0.8;
		}
		self.enemy.owner.health = self.enemy.owner.health + addhealth;
		if (self.enemy.owner.flags & FL_CLIENT) stuffcmd(self.enemy.owner,"bf\n");
		remove(self);
		return;
	}
	self.velocity = vdestdelta * (1/traveltime);
	self.nextthink = time + 0.2;
	self.think = SeekCube;
};