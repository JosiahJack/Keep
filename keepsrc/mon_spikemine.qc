//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Hipnotic
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
// Entity count: 
// Function count: 
//
// Implements: Spikemine
//
// Description:
// Floating spiked ball that homes in when it finds an enemy and explodes on
// impact with almost always deadly damage.
//=============================================================================

void() spikemine_Home = {
	local entity head, selected;
	local float cur_dist, head_dist;
	local vector dir, vtemp;

	self.frame = (self.frame + TRUE);
	if (self.frame == MOVETYPE_FLYMISSILE) self.frame = FALSE;
	self.nextthink = (time + 0.200);
	self.think = spikemine_Home;
	if ( (self.search_time < time) ) {
		selected = world;
		cur_dist = 2000.000;
		head = findradius (self.origin,2000.000);
		while ( head ) {
			if (!Invisible(head) && (head.flags & FLx_CREATURE)) {
				if (visible(head) && (head.health > FALSE)) {
					head_dist = vlen(head.origin - self.origin);
					if (head_dist < cur_dist) {
						selected = head;
						cur_dist = head_dist;
					}
				}
			}
			head = head.chain;
		}
		if ( (selected != world) )
		sound(self,CHAN_VOICE,"hipnotic/items/spikmine.wav",TRUE,ATTN_NORM);

		self.enemy = selected;
		self.search_time = (time + 1.300);
	}
	if (!self.enemy) {
		StopSound(self,CHAN_VOICE);
		self.velocity = VEC_ORIGIN;
		return;
	}
	vtemp = (self.enemy.origin + '0.000 0.000 10.000');
	dir = normalize ((vtemp - self.origin));
	if (infront (self.enemy))
		self.velocity = (dir * ((skill * 50.000) + 50.000));
	else
		self.velocity = (dir * ((skill * 50.000) + 150));
};

void() spikemine_Touch = {
	if ( (self.health > FALSE) ) {
		if (other.classname == "trap_spike_mine" || other.classname == "monster_spikemine") return;
		if (AffectedByPhysics(other)) return;

		T_Damage (self,self,self,(self.health + MOVETYPE_BOUNCE),DAMARMOR);
	}
	T_RadiusDamage (self,self,45.000,world,DAMAGEALL);
	R_Exp3(self.origin);
	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST,TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST,self.origin_x);
	WriteCoord (MSG_BROADCAST,self.origin_y);
	WriteCoord (MSG_BROADCAST,self.origin_z);
	StopSound(self,CHAN_VOICE);
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	setmodel(self,"progs/drake/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1();
};

void() spike_mine_first_think = {
	self.think = spikemine_Home;
	self.nextthink = (time + 0.100);
	self.search_time = FALSE;
	self.takedamage = DAMAGE_AIM;
	self.use = monster_use;
};

void() monster_spikemine_precache = {
	precache_model ("progs/hipnotic/mon_spikmine.mdl");
	precache_sound("hipnotic/items/spikmine.wav");
};

void() monster_spikemine = {
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/hipnotic/mon_spikmine.mdl";
	precache_monster(self.classname);
	setmodel(self,"progs/hipnotic/mon_spikmine.mdl");
	setsize (self,'-16 -16 -24', '16 16 16'); //MonTiny
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_FLYMISSILE;
	self.avelocity = '-50.000 100.000 150.000';
	if (self.health < 1) self.health = 200;
	self.frame = FALSE;
	self.think = spike_mine_first_think;
	self.touch = spikemine_Touch;
	self.th_die = spikemine_Touch;
	self.th_stand = spikemine_Home;
	self.th_walk = spikemine_Home;
	self.th_run = spikemine_Home;
	self.th_melee = spikemine_Home;
	self.th_missile = spikemine_Home;
	self.nextthink = (time + 0.200);
	if (world.devdata & DEV_AMMO_N_HEALTH) sendmonsterdevdata(self);
	if (self.deathstring == "") self.deathstring = " was obliterated by a Spikemine\n";
	AddToTotals(self);
	self.flags = (self.flags | FL_MONSTER);

	self.classname = "trap_spike_mine";
};

void() trap_spike_mine = {
	if (self.deathstring == "") self.deathstring = " was obliterated by a Spikemine\n";
	monster_spikemine(); 
};