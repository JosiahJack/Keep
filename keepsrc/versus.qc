//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Qmaster
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
// Implements: Multiplayer game mode pitting survivors against gamemasters
//
// Description:
// Survival team must battle monsters and collect coins to pay for unlocking
// the next area, weapons, powerups, etc. until they can pay for and access the
// exit.  Coins are shared among all survival players.  Players start with 3
// lives per player to the total survivor life pool, up to 12 (4 X 3) at start.
//
// Gamemaster team must spawn monsters of their choice and collect bones to pay
// for more monsters until the survival team are out of lives.  Bones are
// shared among all gamemaster players.  Gamemasters are on noclip, notarget,
// and god mode and cannot switch off from this.
//
// Cannot be a gamemaster if no other players are present.

// Possible to play as survivor(s) versus randomized computer gamemaster
// similar to LF4D2 director or Call of Duty zombies mode.
//=============================================================================

// For pressing a use keybind to use something.  Used by purchase triggers.
void() usecommand = { // [FUNCTION]
	self.usingfinished = time + 0.8; // show that we pressed using for a bit, to give time for touches to register
};

// Sets up the base game states for versus mode
void() versus_setup = { // [FUNCTION]
	precache_model("progs/qmaster/coinitem.mdl"); // Spawned by all monsters on death
	precache_model("progs/qmaster/boneitem.mdl"); // Spawned by all monsters on death, if gamemasters are present
	coins = 0;
	bones = 0;
	numsurvivors = 0;
	numgamemasters = 0;
	wavenumber = 0;
	dprint("\b[VERSUS]\b Versus mode setup and active!\n");
};

void(entity targ) set_teamsurvivor = { // [FUNCTION]
	if (targ.versustype < 1) {
		targ.versustype = VT_SURVIVOR;
		targ.alignment = GOOD;
	} else {
		if (developer > 0) {
			targ.versustype = VT_SURVIVOR;
			targ.alignment = GOOD;
		} else {
			sprint(targ,"Already on a team, can't change mid-game");
		}
	}   
};

void(entity targ) set_teamgamemaster = { // [FUNCTION]
	if (targ.versustype < 1) {
		targ.versustype = VT_GAMEMASTER;
		targ.alignment = EVIL;
	} else {
		if (developer > 0) {
			targ.versustype = VT_GAMEMASTER;
			targ.alignment = EVIL;
		} else {
			sprint(targ,"Already on a team, can't change mid-game");
		}
	}
};

// Let's Survivors know how many coins they have collected to use for purchasing weapons, items, doors, etc.
void() print_coins = { // [FUNCTION]
	if ((coop < 3 || (coop > 2 && self.versustype == VT_SURVIVOR)) || developer > 0) centerprint2(self,"Coin total: ",ftos(coins));
};

// Let's Gamemasters know how many gibs they have collected to use for purchasing more monsters or events.
void() print_bones = { // [FUNCTION]
	if ((coop > 2 && self.versustype == VT_GAMEMASTER) || developer > 0) centerprint2(self,"Gib total: ",ftos(bones));
};

void() item_coin_touch_versus = { // [FUNCTION]
   if (coop > 2 && other.versustype != VT_SURVIVOR)  return;
   if ( !(other.flags & FL_CLIENT) ) return;

   sprint(other, "You got ");
   sprint(other, ftos(self.count));
   if (self.count == 1) sprint(other, " coin!\n");
   else sprint(other, " coins!\n");
   Safe_stuffcmd(other, "bf\n");
   coins = coins + self.count;
   sound(other,CHAN_ITEM,self.noise,1,ATTN_NORM);
   activator = other;
   SUB_UseTargets();
   item_finished();
   if (!self.respawn_trig) start_item_respawn();
};


void() item_coin = {
	item_setupnoise("drake/items/money.wav");
	item_treasure_coin();
}

float() can_eat_bones = {
	if (coop < 2) return FALSE;
	if (other.versustype != VT_GAMEMASTER)  return FALSE;
	if ( !(other.flags & FL_CLIENT) ) return FALSE;
	return TRUE;
};

void() item_bone_touch = {
	if (!can_eat_bones()) return;
	
	sprint(other, "You got ");
	sprint(other, ftos(self.count));
	if (self.count == 1) sprint(other, " bone!\n");
	else sprint(other, " bones!\n");
	Safe_stuffcmd(other, "bf\n");
	bones = bones + self.count;
	sound(other,CHAN_ITEM,self.noise,1,ATTN_NORM);
	activator = other;
	SUB_UseTargets();
	item_finished();
	if (!self.respawn_trig) start_item_respawn();
};

void() item_bone = {
	if (self.mdl == "") self.mdl = "progs/qmaster/boneitem.mdl"; // Added rotate flag to ad171/proj_wraithbone.mdl
	precache_model (self.mdl);
	if (self.noise == "") self.noise = "quoth/polyp/gibsplt1.wav";
	if (!self.count) self.count = 1;
	precache_sound(self.noise);
	self.touch = item_touch;
	self.touch2 = item_bone_touch;
	self.bbmins = VEC_HULL_MIN;
	self.bbmaxs = VEC_HULL_MAX;
	item_start();
};

void(float c) DropCoin = {
	if (c < 1 || c > 99) return;
	if (coop != 3) return; // not in versus mode

	newmis = spawn();
	newmis.classname = "item_treasure";
	newmis.origin = self.origin - '0 0 20';
	newmis.count = c;
	item_coin_setskin();
	newmis.velocity_z = 300;
	newmis.velocity_x = -100 + (random() * 200);
	newmis.velocity_y = -100 + (random() * 200);
	newmis.flags = FL_ITEM;
	newmis.solid = SOLID_TRIGGER;
	newmis.movetype = MOVETYPE_TOSS;
	self.noise = "drake/items/money.wav";
	setmodel(newmis, "progs/qmaster/coinitem.mdl");
	setsize (newmis, VEC_HULL_MIN, VEC_HULL_MAX);
	newmis.touch = item_touch;
	newmis.touch2 = item_coin_touch_versus;
	newmis.item_expired = 0; //coins never expire
	newmis.item_flrcheck = fabs(newmis.mins_z) + 16;
	newmis.think = item_thinkloop;		// Check floor
	newmis.nextthink = time + 0.3;		// Let coin drop first
};

void() trigger_coinpurchase_touch = {
	if ( !(other.flags & FL_CLIENT) ) return;
	if (coop < 3 || (coop > 2 && other.flags & FL_CLIENT && other.versustype == VT_SURVIVOR)) {
		// Check for and allow for purchases in versus survivor mode
		if (self.cost > 0) {
			if (other.usingfinished > time) {
				if (coins >= self.cost) {
					// continue on
					coins = coins - self.cost;
					self.cost = 0;
					other.usingfinished = 0;
				} else {
					centerprint(other,"You do not have enough for this");
					return;
				}
			} else {
				centerprint3(other,"Press \b'e'\b to purchase for ",ftos(self.cost)," coins.");
				return;
			}
			//activator = other;
			SUB_UseTargets();
		}
	}
};

void() trigger_coinpurchase = {
   InitTrigger();
   self.touch = trigger_coinpurchase_touch;
	if (self.cost <= 0) self.cost = 1; // no free lunch
};

void() trigger_gibpurchase_touch = {
	if (other.flags & FL_CLIENT && other.versustype == VT_GAMEMASTER) {
		// Check for and allow for purchases in versus survivor mode
		if (coop > 2 && self.cost > 0) {
			if (other.usingfinished > time) {
				if (bones >= self.cost) {
					// continue on
					bones = bones - self.cost;
					other.usingfinished = 0;
				} else {
					centerprint(other,"You do not have enough for this");
					return;
				}
			} else {
				centerprint3(other,"Press \b'e'\b to purchase for ",ftos(self.cost)," gibs.");
				return;
			}
		}
		//activator = other;
		SUB_UseTargets();
	}
};

void() trigger_gibpurchase = {
   InitTrigger();
   self.touch = trigger_gibpurchase_touch;
	if (self.cost <= 0) self.cost = 1; // no free lunch
};