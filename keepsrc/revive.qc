//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
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
// Function count: 5
//
// Implements: Enemy Revive System
//
// Description:
// Provides means for reviving dead monsters.  Normally used by magical bosses.
//
// Provides a way for players to revive denizens using Mjolnir in a similar
// manner that one would use the Shadow Axe to gib corpses and fallen zombies.
//=============================================================================

void(entity targ, entity charmmaster) ApplyHornCharm;
void(entity ent) monster_reset_movement_type;
void(entity ent) monster_reset_runtime_attributes;
void(string mname) BeMonsterFromString;
void() BeMonsterFromClassname;

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

void() ai_ritual = { // [FUNCTION]
    local entity temp;

    if (self.fallen) {
        temp = self.enemy;
        self.enemy = self.fallen;
        ai_face();
        self.enemy = temp;
    }
};

// 'ent' = entity to be resurrected, 'god' = the one resurrecting ent.
float(entity ent, entity god) monster_revive = { // [FUNCTION]
    local float good;

	if (intermission_running > 0) return FALSE;
	if (!ent) return FALSE; // Must be an entity!
	if (ent == world) return FALSE; // Can't revive the world.
	if (!god) return FALSE; // The world isn't magical.  Only entities can revive stuff. 
	if ((god.flags & FL_MONSTER) && (ent.classgroup == CG_HARMLESS || ent.alignment == NEUTRAL)) return FALSE; // Only player can save denizens.
    if ((god.flags & FL_MONSTER) && (Align_Opposing(ent,god) || IsInsane(god))) return FALSE; // Monsters only revive friendlies, unless insane.  Players will convert them to their side.
	if (pointcontents(ent.origin) == CONTENT_SOLID) {
		ent.origin = ent.origin + '0 0 4';
		if (pointcontents(ent.origin) == CONTENT_SOLID) {
			ent.origin = ent.origin + '0 0 4';
			if (pointcontents(ent.origin) == CONTENT_SOLID) return FALSE; // Welp, we tried
		}
	}

	if (InSky(ent.origin)) { entity_remove(ent, 0.1); return FALSE; }
    if (!(ent.flags & FL_MONSTER) || ent.health > 0 || (ent.gorging && !ent.gibbed)
		|| ent.touchedvoid
		|| (god == ent)) { // No self-ressurecting; only Jesus can do that 
						   // because he is God.

		return FALSE;
	}

	// Ok do the revive now, all good to go here.
	if ((god.flags & FL_CLIENT)) { // Player is reviving the target.
		ent.enemy = ent.oldenemy = world; // Whoever player can revive forgets.
		if (ent.alignment == EVIL) ent.alignment = god.alignment;
	} else { // A plain old map entity or a monster is reviving a monster.
		if (god.oldenemy == ent) god.oldenemy = world; // Prevent repeat infighting.
		if (god.enemy == ent) {
			// Switch to oldenemy (could be world) to prevent repeat infighting.
			// Yeah I already killed you.  We're good bro.
			if (god.goalentity == ent) god.goalentity = god.oldenemy;
			god.enemy = god.oldenemy;
		}
		if (IsInsane(god) && !Align_Match(ent,god)) {
			// Ressurected good are smart enough to realize they still hate
			// their ressurector, who would only have ressurected an opposing
			// monster if they were insane.
			ent.enemy = ent.movetarget = ent.goalentity = god;
		} else {
			// Reset all enemy dependant fields.
			ent.enemy = ent.movetarget = ent.goalentity = god.oldenemy;
		}

		if (ent.enemy) ent.search_time = time + 5;
		else ent.search_time = time + 3;
	}

	if (ent.alignment == NEUTRAL || ent.classgroup == CG_HARMLESS) {
		// Woot!  One step closer to Thor's Blessing!
		killed_denizens = killed_denizens - 1; 
	} else { // Ahh, nasty reviver hurting my stats!
		killed_monsters = killed_monsters - 1;
	}

	ent.master = god;
	if (ent.distmin == 0) ent.distmin = 0;
	if (ent.distmax == 0) ent.distmax = 256;
	particle(ent.origin + vecrand(0,4,16),'0 0 100',9,15); // Magical particles...
	particle(ent.origin + vecrand(0,4,16),'0 0 100',41,15); // ...indicate this is unusual.
	update_hud_totals(HUD_MONSTERS);
	sound(ent,CHAN_AUTO,"drake/misc/dsslop.wav",1,ATTN_NORM); // Play classic arch-vile resurrection sound.
	ent.pain_finished  = time + 3;  // Don't interrupt ressurection reanimation.
	clear_trigstrs(ent); // Sever all targeting links.
	ent.use = SUB_Null;
	monster_reset_movement_type(ent);
	ent.deadflag = DEAD_NO;
	ent.bodyonflr = "";
	ent.velocity = '0 0 0'; // Make sure stationary
	monster_reset_runtime_attributes(ent);
	if (ent.max_health < 1) ent.max_health = 1; // Have at least some health!
	ent.health = ent.max_health;
	ent.ideal_yaw = ent.angles * '0 1 0';
	ent.lastorigin = ent.origin;
	if (ent.th_revive) ent.th_spawn = ent.th_revive;
	if (ent.gibbed) ent.th_spawn = BeMonsterFromClassname;
	ent.walkframe = ent.frame;
	if (ent.frame < ent.reviveframestart) ent.reviveframestart = ent.frame;
	ent.height = ent.view_ofs_z;
	ent.distmin = 4;
	ent.distmax = 80;
	if (ent.alignment == NEUTRAL) ent.enemy = ent.oldenemy = world;
	ent.think = SUB_FindRandomSpawnSpot;
	ent.nextthink = time + 0.1;
    return TRUE;
};

// Checks if monster should stop to revive a fallen monster.  Success initiates resurrection.
float(float d) ai_medic = { // [FUNCTION]
    local entity head, goal;
    local float hp;

    hp = 0;	// HACK:  Bane -- Don't revive things with too much hp.  Update:  At least until after Bane clones himself.
    if (self.classname == "monster_bane" && self.waitmin) hp = 300; // This is zero after Bane spawns clones.
    goal = self.goalentity;
    head = nextent(world);
    while (head) {
        if (head.flags & FL_MONSTER || head.classtype == CT_TEMPGIB) {
			if (head.deadflag == DEAD_DEAD || head.health <= 0) {
				if ((/*Align_NonHostile(self,head)*/head.alignment == NEUTRAL && (self.flags & FL_CLIENT))
					|| ((!hp || hp <= head.max_health) && !(self.flags & FL_CLIENT))) {

					self.goalentity = head; // QC_CloseEnough checks against goalentity.
					if (QC_CloseEnough(d)) {
						if (monster_revive(head,self)) {
							if ((self.flags & FL_MONSTER)) {
								self.fallen = head;
								//self.goalentity = goal;
							}
							return TRUE;
						}
					}
				}
			}
		}
        head = nextent(head);
    }
    self.fallen = world;
    self.goalentity = goal;
    return FALSE;
};
