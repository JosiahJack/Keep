void() player_run;
void(vector p1, vector p2, entity from, float damage) LightningDamage;
void(vector p1, vector p2, entity from, float damage) PlayerLightningDamage;
void(float reload) W_Reload;

//   SPHERE #techdebt to remove it when no longer necessary

void() SphereFrames = 
{
	self.frame = self.frame + 1;
	if (self.frame > 5)
		self.frame = 0;
	self.nextthink = time + 0.1;
	self.think = SphereFrames;
	
	if (time > self.attack_finished)
		remove(self);
	
};

void() MakeSphere =
{
	local entity sphere;
	
	sphere = spawn();
	sphere.owner = self;
	sphere.classgroup = CG_PROJALL;
	sphere.solid = SOLID_NOT;
	sphere.movetype = MOVETYPE_NONE;
	
	setmodel (sphere, "progs/aoa/sphere.mdl");
	setsize (sphere, '0 0 0', '0 0 0');
	setorigin (sphere, self.origin);
	sphere.attack_finished = time + 10;
	
	sphere.nextthink = time + 0.1;
	sphere.think = SphereFrames;

};

/*
=======================================================
Scimitar of Fire by ryanscissorhands	#scimitar #ryanscissorhands #sword
=======================================================
*/
void() RyanscissorhandsChecks = //called to ensure that the proper player model is being used while wielding weapons.
{
	if (self.weapon == IT_SCIMITAR && !self.selfweaponismoditems) //set player model for scimitar
	{
		setPlayerModel("progs/aoa/player_scimitar.mdl");
	}
	else if (self.weapon == IT_RAPIER && self.selfweaponismoditems) //set player model for rapier
	{
		setPlayerModel("progs/aoa/player_rapier.mdl");
	}
	else
	{
		setPlayerModel("progs/player.mdl");
	}
};

void(float projectileNumber) SwordMagic;
void(float attackNumber) SwordSwing;

void() sword1Attack1 = [32, sword1Attack2] {self.weaponframe = 1;};
void() sword1Attack2 = [33, sword1Attack3] {self.weaponframe = 2;};
void() sword1Attack3 = [34, sword1Attack4]
{
	self.weaponframe = 3;SwordSwing(1);
	if (self.tome_finished) //Tome of Power:every attack launches a fire projectile. #tomeflag
	{
		SwordMagic(1);
		sound (self, CHAN_WEAPON, SOUND_AXE_SWIPE2, 1, ATTN_NORM);
	}
};

void() sword1Attack4 = [35, sword1Attack5] {self.weaponframe = 4;};
void() sword1Attack5 = [36, sword2Attack1]
{
	self.weaponframe = 5;
	if (!self.button0)
	{
		player_run();
		return;
	}
	W_Reload(0.6);
};

void() sword2Attack1 = [37, sword2Attack2] {self.weaponframe = 7;sound (self, CHAN_WEAPON, SOUND_AXE_SWIPE2, 1, ATTN_NORM);};
void() sword2Attack2 = [38, sword2Attack3] {self.weaponframe = 8;};
void() sword2Attack3 = [39, sword2Attack4]
{
	self.weaponframe = 9;
	SwordSwing(2);
	if (self.tome_finished) //Tome of Power:every attack launches a fire projectile. #tomeflag #tomeflag
	{
		SwordMagic(1);
		sound (self, CHAN_WEAPON, SOUND_AXE_SWIPE2, 1, ATTN_NORM);
	}
};
void() sword2Attack4 = [40, sword2Attack5] {self.weaponframe = 10;};
void() sword2Attack5 = [41, sword2Attack6] {self.weaponframe = 11;};
void() sword2Attack6 = [42, sword3Attack1]
{
	self.weaponframe = 12;
	if (!self.button0 || self.ammo_elemental < 1)
	{
		player_run();
		return;
	}
	W_Reload(0.8);
};

void() sword3Attack1 = [43, sword3Attack3]
{
	self.weaponframe = 13;
	

};
void() sword3Attack3 = [45, sword3Attack5] {self.weaponframe = 15;};
void() sword3Attack5 = [47, sword3Attack6]
{
	self.weaponframe = 17;
	SwordSwing(3);
	sound (self, CHAN_WEAPON, SOUND_AXE_SWIPE2, 1, ATTN_NORM);
};
void() sword3Attack6 = [0, sword3Attack7] {self.weaponframe = 18;};
void() sword3Attack7 = [1, sword3Attack8]
{
	self.weaponframe = 19;
	if (self.ammo_elemental > 2) //if they have ammo, consume it to fire projectile
	{
		SwordMagic(3);//launch projectile
		self.currentammo = self.ammo_elemental = self.ammo_elemental - 3;
		if (self.currentammo <0)
			self.currentammo = self.ammo_elemental = 0;
	}
	sound (self, CHAN_WEAPON, SOUND_AXE_SWIPE2, 1, ATTN_NORM);
};

void() sword3Attack8 = [2, player_run] {self.weaponframe = 20;};

void (entity inflictor, entity attacker, float damage, float radius, entity ignore, float checkclass) T_RadiusDamageAOA = // radius and damage are now independent arguments with falloff damage being mostly linear, and doesn't hurt attacker. I might extend it further to pass "damage_attacker" boolean "float"
{
	local	float 	points, distance;
	local	entity	head;
	local	vector	org, imporg;

	// Cannot hurt the world or enemy targets (fake flying markers)
	if (attacker.noradiusdmg) return;
	if (attacker.classtype == CT_WORLD) return;
	if (attacker.classtype == CT_ENEMYTARGET) return;

	// check if inflictor is a bmodel (different origin location)
	if (inflictor.bsporigin) imporg = bmodel_origin(inflictor);
	else imporg = inflictor.origin;
		
	head = findradius(imporg, radius);
	
	while (head) {
		if (head != ignore) {
			// This is used mostly for wraiths so when they die they don't
			// kill each other, can't get the code logic to work so its
			// setup as a dead exception path
			if (checkclass == IGNORECLASS && head.classtype == ignore.classtype) { }
			else {
				// Check for breakable/pushable monster immunity
				// Do nothing, radius damage has no miss effect
				if (ai_immunebreakable(attacker, head)) {
				}
				// Check for any breakables which are prone to explosive damage
				else if (ai_foundbreakable(attacker, head,TRUE) && head.brktrigmissile !=0) {
					trigger_ent(head, attacker);
				}
				else {
					// Can be damaged and NOT immune to radius (splash) damage
					if (head.takedamage > 0 && head.noradiusdmg == 0) {
						// This formula is using bounding box size which means
						// the damage amount is lower if the monster is larger
						// It should really be based on bounding box edge
						// not monster origin
						org = head.origin + (head.mins + head.maxs)*0.5;
						distance = vlen(imporg - org);
						points = ((radius - distance)/radius + damage)/2; //damage is an average of the [float damage] argument, and a spatially-linear falloff damage. AKA damage falls off from 100% to 50% at the edge of the radius
						
						if (points > 0 && head.health > 0) {
							// Need CanDamage to check for anything blocking LoS
							// It will do several traces (source->target) to check
							// for any blocking entities (lifts, doors, walls etc)
							if (CanDamage (head, inflictor)) {
								// #ryanscissorhands: This splash damage is NOT part of rocket resistance, hence commenting out the subsequent two lines
								//if (head.resist_rockets > 0)
								//	points = Resist_Damage(head, AM_ROCKETS, points); // We do this inside T_Damage now for consistency and reduced duplicate code. -Qmaster
								
								// Zombies should really be blown from explosives
								// especially from ogre grenades right under their feet
								// Check for glancing damage or if too far away
								if (head.classgroup == CG_ZOMBIE && points > (head.health*0.25))
									points = DAMAGE_ZOMBIECLASS;
								// Any damage left? Check for poison as well
								if (points > 0) T_Damage (head, inflictor, attacker, points, DAMARMOR); //T_Damage(
								// bprint("Radius is doing ");
								// bprint(ftos(points));
								// bprint(" damage.\n");
								
								if (attacker.poisonous) PoisonDeBuff(head);
							}
						}
					}
				}
			}
		}
		head = head.chain;
	}
};

void() W_FireScimitar = //the first attack in the scimitar's combo
{
	local vector lungeDirection;
	W_Reload(0.6);
	
	if (random() < 0.5) sound (self, CHAN_WEAPON, SOUND_AXE_SWIPE1, 1, ATTN_NORM);
		else sound (self, CHAN_WEAPON, SOUND_AXE_SWIPE2, 1, ATTN_NORM);
	makevectors(self.v_angle);
	lungeDirection = v_forward;
	lungeDirection_z = 0;
	lungeDirection = normalize(lungeDirection);
	
	if (self.flags & FL_ONGROUND)
	{
		self.velocity =  lungeDirection*650 + '0 0 75';
		
		if (self.tome_finished) // #techdebt #tomeflag
			self.velocity = self.velocity * 1.5;
		self.flags = self.flags - FL_ONGROUND;
	}
	sword1Attack1();
};
	
void(float attackNumber) SwordSwing = 
{
	
	local vector org, dir;
	local float damage, hitsTarget;
	
	hitsTarget = FALSE;
	makevectors(self.v_angle);	
	org = self.origin + '0 0 16'; //attack origin is player's hands height.
	if (attackNumber == 1) //first attack in combo is slightly left
	{
		dir = org + v_forward*60 + v_right*-15;
		damage = 40;
	}
	else if (attackNumber == 1 || attackNumber == 2) //second attack in combo is area damage, to increase likelyhood of landing the hit, and potential to hit 2 targets
	{
		dir = org + v_forward*60 + v_right*15;
		damage = 40;
	}
	else if (attackNumber == 3)//third attack in combo is straight ahead
	{
		dir = org + v_forward*75;
		damage = 40;
	}
	
	local entity targets;
	targets =  findradius (self.origin + v_forward*40 + '0 0 10', 50);

	while (targets) 
	{
		if (targets.takedamage && CanDamage(targets, self) && targets != self)
		{
			T_Damage(targets, self, self, damage, DAMARMOR);
			SpawnBlood(targets, (self.origin*2 + targets.origin)/3, '0 0 0', 20,0);
			hitsTarget = TRUE;
			sound (self, CHAN_AUTO, "aoa/melee_meat.wav", 1, ATTN_NORM);
		}
		targets = targets.chain;
	}
	
	
	traceline(org, dir, FALSE, self);
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
		hitsTarget = TRUE;
	if (hitsTarget == TRUE && trace_ent != world)
	{
		trace_ent.axhitme = 1;
		SpawnBlood(trace_ent, dir, dir-org, 20,0);
		sound (self, CHAN_AUTO, "aoa/melee_meat.wav", 1, ATTN_NORM);
	}
	else if (trace_fraction != 1)
	{	// hit wall
		Tent_Point(TE_GUNSHOT,trace_endpos);
		sound (self, CHAN_WEAPON, "aoa/axhit3.wav", 1, ATTN_NORM);
	}
};

void() GlowTouch =
{
	if (other.classgroup == CG_ZOMBIE)
	{
		T_Damage(other, self, self.owner, 150, NOARMOR);//bonus damage on direct zombie hit
	}
	T_RadiusDamageAOA (self, self.owner, 150, 200, self.owner, DAMAGEALL);

	SpawnExplosion(EXPLODE_SMALL, self.origin, "kinn/shuffler/expsmall.wav");
	remove(self);
};

void(float projectileNumber) SwordMagic =
{
	local entity glow;
	local vector org;
	
	makevectors(self.v_angle);
	glow = spawn();
	glow.owner = self;
	glow.classgroup = CG_PROJALL;
	glow.solid = SOLID_BBOX;
	glow.movetype = MOVETYPE_BOUNCE;
	
	glow.velocity = v_forward*1500 + '0 0 150';
	glow.angles = vectoangles(glow.velocity);
	
	org = self.origin + v_forward*8 + v_up*20 + v_right*3;
	setmodel (glow, "progs/aoa/glow.mdl");
	setsize (glow, '0 0 0', '0 0 0');
	setorigin (glow, org);
	glow.frame = projectileNumber - 1;
	glow.avelocity = '-500 0 0';
	glow.touch = GlowTouch;
	glow.nextthink = time + 2;
	glow.think = SUB_Remove;
	
	//check for ammo, make projectile
};

//=================================END OF SCIMITAR OF FIRE====================================================

/*
===================================================================================================
GhostRapier		#rapier #ryanscissorhands
===================================================================================================
*/
void() RapierSpinAttack;
void() RapierAttack;
void(float damage) GhostRapierAttack;
void(vector org, float radius) FindEnemy;
void() rapierParticle;

void() GhostRapierAnimation1 = [1, GhostRapierAnimation2] {SwordSwipeSound();FindEnemy(self.origin, 75);}; //this is the Projectile rapier's animation sequence
void() GhostRapierAnimation2 = [2, GhostRapierAnimation3] {GhostRapierAttack(20);};
void() GhostRapierAnimation3 = [3, GhostRapierAnimation4] {SwordSwipeSound();FindEnemy(self.origin, 75);};
void() GhostRapierAnimation4 = [4, GhostRapierAnimation5] {GhostRapierAttack(25);};
void() GhostRapierAnimation5 = [5, GhostRapierAnimation6] {FindEnemy(self.origin, 75);};
void() GhostRapierAnimation6 = [6, GhostRapierAnimation7] {SwordSwipeSound();FindEnemy(self.origin, 75);};
void() GhostRapierAnimation7 = [7, GhostRapierAnimation8] {GhostRapierAttack(30);};
void() GhostRapierAnimation8 = [8, GhostRapierAnimation9]
{
	if (!self.owner.tome_finished) //if tome of power is off, remove self, else, carry on. #techdebt #tomeflag. Change this to check for player's 'Tome of Power' flag, rather than hacky variable
	{	
		bprint("I think tome is off...\n");
		remove(self);
	}
};
void() GhostRapierAnimation9 = [9, GhostRapierAnimation10] {};
void() GhostRapierAnimation10 = [10, GhostRapierAnimation11] {};
void() GhostRapierAnimation11 = [11, GhostRapierAnimation12] {sound(self, CHAN_AUTO, "aoa/radius.wav", 1, ATTN_NORM);};
void() GhostRapierAnimation12 = [12, GhostRapierAnimation13] {RapierSpinAttack();};
void() GhostRapierAnimation13 = [13, GhostRapierAnimation14] {};
void() GhostRapierAnimation14 = [14, GhostRapierAnimation14] {remove(self);};


void() RapierAnimation1 = [33, RapierAnimation2] {self.weaponframe = 1;SwordSwipeSound();}; //this is the player's attack sequence
void() RapierAnimation2 = [34, RapierAnimation3] {self.weaponframe = 2;RapierAttack();};
void() RapierAnimation3 = [33, RapierAnimation4] {self.weaponframe = 3;SwordSwipeSound();};
void() RapierAnimation4 = [34, RapierAnimation5] {self.weaponframe = 4;RapierAttack();};
void() RapierAnimation5 = [36, RapierAnimation6] {self.weaponframe = 5;};
void() RapierAnimation6 = [32, RapierAnimation7] {self.weaponframe = 6;SwordSwipeSound();};
void() RapierAnimation7 = [34, RapierAnimation8] {self.weaponframe = 7;RapierAttack();};
void() RapierAnimation8 = [0, RapierAnimation9] {self.weaponframe = 8;};
void() RapierAnimation9 = [1, RapierAnimation10]
{
	self.weaponframe = 9;
	if (!self.tome_finished) //if tome of power isn't up, end sequence, else, carry on, self.attack_finished + time + 0.8
	{
		player_run();
		W_Reload(0.2);
	}
	else
	{
		W_Reload(0.8);
	}
};
void() RapierAnimation10 = [2, RapierAnimation11] {self.weaponframe = 10;};
void() RapierAnimation11 = [3, RapierAnimation12] {self.weaponframe = 11;};
void() RapierAnimation12 = [4, RapierAnimation13] {self.weaponframe = 12;};
void() RapierAnimation13 = [5, RapierAnimation14] {self.weaponframe = 13;};
void() RapierAnimation14 = [0, player_run] {self.weaponframe = 14;};

void() rapierParticle =
{
	self.nextthink = time + 0.05;
	self.think = rapierParticle;
	particle(self.origin, self.velocity*(-1) + '0 0 15', 245, 3);
};

void() RapierAttack = //this is the player's melee attack, called three times as part of the combo
{
	local vector org, dir;
	local float damage, hitsTarget;
	
	hitsTarget = FALSE;
	makevectors(self.v_angle);	
	org = self.origin + '0 0 16'; //attack origin is player's hands height.

	dir = org + v_forward*75;
	damage = 35;
	traceline(org, dir, FALSE, self);
	
	org = trace_endpos + v_forward*-2;

	if (trace_ent.takedamage)
		hitsTarget = TRUE;
	if (hitsTarget == TRUE && trace_ent != world)
	{
		trace_ent.axhitme = 1;
		SpawnBlood(trace_ent, dir, dir-org, 20,0);
		if (trace_ent.classname == "monster_shambler")
			damage = damage * 1.5;
		T_Damage (trace_ent, self, self, damage, DAMARMOR);
		local float randy;
		if (randy > 0.7)
			sound (self, CHAN_VOICE, "aoa/rapier_meat.wav", 1, ATTN_NORM);
		else if (randy > 0.35)
			sound (self, CHAN_VOICE, "aoa/rapier_meat2.wav", 1, ATTN_NORM);
		else 
			sound (self, CHAN_VOICE, "aoa/rapier_meat3.wav", 1, ATTN_NORM);
	}
	else if (trace_fraction != 1)
	{	// hit wall
		Tent_Point(TE_GUNSHOT,org);
		sound (self, CHAN_VOICE, "aoa/axhit3.wav", 0.5, ATTN_NORM);
	}
};

void(float damage) GhostRapierAttack = //the projected sword does this attack three times as it travels, damag = 20 x 3
{	
	if (self.enemy == world || self.enemy.health < 1)
		FindEnemy(self.origin, 70);
	
	local vector dir;
	local float hitsTarget;
	
	makevectors(self.angles);
	if (self.enemy != world)
	{
		self.angles = vectoangles (self.enemy.origin + '0 0 8' - self.origin);
		self.velocity = '0 0 0';
		self.movetype = MOVETYPE_NONE;
	}
	dir = self.origin + v_forward*75;//attack origin is player's hands height.
	
	hitsTarget = FALSE;
	
	traceline(self.origin, dir, FALSE, self);

	if (trace_ent.takedamage && trace_ent != world)
	{
		SpawnBlood(trace_ent, dir, '0 0 0', 20,0);
		if (trace_ent.classname == "monster_shambler")
			damage = damage * 1.5;
		T_Damage(trace_ent, self, self, damage, DAMARMOR);
		sound (self, CHAN_WEAPON, "aoa/acidhit.wav", 1, ATTN_NORM);
	}
	else if (trace_fraction != 1)
	{	// hit wall
		Tent_Point(TE_GUNSHOT,trace_endpos);
		sound (self, CHAN_VOICE, "aoa/axhit3.wav", 0.5, ATTN_NORM);
	}
};

void() RapierSpinAttack =
{
	local entity target;
	local float hitTarget;
	
	hitTarget = FALSE;
	target = findradius(self.origin, 70);
	while (target)
	{
		if (target.takedamage && target != self.owner && target.health >0)
		{
			T_Damage(target, self, self.owner, 300, DAMARMOR);
			SpawnBlood(target, (target.origin+self.origin)/2, '0 0 0', 25,0); 
			hitTarget = TRUE;
		}
		target = target.chain;
	}
	if (hitTarget == TRUE)
	{
		sound (self, CHAN_WEAPON, "aoa/melee_meat.wav", 1, ATTN_NORM);
	}
};

void(vector org, float radius) FindEnemy =
{
	local entity target;
	target = findradius(org, radius);
	while (target && self.enemy == world)
	{
		if (target.takedamage && target != self.owner && target.health >0)
		{
			self.enemy = target;
		}
		target = target.chain;
	}
	if (self.enemy != world)
	{
		self.angles = vectoangles(self.enemy.origin - self.origin);
	}
};

void() ghostRapierTouch =
{
	local vector displacement;
	displacement = self.origin + normalize(self.velocity)*-8;
	setorigin (self, displacement);
	self.velocity = '0 0 0';
	if (other.takedamage && other != self.owner && other != world)
	{
		T_Damage(other, self, self.owner, 20, DAMARMOR);
		SpawnBlood(other, other.origin, '0 0 0', 20,0);
		self.touch = SUB_Null;
		sound (self, CHAN_VOICE, "aoa/axhit3.wav", 0.5, ATTN_NORM);
	}
};
void() W_FireRapier =
{
	W_Reload(1);
	RapierAnimation1();
	
	if (self.ammo_bloodcrystals <1 && !self.tome_finished) //don't spawn Ghost rapier if you have no ammo and no Tome of Power
		return;
	
	if (self.ammo_bloodcrystals > 0)
		self.currentammo = self.ammo_bloodcrystals = self.ammo_bloodcrystals - 1;
		
	local entity ghostRapier;
	ghostRapier = spawn();
	ghostRapier.owner = self;
	ghostRapier.classgroup = CG_PROJALL;
	ghostRapier.movetype = MOVETYPE_FLYMISSILE;
	ghostRapier. solid = SOLID_BBOX;
	ghostRapier.enemy = world;
	
	makevectors(self.v_angle);
	ghostRapier.velocity = v_forward*900;
	ghostRapier.angles = vectoangles(v_forward);
	
	setmodel(ghostRapier, "progs/aoa/ghostrapier.mdl");
	setsize(ghostRapier, '0 0 0', '0 0 0');
	setorigin(ghostRapier, self.origin + v_forward*15 + '0 0 25');
	
	ghostRapier.nextthink = time;
	ghostRapier.think = GhostRapierAnimation1;
	
	ghostRapier.touch = ghostRapierTouch;
};

//===============================END OF RAPIER==================================================================

/*
==================================================================
Ice Storm by ryanscissorhands		#ice #chain #ryanscissorhands //#ice1
==================================================================
*/
void() W_FireChainLightning;
void() IceProjectiles;

void() ChainLightningAnimation1 = [0, ChainLightningAnimation2] {self.frame = 1;};
void() ChainLightningAnimation2 = [0, ChainLightningAnimation3] {self.frame = 2;};
void() ChainLightningAnimation3 = [0, ChainLightningAnimation4] {self.frame = 3;};
void() ChainLightningAnimation4 = [0, ChainLightningAnimation5] {self.frame = 4;};
void() ChainLightningAnimation5 = [0, ChainLightningAnimation6] {self.frame = 5;};
void() ChainLightningAnimation6 = [0, ChainLightningAnimation7] {self.frame = 6;};
void() ChainLightningAnimation7 = [0, ChainLightningAnimation8] {self.frame = 7;};
void() ChainLightningAnimation8 = [0, ChainLightningAnimation9] {self.frame = 8;};
void() ChainLightningAnimation9 = [0, ChainLightningAnimation10] {self.frame = 9;};
void() ChainLightningAnimation10 = [0, ChainLightningAnimation11] {self.frame = 10;};
void() ChainLightningAnimation11 = [0, ChainLightningAnimation12] {self.frame = 11;};
void() ChainLightningAnimation12 = [0, ChainLightningAnimation13] {self.frame = 12;};
void() ChainLightningAnimation13 = [0, player_run] {self.frame = 13;};

void() IceAttack1 =	[107, IceAttack2] {if (time < self.attack_finished) return;self.weaponframe = 1;IceProjectiles();W_Reload(0.8);};
void() IceAttack2 =	[108, IceAttack3] {self.weaponframe = 2;};
void() IceAttack3 =	[109, IceAttack4] {self.weaponframe = 3;};
void() IceAttack4 =	[110, IceAttack5] {self.weaponframe = 4;};
void() IceAttack5 =	[111, IceAttack6] {self.weaponframe = 5;};
void() IceAttack6 =	[112, IceAttack7]
{
	self.weaponframe = 6;
	if (!self.button0) //if player isn't holding mouse, don't do second (lightning) attack. will need ammo check here later
	{
		player_run();
		return;
	}
	W_Reload(0.8);
};

void() IceAttack7 =	[113, IceAttack8] {self.weaponframe = 7;};
void() IceAttack8 =	[114, IceAttack9] {self.weaponframe = 8;W_FireChainLightning();};
void() IceAttack9 =	[115, IceAttack10] {self.weaponframe = 9;};
void() IceAttack10 =	[116, IceAttack11] {self.weaponframe = 8;};
void() IceAttack11 =	[117, IceAttack12]
{
	self.weaponframe = 7;
	if (!self.button0 || !self.tome_finished)  //If still attacking and Tome of Power: Launch Boulder for third attack in combo
	{
		player_run();
		return;
	}
	W_Reload(1);
};

void() IceAttack12 = [113, IceAttack13] {self.weaponframe = 36;};
void() IceAttack13 = [114, IceAttack14] {self.weaponframe = 34;};
void() IceAttack14 = [115, IceAttack15] {self.weaponframe = 32;};
void() IceAttack15 = [116, IceAttack16] {self.weaponframe = 33;LaunchBoulder();};
void() IceAttack16 = [117, player_run] {self.weaponframe = 35;};

void() T_BoulderTouch =
{	
	local float speed;
		
	speed = vlen(self.velocity);
			
	if (other.takedamage)
	{
		T_Damage(other, self, self.owner,self.dmg, DAMARMOR);
		// #techdebt spawn blood
		other.velocity = ignoreVertical(self.velocity)*speed + '0 0 300';		
		aoaprint("Self.dmg = ", ftos(self.dmg), "\n", "");
		if (self.dmg > 10) //reduce damage until it's low enough to ignore
			self.dmg = self.dmg *0.4;
		else
			self.dmg = 0;
	}
	else
	{
		T_RadiusDamage(self, self.owner, self.dmg*speed/1000, self.owner, DAMAGEALL);
		aoaprint("Radius damage is ", ftos(self.dmg*speed/1000), "\n", "");
	}

	if (speed > 200)
		sound (self, CHAN_WEAPON, "aoa/fastboulder.wav", 1, ATTN_NORM);//fast impact sound
	else
		sound (self, CHAN_WEAPON, "aoa/slowboulder.wav", 1, ATTN_NORM);//slow impact sound

	self.velocity = self.velocity * 0.5;

	particle(self.origin, spread('70 70 70'), 2, 4);
	particle(self.origin, spread('70 70 70'), 2, 4);
	particle(self.origin, spread('70 70 70'), 2, 4);
	 

};

void() LaunchBoulder =
{
	local entity boulder;
	local vector org;
	
	boulder = spawn();
	boulder.owner = self;
	boulder.classgroup = CG_PROJALL;
	boulder.movetype = MOVETYPE_BOUNCE;
	boulder.solid = SOLID_BBOX;
	
	setmodel(boulder, "progs/aoa/boulder.mdl"); //remember to precache
	setsize(boulder, '0 0 0', '0 0 0');
	org = self.origin + '0 0 24' + v_forward*8 + v_up*8;
	setorigin(boulder, org);
	
	boulder.velocity = v_forward*1200 + v_up*120;
	boulder.touch = T_BoulderTouch;
	boulder.dmg = 120;
	
	boulder.nextthink = time + 3;
	boulder.think = SUB_Remove;
	sound(self, CHAN_WEAPON, "aoa/rockattack.wav", 1, ATTN_NORM);

};

void() ChainedLightning = {
	local float damage;
	
	sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
	traceline(self.origin, self.enemy.origin, FALSE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);
	
	damage = 30;
	if (self.enemy.classname == "player")//half damage to players
		damage = damage * 0.5;
		
	LightningDamage(self.origin, trace_endpos, self.owner, damage);
	remove(self);
};

void (entity target) LightningTarget = //called once per target of the storm, up to 5 targets
{
	local entity cloud;
	
	cloud = spawn();
	cloud.enemy = target;
	cloud.owner = self.owner;
	cloud.nextthink = time;
	cloud.think = ChainedLightning;	
	setorigin (cloud, self.origin);
};

void() StormFindTargets =
{
	local entity nearbyTargets;
	local float targets;

	if (self.tome_finished)//tome hgas max 10 targets, otherwise max 5
		targets = 10;
	else
		targets = 5;
	
	nearbyTargets = findradius(self.origin, 512);
	while (nearbyTargets && targets >0)
	{
		traceline(self.origin, nearbyTargets.origin, TRUE, self);//was TRUE
		if (nearbyTargets.takedamage > 0 && nearbyTargets != world && trace_fraction == 1 && nearbyTargets.health > 0 && nearbyTargets != self.owner)
		{
			if (developer > 0) bprint("Target found! It's a ");
			if (developer > 0) bprint(nearbyTargets.classname);
			if (developer > 0) bprint(".\n");
			LightningTarget(nearbyTargets); //attacks secondary target with lightning
			targets = targets - 1;
		}
		nearbyTargets = nearbyTargets.chain;
	}
	self.nextthink = time + 0.5;
	self.think = SUB_Remove;
};

void() W_FireChainLightning = //direct hitscan damage, then lightning chains from there 0.2 seconds later
{
	local vector org, terminus, stormOrigin;
	local entity storm;

	W_Reload(0.7);
		
	makevectors (self.v_angle);
	org = self.origin + '0 0 8' + v_forward*12 + v_right*10;
	traceline(org, org+v_forward*640, TRUE, self);
	terminus = trace_endpos;
	
	//MakeBeam(org, terminus, "progs/aoa/bolt4.mdl", 0.4);
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, terminus_x);
	WriteCoord (MSG_BROADCAST, terminus_y);
	WriteCoord (MSG_BROADCAST, terminus_z);
	PlayerLightningDamage(org,terminus,self,40);
	SpawnBlood(trace_ent,terminus,vecrand(5,50,TRUE),20,225);
	stormOrigin = terminus + '0 0 20';
	storm = spawn();
	storm.owner = self;
	storm.classgroup = CG_PROJALL;
	setmodel (storm, "progs/aoa/tessla.mdl");
	setsize (storm, '0 0 0', '0 0 0');
	setorigin (storm, stormOrigin);
	storm.movetype = MOVETYPE_NONE;
	storm.solid = SOLID_NOT;
	storm.nextthink = time + 0.3;
	storm.think = StormFindTargets;
	//sound (self, CHAN_WEAPON, "aoa/thndr.wav", 1, ATTN_NORM);
	sound (self, CHAN_WEAPON, "weapons/lstart.wav", 1, ATTN_NORM);
};
	
void() IceSpikeTouch =
{
	if (!self.owner.attack_finished)
		self.dmg = self.dmg *1.5;
	if (other != self.owner && other.takedamage)
	{
		T_Damage(other, self, self.owner, self.dmg, DAMARMOR);//2 dmg per ice spike, 3 with Tome of Power
		SpawnBlood(self, self.origin, self.velocity, 4,0);
	}	

	sound (self, CHAN_AUTO, "hknight/hit.wav", 0.5, ATTN_NORM);
	remove(self);
};
	
void(float vertical, float horizontal) IceSpikeProjectile = 
{
	local entity IceSpike;

	makevectors(self.v_angle);

	IceSpike = spawn();
	IceSpike.owner = self;
	IceSpike.classgroup = CG_PROJICE;
	IceSpike.movetype = MOVETYPE_FLYMISSILE;
	IceSpike.solid = SOLID_BBOX;
	IceSpike.touch = IceSpikeTouch;
	IceSpike.dmg = 2;
	IceSpike.velocity = v_forward*900 - v_up*vertical*8 - v_right*horizontal*8 + spread('5 5 5');
	IceSpike.angles = vectoangles(IceSpike.velocity);
	IceSpike.avelocity_z = crandom()*1000;
	setmodel (IceSpike, "progs/aoa/icespike.mdl"); //remember to precache
	setsize (IceSpike, '0 0 0', '0 0 0');
	setorigin (IceSpike, self.origin + v_up* (16 + vertical) + v_forward*8 + v_right*horizontal);
	IceSpike.nextthink = time + 1.2;
	IceSpike.think = SUB_Remove;
};
void(float offset) IceSpread =
{
	IceSpikeProjectile (offset*0.9, offset*0.9);
	IceSpikeProjectile (offset*0.9, -offset*0.9);
	IceSpikeProjectile (-offset*0.9, offset*0.9);
	IceSpikeProjectile (-offset*0.9, -offset*0.9);
	IceSpikeProjectile (0, offset*1.2);
	IceSpikeProjectile (0, -offset*1.2);
	IceSpikeProjectile (offset*1.2, 0);
	IceSpikeProjectile (-offset*1.2, 0);	
};

void () W_FireIce = 
{
	IceAttack1(); //trigger animation
	self.currentammo = self.ammo_elemental = self.ammo_elemental - 1; 	//consume ammo
	//trigger sound sound (self, CHAN_WEAPON, "aoa/iceattack.wav", 0.7, ATTN_NORM);
};

void() IceProjectiles =
{
	W_Reload(0.9);
	
	sound (self, CHAN_WEAPON, "aoa/iceattack.wav", 1, ATTN_NORM);

	//24 projectiles IceSpikeProjectile ();
	IceSpread(24);
	IceSpread(16);
	IceSpread(8);

	

};

//==========================================END OF ICE STORM===================================================

/*
============================================================== 
Void Staff 		#voidstaff	#staff	#ryanscissorhands
===============================================================
*/

void() 	DetonateVoidShards;
void() StaffDetonate1;

void()	embers1	=[		0,	embers2	] 	{};
void()	embers2	=[		1,	embers3	] 	{};
void()	embers3	=[		2,	embers4	] 	{};
void()	embers4	=[		3,	embers5	] 	{};
void()	embers5	=[		4,	embers6	] 	{};
void()	embers6	=[		5,	embers7	] 	{};
void()	embers7	=[		6,	embers8	] 	{};
void()	embers8	=[		7,	embers9	] 	{};
void()	embers9	=[		8,	embers10	] {};
void()	embers10	=[	9,	embers11	] {};
void()	embers11	=[	10,	embers12	] {};
void()	embers12	=[	11,	embers13	] {};
void()	embers13	=[	12,	embers14	] {};
void()	embers14	=[	13,	embers15	] {};
void()	embers15	=[	14,	embers16	] {};
void()	embers16	=[	15,	embers16	] {remove(self);};


void() StaffShot1 = [113, StaffShot2] {self.weaponframe =1;VoidStaffProjectile();W_Reload(0.9);};
void() StaffShot2 = [114, StaffShot3] {self.weaponframe =2;};
void() StaffShot3 = [115, StaffShot4] {self.weaponframe =3;};
void() StaffShot4 = [116, StaffShot5] {self.weaponframe =4;};
void() StaffShot5 = [117, StaffShot6] {self.weaponframe =5;};
void() StaffShot6 = [118, StaffShot7]
{
	self.weaponframe = 6;
	if (!self.button0) //if player isn't holding mouse, don't do second attack. will need ammo check here later
	{
		player_run();
		return;
	}
};
void() StaffShot7 = [113, StaffShot8] {self.weaponframe =1;VoidStaffProjectile();W_Reload(0.9);};
void() StaffShot8 = [114, StaffShot9] {self.weaponframe =2;};
void() StaffShot9 = [115, StaffShot10] {self.weaponframe =3;};
void() StaffShot10 = [116, StaffShot11] {self.weaponframe =4;};
void() StaffShot11 = [117, StaffWait1] {self.weaponframe =5;};

void() StaffWait1 = [7, StaffWait2] 
{
	self.weaponframe =0;
	if (self.button0) 
	{
		DetonateVoidShards();
		StaffDetonate1();
		W_Reload(0.7);
	}
	
};
void() StaffWait2 = [8, StaffWait3] 
{
	self.weaponframe =0;
	if (self.button0) 
	{
		DetonateVoidShards();
		StaffDetonate1();
		W_Reload(0.6);
	}
	
};
void() StaffWait3 = [9, StaffWait4] 
{
	self.weaponframe =0;
	if (self.button0) 
	{
		DetonateVoidShards();
		StaffDetonate1();
		W_Reload(0.5);
	}
	
};
void() StaffWait4 = [10, StaffWait5] 
{
	self.weaponframe =0;
	if (self.button0) //if player isn't holding mouse, don't do third ((detonation)) attack.
	{
		DetonateVoidShards();
		StaffDetonate1();
		W_Reload(0.4);
	}
};
void() StaffWait5 = [11, StaffWait6] 
{
	self.weaponframe =0;
	if (self.button0) //if player isn't holding mouse, don't do third ((detonation)) attack.
	{
		DetonateVoidShards();
		StaffDetonate1();
		W_Reload(0.4);
	}
	
};
void() StaffWait6 = [12, player_run] 
{
	self.weaponframe =0;
	if (self.button0) //if player isn't holding mouse, don't do third ((detonation)) attack.
	{
		DetonateVoidShards();
		StaffDetonate1();
		W_Reload(0.4);
	}
	
};

void() StaffDetonate1 = [107, StaffDetonate3] {self.weaponframe =9;};
void() StaffDetonate2 = [109, StaffDetonate3] {self.weaponframe =10;};
void() StaffDetonate3 = [111, StaffDetonate4] {self.weaponframe =11;};
void() StaffDetonate4 = [112, player_run] {self.weaponframe =12;};

void () VoidExplosion = 
{

	sound (self, CHAN_VOICE, "ad171/seeker/explode_major.wav", 1, ATTN_NORM);
	local entity GreenEmbers, GreenEmbers2, GreenEmbers3;
	
	makevectors(self.velocity);
	
	GreenEmbers = spawn();
	GreenEmbers.classgroup = CG_PROJALL;
	GreenEmbers.angles = vectoangles(v_right* 10);
	setmodel (GreenEmbers, "progs/aoa/greenembers.mdl");
	setsize (GreenEmbers, '0 0 0', '0 0 0');
	setorigin (GreenEmbers, self.origin + spread('5 5 5'));
	GreenEmbers.nextthink = time + 0.05;
	GreenEmbers.think = embers1;
	
	GreenEmbers2 = spawn();
	GreenEmbers2.classgroup = CG_PROJALL;
	GreenEmbers2.angles = vectoangles(v_right*-10);
	setmodel (GreenEmbers2, "progs/aoa/greenembers.mdl");
	setsize (GreenEmbers2, '0 0 0', '0 0 0');
	setorigin (GreenEmbers2, self.origin + spread('5 5 5'));
	GreenEmbers2.nextthink = time + 0.05;
	GreenEmbers2.think = embers1;
	
	GreenEmbers3 = spawn();
	GreenEmbers3.classgroup = CG_PROJALL;
	GreenEmbers3.angles = vectoangles(v_forward*10);
	setmodel (GreenEmbers3, "progs/aoa/greenembers.mdl");
	setsize (GreenEmbers3, '0 0 0', '0 0 0');
	setorigin (GreenEmbers3, self.origin + spread('5 5 5'));
	GreenEmbers3.nextthink = time + 0.05;
	GreenEmbers3.think = embers1;

	if (self.tome_finished) //extra damage with TOme of Power
	{
		T_RadiusDamageAOA(self, self.owner, 150, 150, world, DAMAGEALL);
	}
	else
	{
		T_RadiusDamageAOA(self, self.owner, 80, 200, world, DAMAGEALL);
	}
	remove(self);
};

void() BlueExplosion =
{
	local float loops;
	loops = 25;
	while (loops> 0)
	{
		particle(self.origin + spread('0.5 0.5 0.5')*5, spread('0.1 0.1 10')*4, 145+random()*2, 5); //was color 47+random()*2
		loops = loops - 1;
	}
};

void() GreenExplosion =
{
	local float loops;
	loops = 40;
	while (loops> 0)
	{
		particle(self.origin + spread('3 3 3'), spread('0.8 0.8 0.4')*15, 184+random()*5, 2);
		particle(self.origin + spread('3 3 3'), spread('0.8 0.8 0.6')*8, 5, 1);
		loops = loops - 1;
	}	
};

void () DetonateVoidShards = 
{
	if (self.ammo_voidshards < 4)
	{
		centerprint(self, "Not enough ammo to detonate.");
		return;
	}
	local entity list;
	local float FoundATarget;
	FoundATarget = FALSE;
	
	makevectors(self.v_angle);
	traceline(self.origin + '0 0 16', self.origin + '0 0 16' + v_forward * 1000, TRUE, self);
	list = findradius(trace_endpos, 2000);
	
	while (list)
	{
		if (list.classname == "VoidShard")
		{
			list.nextthink = time;
			list.think = VoidExplosion;
			FoundATarget = TRUE;
		}
		list = list.chain;
	}
	if (FoundATarget == TRUE)
	{
		self.currentammo = self.ammo_voidshards = self.ammo_voidshards - 4;
		sound (self, CHAN_WEAPON, "ad171/seeker/explode_major.wav", 1, ATTN_NORM);
	}
};

void() VoidShardTouch =
{
	// trigger sound
	// sound (self, CHAN_AUTO, "aoa/staffhit.wav", 1, ATTN_NORM); #techdebt
	GreenExplosion();
	BlueExplosion();
	if (self.owner.tome_finished)
		self.dmg = 75;
	if (other != self.owner && other.takedamage)
	{
		T_Damage (other, self, self.owner, self.dmg, DAMARMOR);
		particle(self.origin, spread('1 1 1') + '0 0 1', 76, 20); //blood
		particle(self.origin, spread('1 1 1') + '0 0 1', 76, 20);//blood
		self.dmg = 0;
		//trigger sound
	}	
	else
	{
		self.nextthink = time + 3;
		self.think = SUB_Remove;
	}

	self.velocity = '0 0 0';
	self.movetype = MOVETYPE_FLY;
	self.velocity = '0 0 90';
	self.nextthink = time + 1.2;
	self.think = SUB_Remove;
	self.touch = SUB_Null;
};

void() VoidShardTrace =
{
	particle(self.origin,normalize(-self.velocity) + '0 0 1', 184 + random()*7, 5);
	if (random() > 0.5)
		particle(self.origin,normalize(-self.velocity) + '0 0 1', 135, 5);
	if (random() < 0.2)
		particle(self.origin, '0 0 2', 177, 14);
	
	self.velocity = self.velocity + '0 0 25' + self.attack_offset;
	self.velocity = self.velocity * 1.1;
	

	if (time > self.attack_finished)
		remove(self);
	self.nextthink = time + 0.04;
	self.think = VoidShardTrace;
	if (pointcontents(self.origin) < -2)
		self.velocity = self.velocity + '0 0 250';
	//#techdebt #tomeflag. Check for Tome of Power, and explode as it travels. Explosion might need a flag for deletion to handle this well.
};

void () VoidStaffProjectile = 
{
	if (self.currentammo < 1) return;

	sound(self, CHAN_WEAPON, "aoa/staffshot.wav", 1, ATTN_NORM);
	
	self.currentammo = self.ammo_voidshards = self.ammo_voidshards - 1;
	
	//trigger animation
	local entity VoidShard;

	makevectors(self.v_angle);

	VoidShard = spawn();
	VoidShard.owner = self;
	VoidShard.classgroup = CG_PROJALL;
	VoidShard.movetype = MOVETYPE_FLYMISSILE;
	VoidShard.solid = SOLID_BBOX;
	VoidShard.dmg = 45;
	VoidShard.touch = VoidShardTouch;
	VoidShard.classname = "VoidShard";
	if (self.tome_finished)//erratic projectiles with Tome
	{
		VoidShard.velocity = v_forward*450 +'0 0 -50';
		VoidShard.attack_offset = v_right*rnd(-35, 35);
	}
	else
	{	
		VoidShard.velocity = v_forward*600 +'0 0 -50';
	}
	VoidShard.angles = spread('180 180 180');
	VoidShard.avelocity = spread('180 180 180');
	setmodel (VoidShard, "progs/aoa/void_shard.mdl");
	setsize (VoidShard, '0 0 0', '0 0 0');
	setorigin (VoidShard, self.origin + v_forward*8 + v_up*14 + v_right *3);
	VoidShard.attack_finished = time + 4;
	
	VoidShard.nextthink = time + 0.03;
	VoidShard.think = VoidShardTrace;
};

void() W_FireVoidStaff =
{
	//consume ammo. #techdebt
	//trigger sound #techdebt
	StaffShot1(); //this triggers the animation, which will in turn trigger projectiles
};


//=========================================END OF VOID STAFF===================================================



/*
========================================================================================
Flak Cannon		#flak	#ryanscissorhands 
========================================================================================
*/

void() LaunchFlakShell;
void() DetonateFlakShell;

void() ShrapnelShot1 = [0, ShrapnelShot2] {self.weaponframe = 1;sound(self, CHAN_WEAPON, "aoa/flakshot.wav", 1.0, ATTN_NORM);};
void() ShrapnelShot2 = [0, ShrapnelShot3]
{
	self.weaponframe = 2;
	if (self.tome_finished) // Tome of Power: Instant explosion #tomeflag
		DetonateFlakShell();
	else
		LaunchFlakShell();

};
void() ShrapnelShot3 = [0, ShrapnelShot4] {self.weaponframe = 3;};
void() ShrapnelShot4 = [0, ShrapnelShot5] {self.weaponframe = 4;};
void() ShrapnelShot5 = [0, ShrapnelShot6] {self.weaponframe = 5;};
void() ShrapnelShot6 = [0, ShrapnelShot7] {self.weaponframe = 6;};
void() ShrapnelShot7 = [0, player_run] {self.weaponframe = 0;};

void() ShrapnelTouch =
{
	local float soundVariance;
	local string soundFile;
	if (pointcontents(self.origin) <-2)// all liquids and sky
	{
		remove(self);
		return;
	}
	self.count = self.count - 1;
	if (other.takedamage && other.health > 0)
	{
		T_Damage(other, self, self.owner, 5, NOARMOR);
		self.velocity = spread('1 1 1')*1500;
	}
	
	soundVariance = random();
	
	if (soundVariance > 0.8) // mix up riccochet sounds, and don't make the sound every time; it's a bit noisy
		soundFile = "weapons/ric1.wav";
	else if (soundVariance > 0.6)
		soundFile = "weapons/ric2.wav";
	else if (soundVariance > 0.4)
		soundFile = "weapons/ric3.wav";
	
	if (soundVariance > 0.4)
		sound (self, CHAN_WEAPON, soundFile, 0.5, ATTN_NORM);
	
	if (self.count <= 0) //after a number (self.count) bounces, delete shrapnel
		remove(self);
	
};

void(vector direction) FlakShrapnel =
{
	local entity shrapnel;
	
	shrapnel = spawn();
	shrapnel.owner = self.owner;
	shrapnel.classgroup = CG_PROJALL;
	shrapnel.solid = SOLID_BBOX;
	shrapnel.movetype = MOVETYPE_BOUNCE;
	shrapnel.count = 3; //number of touches before deletion
	
	shrapnel.velocity = normalize(direction)*1800;
	shrapnel.angles = vectoangles(shrapnel.velocity);
	shrapnel.avelocity = spread('50 50 50');
	

	setmodel (shrapnel, "progs/aoa/proj_flak_shrapnel.mdl");
	setsize (shrapnel, '0 0 0', '0 0 0');
	setorigin(shrapnel, self.origin + direction);
	shrapnel.touch = ShrapnelTouch;
	shrapnel.nextthink = time + 0.6;
	shrapnel.think = SUB_Remove;
};

void() FlakExplode =
{
	T_RadiusDamage(self, self.owner, 125, world, DAMAGEALL);
	//trigger sound #techdebt
	FlakShrapnel('1 0 0.1'); //
	FlakShrapnel('-1 0 0.1');
	FlakShrapnel('0 1 0.1');
	FlakShrapnel('0 -1 0.1');
	FlakShrapnel('1 1 0.1');
	FlakShrapnel('1 -1 0.1');
	FlakShrapnel('-1 1 0.1');
	FlakShrapnel('-1 -1 0.1');
	FlakShrapnel('1 0 0.1');
	FlakShrapnel('1 0 0.1'); //10 so far
	FlakShrapnel(spread('1 1 1'));
	FlakShrapnel(spread('1 1 1'));
	FlakShrapnel(spread('1 1 1'));
	FlakShrapnel(spread('1 1 1'));
	FlakShrapnel(spread('1 1 1'));
	FlakShrapnel(spread('1 1 1'));
	FlakShrapnel(spread('1 1 1'));
	FlakShrapnel(spread('1 1 1'));
	FlakShrapnel(spread('1 1 1'));
	FlakShrapnel(spread('1 1 1'));
	FlakShrapnel(spread('1 1 1')); //20 projectiles
	R_Exp3(self.origin);
	BecomeExplosion();
};

void() DetonateFlakShell =
{
	local vector org;
	local entity explosion;
	
	makevectors(self.v_angle);
	
	org = self.origin + '0 0 16' + v_up*8 + v_forward*8;
	traceline (org, org+v_forward*700, FALSE, self);
	
	explosion = spawn();
	explosion.owner = self;
	explosion.classgroup = CG_PROJALL;
	
	explosion.origin = trace_endpos - v_forward*4;
	explosion.nextthink = time;
	explosion.think = FlakExplode;
		
};

void() W_FireFlak =
{
	//trigger animation
	if (time <self.attack_finished)
		return;
	if (self.currentammo < 1)
		return;
	self.ammo_nails = self.ammo_nails - FLAK_NAILUSAGE;
	self.ammo_rockets = self.ammo_rockets - FLAK_ROCKETUSAGE;
	if (self.ammo_nails < 0)
		self.ammo_nails = 0;
	if (self.ammo_rockets < 0)
		self.ammo_rockets = 0;
	self.currentammo = CountFlakAmmo(self);

	
	W_Reload(1);
	
	ShrapnelShot1();
};

void() LaunchFlakShell =
{
	local entity flak;
	
	flak = spawn();
	flak.owner = self;
	flak.classgroup = CG_PROJALL;
	flak.solid = SOLID_BBOX;
	flak.movetype = MOVETYPE_BOUNCE;
	
	makevectors(self.v_angle);
	
	flak.velocity = v_forward*1100 + '0 0 190';
	flak.angles = vectoangles(flak.velocity);
	flak.avelocity = '-100 0 0';
	
	setmodel(flak, "progs/aoa/proj_flak_shell.mdl");
	setsize (flak, '0 0 0', '0 0 0');
	setorigin (flak, self.origin + '0 0 15' + v_forward*8 + v_right*5);
	
	flak.nextthink = time + 1.2;
	flak.think = FlakExplode;
	flak.touch = FlakExplode;
};




//=========================================END OF FLAK===================================================

/*
========================================================================================
Vampiric Mace		#mace	#ryanscissorhands
========================================================================================
*/

void() MaceSwing;

void() CastDrainHealth;

void() MaceSwing1 =	[	119,	MaceSwing2	] {self.weaponframe=1;sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);W_Reload(0.6);}; //th
void() MaceSwing2 =	[	120,	MaceSwing3	] {self.weaponframe=2;};
void() MaceSwing3 =	[	121,	MaceSwing4	] {self.weaponframe=3; MaceSwing(); };
void() MaceSwing4 =	[	122,	MaceSwing5	] {self.weaponframe=4;};
void() MaceSwing5 =	[	123,	MaceBackhand1	]
{
	self.weaponframe=5;
	if (!self.button0) //if player isn't holding mouse, don't do second attack. will need ammo check here later
	{
		player_run();
		return;
	}
};

void() MaceBackhand1 =	[	125,	MaceBackhand2	] {self.weaponframe=6;sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);W_Reload(0.7);};
void() MaceBackhand2 =	[	126,	MaceBackhand3	] {self.weaponframe=7;MaceSwing();};
void() MaceBackhand3 =	[	127,	MaceBackhand4	] {self.weaponframe=8;};
void() MaceBackhand4 =	[	128,	MaceBackhand5	] {self.weaponframe=9;};
void() MaceBackhand5 =	[	129,	MaceBackhand6	] {self.weaponframe=0;};
void() MaceBackhand6 =	[	0,	DrainHealth1	]
{
	self.weaponframe=0;
	if (!self.button0 || !self.tome_finished) //if player isn't holding mouse or doesn't have Tome of Power, end combo
	{
		player_run();
		return;
	}
};

void() DrainHealth1 =	[112, DrainHealth2]	{self.weaponframe = 10;W_Reload(1.2);};  
void() DrainHealth2 =	[115, DrainHealth3]	{self.weaponframe = 11;}; 
void() DrainHealth3 =	[118, DrainHealth4]	{self.weaponframe = 12;}; 
void() DrainHealth4 =	[118, player_run]	{self.weaponframe = 13;CastDrainHealth();}; 

void() drain1Frames =
{
	self.frame = self.frame + 1;
	if (self.frame >17)
		remove(self);
	self.nextthink = time + 0.05;
	self.think = drain1Frames;
};


void() drain2Frames =
{
	self.frame = self.frame + 1;
	if (self.frame >9)
		remove(self);
	self.nextthink = time + 0.025;
	self.think = drain2Frames;
};

void(vector location) DrainHealthEffect =
{
	local entity FX, FX2;
	
	FX = spawn();
	FX.classgroup = CG_PROJALL;
	
	FX.movetype = MOVETYPE_NONE;
	FX.solid = SOLID_NOT;
	
	setmodel (FX, "progs/aoa/bloodembers.mdl");
	setsize (FX, '0 0 0', '1000 1000 1000');
	setorigin (FX, location);
	FX.frame = 0;

	FX.nextthink = time + 0.05;
	FX.think = drain1Frames;
	
	FX2 = spawn();
	FX2.classgroup = CG_PROJALL;
	
	FX2.movetype = MOVETYPE_NONE;
	FX2.solid = SOLID_NOT;

	
	setmodel (FX2, "progs/aoa/bloodsphere.mdl");
	setsize (FX2, '0 0 0', '0 0 0');
	setorigin (FX2, location);
	FX2.frame = 0;

	FX2.nextthink = time + 0.025;
	FX2.think = drain2Frames;

	
};

void(entity victim, entity attacker) DrainHealth 
{
	T_Damage(victim, attacker, attacker, 35, DAMARMOR);
	TriggerHeal(self, 10, 110);
	SpawnBlood(victim, victim.origin + '0 0 45', '0 0 100' + spread('100 100 100'), 20,0);
};

void() CastDrainHealth =
{
	local entity NearbyEnemies;

	makevectors(self.v_angle);
	NearbyEnemies = findradius(self.origin + ignoreVertical(v_forward)*30, 120);

	while (NearbyEnemies)
	{
		if (NearbyEnemies.takedamage > 0 && NearbyEnemies.health > 0 && NearbyEnemies != self)
		{
			//aoaprint("Draining from a ", NearbyEnemies.classname, ".\n");
			DrainHealth(NearbyEnemies, self);
			sound(NearbyEnemies, CHAN_WEAPON, "aoa/drainhealth.wav", 1, ATTN_NORM);
		}
		NearbyEnemies = NearbyEnemies.chain;
	}
	makevectors(self.v_angle);
	DrainHealthEffect(self.origin + ignoreVertical(v_forward)*30);
	sound (self, CHAN_WEAPON, "aoa/hhs.wav", 1, ATTN_NORM);
};


void() MaceLungeTouch = 
{
	if (other.takedamage && !(self.flags & FL_ONGROUND))
	{
		T_Damage(other, self, self, 25, DAMARMOR);
		sound(self, CHAN_VOICE, "ad171/weapons/axe_wood.wav", 1.0, ATTN_NORM);
		SpawnBlood(other, (self.origin - other.origin)/2 + '0 0 20', self.velocity, 20,0);
	}
	self.touch = SUB_Null;
};

void() W_FireMace =
{
	local vector lunge;
	MaceSwing1(); 	//trigger animation

	if (!(self.flags & FL_ONGROUND))
	{
		return;		
	}
	sound (self, CHAN_VOICE, "qmaster/player/jump.wav", 1, ATTN_NORM);

	self.flags = self.flags - FL_ONGROUND;
	makevectors(self.v_angle);
	lunge = '0 0 300';
	//centerprint(self, ftos(v_forward_z));
	if (v_forward_z < 0)
	{	
		lunge = lunge + ignoreVertical(v_forward*4 + v_up)*600;
	}
	else
	{
		lunge = lunge + normalize(v_forward)*300 + ignoreVertical(v_forward*10 + v_up)*300;
	}
	self.touch = MaceLungeTouch;
		
	self.velocity = lunge;
};

void(vector org, entity victim) MaceSwingHits =
{
	local float damage;
	
	sound (self, CHAN_AUTO, "aoa/melee_meat.wav", 1, ATTN_NORM);
	traceline(org, victim.origin +'0 0 10', TRUE, self);
	particle(trace_endpos, '0 0 2', 73, 10);
	SpawnBlood(victim, org, '0 0 1', 10,0);
	sound (self, CHAN_AUTO, "aoa/melee_meat.wav", 1, ATTN_NORM);
	if (victim.classgroup == CG_ZOMBIE)
	{
		damage = 100; //bonus damage to zombies, but cannot drain health from zombies
	}
	else
	{
		TriggerHeal(self, 5, 100);// entity target, float hlth, float maxHealth. Heals self 5, capped at 100
	}
	
	damage = 45;//regular attack
	if (self.tome_finished)
		damage = 90; //double damage during Tome of Power
	T_Damage(victim, self, self, damage, DAMARMOR);

};

void() MaceSwing = //executes the attack part. Melee changed from traceline to findradius for sweeping attack area
{
	local	vector	source;
	local entity targets;
	local float hitSomething;
	hitSomething = FALSE;
	makevectors(self.v_angle);
	source = self.origin + '0 0 16' + v_forward*8;
	
	targets = findradius(source + v_forward*35 + '0 0 -10', 40);
	while(targets)
	{
		if (targets.takedamage && targets != self && targets.health >0)
		{
			hitSomething = TRUE;
			MaceSwingHits(source, targets);
		}
		targets = targets.chain;
	}

	if (hitSomething == TRUE)
	{
		sound (self, CHAN_AUTO, "aoa/melee_meat.wav", 1, ATTN_NORM);
	}
	traceline (source, source + v_forward*70, FALSE, self);
	
	if (trace_fraction != 1 && hitSomething == FALSE)
	{	// hit wall
		Tent_Point(TE_GUNSHOT,trace_endpos);
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
	}
};	
	


//=========================================END OF MACE================================

/*
========================================================================================
Gungnir, Spear of Odin		#gungnir #spear #ryanscissorhands
========================================================================================
*/
void() GungnirPrimary;
void() GungnirDive;
void() LaunchVortex;

// Gungnir combo: GungnirAttack, GundnirJump, GungnirDive, GungnirVortex


void()	GungnirAttack1 = 	[144, GungnirAttack2		]
{
	//setPlayerModel ("progs/player.mdl");
	self.weaponframe = 1;
	sound (self, CHAN_AUTO, "aoa/swing2.wav", 1, ATTN_NORM);
	W_Reload(0.9);
};
void()	GungnirAttack2 = 	[145, GungnirAttack3		]	{self.weaponframe = 2;GungnirPrimary();};
void()	GungnirAttack3 = 	[146, GungnirAttack4		]	{self.weaponframe = 3;};
void()	GungnirAttack4 = 	[147, GungnirAttack5		]	{self.weaponframe = 0;};
void()	GungnirAttack5 = 	[7, GungnirAttack6		]	{self.weaponframe = 0;};
void()	GungnirAttack6 = 	[8, GungnirAttack7		]	{self.weaponframe = 0;};
void()	GungnirAttack7 = 	[9, GungnirJump1]
{
	self.weaponframe = 0;
	if (!self.button0) //if player isn't holding mouse, don't do second attack. #techdebt add ammo check here
	{
		player_run();
		return;
	}
	W_Reload(0.8);

};

//Launch Vortex
void()	GungnirVortex1 = 	[145, GungnirVortex2		]	{self.weaponframe = 1;};
void()	GungnirVortex2 = 	[146, GungnirVortex3		]	{self.weaponframe = 1;};
void()	GungnirVortex3 = 	[147, GungnirVortex4		]	{self.weaponframe = 5;};
void()	GungnirVortex4 = 	[146, GungnirVortex5		]	{self.weaponframe = 6;};
void()	GungnirVortex5 = 	[146, GungnirVortex6		]	{self.weaponframe = 7;};
void()	GungnirVortex6 = 	[148, player_run]	{self.weaponframe = 8;LaunchVortex();};

void() DiveTargetFollow = //this loop ensures that the reticle is where the player is aiming, and is ultimately going to dive
{
	local vector org, dest;
	
	if (time > self.attack_finished)
	{
		remove(self);
		return;
	}
	
	makevectors(self.owner.v_angle);
	org = self.owner.origin + '0 0 32' + v_forward*8;
	dest = org + ignoreVertical(v_forward)*400 + v_forward*300 + '0 0 -400';
	traceline(org, dest, TRUE, self);
	
	setorigin (self, trace_endpos);
	
	self.nextthink = time + 0.01;
	self.think = DiveTargetFollow;
	
};

void() SpawnDiveTarget = //spawns the reticle which shows the player where they will dive to
{
	local entity target;
	
	target = spawn();
	target.owner = self;
	target.classgroup = 0;
	target.solid = SOLID_NOT;
	target.movetype = MOVETYPE_NONE;
	
	target.attack_finished = time + 0.5;
	
	setmodel (target, "progs/aoa/divetarget.mdl");
	setsize(target, '0 0 0', '0 0 0');
	setorigin(target, self.origin);
	
	target.nextthink = time;
	target.think = DiveTargetFollow;	
};

//jump in preparation for dive attack
void()	GungnirJump1 = 	[143, GungnirJump2		]
{
	self.weaponframe = 4;
	W_Reload(0.8);
	if (self.flags & FL_ONGROUND && self.ammo_voidshards > 1)
	{
		self.velocity = '0 0 550';
	}
	sound (self, CHAN_AUTO, "aoa/swing2.wav", 1, ATTN_NORM);
};
void() GungnirJump2 = [143, GungnirJump3] {self.weaponframe = 4;GungnirPrimary();SpawnDiveTarget();};
void() GungnirJump3 = [143, GungnirJump4] {self.weaponframe = 4;};
void() GungnirJump4 = [143, GungnirJump5] {self.weaponframe = 4;};
void() GungnirJump5 = [143, GungnirDive1] {self.weaponframe = 4;};

//dive attack
void() GungnirDive1 = [143, GungnirDive2] {self.weaponframe = 6;GungnirDive();};
void() GungnirDive2 = [143, GungnirDive3] {self.weaponframe = 6;};
void() GungnirDive3 = [143, GungnirDive4] {self.weaponframe = 6;};
void() GungnirDive4 = [143, player_run]
{
	self.weaponframe = 0;
	if (self.tome_finished && self.button0)//if player is attacking with Tome of Power, add Eye of Odin (Vortex)
	{
		self.nextthink = time + 0.1;
		self.think = GungnirVortex1;	
	}
};

void() impactFrames =
{
	if (self.frame == 9)
	{
		remove(self);
		return;
	}
	self.frame = self.frame + 1;
	self.nextthink = time + 0.1;
	self.think = impactFrames;
};

void() ImpaleTouch = 
{
	local entity enemies, impact;
	local vector explosionCenter;
	local float armorResist;
	
	self.velocity = self.velocity*0; //'0 0 0';
	self.touch = SUB_Null;
	self.weaponframe = 2;
	if (other.takedamage)
	{
		if (other.armorvalue > 0) //direct hits are less effective against armor, but full potency against armorless targets. This is to ensure it does less damage to players, and more to monsters
			armorResist = other.armorvalue/2;
		T_Damage (other, self, self.owner, 120 - armorResist, DAMARMOR);
	}
	if (!self.tome_finished)
		T_RadiusDamageAOA(self, self, 100, 350, self, DAMAGEALL); //norm damage 50-100
	else
		T_RadiusDamageAOA(self, self, 150, 350, self, DAMAGEALL); //Tome dmg 75-150

	
	makevectors(self.v_angle);
	explosionCenter = self.origin + ignoreVertical(v_forward)*20;
	sound (self, CHAN_AUTO, "shambler/sboom.wav", 1, ATTN_NORM); //needs a new sound #techdebt
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord (MSG_BROADCAST, explosionCenter_x);
	WriteCoord (MSG_BROADCAST, explosionCenter_y);
	WriteCoord (MSG_BROADCAST, explosionCenter_z);
	
	makevectors(self.v_angle);
	
	enemies = findradius(explosionCenter, 300);
	
	while (enemies)//area knockback 
	{
		if ( (HasLOS(enemies, self)) && ((enemies.movetype == MOVETYPE_STEP) || (enemies.movetype == MOVETYPE_WALK)) ) //if 'enemies' entity is in line of sight, and is not NONE, NOCLIP, or PUSH, then:
		{
			local vector blastDirection;
			blastDirection = ignoreVertical(normalize(enemies.origin - self.origin)) *600 + '0 0 225' + '0 0 100'*random();
			enemies.flags = enemies.flags - FL_ONGROUND;
			enemies.velocity = blastDirection;
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_TELEPORT);
			WriteCoord (MSG_BROADCAST, enemies.origin_x);
			WriteCoord (MSG_BROADCAST, enemies.origin_y);
			WriteCoord (MSG_BROADCAST, enemies.origin_z);
		}
		enemies = enemies.chain;
	}
	impact = spawn(); //the visual ring effect for the explosion
	impact.owner = self;
	impact.classgroup = CG_PROJALL;
	setmodel(impact, "progs/aoa/ad_gungnir_impact.mdl");
	setsize(impact, '0 0 0', '0 0 0');
	setorigin(impact, self.origin+ v_forward*20);
	impact.frame = 1;
	impact.nextthink = time + 0.1;
	impact.think = impactFrames;

	if (self.tome_finished && self.button0) //Tome of Power: Adds Eye of Odin to attack
	{
		self.nextthink = time + 0.1;
		self.think = GungnirVortex1;
	}
	else
	{
		player_run();
	}
};

void() GungnirDive =
{
	local vector org, dest;	
	
	if (self.ammo_voidshards < 3)
	{
		centerprint(self, "Not enough ammo");
		return;
	}
	else
	{
		self.currentammo = self.ammo_voidshards = self.ammo_voidshards - GUNGNIR_DIVE_VOIDUSAGE;//consume 3 voidshards for a dive
		if (self.ammo_voidshards < 0) self.currentammo = self.ammo_voidshards = 0;
	}
	makevectors(self.v_angle);
	org = self.origin + '0 0 32' + v_forward*8;
	dest = org + ignoreVertical(v_forward)*150 + v_forward*150 + '0 0 -200';
	traceline(org, dest, TRUE, self);
	W_Reload(0.8);
	
	if ( (trace_endpos_z - self.origin_z <= -80) && (trace_fraction > 0.2) )
	{
		self.velocity = normalize(dest - self.origin)*950 + v_forward*600;
		self.touch = ImpaleTouch;
	}
	else
	{
		GungnirAttack1();
	}
};


void() VortexTouch =
{
	if (other.takedamage)
	{	
		T_Damage(other, self, self.owner, 50, DAMARMOR);
		self.touch = SUB_Null;
	}
	self.velocity = '0 0 0';
};


void(entity victim) ZapEnemy =
{	
	if (random() > 0.65)
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
	traceline(self.origin, victim.origin, FALSE, self);
	
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	LightningDamage(self.origin, trace_endpos, self.owner, 15);	
};

void() VortexThink =
{	
	local entity victims;
	local vector gravity;
	
		sound (self, CHAN_AUTO, "aoa/vortex.wav", 1, ATTN_NORM);	
	
	if (vlen(self.velocity) > 50)
		self.velocity = self.velocity * 0.95;
	else
		self.velocity = '0 0 0';
	
	victims = findradius(self.origin, 350);
	while (victims)
	{
		if (victims.takedamage && victims != self.owner && random() > 0.8)
		{
			ZapEnemy(victims);
		}
		if (victims != self.owner && victims.movetype != MOVETYPE_NONE && victims.movetype != MOVETYPE_PUSH && victims.movetype != MOVETYPE_NOCLIP && victims != self)
		{
			gravity = self.origin - victims.origin;
			makevectors(vectoangles(gravity));
			gravity = normalize(gravity);
			
			victims.velocity = victims.velocity*0.85 + gravity * 150 + self.velocity*0.6 + v_right*200 + spread('200 200 200');
		}
		victims = victims.chain;
	}
	if (time > self.attack_finished) //delete if past expiry
		remove(self);

	if (self.frame == 1)
		sound (self, CHAN_AUTO, "aoa/vortex.wav", 1, ATTN_NORM);
	if (self.frame == 23)
		self.frame = 0;
	else
		self.frame = self.frame + 1;
		

	self.nextthink = time + 0.05;
	self.think = VortexThink;
};

void() LaunchVortex = //#EyeOfOdin
{
	local entity nearby, vortex;
	local vector org;
	
	nearby = find(world,classname,"vortex"); //check if there is an existing Eye of Odin
	if (nearby != world)
		return; //Odin only has one eye. Globally.
	
	vortex = spawn();
	
	vortex.owner = self;
	vortex.classgroup = CG_PROJALL;
	vortex.movetype = MOVETYPE_FLY;
	vortex.solid = SOLID_BBOX;
	vortex.classname = "vortex";
	vortex.attack_finished = time + 3;

	makevectors(self.v_angle);
	org = self.origin + '0 0 16' + v_forward*8 + v_up*8;
	vortex.velocity = ignoreVertical(v_forward) * 600;
	vortex.touch = VortexTouch;
	vortex.nextthink = time + 0.2;
	vortex.think = VortexThink;
	vortex.effects = vortex.effects | EF_DIMLIGHT;
	setmodel (vortex, "progs/aoa/vortex.mdl");
	setsize (vortex, '-16 -16 0', '0 0 0');
	setorigin (vortex, org);
};


void() W_FireGungnir =
{
	if (time < self.attack_finished)
	{
		return;
	}
	W_Reload(0.8); //adjust self.attack_finished time
	GungnirAttack1();	//trigger animation, delegate attack method and sound triggers
};

void() SparkTouch =
{
	if (other.takedamage)
	{
		SpawnBlood (other, self.origin, spread('100 100 100'), 25,0);
		T_Damage (other, self, self.owner, self.dmg, DAMARMOR);
		sound (self, CHAN_AUTO, "aoa/melee_meat.wav", 1, ATTN_NORM);
	}
	else
	{	// hit wall
		particle (self.origin, '0 0 0', 158, 10);
		particle (self.origin, '0 0 0', 156, 10);
		particle (self.origin, '0 0 0', 154, 10);
		sound (self, CHAN_AUTO, "player/axhit2.wav", 1, ATTN_NORM);
	}
	remove(self);
};

void() GungnirPrimary = 
{
	local	vector	source, org, swim;
	local float usedAmmo;
	local entity spark;
	
	makevectors (self.v_angle);
	
	
	if (self.ammo_voidshards > 0)
	{
		usedAmmo = TRUE;
		self.currentammo = self.ammo_voidshards = self.ammo_voidshards - 1;
	}
	swim = v_forward; //this is used to make the player go faster underwater
	source = self.origin + v_up*16 + v_right*6 + v_forward*8;
	traceline (source, source + v_forward*150, FALSE, self);
	if (self.waterlevel > 2.8)
	{
		if (swim_z > 0)
			swim_z = 0;
		self.velocity = swim*1500;//underwater boost
	}
	if (usedAmmo == TRUE)
	{
		spark = spawn();
		spark.owner = self;
		spark.classgroup = CG_PROJALL;
		spark.touch = SparkTouch;
		spark.nextthink = time + 2;
		spark.think = SUB_Remove;
		
		spark.movetype = MOVETYPE_FLYMISSILE;
		spark.solid = SOLID_BBOX;
		spark.velocity = normalize(v_forward)*1000;
		spark.angles = vectoangles(spark.velocity);
		setmodel (spark, "progs/aoa/spark.mdl");
		setorigin (spark, self.origin + v_up*12 + v_right*8 + v_forward*25);
		setsize (spark, '0 0 0', '0 0 0');
		spark.dmg = 40;
	}
	else if (trace_fraction < 1)
	{
		org = trace_endpos + v_forward*(-2);

		if (trace_ent.takedamage) //do damage and make blood if it lands
		{
			SpawnBlood (trace_ent, org, '0 0 0', 40,0);
			if (trace_ent.classgroup == CG_ZOMBIE)
				T_Damage(trace_ent, self, self, 400, DAMARMOR);
			T_Damage (trace_ent, self, self, 50, DAMARMOR);
			sound (self, CHAN_WEAPON, "blob/hit1.wav", 1, ATTN_NORM);
			sound (self, CHAN_AUTO, "aoa/melee_meat.wav", 1, ATTN_NORM);
		}
		else
		{	// hit wall
			particle (trace_endpos, '0 0 0', 154, 15);
			particle (trace_endpos, '0 0 0', 156, 15);
			particle (trace_endpos, '0 0 0', 158, 15);
			sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		}
	}
};

//=========================================END OF GUNRNIR===================================================

/*
========================================================================================
Sanguinators		#gauntlets #bloodgauntlets #sanguinators #ryanscissorhands
========================================================================================
*/
void (float RightOffset) GauntletBeam;
void() GauntletBloodReturn;

void() BloodTornadoSeek;
void() AttackWithGreyOrbs;

void()	RGaunt1 =[		115,		RGaunt2	]	
{
	self.weaponframe=1;
	GauntletBeam(15); //right beam
	AttackWithGreyOrbs(); //any orbs generated with tome are now projectiles.
	W_Reload(0.4);
};
void()	RGaunt2 =[		117,		RGaunt3	] { self.weaponframe=2;};

void()	RGaunt3 =[		118,		LGaunt1	]
{
	self.weaponframe=2;
	if (!self.button0) //if player isn't holding attack, then stop attacking; otherwise, do left attack
	{
		player_run();
		return;
	}
};

void()	LGaunt1 =[		115,		LGaunt2	]	
{
	self.weaponframe=3;
	GauntletBeam(-15); //left beam
	AttackWithGreyOrbs();
	W_Reload(0.4);
};

void() LGaunt2 = [117, LGaunt3]{self.weaponframe=4;};

void()	LGaunt3 =[		118,		RGaunt1	]
{
	self.weaponframe=4;
	if (!self.button0 || self.currentammo < 2) //if player isn't holding attack, then stop attacking; otherwise, do right attack
	{
		player_run();
		return;
	}
};

void() GauntletOrbTouch =
{
	if (other == self.owner)
		return;	
	
	if (other.takedamage)
	{
		if (other.classname == "monster_shambler")
			self.dmg = self.dmg *2;
		T_Damage (other, self, self.owner, self.dmg, DAMARMOR);
		sound (self, CHAN_AUTO, "aoa/melee_meat.wav", 1, ATTN_NORM);
	}
	remove(self);
};


void() GreyOrbTouch = //Tome of Power blood orb projectiles
{
	if (other != self.owner) {
		T_RadiusDamageAOA(self, self.owner, 100, 80, self.owner, DAMAGEALL);
		R_Exp3(self.origin);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);		
		BecomeExplosion ();
		remove(self);
	}
};

void() CountGreyOrbs =
{
	local float orbCount;
	local entity orbs;
	
	orbCount = 0;
	orbs = find(world, classname, "GreyBloodOrb");
	while (orbs)
	{
		orbCount = orbCount + 1;
		orbs = find(orbs, classname, "GreyBloodOrb");
	}
	//aoaprint("There are ", ftos(orbCount), "orbs on the server.", "");
};

entity (entity first, entity second, entity reference) ClosestEntity = //returns the closest of first or second, filtering out world
{
	if (first == world && second != world)
		return second;
	if (second == world && first != world)
		return first;
	
	local float distance1, distance2;
	
	distance1 = vlen(reference.origin - first.origin);
	distance2 = vlen(reference.origin - second.origin);
	if (distance1 >= distance2)
		return first;
	else
		return second;
};

void() AttackWithGreyOrbs = // self == Player
{
	//dprint("attempting to attack with orb.\n"); //useful for debugging
	//CountGreyOrbs(); //useful for debugging
	local entity GreyOrbs, target;
	local float success;
	makevectors (self.v_angle);
	
	target = world;
	success = FALSE;
	
	GreyOrbs = find(world, classname, "GreyBloodOrb");
	while (GreyOrbs != world)
	{
		if (GreyOrbs.owner == self)
		{
			success = TRUE;
			if (target == world)
				target = GreyOrbs;
			else
				target = ClosestEntity (target, GreyOrbs, self);//(entity reference, entity first, entity second);
			
		}
		GreyOrbs = find(GreyOrbs, classname, "GreyBloodOrb");
	}
	
	if (success == TRUE)
	{
		//dprint("Orb Launched.\n"); //useful for debugging
		target.solid = SOLID_BBOX;
		target.touch = GreyOrbTouch;
		target.velocity = v_forward*800;
		target.avelocity = spread('300 300 300');
		// #techdebt needs a classgroup 
		target.nextthink = time + 3;
		target.think = SUB_Remove;
		target.dmg = 100;
		target.attack_finished = time + 3;
		
		setmodel (target, "progs/aoa/greyorbprojectile.mdl");


	}
};

void() BloodTornadoSeek = //converts blood orbs into grey blood orbs, in preparation for attacks with Tome of Power
{
	local vector cog, toOwner; //cog = center of gravity location, toOwner is the diff from cog to self.origin
	local float distance;

	if (time > self.attack_finished) //this checks for the expiry of each orb
	{
		remove(self);
		return;
	}
	
	self.solid = SOLID_NOT;
	
	setmodel (self, "progs/aoa/greyorb.mdl");//#techdebt I should leverage different skins, rather than different models.
	self.classname = "GreyBloodOrb";
	
	makevectors(self.owner.v_angle);
	cog = (self.owner.origin + '0 0 4' + ignoreVertical(v_forward)*30); //cog is a specific location ahead of the player
	toOwner = cog-self.origin; //this vector leads from self to center of gravity
	distance = vlen(toOwner);

	makevectors (vectoangles (toOwner));
	
	if (distance > 50)
	{
		self.velocity = normalize (toOwner)*500 + spread('40 40 40');
	}
	else
	{
		self.velocity = v_right*300 + v_forward*250 + spread('20 20 10');
		self.velocity_z = (cog_z - self.origin_z) * 0.5;
	}
	
	self.avelocity = self.avelocity + spread('20 20 20');//you spin me right round, baby
	self.nextthink = time + 0.05;
	self.think = BloodTornadoSeek;
	
	//this section is responsible for player healing and armor regenration

	if (self.owner.armorvalue < 100)
	{
		self.owner.armorvalue = self.owner.armorvalue + 0.01;
		self.dmg = self.dmg - 0.01;
	}
	if (self.owner.armortype < 0.50)
		self.owner.armortype = 0.50;
	
	if (vlen(self.velocity) <= 2) //delete if it gets stuck
	{
		remove(self);
	}
};

void() TurnIntoArmor =
{
	if (self.owner.armorvalue < 199)
		self.owner.armorvalue = self.owner.armorvalue + 2;
	if (self.owner.armortype < 0.5)
		self.owner.armortype = 0.5;
	sound(self, CHAN_VOICE, "aoa/mildarmor.wav", 0.5, ATTN_NORM);
	remove(self);	
};

void() GauntletBloodOrbit = //make the blood orbs orbit the player, and provide health if possible.
{
	local float distance, contents;
	local vector toOwner;
	
	
	if (self.owner.tome_finished) //
	{
		self.nextthink = time;
		self.think = BloodTornadoSeek;
		return;
	}
	
	if (self.frame == 9)//loop through frames
		self.frame = 0;
	else
		self.frame = self.frame + 1;
		
	if (self.owner.health < 0) //this is set by GauntletDrainSpell as attack_finished (time+20seconds), and determines the lifspan of the Gauntlet Blood bits
	{
		remove(self);
		return;
	}
	if (time > self.attack_finished) //at expiry, turn into armor
	{
		TurnIntoArmor();
		return;
	}

	if (self.owner.health <100 && self.owner.health >0 && vlen(self.owner.origin - self.origin) < 64 && self.enemy != self.owner) //heal owner for self.dmg
	{
		TriggerHeal(self.owner, self.dmg, 100);
		remove(self);
		return;
	}
	contents = pointcontents(self.origin);
	if (contents == -3 || contents == -4 || contents == -5)
	{
		remove(self);
		return;
	}
	
	if (self.flags & FL_ONGROUND) //make sure bits don't get stuck on the ground as they orbit
	{
		self.flags = self.flags - FL_ONGROUND;
		setorigin (self, self.origin + '0 0 1');
	}
	
	makevectors(self.owner.v_angle);
	toOwner = (self.owner.origin + '0 0 23' + v_forward*50 + v_right*36 + self.attack_offset); //this is where the blood orbs congregate, the player's "blood clot"
	distance = vlen(toOwner - self.origin);

	makevectors (vectoangles (toOwner - self.origin)); //make orb face the player's "blood clot" location, where the blood orbs congregate
	
	if (distance < 60)
	{
		self.velocity = self.velocity*(0.85) + normalize(toOwner - self.origin)*500 *(distance / 30) + spread('20 20 20');
	}
	else
	{
		self.velocity = self.velocity*(0.85) + normalize(toOwner - self.origin)*500 + spread('90 90 90');

	}
	self.avelocity = self.avelocity + spread('3 3 3');
	self.nextthink = time + 0.045 + random()*0.01;
	self.think = GauntletBloodOrbit;
};

void() GauntletBloodReturn = //used to move the blood orbs from the victim back to the attacker. As they get close, this loop changes to GauntletBloodOrbit(), which will make the orbs circle the player
{
	
	if (vlen(self.origin - self.owner.origin) > 70)//fly toward self.owner until it gets within 50
	{
		self.velocity = normalize( self.owner.origin - self.origin + '0 0 20'+ spread('50 50 80') )*225;
	}
	else
	{
		self.nextthink = time;
		self.think = GauntletBloodOrbit;
		return;
	}
	
	if (self.frame == 9)
		self.frame = 0;
	else
		self.frame = self.frame + 1;
	
	self.nextthink = time + 0.1;
	self.think = GauntletBloodReturn;
	if (time > self.attack_finished)
		remove(self);
};

void(entity victim) GauntletDrainSpell = //spawns orbs of blood at enemy hit by gauntlet's hitscan attack. They will seek the player
{

	local entity FlyingBlood;

	FlyingBlood = spawn();
	FlyingBlood.classgroup = CG_PROJALL;
	FlyingBlood.enemy = victim;
	FlyingBlood.owner = self;
	FlyingBlood.classname = "FlyingBlood";
	FlyingBlood.movetype = MOVETYPE_FLY;
	FlyingBlood.solid = SOLID_TRIGGER;
	FlyingBlood.dmg = 4;
	FlyingBlood.attack_finished = time + 15;

	FlyingBlood.velocity = normalize(self.origin - self.owner.origin) * 175 + '0 0 30' + spread('100 100 60'); //fly sort of towards owner
	FlyingBlood.angles = vectoangles(spread('100 100 100'));
	self.avelocity = spread('360 360 360');
	FlyingBlood.attack_offset = spread('5 5 4');
	FlyingBlood.touch = SUB_Null;

	setmodel (FlyingBlood, "progs/aoa/bloodorb_small.mdl");
	setsize (FlyingBlood, '0 0 0', '0 0 0');		
	setorigin (FlyingBlood, victim.origin + '0 0 18');
	
	FlyingBlood.nextthink = time + 0.2;
	FlyingBlood.think = GauntletBloodReturn;
};


void (float RightOffset) GauntletBeam = //triggers attack and visual effect, alternating left and right by passing a different 'RightOffset" value.
{
	if (self.ammo_bloodcrystals < 1)
	{
		self.weapon = W_BestWeapon (self);
		return;
	}	
	
	local vector org, dir;
	local float randy;
	
	self.currentammo = self.ammo_bloodcrystals = self.ammo_bloodcrystals - 1;
	
	randy = random();
	
	if (RightOffset > 0)
	{
		if (randy > 0.5)
			sound(self, CHAN_WEAPON, "aoa/sanguinator_atk1.wav", 0.7, ATTN_NORM); //gauntlet_att.wav"
		else 
			sound(self, CHAN_WEAPON, "aoa/sanguinator_atk2.wav", 0.7, ATTN_NORM);
	}
	else
	{
		if (randy > 0.5)
			sound(self, CHAN_WEAPON, "aoa/sanguinator_atk2.wav", 0.7, ATTN_NORM);
		else 
			sound(self, CHAN_WEAPON, "aoa/sanguinator_atk3.wav", 0.7, ATTN_NORM);
	}
		
	makevectors(self.v_angle);
	org = self.origin + v_up*6 + v_forward*16 + v_right*RightOffset;
	
	if (self.tome_finished) //langer range with Tome
		dir = org + v_forward*1000 + v_right*(-1)*RightOffset;
	else
		dir = org + v_forward*600 + v_right*(-1)*RightOffset;
	
	traceline(org, dir, FALSE, self);
	if (trace_ent.takedamage)
	{	
		GauntletDrainSpell (trace_ent);
		MakeBeam(org, dir, "progs/aoa/drainhit.mdl", 0.3);
		sound(self, CHAN_VOICE, "aoa/heartbeat.wav", 1, ATTN_NORM);//play heartbeat sound when it hits a target
	}
	else
	{
		MakeBeam(org, dir, "progs/aoa/drainmiss.mdl", 0.15);
	}
	LightningDamage (org, dir, self, 15);
	
};

void() W_FireSanguinators = //triggers animations, which alternate left/right like the nailgun
{
	W_Reload(0.3);
	RGaunt1();//trigger animations, delegating attack triggers and sounds
};
//=========================================END OF SANGUINATORS================================