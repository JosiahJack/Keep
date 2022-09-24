//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: All
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
// Entity count: 3
// Function count: 3
//
// Implements: Treasure and Miscellaneous Drake Item Pickups
//
// Description:
// The health gems and armor coins from Drake that monster's dropped from their
// 'purse' on death.  Gems give slight health, and coins give slight armor.s
//=============================================================================

void() item_coin_touch_versus;

// Updates gem color and glimmer.
void(float gt) gem_colors = { // [FUNCTION]
    local float bit3, bit4, newskin;

    bit4 = self.cnt = (self.cnt + 1) & 7;
    bit3 = bit4 & 3;
    if (gt == 1) {        // 00001111
        newskin = (bit4 / 4);
    } else if (gt == 2) { // 00110011
        newskin = ((bit3 & 2) / 2);
    } else if (gt == 3) { // 21002100
        newskin = 2 - bit3;
        if (newskin < 0) newskin = 0;
    } else if (gt == 4) { // 01210121
        if (bit3 == 3) newskin = 1;
        else newskin = bit3;
    } else if (gt == 5) { // 01230123
        newskin = bit3;
    } else if (gt == 6) { // 01233210
        if (bit4 & 4) newskin = 3 - bit3;
        else newskin = bit3;
    } else {              // 40414243
        if (bit4 & 1) newskin = ((bit4 & 6) / 2) & 3;   
        else newskin = 4;
    }
    self.skin = newskin;
};

// Magic gem thinking -- change color every frame for pulsating glimmer.
void() gem_pulse = { // [FUNCTION]
    self.nextthink = time + 0.1;
    self.think = gem_pulse;     // Must define here in case of dynamic spawn.
    gem_colors(self.worldtype);    // FIXME:  Confirm in item_treasure.
};

// Called when something bumps into item_treasure.
void() treasure_touch = { // [FUNCTION]
    if (other.health <= 0) return;
    if (!(other.flags & FL_CLIENT)) return;

    sprint(other, "You found ");
    sprint(other, self.netname);
    sprint(other, "\n");
    Safe_stuffcmd(other, "bf\n");
    sound(other,CHAN_ITEM,self.noise,1,ATTN_NORM);
    if (!self.healamount) self.healamount = 5;
    if (self.healtype)
        T_Heal(other, self.healamount, TRUE); // Reward with max hp increase -- not in SoE!
    else
        T_Repair(other, self.healamount, TRUE); // SoE: Increase armor, ignoring max, like in classic Doom.

	activator = other;
	SUB_UseTargets();
	item_finished();
	if (!self.respawn_trig) start_item_respawn();
};

void() item_coin_setskin = { // [FUNCTION]
   if (self.count < 1) self.count = 1;  //number of coins
   if (self.count == 1) self.skin = 0;
   if (self.count == 2) self.skin = 1;
   if (self.count == 3) self.skin = 2;
   if (self.count == 4) self.skin = 3;
   if (self.count == 5) self.skin = 4;
};

// Large gems or gold coins.  Gems raise health by 3, ignoring max health.
// Coins raise armor by a like amount, up to an absolute limit of 250.
// Note:  In Drake, maximum health gets raised by 1 permanently.
void() item_treasure = { // [ENTITY]
    self.classname = "item_treasure";
    self.touch2 = treasure_touch;
    if (self.spawnflags & 1) { self.frame = 0;  self.healamount = 5; }
    else if (self.spawnflags & 2) { self.frame = 2;  self.healamount = 20; }
    else { self.frame = 1;  self.healamount = 10; }
    if (self.healtype) {
        if (self.worldtype) self.th_win = gem_pulse;
        self.netname = "a gem";
        item_setupmodel("progs/drake/t_gem.mdl",self.skin); // SOE gem
        if (self.skin < 0) {
            self.skin = random() * 4.999;
            self.skin = floor (self.skin);
        }
    } else {
        self.netname = "gold";
        item_coin_setskin();
        item_setupmodel("progs/drake/t_coin.mdl",self.frame); // SOE coin
        if (coop > 2) self.touch2 = item_coin_touch_versus;
    }
	self.respawn_style = PARTICLE_BURST_WHITE + PARTICLE_BURST_RING;
	self.classtype = CT_HEALROT;
	self.respawn_effect = TRUE;
	self.respawn_ofs = '0 0 16';
	self.bbmins = VEC_ITEM_MIN;
	self.bbmaxs = '16 16 56';
	if (self.respawn_time == 0) self.respawn_time = RESPAWN_HEALTH;
	item_setupnoise("drake/items/treasure.wav");

	// Query console variable 'temp1' for model upgrade option.
	// Cannot use global vars because they don't exist at this point
	// Move the new centered ammo models to match old ammo origin
	// The default is to move all ammo items to suit original id maps
	if (query_configflag(SVR_ITEMOFFSET) == FALSE) {
		self.oldorigin = self.origin + '16 16 0';
		setorigin(self, self.oldorigin);
	}

	// Setting the angle key in the editor to UP/DOWN = random rotation	
	if (self.angles_y < 0 || (self.angles_y == 0 && query_configflag(SVR_ITEMROTATE) == FALSE)) self.angles_y = rint(random()*359);

	item_coopcheck();
	item_start();
};

void() item_treasure_gem = { self.healtype = 1; item_treasure(); }; // [ENTITY], Large gems

void() item_treasure_coin = { self.healtype = 0; item_treasure(); }; // [ENTITY], Large gold coins