/* VERSUS.QC
===================================================================================================================
by Qmaster

Multiplayer game mode where there are two teams

Survival team must battle monsters and collect coins to pay for unlocking the next area, 
weapons, powerups, etc. until they can pay for and access the exit.

Gamemaster team must spawn monsters of their choice and collect bones to pay for more monsters
until the survival team are out of lives.

FOR AD MOD OR AD DERIVATIVES ONLY
===================================================================================================================
*/
/*  ADD TO setttings.qc -> ImpulseCommands() FUNCTION
===================================================================================================================
void(entity targ) print_coins;
void(entity targ) print_bones;

	else if (self.impulse == 143) print_coins();		// Display versus currency for survival player(s)
	else if (self.impulse == 144) print_bones();		// Display versus currency for gamemaster player(s)

===================================================================================================================
*/

void () usecommand = {
	self.usingfinished = time + 0.8; // show that we pressed using for a bit, to give time for touches to register
};

void () versus_setup = {
	precache_model("progs/coinitem.mdl");
   coins = 0;
   bones = 0;
   numsurvivors = 0;
   numgamemasters = 0;
	wavenumber = 0;
};

void (entity targ) set_teamsurvivor = {
	if (targ.versustype < 1) {
		targ.versustype = VT_SURVIVOR;
		targ.alignment = GOOD;
	} else {
		if (developer) {
			targ.versustype = VT_SURVIVOR;
			targ.alignment = GOOD;
		} else {
			sprint(targ,"Already on a team, can't change mid-game");
		}
	}   
};

void (entity targ) set_teamgamemaster = {
	if (targ.versustype < 1) {
		targ.versustype = VT_GAMEMASTER;
		targ.alignment = EVIL;
	} else {
		if (developer) {
			targ.versustype = VT_GAMEMASTER;
			targ.alignment = EVIL;
		} else {
			sprint(targ,"Already on a team, can't change mid-game");
		}
	}   
};

// Let's Survivors know how many coins they have collected to use for purchasing weapons, items, doors, etc.
void () print_coins = {
	if ((coop < 3 || (coop > 2 && self.versustype == VT_SURVIVOR)) || developer) centerprint2(self,"Coin total: ",ftos(coins));
};

// Let's Gamemasters know how many gibs they have collected to use for purchasing more monsters or events.
void () print_bones = {
	if ((coop > 2 && self.versustype == VT_GAMEMASTER) || developer) centerprint2(self,"Gib total: ",ftos(bones));
};

void () item_coin_touch = {
   if (coop > 2 && other.versustype != VT_SURVIVOR)  return;
   if ( !(other.flags & FL_CLIENT) ) return;

   sprint (other, "You got ");
   sprint (other, ftos(self.count));
   if (self.count == 1) sprint (other, " coin!\n");
   else sprint (other, " coins!\n");
   Safe_stuffcmd (other, "bf\n");
   coins = coins + self.count;
   sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
   item_finished();
   check_item_respawn();
   activator = other;
   SUB_UseTargets();
};

void () item_coin_setup = {
   if (self.noise == "") self.noise = "items/money.wav";

   precache_sound (self.noise);
   self.touch = item_touch;
   self.touch2 = item_coin_touch;
   self.bbmins = VEC_KEYS_MIN;
   self.bbmaxs = VEC_KEYS_MAX;
   item_start();
};

void () item_coin_setskin = {
   if (self.count < 1) self.count = 1;  //number of coins
   if (self.count == 1) self.skin = 0;
   if (self.count == 2) self.skin = 1;
   if (self.count == 3) self.skin = 2;
   if (self.count == 4) self.skin = 3;
   if (self.count == 5) self.skin = 4;
};

void () item_coin = {
	if (self.mdl == "") self.mdl = "progs/coinitem.mdl";
	precache_model (self.mdl);
	item_coin_setskin();
	item_coin_setup();
};

float() can_eat_bones = {
	if (coop < 2) return FALSE;
	if (other.versustype != VT_GAMEMASTER)  return FALSE;
	if ( !(other.flags & FL_CLIENT) ) return FALSE;
	return TRUE;
};

void () item_bone_touch = {
	if (can_eat_bones()) {
		sprint (other, "You got ");
		sprint (other, ftos(self.count));
		if (self.count == 1) sprint (other, " bone!\n");
		else sprint (other, " bones!\n");
		Safe_stuffcmd (other, "bf\n");
		bones = bones + self.count;
		sound (other, CHAN_ITEM, self.noise, 1, ATTN_NORM);
		item_finished();
		check_item_respawn();
		activator = other;
		SUB_UseTargets();
	}
};

void () item_bone = {
	if (self.mdl == "") self.mdl = "progs/boneitem.mdl";
	precache_model (self.mdl);
	if (self.noise == "") self.noise = "polyp/gibsplt1.wav";
	if (!self.count) self.count = 1;
	precache_sound (self.noise);
	self.touch = item_touch;
	self.touch2 = item_bone_touch;
	self.bbmins = VEC_KEYS_MIN;
	self.bbmaxs = VEC_KEYS_MAX;
	item_start();
};

//----------------------------------------------------------------------
void(float c) DropCoin = {
	local entity item;

	if (c < 1 || c > 99) return;

	if (coop != 3) return; // not in versus mode

	item = spawn();
	item.classname = "item_coin";
	item.origin = self.origin - '0 0 20';
	item.count = c;
	item_coin_setskin();
	item.velocity_z = 300;
	item.velocity_x = -100 + (random() * 200);
	item.velocity_y = -100 + (random() * 200);
	item.flags = FL_ITEM;
	item.solid = SOLID_TRIGGER;
	item.movetype = MOVETYPE_TOSS;
	self.noise = "items/money.wav";
	setmodel (item, "progs/coinitem.mdl");
	setsize (item, '-16 -16 -24', '16 16 32');
	item.touch = item_touch;
	item.touch2 = item_coin_touch;
	item.item_expired = 0; //coins never expire
	item.item_flrcheck = fabs(item.mins_z) + 16;
	item.think = item_thinkloop;		// Check floor
	item.nextthink = time + 0.3;		// Let coin drop first
};

/* Purchasing code
	// Check for and allow for purchases in versus survivor mode
	if (coop > 2 && other.versustype == VT_SURVIVOR && self.cost > 0) {
		if (other.usingfinished > time) {
			if (coins >= self.cost) {
				// continue on
				coins = coins - self.cost;
				other.usingfinished = 0;
			} else {
				centerprint(other,"You do not have enough for this");
				return;
			}
		} else {
			centerprint3(other,"Press \b'e'\b to purchase for ",ftos(self.cost)," coins.");
			return;
		}
	}
*/

void () trigger_coinpurchase_touch = {
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

void () trigger_coinpurchase = {
   InitTrigger ();
   self.touch = trigger_coinpurchase_touch;
	if (self.cost <= 0) self.cost = 1; // no free lunch
};

void () trigger_gibpurchase_touch = {
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

void () trigger_gibpurchase = {
   InitTrigger ();
   self.touch = trigger_gibpurchase_touch;
	if (self.cost <= 0) self.cost = 1; // no free lunch
};