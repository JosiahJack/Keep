//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Drake by Patrick Martin, Hexen2
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
// Entity count: 6
// Function count: 12
//
// Implements: Miscellaneous Effects
//
// Description:
// Various decorative static objects or effects.
//=============================================================================

// This spawns a gib from the blood fountain.  Taken from Zerstorer and adapted to Drake.
void() gibs_fly = { // [FUNCTION]
    local float rnum; 

    rnum = random();
    if (rnum < 0.15) {
		ThrowGib(1,1);
		ThrowGib(2,1);
		ThrowGib(3,1);
		ThrowGib(4,1);
		ThrowGib(25,1);
        sound(self,CHAN_AUTO,"zerstorer/gibfnt/gf_sbig.wav",1,ATTN_NORM);
    } else if (rnum < 0.45) ThrowGib(1,1);
    else if (rnum < 0.85) ThrowGib(2,1);   //Zer uses gib4.mdl.
    else ThrowGib(3,1);

    if (random() < 0.5) sound(self,CHAN_VOICE, "zerstorer/gibfnt/gf_sprt1.wav",1,ATTN_NORM);
    else sound(self,CHAN_VOICE, "zerstorer/gibfnt/gf_sprt2.wav",1,ATTN_NORM);

    self.nextthink = time + (random() * 5) + 3;
    self.think = gibs_fly;
};

void() gibft_use = { // [FUNCTION]
    if (self.nextthink == 0) {
        self.nextthink = time + self.delay;
		self.think = gibs_fly;
    } else if (self.lefty) self.nextthink = 0;
    else remove (self);
};

// Gib Fountain -- Zerstorer style.
void() misc_gibft = { // [ENTITY]
    precache_model ("progs/gib1.mdl");
    precache_model ("progs/gib2.mdl");
    precache_model ("progs/gib3.mdl");
    precache_model ("progs/h_player.mdl");
	self.headmdl = "progs/h_player.mdl";
    precache_sound("zerstorer/gibfnt/gf_sprt1.wav");
    precache_sound("zerstorer/gibfnt/gf_sprt2.wav");
    precache_sound("zerstorer/gibfnt/gf_plop.wav");
    precache_sound("zerstorer/gibfnt/gf_sbig.wav");
    if (!self.wait) self.wait = 2;
    self.nextthink  = time + (random() * self.wait);
    self.think = gibs_fly;
    if (!self.speed) self.speed = 1000;
    if (!self.dmg) self.dmg = 5;
    if (!self.delay) self.delay = 0.5;
	self.classtype = CT_MISCGIBF;
    if (self.targetname) {
        self.lefty = self.spawnflags & 4;
        if (self.spawnflags & ENT_STARTOFF) {
            self.nextthink = 0;     // Start off.
			self.think = SUB_Null;
		}
        self.use = gibft_use;
    }
};

//  Big Bell

// ATTN_NORM, which equals 1, has a maximum range of 1000.  ATTN_NONE, which equals 0, is heard at full volume anywhere.  The bell
// should be heard much further away than a distance of 1000, yet shouldn't be heard at full volume everywhere.  Armagon uses attenuation of 0.5,
// which lets him be heard up to a distance of 2000.  Since the bell should be heard up to at least 4000, use 0.25.  For up to 8000, use 0.125.
// This animates the bell.  Hexen2 bell frames:  <ringA: 0-30>, <ringB: 31-51>.
void() bell_ring = [ 0, bell_ring ] { // [FUNCTION]
    self.walkframe = self.walkframe + 1;
    if (self.walkframe >= self.waitmax) { // Done ringing and animating.
        self.frame = self.walkframe = 0;
        self.think = SUB_Null;
        return;
    }

    self.frame = self.waitmin + self.walkframe;
    if (self.waitmin) return; // Not using ringing anim if TRUE.

    if ((self.frame == 2) || (self.frame == 7) || (self.frame == 11)) sound(self,CHAN_AUTO,"drake/misc/bellring.wav", 1, 0.2); // Big bell should be heard from long distance, see attenuation note above.
};

// Self-explanatory -- called when bell gets used.
void() bell_use = { // [FUNCTION]
    if (self.frame && self.frame <= 12) return; // Already ringing.

    self.walkframe = 0;
    self.waitmin = 0;
	self.waitmax = 30;
    bell_ring();
};

// Called when bell takes a big hit.
void() bell_bighit = { // [FUNCTION]
    self.takedamage = DAMAGE_YES;
    self.health = self.max_health;      // Reset for the next hit.
    bell_use();
};

// Called when bell takes a small hit.
void(entity inflictor, entity attacker, float damage) bell_hit = { // [FUNCTION]
    self.health = self.max_health;      // Reset for the next hit.
    if (damage < 20) { // Small hit.
        if (self.frame && self.frame < 47) return; // Too much momemtum to overcome.

        self.walkframe = 10;
    } else { // Medium hit.
        if (self.frame && self.frame < 18) return; // Bell still ringing from use.
        if (self.frame >= 31 && self.frame < 41) return; // Bell still has extra momemtum.

        self.walkframe = 0;
    }
    self.waitmin = 31;  self.waitmax = 21;
    bell_ring();
};

// --> QUAKED misc_bell (0 .5 .8) (-64 -64 -80) (64 64 88)
// Huge bell.  Use in belltowers.
// This is a modified Hexen2 bell.  The model was shifted upward
// by 112 pixels.
// In Hexen2, bell has a hull from '-100 -100 -210' to '100 100 8'.
void() misc_bell = { // [ENTITY]
    precache_model("progs/drake/bellring.mdl");
	setmodel(self,"progs/drake/bellring.mdl");
    precache_sound("drake/misc/bellring.wav");
    setsize (self, '-64 -64 -80', '64 64 88');
    self.movetype   = MOVETYPE_NONE;
    self.velocity   = '0 0 0';
    self.touch      = SUB_Null;
    self.solid      = SOLID_BBOX;
    self.use        = bell_use;
    self.th_pain    = bell_hit;
    self.th_die     = bell_bighit;
    self.frame      = 0;
    self.max_health = self.health   = 200;
    self.takedamage = DAMAGE_YES;
};

// Plants the object on the floor.  I had removed this at one point but it breaks too many maps, restored. -Qmaster
void() PlaceDecor = { // [FUNCTION]
    self.solid      = SOLID_BBOX;
    self.movetype   = MOVETYPE_TOSS;    
    self.velocity   = '0 0 0';
	self.oldorigin = self.origin;
    self.origin_z   = self.origin_z + 1;    // Other items used +6.
    if (!droptofloor ()) {
		dprint(self.classname);
		dprint(" could not fall to floor, staying put inside something else at ");
		dprint(vtos(self.origin)); 
		dprint("\n");
        self.origin = self.oldorigin;
    }
};

// Miscellaneous solid object that just sits there.
void() misc_decor = { // [ENTITY]
    if (!self.mdl) { // Default to Zerstorer tree.
        self.mdl = "progs/drake/tree_zer.mdl";
        self.pos1 = VEC_ITEM_MIN;
        self.pos2 = '16 16 86';
    }
	precache_model(self.mdl);
	setmodel(self,self.mdl);
    setsize(self,self.pos1,self.pos2);
    self.nextthink  = time + 0.2;   // items start after other solids
    self.think = PlaceDecor;
};

void(float loop, float dm) statue_pieces = { // [FUNCTION]
    local   float   hp;

// PM:  Use Drake gib functions so that carnivores can't eat tree splinters.
    hp = self.health;
    self.health = dm;   // So the rocks have some velocity.
    sound(self,CHAN_AUTO,"drake/misc/wallbrk.wav",1,ATTN_NORM);
    do {
        if (random() < 0.5) ThrowGib(11, 1); // gib1mdl  ThrowTreeChunks ("progs/drake/imp_rock.mdl");
        else ThrowGib(12, 1); // gib2mdl ThrowTreeChunks ("progs/drake/st_gib3.mdl");

        loop = loop - 1;
    } while (loop > 0);
    self.health = hp;
};

void() statue_crumble = { // [FUNCTION]
    monster_death_use();
    statue_pieces (8, self.health);
	setmodel(self, "progs/null.spr");
    self.nextthink = time + 0.1; // PM:  Don't remove self now because we may be in the middle of a damage chain, such as one made by T_RadiusDamage.
    self.think = SUB_Remove; 
    self.solid = SOLID_NOT;
    self.takedamage = DAMAGE_NO;
};

// If a client stands on a statue, smash it.  Stops client from using
// the statue as a platform to reach places he shouldn't yet.
void() crumble_check = { // [FUNCTION]
    if (other.flags & FLx_CREATURE)
        if (other.movetype == MOVETYPE_WALK)
            if (other.health > 0)
//                if (other.absmin_z >= self.absmax_z)
                if (other.origin_z + other.mins_z >= self.origin_z + self.maxs_z) { // Crumble after touch loop.
                    self.touch = SUB_Null;
                    self.nextthink = time + 0.1;
                    self.think = statue_crumble;
                }
};

// A statue of the player.  Used in soeexit.bsp.
void() misc_statue = { // [ENTITY]
	local vector trig;
	local float vx, vy;

    if (world.model == "maps/soeexit.bsp") { // PM:  Replaced by bigger player model made for this purpose.
        self.mdl    = "progs/drake/hero.mdl";
        self.skin   = 0;
        self.frame  = 0;
        self.pos1   = '-32 -32 -24';
        self.pos2   = '32 32 80';
        //self.touch  = barrel_touch;     // Walk on statue.
    } else { // Default to angel statue.  Since the model is rectangular, calculate the bbox dimensions.
        trig = CoSine(self.angles_y);
        vx = fabs(16 * trig_x) & 31 + 32;
        vy = fabs(16 * trig_y) & 31 + 32;
        self.mdl    = "progs/drake/anglstat.mdl";
        self.skin   = 0;
        self.frame  = 0;
        self.pos1_x = 0 - vx;
        self.pos1_y = 0 - vy;
        self.pos1_z = 0;
        self.pos2_x = vx;
        self.pos2_y = vy;
        self.pos2_z = 120;
        self.touch  = crumble_check;
		self.gib1mdl = "progs/drake/imp_rock.mdl";
        precache_model (self.gib1mdl);
		self.gib2mdl = "progs/drake/st_gib3.mdl";
        precache_model (self.gib2mdl);
        precache_sound("drake/misc/wallbrk.wav");
    }
	self.gibtype = GIBTYPE_STONE;
    misc_decor();
};

// A statue of Hexen2's praying angel.  For Arcanum.
void() misc_statue_angel = { misc_statue(); }; // [ENTITY], Redirect

void(entity inflictor, entity attacker, float damage) tree_pain = { // [FUNCTION]
    if (self.pain_finished > time) return;

    sound(self,CHAN_VOICE, "drake/misc/met2wd.wav",1,ATTN_NORM);
    self.pain_finished = time + 0.1;    //2;
};

void() tree_die = { // [FUNCTION]
    monster_death_use();
    sound(self,CHAN_VOICE, "drake/misc/woodbrk.wav",1,ATTN_NORM);
    if (self.health > -50) self.health = -50;  // So gibs have some velocity.
	ThrowGib(11, 1); // gib1mdl
	ThrowGib(12, 1); // gib2mdl
	ThrowGib(13, 1); // gib3mdl
	ThrowGib(25, 1); // headmdl
	setmodel(self, "progs/null.spr");
    self.nextthink = time + 0.1;
    self.think = SUB_Remove; // PM:  Don't remove self now because we may be in the middle of a damage chain, such as one made by T_RadiusDamage.
    self.solid = SOLID_NOT;
    self.takedamage = DAMAGE_NO;
};

void() misc_tree = { // [ENTITY]
    self.cnt = floor(self.cnt);
    if ((self.cnt < 0) || (self.cnt > 3)) self.cnt = 0;

    if (!self.cnt) {
        self.mdl = "progs/drake/tree.mdl";
        self.pos1 = '-16 -16 0';
        self.pos2 = '16 16 128';
    } else {
        self.mdl = "progs/drake/tree_zer.mdl";
        self.pos1 = '-16 -16 0';
        self.pos2 = '16 16 86';
        if (self.cnt == 2) self.skin = 1;
    }

    if (self.spawnflags & 1) {
        if (!self.health) self.health = 200;
        self.max_health = self.health;
        self.th_pain = tree_pain;
        self.th_die  = tree_die;
        self.takedamage = DAMAGE_YES;   // PM:  Don't use damage_aim.
		self.gib1mdl = "progs/custents/rubble1.mdl";
        precache_model (self.gib1mdl);
		self.gib2mdl = "progs/custents/rubble2.mdl";
        precache_model (self.gib2mdl);
		self.gib3mdl = "progs/custents/rubble3.mdl";
        precache_model (self.gib3mdl);
		self.headmdl = "progs/drake/rubble4.mdl";
        precache_model (self.headmdl);
        precache_sound("drake/misc/met2wd.wav");
        precache_sound("drake/misc/woodbrk.wav");
        self.bloodtype = 17;    // Roughly tree sap color.
    } else self.takedamage = DAMAGE_NO;

	self.gibtype = GIBTYPE_WOOD;
    misc_decor();
};

void() misc_spikes_touch = {
    if (!other.takedamage) return; // Can't kill me.
    if (other.health < 1) return;     // Already dead.
    if ((other.origin_z + other.mins_z) < (self.origin_z + self.maxs_z)) return; // Below spikes.

    sound (self, CHAN_WEAPON, "drake/bane/hit.wav", 1, ATTN_NORM);
    if (self.dmg == 1000) self.dmg = other.health;
    T_Damage(other,self,self,self.dmg,DAMARMOR); // Squish!
};

// --> QUAKED misc_spikes (0 .5 .8) (-32 -32 0) (32 32 48)
// Spikes for roman start map.  (Which I built!)
// Custom made to avoid placing lots of thin
// brushes which can greatly increase vis times
// (and maybe r_speeds for that matter).
void() misc_spikes = {
    self.solid      = SOLID_BBOX;
    self.movetype   = MOVETYPE_NONE;
    precache_model("progs/drake/spikes32.mdl");
    precache_sound("drake/bane/hit.wav");
    self.takedamage = DAMAGE_NO;
    self.classname  = "spikes";
    self.touch      = misc_spikes_touch;
    if (self.dmg == 0) self.dmg = 1000;
    if (self.dmg < 0) {
        self.dmg = 0;
        self.touch = SUB_Null;
        self.solid = SOLID_NOT;
    }
    setall (self, "progs/drake/spikes32.mdl", '-32 -32 0', '32 32 48', self.origin);
    self.oldorigin = self.origin;
    self.origin_z   = self.origin_z + 2;
    if (self.deathstring == "") self.deathstring = " was impaled on spikes";
    if (!droptofloor()) {
        dprint(self.classname); dprint(" would fall out of level at ");
        dprint(vtos(self.origin)); dprint(", left in place\n");
        setorigin(self,self.oldorigin);
    }
};

//  Wanted Poster -- nsoe1+2.
// Death anim for the poster, which is a simple fade away.
void() wanted_fade = { // [FUNCTION]
    if (self.alpha <= self.cnt) {SUB_Remove();  return;}
    if (self.burning) particle(self.origin, '0 0 100', 1, 50);
    self.nextthink = time + 0.1;
    self.think = wanted_fade;
    self.alpha = self.alpha - self.cnt;
};

// Called when poster is destroyed.
void() wanted_die = {
    if (self.alpha <= self.cnt) { // Cannot remove now in case we are in a .chain loop.
        self.nextthink  = time + 0.1;
        self.think      = SUB_Remove;
    } else { // Kill it.
        self.takedamage = DAMAGE_NO;
        wanted_fade();
    }
};

void() wanted_touch = { // Added so it can go up in smoke.  -Qmaster
    if (!other) return;
    if (!(other.flags & FLx_CREATURE)) return;
    if (self.pain_finished > time) return;

    self.pain_finished = time + 0.2;
    if (other.burning && !InLiquid(self.origin)) {
        sound(self,CHAN_AUTO,"player/slimbrn2.wav",1,ATTN_NORM);
        self.burning = TRUE;
        particle(self.origin, '0 0 100', 1, 50);
        T_Damage(self,other,other,random() * 2,DAMARMOR);
    }
};

//============
// --> QUAKED misc_wanted (0 1 0) (-8 -8 -8) (8 8 8)
// Places a wanted poster on a wall.  Otherwise, same as Hip's wallsprite.
// Angles should be opposite of face.
//
// Update:  Wanted poster can be destroyed.
//============
void() misc_wanted = {
    if (!self.model) self.model = "progs/drake/wanted.mdl";
    precache_model(self.model);
    setmodel(self,self.model);
    SetSelfAnglesUpDown();
    makevectors (self.angles);
    setorigin (self, self.origin - ( v_forward * 0.2 ) ); // Pull the sprite away from the wall slightly to get rid of z sort errors.
    if (self.health < 1) self.health = 10;
    if (self.health) {
        self.alpha      = 1;
        self.cnt        = 0.15; // Was 0.25, made slower. -Qmaster
        self.solid      = SOLID_TRIGGER;
        self.touch      = wanted_touch;
        self.movetype   = MOVETYPE_NONE;
        self.takedamage = DAMAGE_YES;
        self.health     = 10;
        self.th_die     = wanted_die;
    } else makestatic(self);
};
