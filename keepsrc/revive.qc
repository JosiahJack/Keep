//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Drake by Patrick Martin
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
// Entity count: 0
// Function count: 6
//
// Implements: Enemy Revive System
//
// Description:
// Provides means for reviving dead monsters.  Normally used by magical bosses.
//=============================================================================

void(entity targ, entity charmmaster) ApplyHornCharm;
void() monster_reset_movement_type;
void() monster_reset_runtime_attributes;
void(string mname) BeMonsterFromString;

// To be called after revive animation is completed to restore takedamage.
float() monster_revive_finish = { // [FUNCTION]
	if (self.bouncegrenade) self.takedamage = DAMAGE_YES; // Should grenades bounce off the body?
	else self.takedamage = DAMAGE_AIM;			// Can receive damage

	if (pointcontents(self.origin) == CONTENT_SOLID) {
		self.health = self.gibhealth; // Time to die!
		Killed(self,self);
		return FALSE;
	}
	if (self.classmove == MON_MOVEFLY) {
		self.flags = (self.flags - (self.flags & FL_ONGROUND)) | FL_FLY;
	}
	particle(self.origin,VEC_ORIGIN,9,25);
	particle(self.origin,VEC_ORIGIN,41,30);
	//FoundHuntTarget(TRUE); // Setup goals and warn other monsters
	return TRUE;
};

void() revive_frames = { // [FUNCTION]
	self.nextthink = time + 0.1;
	self.think = revive_frames;
	self.walkframe = SUB_ClampFloat(self.walkframe - 1,self.reviveframeend,self.reviveframestart);
	self.frame = self.walkframe; // Revive is death in reverse!
	particle(self.origin + vecrand(0,4,16),'0 0 100',9,15); // Magical particles...
	particle(self.origin + vecrand(0,4,16),'0 0 100',41,15); // ...indicate this is unusual.
	if (self.enemy) ai_face();
	if (self.frame <= self.reviveframeend) {
		monster_revive_finish();
		if (self.classmove != MON_MOVESTATIC) {
			if (self.enemy) self.th_run();
			else if (self.charmer) self.th_walk();
			else self.th_stand();
		} else self.th_stand();
	}
};

float() SelfHasRoom = {
	local vector v1, v2; // Used to preserve before setsize call.

	if (self.maxs_x != self.bbmaxs_x) {
		v1 = self.mins;
		v2 = self.maxs;
		setsize(self,self.bbmins,self.bbmaxs);
		if (walkmove(0,0)) return TRUE;
		setsize(self,v1,v2);
	} else {
		if (walkmove(0,0)) return TRUE;
	}
	return FALSE;
};

void() revive_gibbed = { // [FUNCTION]
	local float dist, spd;
	local vector dir;

	if (check_skycontent(self.origin)) { entity_remove(self, 0.1); return;}
	if (self.touchedvoid) return;	

	dist = vlen(self.pos1 - self.origin);
	if (dist < 32 || self.attack_finished < time) {
		setorigin(self,self.pos1); // Put back at spot.
		self.velocity = 0;
		if (SelfHasRoom()) {
			particle(self.origin + vecrand(0,4,16),'0 0 100',9,15); // Magical particles...
			particle(self.origin + vecrand(0,4,16),'0 0 100',41,15); // ...indicate this is unusual.
			setsize(self,self.bbmins,self.bbmaxs);
			BeMonsterFromString(self.classname);
			self.think = SUB_Remove;
			self.nextthink = time + 0.1;
			return;
		}
	}
	self.touch = SUB_Null;
	dir = vectoangles(self.pos1 - self.origin);
	dir = normalize(dir);
	if (dist > 512) spd = SUB_ClampFloat(self.speed,150,self.speed);
	else if (dist < 128) spd = SUB_ClampFloat(self.speed * 0.8,25,self.speed);
	else spd = SUB_ClampFloat(self.speed,75,self.speed);
	self.velocity = dir * spd;
	self.think = revive_gibbed;
	self.nextthink = time + 0.1;
};

void() ai_ritual = { // [FUNCTION]
    local entity temp;

    if (self.fallen) {
        temp = self.enemy;
        self.enemy = self.fallen;
        ai_face();
        self.enemy = temp;
    }
};

// Checks if 'self' can be raised from the dead.
// Must use self because this requires a walkmove to ensure area is clear to become solid.
// Called by 'monster_revive'.
// Note:  findradius may be safe to use, since it is useless for detecting
// entities with SOLID_NOT, barring DarkPlaces engine.
float() CanSelfRevive = { // [FUNCTION]
	if (self.gibbed) return FALSE; // Need a body!
	if (!self.th_revive) return FALSE; // Only if there is a legitimate revive animation.
	if (!(self.flags & FL_MONSTER)) return FALSE; // Only revive monsters.  Players have their own thing for coop but naught else.
	if (self.health > 0) return FALSE; // Only revive the dead!
	if (self.gorging) return FALSE; // Don't revive monsters who are being eaten by gremlins currently.
	if (self.touchedvoid) return FALSE;
	if (check_skycontent(self.origin)) { entity_remove(self, 0.1); return FALSE;}

    if (self.modelindex) {
		return SelfHasRoom();
	}
    return FALSE;
};

// 'ent' = entity to be resurrected, 'god' = the one resurrecting ent.
// Note:  'CanSelfRevive' always returns FALSE, if ent == world.
float(entity ent, entity god) monster_revive = { // [FUNCTION]
    local entity os;
    local float good;

	if (frame_pause()) return FALSE;
	if (!ent) return FALSE; // Can't revive the world.
	if (!god) return FALSE; // The world isn't magical.  Only entities can revive stuff. 
	if ((god.flags & FL_MONSTER) && (ent.classgroup == CG_HARMLESS || ent.alignment == NEUTRAL)) return FALSE; // Only player can save denizens.
    if ((god.flags & FL_MONSTER) && Align_Opposing(ent,god) && !IsInsane(god)) return FALSE; // Monsters only revive friendlies, unless insane.  Players will convert them to their side.
	if (pointcontents(ent.origin) == CONTENT_SOLID) { 
		ent.origin = ent.origin + '0 0 4';
		if (pointcontents(ent.origin) == CONTENT_SOLID) return FALSE;
	}

    os = self;
    self = ent;
    if ((god == ent) && !CanSelfRevive()) { self = os; return FALSE; } // No self-ressurecting; only Jesus can do that.

	// Ok do the revive now, all good to go here.
	if ((god.flags & FL_CLIENT)) { // Player is reviving the target.
		if (((self.enemy == god && self.classgroup == CG_HARMLESS) || Align_Match(self.enemy,god)) || self.enemy.health < 1) self.enemy = self.oldenemy = world; // Good monsters remember their enemy.
		killed_denizens = killed_denizens - 1; // Woot woot!  One step closer to Thor's Blessing!
	} else { // A plain old map entity or a monster is reviving a monster.
		if (god.oldenemy == self) god.oldenemy = world; // Prevent repeat infighting.
		if (god.enemy == self) { // Switch to oldenemy (could be world) to prevent repeat infighting.  Yeah I already killed you.  We're good bro.
			if (god.goalentity == self) god.goalentity = god.oldenemy;
			god.enemy = god.oldenemy;
		}
		if (IsInsane(god) && !Align_Match(self,god)) self.enemy = self.movetarget = self.goalentity = god; // Ressurected good are smart enough to realize they still hate their ressurector, who would only have ressurected an opposing monster if they were insane.
		else self.enemy = self.movetarget = self.goalentity = god.oldenemy; // Reset all enemy dependant fields.
		if (self.enemy) self.search_time = time + 5;
		else self.search_time = time + 3;

		killed_monsters = killed_monsters - 1; // Ahh, nasty reviver hurting my stats!
	}
	update_hud_totals(HUD_MONSTERS);
	sound(self, CHAN_AUTO, "drake/misc/dsslop.wav", 1, ATTN_NORM); // Play classic arch-vile resurrection sound.
	self.pain_finished  = time + 3;  // Don't interrupt ressurection reanimation.
	clear_trigstrs(self); // Sever all targeting links.
	self.use = SUB_Null;
	self.solid = SOLID_SLIDEBOX; // Restore physical properties then re-animate.
	self.lastorigin = self.origin; // Save origin for cinematic camera angle interpolation
	monster_reset_movement_type();
	self.deadflag = DEAD_NO;
	self.velocity = '0 0 0'; // Make sure stationary
	monster_reset_runtime_attributes();
	if (self.max_health < 30) self.max_health = 30; // Have at least some health!
	self.health = self.max_health;
	self.ideal_yaw = self.angles * '0 1 0';

	// Reset size in case it was changed by crushing brushes and the like.
	// Calling setsize or setorigin also updates the solid change now,
	// which without it, a solid change could get delayed until the
	// next frame.  A delayed solid change may allow another monster
	// to fuse with self and both will get stuck -- not good.
	if (self.gibbed) {
		self.think = revive_gibbed;
		self.attack_finished = time + 10; // Maximum time to try to return before we poof there.
	} else {
		setsize(self,self.bbmins,self.bbmaxs);
		self.think = self.th_revive;
		self.walkframe = self.frame;
		if (self.frame < self.reviveframestart) self.reviveframestart = self.frame;
	}
	self.nextthink = time + 0.1;
    self = os;
    return TRUE;
};

// Checks if monster should stop to revive a fallen monster.  Success initiates resurrection.
float(float d) ai_medic = { // [FUNCTION]
    local entity head, goal;
    local float hp;

    hp = 0;	// HACK:  Bane -- Don't revive things with too much hp.  Update:  At least until after Bane clones himself.
    if (self.classname == "monster_bane" && self.waitmin) hp = 300; // This is zero after Bane spawns clones.
    goal = self.goalentity;
    head = nextent (world);
    while (head) {
        if (head.flags & FL_MONSTER)
        if (head.deadflag == DEAD_DEAD || head.health <= 0)
		if (!head.gibbed) // Disabled gib regathering for now, too many issues.
		if ((Align_NonHostile(self,head) && (self.flags & FL_CLIENT))
            || (!hp || hp <= head.max_health || (self.flags & FL_CLIENT))) {
            self.goalentity = head; // QC_CloseEnough checks against goalentity.
            if (QC_CloseEnough(d)) {
                if (monster_revive(head,self)) {
					if ((self.flags & FL_MONSTER)) {
						self.fallen = head;
						self.goalentity = goal;
					}
					return TRUE;
                }
            }
        }
        head = nextent(head);
    }
    self.fallen = world;
    self.goalentity = goal;
    return FALSE;
};
