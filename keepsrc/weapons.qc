//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: All and Qmaster
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
// Function count: 54
//
// Implements: Weapons System for the Player
//
// Description:
// W_SetCurrentAmmo   - Update HUD icons based on self.weapon value
// W_BestWeapon       - returns best weapon LG > SNG > SSG > NG > SG > Axe
//                      interesting that the function does not return GL/RL
// W_CheckNoAmmo      - Ammo check for attack function
// W_Attack           - Main function that fire weapons (player animations).
//                      Typically wakes up nearby monsters
// W_ChangeWeapon     - Change weapon based on availabilty and ammo
// CycleWeaponCommand - Move forward or backward through active weapons
// CycleWeaponReverseCommand
// W_WeaponFrame      - Called every frame, catches impulse event
// SuperDamageSound   - Plays quad damage sound
//=============================================================================

entity multi_ent;
float multi_damage;
void (vector pos) placebullethole

// Well, we can either do these 55 someodd declarations for player stuff here, or alternatively declare weapon stuff in player.qc and move it up in the progs.src ordering.
void(entity targ) remoteplayer_run;
void() player_axe1;				// Different Axe animations
void() player_axeb1;
void() player_axec1;
void() player_axed1;
void() player_axee1;
void() player_axeoldc1;			// Different Axe animations for original axe
void() player_axeoldd1;
void() player_sg1;				// Shotgun
void() player_supersg1;			// Super Shotgun
void() player_nail1;			// Nailgun
void() player_snail1;			// Super Nailgun
void() player_rocket1;			// Rocket Launcher
void() player_grenade1;			// Grenade Launcher
void() player_multi_rocket1;	// Multi-Rocket Launcher
void() player_multi_grenade1;	// Multi-Grenade Launcher
void() player_light1;			// Thunderbolt
void() player_plasma1;			// Plasma Gun
void() player_plasmalight1;		// Rogue Plasma Gun
void() player_ssgreset;			// Reset weaponframe
void() player_sgreset;
void() player_grenreset;
void() player_rockreset;
void() player_crossbow1;
void() player_crossbow2;
void() player_crossbow3;
void() player_crossbow4;
void() player_crossbow5;
void() player_crossbow6;
void() player_laser1;
void() player_hammer1;
void() player_mjolnir1;
void() player_prox_grenade1;
void() player_wand1;
void() player_grapple1;
void() player_grapple3;
void() player_chainlight1;
void() player_blast1;
void() player_saw1;
void() player_bfg1;
void() player_airgun1;
void() player_failedairgun1;
void() player_xbow1;
void() W_FireSparks;
void(entity ent) ReflectSound;
void(float pause, void() thinkst) Echo_Shot;
float Hip_ThrewMjolnir();
void(vector lstart, entity lsource, float ldamage) LightningReflection;
void() player_lava_nail1;
void() player_lava_snail1;

// Weapon ammo run out and switching to next best weapon
void(float wait_time) forceweaponswitch = { // [FUNCTION]
	local float nextweap;

	if (self.flags & FL_MONSTER) return;

	nextweap = W_BestWeapon(self); // has the player run out of ammo? work out next best weapon
	if (self.weapon != nextweap) { // Does the player need to switch weapons?
		self.weapon = nextweap;
		W_SetCurrentAmmo(self);
	}
};

// Hipnotic Laser Cannon
void (float stat) HIP_FireLaser = { // [FUNCTION]
	local vector org, dir, out;
	local float ofs, aofs, glow;

	if (!self.button0) { player_run(); return; }

	if ((self.weapon == IT2_LASER_CANNON && !self.selfweaponismoditems) && (self.ammo_cells < TRUE) ) {
		self.weapon = W_BestWeapon(self);
		W_SetCurrentAmmo(self);
		return ;
	}

	if ((self.weapon == IT_SHOTGUN && !self.selfweaponismoditems) && (self.ammo_shells < TRUE) ) { // Blaster uses this
		self.weapon = W_BestWeapon (self);
		W_SetCurrentAmmo (self);
		return ;
	}

	self.effects = (self.effects | EF_MUZZLEFLASH);
	makevectors (self.v_angle);
	ofs = MOVETYPE_TOSS;
	out = v_forward;
	out_z = FALSE;
	out = normalize (out);
	org = ((self.origin + ((STAT_TOTALMONSTERS - ofs) * v_up)) + (STAT_TOTALMONSTERS * out));
	dir = aim (self,1000.000);
	aofs = (ofs * 0.707);
	if (stat == FALSE) {
		self.ammo_cells = (self.ammo_cells - TRUE);
		self.currentammo = (self.currentammo - TRUE);
		org = (org + (aofs * v_right));
		org = (org - (aofs * v_up));
		HIP_LaunchLaser (org,dir,FALSE);
		org = (org - ((FL_SWIM * aofs) * v_right));
		HIP_LaunchLaser (org,dir,FALSE);
	} else if (stat == TRUE) {
		self.ammo_cells = (self.ammo_cells - TRUE);
		self.currentammo = (self.currentammo - TRUE);
		org = (org + (ofs * v_up));
		if ( (random () < 0.100) ) {
			HIP_LaunchLaser (org,dir,TRUE);
			newmis.dmg = 25.000;
		} else {
			HIP_LaunchLaser (org,dir,FALSE);
		}
	} else { // Using the modified shotgun-turned-blaster model...
		org = self.origin + '0 0 12';
		if (stat == 2 && self.tracer_time <= time) {
			glow = TRUE;
			self.tracer_time = time + 0.5;
		}
		self.ammo_shells = (self.ammo_shells - TRUE);  // blaster uses shells??  well, I guess that's fine whatevs
		self.currentammo = (self.currentammo - TRUE);
		HIP_LaunchLaser (org, dir, glow);
		newmis.volume = 0; // No random chance of removal on impact.  Spread gun looks bad unless v_model is wider.
	}
	self.punchangle_x = CONTENT_EMPTY;
};

void () HIP_FireMjolnir = { // [FUNCTION]
	local vector org, source, tvec;
	local float damage;
	local entity tester;

	// Since throwing the hammer on frame three can be almost impossible with
	// lag, allow throwing on frame four, even if animation would make the
	// throw appear a bit late.  Better to have forgiving controls and happy
	// players than "fake difficulty" for animation's sake.
    if (Hip_ThrewMjolnir()) return;

	W_Reload(0.4);
	source = (self.origin + '0.000 0.000 16.000');
	makevectors (self.v_angle);
	traceline (source,(source + (v_forward * RANGE_PLAYAXE)),FALSE,self);
	if ( ((trace_fraction == TRUE) && (self.ammo_cells >= 15.000)) ) {
		source = (source + (v_forward * RANGE_PLAYAXE));
		traceline (source,(source - (v_up * 50.000)),FALSE,self);
		if ( ((trace_fraction > 0.300) && (trace_fraction < TRUE)) ) {
			HIP_FireMjolnirLightning();
			W_Reload(1);
			return;
		}
	}
	org = (trace_endpos - (v_forward * 4));

	// REFLECTION stuff like blue shields
	if (trace_ent.reflectaxe) Resist_Effects(trace_ent,org,VEC_ORIGIN,0,AM_NONE,SOUND_AXE_STONE,"");

	// BLEEDING/DAMAGE stuff with unique impact sounds
	else if (trace_ent.takedamage) {
		damage = 50;
		if ((trace_ent.classgroup == CG_ZOMBIE) && trace_ent.classname != "monster_mummy") damage = trace_ent.max_health * 2;
		trace_ent.axhitme = TRUE;
		SpawnBlood (trace_ent, org,v_forward,damage);
		HIP_FireMjolnirLightning(); dprint("Hit targ slam takedamage\n");
		T_Damage (trace_ent,self,self,damage, DAMARMOR);
	} else {
		if (trace_fraction != TRUE) {
			sound (self,CHAN_WEAPON,"hipnotic/weapons/mjoltink.wav",TRUE,ATTN_NORM);
			tester = spawn();
			setorigin(tester,org);
			setsize(tester,'-4 -4 0', '4 4 16');
			tvec = tester.origin;
			tvec_z = tvec_z + 10;
			tracebox(org,'-4 -4 0', '4 4 16',tvec, TRUE, tester);
			if (trace_fraction == TRUE) HIP_FireMjolnirLightning ();
			remove(tester);
			Tent_Point(TE_GUNSHOT,org);
		} else {
			sound (self,CHAN_WEAPON,"knight/sword1.wav",TRUE,ATTN_NORM);
		}
   }
   W_Reload(0.4);
};

// Initially written by Qmaster and tested in the Keep mod

void (entity current, float life) SpawnLightningTrace = { // [FUNCTION]
	float dmg;
	WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST,TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST,current);
	WriteCoord (MSG_BROADCAST,current.origin_x);
	WriteCoord (MSG_BROADCAST,current.origin_y);
	WriteCoord (MSG_BROADCAST,current.origin_z);
	WriteCoord (MSG_BROADCAST,self.origin_x);
	WriteCoord (MSG_BROADCAST,self.origin_y);
	WriteCoord (MSG_BROADCAST,self.origin_z);
	sound (self,CHAN_VOICE,"weapons/lhit.wav",TRUE,ATTN_NORM);
	if (current.classgroup == CG_ZOMBIE) dmg = current.max_health; // poor zombies die in so many ways
	else dmg = 30;

	LightningDamage(self.origin,current.origin,self,dmg);
};

void (vector startpos, float radius, float life) SpawnOrbLightning = { // [FUNCTION]
	local entity head;
	local vector org;

	head = findradius(startpos,radius); // find EVERYTHING within 250 unit radius
	while (head) {
		// Can be damaged and NOT immune to radius (splash) damage
		if ((head.takedamage > 0) && (head.flags & FLx_CREATURE)) {
			org = head.origin + (head.mins + head.maxs)*0.5;
			if (head.health > 0) SpawnLightningTrace(head,life); // create initial lightning for any monsters found
		}
		head = head.chain;
	}
};

void () lightning_orb_death = { // [FUNCTION]
	local entity light;

	light = spawn ();
	light.origin = self.origin;
	light.model = "progs/drake/s_fancy.spr";
	setmodel(light,light.model);
	setsize(light,VEC_ORIGIN,VEC_ORIGIN);
	light.solid = SOLID_NOT;
	light.spritestarted = FALSE;
	light.pos1 = '5 1 0'; //start frame, alpha, null
	light.idleweaponframe = 9; // endframe
	light.think = env_sprite_loop;
	light.spawnflags = light.spawnflags | SPRITE_PLAYONCE; // So it only plays sprite once.
	light.impulse = 0.05; // Fast think for sprite animation.
	light.use = SUB_Remove;
	light.nextthink = self.nextthink = time + 0.1;
	sound (light,CHAN_AUTO,"doom/bfg.wav",TRUE,ATTN_NORM); // death burst
	T_RadiusDamage(self, self.owner, 40,world,DAMAGEALL); // minor damage from exploding
	SpawnOrbLightning(self.origin,250,0.4);
	self.think = SUB_Remove;
};



void () lightning_orb_think = { // [FUNCTION]
	if (self.attack_finished < time) { self.think = lightning_orb_death; self.nextthink = time + 0.1; return; }

	SpawnOrbLightning(self.origin,250,1.9);
	self.think = lightning_orb_think;
	self.nextthink = time + 0.1;
};

void () SpawnLightningOrb = { // [FUNCTION]
	local entity light;

	light = spawn ();
	light.origin = trace_endpos;
	light.origin_z = light.origin_z + 32; //move it up a tad from the hit point
	light.flags = FALSE;
	light.owner = self;
	light.struck_by_mjolnir = TRUE;
	light.model = "progs/s_light4.spr";
	setmodel(light,light.model);
	setsize(light,VEC_ORIGIN,VEC_ORIGIN);
	light.solid = SOLID_NOT;
	light.think = lightning_orb_think;
	light.attack_finished = time + 1.9;
	light.nextthink = (time + 0.5);
	sound (light,CHAN_AUTO,"zerstorer/ambience/thunder2.wav",TRUE,ATTN_NORM);
};

void () HIP_FireMjolnir2 = { // [FUNCTION]
	local vector org, source;
	local float damage;

	W_Reload(0.4);
	source = (self.origin + '0.000 0.000 16.000');
	makevectors (self.v_angle);
	traceline (source,(source + (v_forward * RANGE_PLAYAXE)),FALSE,self);
	if ( ((trace_fraction == TRUE) && (self.ammo_cells >= 15.000)) ) {
		source = (source + (v_forward * RANGE_PLAYAXE));
		traceline (source,(source - (v_up * 50.000)),FALSE,self);
		self.ammo_cells = (self.ammo_cells - 15.000);
		self.currentammo = (self.currentammo - 15.000);
		SpawnLightningOrb();
		W_Reload(0.8);
		return;
	}
	org = (trace_endpos - (v_forward * 4));
	if ( trace_ent.takedamage ) {
		if (self.ammo_cells >= 15) damage = 300.000;
		else damage = 80;

		trace_ent.axhitme = TRUE;
		SpawnBlood(trace_ent, org,v_forward,damage);
		T_Damage (trace_ent,self,self,damage, DAMARMOR);
		if (self.ammo_cells >= 15) {
		SpawnLightningOrb();
		self.ammo_cells = (self.ammo_cells - 15.000);
		self.currentammo = (self.currentammo - 15.000);
	}
	} else {
		if ( (trace_fraction != TRUE) ) {
			sound (self,CHAN_WEAPON,"hipnotic/weapons/mjoltink.wav",TRUE,ATTN_NORM); //tink, nothin
			Tent_Point(TE_GUNSHOT,org);
		} else sound (self,CHAN_WEAPON,"knight/sword1.wav",TRUE,ATTN_NORM); //swoosh
	}
	W_Reload(0.4);
};

void () W_FireMjolnir = { // [FUNCTION]
	if (world.hipnoticoptions & HIPNOTIC_OLDMJOLNIR) {
		HIP_FireMjolnir();
	} else {
		if (self.tome_finished > 0) {
			HIP_FireMjolnir2(); //adaya bfg lightning ball spawn!
		} else { 
			HIP_FireMjolnir(); // Standard Drake Mjolinr throwing
		}
	}
};

void () W_FireProximityGrenade = { // [FUNCTION]
	local entity missile;

	if (self.attack_finished > time) return;
	if (self.ammo_rockets < 1) { forceweaponswitch(0.2); return;}
	NumProximityGrenades = (NumProximityGrenades + TRUE);
	self.ammo_rockets = (self.ammo_rockets - TRUE);
	self.currentammo = (self.currentammo - TRUE);
	sound (self,CHAN_WEAPON,"hipnotic/weapons/proxbomb.wav",TRUE,ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn ();
	missile.classgroup = CG_PROJGRENADES;
	missile.owner = self;
	missile.lastvictim = self;
	missile.movetype = MOVETYPE_TOSS;
	missile.solid = SOLID_BBOX;
	missile.classname = "proximity_grenade";
	missile.takedamage = DAMAGE_NO;
	missile.health = MOVETYPE_FLY;
	missile.state = FALSE;
	makevectors (self.v_angle);
	if ( self.v_angle_x ) {
		missile.velocity = ((((v_forward * 600.000) + (v_up * 200)) + ((crandom () * v_right) * MOVETYPE_BOUNCE)) + ((crandom () * v_up) * MOVETYPE_BOUNCE));
	} else {
		missile.velocity = aim (self,10000.000);
		missile.velocity = (missile.velocity * 600.000);
		missile.velocity_z = 200;
	}
	missile.avelocity = '100.000 600.000 100.000';
	missile.angles = vectoangles (missile.velocity);
	missile.touch = ProximityGrenadeTouch;
	missile.nextthink = (time + FL_SWIM);
	missile.delay = ((time + 15.000) + (MOVETYPE_BOUNCE * random ()));
	missile.think = ProximityBomb;
	missile.th_die = ProximityGrenadeExplode;
	setmodel (missile,"progs/hipnotic/proxbomb.mdl");
	setorigin (missile,self.origin);
	setsize (missile,'-1.000 -1.000 -1.000','1.000 1.000 1.000');
	W_Reload(0.6);
};

void() W_FireAxe = { // [FUNCTION]
	local vector source, org, vec;
	local float src_dist, dotprod, axedmg;
	local entity onflr;

	makevectors (self.v_angle);				// Player forward angle
	source = self.origin + '0 0 16';		// Move source point up body

	if (self.flags & FL_GODMODE && self.flags & FL_FLY) {
		traceline (source, source + (v_forward* RANGE_PLAYAXE), FALSE, self);
		if (trace_fraction < 1.0) {
			if (trace_ent.flags & FL_MONSTER && trace_ent.health > 0) {
				dprint("\n\b[DEBUG]\b system active, changing monster\n");
				trace_ent.debuglvl = 1 - trace_ent.debuglvl;
			}
		}
		return;
	}		 

	if (self.moditems & IT_UPGRADE_AXE || self.tome_finished) {
		// See if there are any bodies lying around
		onflr = find(world, bodyonflr, MON_ONFLR);
		while (onflr) {
			src_dist = vlen(source - onflr.origin);
			if (src_dist < RANGE_CHOPAXE) {			// Is the body close to the player?
				org = onflr.origin - '0 0 16';		// move origin close to floor
				makevectors (self.v_angle);			// Calculate viewing angle
				vec = normalize (org - self.origin);
				dotprod = vec * v_forward;
				if (dotprod > 0.6) {				// Is the body infront of the player
					onflr.origin = org;				// Move gib closer to floor
					monster_flrbody_gib(onflr, axedmg*4); // Now a function in ai_gibs since it's used by boil explosion as well
					self.show_hostile = time + 1;	// wake monsters up, we hit stuff
					return;														// Finished
				}
			}
			onflr = find(onflr,bodyonflr, MON_ONFLR); // See if there are anymore bodies close by
		}
	}

	traceline (source, source + (v_forward* RANGE_PLAYAXE), FALSE, self); // Trace forward and see if the axe has hit anything?
	if (trace_fraction == 1.0) return;	// No contact, no hit

	self.show_hostile = time + 1;	// wake monsters up, we hit stuff
	org = trace_endpos - v_forward*4;	// Back 4 units to spawn blood
	if (trace_ent.reflectaxe) Resist_Effects(trace_ent,org,VEC_ORIGIN,0,AM_NONE,SOUND_AXE_STONE,""); // REFLECTION stuff like blue shields
	else if (trace_ent.takedamage) { // BLEEDING/DAMAGE stuff with unique impact sounds
		// Mark the monster with type of axe used and change damage
		if (self.moditems & IT_UPGRADE_AXE) {
			axedmg = DAMAGE_PLAYAXE2; trace_ent.axhitme = 2;
		} else {
			axedmg = DAMAGE_PLAYAXE1; trace_ent.axhitme = 1;
		}
		if (self.tome_finished) {
			axedmg = axedmg * 2;
			if (trace_ent.classgroup == CG_ZOMBIE) axedmg = 120;
			SpawnMeatSpray(self,trace_ent,(crandom() * 300));
			SpawnMeatSpray(self,trace_ent,(crandom() * 300));
			if (self.moditems & IT_UPGRADE_AXE) {
				SpawnMeatSpray(self,trace_ent,(crandom() * 300));
				SpawnMeatSpray(self,trace_ent,(crandom() * 300));
			}
		}

		SpawnBlood (trace_ent, org, '0 0 1', axedmg); // Spamn blood always up so player can see it
		T_Damage (trace_ent, self, self, axedmg, DAMARMOR);
		if (trace_ent.flags & FL_MONSTER) { // Monster impact sounds (fleshy stuff)
			if (random() < 0.5) sound (self, CHAN_WEAPON, GIB_SOUND_HEAVY, 1, ATTN_NORM);
			else sound (self, CHAN_WEAPON, GIB_SOUND_HEAVY2, 1, ATTN_NORM);
		} else if (trace_ent.classtype == CT_FUNCBREAK) { // Breakable impact sounds (def=stone/brick)
			if (trace_ent.style == BTYPE_WOOD) 
				sound (self, CHAN_WEAPON, SOUND_AXE_WOOD, 1, ATTN_NORM);
			else if (trace_ent.style == BTYPE_GLASS) 
				sound (self, CHAN_WEAPON, SOUND_AXE_GLASS, 1, ATTN_NORM);
			else if (trace_ent.style == BTYPE_METAL) 
				sound (self, CHAN_WEAPON, SOUND_AXE_METAL, 1, ATTN_NORM);
			else if (trace_ent.style == BTYPE_FLESH) 
				sound (self, CHAN_WEAPON, SOUND_AXE_FLESH, 1, ATTN_NORM);
			else
				sound (self, CHAN_WEAPON, SOUND_AXE_STONE, 1, ATTN_NORM);
		} else if (trace_ent.classtype == CT_FUNCPUSHABLE) { // Pushable impact sounds (def=stone/brick)
			if (trace_ent.style == PTYPE_WOOD) 
				sound (self, CHAN_WEAPON, SOUND_AXE_WOOD, 1, ATTN_NORM);
			else if (trace_ent.style == PTYPE_GLASS) 
				sound (self, CHAN_WEAPON, SOUND_AXE_GLASS, 1, ATTN_NORM);
			else if (trace_ent.style == PTYPE_METAL) 
				sound (self, CHAN_WEAPON, SOUND_AXE_METAL, 1, ATTN_NORM);
			else
				sound (self, CHAN_WEAPON, SOUND_AXE_STONE, 1, ATTN_NORM);
		}
	} else {
		// WORLD OBJECT : Target does not bleed, play stone hitting sound
		sound (self, CHAN_WEAPON, SOUND_AXE_STONE, 1, ATTN_NORM);
		Tent_Point(TE_GUNSHOT,org);
	}
};

// OLD STYLE BULLET SYSTEM (HITSCAN)
void() ClearMultiDamage = { // [FUNCTION]
    multi_ent = world;
    multi_damage = 0;
};

void() ApplyMultiDamage = { // [FUNCTION]
    if (!multi_ent) return;
    T_Damage (multi_ent, self, self, multi_damage,DAMARMOR);
};

void(entity hit, float damage) AddMultiDamage = { // [FUNCTION]
    if (!hit) return;
    
    if (hit != multi_ent) {
        ApplyMultiDamage ();
        multi_damage = damage;
        multi_ent = hit;
    }  else {
        multi_damage = multi_damage + damage;
	}
};

void(vector org, float marker_time) MarkAttack = { // [FUNCTION]
	newmis = spawn();
	newmis.classtype = CT_DEVMARKER;
	newmis.movetype = MOVETYPE_NONE;
	newmis.solid = SOLID_NOT;
	setmodel(newmis, MODEL_BROKEN);
	newmis.skin = rint(random()*7);
	setorigin(newmis, org);
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	newmis.think = SUB_Remove;
	newmis.nextthink = time + marker_time;
};

void(float damage, vector dir) TraceAttack = { // [FUNCTION]
	local vector vel, org;
	
	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;
	org = trace_endpos - dir*4;
	if (!check_skycontent(org)) { // Check for sky content? skies don't impact or bleed
		if (trace_ent.takedamage) {
			if (trace_ent.resist_shells > 0) Resist_Effects(trace_ent,org,vel,damage,AM_SHELLS,trace_ent.pain_sound,""); // Show bullet resistance as small blood+gunshot+smoke
			else {
				if (trace_ent.flags & FL_MONSTER) SpawnBlood (trace_ent, org, vel*0.2, damage*2); // Hitting monsters does twice the amount of blood effects
				else SpawnBlood (trace_ent, org, vel*0.2, damage);
			}
			AddMultiDamage (trace_ent, damage); // Keep adding up the damage
			if (trace_ent.classtype == CT_TARGETDUMMY) MarkAttack(org, trace_ent.wait); // Check for target dummy (manually create marker)
		} else Tent_Point(TE_GUNSHOT,org); // Hit something that does not bleed (often world)
	}
};

void(float shotcount, vector spread) FireBullets = { // [FUNCTION]
	local vector direction, src, dir;
	local float addedtime, bullet;
	
	bullet = 0;
	makevectors(self.v_angle);
	if (self.flags & FL_CLIENT) {
		// Auto aim assist (builtin function 44)
		if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN) dir = aim(self, SPEED_PLAYAIM);
		// Straight line forward where crosshair is pointing
		else dir = normalize(v_forward * SPEED_PLAYAIM);
	} else {
		// A monster attacking a monster will not dodge
		if (self.enemy.flags & FL_MONSTER) dir = normalize(self.enemy.origin - self.origin);
		else {
			// fire somewhat behind the player
			// so a dodging player is harder to hit
			dir = self.enemy.origin - self.enemy.velocity*0.2;
			dir = normalize(dir - self.origin);
		}
	}

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();
	while (shotcount > 0) {
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;
		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0) {
			if (self.tome_finished) {
				if (shotcount == 1) addedtime = 0;
				else addedtime = shotcount * 0.05;
				TraceExploAttack(EXSHELL_DAMAGE, direction, addedtime);
			} else {
				if (self.classtype == CT_MONENF_GUNNER) TraceAttack(9, direction); // More damage
				else TraceAttack(DAMAGE_SHELL, direction);

				if (!bullet && (trace_ent == world) && (world.hipnoticoptions & HIPNOTIC_BULLETHOLES)) { // Default is off.
					placebullethole(trace_endpos);
					bullet = TRUE;
				}
			}
		}
		shotcount = shotcount - 1;
	}
	ApplyMultiDamage ();
};

void() W_FireShotgun = { // [FUNCTION]
	local vector spread_pat;
	local float shotcnt;

	if (self.attack_finished > time) return;
	if (self.ammo_shells < 1) { forceweaponswitch(0.2); return;} // Ran out of ammo, switch to next best weapon
	
	// Change weapon sound if using Projectile Pellets.
	if (!query_configflag(SVR_SHOTGPROJ)) sound (self ,CHAN_WEAPON, "ad171/weapons/sg2.wav", 1, ATTN_NORM); // ever so subtle sound of a shell ejecting added to normal
	else sound (self ,CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM); // vanilla single barrel shotgun
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	if (self.perms & POW_SHOTTYMAN) W_Reload(0.3);
	else W_Reload(0.5);

	self.punchangle_x = -2;
	if (self.classtype != CT_MONGREMLIN) player_sgreset(); // reset weaponframe
	
	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	if (self.moditems & IT_ARTSHARP) spread_pat = SPREAD_SG2;
	else spread_pat = SPREAD_SG;

	shotcnt = QUANTITY_SG;
	if (self.tome_finished) shotcnt = 3; // Extra for tome.
	if (query_configflag(SVR_SHOTGPROJ)) // Choose between a projectile or hitscan system
		FireBullets (shotcnt, spread_pat);
	else {
		Launch_Shells(shotcnt, spread_pat, CT_PROJ_SG);
		Launch_ShellCasing(1);	// Shell casings
	}
};

void() W_FireSuperShotgun = { // [FUNCTION]
	local float ssg_qty, shell_qty;
	local vector spread_pat;
	
	// Ran out of ammo, switch to next best weapon
	if (self.attack_finished > time) return;
	if (self.ammo_shells < 2 && self.classtype != CT_MONGREMLIN) { forceweaponswitch(0.2); return;}

	makevectors (self.v_angle);		// Special view angle for the player

	// if shot in the air - do Newton's 3rd law. (from zerstorer)
	if (!(self.flags & FL_ONGROUND)) self.velocity = self.velocity - (v_forward * 35);
	
	// Change weapon sound if using Shotgun Upgrade or Projectile Pellets
	// IMPORTANT - default for Projectile Pellets is ON = 0
	if (self.moditems & IT_UPGRADE_SSG || !query_configflag(SVR_SHOTGPROJ)) sound (self ,CHAN_WEAPON, "ad171/weapons/ssg2.wav", 1, ATTN_NORM);
	else sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);

	self.effects = self.effects | EF_MUZZLEFLASH;
	if (self.perms & POW_SHOTTYMAN) W_Reload(0.5);
	else W_Reload(0.7);

	self.punchangle_x = -4;
	if (self.classtype != CT_MONGREMLIN)
		player_ssgreset();			// reset weaponframe
	shell_qty = 2;				// Standard shell casings quantity

	// If the player has the Widowmaker, setup triple shot
	if (self.moditems & IT_UPGRADE_SSG) {
		// Only got 2 shells in the gun (reduced damage)
		if (self.ammo_shells < 3) {
			self.ammo_shells = 0;
			ssg_qty = QUANTITY_SSG;
		} else {
			// 150% damage
			shell_qty = 3;
			self.ammo_shells = self.ammo_shells - 3;
			ssg_qty = QUANTITY_SSG * 1.5;
		}
	} else {
		// Default ID SSG damage
		self.ammo_shells = self.ammo_shells - 2;
		ssg_qty = QUANTITY_SSG;
	}

	self.currentammo = self.ammo_shells;
	if (self.moditems & IT_ARTSHARP) spread_pat = SPREAD_SSG2;
	else spread_pat = SPREAD_SSG;

	if (self.tome_finished) {
		if (self.moditems & IT_UPGRADE_SSG) ssg_qty = 11; // Widowmaker (Triple-barreled)
		else ssg_qty = 7; // Double-barreled Shotgun
	}

	// Choose between a projectile or hit-scan system
	if (query_configflag(SVR_SHOTGPROJ)) {
		FireBullets (ssg_qty, spread_pat);	// Hit-scan
	} else {
		Launch_Shells(ssg_qty, spread_pat, CT_PROJ_SSG);
		Launch_ShellCasing(shell_qty);
	}
};

void(float oz, float ox) W_FireSpikes = { // [FUNCTION]
	local vector org, dir;
	local entity spike1, spike2;

	if (self.ammo_nails < 1) { forceweaponswitch(0.2); return; } // If run out of ammo, switch weapons to next best

	self.effects = self.effects | EF_MUZZLEFLASH;
	W_Reload(0.2);
	self.punchangle_x = -2;
	makevectors (self.v_angle);
	if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN) dir = aim(self, SPEED_PLAYSPIKE); // Check for auto aim state.  Auto aim assist (builtin function 44)
	else dir = normalize(v_forward * SPEED_PLAYSPIKE); // Straight line forward where crosshair is pointing

	// SNG setup, sound and ammo change
	if (self.ammo_nails > 1 && self.weapon == IT_SUPER_NAILGUN) {
		sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
		if (self.perms & POW_DOUBLE) self.currentammo = self.ammo_nails = self.ammo_nails - 1;
		else self.currentammo = self.ammo_nails = self.ammo_nails - 2;

		// Original setup - org = self.origin + '0 0 16';
		// - SNG projectile offset idea by Kinn
		// org = self.origin + dir*14 + v_right*ox;
		// org_z = org_z + oz;
		// The SNG offset idea was hiting far below the crosshair
		// which was causing impact problems.
		// Kept the barrel offset, removed the Z adjustment instead!
		org = self.origin + '0 0 16' + v_right*ox;
		if (self.tome_finished) {
			// Update 2/14/10:  Minigun mode -- fire three shots per 0.1 sec.
			org = self.origin + '0 0 16' + v_up*fabs(ox);
			Piercer_Trace (org, org + dir, self, SPIKEY_DAMAGE, self, TE_GUNSHOT);
			Echo_Shot(1/30, W_EchoSpike_Down);
			Echo_Shot(2/30, W_EchoSpike_Up);
			StackDamage_Clear();
		} else { // Normal Super Nailgun Fire
			if (world.copperoptions & COPPER_TWOSHOT_PERFORATOR) { // Copper variant fires more nails instead of one super one
				launch_projectile (org + vecrand(0,1.25,1), dir, CT_PROJ_NG, (940 + random()*30));
				if (self.super_damage_finished > time) {
					newmis.dmg = DAMAGE_SNGSPIKE; // So zombies still gib at 72 with quad.  Yes Copper did this.
					spike1 = newmis;
				}
				launch_projectile (org + vecrand(0,1.25,1), dir, CT_PROJ_NG, (1020 + random()*30));
				if (self.super_damage_finished > time) {
					newmis.dmg = DAMAGE_SNGSPIKE; 
					spike2 = newmis;
					spike1.buddy = spike2; // First one to hit nerfs its buddy
					spike2.buddy = spike1; // Race ya!
					dprint("Buddy nails setup!\n");
				}
			} else launch_projectile (org, dir, CT_PROJ_SNG, SPEED_PLAYSPIKE); // Normal Normal Super Nailgun Fire
		}
	} else { // NG setup, sound and ammo change
		sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
		if (self.perms & POW_DOUBLE) {
			if (self.nailcosthalf) {
				self.currentammo = self.ammo_nails = self.ammo_nails - 1;
				self.nailcosthalf = 0;
			} else self.nailcosthalf = 1;
		} else self.currentammo = self.ammo_nails = self.ammo_nails - 1;

		
		// Original setup - org = self.origin + '0 0 16' + v_right*ox;
		// - NG projectile offset idea by Kinn
		// org = self.origin + '0 0 8' + dir*14 + v_right*ox;
		org = self.origin + '0 0 16' + v_right*ox;
		if (self.tome_finished) { // ToP makes nailguns fire armor-piercing, hitscan bullets.
			ox = ox * 2;    // Hitscan with no bonus, so extend offset.
			dir = aim (self, 100000) * SPIKEY_RANGE;
			Piercer_Trace (org, org + dir, self, SPIKEY_DAMAGE, self, TE_GUNSHOT); // ToP also doubles nailgun's rate of fire.
			if (ox < 0) Echo_Shot(0.05,W_EchoSpike_Down); // Fire a second nail from the same barrel a moment later.
			else Echo_Shot(0.05,W_EchoSpike_Up);

			StackDamage_Clear();
		} else launch_projectile(org,dir,CT_PROJ_NG,SPEED_PLAYSPIKE); // Normal Nailgun Fire
	}
};

void(float oz, float ox) W_FireLavaSpikes = { // [FUNCTION]
	local vector org, dir;
	
	if (self.ammo_lava_nails < 1) { forceweaponswitch(0.2); return; } // If run out of ammo, switch weapons to next best

	self.effects = self.effects | EF_MUZZLEFLASH;
	W_Reload(0.2);
	self.punchangle_x = -2;
	makevectors (self.v_angle);
	if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN)  dir = aim(self, SPEED_PLAYSPIKE); // Auto aim assist (builtin function 44)
	else dir = normalize(v_forward * SPEED_PLAYSPIKE); // Straight line forward where crosshair is pointing

	// Lava SNG setup, sound and ammo change
	if (self.ammo_lava_nails > 1 && self.weapon == IT_LAVA_SUPER_NAILGUN) {
		sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
		if (self.perms & POW_DOUBLE) {
			self.currentammo = self.ammo_lava_nails = self.ammo_lava_nails - 1;
		} else {
			self.currentammo = self.ammo_lava_nails = self.ammo_lava_nails - 2;
		}
		// Original setup - org = self.origin + '0 0 16';
		// - SNG projectile offset idea by Kinn
		// org = self.origin + dir*14 + v_right*ox;
		// org_z = org_z + oz;
		// The SNG offset idea was hiting far below the crosshair
		// which was causing impact problems.
		// Kept the barrel offset, removed the Z adjustment instead!
		org = self.origin + '0 0 16' + v_right*ox;
		if (self.tome_finished) {
			org = self.origin + '0 0 16' + v_up*fabs(ox); // Update 2/14/10:  Minigun mode -- fire three shots per 0.1 sec.
			Piercer_Trace (org, org + dir, self, SPIKEY_DAMAGE, self, TE_GUNSHOT);
			Echo_Shot(1/30, W_EchoLavaSpike_Down);
			Echo_Shot(2/30, W_EchoLavaSpike_Up);
			StackDamage_Clear();
		} else launch_projectile (org, dir, CT_PROJ_LAVASNG, SPEED_PLAYSPIKE); // Normal Super Nailgun Fire
	} else { // Lava NG setup, sound and ammo change
		sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
		if (self.perms & POW_DOUBLE) {
			if (self.nailcosthalf) {
				self.currentammo = self.ammo_lava_nails = self.ammo_lava_nails - 1;
				self.nailcosthalf = 0;
			} else self.nailcosthalf = 1;
		} else self.currentammo = self.ammo_lava_nails = self.ammo_lava_nails - 1;
		
		// Original setup - org = self.origin + '0 0 16' + v_right*ox;
		// - NG projectile offset idea by Kinn
		// org = self.origin + '0 0 8' + dir*14 + v_right*ox;
		org = self.origin + '0 0 16' + v_right*ox;
		if (self.tome_finished) { // ToP makes nailguns fire armor-piercing, hitscan bullets.
			ox = ox * 2;  // Hitscan with no bonus, so extend offset.
			dir = aim (self, 100000) * SPIKEY_RANGE;
			Piercer_Trace(org,org + dir,self,SPIKEY_DAMAGE,self,TE_GUNSHOT); // ToP also doubles nailgun's rate of fire.
			
			if (ox < 0) Echo_Shot(0.05,W_EchoLavaSpike_Down); // Fire a second nail from the same barrel a moment later.
			else Echo_Shot(0.05,W_EchoLavaSpike_Up);

			StackDamage_Clear();
		} else launch_projectile (org, dir, CT_PROJ_LAVANG, SPEED_PLAYSPIKE); // Normal Nailgun Fire
	}
};

void() W_FireGrenade = { // [FUNCTION]
	local vector dir, avel;

	if (self.attack_finished > time) return;
	if (self.ammo_rockets < 1) { forceweaponswitch(0.2); return;} // Ran out of ammo, switch to next best weapon

	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	W_Reload(0.6);
	self.punchangle_x = -2;
	player_grenreset();	// reset weaponframe
	makevectors (self.v_angle);

	if (self.tome_finished) {
		if (self.v_angle_x) { // Has the player aimed left/right? then no auto aim assist
			dir = v_forward*800 + v_up * ELEV_ZAXIS + crandom()*v_right*10 + crandom()*v_up*10; // Faster
		} else {
			if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN)  dir = aim(self, SPEED_PLAYAIM); // Check for auto aim state
			else dir = normalize(v_forward * 800); // Faster

			dir = dir * 800; // Faster
			dir_z = ELEV_ZAXIS; // Work out default speed and elevation
		}
		avel = vecrand(100,200,FALSE);
        Launch_Grenade(self.origin, dir, avel, CT_PROJ_GLSUPER);
    } else {
		if (self.v_angle_x) { // Has the player aimed left/right? then no auto aim assist
			dir = v_forward*SPEED_PLAYGRENADE + v_up * ELEV_ZAXIS + crandom()*v_right*10 + crandom()*v_up*10;
		} else {
			if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN)  dir = aim(self, SPEED_PLAYAIM); // Check for auto aim state
			else dir = normalize(v_forward * SPEED_PLAYGRENADE);

			dir = dir * SPEED_PLAYGRENADE;
			dir_z = ELEV_ZAXIS; // Work out default speed and elevation
		}
		avel = vecrand(100,200,FALSE);
		Launch_Grenade(self.origin, dir, avel, CT_PROJ_GL);
	}
};

void() W_FireRocket = { // [FUNCTION]
	local vector org, dir;
	
	// Ran out of ammo, switch to next best weapon
	if (self.attack_finished > time) return;
	if (self.ammo_rockets < 1) { forceweaponswitch(0.2); return;}

	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	W_Reload(0.8);
	self.punchangle_x = -2;
	player_rockreset();	// reset weaponframe
	makevectors (self.v_angle);
	org = self.origin + v_forward * 8 + '0 0 16';

	// Auto aim assist (builtin function 44)
	if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN)  dir = aim(self, SPEED_RLPLAYER);
	// Straight line forward where crosshair is pointing
	else dir = normalize(v_forward * SPEED_RLPLAYER);
	
    if (self.tome_finished) Launch_Missile (org, dir, '0 0 0', CT_PROJ_ROCKETSUPER, 500); //SuperRocket_Launch (org, dir);
    else Launch_Missile (org, dir, '0 0 0', CT_PROJ_ROCKET, SPEED_RLPLAYER);
};

void () W_Fire_Crossbow = { // [FUNCTION]
	local vector org, dir;

	if (self.attack_finished > time) return;
	if (self.ammo_bolts < 1) { forceweaponswitch(0.2); return;}
	self.currentammo = self.ammo_bolts = self.ammo_bolts - 1;
	makevectors (self.v_angle);
	sound (self, CHAN_WEAPON, "ad171/weapons/crossbow_fire.wav", 1, ATTN_NORM);
	if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN) dir = aim(self, SPEED_PLAYSPIKE);
	else dir = normalize(v_forward * SPEED_DCROSS); // Straight line forward where crosshair is pointing

	if (self.tome_finished) W_Reload(0.13);
	else W_Reload(0.9);
	org = self.origin + '0 0 16';
	launch_projectile (org, dir, CT_PROJ_BOLT1, 1100);
};

void () W_Fire_Crossbow_Poison = { // [FUNCTION]
	local vector org, dir;

	if (self.attack_finished > time) return;
	if (self.ammo_poison < 1) { forceweaponswitch(0.2); return;}
	self.currentammo = self.ammo_poison = self.ammo_poison - 1;
	makevectors (self.v_angle);
	sound (self, CHAN_WEAPON, "ad171/weapons/crossbow_fire.wav", 1, ATTN_NORM);
	if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN)  dir = aim(self, SPEED_PLAYSPIKE);
	else dir = normalize(v_forward * SPEED_DCROSS); // Straight line forward where crosshair is pointing

	if (self.tome_finished) W_Reload(0.13);
	else W_Reload(0.9);
	org = self.origin + '0 0 16';
	self.poisonous = 1;
	launch_projectile (org, dir, CT_PROJ_BOLT2, 1100);
};

void() W_FireIceCrossbow = { // [FUNCTION]
    local vector start, dir, vx, vy;

    if (self.ammo_bolts < 1) return;

    self.currentammo = self.ammo_bolts = self.ammo_bolts - 1;
    self.punchangle_x = -2;
    makevectors (self.v_angle);
    start = self.origin + v_forward*8 + '0 0 16';
    dir = v_forward;    // No auto-aim please.
    vx = v_forward * 0.9848;    // cos(10)
    vy = v_right * 0.1736;      // sin(10)
    Buriza_Launch (start, dir);
    if (self.tome_finished) { // ToP: Shoot two more to the sides for free.
        Buriza_Launch (start, vx + vy);
        Buriza_Launch (start, vx - vy);
    }
};

void() W_FirePlasma = { // [FUNCTION]
	local vector org, dir;
	local float cells;
	
	// If run out of ammo, switch weapons to next best
	if (self.attack_finished > time) return;
	if (self.ammo_cells < 1) { forceweaponswitch(0.2); return; }

	// Do nothing if weapon is under water
	if (self.waterlevel > 1) {
		// Air tank vania item wil explode weapon instead
		if (self.moditems & IT_ARTWETSUIT) {
			// Use all cells
			cells = self.ammo_cells;
			// Update inventory
			self.ammo_cells = 0;
			W_SetCurrentAmmo (self);
			// Impact avoidance sound
			PlayBlastBeltSound(self);
			// Death to everything around, except players!
			T_RadiusDamage (self, self, 35*cells, self, IGNORECLASS);
			// Reduce player HP down to 50%, no armour saves!
			T_Damage(self, world, world, self.health*0.5, NOARMOR);
		} else {
			W_Reload(0.2);
			sound (self, CHAN_WEAPON, SOUND_MISFIRE, 1, ATTN_NORM);
		}
		return;
	}
	
	self.effects = self.effects | EF_MUZZLEFLASH;
	W_Reload(0.2);
	self.punchangle_x = -2;
	makevectors (self.v_angle);

	// Check for auto aim state
	// Auto aim assist (builtin function 44)
	if ((autoaim_cvar < 1) && self.classtype != CT_MONGREMLIN)  dir = aim(self, SPEED_PLAYPLASMA);
	else dir = normalize(v_forward * SPEED_PLAYPLASMA); // Straight line forward where crosshair is pointing

	sound (self, CHAN_WEAPON, "ad171/weapons/plasma_fire.wav", 1, ATTN_NORM);
	self.currentammo = self.ammo_cells = self.ammo_cells - 1;
	org = self.origin + v_forward*8 + '0 0 16';
	launch_plasma (org, dir, CT_PROJ_PLASMA, SPEED_PLAYPLASMA);
};

void(vector p1, vector p2, entity from, float damage) LightningDamage = { // [FUNCTION]
	local entity e1, e2;
	local vector f;
	local float lighthit, temp_classgroup;
	
	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;
	temp_classgroup = from.classgroup; // Need to fool T_Damage that damage is coming from LG
	if (from) from.classgroup = CG_PROJCELLS;
	e1 = e2 = world;
	lighthit = FALSE;
	traceline (p1, p2, FALSE, self);
	if (trace_ent.takedamage) {
		lighthit = TRUE;
		if ((self.flags & FL_CLIENT) && (other.flags & FL_CLIENT)) trace_ent.velocity_z = trace_ent.velocity_z + 400; // Some weird MP velocity hack! KEEP IT!!
	} else {
		e1 = trace_ent;
		traceline (p1 + f, p2 + f, FALSE, self);
		if (trace_ent != e1 && trace_ent.takedamage) lighthit = TRUE;
		else {
			e2 = trace_ent;
			traceline (p1 - f, p2 - f, FALSE, self);
			if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage) lighthit = TRUE;
		}
	}

	// Found a target to hit?
	if (lighthit) {
		// Check for breakable/pushable monster immunity
		if (ai_immunebreakable(self, trace_ent)) {
			if (self.lightning_timer < time) { // This is resist lightning function without pain sound.  Don't spawn smoke constantly (let the sprite finish)
				self.lightning_timer = time + 0.3;
				SpawnExplosion(EXPLODE_BURST_SMOKE, trace_endpos, "");
			}
			SpawnProjectileSmoke(trace_endpos, 200, 50, 150);
		} else if (trace_ent.resist_cells > 0) { // Check for any cell/lightning resistance
			Resist_Effects(trace_ent,trace_endpos,VEC_ORIGIN,0,AM_CELLS,trace_ent.pain_sound,""); // damage = damage * trace_ent.resist_cells;
			if (damage > 0) T_Damage (trace_ent, from, from, damage, DAMARMOR);
		} else {
			SpawnBlood(trace_ent, trace_endpos, '0 0 100', damage*4); // Originally used 225 blood colour
			T_Damage (trace_ent, from, from, damage, DAMARMOR);
		}
		if (trace_ent.reflectlightning) LightningReflection(trace_endpos, trace_ent, damage*0.5); // Check for any lightning reflection abilitites.  Source = Lightning originally came from player
	}
	if (from) from.classgroup = temp_classgroup;
};

// New ability to spawn lighting strikes in random directions
void(vector lstart, entity lsource, float ldamage) LightningReflection = { // [FUNCTION]
	local vector lfinish, dir;

	lfinish = lstart + vecrand(0,1000,1); // Setup a random XYZ direction (+/-)
	traceline(lstart, lfinish, FALSE, lsource); // Trace line in random direction
	if (random() < 0.5) { // Random chance of a plasma/lightning bolt!
		dir = normalize(trace_endpos - lstart);
		launch_plasma(lstart, dir, CT_REFLECTLIGHT, SPEED_REFLECTION);
	} else {
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY); // Draw lighting beam (32 model unit chunks)
		WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
		WriteEntity (MSG_BROADCAST, lsource);
		WriteCoord (MSG_BROADCAST, lstart_x);
		WriteCoord (MSG_BROADCAST, lstart_y);
		WriteCoord (MSG_BROADCAST, lstart_z);
		WriteCoord (MSG_BROADCAST, trace_endpos_x);
		WriteCoord (MSG_BROADCAST, trace_endpos_y);
		WriteCoord (MSG_BROADCAST, trace_endpos_z);
		LightningDamage(lstart, trace_endpos, world, ldamage); // Check for damage with new lightning beam
	}
};

// This lightning damage check is designed for the lightning gun with many modifiers designed for the player and MP combat.
// This function should not be used for general lightning damage
void(vector p1, vector p2, entity from, float damage) PlayerLightningDamage = { // [FUNCTION]
	local entity e1, e2;
	local vector f, dir;
	local float lighthit, temp_classgroup, iter, dmg;
	
	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;
	dmg = damage;
	e1 = e2 = world;
	lighthit = FALSE;
	traceline (p1, p2, FALSE, self);
	if (trace_ent.takedamage) {
		lighthit = TRUE;
		// Some weird MP velocity hack!
		// The story about this code (from quakeworld.nu)
		//
		// This code appears to have been there for a long, long time.
		// It was there in Quake 1.06 Shareware release, and it may have
		// been there before that. Someone must have been experimenting
		// with something and forgot it there, but no one noticed because
		// in that function, the 'other' entity is not usually set to
		// anything in particular, and the code never worked.
		//
		// But then QW came along, and in the QW engine it turns out
		// that 'other' will be set to 'self' if the player is touching
		// a platform. And so the dormant code stared working! It was
		// discovered by players, and players started using it to their
		// advantage. Now it's an integral part of dm6 gameplay.
		//
		// The code was apparently discovered and removed when Quake QC 
		// code was cleaned up before being released to public, so you
		// won't normally see it in NQ mods. But it is there in the
		// progs.dat in pak0.pak; and it will work in QuakeWorld engines
		// supporting progs.dat (currently FTE and ZQuake).
		if ((self.flags & FL_CLIENT) && (other.flags & FL_CLIENT)) trace_ent.velocity_z = trace_ent.velocity_z + 400;
	} else {
		e1 = trace_ent;
		traceline (p1 + f, p2 + f, FALSE, self);
		if (trace_ent != e1 && trace_ent.takedamage) lighthit = TRUE;
		else {
			e2 = trace_ent;
			traceline (p1 - f, p2 - f, FALSE, self);
			if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage) lighthit = TRUE;
		}
	}

	// Found a target to hit?
	if (lighthit) {
		if (self.tome_finished && trace_ent) {
			// Make some extra tome of power spark effects
			iter = 0;
			while (iter < 6) {
				dir = safe_client_forward();
				make_spark(trace_ent.origin, dir, FALSE); // False to use direction.
				newmis.velocity_z = 200 + crandom() * 300;
				newmis.velocity_y = crandom() * 300;
				newmis.velocity_x = crandom() * 300;
				newmis.solid = SOLID_NOT;
				newmis.touch = SUB_Null;
				newmis.skin = 8;
				iter = iter + 1;
			}
			dmg = dmg * 2; // Double damage
			if (trace_ent.health < dmg) { // Monster go pop!
				iter = 0;
				sound (self, CHAN_AUTO, "rrp/misc/spark.wav", 1, ATTN_STATIC);
				while (iter < 30) {
					dir = safe_client_forward();
					make_spark(trace_ent.origin, dir, FALSE); // False to use direction.
					if (iter < 15) newmis.velocity_z = 200;
					else newmis.velocity_z = -200;
					newmis.velocity_y = crandom() * 100;
					newmis.velocity_x = crandom() * 100;
					newmis.solid = SOLID_NOT;
					newmis.touch = SUB_Null;
					newmis.skin = 8;
					iter = iter + 1;
				}
			}
		}

		// Check for any cell/lightning resistance
		if (trace_ent.resist_cells > 0) {
			Resist_Effects(trace_ent,trace_endpos,VEC_ORIGIN,0,AM_CELLS,trace_ent.pain_sound,"");
			if (dmg > 0) {
				// Need to fool T_Damage that damage is coming from LG
				temp_classgroup = from.classgroup;
				from.classgroup = CG_PROJCELLS;
				T_Damage (trace_ent, from, from, dmg, DAMARMOR);
				from.classgroup = temp_classgroup;
			}
		} else {
			// Originally used 225 blood colour
			SpawnBlood(trace_ent, trace_endpos, '0 0 100', dmg*4);
			T_Damage (trace_ent, from, from, dmg, DAMARMOR);
		}

		// Check for any lightning reflection abilitites
		if (trace_ent.reflectlightning) {
			dmg = dmg * 0.5; // Lightning splits when reflected...I guess.
			LightningReflection(trace_endpos, trace_ent, dmg); // Source = Lightning originally came from player
		}
	} else {
		if (self.tome_finished) {
			// Make some extra tome of power spark effects
			iter = 0;
			while (iter < 6) {
				dir = safe_client_forward();	
				make_spark(trace_endpos, dir * 300, FALSE); // False to use direction.
				newmis.velocity_z = crandom() * 300;
				newmis.velocity_y = crandom() * 300;
				newmis.velocity_x = crandom() * 300;
				newmis.solid = SOLID_NOT;
				newmis.touch = SUB_Null;
				newmis.skin = 8;
				iter = iter + 1;
			}
		}
	}
};

void() W_FireLightning = { // [FUNCTION]
	local vector dir;
	local float cells, ct, iter;

	if (self.ammo_cells < 1) { forceweaponswitch(0.2); return; } // Ran out of ammo, switch to next best weapon

	// explode if under water
	if (self.waterlevel > 1) {
		cells = self.ammo_cells; 
		self.currentammo = self.ammo_cells = 0; // Use all cells
		W_SetCurrentAmmo (self); // Update inventory

		if (self.tome_finished) {
			// Make some extra tome of power spark effects off the player
			iter = 0;
			while (iter < 30) {
				make_spark(self.origin, VEC_ORIGIN, TRUE); // TRUE for random using Rubicon method.
				newmis.velocity_z = crandom() * 300;
				newmis.velocity_y = crandom() * 300;
				newmis.velocity_x = crandom() * 300;
				newmis.solid = SOLID_NOT;
				newmis.touch = SUB_Null;
				newmis.skin = 8;
				iter = iter + 1;
			}

			cells = cells * 2; // Double discharge damage
			if (cells < 50) cells = 50; // Less than 25 cells is same as 25 cells.
		}

		if (self.moditems & IT_ARTWETSUIT) {
			// Air tank vania item saves player from death
			PlayBlastBeltSound(self); // Impact avoidance sound
			T_RadiusDamage (self, self, 35*cells, self, IGNORECLASS); // Death to everything around, except players!
			T_Damage(self, world, world, self.health*0.5, NOARMOR); // Reduce player HP down to 50%, no armour saves!
		} else {
			// Default behaviour, death to everything!
			T_RadiusDamage (self, self, 35*cells, world, DAMAGEALL); 
		}
		return;
	}

	// Time for a new LG hit sound?
	if (self.t_width < time) {
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	
	self.currentammo = self.ammo_cells = self.ammo_cells - 1;
	self.effects = self.effects | EF_MUZZLEFLASH;
	W_Reload(0.2);
	self.punchangle_x = -2;
	dir = self.origin + '0 0 16';
	traceline (dir, dir + v_forward*6000, TRUE, self);
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, dir_x);
	WriteCoord (MSG_BROADCAST, dir_y);
	WriteCoord (MSG_BROADCAST, dir_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);
	PlayerLightningDamage(self.origin, trace_endpos + v_forward*4, self, DAMAGE_LGPLAYER);
};

// Fires chain lightning.  Replaces 'W_FireLightning' and custom 'W_FireBurstLight'.
void(float cl) W_FireThunderbolt = { // [FUNCTION]
    local   vector  org;
    local   float   cells, damage;     // Used as ammo cost first, then as damage.

	// Ran out of ammo, switch to next best weapon
	if (self.ammo_cells < 1) { forceweaponswitch(0.2); return; }

	// Do nothing if weapon is under water
	if (self.waterlevel > 1) {
		// Air tank vania item wil explode weapon instead
		if (self.moditems & IT_ARTWETSUIT) {
			// Use all cells
			cells = self.ammo_cells;
			// Update inventory
			self.ammo_cells = 0;
			W_SetCurrentAmmo (self);
			PlayBlastBeltSound(self); // Impact avoidance sound
			T_RadiusDamage (self, self, 35*cells, self, IGNORECLASS); // Death to everything around, except players!
			T_Damage(self, world, world, self.health*0.5, NOARMOR); // Reduce player HP down to 50%, no armour saves!
		} else {
			W_Reload(0.2);
			sound (self, CHAN_WEAPON, SOUND_MISFIRE, 1, ATTN_NORM);
		}
		return;
	}

    if (self.t_width < time) {
        sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
        self.t_width = time + 0.6;
    }
    self.punchangle_x = -2;

    damage = 2;
    if (self.tome_finished)
        damage = damage + 1;
    if (self.ammo_cells < damage)
        damage = self.ammo_cells;

	self.currentammo = self.ammo_cells = self.ammo_cells - damage;
    damage = damage * 15;

	// Grrr, when a beam is drawn from a client, it always starts from the
	// origin no matter the source point passed.  QuakeC can't fix this
	// without causing some other problem sore to the eyes.
    makevectors(self.v_angle);
    org = self.origin + '0 0 16';
	// Note:  Changing 1st parm won't make lightning start elsewhere from client.
    if (cl)
        BurstLit_Bolt(self.origin,org + v_forward*6000,self,damage,350); // Always chain
    else
        LightningBolt(self.origin,org + v_forward*6000,self,damage,self,TE_LIGHTNING2);
};

void () W_FireMultiGrenade = { // [FUNCTION]
	local vector dir, avel;

	if (self.attack_finished > time) return;
	if (self.ammo_multi_rockets < 1) { forceweaponswitch(0.2); return;}

	self.ammo_multi_rockets = (self.ammo_multi_rockets - TRUE);
	self.currentammo = (self.currentammo - TRUE);
	sound (self,CHAN_WEAPON,"weapons/grenade.wav",TRUE,ATTN_NORM);
	self.effects = self.effects | EF_MUZZLEFLASH;
	W_Reload(0.6);
	self.punchangle_x = -2;
	makevectors (self.v_angle);
	if ( self.v_angle_x ) {
		dir = ((((v_forward * 600.000) + (v_up * 200.000)) + ((crandom () * v_right) * MOVETYPE_BOUNCE)) + ((crandom () * v_up) * MOVETYPE_BOUNCE));
	} else {
		dir = aim (self,10000.000);
		dir = (dir * 600.000);
		dir_z = 200.000;
	}
	avel = '300.000 300.000 300.000';
	Launch_Grenade(self.origin, dir, avel, CT_PROJ_GLMULTI);
};

void () W_FireMultiRocket = { // [FUNCTION]
	if (self.attack_finished > time) return;
	self.ammo_multi_rockets = (self.ammo_multi_rockets - TRUE);
	self.currentammo = (self.currentammo - TRUE);
	sound (self,CHAN_WEAPON,"weapons/sgun1.wav",TRUE,ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	MultiRocketLaunch (-10.000,FL_SWIM);
	MultiRocketLaunch (CONTENT_LAVA,MOVETYPE_WALK);
	MultiRocketLaunch (MOVETYPE_FLY,FALSE);
	MultiRocketLaunch (MOVETYPE_BOUNCE,TRUE);
	W_Reload(0.9);
};

void () W_FirePlasmaGun = { // [FUNCTION]
   local entity missile;
	local float cells;

	if (self.attack_finished > time) return; // Do nothing if weapon is under water
	
	if (self.waterlevel > 1) {
		if (self.moditems & IT_ARTWETSUIT) { // Air tank vania item wil explode weapon instead
			cells = self.ammo_cells; // Use all cells
			self.ammo_cells = 0; // Update inventory
			W_SetCurrentAmmo (self);
			PlayBlastBeltSound(self); // Impact avoidance sound
			T_RadiusDamage (self, self, 35*cells, self, IGNORECLASS); // Death to everything around, except players!
			T_Damage(self, world, world, self.health*0.5, NOARMOR); // Reduce player HP down to 50%, no armour saves!
		} else {
			W_Reload(0.2);
			sound (self, CHAN_WEAPON, SOUND_MISFIRE, 1, ATTN_NORM);
		}
		return;
	}

	self.ammo_plasma = (self.ammo_plasma - TRUE);
	self.currentammo = (self.currentammo - TRUE);
	sound (self,CHAN_WEAPON,"rogue/plasma/fire.wav",0.500,ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn ();
	missile.classgroup = CG_PROJCELLS;
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "plasma";
	makevectors (self.v_angle);
	missile.velocity = aim (self,1250);
	missile.velocity = (missile.velocity * 1250);
	missile.avelocity = '300.000 300.000 300.000';
	missile.angles = vectoangles (missile.velocity);
	missile.touch = PlasmaTouch;
	setmodel (missile,"progs/plasma.mdl");
	setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
	setorigin (missile,((self.origin + (v_forward * FL_CLIENT)) + '0.000 0.000 16.000'));
	sound (missile,CHAN_WEAPON,"rogue/plasma/flight.wav",TRUE,ATTN_NORM);
	missile.think = PlasmaGroundOut;
	missile.nextthink = (time + MOVETYPE_FLY);
	W_Reload(0.8);
};

void(entity targ) W_SetCurrentAmmo = { // [FUNCTION]
	if (frame_pause()) return; // intermission, cinematic, or finale

	remoteplayer_run(targ);	// Get out of any weapon firing states.
	if (!targ.selfweaponismoditems) {
		if (targ.weapon == IT_AXE) {
			targ.currentammo = 0;
			if (targ.moditems & IT_UPGRADE_AXE) {
				targ.weaponmodel = MODEL_VWEAP_UPAXE;
			} else {
				targ.weaponmodel = v_axemodel;
			}
			if (targ.perms & IT_CHAINSAW) targ.weaponmodel = "progs/drake/v_saw.mdl"; // override axes
		} else if (targ.weapon == IT_SHOTGUN) {
			targ.currentammo = targ.ammo_shells;
			if (targ.perms & IT_BLASTER) {
				targ.weaponmodel = "progs/drake/v_laserb.mdl";
			} else {
				if (targ.items & IT_SHOTGUN) {
					targ.weaponmodel = MODEL_VWEAP_SG;
				} else {
					// This is also called no axe startup option.  Cinematic mode, no viewmodel
					targ.weaponmodel = "";
					targ.currentammo = 0;
				}
			}
		} else if (targ.weapon == IT_SUPER_SHOTGUN) {
			targ.currentammo = targ.ammo_shells;
			if (targ.moditems & IT_UPGRADE_SSG) targ.weaponmodel = MODEL_VWEAP_UPSSG;
			else targ.weaponmodel = MODEL_VWEAP_SSG;
		} else if (targ.weapon == IT_LAVA_NAILGUN) {
			targ.currentammo = targ.ammo_lava_nails;
			targ.weaponmodel = MODEL_VWEAP_LAVANG;
		} else if (targ.weapon == IT_NAILGUN) {
			targ.currentammo = targ.ammo_nails;
			targ.weaponmodel = MODEL_VWEAP_NG;
		} else if (targ.weapon == IT_LAVA_SUPER_NAILGUN) {
			targ.currentammo = targ.ammo_lava_nails;
			targ.weaponmodel = MODEL_VWEAP_LAVASNG;
		} else if (targ.weapon == IT_SUPER_NAILGUN) {
			targ.currentammo = targ.ammo_nails;
			targ.weaponmodel = MODEL_VWEAP_SNG;
		} else if (targ.weapon == IT_MULTI_GRENADE) {
			targ.currentammo = targ.ammo_multi_rockets;
			targ.weaponmodel = MODEL_VWEAP_MULTG;
		} else if (targ.weapon == IT_GRENADE_LAUNCHER) {
			targ.currentammo = targ.ammo_rockets;
			targ.weaponmodel = MODEL_VWEAP_GL;
		} else if (targ.weapon == IT2_PROXIMITY_GUN) {
			targ.currentammo = targ.ammo_rockets;
			targ.weaponmodel = MODEL_VWEAP_PROX;
		} else if (targ.weapon == IT_MULTI_ROCKET) {
			targ.currentammo = targ.ammo_multi_rockets;
			targ.weaponmodel = MODEL_VWEAP_MULTR;
		} else if (targ.weapon == IT_ROCKET_LAUNCHER) {
			targ.currentammo = targ.ammo_rockets;
			if (targ.moditems & IT3_MIRV) {
				targ.weaponmodel = "progs/drake/v_mirv.mdl";
			} else {
				targ.weaponmodel = MODEL_VWEAP_RL;
			}
		} else if (targ.weapon == IT_LIGHTNING) {
			targ.currentammo = targ.ammo_cells;
			if (targ.moditems & IT_UPGRADE_LG) targ.weaponmodel = MODEL_VWEAP_UPLG;
			else targ.weaponmodel = MODEL_VWEAP_LG;
		} else if (targ.weapon == IT2_CHAINLIGHTNING) {
			targ.currentammo = targ.ammo_cells;
			targ.weaponmodel = "progs/drake/v_light2.mdl";
		} else if (targ.weapon == IT_PLASMA_GUN) {
			targ.currentammo = targ.ammo_plasma;
			targ.weaponmodel = MODEL_VWEAP_PLASM;
		} else if (targ.weapon == IT2_LASER_CANNON) {
			targ.currentammo = targ.ammo_cells;
			targ.weaponmodel = "progs/hipnotic/v_laserg.mdl";
		} else if (targ.weapon == IT_EXTRA_WEAPON) {
			if (targ.perms & IT_FROSTBOW) {
				targ.currentammo = targ.ammo_bolts;
				targ.weaponmodel = "progs/drake/v_xbow.mdl";
			} else {
				if (targ.ammo_poison > 0) {
					targ.currentammo = targ.ammo_poison;
					targ.weaponmodel = "progs/its/v_crossbow2.mdl";
				} else {
					targ.currentammo = targ.ammo_bolts;
					targ.weaponmodel = "progs/its/v_crossbow1.mdl";
				}
			}
		} else if (targ.weapon == IT2_MJOLNIR) {
			targ.currentammo = targ.ammo_cells;
			targ.weaponmodel = MODEL_VWEAP_MJOL;
		} else if (targ.weapon == IT2_CROSS) {
			targ.weaponmodel =  "progs/drake/v_wand.mdl";
		} else if (targ.weapon == IT2_GRAPPLE) {
			targ.currentammo = 0;
			targ.weaponmodel = "progs/drake/v_grpple.mdl";
			if (self.hook) {
				if (self.hook.count) {
					self.weaponframe = 1;   // Hook is still out.
				}
			}
		} else if (targ.weapon == IT_SANGUINATORS) {
			targ.currentammo = targ.ammo_bloodcrystals;
			targ.weaponmodel = "progs/aoa/v_sanguinators.mdl";
		} else if (targ.weapon == IT_SCIMITAR) {
			targ.currentammo = targ.ammo_elemental;
			targ.weaponmodel = "progs/aoa/v_scimitar.mdl";
		} else if (targ.weapon == IT_RAPIER) {
			targ.currentammo = targ.ammo_bloodcrystals;
			targ.weaponmodel = "progs/aoa/v_rapier.mdl";
		} else {
			// This is also called no axe startup option.  Cinematic mode, no viewmodel.
			targ.currentammo = 0;
			targ.weaponmodel = "";
		}
	} else {
		if (targ.weapon == IT_ICE) {
			targ.currentammo = targ.ammo_elemental;
			targ.weaponmodel = "progs/aoa/v_ice.mdl";
		} else if (targ.weapon == IT_MACE) {
			targ.currentammo = targ.ammo_bloodcrystals;
			targ.weaponmodel = "progs/aoa/v_mace.mdl";
		} else if (targ.weapon == IT_VOID_STAFF) {
			targ.currentammo = targ.ammo_voidshards;
			targ.weaponmodel = "progs/aoa/v_voidstaff.mdl";
		} else if (targ.weapon == IT_FLAK) {
			targ.currentammo = CountFlakAmmo(targ);
			targ.weaponmodel = "progs/aoa/v_flak.mdl";
		} else if (targ.weapon == IT_GUNGNIR) {
			targ.currentammo = targ.ammo_voidshards;
			targ.weaponmodel = "progs/aoa/v_gungnir.mdl";
		} else if (targ.weapon == IT_AIRGUN) {
			targ.currentammo = 0;
			targ.weaponmodel = "progs/airfist/v_airgun.mdl";
		} else {
			// This is also called no axe startup option.  Cinematic mode, no viewmodel.
			targ.currentammo = 0;
			targ.weaponmodel = "";
		}
	}
};

// Return best weapon based on current ammo quantities, excludes rockets and multi-rockets for obvious heat of the moment self inflicted damage avoidance
float(entity targ) W_BestWeapon = { // [FUNCTION]
	if (targ.waterlevel < 1 && targ.ammo_cells > 0 && (targ.items & IT2_LASER_CANNON) ) return IT2_LASER_CANNON;
	if (targ.waterlevel < 1 && targ.ammo_cells > 0 && (targ.items2 & IT2_CHAINLIGHTNING) ) return IT2_CHAINLIGHTNING;
	if (targ.waterlevel < 1 && targ.ammo_cells > 0 && (targ.items & IT_LIGHTNING) ) return IT_LIGHTNING;
	if (targ.waterlevel < 1 && targ.ammo_cells > 0 && (targ.items & IT2_MJOLNIR) ) return IT2_MJOLNIR;
	if (targ.ammo_bloodcrystals > 0 && (targ.items & IT_SANGUINATORS) ) return IT_SANGUINATORS;
	if(targ.ammo_lava_nails > 1 && (targ.items & IT_LAVA_SUPER_NAILGUN) ) return IT_LAVA_SUPER_NAILGUN;
	if(targ.ammo_nails > 1 && (targ.items & IT_SUPER_NAILGUN) ) return IT_SUPER_NAILGUN;
	if(targ.ammo_lava_nails > 1 && (targ.items & IT_LAVA_NAILGUN) ) return IT_LAVA_NAILGUN;
	if (targ.ammo_elemental > 0 && (targ.items & IT_SCIMITAR) ) return IT_SCIMITAR;
	if(targ.ammo_bolts > 1 && (targ.items & IT_EXTRA_WEAPON) ) return IT_EXTRA_WEAPON;
	if (targ.ammo_bloodcrystals > 0 && (targ.items & IT_SANGUINATORS) ) return IT_SANGUINATORS;
	if(targ.ammo_shells > 2 && (targ.items & IT_SUPER_SHOTGUN) ) return IT_SUPER_SHOTGUN; // greater than 2 in case of upgraded triple shotgun Widowmaker
	if(targ.ammo_nails > 0 && (targ.items & IT_NAILGUN) ) return IT_NAILGUN;
	if(targ.ammo_shells > 0 && (targ.items & IT_SHOTGUN || targ.perms | IT_BLASTER) ) return IT_SHOTGUN;
	if (targ.waterlevel > 0 && targ.ammo_cells < 1 && (targ.items & IT2_MJOLNIR) ) return IT2_MJOLNIR;
	if (targ.items & IT_AXE) return IT_AXE;
	if (targ.items2 & IT2_CROSS) return IT2_CROSS; // WAND
	return FALSE;
};

float(entity targ) W_CheckNoAmmo = { // [FUNCTION]
	if (targ.selfweaponismoditems) {
		if (targ.weapon == IT_FLAK) targ.currentammo = CountFlakAmmo(targ);
		if (targ.weapon == IT_GUNGNIR || targ.weapon == IT_MACE || targ.weapon == IT_AIRGUN) return TRUE;
	} else {
		if (targ.weapon == IT_AXE || targ.weapon == IT2_MJOLNIR || targ.weapon == IT2_CROSS || targ.weapon == IT2_GRAPPLE || targ.weapon == IT_RAPIER || targ.weapon == IT_SCIMITAR) return TRUE;
	}

	if (targ.currentammo > 0) return TRUE;

	targ.weapon = W_BestWeapon (targ);
	W_SetCurrentAmmo (targ);
	return FALSE; // drop the weapon down
};

void(float reload) W_Reload = { // [FUNCTION]
	if ((self.flags & FL_CLIENT) && self.perms & POW_HASTE) reload = reload / 2;
	if (reload < 0.05) reload = 0.05; // Minimum value, to prevent near zero from Haste, Shotty, and Tome of Power stacking up.
	if (reload > 10) reload = 10; // Just in case, this is a rather ridiculous value anyway.
	if (self.slow_finished > time) reload = reload * 1.5; //Such a slog, we are cold
    self.attack_finished = time + reload;
};

void() W_Attack = { // [FUNCTION]
	if (intermission_running > 0) return;	// intermission or finale
	if (cinematic_running > 0) return;		// Remote camera active
	if ( !W_CheckNoAmmo(self) ) return;		// Out of ammo?

	makevectors	(self.v_angle);		// calculate forward angle for velocity
	if (((self.weapon != IT_EXTRA_WEAPON && !self.selfweaponismoditems) || (self.perms & IT_FROSTBOW && self.weapon == IT_EXTRA_WEAPON && !self.selfweaponismoditems)) && self.weapon != IT_AXE && !self.selfweaponismoditems) self.show_hostile = time + 1;	// wake monsters up
    self.b0_click = 0;
	if (!self.selfweaponismoditems) {
		if (self.weapon == IT_AXE) {
			if (self.perms & IT_CHAINSAW) { // Chainsaw overrides axes once acquired.
				player_saw1(); 
				W_Reload(0.55);
				sound (self, CHAN_AUTO, "zerstorer/weapons/sawatck.wav", 1, ATTN_NORM);
				self.show_hostile = time + 1; // wake monsters up, we hit stuff
			} else {
				// Axe and Shadowaxe
				if (random() < 0.5) sound (self, CHAN_WEAPON, SOUND_AXE_SWIPE1, 1, ATTN_NORM);
				else sound (self, CHAN_WEAPON, SOUND_AXE_SWIPE2, 1, ATTN_NORM);
				
				self.lip = self.meleeattack; // Work out which axe swing to play (never play swing twice in a row)
				while (self.meleeattack == self.lip) {
					self.lip = rint(random()*4.4);
				}
				self.meleeattack = self.lip;
				if (v_axemodel == "progs/ad171/v_shadaxe0.mdl") {
					if (self.meleeattack == 0) player_axe1();
					else if (self.meleeattack == 1) player_axeb1();
					else if (self.meleeattack == 2) player_axec1();
					else if (self.meleeattack == 3) player_axed1();
					else player_axee1();
				} else {
					if (self.meleeattack == 0) player_axe1();
					else if (self.meleeattack == 1) player_axeb1();
					else if (self.meleeattack == 2) player_axeoldc1();
					else player_axeoldd1();
				}	
				W_Reload(0.5);
			}
		} else if (self.weapon == IT_SHOTGUN) {
			if (self.perms & IT_BLASTER) {
				player_blast1(); // use laser blaster only once we have it, still uses shells
			} else {
				player_sg1(); // use standard single barrel shotgun
			}
		} else if (self.weapon == IT_SUPER_SHOTGUN) { player_supersg1(); }
		else if (self.weapon == IT_NAILGUN) { player_nail1(); }
		else if (self.weapon == IT_LAVA_NAILGUN) { player_lava_nail1(); self.lavaGunFired = TRUE; }
		else if (self.weapon == IT_SUPER_NAILGUN) { player_snail1(); }
		else if (self.weapon == IT_LAVA_SUPER_NAILGUN) { player_lava_snail1();  self.lavaGunFired = TRUE; }
		else if (self.weapon == IT_MULTI_GRENADE) { player_multi_grenade1(); }
		else if (self.weapon == IT_GRENADE_LAUNCHER) { player_grenade1(); }
		else if (self.weapon == IT_MULTI_ROCKET) { player_multi_rocket1(); }
		else if (self.weapon == IT_ROCKET_LAUNCHER) {
			if (self.moditems & IT3_MIRV) {
				player_bfg1();
				if (self.ammo_rockets >= COST_MIRV) {
					W_FireStinger();
					W_Reload(1.5);
				} else W_FireRocket();
			} else {
				player_rocket1();
			}
		} else if (self.weapon == IT_PLASMA_GUN) { player_plasmalight1(); }
		else if (self.weapon == IT_LIGHTNING) {
			if (self.moditems & IT_UPGRADE_LG) player_plasma1();
			else {
				player_light1(); 
				sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM); 
			}
		} else if (self.weapon == IT_EXTRA_WEAPON) {
			if (self.perms & IT_FROSTBOW) {
				player_xbow1();
				W_Reload(0.8);
			} else {
				player_crossbow1();
			}
		} else if (self.weapon == IT2_LASER_CANNON) player_laser1();
		else if (self.weapon == IT2_MJOLNIR) {
			if (self.ammo_cells < COST_MJOLNIR) {
				W_Reload(0.4);
				player_hammer1();
			} else {
				W_Reload(0.4);
				player_mjolnir1();
			}
		} else if (self.weapon == IT2_GRAPPLE) {
				if (self.hook) {
					// Assume hook was improperly removed, so reset links.
					if (!self.hook.modelindex) {   
						self.hook = world;  // So W_FireGrapple fires a hook.
						player_grapple1 ();
						return;
					}
					if (self.hook.count) return;
					player_grapple3 ();
				} else player_grapple1 ();

				// Modified animation takes three frames to complete, hence 0.3 for 0.1 * 3.
				W_Reload(0.3);
		} else if (self.weapon == IT2_PROXIMITY_GUN) {
			if (self.tome_finished) {
				W_FireHydra();
				W_Reload(1.5);
			} else {
				if (self.perms & IT_SIDEWINDER) { W_FireSidewinder(); W_Reload(1); }
				else player_prox_grenade1();
			}
		} else if (self.weapon == IT2_CHAINLIGHTNING) {
			player_chainlight1();
			W_Reload(0.1);
			sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
		} else if (self.weapon == IT2_CROSS) {
			player_wand1();
			W_FireSparks();
		} else if (self.weapon == IT_SANGUINATORS) W_FireSanguinators();
		else if (self.weapon == IT_SCIMITAR) W_FireScimitar(); 
		else if (self.weapon == IT_RAPIER) W_FireRapier();
	} else {
		if (self.weapon == IT_ICE) { W_FireIce(); }
		else if (self.weapon == IT_MACE) { W_FireMace(); }
		else if (self.weapon == IT_VOID_STAFF) { W_FireVoidStaff(); }
		else if (self.weapon == IT_FLAK) { W_FireFlak(); }
		else if (self.weapon == IT_GUNGNIR) { W_FireGungnir(); }
		else if (self.weapon == IT_AIRGUN) { W_FireAirFist(); } // Fire the Airfist weapon
	}
};

float (entity targ, float testValue) InItems = { // [FUNCTION]
   if (targ.items & testValue) return TRUE;
   return FALSE;
};

float (entity targ, float testValue) InItems2 = { // [FUNCTION]
   if (targ.items2 & testValue) return TRUE;
   return FALSE;
};

float (entity targ, float testValue) InModItems = { // [FUNCTION]
   if (targ.moditems & testValue) return TRUE;
   return FALSE;
};

float (entity targ, float testValue) InPerms = { // [FUNCTION]
   if (targ.perms & testValue) return TRUE;
   return FALSE;
};

float IN_ITEMS1 = 1;
float IN_ITEMS2 = 2;
float IN_MODITEMS = 4;
float IN_PERMS = 8;
float IN_ITEMS1_HACKBANK = 16;
float IN_ITEMS2_HACKBANK = 32;
float IN_MODITEMS_HACKBANK = 64;
float IN_PERMS_HACKBANK = 128;

float (float mask, entity targ, float testValue) InAnyItems = { // [FUNCTION]
	if (mask == IN_ITEMS1) return InItems(targ,testValue);
	if (mask == IN_ITEMS2) return InItems2(targ,testValue);
	if (mask == IN_MODITEMS) return InModItems(targ,testValue);
	if (mask == IN_PERMS) return InPerms(targ,testValue);
	if (mask == IN_ITEMS1_HACKBANK) return InItems(targ,testValue);
	if (mask == IN_ITEMS2_HACKBANK) return InItems2(targ,testValue);
	if (mask == IN_MODITEMS_HACKBANK) return InModItems(targ,testValue);
	if (mask == IN_PERMS_HACKBANK) return InPerms(targ,testValue);
	return FALSE;
}

// Function to cycle within the same slot by multiple keypresses, e.g. keep pressing 6 to cycle through grenade launcher,
// proximity grenade launcher, and multi-grenade launcher.
// Returns a vector: x = fl (the new self.weapon, y = gotgun (whether we have it), z = (am, whether we have ammo)
// targ = player
// wep1 = 1st weapon in this keybind's slot
// wep2 = 2nd weapon in this keybind's slot
// wep3 = 3rd weapon in this keybind's slot
// wep1initems = bitmask to specify whether to use self.items, self.items2, self.moditems, or self.perms
vector (entity targ, float wep1, float wep2, float wep3, float wep1initems, float wep2initems, float wep3initems) WeaponSlotPickOneOfThree = { // [FUNCTION]
	local vector retvec;
	local float fl, gotgun, gotgun1, gotgun2, gotgun3, am;
	local float inhackbank;
	// Make sure it's all zeroed out
	inhackbank = fl = gotgun1 = gotgun2 = gotgun3 = am = FALSE;
	if (wep1) gotgun1 = InAnyItems(wep1initems, targ, wep1);
	if (wep2) gotgun2 = InAnyItems(wep2initems, targ, wep2);
	if (wep3) gotgun3 = InAnyItems(wep3initems, targ, wep3);
	retvec = VEC_ORIGIN;

	if (targ.weapon == wep1) {
		if (gotgun3) {
			fl = wep3;
			gotgun = TRUE;
		} else {
			fl = wep2;
			//gotgun = InItems2(targ, fl);
			gotgun = gotgun2;
		}
	} else {
		if (targ.weapon == wep3) {
			if (gotgun2) {
				fl = wep2;
				gotgun = TRUE;
			} else {
				fl = wep1;
				//gotgun = InItems(targ, fl);
				gotgun = gotgun1;
			}
		}  else {
			if (targ.weapon == wep2) {
				if (gotgun1) {
					fl = wep1;
					gotgun = TRUE;
				} else {
					fl = wep3;
					//gotgun = InItems(targ, fl);
					gotgun = gotgun3;
				}
			} else {
				if (gotgun1) {
					fl = wep1;
					gotgun = TRUE;
				} else {
					if (gotgun3) {
						fl = wep3;
						gotgun = TRUE;
					} else {
						if (gotgun2) {
							fl = wep2;
							gotgun = TRUE;
						}
					}
				}
			}
		}
	}

	if (fl == wep1) {
		if (wep1initems == IN_ITEMS1_HACKBANK || wep1initems == IN_ITEMS2_HACKBANK || wep1initems == IN_MODITEMS_HACKBANK || wep1initems == IN_PERMS_HACKBANK) inhackbank = TRUE;
	}
	if (fl == wep2) {
		if (wep2initems == IN_ITEMS1_HACKBANK || wep2initems == IN_ITEMS2_HACKBANK || wep2initems == IN_MODITEMS_HACKBANK || wep2initems == IN_PERMS_HACKBANK) inhackbank = TRUE;
	}
	if (fl == wep3) {
		if (wep3initems == IN_ITEMS1_HACKBANK || wep3initems == IN_ITEMS2_HACKBANK || wep3initems == IN_MODITEMS_HACKBANK || wep3initems == IN_PERMS_HACKBANK) inhackbank = TRUE;
	}

	retvec.x = fl;
	retvec.y = gotgun;
	retvec.z = inhackbank;
	return retvec;
};

// FOUR WEAPONS ON THE SAME KEYBOARD KEY!!!  Good lawdy we need a bigger keyboard!
vector (entity targ, float wep1, float wep2, float wep3, float wep4, float wep1initems, float wep2initems, float wep3initems, float wep4initems) WeaponSlotPickOneOfFour = { // [FUNCTION]
	local vector retvec;
	local float fl, gotgun, gotgun1, gotgun2, gotgun3, gotgun4, am;
	local float inhackbank;
	// Make sure it's all zeroed out
	inhackbank = fl = gotgun1 = gotgun2 = gotgun3 = gotgun4 = am = FALSE;
	if (wep1) gotgun1 = InAnyItems(wep1initems, targ, wep1);
	if (wep2) gotgun2 = InAnyItems(wep2initems, targ, wep2);
	if (wep3) gotgun3 = InAnyItems(wep3initems, targ, wep3);
	if (wep4) gotgun4 = InAnyItems(wep4initems, targ, wep3);
	retvec = VEC_ORIGIN;

	if (targ.weapon == wep1) {
		if (gotgun4) {
			fl = wep4;
			gotgun = TRUE;
		} else {
			fl = wep3;
			//gotgun = InItems2(targ, fl);
			gotgun = gotgun3;
		}
	} else {
		if (targ.weapon == wep4) {
			if (gotgun3) {
				fl = wep3;
				gotgun = TRUE;
			} else {
				fl = wep2;
				gotgun = gotgun2;
			}
		} else {
			if (targ.weapon == wep3) {
				if (gotgun2) {
					fl = wep2;
					gotgun = TRUE;
				} else {
					fl = wep1;
					//gotgun = InItems(targ, fl);
					gotgun = gotgun1;
				}
			}  else {
				if (targ.weapon == wep2) {
					if (gotgun1) {
						fl = wep1;
						gotgun = TRUE;
					} else {
						fl = wep3;
						//gotgun = InItems(targ, fl);
						gotgun = gotgun3;
					}
				} else {
					if (gotgun1) {
						fl = wep1;
						gotgun = TRUE;
					} else {
						if (gotgun4) {
							fl = wep4;
							gotgun = TRUE;
						} else {
							if (gotgun3) {
								fl = wep3;
								gotgun = TRUE;
							} else {
								if (gotgun2) {
									fl = wep2;
									gotgun = TRUE;
								}
							}
						}
					}
				}
			}
		}
	}

	if (fl == wep1) {
		if (wep1initems == IN_ITEMS1_HACKBANK || wep1initems == IN_ITEMS2_HACKBANK || wep1initems == IN_MODITEMS_HACKBANK || wep1initems == IN_PERMS_HACKBANK) inhackbank = TRUE;
	}
	if (fl == wep2) {
		if (wep2initems == IN_ITEMS1_HACKBANK || wep2initems == IN_ITEMS2_HACKBANK || wep2initems == IN_MODITEMS_HACKBANK || wep2initems == IN_PERMS_HACKBANK) inhackbank = TRUE;
	}
	if (fl == wep3) {
		if (wep3initems == IN_ITEMS1_HACKBANK || wep3initems == IN_ITEMS2_HACKBANK || wep3initems == IN_MODITEMS_HACKBANK || wep3initems == IN_PERMS_HACKBANK) inhackbank = TRUE;
	}
	if (fl == wep4) {
		if (wep4initems == IN_ITEMS1_HACKBANK || wep4initems == IN_ITEMS2_HACKBANK || wep4initems == IN_MODITEMS_HACKBANK || wep4initems == IN_PERMS_HACKBANK) inhackbank = TRUE;
	}

	retvec.x = fl;
	retvec.y = gotgun;
	retvec.z = inhackbank;
	return retvec;
};

// Check if got weapon and ammo and switch to relevant weapon
void(entity targ) W_ChangeWeapon = { // [FUNCTION]
	local float am, fl, gotgun, inhackbank;
	local vector checkvec;
	
	if (intermission_running > 0) return;	// intermission or finale
	if (cinematic_running > 0) return;		// Remote camera active

	am = FALSE;
	checkvec = VEC_ORIGIN;
	inhackbank = FALSE; // Assume we aren't looking into the hack bank of 2nd set of 24 weapons
	gotgun = FALSE;
	if (targ.impulse == 1) {
		checkvec = WeaponSlotPickOneOfThree(targ, IT_AXE, IT2_GRAPPLE, IT_MACE, IN_ITEMS1, IN_ITEMS2, IN_MODITEMS_HACKBANK);
		fl = checkvec_x;
		gotgun = checkvec_y;
		inhackbank = checkvec_z;
		if (fl == IT_AXE) {
			if (InModItems(targ, IT_UPGRADE_AXE)) gotgun = TRUE;
			if (self.perms & IT_CHAINSAW) gotgun = TRUE;
		}
		if (fl == IT_MACE) {
			if (targ.ammo_bloodcrystals < 1) am = TRUE; // no ammo
		}
	} else if (targ.impulse == 2) {
		checkvec = WeaponSlotPickOneOfThree(targ, IT_SHOTGUN, IT_ICE, IT_AIRGUN, IN_ITEMS1, IN_MODITEMS_HACKBANK, IN_PERMS_HACKBANK);
		fl = checkvec_x;
		gotgun = checkvec_y;
		inhackbank = checkvec_z;
		if (fl == IT_SHOTGUN) {
			if (targ.ammo_shells < 1) am = TRUE; // no ammo
		}
		if (fl == IT_ICE) {
			if (targ.ammo_elemental < 1) am = TRUE; // no ammo
		}
	} else if (targ.impulse == 3) {
		checkvec = WeaponSlotPickOneOfThree(targ, IT_SUPER_SHOTGUN, IT_SCIMITAR, 0, IN_ITEMS1, IN_MODITEMS, 0);
		fl = checkvec_x;
		gotgun = checkvec_y;
		inhackbank = checkvec_z;
		if (fl == IT_SUPER_SHOTGUN) {
			if (targ.ammo_shells < 1) am = TRUE; // no ammo
		}
		if (fl == IT_SCIMITAR) {
			if (targ.ammo_elemental < 1) am = TRUE; // no ammo
		}
	} else if (targ.impulse == 4) {
		checkvec = WeaponSlotPickOneOfThree(targ, IT_NAILGUN, IT_RAPIER, IT_LAVA_NAILGUN , IN_ITEMS1, IN_MODITEMS, IN_ITEMS1);
		fl = checkvec_x;
		gotgun = checkvec_y;
		inhackbank = checkvec_z;
		if (fl == IT_NAILGUN) {
			if (targ.ammo_nails < 1) am = TRUE; // no ammo
		}
		if (fl == IT_LAVA_NAILGUN) {
			if (targ.ammo_lava_nails < 1) am = TRUE; // no ammo
		}
		if (fl == IT_RAPIER) {
			am = FALSE; // not using ammo right now
		}
	} else if (targ.impulse == 5) {
		checkvec = WeaponSlotPickOneOfThree(targ, IT_SUPER_NAILGUN, IT_LAVA_SUPER_NAILGUN, IT_VOID_STAFF, IN_ITEMS1, IN_ITEMS1, IN_MODITEMS_HACKBANK);
		fl = checkvec_x;
		gotgun = checkvec_y;
		inhackbank = checkvec_z;
		if (fl == IT_SUPER_NAILGUN) {
			if (targ.ammo_nails < 1) am = TRUE; // no ammo
		}
		if (fl == IT_LAVA_SUPER_NAILGUN) {
			if (targ.ammo_lava_nails < 1) am = TRUE; // no ammo
		}
		if (fl == IT_VOID_STAFF) {
			if (targ.ammo_voidshards < 1) am = TRUE; // no ammo
		}
	} else if (targ.impulse == 6) {
		checkvec = WeaponSlotPickOneOfThree(targ, IT_GRENADE_LAUNCHER, IT2_PROXIMITY_GUN, IT_MULTI_GRENADE, IN_ITEMS1, IN_ITEMS2, IN_ITEMS1);
		fl = checkvec_x;
		gotgun = checkvec_y;
		inhackbank = checkvec_z;
		if (fl == IT_GRENADE_LAUNCHER) {
			if (targ.ammo_rockets < 1) am = TRUE; // no ammo
		}
		if (fl == IT2_PROXIMITY_GUN) {
			if (targ.ammo_rockets < 1) am = TRUE; // no ammo
		}
		if (fl == IT_MULTI_GRENADE) {
			if (targ.ammo_multi_rockets < 1) am = TRUE; // no ammo
		}
	} else if (targ.impulse == 7) {
		checkvec = WeaponSlotPickOneOfThree(targ, IT_ROCKET_LAUNCHER, IT_MULTI_ROCKET, IT_SANGUINATORS, IN_ITEMS1, IN_ITEMS1, IN_MODITEMS);
		fl = checkvec_x;
		gotgun = checkvec_y;
		inhackbank = checkvec_z;
		if (fl == IT_ROCKET_LAUNCHER) {
			if (targ.ammo_rockets < 1) am = TRUE; // no ammo
		}
		if (fl == IT_MULTI_ROCKET) {
			if (targ.ammo_multi_rockets < 1) am = TRUE; // no ammo
		}
		if (fl == IT_SANGUINATORS) {
			if (targ.ammo_bloodcrystals < 1) am = TRUE; // no ammo
		}
	} else if (targ.impulse == 8) {
		checkvec = WeaponSlotPickOneOfThree(targ, IT_LIGHTNING, IT_PLASMA_GUN, IT_FLAK, IN_ITEMS1, IN_ITEMS1, IN_MODITEMS_HACKBANK);
		fl = checkvec_x;
		gotgun = checkvec_y;
		inhackbank = checkvec_z;
		if (fl == IT_LIGHTNING) {
			if (targ.ammo_cells < 1) am = TRUE; // no ammo
		}
		if (fl == IT_PLASMA_GUN) {
			if (targ.ammo_plasma < 1) am = TRUE; // no ammo
		}
		if (fl == IT_FLAK) {
			if (targ.ammo_nails < 1) am = TRUE; // no ammo
		}
	} else if (targ.impulse == 90) {
		checkvec = WeaponSlotPickOneOfThree(targ, IT_EXTRA_WEAPON, IT2_LASER_CANNON, IT2_CHAINLIGHTNING, IN_ITEMS1, IN_ITEMS2, IN_ITEMS2);
		fl = checkvec_x;
		gotgun = checkvec_y;
		inhackbank = checkvec_z;
		if (fl == IT_EXTRA_WEAPON) {
			if (targ.ammo_bolts < 1) am = TRUE; // no ammo
		}
		if (fl == IT2_LASER_CANNON) {
			if (targ.ammo_cells < 1) am = TRUE; // no ammo
		}
		if (fl == IT2_CHAINLIGHTNING) {
			if (targ.ammo_cells < 1) am = TRUE; // no ammo
		}
	} else if (targ.impulse == 60) {
		fl = IT_LAVA_NAILGUN;
		if (targ.ammo_lava_nails < 1) am = TRUE;
		gotgun = InItems(targ, fl);
	} else if (targ.impulse == 61) {
		fl = IT_LAVA_SUPER_NAILGUN;
		if (targ.ammo_lava_nails < 2) am = TRUE;
		gotgun = InItems(targ, fl);
	} else if (targ.impulse == 62) {
		fl = IT_MULTI_GRENADE;
		if (targ.ammo_multi_rockets < 1) am = TRUE;
		gotgun = InItems(targ, fl);
	} else if (targ.impulse == 63) {
		fl = IT_MULTI_ROCKET;
		if (targ.ammo_multi_rockets < 1) am = TRUE;
		gotgun = InItems(targ, fl);
	} else if (targ.impulse == 64) {
		fl = IT_PLASMA_GUN;
		if (targ.ammo_plasma < 1) am = TRUE;
		gotgun = InItems(targ, fl);
	} else if (targ.impulse == 75) {
		fl = IT2_LASER_CANNON;
		if (targ.ammo_cells < 1) am = TRUE;
		gotgun = InItems2(targ, fl);
	} else if (targ.impulse == 76) {
		fl = IT2_PROXIMITY_GUN;
		gotgun = InItems2(targ, fl);
	} else if (targ.impulse == 77) {
		checkvec = WeaponSlotPickOneOfThree(targ, IT2_MJOLNIR, IT2_CROSS, IT_GUNGNIR, IN_ITEMS2, IN_ITEMS2, IN_MODITEMS_HACKBANK);
		fl = checkvec_x;
		gotgun = checkvec_y;
		inhackbank = checkvec_z;
		if (fl == IT_GUNGNIR) {
			if (targ.ammo_voidshards < 1) am = TRUE; // no ammo
		}
	} else if (targ.impulse == 78) {
		fl = IT_EXTRA_WEAPON;
		gotgun = InItems(targ, fl);
	} else if (targ.impulse == 79) {
		fl = IT2_CROSS;
		gotgun = InItems2(targ, fl);
	} else if (targ.impulse == 80) {
		fl = IT2_GRAPPLE;
		gotgun = InItems2(targ, fl);
	} else if (targ.impulse == 81) {
		fl = IT2_CHAINLIGHTNING;
		gotgun = InItems2(targ, fl);
	} else if (targ.impulse == 82) {
		fl = IT_ICE;
		inhackbank = TRUE; // Ok we are hacking now, switch to 2nd set of 24 weapons in bank 2
		gotgun = InModItems(targ, fl);
	} else if (targ.impulse == 83) {
		fl = IT_MACE;
		inhackbank = TRUE; // Ok we are hacking now, switch to 2nd set of 24 weapons in bank 2
		gotgun = InModItems(targ, fl);
	} else if (targ.impulse == 84) {
		fl = IT_VOID_STAFF;
		inhackbank = TRUE; // Ok we are hacking now, switch to 2nd set of 24 weapons in bank 2
		gotgun = InModItems(targ, fl);
	} else if (targ.impulse == 85) {
		fl = IT_FLAK;
		inhackbank = TRUE; // Ok we are hacking now, switch to 2nd set of 24 weapons in bank 2
		gotgun = InModItems(targ, fl);
	} else if (targ.impulse == 86) {
		fl = IT_GUNGNIR;
		inhackbank = TRUE; // Ok we are hacking now, switch to 2nd set of 24 weapons in bank 2
		gotgun = InModItems(targ, fl);
	} else if (targ.impulse == 87) {
		fl = IT_SANGUINATORS;
		gotgun = InModItems(targ, fl);
	} else if (targ.impulse == 88) {
		fl = IT_SCIMITAR;
		gotgun = InModItems(targ, fl);
	} else if (targ.impulse == 89) {
		fl = IT_RAPIER;
		gotgun = InModItems(targ, fl);
	} else if (targ.impulse == 47) {
		fl = IT_AIRGUN;
		inhackbank = TRUE; // Ok we are hacking now, switch to 2nd set of 24 weapons in bank 2
		gotgun = InPerms(targ, fl);
	}
	targ.impulse = 0; // Clear impulse
	if (!(gotgun)) { sprint(targ,"no weapon.\n"); return; } //Do we have this weapon?
	if (am) { sprint(targ,"not enough ammo.\n"); return; } //Do we have ammo?

	if (inhackbank) {
		targ.selfweaponismoditems = TRUE;
		if (fl == IT_ICE) {
			sprint (targ,"Elemental Tome!\n");
		} else {
			if (fl== IT_MACE) {
				sprint (targ,"Vampiric Mace!\n");
			} else {
				if (fl== IT_VOID_STAFF) {
					sprint (targ,"Void Staff!\n");
				} else {
					if (fl == IT_FLAK) {
						sprint (targ,"Flak Cannon!\n");
					} else {
						if (fl == IT_AIRGUN) {
							sprint (targ,"Air Fist!\n");
						} else {
							if (fl == IT_GUNGNIR) sprint (targ,"Gungnir!\n");
						}
					}
				}
			}
		}
	} else {
		targ.selfweaponismoditems = FALSE;
		if ( (targ.weapon != fl) ) {
		  if ( ((targ.weapon == IT_LAVA_NAILGUN) || (targ.weapon == IT_LAVA_SUPER_NAILGUN)) ) {
			 if ( ((fl == IT_NAILGUN) || (fl == IT_SUPER_NAILGUN)) ) {
				sprint (targ,"Normal Nails\n");
			 }
		  } else {
			 if ( (targ.weapon == IT_MULTI_GRENADE) ) {
				if ( (fl == IT_GRENADE_LAUNCHER) ) {
				   sprint (targ,"Normal Grenades\n");
				}
			 } else {
				if ( (targ.weapon == IT_MULTI_ROCKET) ) {
				   if (fl == IT_ROCKET_LAUNCHER) sprint (targ,"Normal Rockets\n");
				} else {
				   if ( (targ.weapon == IT_PLASMA_GUN) ) {
					  if ( (fl == IT_LIGHTNING) ) {
						 if (targ.moditems & IT_UPGRADE_LG) {
							sprint (targ,"Plasma Gun\n");
						 } else {
							sprint (targ,"Lightning Gun\n");
						 }
					  }
				   } else {
					  if ( ((fl == IT_LAVA_NAILGUN) || (fl == IT_LAVA_SUPER_NAILGUN)) ) {
						 sprint (targ,"Lava Nails!\n");
					  } else {
						 if ( (fl == IT_MULTI_GRENADE) ) {
							sprint (targ,"Multi-Grenades!\n");
						 } else {
							if ( (fl == IT_MULTI_ROCKET) ) {
							   sprint (targ,"Multi-Rockets!\n");
							} else {
							   if ( (fl == IT_PLASMA_GUN) ) {
								  sprint (targ,"Plasma Gun!\n");
							   } else {
								  if ( (fl == IT2_PROXIMITY_GUN) ) {
									 sprint (targ,"Proximity Grenades!\n");
								  } else {
									 if ( (fl == IT2_LASER_CANNON) ) {
										sprint (targ,"Laser Cannon!\n");
									 }  else {
										if ( (fl == IT2_CROSS) ) {
											sprint (targ,"Magic Wand!\n");
										}  else {
											if ( (fl == IT2_MJOLNIR) ) {
												sprint (targ,"Mjolnir's Hammer!\n");
											} else {
												if ( (fl == IT_SANGUINATORS) ) {
													sprint (targ,"Sanguinators!\n");
												} else {
													if ( (fl == IT_SCIMITAR) ) {
														sprint (targ,"Fire Scimitar!\n");
													} else {
														if ( (fl == IT_RAPIER) ) sprint (targ,"Ghost Rapier!\n"); // Sharp if nest there, don't prick your eyes.
													}
												}
											}
										}
									 }
								  }
							   }
							}
						 }
					  }
				   }
				}
			 }
		  }
	   }
	}
	targ.weapon = fl;
	W_SetCurrentAmmo (targ);
};

// Returns unique ID in list of weapon cycling order.  Refer to defskeep.qc for the list and ID's
float GetWepIDIndex (float wep, float inhackbank) = { // [FUNCTION]
	float retval;
	retval = 0;
	if (inhackbank) {
		if (wep == IT_MACE) 		retval = ID_MACE;
		if (wep == IT_ICE)			retval = ID_ICE;
		if (wep == IT_VOID_STAFF)	retval = ID_VOIDSTAFF;
		if (wep == IT_FLAK) 		retval = ID_FLAK;
		if (wep == IT_GUNGNIR) 		retval = ID_GUNGNIR;
		if (wep == IT_AIRGUN) 		retval = ID_AIRGUN;
	} else {
		if (wep == IT2_GRAPPLE) 			retval = ID_GRAPPLE;
		if (wep == IT_AXE)					retval = ID_AXE_SHADAXE_CHAINSAW;
		if (wep == IT_SHOTGUN)				retval = ID_SHOTGUN_BLASTER;
		if (wep == IT_SUPER_SHOTGUN)		retval = ID_SUPER_SHOTGUN_WIDOWMAKER_SHOTCYCLER_QUADSHOTTY;
		if (wep == IT_SCIMITAR)				retval = ID_SCIMITAR;
		if (wep == IT_NAILGUN)				retval = ID_NAILGUN;
		if (wep == IT_LAVA_NAILGUN)			retval = ID_LAVANAILGUN;
		if (wep == IT_RAPIER)				retval = ID_RAPIER;
		if (wep == IT_SUPER_NAILGUN)		retval = ID_PERFORATOR;
		if (wep == IT_LAVA_SUPER_NAILGUN)	retval = ID_LAVASUPERNAILGUN;
		if (wep == IT_GRENADE_LAUNCHER)		retval = ID_GRENADE_LAUNCHER;
		if (wep == IT2_PROXIMITY_GUN)		retval = ID_PROXIMITY_GRENADE;
		if (wep == IT_MULTI_GRENADE)		retval = ID_MULTI_GRENADE;
		if (wep == IT_ROCKET_LAUNCHER)		retval = ID_ROCKETLAUNCHER;
		if (wep == IT_MULTI_ROCKET)			retval = ID_MULTIROCKETLAUNCHER;
		if (wep == IT_SANGUINATORS)			retval = ID_SANGUINATORS;
		if (wep == IT_LIGHTNING)			retval = ID_THUNDERBOLT_AD_PLASMAGUN;
		if (wep == IT_PLASMA_GUN)			retval = ID_PLASMAGUN_ROGUE;
		if (wep == IT_EXTRA_WEAPON)			retval = ID_CROSSBOW;
		if (wep == IT2_LASER_CANNON)		retval = ID_LASER_CANNON;
		if (wep == IT2_CHAINLIGHTNING)		retval = ID_CHAINLIGHTNING;
		if (wep == IT2_CROSS)				retval = ID_WANDCROSS2;
		if (wep == IT2_MJOLNIR)				retval = ID_MJOLNIR;
	}
	return retval;
};

vector GetWepIT_FromID(float id) = { // [FUNCTION]
	local vector retval;

	retval = VEC_ORIGIN;
	if (id == ID_MACE ) 		{ retval_x = IT_MACE;			retval_y = TRUE; } // in hack bank
	if (id == ID_ICE )			{ retval_x = IT_ICE;			retval_y = TRUE; }
	if (id == ID_VOIDSTAFF )	{ retval_x = IT_VOID_STAFF;		retval_y = TRUE; }
	if (id == ID_FLAK ) 		{ retval_x = IT_FLAK;			retval_y = TRUE; }
	if (id == ID_GUNGNIR ) 		{ retval_x = IT_GUNGNIR;		retval_y = TRUE; }
	if (id == ID_AIRGUN ) 		{ retval_x = IT_AIRGUN;			retval_y = TRUE; }
	if (id == ID_GRAPPLE ) 				{ retval_x = IT2_GRAPPLE; retval_y = FALSE; }
	if (id == ID_AXE_SHADAXE_CHAINSAW )	{ retval_x = IT_AXE; retval_y = FALSE; }
	if (id == ID_SHOTGUN_BLASTER )		{ retval_x = IT_SHOTGUN; retval_y = FALSE; }
	if (id == ID_SUPER_SHOTGUN_WIDOWMAKER_SHOTCYCLER_QUADSHOTTY ) { retval_x = IT_SUPER_SHOTGUN; retval_y = FALSE; }
	if (id == ID_SCIMITAR )				{ retval_x = IT_SCIMITAR; retval_y = FALSE; }
	if (id == ID_NAILGUN )				{ retval_x = IT_NAILGUN; retval_y = FALSE; }
	if (id == ID_LAVANAILGUN )			{ retval_x = IT_LAVA_NAILGUN; retval_y = FALSE; }
	if (id == ID_RAPIER )				{ retval_x = IT_RAPIER; retval_y = FALSE; }
	if (id == ID_PERFORATOR )			{ retval_x = IT_SUPER_NAILGUN; retval_y = FALSE; }
	if (id == ID_LAVASUPERNAILGUN )		{ retval_x = IT_LAVA_SUPER_NAILGUN; retval_y = FALSE; }
	if (id == ID_GRENADE_LAUNCHER )		{ retval_x = IT_GRENADE_LAUNCHER; retval_y = FALSE; }
	if (id == ID_PROXIMITY_GRENADE )	{ retval_x = IT2_PROXIMITY_GUN; retval_y = FALSE; }
	if (id == ID_MULTI_GRENADE )		{ retval_x = IT_MULTI_GRENADE; retval_y = FALSE; }
	if (id == ID_ROCKETLAUNCHER )		{ retval_x = IT_ROCKET_LAUNCHER; retval_y = FALSE; }
	if (id == ID_MULTIROCKETLAUNCHER )	{ retval_x = IT_MULTI_ROCKET; retval_y = FALSE; }
	if (id == ID_SANGUINATORS )			{ retval_x = IT_SANGUINATORS; retval_y = FALSE; }
	if (id == ID_THUNDERBOLT_AD_PLASMAGUN) { retval_x = IT_LIGHTNING; retval_y = FALSE; }
	if (id == ID_PLASMAGUN_ROGUE )		{ retval_x = IT_PLASMA_GUN; retval_y = FALSE; }
	if (id == ID_CROSSBOW )				{ retval_x = IT_EXTRA_WEAPON; retval_y = FALSE; }
	if (id == ID_LASER_CANNON )			{ retval_x = IT2_LASER_CANNON; retval_y = FALSE; }
	if (id == ID_CHAINLIGHTNING )		{ retval_x = IT2_CHAINLIGHTNING; retval_y = FALSE; }
	if (id == ID_WANDCROSS2 )			{ retval_x = IT2_CROSS; retval_y = FALSE; }
	if (id == ID_MJOLNIR )				{ retval_x = IT2_MJOLNIR; retval_y = FALSE; }
	return retval;
};

void() CycleWeaponCommand = { // [FUNCTION]
	local float	am, inhackbank, wepID, cyclecheck;
	local vector idconversion;
	
	inhackbank = FALSE;
	if (self.selfweaponismoditems) inhackbank = TRUE;
	if (intermission_running > 0) return;		// intermission or finale
	if (cinematic_running > 0) return;		// Remote camera active
	self.impulse = 0;			// reset impulse
	cyclecheck = 0; // counter to see how many times we go through the loop
	if (self.weapon == 0 && self.items == 0 && self.items2 == 0 && self.moditems == 0 && self.perms == 0) return;
	wepID = GetWepIDIndex(self.weapon, inhackbank);

	// Keep cycling around weapon list until found a weapon with ammo
	while (1) {
		am = 0;
		cyclecheck = cyclecheck + 1;
		if (cyclecheck > 100) return; // exit gracefully, no runaway loop error
		if (wepID == ID_GRAPPLE) {
			wepID = ID_AXE_SHADAXE_CHAINSAW;
		} else if (wepID == ID_AXE_SHADAXE_CHAINSAW) {
			wepID = ID_MACE;
		} else if (wepID == ID_MACE) {
			wepID = ID_SHOTGUN_BLASTER;
			if (self.ammo_shells < 1) am = 1;
		} else if (wepID == ID_SHOTGUN_BLASTER) {
			wepID = ID_AIRGUN;
		} else if (wepID == ID_AIRGUN) {
			wepID = ID_ICE;
			if (self.ammo_elemental < 1) am = 1;
		} else if (wepID == ID_ICE) {
			wepID = ID_SUPER_SHOTGUN_WIDOWMAKER_SHOTCYCLER_QUADSHOTTY;
			if (self.ammo_shells < 1) am = 1; // only checking for 1 shell since autoshotgun/shotcycler might only use 1
		} else if (wepID == ID_SUPER_SHOTGUN_WIDOWMAKER_SHOTCYCLER_QUADSHOTTY) {
			wepID = ID_SCIMITAR;
		} else if (wepID == ID_SCIMITAR) {
			wepID = ID_NAILGUN;
			if (self.ammo_nails < 1) am = 1;
		} else if (wepID == ID_NAILGUN) {
			wepID = ID_LAVANAILGUN;
			if (self.ammo_lava_nails < 2) am = 1;
		} else if (wepID == ID_LAVANAILGUN) {
			wepID = ID_RAPIER;
			if (self.ammo_bloodcrystals < 1) am = 1;
		} else if (wepID == ID_RAPIER) {
			wepID = ID_PERFORATOR;
			if (self.ammo_nails < 2) am = 1;
		} else if (wepID == ID_PERFORATOR) {
			wepID = ID_LAVASUPERNAILGUN;
			if (self.ammo_lava_nails < 2) am = 1;
		} else if (wepID == ID_LAVASUPERNAILGUN) {
			wepID = ID_VOIDSTAFF;
			if (self.ammo_voidshards < 1) am = 1;
		} else if (wepID == ID_VOIDSTAFF) {
			wepID = ID_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1) am = 1;
		} else if (wepID == ID_GRENADE_LAUNCHER) {
			wepID = ID_PROXIMITY_GRENADE;
			if (self.ammo_rockets < 1) am = 1;
		} else if (wepID == ID_PROXIMITY_GRENADE) {
			wepID = ID_MULTI_GRENADE;
			if (self.ammo_multi_rockets < 1) am = 1;
		} else if (wepID == ID_MULTI_GRENADE) {
			wepID = ID_ROCKETLAUNCHER;
			if (self.ammo_rockets < 1) am = 1;
		} else if (wepID == ID_ROCKETLAUNCHER) {
			wepID = ID_MULTIROCKETLAUNCHER;
			if (self.ammo_multi_rockets < 1) am = 1;
		} else if (wepID == ID_MULTIROCKETLAUNCHER) {
			wepID = ID_SANGUINATORS;
			if (self.ammo_bloodcrystals < 1) am = 1;
		} else if (wepID == ID_SANGUINATORS) {
			wepID = ID_THUNDERBOLT_AD_PLASMAGUN;
			if (self.ammo_cells < 1) am = 1;
		} else if (wepID == ID_THUNDERBOLT_AD_PLASMAGUN) {
			wepID = ID_PLASMAGUN_ROGUE;
			if (self.ammo_plasma < 1) am = 1;
		} else if (wepID == ID_PLASMAGUN_ROGUE) {
			wepID = ID_FLAK;
			if (self.ammo_rockets < FLAK_ROCKETUSAGE || self.ammo_nails < FLAK_NAILUSAGE) am = 1; // Flak uses multiple nails & rockets per shot
		} else if (wepID == ID_FLAK) {
			wepID = ID_CROSSBOW;
			if (self.ammo_bolts < 1 && self.ammo_poison < 1) am = 1;
		} else if (wepID == ID_CROSSBOW) {
			wepID = ID_LASER_CANNON;
			if (self.ammo_cells < 1) am = 1;
		} else if (wepID == ID_LASER_CANNON) {
			wepID = ID_CHAINLIGHTNING;
			if (self.ammo_cells < 1) am = 1;
		} else if (wepID == ID_CHAINLIGHTNING) {
			wepID = ID_WANDCROSS2;
		} else if (wepID == ID_WANDCROSS2) {
			wepID = ID_MJOLNIR;
		} else if (wepID == ID_MJOLNIR) {
			wepID = ID_GUNGNIR;
			if (self.ammo_voidshards < 1) am = 1;
		} else if (wepID == ID_GUNGNIR) {
			wepID = ID_GRAPPLE;
		}

		if (wepID == FALSE) {
			return; // prevent crash in "cinematic mode"
		}

		// ok we found the weapon from the full list, turn it back into a normal IT_ number
		idconversion = GetWepIT_FromID(wepID);
		self.weapon =  idconversion_x;
		self.selfweaponismoditems = idconversion_y;
		if (self.selfweaponismoditems) inhackbank = TRUE; // just in case I need to add a check below
		else inhackbank = FALSE;

		// Has the player got the weapons and ammo to switch?
		if (inhackbank) {
			if (wepID == ID_MACE || wepID == ID_ICE || wepID == ID_VOIDSTAFF || wepID == ID_FLAK || wepID == ID_GUNGNIR) {
				if ((self.moditems & self.weapon) && !am) {
					W_SetCurrentAmmo (self);
					dprint("idconversion: ");
					dprint(ftos(idconversion_x));
					dprint(" ");
					dprint(ftos(idconversion_y));
					dprint("\n");
					return;
				}
			}
		} else {
			if (wepID == ID_RAPIER) {
				if ((self.moditems & self.weapon) && !am) {
					W_SetCurrentAmmo (self);
					dprint("idconversion: ");
					dprint(ftos(idconversion_x));
					dprint(" ");
					dprint(ftos(idconversion_y));
					dprint("\n");
					return;
				}
			} else if (wepID == ID_LASER_CANNON || wepID == ID_MJOLNIR || wepID == ID_PROXIMITY_GRENADE || wepID == ID_WANDCROSS2 || wepID == ID_GRAPPLE || wepID == ID_CHAINLIGHTNING) {
				if ((self.items2 & self.weapon) && !am) {
					W_SetCurrentAmmo (self);
					dprint("idconversion: ");
					dprint(ftos(idconversion_x));
					dprint(" ");
					dprint(ftos(idconversion_y));
					dprint("\n");
					return;
				}
			} else {
				if ((self.items & self.weapon) && !am) {
					W_SetCurrentAmmo (self);
					dprint("idconversion: ");
					dprint(ftos(idconversion_x));
					dprint(" ");
					dprint(ftos(idconversion_y));
					dprint("\n");
					return;
				}
			}
		}
	}
};

void() CycleWeaponReverseCommand = { // [FUNCTION]
	local float	am, inhackbank, wepID, cyclecheck;
	local vector idconversion;
	
	inhackbank = FALSE;
	if (self.selfweaponismoditems) inhackbank = TRUE;
	if (intermission_running > 0) return;		// intermission or finale
	if (cinematic_running > 0) return;		// Remote camera active
	self.impulse = 0;			// reset impulse
	cyclecheck = 0; // counter to see how many times we go through the loop
	if (self.weapon == 0 && self.items == 0 && self.items2 == 0 && self.moditems == 0 && self.perms == 0) return;
	wepID = GetWepIDIndex(self.weapon, inhackbank);

	// Keep cycling around weapon list until found a weapon with ammo
	while (1) {
		am = 0;
		cyclecheck = cyclecheck + 1;
		if (cyclecheck > 100) return; // exit gracefully, no runaway loop error
		if (wepID == ID_GUNGNIR) {
			wepID = ID_MJOLNIR;
		} else if (wepID == ID_MJOLNIR) {
			wepID = ID_WANDCROSS2;
		} else if (wepID == ID_WANDCROSS2) {
			wepID = ID_CHAINLIGHTNING;
			if (self.ammo_cells < 1) am = 1;
		} else if (wepID == ID_CHAINLIGHTNING) {
			wepID = ID_LASER_CANNON;
			if (self.ammo_cells < 2) am = 1;
		} else if (wepID == ID_LASER_CANNON) {
			wepID = ID_CROSSBOW;
			if (self.ammo_bolts < 1 && self.ammo_poison < 1) am = 1;
		} else if (wepID == ID_CROSSBOW) {
			wepID = ID_FLAK;
			if (self.ammo_rockets < FLAK_ROCKETUSAGE || self.ammo_nails < FLAK_NAILUSAGE) am = 1; // Flak uses multiple nails & rockets per shot
		} else if (wepID == ID_FLAK) {
			wepID = ID_PLASMAGUN_ROGUE;
			if (self.ammo_plasma < 1) am = 1;
		} else if (wepID == ID_PLASMAGUN_ROGUE) {
			wepID = ID_THUNDERBOLT_AD_PLASMAGUN;
			if (self.ammo_cells < 1) am = 1;
		} else if (wepID == ID_THUNDERBOLT_AD_PLASMAGUN) {
			wepID = ID_SANGUINATORS;
			if (self.ammo_bloodcrystals < 1) am = 1;
		} else if (wepID == ID_SANGUINATORS) {
			wepID = ID_MULTIROCKETLAUNCHER;
			if (self.ammo_multi_rockets < 1) am = 1;
		} else if (wepID == ID_MULTIROCKETLAUNCHER) {
			wepID = ID_ROCKETLAUNCHER;
			if (self.ammo_rockets < 1) am = 1;
		} else if (wepID == ID_ROCKETLAUNCHER) {
			wepID = ID_MULTI_GRENADE;
			if (self.ammo_multi_rockets < 1) am = 1;
		} else if (wepID == ID_MULTI_GRENADE) {
			wepID = ID_PROXIMITY_GRENADE;
			if (self.ammo_rockets < 1) am = 1;
		} else if (wepID == ID_PROXIMITY_GRENADE) {
			wepID = ID_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1) am = 1;
		} else if (wepID == ID_GRENADE_LAUNCHER) {
			wepID = ID_VOIDSTAFF;
			if (self.ammo_voidshards < 1) am = 1;
		} else if (wepID == ID_VOIDSTAFF) {
			wepID = ID_LAVASUPERNAILGUN;
			if (self.ammo_lava_nails < 2) am = 1;
		} else if (wepID == ID_LAVASUPERNAILGUN) {
			wepID = ID_PERFORATOR;
			if (self.ammo_nails < 2) am = 1;
		} else if (wepID == ID_PERFORATOR) {
			wepID = ID_RAPIER;
			if (self.ammo_bloodcrystals < 1) am = 1;
		} else if (wepID == ID_RAPIER) {
			wepID = ID_LAVANAILGUN;
			if (self.ammo_lava_nails < 1) am = 1;
		} else if (wepID == ID_LAVANAILGUN) {
			wepID = ID_NAILGUN;
			if (self.ammo_nails < 1) am = 1;
		} else if (wepID == ID_NAILGUN) {
			wepID = ID_SCIMITAR;
		} else if (wepID == ID_SCIMITAR) {
			wepID = ID_SUPER_SHOTGUN_WIDOWMAKER_SHOTCYCLER_QUADSHOTTY;
			if (self.ammo_shells < 1) am = 1; // only checking for 1 shell since autoshotgun/shotcycler might only use 1
		} else if (wepID == ID_SUPER_SHOTGUN_WIDOWMAKER_SHOTCYCLER_QUADSHOTTY) {
			wepID = ID_ICE;
			if (self.ammo_elemental < 1) am = 1;
		} else if (wepID == ID_ICE) {
			wepID = ID_AIRGUN;
		} else if (wepID == ID_AIRGUN) {
			wepID = ID_SHOTGUN_BLASTER;
			if (self.ammo_shells < 1) am = 1;
		} else if (wepID == ID_SHOTGUN_BLASTER) {
			wepID = ID_MACE;
		} else if (wepID == ID_MACE) {
			wepID = ID_AXE_SHADAXE_CHAINSAW;
		} else if (wepID == ID_AXE_SHADAXE_CHAINSAW) {
			wepID = ID_GRAPPLE;
		} else if (wepID == ID_GRAPPLE) {
			wepID = ID_GUNGNIR;
			if (self.ammo_voidshards < 1) am = 1;
		}

		if (wepID == FALSE) return; // prevent crash in "cinematic mode"

		// ok we found the weapon from the full list, turn it back into a normal IT_ number
		idconversion = GetWepIT_FromID(wepID);
		self.weapon = idconversion_x;
		self.selfweaponismoditems = idconversion_y;
		if (self.selfweaponismoditems) inhackbank = TRUE; // just in case I need to add a check below
		else inhackbank = FALSE;

		// Has the player got the weapons and ammo to switch?
		if (inhackbank) {
			if (wepID == ID_MACE || wepID == ID_ICE || wepID == ID_VOIDSTAFF || wepID == ID_FLAK || wepID == ID_GUNGNIR || wepID == ID_AIRGUN) {
				if ((self.moditems & self.weapon) && !am) {
					W_SetCurrentAmmo (self);
					dprint("idconversion: ");
					dprint(ftos(idconversion_x));
					dprint(" ");
					dprint(ftos(idconversion_y));
					dprint("\n");
					return;
				}
			}
		} else {
			if (wepID == ID_RAPIER) {
				if ((self.moditems & self.weapon) && !am) {
					W_SetCurrentAmmo (self);
					dprint("idconversion: ");
					dprint(ftos(idconversion_x));
					dprint(" ");
					dprint(ftos(idconversion_y));
					dprint("\n");
					return;
				}
			} else if (wepID == ID_LASER_CANNON || wepID == ID_MJOLNIR || wepID == ID_PROXIMITY_GRENADE || wepID == ID_WANDCROSS2 || wepID == ID_GRAPPLE || wepID == ID_CHAINLIGHTNING) {
				if ((self.items2 & self.weapon) && !am) {
					W_SetCurrentAmmo (self);
					dprint("idconversion: ");
					dprint(ftos(idconversion_x));
					dprint(" ");
					dprint(ftos(idconversion_y));
					dprint("\n");
					return;
				}
			} else {
				if ((self.items & self.weapon) && !am) {
					W_SetCurrentAmmo (self);
					dprint("idconversion: ");
					dprint(ftos(idconversion_x));
					dprint(" ");
					dprint(ftos(idconversion_y));
					dprint("\n");
					return;
				}
			}
		}
	}
};

void() W_WeaponFrame = { // [FUNCTION]
	if (self.lavaGunFired) {
		if (self.weapon == IT_LAVA_NAILGUN || self.weapon == IT_LAVA_SUPER_NAILGUN) {
			sound (self, CHAN_BODY, "rogue/weapons/snail.wav", 1, ATTN_NORM);
		}
		self.lavaGunFired = 0;
	}

	if (time < self.attack_finished) {
		if (!self.button0) {
			if (!self.b0_click) self.b0_click = 1; // Released button.

			// Check for loose MIRVs.
			if (self.weapon == IT3_MIRV && self.selfweaponismoditems != 1) Mirv_Use ();
		}
		return;
	}

	ImpulseCommands ();

	// Change crossbow skin if bolts are poisoned
	if (self.ammo_poison > 0) W_SetCurrentAmmo (self);

	// check for attack
	if (self.button0) {
		if (self.b0_click) self.b0_click = 2; // Just double-clicked.

		// originally - SuperDamageSound
		// Only play one powerup sound at once
		if (self.super_damage_finished > 0 && self.powerup_sound < time) {
			if (self.super_sound < time) {
				self.super_sound = time + 1;
				self.powerup_sound = time + 1;
				sound (self, CHAN_BODY, SOUND_ARTQUAD3, 1, ATTN_NORM);
			}
		}
		// Only play one powerup sound at once
		if (self.sharpshoot_finished > 0 && self.powerup_sound < time) {
			// Only works with the shotguns
			if (self.weapon == IT_SHOTGUN || self.weapon == IT_SUPER_SHOTGUN) {
				if (self.sharpshooter_sound < time) {
					self.sharpshooter_sound = time + 0.5;
					// Only play the sound every other shot
					self.powerup_sound = time + 1;
					sound (self, CHAN_BODY, SOUND_ARTSHARP3, 1, ATTN_NORM);
				}
			}
		}
		// Only play one powerup sound at once
		if (self.nailpiercer_finished > 0 && self.powerup_sound < time) {
			// Only works with nailgun + super nailgun
			if (self.weapon == IT_NAILGUN || self.weapon == IT_SUPER_NAILGUN) {
				if (self.nailpiercer_sound < time) {
					self.nailpiercer_sound = time + 0.5;
					self.powerup_sound = time + 1;
					sound (self, CHAN_BODY, SOUND_ARTNAILP3, 1, ATTN_NORM);
				}
			}
		}
		// Check for weapon updates
		W_Attack ();
	} else {
		if (self.weapon == IT3_MIRV && self.selfweaponismoditems != 1) {
			if (self.mirv1) Mirv_Use();
		}
	}
};