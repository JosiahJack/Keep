// Initially written by Qmaster and tested in the Keep mod

// Add in your defs somewhere, if in defs.qc, must be below "void		end_sys_globals;"
// .float spritestarted; 

// you might need to change the T_Damage's below to remove ",DAMARMOR" from each...I'm using AD's modified T_Damage
// same for T_RadiusDamage, you'll need to remove ",DAMAGEALL"

void (vector startpos, float radius, float life) SpawnOrbLightning;

void() orb_sprite_loop = {
	if (self.spritestarted == FALSE) {
		// first frame setup the start frame and alpha
		self.frame = self.pos1_x;
		self.alpha = self.pos1_y;
		// = self.pos1_z; // nothing yet
		self.spritestarted = TRUE;
	} else {
		self.frame = self.frame + 1;
	}

	if (self.frame > (self.idleweaponframe)) {
		self.frame = self.pos1_x;
		self.use();
		return; //all done!
	}

	self.think = orb_sprite_loop;
	self.nextthink = time + 0.05;  // fast think
};

void (vector p1, vector p2, entity from, float damage) OrbLightningDamage = {
   local entity e1;
   local entity e2;
   local vector f;

   f = (p2 - p1);
   normalize (f);
   f_x = (FALSE - f_y);
   f_y = f_x;
   f_z = FALSE;
   f = (f * FL_INWATER);
   e2 = world;
   e1 = world;
   traceline (p1,p2,FALSE,self);
   if ( trace_ent.takedamage ) {
      particle (trace_endpos,'0.000 0.000 100.000',225.000,(damage * 4));
      T_Damage (trace_ent,from,from.owner,damage,DAMARMOR);
      if ( (self.classname == "player") ) {
         if ( (other.classname == "player") )
            trace_ent.velocity_z = (trace_ent.velocity_z + 400);
      }
   }
   e1 = trace_ent;
   traceline ((p1 + f),(p2 + f),FALSE,self);
   if ( ((trace_ent != e1) && trace_ent.takedamage) ) {
      particle (trace_endpos,'0.000 0.000 100.000',225.000,(damage * 4));
      T_Damage (trace_ent,from,from.owner,damage,DAMARMOR);
   }
   e2 = trace_ent;
   traceline ((p1 - f),(p2 - f),FALSE,self);
   if ( (((trace_ent != e1) && (trace_ent != e2)) && trace_ent.takedamage) ) {
      particle (trace_endpos,'0.000 0.000 100.000',225.000,(damage * 4));
      T_Damage (trace_ent,from,from.owner,damage,DAMARMOR);
   }
};

void (entity current, float life) SpawnLightningTrace = {
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
	if (current.classgroup == CG_ZOMBIE) {
		dmg = 70; // poor zombies die in so many ways
	} else {
		dmg = 30;
	}
	OrbLightningDamage (self.origin,current.origin,self,dmg);
};

void () env_sprite_loop;

void () lightning_orb_death = {
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
	light.think = orb_sprite_loop;
	light.use = SUB_Remove;
	light.nextthink = time + 0.1;
	sound (light,CHAN_AUTO,"bfg/bfg.wav",TRUE,ATTN_NORM); // death burst
	T_RadiusDamage(self, self.owner, 40,world,DAMAGEALL); // minor damage from exploding
	
	SpawnOrbLightning(self.origin,250,0.4);
	self.think = SUB_Remove;
	self.nextthink = time + 0.1;
};

void (vector startpos, float radius, float life) SpawnOrbLightning = {
	local entity head;
	local vector org;

	head = findradius(startpos,radius); // find EVERYTHING within 250 unit radius
	while (head) {
		// Can be damaged and NOT immune to radius (splash) damage
		if ((head.takedamage > 0) && (head.flags & FL_MONSTER)) {
			org = head.origin + (head.mins + head.maxs)*0.5;
			if (head.health > 0) {
				SpawnLightningTrace(head,life); // create initial lightning for any monsters found
			}
		}
		head = head.chain;
	}
};

void () lightning_orb_think = {
	if (self.attack_finished < time) {
		self.think = self.think1;
		self.nextthink = time + 0.1;
		return;
	}

	SpawnOrbLightning(self.origin,250,1.9);
	self.think = lightning_orb_think;
	self.nextthink = time + 0.1;
};

void () SpawnLightningOrb = {
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
	light.think1 = lightning_orb_death;
	light.nextthink = (time + 0.5);
	sound (light,CHAN_AUTO,"nehahra/ambience/thunder3.wav",TRUE,ATTN_NORM);
	//SpawnOrbLightning(light.origin,250,1.9);  // find and create lightning traces
};

void () HIP_FireMjolnir2 = {
   local vector org;
   local float damage;
   local vector source;

   self.attack_finished = (time + 0.400);
   source = (self.origin + '0.000 0.000 16.000');
   makevectors (self.v_angle);
   traceline (source,(source + (v_forward * RANGE_PLAYAXE)),FALSE,self);
   if ( ((trace_fraction == TRUE) && (self.ammo_cells >= 15.000)) ) {
      source = (source + (v_forward * RANGE_PLAYAXE));
      traceline (source,(source - (v_up * 50.000)),FALSE,self);
      // if ( ((trace_fraction > 0.300) && (trace_fraction < TRUE)) ) {
		self.ammo_cells = (self.ammo_cells - 15.000);
		self.currentammo = (self.currentammo - 15.000);
         SpawnLightningOrb();
         self.attack_finished = (time + 0.800);
         return ;
      // }
   }
   org = (trace_endpos - (v_forward * 4));
   if ( trace_ent.takedamage ) {
	if (self.ammo_cells >= 15) {
      	damage = 300.000;
	} else {
		damage = 80;
	}

	trace_ent.axhitme = TRUE;
	SpawnBlood (trace_ent, org,v_forward,damage);
 	T_Damage (trace_ent,self,self,damage, DAMARMOR);
	if (self.ammo_cells >= 15) {
		SpawnLightningOrb();
		self.ammo_cells = (self.ammo_cells - 15.000);
		self.currentammo = (self.currentammo - 15.000);
	}
   } else {
      if ( (trace_fraction != TRUE) ) {
         sound (self,CHAN_WEAPON,"hipnotic/weapons/mjoltink.wav",TRUE,ATTN_NORM); //tink, nothin
         WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
         WriteByte (MSG_BROADCAST,TE_GUNSHOT);
         WriteCoord (MSG_BROADCAST,org_x);
         WriteCoord (MSG_BROADCAST,org_y);
         WriteCoord (MSG_BROADCAST,org_z);
      } else {
         sound (self,CHAN_WEAPON,"knight/sword1.wav",TRUE,ATTN_NORM); //swoosh
      }
   }
   self.attack_finished = (time + 0.400);
};