//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: All, though primarily Arcane Dimensions (AD)
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
// Function count: 12
//
// Implements: Projectile Touches
//
// Description:
// Generic functions handling what happens when projectiles touch something,
// typically exploding.
//=============================================================================

void(entity targ, float playdmg, float mondmg) ApplyFireDmg;

void() Touch_Bullet = { // [FUNCTION]
	if (self.touchedvoid) return;				// Marked for removal
	if (check_skycontent(self.origin)) {entity_remove(self, 0.1); return;}
	if (other == self.owner) return;			// Touching self, do nothing
	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing
	if (self.waitmin > time) return;			// bullet touch has been disabled

	entity_remove(self, 1);						// Setup bullet for removal	

	if (other.takedamage) {
		// Hit monster/interactive object, impact blood
		// Due to how difficult projectile shotguns were to hit things, an extra +4 damage (dead center tracer) was added to help AD's particle shotguns.
		// In AD 1.7+ the bullet projectiles are now using wide impact against monsters which means more pellets will hit.  The extra is no longer required.
		if (self.classtype == CT_PROJ_TRACEPART) self.dmg = 0;
		else if (self.classtype == CT_PROJ_TRACE) self.dmg = 0;
		else self.dmg = DAMAGE_PSHELL; // Default shell pellet damage
		
		// Check for breakable/pushable no monster damage
		if (ai_immunebreakable(self.owner, other)) {
			self.dmg = 0;
			Tent_Point(TE_GUNSHOT,self.origin);
		} else if (other.resist_shells > 0) Resist_Effects(other,self.origin,self.velocity,self.dmg,AM_SHELLS,other.pain_sound,""); // Show bullet resistance as small blood+gunshot+smoke
		else {
			if (other.flags & FL_MONSTER) spawn_touchblood (self, other, self.dmg*2); // Hitting monsters does twice the amount of blood effects
			else spawn_touchblood (self, other, self.dmg);
		}
		
		if (self.dmg > 0) T_Damage (other, self, self.owner, self.dmg, DAMARMOR); // Don't bother with damage if there is none!
	} else {
		// Hit world/static object, impact particles.
		if (self.classtype == CT_PROJ_TRACE || self.classtype == CT_PROJ_MCOR2) { // NG tink sound or SG ricochet sound.
			self.lip = random();
			if (self.lip < 0.5) sound(self, CHAN_VOICE, "weapons/tink1.wav", random()*0.5, ATTN_LOW);
			else if (self.lip < 0.7) sound(self, CHAN_VOICE, "weapons/ric2.wav", random()*0.5, ATTN_LOW);
			else sound(self, CHAN_VOICE, "weapons/ric3.wav", random()*0.5, ATTN_LOW);
		} else {
			Tent_Point(TE_GUNSHOT,self.origin);
		}
	}
};

void() Touch_PlasmaProjectile = { // [FUNCTION]
	local vector org, vec, dir;
	local entity tself;

	if (check_skycontent(self.origin)) {entity_remove(self, 0.1); return;}
	if (self.touchedvoid) return;				// Marked for removal
	if (other == self.owner) return;			// Touching self, do nothing
	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing
	if (self.waitmin > time) return;			// plasma touch has been disabled

	if (self.owner.flags & FL_CLIENT) self.pos1 = DAMAGE_PGPLAYER; // Default damage for plasma (override on worldspawn)
	else if (self.owner.classtype == CT_MONGREMLIN) self.pos1 = DAMAGE_PGGREMLIN;
	else if (self.classtype == CT_REFLECTLIGHT) self.pos1 = DAMAGE_PGREFLECT; // Default damage for all monsters
	else if (self.classtype == CT_REFLECTPLASMA) self.pos1 = DAMAGE_PGREFLECT;
	else if (self.classtype == CT_SUMMONLIGHT) self.pos1 = DAMAGE_PGSUMMON;
	else if (self.classtype == CT_MONMINOTAUR) self.pos1 = DAMAGE_PGMINOTAUR;
	else if (self.classtype == CT_MONGAUNT) self.pos1 = DAMAGE_PGGAUNT;
	else if (self.classtype == CT_MONTURRETB) self.pos1 = DAMAGE_PGTURRETB;
	else if (self.owner.classtype == CT_MONNOUR) self.pos1 = DAMAGE_PGNOUR;
	else if (self.classtype == CT_MONFLOYD) self.pos1 = DAMAGE_PGFLOYD;
	else if (self.classtype == CT_MONDEFLECTOR) self.pos1 = DAMAGE_PGDEFLECT;
	else self.pos1 = DAMAGE_PLASMA;

	if (ai_immunebreakable(self.owner, other)) self.pos1 = '0 0 0'; // Check for breakable/pushable immunity first
	self.dmg = self.pos1_x + random()*self.pos1_y;
	if (self.pos1_z > 0) T_RadiusDamage (self, self.owner, self.pos1_z, world, DAMAGEALL); // Plasma Splashdamage affects everything, check for 0 dmg first.  This can also apply a poisonous debuff from the attacker.
	if (other.takedamage) { // Hit monster/interactive object, impact blood
		if (ai_immunebreakable(self.owner, other)) { // Check for breakable/pushable no monster damage
			SpawnExplosion(EXPLODE_BURST_SMOKE, self.origin, SOUND_PLASMA_HIT); // Using a cut down version of ammo resistance
			SpawnProjectileSmoke(self.origin, 200, 50, 150);
			if (random() < 0.5) SpawnProjectileSmoke(self.origin, 200, 50, 250);
			if (random() < 0.5) SpawnProjectileSmoke(self.origin, 300, 50, 150);
		} else if (other.resist_cells > 0) Resist_Effects(other,self.origin,VEC_ORIGIN,0,AM_CELLS,other.pain_sound,SOUND_PLASMA_HIT);
		else if (other.resist_plasma > 0) Resist_Effects(other,self.origin,VEC_ORIGIN,0,AM_PLASMA,other.pain_sound,SOUND_PLASMA_HIT);
		else {
			if (other.flags & FL_MONSTER) spawn_touchblood (self, other, self.dmg*2); // Hitting monsters does twice the amount of blood effects
			else spawn_touchblood (self, other, self.dmg);

			if (self.poisonous) self.lip = EXPLODE_POISON_SMALL; // Switch poisonous to poison sprite, but keep plasma explosion,oOtherwise this sounds confusing with a rocket explosion.
			else {
				if (random() < 0.3) self.lip = EXPLODE_PLASMA_SMALL; // Randomly pick between Quoth electric and AD blue explosions.
				else self.lip = EXPLODE_ELECT_SMALL;
			}
			SpawnExplosion(self.lip, self.origin, SOUND_PLASMA_HIT);
		}

		if (other.classgroup == CG_ZOMBIE && !(other.classname == "monster_mummy")) self.dmg = DAMAGE_ZOMBIECLASS; // Plasma hits always kill any zombie (1 hit)
		if (self.dmg > 0) T_Damage (other, self, self.owner, self.dmg, DAMARMOR); // Don't bother with damage if there is none!
	} else {
		// Hit world/static object, impact particles
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION2); // New special coloured particle explosion (rogue expansion)
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
		WriteByte (MSG_BROADCAST, 35);
		WriteByte (MSG_BROADCAST, 8);
		if (self.poisonous) self.lip = EXPLODE_POISON_SMALL; // Poisonous sprite explosion instead
		else self.lip = EXPLODE_ELECT_SMALL; // Classic quoth electric impact explosion
		SpawnExplosion(self.lip, self.origin, SOUND_PLASMA_HIT);
	}

	// Check for any plasma reflection? (player only function)
	if (self.owner.flags & FL_CLIENT && other.reflectplasma) {
		org = self.origin;
		if (random() < 0.2 && self.owner) dir = normalize(self.owner.origin - org); // Random chance that plasma will reflect straight back
		else {
			vec = org + vecrand(0,1000,1); // Pick random location instead
			dir = normalize(vec - org);
		}
		tself = self;
		self = other; // Switch around self to make sure reflection happens once
		launch_projectile(org, dir, CT_REFLECTPLASMA, SPEED_REFLECTION);
		self = tself;
	}
	entity_remove(self, 1); // Remove plasma bolt
};

void() Touch_Projectile = { // [FUNCTION]
	local vector org, dir, vec;
	local float proj_type, proj_speed, old_armortype, old_armorvalue, old_armormask, olddmg;
	local entity tself, newent, stemp;
	
	if (self.touchedvoid) return;				// Marked for removal
	if (check_skycontent(self.origin)) {entity_remove(self, 0.1); return;}
	if (other == self.owner) return;			// no touching self
	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing

	self.touch = SUB_Null; // No more touch/world interaction
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	if (self.classtype == CT_PROJ_LASER) { //	Laser impact/stop sound (precached by owner)
		if (self.attack_ricochet > 0) sound (self, CHAN_WEAPON, SOUND_LASER_RIC, 1, ATTN_STATIC);
		else sound (self, CHAN_WEAPON, SOUND_LASER_HIT, 1, ATTN_STATIC);
	} else if (self.classtype == CT_PROJ_GROCK) { // Golem rock impact sound (precached by owner)
		self.lip = random();
		self.volume = 0.5 + random()*0.5;
		if (self.lip < 0.25) sound (self, CHAN_WEAPON, SOUND_IMP_ROCK1, self.volume, ATTN_BREAK);
		else if (self.lip < 0.5) sound (self, CHAN_WEAPON, SOUND_IMP_ROCK2, self.volume, ATTN_BREAK);
		else if (self.lip < 0.75) sound (self, CHAN_WEAPON, SOUND_IMP_ROCK3, self.volume, ATTN_BREAK);
		else sound (self, CHAN_WEAPON, SOUND_IMP_ROCK4, self.volume, ATTN_BREAK);
	}

	if (other.takedamage) { // Hit something that bleeds
		if (self.classtype == CT_PROJ_SNG) self.dmg = DAMAGE_SNGSPIKE; // SNG spikes are essentially double damage (cheap way of 2 x nails)
		else if (self.classtype == CT_PROJ_REFNG) self.dmg = DAMAGE_NGREFSPIKE; // Reflected nails (can only happen from the player)
		else if (self.classtype == CT_PROJ_REFLNG) self.dmg = DAMAGE_LNGREFSPIKE; // Reflected lava nails (can only happen from the player)
		else if (self.owner.classtype == CT_MONJIM) self.dmg = DAMAGE_BOBLASER + (random() * DAMAGE_BOBLASER); // Bob and enforcer lasers are different
		else if (self.classtype == CT_PROJ_LASER) self.dmg = DAMAGE_LASER;
		else if (self.classtype == CT_PROJ_RICLASER && self.dmg < DAMAGE_NGSPIKE) self.dmg = DAMAGE_NGSPIKE; // Minimum damage = spike after all the bouncing around
		else if (self.classtype == CT_PROJ_LAVANG) self.dmg = DAMAGE_LAVANGSPIKE;
		else if (self.classtype == CT_PROJ_LAVASNG) self.dmg = DAMAGE_LAVASNGSPIKE;
		else if (self.classtype == CT_PROJ_MCOR1) self.dmg = DAMAGE_MANTICORESPIKE + (random() * 5);
		else if (self.classtype == CT_PROJ_MCOR2) self.dmg = DAMAGE_MANTICORETHRON + random();
		else if (self.classtype == CT_PROJ_DARTARROW) self.dmg = DAMAGE_NGSPIKE;
		else if (self.classtype == CT_PROJ_BOLT1) { // Special damage and sound effects for crossbow knights
			if (random() < 0.3) sound (self, CHAN_WEAPON, "ad171/weapons/bolt_hit1.wav", 1, ATTN_NORM); // ting sound
			else sound (self, CHAN_WEAPON, "ad171/weapons/bolt_hit4.wav", 1, ATTN_NORM); // flesh wound
			if (other.classtype == self.owner.classtype) {
				self.dmg = DAMAGE_BOLT0; // Reduce damage if hit another dcrossbow knight.
			} else {
				if (self.owner.flags & FL_CLIENT) self.dmg = DAMAGE_BOLTPLAYER;
				else self.dmg = DAMAGE_BOLT1; // Set to standard monster damage.
			}
		} else if (self.classtype == CT_PROJ_BOLT2) {
			if (random() < 0.3) sound (self, CHAN_WEAPON, "ad171/weapons/bolt_hit1.wav", 1, ATTN_NORM); // ting sound
			else sound (self, CHAN_WEAPON, "ad171/weapons/bolt_hit4.wav", 1, ATTN_NORM); // flesh wound
			if (other.classtype == self.owner.classtype) {
				self.dmg = DAMAGE_BOLT0; // Reduce the damage if the bolt has hit another dcrossbow knight
			} else {
				if (self.owner.flags & FL_CLIENT) self.dmg = DAMAGE_BOLTPLAYERP;
				else self.dmg = DAMAGE_BOLT2; // Set to standard poisonous monster damage.
			}
		} else if (self.classtype == CT_PROJ_BLBOLT || self.classtype == CT_PROJ_BLBOLT2) self.dmg = DAMAGE_BOGLORD;
		else if (self.classtype == CT_PROJ_FLESH || self.classtype == CT_PROJ_FLESHP) {
			sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM); // Zombies have special impact sound
			self.dmg = DAMAGE_FLESH;
		} else if (self.classtype == CT_PROJ_SCORP) { // Scorpion spikes cannot hurt other spider types.  This is to prevent the minion scorpion killing other minions
			if (other.classgroup == self.owner.classgroup) self.dmg = 0;
			else self.dmg = DAMAGE_NGSPIKE;
		} else if (self.classtype == CT_PROJ_GROCK) { // Rock projectiles cannot hurt stone monsters!
			if (other.classgroup == self.owner.classgroup) self.dmg = 0;
			else self.dmg = DAMAGE_NGSPIKE;
		} else self.dmg = DAMAGE_NGSPIKE; // Default spike damage (nails)

		olddmg = self.dmg;
		if (ai_immunebreakable(self.owner, other)) { // Check for breakable/pushable monster immunity
			self.dmg = self.classgroup = 0; // Zero damage and make sure no resistance checks
			self.poisonous = FALSE; // Remove poisonous effect
			Tent_Point(TE_GUNSHOT,org);
			if (random() < 0.5) SpawnProjectileSmoke(self.origin, 200, 50, 150); // Show ammo resistance effect
		}

		if (self.poisonous == TRUE) PoisonDeBuff(other); // Check for poison debuff (using poisonous flag)

		// Check for NG/SNG nail resistance
		if (self.classgroup == CG_PROJNAILS && other.resist_nails > 0) {
			Resist_Effects(other,self.origin,VEC_ORIGIN,0,AM_NAILS,other.pain_sound,"");
			self.projeffect = 0;
			// Check for any nail reflection?
			if (other.reflectnails && random() < other.resist_nails) {
				org = self.origin;
				// Random chance that nail will reflect straight back
				if (random() < 0.2 && self.owner) 
					dir = normalize(self.owner.origin - org);
				else {
					// Pick random location instead
					// Flatten the Z axis so the reflection looks less random
					vec = vecrand(0,100,1);
					vec_z = random()*25;
					vec = vec + org;
					dir = normalize(vec - org);
				}
				// Switch around self to make sure reflection happens once
				tself = self; self = other;
				launch_projectile(org, dir, CT_PROJ_REFNG, SPEED_REFLECTION);
				self = tself;
			}
		}

		// Ignore armor for lava nails
		if (self.classtype == CT_PROJ_LAVANG || self.classtype == CT_PROJ_LAVASNG) {
			old_armortype = other.armortype;
			old_armorvalue = other.armorvalue;
			old_armormask = (other.items2 & ((IT2_ARMOR1 | IT2_ARMOR2) | IT2_ARMOR3));
			other.armortype = FALSE;
			other.armorvalue = FALSE;
			// Add fun fire effects 5% of the time.
			if (random() < 0.05 && other.resist_fire < 1) {
				newent = spawn();
				setorigin(newent,self.origin);
				stemp = self;
				self = newent;
				Ember_Shower(2);
				self.think      = SUB_Remove;
				self.nextthink  = time + 0.1;
				self = stemp;
				Burn_Add(other,self.owner,self.dmg);
			} else Resist_Effects(other,self.origin,VEC_ORIGIN,0,AM_LAVANAILS,other.pain_sound,"");
			
			// Check for any nail reflection?
			if (other.reflectnails && random() < other.resist_lava_nails) {
				org = self.origin;
				// Random chance that nail will reflect straight back
				if (random() < 0.2 && self.owner) 
					dir = normalize(self.owner.origin - org);
				else {
					// Pick random location instead
					// Flatten the Z axis so the reflection looks less random
					vec = vecrand(0,100,1);
					vec_z = random()*25;
					vec = vec + org;
					dir = normalize(vec - org);
				}
				// Switch around self to make sure reflection happens once
				tself = self; self = other;
				launch_projectile(org, dir, CT_PROJ_REFLNG, SPEED_REFLECTION);
				self = tself;
			}
			self.projeffect = 0;

			if (other.resist_fire > 0) self.dmg = self.dmg * (1 - other.resist_fire); // Change damage after applying burning for maximum burn life.

			// Check for any nail reflection?
			if (other.resist_fire >= 1 || ((random() < other.resist_lava_nails) || ((random() < other.resist_nails) && other.reflectnails))) {
				org = self.origin;
				if (random() < 0.2 && self.owner) dir = normalize(self.owner.origin - org); // Random chance that nail will reflect straight back.
				else { // Pick random location instead. 
					vec = vecrand(0,100,1);
					vec_z = random()*25; // Flatten the Z axis so the reflection looks less random.
					vec = vec + org;
					dir = normalize(vec - org);
				}
				tself = self;
				self = other; // Switch around self to make sure reflection happens once.
				launch_projectile(org, dir, CT_PROJ_REFLNG, SPEED_REFLECTION);
				self = tself;
			}
		}

		// Produce blood particles at impact and apply damage to target.
		if (self.dmg > 0) {
			spawn_touchblood(self, other, self.dmg);
			T_Damage(other, self, self.owner, self.dmg, DAMARMOR);
		} else {
			if (other.flags & FL_MONSTER && olddmg && self.owner && (other.enemy != self.owner)) {
				if (!Align_Match(other,self.owner) && (!other.enemy || other.switchtimer < time) && (self.owner.health > 0)) {
					other.enemy = self.owner;
					if (other.th_run) {
						other.think = other.th_run;
						other.nextthink = time + 0.1;
					}
				}
			}
		}

		// Restore armor after applying lavanail's pierce damage
		if (self.classtype == CT_PROJ_LAVANG || self.classtype == CT_PROJ_LAVASNG) { other.armortype = old_armortype; other.armorvalue = old_armorvalue; }

		// Nail Piercing affect, move nail through monster
		if (self.projeffect & IT_ARTPIERCE) {
			if (random() < 0.2) SpawnMeatSpray (self, other, crandom() * 100); // a small pile of gifs! (spog)
			self.movetype = MOVETYPE_FLY; // Setup projectile ready for monster tests
			self.solid = SOLID_BBOX;
			self.oldorigin = self.origin;
			self.count = 0;

			// Loop forward 8 times to find space on the other side of any other damageables.
			while (self.count < 8) {
				self.finaldest = self.oldorigin + (self.finalangle * 512); // Trace forward from current position
				traceline(self.oldorigin, self.finaldest,FALSE,self);
				if (trace_ent == other) self.oldorigin = self.oldorigin + self.finalangle*16; // Still inside bleeding object?
				else self.count = 8; // On the other side!
				self.count = self.count + 1;
			}

			// Is the other side free space to spawn?
			if (pointcontents(self.oldorigin) == CONTENT_EMPTY) {
				tself = self;
				org = self.oldorigin;
				dir = self.finalangle;
				proj_type = self.classtype;
				proj_speed = self.speed;
				self = self.owner; // Once a projectile hits an object it is impossible to reset its velocity/angles and carry on.  Use owner to make non-solid...
				launch_projectile(org, dir, proj_type, proj_speed); // ... and create a new projectile and delete the current one instead!
				self = tself;
			}
		}
	} else {
		// Rocochet feature for lasers (Laser Canon from hipnotic mod)
		if (self.attack_ricochet > 0) {
			self.attack_ricochet = self.attack_ricochet - 1;
			self.dmg = self.dmg * 0.9; // Gradually wear down the damage from ricohets
			self.pos1 = self.angles;
			self.pos1_x = -self.pos1_x;
			makevectors(self.pos1); // Use angles to create forward vector
			self.pos2 = self.origin - (v_forward * 16); // Need to intersect the surface to create the plane normal
			self.pos3 = self.origin + (v_forward * 16); // Start and finish points have to be either side of impact
			traceline (self.pos2, self.pos3, FALSE, self); // Ignore all monsters and trace backward from impact
			setorigin(self, trace_endpos); // Move entity to impact point so its not stuck

			// Show Laser impact on geo surface
			if (self.attack_ricochet == 0 || random() < 0.25) {
				WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
				WriteCoord (MSG_BROADCAST, self.origin_x);
				WriteCoord (MSG_BROADCAST, self.origin_y);
				WriteCoord (MSG_BROADCAST, self.origin_z);
			}
			
			// Create ricochet angle using trace_plane_normal, which is the normal of the surface hit.
			self.pos3 = normalize(self.finalangle);
			self.velocity = self.pos3 + ( 2 * trace_plane_normal );
			self.velocity = normalize(self.velocity);
			self.finalangle = self.velocity; // Save for think function
			self.velocity = self.finalangle * self.attack_speed;
			self.angles = vectoangles(self.finalangle); // make sure projectile facing correct direction
			self.flags = self.flags - (self.flags & FL_ONGROUND); // Make sure the projectile is still flying
			self.movetype = MOVETYPE_FLYMISSILE; // Reset movement functionality
			self.solid = SOLID_BBOX;
			self.touch = Touch_Projectile; // Make sure all touch/think is still working.
			self.nextthink = time + 0.1;
			self.think = Think_Projectile;
			return; // We bounced.
		}

		// Some projectiles need to be left lying around for a while
		if (self.bodyfadeaway) {
			if (self.classtype == CT_PROJ_FLESH || self.classtype == CT_PROJ_FLESHP) 
				sound (self, CHAN_WEAPON, "zombie/z_miss.wav", 1, ATTN_NORM);
			else if (self.classtype == CT_PROJ_SPID || self.classtype == CT_PROJ_WILLY || self.classtype == CT_PROJ_VORE || self.classtype == CT_PROJ_ELF)
				sound (self, CHAN_WEAPON, "ad171/wraith/bounce.wav", 1, ATTN_NORM);
			else if (self.classtype == CT_PROJ_BOLT1 || self.classtype == CT_PROJ_BOLT2 || self.classtype == CT_PROJ_DARTARROW) {
				if (random() < 0.5) sound (self, CHAN_WEAPON, "ad171/weapons/bolt_hit2.wav", 1, ATTN_NORM);
				else sound (self, CHAN_WEAPON, "ad171/weapons/bolt_hit3.wav", 1, ATTN_NORM);
			}
				
			self.velocity = self.avelocity = '0 0 0';
			self.nextthink = time + 2 + random(); // Soon make projectiles vanish.
			self.ltime = self.nextthink;
			self.think = model_fade;	
			return;
		} else { // Standard engine impact particles and sounds
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			if (self.classtype == CT_PROJ_SNG) WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
			else if (self.classtype == CT_PROJ_LASER) WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
			else if (self.classtype == CT_PROJ_GROCK) WriteByte (MSG_BROADCAST, TE_GUNSHOT);
			else if (self.classtype == CT_PROJ_WIZ) WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
			else if (self.classtype == CT_PROJ_SPID) WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
			else if (self.classtype == CT_PROJ_SWAMP) WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
			else if (self.classtype == CT_PROJ_WILLY) WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
			else if (self.classtype == CT_PROJ_VORE) WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
			else if (self.classtype == CT_PROJ_ELF) WriteByte (MSG_BROADCAST, TE_GUNSHOT);
			else if (self.classtype == CT_PROJ_FURY2) WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
			else if (self.classtype == CT_PROJ_NOUR1) WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
			else if (self.classtype == CT_PROJ_BLBOLT) WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
			else if (self.classtype == CT_PROJ_BLBOLT2) WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
			else if (self.classtype == CT_PROJ_HKN || self.classtype == CT_PROJ_HKN_BLUE) WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
			else if (self.classtype == CT_PROJ_HKN2) WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
			else WriteByte (MSG_BROADCAST, TE_SPIKE);
			WriteCoord (MSG_BROADCAST, self.origin_x);
			WriteCoord (MSG_BROADCAST, self.origin_y);
			WriteCoord (MSG_BROADCAST, self.origin_z);
		}
	}
	entity_remove(self,3); // Hide projectile and wait for any sounds to finish playing
};

void() Touch_HomingMissile = { // [FUNCTION]
	if (check_skycontent(self.origin)) {entity_remove(self, 0.1); return;}
	if (self.touchedvoid) return;				// Marked for removal
	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing

	// Check for breakable/pushable monster immunity
	if (ai_immunebreakable(self.oldenemy, other)) {
		SpawnExplosion(EXPLODE_BURST_SMOKE,self.origin,SOUND_RESIST_ROCKET); // Show ammo resistance on bmodel
		SpawnProjectileSmoke(self.origin, 200, 50, 150);
		SpawnProjectileSmoke(self.origin, 200, 50, 250);
		SpawnProjectileSmoke(self.origin, 300, 50, 150);
	} else {
		if (ai_foundbreakable(self.oldenemy, other, TRUE) && other.brktrigmissile != 0) {
			trigger_ent(other, self.oldenemy); // Found a breakable which is prone to explosive damage
		} else {
			
			if (other.classgroup == CG_ZOMBIE && !(other.classname == "monster_mummy")) T_Damage (other, world, world, DAMAGE_ZOMBIECLASS, NOARMOR); // Homing Missiles always kill any zombie class (except for tuff mummies!).
			else {
				self.pos1 = '0 0 0'; // Missile explosion x/y/z = base/rnd/splash
				if (self.classtype == CT_PROJ_SHUB1) self.pos1 = self.oldenemy.pos2;
				else if (self.classtype == CT_PROJ_SHAL) self.pos1 = DAMAGE_HMSHAL;
				else if (self.classtype == CT_PROJ_SERG) self.pos1 = DAMAGE_HMSERG;
				else self.pos1_z = DAMAGE_MONROCKET; // Default uses classic grenade/rocket damage

				self.dmg = self.pos1_x + (random() * self.pos1_y); // pre-calculate missile damage

				// BLAST BELT:  Resistance = 100% for splashdamage, 50% for direct.
				if (other.flags & FL_CLIENT && other.moditems & IT_ARTBLASTBELT) {
					PlayBlastBeltSound(other);	// Play impact sound
					if (other.health > 0) {
						if (self.dmg <= 0 && self.pos1_z > 0) T_Damage (other, self, self.oldenemy, self.pos1_z * ART_BLASTBELT_DD, DAMARMOR); // Need some damage otherwise projectile does nothing!
						else if (self.dmg > 0) T_Damage (other, self, self.oldenemy, self.dmg * ART_BLASTBELT_DD, DAMARMOR); // Any Direct damage is reduced
					}

					if (self.pos1_z > 0) T_RadiusDamage (self, self.oldenemy, self.pos1_z, self.oldenemy, IGNORECLASS);
				} else { // DEFAULT
					if (self.dmg > 0 && other.health > 0) T_Damage (other, self, self.oldenemy, self.dmg, DAMARMOR); // Only call T_ functions if there is damage to do!
					if (self.pos1_z > 0) T_RadiusDamage (self, self.oldenemy, self.pos1_z, self.oldenemy, IGNORECLASS); // Stop multiple enemies of the same type killing themselves!
					else {
						if (self.poisonous) PoisonDeBuff(other); // Check for poison debuff (using poisonous flag)
					}
				}
			}
		}

		if (other.resist_rockets > 0) Resist_Effects(other,self.origin,VEC_ORIGIN,0,AM_ROCKETS,other.pain_sound,SOUND_RESIST_ROCKET); // Rocket resistance is shown with puffs of smoke
		else {
			if (ext_dppart) { 
				if (self.poisonous == TRUE) self.dpp_name = DPP_TEPOISON; // Use special effect for e.g. voreball explosions in DP.
				pointparticles(particleeffectnum(self.dpp_name), self.origin, '0 0 0', 1); // DP effect name set before homing missile launched
				R_Exp3(self.origin); // Play standard explosion sound
			} else {
				if (self.poisonous) {
					WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
					WriteByte (MSG_BROADCAST, TE_EXPLOSION2); // New special coloured particle explosion (rogue expansion)
					WriteCoord (MSG_BROADCAST, self.origin_x);
					WriteCoord (MSG_BROADCAST, self.origin_y);
					WriteCoord (MSG_BROADCAST, self.origin_z);
					WriteByte (MSG_BROADCAST, 51);
					WriteByte (MSG_BROADCAST, 8);
					SpawnExplosion(EXPLODE_POISON_SMALL, self.origin, SOUND_REXP3); // Sprite explosion for Fitz engines
				} else {
					WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
					WriteByte (MSG_BROADCAST, TE_EXPLOSION); // Standard explosion
					WriteCoord (MSG_BROADCAST, self.origin_x);
					WriteCoord (MSG_BROADCAST, self.origin_y);
					WriteCoord (MSG_BROADCAST, self.origin_z);
					SpawnExplosion(EXPLODE_SMALL, self.origin, SOUND_REXP3); // Sprite explosion for Fitz engines
				}
			}
		}
	}
	entity_remove(self, 4); // Hide+Delete homing missile, no longer needed.  Wait for any sounds to finish playing
};

void() ShalMissileTouch = { Touch_HomingMissile(); }; // [FUNCTION], re-direct any map hacks to the new function replacement.

void() Touch_Missile = { // [FUNCTION]
	local float lavadmg;

	if (self.touchedvoid) return;				// Marked for removal
	if (check_skycontent(self.origin)) {entity_remove(self, 0.1); return;}
	if (other == self.owner) return;			// Touching self, do nothing
	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing
	if (self.oldenemy && other.classtype == self.oldenemy.classtype) return; // Stop packs of owners killing each other
	if (self.classtype == CT_PROJ_SKULLW && self.th_updmissile != SUB_Null) { self.th_updmissile(); return; } // Guardian skull wizards have special poison explosion

	if (ai_immunebreakable(self.owner, other)) { // Check for breakable/pushable monster immunity
		SpawnExplosion(EXPLODE_BURST_SMOKE,self.origin,SOUND_RESIST_ROCKET); // Show ammo resistance
		SpawnProjectileSmoke(self.origin, 200, 50, 150);
		if (random() < 0.5) SpawnProjectileSmoke(self.origin, 200, 50, 250);
		if (random() < 0.5) SpawnProjectileSmoke(self.origin, 300, 50, 150);
	} else {
		if (ai_foundbreakable(self.owner, other, TRUE) && other.brktrigmissile != 0) {
			trigger_ent(other, self.owner); // Found a breakable which is prone to explosive damage
		} else {
			// Setup rocket damage (vector = base + random and splash)
			if (self.classtype == CT_PROJ_ROCKET) self.pos1 = DAMAGE_RLPLAYER;
			else if (self.classtype == CT_PROJ_ROCKETSUPER) self.pos1 = DAMAGE_RLPLAYER;
			else if (self.classtype == CT_PROJ_FURY1) self.pos1 = DAMAGE_RLFURY;
			else if (self.classtype == CT_PROJ_LAVA) { self.pos1 = DAMAGE_RLPLAYER; lavadmg = TRUE; }
			else if (self.classtype == CT_PROJ_FIRETOP) { self.pos1 = DAMAGE_RLFIRETOP; lavadmg = TRUE; }
			else if (self.classtype == CT_PROJ_CHTHON) { self.pos1 = self.owner.pos2; lavadmg = TRUE; }
			else if (self.classtype == CT_PROJ_SKULLW) self.pos1 = DAMAGE_RLSKULLW;
			else if (self.classtype == CT_PROJ_GARG) { self.pos1 = DAMAGE_RLGARG; lavadmg = TRUE; }
			else if (self.classtype == CT_PROJ_ARMY) self.pos1 = DAMAGE_RLARMY;
			else if (self.classtype == CT_PROJ_CYBER) self.pos1 = DAMAGE_RLCYBER;
			else if (self.classtype == CT_PROJ_JIM2) self.pos1 = DAMAGE_RLJIM2;
			else if (self.classtype == CT_PROJ_SEEKER) self.pos1 = DAMAGE_RLSEEKER;
			else if (self.classtype == CT_PROJ_DROLE) { self.pos1 = DAMAGE_RLDROLE; lavadmg = TRUE; }
			else if (self.classtype == CT_PROJ_ICEG1) self.pos1 = DAMAGE_RLICEG;
			else if (self.classtype == CT_PROJ_BLORD2){ self.pos1 = DAMAGE_RLBLORD; lavadmg = TRUE; } // BOSS Custom for ad_sepulcher (Fire Shambler)
			else if (self.classtype == CT_PROJ_EIDO1) self.pos1 = DAMAGE_RLEIDO;
			else if (self.classtype == CT_PROJ_SMARTBALL) { self.pos1 = DAMAGE_SMARTBALL; lavadmg = TRUE; }
			else if (self.classtype == CT_PROJ_FABLADE) self.pos1 = '8 8 0';
			else if (self.classtype == CT_PROJ_FASPELL) self.pos1 = '12 22 20';
			else if (self.classtype == CT_PROJ_BLORD) {
				self.pos1 = DAMAGE_RLBLORD;
				self.oldorigin = self.origin; // Don't spawn gib models at impact (could be solid)
				self.origin = self.origin - 8*normalize(self.velocity);
				self.gib1mdl = MODEL_PROJ_BLORD1S; // Special gib model, frame and movement pattern
				self.gib1frame = 9;
				ThrowGib(11, rint(0.5 + random()*3)); // Throw gib quantity based on skill level
				self.origin = self.oldorigin; // Restore origin for rest of rocket impact
				self.height = EXPLODE_POISON_MED; // Use new poison explosion
				if (other.classname == "player") PoisonDeBuff(other); // Poisonous projectiles
			}
			else if (self.classtype == CT_PROJ_SWEEP1) self.pos1 = DAMAGE_RLSWEEPER;
			else if (self.classtype == CT_PROJ_DPRINCE1) self.pos1 = DAMAGE_RLDPRINCE;
			else if (self.classtype == CT_PROJ_DEFLECT1) self.pos1 = DAMAGE_RLDEFLECT;
			else if (self.classtype == CT_PROJ_MAMMOTH) self.pos1 = DAMAGE_RLMAMMOTH;
			else if (self.classtype == CT_PROJ_JUDGER) self.pos1 = DAMAGE_RLJUDGE;
			else if (self.classtype == CT_PROJ_JUSTICER) self.pos1 = DAMAGE_RLJUDGE;
			else if (self.classtype == CT_PROJ_RAINDEER) self.pos1 = DAMAGE_RLRAINDEER;

			// Instant death explosion for zombies from rocket explosions!  It doesn't make sense that this wasn't originally a default for explosives. this will affect _zombie, _zombiek, monster types.
			if (other.classgroup == CG_ZOMBIE && !(other.classname == "monster_mummy")) {
				if (self.pos1_x < DAMAGE_RLKILLZOM) self.pos1_x = DAMAGE_RLKILLZOM; // Change direct damage direct to make sure it zombie gibs
			}
			self.dmg = self.pos1_x + (random() * self.pos1_y); // Pre-calculate rocket damage.

			// LAVA SHIELD.  Resistance = 50% fire/lava attacks.  Monsters - Boss, Chthon, Firetop, Drole, Quoth Deathguard and Gargoyle
			if (other.flags & FL_CLIENT && other.moditems & IT_ARTLAVASHIELD && lavadmg == TRUE) {
				if (other.moditems & IT_ARTLAVASHIELD) {
					PlayLavaShieldSound(other);
					self.dmg = floor(self.dmg * 0.5);
					if (self.dmg <= 0) self.dmg = 0;
				}

				if (other.resist_fire > 0) self.dmg = self.dmg * (1-other.resist_fire);
			}

			// BLAST BELT:  Resistance = 100% for splashdamage, 50% for direct.
			if (other.flags & FL_CLIENT && other.moditems & IT_ARTBLASTBELT) {
				PlayBlastBeltSound(other);	// Play impact sound
				if (other.health > 0) {
					if (self.dmg <= 0 && self.pos1_z > 0) T_Damage (other, self, self.owner, self.pos1_z*ART_BLASTBELT_DD, DAMARMOR); // Need some damage otherwise projectile does nothing!
					else if (self.dmg > 0) T_Damage (other, self, self.owner, self.dmg*ART_BLASTBELT_DD, DAMARMOR); // Any direct damage is reduced
				}
				if (self.pos1_z > 0) T_RadiusDamage (self, self.owner, self.pos1_z, other, DAMAGEALL);
			} else {
				if (self.dmg > 0 && other.health > 0) T_Damage (other, self, self.owner, self.dmg, DAMARMOR); // DEFAULT Only call T_ functions if there is damage to do!
				if (self.pos1_z > 0) T_RadiusDamage (self, self.owner, self.pos1_z, other, DAMAGEALL);
			}
		}
		
		if (other.resist_rockets > 0 || (other.resist_multi_rockets && self.classgroup == CG_PROJMULTIROCKETS)) Resist_Effects(other,self.origin,VEC_ORIGIN,0,AM_ROCKETS,other.pain_sound,SOUND_RESIST_ROCKET); // Rocket resistance is shown with puffs of smoke
		else {
			if (self.poisonous == TRUE) { self.height = EXPLODE_POISON_MED; PoisonDeBuff(other); } // Check for poison debuff (using poisonous flag).  Use new poison explosion.
			self.origin = self.origin - 8*normalize(self.velocity); // Move the explosion effect higher up from point of contact
			if (self.classtype == CT_PROJ_ROCKETSUPER || self.classtype == CT_PROJ_SIDEWINDER) self.height = EXPLODE_SMALL; // Because it's used for the think function to adjsut velocity over time.
			if (self.height < EXPLODE_PLASMA_SMALL) {
				WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte (MSG_BROADCAST, TE_EXPLOSION); // Default ID particle explosion for fire explosions
				WriteCoord (MSG_BROADCAST, self.origin_x);
				WriteCoord (MSG_BROADCAST, self.origin_y);
				WriteCoord (MSG_BROADCAST, self.origin_z);
			}
			if (self.noise == "") self.noise = SOUND_REXP3; // Play original explosion sound or replacement
			SpawnExplosion(self.height, self.origin, self.noise);
		}
	}
	entity_remove(self, 1); // Hide+Delete rocket, no longer needed
};

void() T_MissileTouch = { Touch_Missile(); }; // [FUNCTION], re-direct any map hacks to the new function replacement.

void() Touch_Grenade = { // [FUNCTION]
	if (self.touchedvoid) return;				// Marked for removal
	if (entity_pcontent(self.origin)) {remove(self); return;}
	if (other == self.owner) return;			// Touching self, do nothing
	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing

	self.activate = other;		// Always keep track of what to damage
	if (self.classtype == CT_PROJ_MEGG && other.takedamage == DAMAGE_AIM) {
		// Let minion eggs re-bounce in opposite direction.  Don't want them to explode like grenades.
		if (CheckZeroVector(self.velocity) == FALSE) {
			self.angles = vectoangles(self.mangle);
			self.angles_y = anglemod(self.angles_y + 180);
			self.velocity = -self.mangle;	// Reverse direction
			self.mangle = self.velocity;	// Update new direction
			sound (self, CHAN_WEAPON, self.noise, 1, ATTN_NORM);
			if ( vlen(self.velocity) > 100 ) self.nextthink = time + LIFE_EGG; // Reset egg timer if still bouncing a lot
		}
	} else {
		if (ai_foundbreakable(self.owner, self.activate, TRUE) && (self.owner.flags & FL_MONSTER)) { // Check before damage_aim because only player/monster have that setting
			trigger_ent(self.activate, self.owner); // Found a breakable which is prone to explosive damage
			Explode_Grenade(); // Any monster firing a grenade at a breakable will explode without bounce
		} else if (self.activate.takedamage == DAMAGE_AIM) { // Hit something that bleeds? (allows for grenade impact)
			Explode_Grenade(); 
		} else {
			sound (self, CHAN_WEAPON, self.noise, 1, ATTN_NORM); // Bounce sound.  MOOM!
			if (CheckZeroVector(self.velocity)) self.avelocity = '0 0 0'; // Stop spinning.
		}
	}
};

void() GrenadeTouch = { maphack_grenade(); }; // [FUNCTION]


// Ejecting Shell Casing for Shotguns
void() Touch_ShellCasing = { // [FUNCTION]
	if (self.touchedvoid) return;				// Marked for removal
	if (check_skycontent(self.origin)) {entity_remove(self, 0.1); return;}
	if (other == self.owner || other == self.master) return;
	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing

	self.touch = SUB_Null;
	if (random() < 0.5) sound(self, CHAN_VOICE, "ad171/weapons/shellc.wav", random()*0.25, ATTN_LOW);		
};

void () HIP_LaserTouch = { // [FUNCTION]
	local vector org, spot1, spot2, oldvel, dir, dir2;

	self.owner = world;
	self.cnt = (self.cnt + TRUE);
	if (pointcontents(self.origin) == CONTENT_SKY) { remove (self); return; }

	oldvel = normalize (self.old_velocity);
	spot1 = (self.origin - (16 * oldvel));
	spot2 = (self.origin + (16 * oldvel));
	traceline (spot1,spot2,FALSE,self);
	self.origin = trace_endpos;
	org = self.origin;
	if (self.master.tome_finished && self.tome_finished) {
		dir = (oldvel + (2 * trace_plane_normal));
		dir = normalize (dir);
		dir = (self.speed * dir);
		HIP_LaunchLaser (self.origin, dir * (crandom() * 20), TRUE);
		newmis.owner = other;
		newmis.master = self.master;
		newmis.tome_finished = FALSE; // Prevent infinite spawning loop
		HIP_LaunchLaser (self.origin, dir * (crandom() * 20), TRUE);
		newmis.owner = other;
		newmis.master = self.master;
		newmis.tome_finished = FALSE; // Prevent infinite spawning loop
	}

	if (other.health > 0 && other.takedamage) {
		if (self.lastvictim == other) self.dmg = (self.dmg / 2);
		spawn_touchblood (self, other, self.dmg);
		T_Damage (other,self,self.lastvictim,self.dmg,DAMARMOR);
	} else {
		if (self.cnt == 3 || random() < 0.15) Tent_Point(TE_GUNSHOT,org);
		else {
			// Ricochet up to 3 times
			if (!self.master.tome_finished) {
				self.dmg = (0.900 * self.dmg); // Reduce damage 10% each ricochet, we lose energy on impact, unless tome of power
				self.velocity = (oldvel + (2 * trace_plane_normal)); // Mirror direction along impact plane normal
				self.velocity = normalize (self.velocity);
				self.velocity = (self.speed * self.velocity);
				self.old_velocity = self.velocity;
				if (self.flags & FL_ONGROUND) self.flags = (self.flags - FL_ONGROUND);
			} else {
				BounceShot_Move();
				BounceShot_Seek(); // Redirect to an enemy.
			}
			sound (self,CHAN_WEAPON,"hipnotic/weapons/laserric.wav",TRUE,ATTN_STATIC);
			return;
		}
	}
	sound (self,CHAN_WEAPON,SOUND_LASER_HIT,TRUE,ATTN_STATIC);
	remove (self);
};

void () ProximityGrenadeTouch = { // [FUNCTION]
   if (other == self) return;
   if (other.classname == self.classname) return;

   self.movetype = MOVETYPE_TOSS;
   if (self.state) return;
   if (vlen(other.velocity) > 0) { ProximityGrenadeExplode (); self.think(); return; }
   if (other.takedamage == DAMAGE_AIM) { ProximityGrenadeExplode (); self.think(); return; }

   sound (self,CHAN_WEAPON,"weapons/bounce.wav",TRUE,ATTN_NORM);
   self.movetype = MOVETYPE_NONE;
   setsize (self,'-8.000 -8.000 -8.000','8.000 8.000 8.000');
   self.state = TRUE;
   self.spawnmaster = other;
};

// AreaBlaster = Fireballs that tear through and grind targets for a while before exploding.  Similar to the AreaBlaster special from the NES game
// The Guardian Legend.  For a more recent example, the ghosts from Hexen's priest weapon Wraithverge.
void() AreaBlaster_Touch = { // [FUNCTION]
    if (pointcontents(self.origin) == CONTENT_SKY) {remove (self); return;}
    if (Reflected()) return;

    if (other.takedamage) T_Damage (other, self, self.master, self.cnt, IGNORECLASS);
    else Tent_Point (TE_KNIGHTSPIKE, self.origin);

    if (other.solid != SOLID_BSP) self.owner = other;
};

// Called when a MIRV slams into something before releasing its payload.
void() Mirv_Touch = { // [FUNCTION]
    Mirv_Reset (); // Turn off control.
    if (pointcontents(self.origin) == CONTENT_SKY) {remove (self); return;}
    if (Reflected_Damage (COURAGE_DAMAGE)) return;

    Mirv_Payload(); // Unleash AreaBlaster payload.
    self.touch = SUB_Null; // Stack overflow prevention.
    self.enemy = other;
	if (!self.dmg) self.dmg = 120;
    if (self.tome_finished) self.dmg = self.dmg * 2;
	if (self.dmg > 0 && other.health > 0) {
		T_Damage (other, self, self.owner, self.dmg, DAMARMOR);
		T_RadiusDamage (self, self.owner, self.dmg, other, DAMAGEALL);
		if (other.resist_rockets > 0 || (other.resist_multi_rockets && self.classgroup == CG_PROJMULTIROCKETS)) Resist_Effects(other,self.origin,VEC_ORIGIN,0,AM_ROCKETS,other.pain_sound,SOUND_RESIST_ROCKET); // Rocket resistance is shown with puffs of smoke
	} else {
		// Check for poison debuff (using poisonous flag)
		if (self.poisonous == TRUE) {
			self.height = EXPLODE_POISON_MED; // Use new poison explosion
			PoisonDeBuff(other); // Poisonous projectiles
		}

		T_RadiusDamage (self, self.owner, self.pos1_z, other, DAMAGEALL);
	}
	
	self.origin = self.origin - 8*normalize(self.velocity); // Move the explosion effect higher up from point of contact
	if (self.noise == "") self.noise = SOUND_REXP3; // Play original explosion sound or replacement
	R_Exp3(self.origin);
	Tent_Explosion(self.origin);
	BecomeExplosion2 ();
};

void () lavaspike_touch = { // [FUNCTION]
	local float old_armortype;
	local float old_armorvalue;
	local float old_armormask;

	if (other == self.owner) return;
	if (other.solid == SOLID_TRIGGER) return;
	if (pointcontents(self.origin) == CONTENT_SKY) { remove(self); return; }

	if (other.takedamage) {
		spawn_touchblood(self,other,9);
		if (other.flags & FL_CLIENT) {
			old_armortype = other.armortype;
			old_armorvalue = other.armorvalue;
			old_armormask = (other.items2 & ((IT2_ARMOR1 | IT2_ARMOR2) | IT2_ARMOR3));
			other.armortype = FALSE;
			other.armorvalue = FALSE;
			T_Damage (other,self,self.owner,9,DAMARMOR);
			other.armortype = old_armortype;
			other.armorvalue = old_armorvalue;
			other.items2 = (other.items2 | old_armormask);
		} else T_Damage (other,self,self.owner,15,DAMARMOR);
	} else {
		WriteByte(MSG_BROADCAST,SVC_TEMPENTITY);
		if (self.classname == "wizspike") WriteByte(MSG_BROADCAST,TE_WIZSPIKE);
		else if (self.classname == "knightspike") WriteByte(MSG_BROADCAST,TE_KNIGHTSPIKE);
		else WriteByte(MSG_BROADCAST,TE_SPIKE);

		WriteCoord(MSG_BROADCAST,self.origin_x);
		WriteCoord(MSG_BROADCAST,self.origin_y);
		WriteCoord(MSG_BROADCAST,self.origin_z);
	}
	remove(self);
};

void () superlavaspike_touch = { // [FUNCTION]
	local float old_armortype;

	if (other == self.owner) return;
	if (other.solid == SOLID_TRIGGER) return;
	if (pointcontents(self.origin) == CONTENT_SKY) { remove(self); return; }

	if ( other.takedamage ) {
		spawn_touchblood (self, other, 18.000);
		if (other.flags & FL_CLIENT) {
			old_armortype = other.armortype;
			other.armortype = (other.armortype * 0.500);
			T_Damage (other,self,self.owner,18.000,DAMARMOR);
			if (other.armortype != 0) other.armortype = old_armortype;
		} else T_Damage (other,self,self.owner,30,DAMARMOR);
	} else {
		WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST,TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST,self.origin_x);
		WriteCoord (MSG_BROADCAST,self.origin_y);
		WriteCoord (MSG_BROADCAST,self.origin_z);
	}
	remove (self);
};

void() MultiGrenadeTouch = { // [FUNCTION]
   if (other == self.owner) return;

   if (other.takedamage == DAMAGE_AIM) {
      if (self.classname == "MiniGrenade") {
         MiniGrenadeExplode(); // Do the split grenade's explode.
      } else {
         if (self.owner.classname == "player") {
			self.lefty = TRUE;
            MultiGrenadeExplode(); // Split and near insta-explode.
         } else MiniGrenadeExplode(); // Monster grenade, forgiving.
      }
      return;
   }
   sound(self,CHAN_WEAPON,"weapons/bounce.wav",TRUE,ATTN_NORM);
   if (self.velocity == VEC_ORIGIN) self.avelocity = VEC_ORIGIN;
};

void () MultiRocketTouch = { // [FUNCTION]
   if (other == self.owner) return;
   if (pointcontents(self.origin) == CONTENT_SKY) { remove(self); return; }

   MultiRocketExplode();
};

void () PlasmaTouch = { // [FUNCTION]
   local float damg,raddmg;

   if ( (other == self.owner) )
      return ;

   if ( (pointcontents (self.origin) == CONTENT_SKY) ) {
      remove (self);
      return ;
   }
   damg = (80.000 + (random () * 20.000));
   raddmg = 70;
   if (self.owner.classtype == CT_MONGREMLIN) { damg = damg * 0.5; raddmg = 35;}
   sound (self,CHAN_WEAPON,"rogue/plasma/explode.wav",TRUE,ATTN_NORM);
   if ( other.health ) {
      T_Damage (other,self,self.owner,damg,DAMARMOR);
   }

   T_RadiusDamage (self,self.owner,raddmg,other,DAMAGEALL);
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_EXPLOSION2);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   WriteByte (MSG_BROADCAST,244.000);
   WriteByte (MSG_BROADCAST,MOVETYPE_WALK);
   PlasmaGroundOut();
   remove(self);
};

void() beam_touch = { // [FUNCTION]
	local float totaldmg;

	if (other == self.owner) return;
	if (other.solid == SOLID_TRIGGER) return; // trigger field, do nothing
	if (pointcontents(self.origin) == CONTENT_SKY) { remove(self); return; }

	if (other.takedamage) { // hit something that bleeds
		totaldmg = self.currentammo * 1.25;
		totaldmg = ceil(totaldmg);
		// totally decimate the dude if doesn't have enough health
		if(other.health <= totaldmg) {
			T_Damage (other, self, self.owner, 99999,DAMARMOR);
			if(other.health <= 0) {
				MakeBeamRing(other.origin);
				WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte (MSG_BROADCAST, TE_TAREXPLOSION);
				WriteCoord (MSG_BROADCAST, other.origin_x);
				WriteCoord (MSG_BROADCAST, other.origin_y);
				WriteCoord (MSG_BROADCAST, other.origin_z);
				remove(self);
				return;
			}
		} else T_Damage (other, self, self.owner, totaldmg,DAMARMOR);
	}
	sound (self, CHAN_ITEM, "custents/turret/beamhit.wav", 1, ATTN_NORM);
	BecomeBeamHit();
};

void() Laser2_Touch = { // [FUNCTION]
	local vector org;

	if (other == self.owner) return;		// don't explode on owner
	if (pointcontents(self.origin) == CONTENT_SKY) { remove(self); return; }
	
	sound (self, CHAN_WEAPON, SOUND_LASER_HIT, 1, ATTN_STATIC);
	org = self.origin - 8*normalize(self.velocity);
	if (other.health) {
		SpawnBlood (self.enemy, org,v_forward, 9,0);
		T_Damage (other, self, self.owner, 9, DAMARMOR);
	}
	remove(self);
};

void() WeldTouch = { // [FUNCTION]
	local float r, d, db;
	local entity e;

	if (pointcontents(self.origin) == CONTENT_SKY) { remove(self); return; }
	if (self.waterlevel > 1) { remove(self); return; }
	if (self.enemy.classname == "the_mister") { remove(self); return; }
	if (self.enemy.items & IT_SUIT) { remove(self); return; }
	if (self.enemy.event == "nehahra_frame" || self.enemy.classname == "monster_nehahra") { remove(self); return; }

	if (other.takedamage) spawn_touchblood(self, other, 9);
	e = findradius(self.origin, WELD_DAMAGE_RADIUS);
	while (e) {
		if (e.takedamage) {
			if (e.takedamage != DAMAGE_AIM) {
				T_Damage(e, self, self.owner, 10, DAMARMOR);
			} else {
				r = random();
				db = 10 + (0.5 - r) * 6;
				d = vlen(e.origin + '0 0 16' - self.origin);
				if (d < WELD_DAMAGE_RADIUS - 4 * db) {
					d = db;
				} else {
					if (d < WELD_DAMAGE_RADIUS)
						d = (WELD_DAMAGE_RADIUS - d) * 0.25;
					else
						d = 0;
				}
				if (d) {
					
					if (r > 0.85) {
						if (d > 5) {
							if (e.flags & FLx_CREATURE) ApplyFireDmg(e, d, d);
							else if (ai_foundbreakable(self, e, FALSE)) T_Damage(e, self, self.owner, d, DAMARMOR);
						}
					}
				}
			}
		}
		e = e.chain;
	}
	self.origin = self.origin - 4 * normalize(self.velocity);
	self.movetype = MOVETYPE_NONE;
	self.velocity = VEC_ORIGIN;
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;
	self.think = SUB_Remove;
	self.nextthink = time + 4;
	setmodel(self, "progs/s_explod.spr");
	setorigin(self, self.origin);
	sound(self, CHAN_BODY, "nehahra/boss3/hit.wav", 1, ATTN_NORM);
	WeldExplode1();
};

void() AkArrow_Magic_Touch = { // [FUNCTION]
	local float sped;

	// Other, more powerful and explosive arrow types.
    if (self.worldtype && (other.flags & FLx_CREATURE) && !Ally_Check(other,self.master) && !HasReflection(other,self.origin,0) && other.mass > 0 && other.mass <= MASS_SUPER) { // Knockback effect.
		sped = self.speed;
		if (other.mass == MASS_SUPER) sped = sped / 2;
		other.velocity = other.velocity + (self.movedir * sped);
		if (other.flags & FL_ONGROUND) {
			other.flags = other.flags - FL_ONGROUND;
			if (other.velocity_z < 150) other.velocity_z = 150;
		}
    }
    Touch_Missile();
};

// Called when an arrow hits something.
void() AkArrow_Wood_Touch = { // [FUNCTION]
    local vector org;

    if (pointcontents(self.origin) == CONTENT_SKY) {remove (self); return;}
    if (Reflected ()) return;

    self.touch = SUB_Null; // Stack overflow prevention.
    if (other.takedamage) {
        spawn_touchblood(self, other, self.dmg);
        T_Damage(other, self, self.master, self.dmg,DAMARMOR);
        sound(self, CHAN_WEAPON, "drake/archer/arrow1.wav", 1, ATTN_IDLE);
        remove(self);
        return;
    }
    if (other.solid != SOLID_BSP) { // Break on impact. e.g., shielded mega enforcer.
        org = self.origin - (8 * normalize(self.velocity));
        sound(self, CHAN_WEAPON, "drake/archer/arrowbrk.wav", 1, ATTN_IDLE);
        Tent_Point(TE_GUNSHOT,org);
        remove(self);
        return;
    }

	// Imbed into the surface.
    if (random() < 0.5) sound (self, CHAN_WEAPON, "drake/archer/arrow2.wav", 1, ATTN_IDLE);
    else sound (self, CHAN_WEAPON, "drake/archer/arrow3.wav", 1, ATTN_IDLE);

    self.movetype = MOVETYPE_NONE;
    self.velocity = self.avelocity = '0 0 0';
    self.nextthink= time + 1.5; // Reset think so arrow sticks in wall for a moment then vanishes.
    self.think    = SUB_Remove;
    self.touch    = SUB_Remove;
    if (other) { // Hit something that may move later.  Watch the axe... er, arrow.
        self.enemy      = other;
        self.delay      = self.nextthink;
        self.nextthink  = time + 0.100;
        self.think      = Axe_Watch;
    }
};

void() RyuPlasma_Touch = { // [FUNCTION]
    if (pointcontents(self.origin) == CONTENT_SKY) {remove (self);  return;}

    self.enemy = other;
    RyuPlasma_Explode();
};

void() Acidball_Touch = { // [FUNCTION]
    if (pointcontents(self.origin) == CONTENT_SKY) {remove (self); return;}

    self.touch = SUB_Null;
    self.enemy = other;
    if (!self.dmg) self.dmg = 120;
    if (self.enemy) T_Damage (self.enemy,self,self.owner,self.dmg / 6 * (5 + random()),DAMARMOR); // Don't check health, just if there is a target.  Someone took a direct hit.
    T_RadiusDamage(self,self.owner,self.dmg,self.enemy,DAMAGEALL); // Don't do radius damage to the enemy, because all the damage was done in the impact.
	setorigin(self, self.origin - (8 * normalize(self.velocity))); // PM:  Do it right.
    Tent_Explosion2(self.origin,48,16);
    BecomeAnyExplosion(115,5,"progs/drake/s_fancy.spr");
};

//  Meat -- Used by zombie and nightshade (wraith dragon).
void() Meat_Touch = { // [FUNCTION]
    if (pointcontents(self.origin) == CONTENT_SKY) {remove(self); return; }
    if (Reflected()) return;

    if (other.takedamage) {
        self.touch = SUB_Null;      // Stack overflow prevention.
        T_Damage(other,self,self.master,self.dmg,DAMARMOR);
        sound(self,CHAN_WEAPON,"zombie/z_hit.wav",1,ATTN_NORM);
        remove(self);
        return;
    }

    sound(self,CHAN_WEAPON,"zombie/z_miss.wav",1,ATTN_NORM); // bounce sound
    self.velocity = self.avelocity = '0 0 0';
    self.touch = SUB_Remove;
};

void() Ice_Touch = { // [FUNCTION]
    local float chunks, damage;
    local vector spot;

    if (pointcontents(self.origin) <= CONTENT_LAVA) {remove(self);  return;} // Lava or sky.
    if (Reflected ()) return;

    self.touch = SUB_Null;      // Stack overflow prevention.
    chunks = TRUE;
    damage = self.dmg;
    if (other.takedamage) {
		// Check cold resistance here instead of in the damage functions because it affects how much blood is spawned.
        if (damage > 0) {
            spawn_touchblood (self, other, damage);
            T_Damage (other, self, self.owner, damage, DAMARMOR);
            chunks = FALSE;
        }
    }
    if (chunks) {
        spawn_touchblood (self, other, 10); // Ice chunks.
        sound (self, CHAN_WEAPON, "drake/dragon/icehit.wav", 1, ATTN_NORM);
    }

	// Become a mini-shockwave if close enough to the wall.
	// In case of standard engines, just display a ring topside only.
    spot = self.origin;
    traceline (spot, spot + self.velocity, TRUE, world); // Ignore creatures.
    if (trace_fraction >= 1.0) {remove (self);  return;} // Too far from a solid surface.
	
    spot = trace_endpos + trace_plane_normal * 2;
    self.angles = vectoangles(trace_plane_normal);
    self.angles_y = anglemod(self.angles_y + 180);
    setorigin (self, spot);
    self.alpha = 0;
    BecomeAnyExplosion (RING2_ICE, 3, "progs/drake/s_wave2.spr");
};

void() IceMine_Touch = { // [FUNCTION]
    if ((other.takedamage != DAMAGE_AIM) && !(other.flags & FLx_CREATURE)) return; // Target must either be shootable or a creature.
    if (other == self.master) return; // Don't explode on attacker.

    IceMine_Explode(); // Removed sky and reflection checks because they do not apply to land mines.
};

// Made so monsters who step on the iceball will explode it.
void() IceMineTrigger_Touch = { // [FUNCTION]
    local   entity  ice, swap;

    ice = self.owner;
    if (!ice || (ice == self)) {remove (self);  return;}
    if (!(other.flags & FL_MONSTER)) return; // Other things should be able touch the iceball itself.
    if (other == ice.master) return; // Iceball owner is immune.
    if (!(ice.flags & FL_ONGROUND) || (ice.velocity != '0 0 0')) return; // Anything can touch iceball if it's moving.

	// Set off the mine!
    if (other) other.flags = other.flags - (other.flags & FL_ONGROUND);
    self.touch = SUB_Null;
    swap = self;
    self = ice;
    self.trigger_field = world;
    self.touch = SUB_Null;      // Stack overflow prevention.
    self.owner = other;         // Pass through the mine.
    IceMine_Explode();
    self = swap;
    remove (self);
};

//  Coven of Ebony Attacks
void() NecroSnake_Touch = { // [FUNCTION]
    if (pointcontents(self.origin) == CONTENT_SKY) { remove(self); return; }
    if (Reflected()) return;

    self.touch = SUB_Null;      // Stack overflow prevention.
    if (other.takedamage && (other.classname != self.master.classname)) {
        spawn_touchblood(self,other,self.dmg);
        T_Damage(other,self,self.master,self.dmg,DAMARMOR); // Update 6/11/2011:  Removed poison critical hits.
    } else Tent_Point(TE_WIZSPIKE,self.origin);
    remove (self);
};

void() NecroBolt_Touch = { // [FUNCTION]
    local float damage;

    if (pointcontents(self.origin) == CONTENT_SKY) {remove(self);  return;}
    if (Reflected_Damage (COURAGE_DAMAGE)) return;

    self.touch = SUB_Null; // Stack overflow prevention.
    if (other.classname != self.master.classname) { // Warlocks are immune, and shamblers take full damage.
        damage = (self.dmg - 20) + (random() * 20); // PM:  Half strength would be 50+d10, but since older progs used 50+d20 and gives the shot more oomph, I'll leave damage alone.
        if (damage > 0) T_Damage (other, self, self.master, damage, DAMARMOR);
    }
    T_RadiusDamage (self, self.master, self.dmg, other, DAMAGEALL); // PM:  Don't use 120 radius damage because that is too much.  Also, even though effects look like lightning, it isn't -- it's magic!
    self.origin = self.origin - 8*normalize(self.velocity);
    sound(self, CHAN_AUTO, "rogue/plasma/explode.wav", 1, ATTN_NORM);
    Rocket_Explosion2(self.origin, 247, 5); // Create wicked red electric explosion.
    BecomeFancy (X56_PLASMA_RED, 6);
};

// Called when a thrown hammer hits something.
void() Thor_Touch = { // [FUNCTION]
    local vector org;
    local float damage, dmg1, dmg2;
    local entity  swap;

    if (other == self.master) { Thor_Remove(); return; } // Returned to attacker, so simply catch the hammer.
    if (Reflected()) return;

    if (self.owner == self.master) { // Bounce straight back.
        self.movedir = self.movedir * -1;
        self.velocity = self.movedir * THOR_SPEED;
    }

    self.enemy = self.owner = other;
    if (other && other.takedamage) { // Hammers do not draw blood like edged weapons, so no spawn_touchblood. After all, this is why clerics in AD&D can use only blunt weapons. Hammer in melee may draw blood, but not when thrown.
        damage = 50;
        if (other.classname == "monster_zombie") damage = other.health + fabs(other.gibhealth * 1.1);
        sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
        T_Damage(other, self, self.master, damage, DAMARMOR);
        if (self.ammo_cells > 0) {
            damage = self.dmg;
            org = Midpoint(self.master);
            if (vlen(self.origin - org) > damage + 40) { // Discharge.
                self.ammo_cells = 0;
                dmg1 = (0.8 + random()*0.2) * self.dmg; // Combine two different sources of damage into one. dmg1 = Splash damage, dmg2 = Discharge.
                if (Align_Opposing(other, self.master)) { // Discharge would not hit target. 
                    dmg2 = self.dmg * 1.5; // Unlike plasma, this explosion discharges not once, but twice.
                }

                if (!other.bossflag && (other.health > 0) && other.health < 120 && other != self.master) {
					damage_attacker = self.master;
					damage_velocity = VEC_ORIGIN;
					dmg1 = other.health - other.gibhealth + 1;
				}
				T_Damage(other, self, self.master, dmg1 + dmg2, DAMARMOR); // Send monsters flying.
                T_RadiusDamage(self,self.master,damage,other,DAMAGEALL);

				// Don't move sprite back because hammer is still there.
                sound(self, CHAN_AUTO, "hipnotic/weapons/mjolhit.wav", 1, ATTN_NORM);
                Rocket_Explosion2(self.origin, 244, 3);
                Thor_Discharge(); // Spawn new, separate explosion entity.
                if (self.master.tome_finished) {
                    ShockWave(self.origin + '0 0 4', RING_BLUE, 6, "progs/drake/s_wave.spr",FALSE);
                    swap = self;
                    self = self.master;
					Quake_Spawn(self,800,10,self.origin,TRUE,2,VEC_QUAKE);
                    DeathRay(swap.origin,'0 0 0',100,1000,-2); // Use BFG9000-like trace attack instead of static field.
                    Divine_Wrath(4,2);
                    self = swap;
                } else ShockWave (self.origin + '0 0 4',RING_BLUE,4,"progs/drake/s_wave.spr",FALSE);
            }
        }
    } else {   // Hammer slammed a wall or something.
        if (pointcontents(self.origin) != CONTENT_SKY) {
            org = self.origin - 8*normalize(self.velocity);
            Tent_Point (TE_GUNSHOT, org);
            sound (self, CHAN_WEAPON, "hipnotic/weapons/mjoltink.wav", 1, ATTN_NORM);
        }

        if (self.count < 10) {
            self.count = self.count + 1;
        } else { // Stuck, so teleport back to the attacker's hand.
            Thor_Poof ();
            return;
        }
    }
};

void() Frozen_Touch = { // [FUNCTION]
	if (self.classtype == CT_MONSPAWN) dprint("Frozen spawn touched\n");

	if (other.health > 0 && other.flags & FLx_CREATURE) {
		if (self.pain_finished < time) {
			self.flags = self.flags - (self.flags & FL_ONGROUND);
			self.velocity_x = self.velocity_x + other.velocity_x*2;
			self.velocity_y = self.velocity_y + other.velocity_y*2;
			self.velocity_z = vlen(self.velocity) * 0.5;
			self.avelocity = crandom() * '0 600 0';
			sound(self, CHAN_VOICE,"drake/weapons/icewall.wav", 1, self.volume); // Has any impact sounds been defined?
			self.pain_finished = time + 2 + random() * 2; // 2 to 4 seconds
		}
	}
};

// Called when an arrow hits something.
void() Buriza_Touch = { // [FUNCTION]
    if (pointcontents(self.origin) == CONTENT_SKY) {remove (self); return;}
    if (Reflected()) return;

    if (other) {
        self.owner = other; // So arrow may pass through target.
        if (other == self.fallen) return; // Do not hit this target.
        if (other == self.oldenemy) return; // Do not retouch the same target twice in a row.

		T_Damage (other, self, self.master, 100, DAMARMOR); // Hit for 100 damage like in Heretic (ToP firemace vs. bosses).
		T_Slow (other, self.master, 5); // Knock off some hp, and slow for 5 seconds.
		particle (self.origin, crandom() * 100 * '1 1 1', 41 + rint(random()*7), 20);
		particle (self.origin, crandom() * 100 * '1 1 1', 9 + rint(random()*7), 20);
        if (other.solid != SOLID_BSP) {self.oldenemy = other;  return;}   // Pierce the target.

        self.owner = world; // Arrow will shatter, so set owner to the world so that targets hiding behind 'other' aren't hit by T_RadiusDamage.
    }

	// Explode on impact on a solid surface.
    self.touch = SUB_Null; // Stack overflow prevention.
    T_RadiusDamage (self, self.master, 60, world, DAMAGEALL);
    self.origin = self.origin - 8*normalize(self.velocity);
    sound (self, CHAN_AUTO, "drake/weapons/icewall.wav", 1, ATTN_NORM); // Don't spawn shockwaves like the dragons' iceballs.
    Particle_Explosion (self.origin, '9 33 4', '15 41 3'); // Formerly 'Tent_Explosion2 (self.origin, 32, 16);'.
    BecomeIcyExp();
};

// Called when fireball impacts.  On impact, it explodes and inflicts damage.
void() Fireball_Touch = { // [FUNCTION]
    if (pointcontents(self.origin) == CONTENT_SKY) {remove (self); return;} // If it is in the sky, disappear.

    self.velocity = normalize(self.velocity);
    if (Fireball_InWater (self)) return; // If the flame is in water, dissolve into steam.
    if (Reflected ()) return; // NEW:  Rebound if impacting a reflective surface.

    self.touch = SUB_Null; // Stack overflow prevention.
    T_RadiusDamage (self, self.master, self.dmg, other, DAMAGEALL); // Hit something that bleeds.  Update 8/30/09:  Attenuation = Damage / Radius.
    self.origin = self.origin - 8*normalize(self.velocity);
    if (other.takedamage) {
        MakeFlame (other);
        T_Damage (other, self, self.master, self.dmg, DAMARMOR);
    } else FloorFire_SpawnCheck (self, 0.1);

    self.effects = self.effects | EF_MUZZLEFLASH;
    if (self.noise) sound (self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
    BecomeExplosion ();
};

// The large fireball explodes on contact and inflicts severe damage within a radius.
void() Meteor_Touch = { // [FUNCTION]
    if (pointcontents(self.origin) == CONTENT_SKY) {remove (self); return;} // Destroy fireball if it has no power or if it touches the sky.
    if (self.dmg <= 0) {Meteor_Fizzle(self); return;}
    if (Reflected_Damage (COURAGE_DAMAGE)) return; // NEW:  Rebound if impacting a reflective surface.

    self.touch = SUB_Null; // Stack overflow prevention.
    self.enemy = other;
    Meteor_Explode(); // Do the damage.
};

// Oh dear!  Someone crossed the firewall.
void() Firelink_Touch = { // [FUNCTION]
    local float damage;

    if (self.wait > time) return; // Already burnt someone recently.
    if (!other.takedamage) return;
    if (other == self.owner) return; // Don't harm attacker.

    if (self.dmg < 1) damage = 1;
    else damage = (random() + 1) * self.dmg;

    T_Damage (other, self, self.master, damage, DAMARMOR);
    self.wait = time + 0.1;    // Wait until then to damage again.
    if (self.t_width < time) {
        sound (self, CHAN_BODY, "drake/weapons/fwallhit.wav", 1, ATTN_NORM); // Play burning sounds.
        self.t_width = time + 0.5;
    }
};

// Explode like Maulotaur firewall. PM:  Don't reflect firewall.
void() Firewall_Touch = { // [FUNCTION]
    local float pass, pc;
    local vector spot, mp;

    pass = 0;
    traceline (self.origin, self.origin - '0 0 600', TRUE, self); // If explosion cannot hit the target, don't explode.
    if (trace_fraction == 1) pass = 1; // No flame on ground.
    else {
        spot = trace_endpos;
        pc = pointcontents (spot);
        if ((pc != CONTENT_EMPTY) && (pc != CONTENT_LAVA))
            pass = 1; // Flame in void, water, or sky.
        else if (other.flags & FLx_CREATURE) {
            if (fabs(other.origin_z - spot_z) > (self.dmg + 40))
                pass = 1; // Too far away to damage.
            else {
                mp = Midpoint (other);
                traceline (spot, mp, TRUE, self);
                if (trace_fraction < 1) pass = 1; // Blocked
            }
        }
    }
    if (pass) { // Explosion ineffective, convert to notouch version.
        self.movetype     = MOVETYPE_NOCLIP;
        self.solid        = SOLID_NOT;
        self.touch        = SUB_Null;
        return;
    }

    self.touch = SUB_Null; // Stack overflow prevention.
    self.enemy = world;
	R_Exp3(spot);
	Tent_Explosion(spot);
	if (other.takedamage) T_Damage(other,other,self.owner,self.dmg,DAMARMOR);
	T_RadiusDamage(self,self.owner,self.dmg,self.owner,DAMAGEALL);
	self.think = SUB_Remove;
	self.nextthink = time + 0.1;
};

void() faBladeTouch =  { // [FUNCTION]
	local float damg = 0.00000;

   if (other == self.owner)  return;
   if (pointcontents(self.origin) == CONTENT_SKY) { remove(self); return; }

   damg = random(8.00000,16.00000);
   if ( other.health ) T_Damage ( other, self, self.owner, damg, DAMARMOR);
   sound ( self, CHAN_WEAPON, "hexen2/weapons/expsmall.wav", 1.00000, ATTN_NORM);
   self.origin = (self.origin - (8.00000 * normalize ( self.velocity)));
   //CreateGreenSmoke ( self.origin, '0.00000 0.00000 8.00000', (HX_FRAME_TIME * 4.00000));
   remove(self);
};

void() faSpellTouch = { // [FUNCTION]
	local float damg;

	if (other == self.owner) return;
	if ((pointcontents(self.origin) == CONTENT_SKY)) { remove(self); return; }

	damg = random(12,22);
	if ( other.health ) T_Damage ( other, self, self.owner, damg, DAMARMOR);
	T_RadiusDamage ( self, self.owner, damg, other, DAMAGEALL);
	sound ( self, CHAN_WEAPON, "hexen2/weapons/explode.wav", 1.00000, ATTN_NORM);
	self.origin = self.origin - (8 * normalize(self.velocity));
	FlareGlitter();
	remove(self);
};

void() WandSpark_Touch = { // [FUNCTION]
    if (pointcontents(self.origin) == CONTENT_SKY) {remove (self); return;}
    if (Reflected()) return;

    self.touch = SUB_Null; // Stack overflow prevention.
    if (other.takedamage) T_Damage (other, self, self.master, self.dmg, DAMARMOR); // Hit something that bleeds
    self.origin = self.origin - 8*normalize(self.velocity);
    BecomeFancy (X32_CUT_ORANGE, 4);
};

void() Touch_HazardProjectile = {
	if (self.touchedvoid) return;				// Marked for removal
	if (check_skycontent(self.origin)) { HazardProjectile_Finished(self); return;}
	if (other == self.owner) return;			// Touching attacker, do nothing
	if (other.solid == SOLID_TRIGGER) return;	// trigger field, do nothing
	if (other.classgroup == CG_PROJHAZARD) return;	// Touching other hazards
	if (self.attack_finished < time) return;	// Hazard finished, no more touch
	if (self.pain_finished > time) return;		// Slow down touch damage

	self.velocity = self.velocity * 0.5;	// Slow down velocity bounce
	self.pain_finished = time + 0.1;		// Slow down touch/pain cycle
	self.part_qctrail = FALSE;				// No more particle trail effect

	// Switch to trigger type so that monsters can interact with them
	// Need to reset size, so the solid type can be changed to trigger
	if (self.solid != SOLID_TRIGGER) {
		self.solid = SOLID_TRIGGER;
		setsize(self, self.bbmins, self.bbmaxs);
	}
	
	// Check if can damage target
	if (other.takedamage) {
		// Check target is the same group type as owner of projectile
		// This is to prevent groups of the same enemy type killing each other!
		if (other.classgroup == self.owner.classgroup) self.dmg = 0;
		else {
			// DMG easy=1-2, normal=1-3, hard=1-4, nm=1-5, evil=1-6
			self.dmg = 1;
			self.cnt = 1 + skill;
			// Loop through base + random damage
			while (self.cnt > 0) { 
				self.dmg = self.dmg + random(); 
				self.cnt = self.cnt - 1;
			}
		}

		// LAVA SHIELD Resistance = 50% fire/lava attacks
		if (other.flags & FL_CLIENT && other.moditems & IT_ARTLAVASHIELD) {
			PlayLavaShieldSound(other);
			if (other.resist_fire > 0) self.dmg = self.dmg * (1-other.resist_fire);
			else {
				if (random() < (self.dmg+1)*0.01) Burn_Add (other, self, self.dmg); // Chance to burn equals (damage + 1)%.  E.g., 9 damage = 10%. Yes, use 'damage' and not 'take'.
			}
			if (self.dmg > 0) self.dmg = floor(self.dmg * 0.5);
		}
	
		// Add any monster infighting modifiers (no negative or zero).  Round down the damage to integers (can cause logic issues)
		if (self.infightextra <= 0) self.infightextra = 1;
		if (self.dmg > 0) self.dmg = floor(self.infightextra * self.dmg);

		// FINALLY any damage?
		if (self.dmg > 0) {
			// Spawn some blood, cause harm and play a sound!
			spawn_touchblood (self, other, self.dmg);
			T_Damage (other, self, self.owner, self.dmg, DAMARMOR);
			// Play touch sound if defined? (limit replay)
			if (self.part_soundtouch != "" && self.part_soundtimer < time) {
				self.part_soundtimer = time + 0.3;
				self.volume = 0.5 + (random() * 0.5);
				sound (self, CHAN_WEAPON, self.part_soundtouch, self.volume, ATTN_FEET);
			}
		}
	} else {
		// Any impact/miss sound defined?
		if (self.part_soundmiss != "") {
			sound (self, CHAN_WEAPON, self.part_soundmiss, 1, ATTN_FEET);
			// trigger sound once
			self.part_soundmiss = "";
		}
	}
};