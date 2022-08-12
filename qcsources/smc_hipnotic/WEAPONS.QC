/*
*/
//JIM
void( vector pos ) placebullethole;
void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void () player_run;
void(entity bomb, entity attacker, float rad, entity ignore) T_RadiusDamage;
void(vector org, vector vel, float damage) SpawnBlood;
void() SuperDamageSound;


void(vector org, vector vel) SpawnMeatSpray_eviltexture =
{
	local	entity missile;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity_x = vel_x * crandom() * 2.5;
	missile.velocity_y = vel_y * crandom() * 2.5;
	missile.velocity_z = vel_z + 130 + 100*random();

	missile.avelocity = '3000 1000 2000';
	
	local float zufall;
	zufall = random();		// randomize gib sizes
	    if (zufall > 0.8)  
	    	missile.scale = 1.6;
	    else if (zufall > 0.6)  
	    	missile.scale = 1.3;
	    else if (zufall > 0.4)  
	    	missile.scale = 1;
	    else if (zufall > 0.2) 
	    	missile.scale = 0.7;
	    else 
	    	missile.scale = 0.4;

// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, org);
};



//MED 10/18/96
void(float damage) spawn_touchblood;
/*
================
HIPNOTIC WEAPONS
================
*/
void() HIP_LaserTouch =
{
	local vector org;
   local vector spot1,spot2;
   local vector oldvel;
   local float mag;
   local float r;

   self.owner = world;
   self.cnt = self.cnt + 1;
   if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
 	local float surfacenum;
	local string tex;
	surfacenum = getsurfacenearpoint(world, self.origin);
	if (surfacenum >= 0)
	{
		tex = getsurfacetexture(world, surfacenum);
		if ((tex == "sky1") || (tex == "sky4") || (tex == "sky10") || (tex == "sky_tele"))
		{
			remove(self);
			return;
		}
	}

   oldvel = normalize(self.old_velocity);
   spot1 = self.origin - (16*oldvel);
   spot2 = self.origin + (16*oldvel);
   traceline (spot1, spot2, FALSE, self);  // see through other monsters
   self.origin = trace_endpos;

   org = self.origin;

     	if ((other.inflamed == 1) && (other.inflamekillafterdeath == 0))
	{
		other.inflamekillafterdeath = 1;
		other.health = -1;
		other.nextthink = time;
		other.think = other.th_die;
	}

    if (other.takedamage)
      {
      if (self.lastvictim == other)
         {
         self.dmg = self.dmg / 2;
         }
	   var float autocvar_shootablebuttonsandsecrets = 1;     	// set cvar 'shootablebuttonsandsecrets' default to 1
	   if (autocvar_shootablebuttonsandsecrets != 0)		// if 'shootablebuttonsandsecrets' is other than '0'
	   {
		if (((other.takedamage != DAMAGE_AIM) && (other.classname != "monster_hell_knight2")) || (other.model == "maps/b_explob.bsp") || (other.model == "maps/b_exbox2.bsp"))	
				// prevents shootable buttons, secret walls/meshes and exploding boxes to spawn blood
		  {
			if (autocvar_shootablebuttonsandsecrets == 1)		// if 'shootablebuttonsandsecrets' is '1', use a new "secret" particle effect, so that the player notice that he just shot a secret wall/button
				pointparticles(particleeffectnum("secret"), org, '0 0 0', 1); 
			else 							// if 'shootablebuttonsandsecrets' is '2', use standard particle effect
				pointparticles(particleeffectnum("laser_impact"), org, '0 0 0', 1); 
	                T_Damage (other, self, self.lastvictim, self.dmg);
	                remove(self); 
			return;
		  }
	   }
      spawn_touchblood (self.dmg);
      T_Damage (other, self, self.lastvictim, self.dmg);
      }
   else 
   {   
      
      	if (autocvar_evil_faces)
	{
		local float surfnum;
		local string s;
		local vector backwards;
		surfnum = getsurfacenearpoint(world, org);
		if (surfnum >= 0)
		{
			s = getsurfacetexture(world, surfnum);
			if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
			{
				backwards = org;
				backwards = backwards - 8*normalize(self.velocity);
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnBlood (backwards, '0 0 0', 5);
				if (facetime < time)
				{
					facetime = time + 2;					// only spawn a face every 2 seconds (not more/earlier)
					local vector face_spawn_pos, face_spawn_vel;
					face_spawn_vel = normalize (trace_plane_normal);	
					face_spawn_vel = face_spawn_vel * 10;
					face_spawn_pos = org - trace_plane_normal * 20;		// face is spawned inside wall and comes out of it...
					spawn_face (face_spawn_pos, face_spawn_vel, 0);
				}
				remove(self); 
				return; 
			}
		}		
	}
   
      if ((self.cnt == 3) || (random()<0.35))  // was 0.15
      {
/*
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
*/
	pointparticles(particleeffectnum("laser_impact"), org, '0 0 0', 1); 
      }
      else
      {
//      self.dmg = 0.66 * self.dmg;
      self.dmg = 0.9 * self.dmg;
//      self.speed = 0.95 * self.speed;
      self.velocity = oldvel+(2*trace_plane_normal);
      self.velocity = normalize(self.velocity);
      self.velocity = self.speed * self.velocity;
      self.old_velocity = self.velocity;
      if (self.flags & FL_ONGROUND)
         self.flags = self.flags - FL_ONGROUND;
      r = random();
      sound (self, CHAN_WEAPON, "hipweap/laserric.wav", 1, ATTN_STATIC);
/*
      if (r<0.33)
         sound (self, CHAN_WEAPON, "weapons/ric1.wav", 1, ATTN_STATIC);
      else if (r<0.66)
         sound (self, CHAN_WEAPON, "weapons/ric2.wav", 1, ATTN_STATIC);
      else
         sound (self, CHAN_WEAPON, "weapons/ric3.wav", 1, ATTN_STATIC);
*/
      return;
      }
   }
  
   sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
   remove(self);
};


void() HIP_LaserThink =
   {
   local float delta;

   if (time>self.attack_finished)
      {
      remove(self);
      return;
      }
   if (self.flags & FL_ONGROUND)
      self.flags = self.flags - FL_ONGROUND;
   self.velocity = self.old_velocity;
   self.angles = vectoangles(self.velocity);
   self.nextthink = time+0.1;
   };


void(vector org, vector vec, float light) HIP_LaunchLaser =
{
//   sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);
   sound (self ,CHAN_WEAPON, "hipweap/laserg.wav", 1, ATTN_NORM);

   vec = normalize(vec);

	newmis = spawn();
newmis.cansplash = TRUE;
   newmis.owner = self;
   newmis.classname = "hiplaser";
   newmis.lastvictim = self;
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
//   if (light)
//      newmis.effects = EF_DIMLIGHT;
newmis.traileffectnum = particleeffectnum("lasergun_trail");

   setmodel (newmis, "progs/lasrspik.mdl");
   setsize (newmis, '0 0 0', '0 0 0');

   setorigin (newmis, org);

   newmis.speed = 1000;
   newmis.dmg = autocvar_player_lasergun;	// default 18
   newmis.velocity = vec * newmis.speed;
   newmis.old_velocity = newmis.velocity;
   newmis.angles = vectoangles(newmis.velocity);
   newmis.avelocity = '0 0 400';

   newmis.nextthink = time;
   newmis.attack_finished = time + 5;
   newmis.think = HIP_LaserThink;
   newmis.touch = HIP_LaserTouch;
   newmis.count = 0;
};


/*
=================
HIP_FireLaser
=================
*/
void(float stat) HIP_FireLaser =
   {
   local vector org;
   local vector dir;
   local vector out;
   local float ofs;
   local float aofs;

   if (!self.button0)
      {
      player_run ();
      return;
      }
   if (self.ammo_cells < 1)
      {
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
      }
   SuperDamageSound();
   self.effects = self.effects | EF_MUZZLEFLASH;
   makevectors (self.v_angle);

   ofs = 6;
   out = v_forward;
   out_z = 0;
   out = normalize(out);
   org = self.origin + ((12-ofs) * v_up) + (12*out);
//   org = self.origin + (1*v_forward);
   dir = aim (self, 1000);
   aofs = ofs * 0.707;
   if (stat == 0)
      {
      self.currentammo = self.ammo_cells = self.ammo_cells - 1;
      org = org + (aofs*v_right);
      org = org - (aofs*v_up);
      HIP_LaunchLaser(org, dir, 0);
      org = org - (2*aofs*v_right);
      HIP_LaunchLaser(org, dir, 0);
      }
   else if (stat == 1)
      {
      self.currentammo = self.ammo_cells = self.ammo_cells - 1;
      org = org + (ofs*v_up);
      if (random()<0.1)
         {
         HIP_LaunchLaser(org, dir, 1);
         newmis.dmg = autocvar_player_lasergun * 1.39;	// default 25
         }
      else
         HIP_LaunchLaser(org, dir, 0);
      }
   self.punchangle_x = -1;

   ///////// pushback Laser
	var float autocvar_pushback = 1;     	// set cvar 'pushback' default to 1
	if (autocvar_pushback != 0)		// if 'pushback' is other than '0', pushback is enabled
		{
		var float autocvar_pushbacklaser = 30;    // set cvar 'pushbacklaser' default to 30
		local vector pushback1, direc;
		direc = aim (self, 100);
		traceline (self.origin, self.origin + direc*autocvar_pushbacklaser, FALSE, self);
		pushback1 = (trace_endpos - self.origin); // + (normalize(direc) * 80);
		self.velocity = self.velocity - pushback1;
		}

////  added GYRO below

	local entity lasr;
	local	vector align, lasrvec;

	makevectors(self.v_angle);
	align = dir + v_up*0.24;
	traceline (self.origin, self.origin + align*200, FALSE, self);
	lasrvec = (trace_endpos - self.origin) + (normalize(dir) * 80);
	lasr = Gyro_Force_Create("laserhit", self.origin);
	Gyro_Force_ApplyFalloff_ConeLinear(lasr, lasrvec, 16, 16);
	Gyro_Force_ApplyAffector_Directional(lasr, lasrvec, 300, FALSE);
	Gyro_Force_AddProperty_Instant(lasr);
	Gyro_Force_Ignore(lasr, self); 
   };



/*
=================
HIP_HammerDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) HIP_HammerDamage =
{
	local entity		e1, e2;
	local vector		f;

	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
//JIM
	if (trace_ent.takedamage && !trace_ent.wetsuit_finished )
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
//JIM
	if (trace_ent != e1 && trace_ent.takedamage &&
		!trace_ent.wetsuit_finished )
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
//JIM
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage &&
		!trace_ent.wetsuit_finished )
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
};


/*
void() HIP_DiversionLightningThink =
   {
   local vector   org,end;

   if (time > self.delay)
      {
      remove(self);
      return;
      }

   makevectors(self.v_angle);
   org = self.origin;
   end = org + v_forward*200;
//   end = end + (((200*random()) - 100) * v_up);
   end = end + (((400*random()) - 200) * v_right);

   traceline (org, end, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
   WriteCoord (MSG_BROADCAST, trace_endpos_x);
   WriteCoord (MSG_BROADCAST, trace_endpos_y);
   WriteCoord (MSG_BROADCAST, trace_endpos_z);

   self.nextthink = time + 0.1;
   };
*/


//void(entity prev, entity owner, float dst) HIP_SpawnMjolnirLightning;
void() HIP_LightningThink =
   {
   local vector org;
   local vector dst;
   local entity head;
   local entity selected;
   local float cur_dist;
   local float head_dist;
   local vector vec;
   local float dot;
   local float oldstate;
   local float dam;

   if (time > self.delay)
      {
      if (self.enemy != world)
         self.enemy.struck_by_mjolnir = 0;
      remove(self);
      return;
      }
   oldstate = self.state;
   if (self.state==0)
      {
      // look in our immediate vicinity
      self.enemy = world;
      selected = world;
      cur_dist = self.distance;
      head = findradius(self.owner.origin, self.distance);
      while(head)
         {
         if(!(head.flags & FL_NOTARGET) && ((head.flags & FL_MONSTER) || (head.flags & FL_CLIENT)))
            {
//            if (visible(head) && (head!=self.owner.owner) && (head.health>0))
            if ((visible(head)) && (head!=self.owner.owner) && (head.health>0))
               {
               head_dist = vlen(head.origin - self.lastvictim.origin);
               if ((head_dist<cur_dist) && (head.struck_by_mjolnir==0))
                  {
                  selected = head;
                  cur_dist = head_dist;
                  }
               }
            }
         head = head.chain;
         }
      if (selected != world)
         {
         self.state = 1;
         self.enemy = selected;
         self.enemy.struck_by_mjolnir = 1;
         }
      else
         {
         local vector   org,end;

         makevectors(self.v_angle);
         org = self.owner.origin;
         end = org + v_forward*200;
         end = end + (((400*random()) - 200) * v_right);

         traceline (org, end, TRUE, self);

         WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
         WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
         WriteEntity (MSG_BROADCAST, self);
         WriteCoord (MSG_BROADCAST, org_x);
         WriteCoord (MSG_BROADCAST, org_y);
         WriteCoord (MSG_BROADCAST, org_z);
         WriteCoord (MSG_BROADCAST, trace_endpos_x);
         WriteCoord (MSG_BROADCAST, trace_endpos_y);
         WriteCoord (MSG_BROADCAST, trace_endpos_z);

         self.nextthink = time + 0.1;
//         self.think = HIP_DiversionLightningThink;
//         self.nextthink = time;
//         self.delay = time + 0.30;
//         self.origin = self.owner.origin;
//         self.think();
         return;
         }
      }
   org = self.lastvictim.origin;
   dst = self.enemy.absmin + 0.25*(self.enemy.absmax-self.enemy.absmin);
   dst = dst + (random()*0.5*(self.enemy.absmax-self.enemy.absmin));
   traceline (org, dst, TRUE, self.owner.owner);

   if (trace_fraction != 1.0 || self.enemy.health<=0)
      {
      self.enemy.struck_by_mjolnir = 0;
      self.state = 0;
      self.nextthink = time + 0.1;
      return;
      }
   WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
   WriteEntity (MSG_BROADCAST, self);
   WriteCoord (MSG_BROADCAST, org_x);
   WriteCoord (MSG_BROADCAST, org_y);
   WriteCoord (MSG_BROADCAST, org_z);
   WriteCoord (MSG_BROADCAST, trace_endpos_x);
   WriteCoord (MSG_BROADCAST, trace_endpos_y);
   WriteCoord (MSG_BROADCAST, trace_endpos_z);
   vec = normalize(self.enemy.origin - self.owner.origin);
   dot = vec * self.owner.movedir;
   head = self;
   self = self.owner.owner;
   if (oldstate==0)
      dam = autocvar_player_mjolnir_lightning;		// default 80
   else
      dam = autocvar_player_mjolnir_lightning * 0.375;	// default 30
   if (dot>0.3)
      HIP_HammerDamage (org, trace_endpos, self, dam);
   else
      HIP_HammerDamage (org, trace_endpos, self, dam*0.5);
   self = head;

   self.nextthink = time + 0.2;
   };


void(entity prev, entity own, float dst) HIP_SpawnMjolnirLightning =
   {
   local entity light;
   // spawn actual lightning
   light = spawn();
   light.delay = time + 0.8;
   light.state = 0;
   light.lastvictim = prev;
   light.distance = dst;
   light.owner = own;
   light.v_angle = self.angles;
   light.v_angle_x = 0;
   light.v_angle_z = 0;
   light.origin = own.origin;
   light.think = HIP_LightningThink;
   light.nextthink = time;
   };


void() HIP_SpawnMjolnirBase =
   {
   local entity light;
   // spawn lightning base
   light = spawn();
//   light.origin = self.origin - '0 0 24' + (32*v_forward);
   light.origin = trace_endpos;
   light.flags = 0;
   light.owner = self;
   light.struck_by_mjolnir = 1;
   light.think = SUB_Remove;
   light.nextthink = time + 1;
   sound (light, CHAN_AUTO, "hipweap/mjolslap.wav", 1, ATTN_NORM);
   sound (light, CHAN_WEAPON, "hipweap/mjolhit.wav", 1, ATTN_NORM);
   makevectors(self.v_angle);
   light.movedir = v_forward;
   HIP_SpawnMjolnirLightning( light, light, 350 );
   HIP_SpawnMjolnirLightning( light, light, 350 );
   HIP_SpawnMjolnirLightning( light, light, 350 );
   HIP_SpawnMjolnirLightning( light, light, 350 );
   };


void() HIP_FireMjolnirLightning =
   {
   local vector org;
   local float cells;

// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_cells;
		self.ammo_cells = 0;
      discharged = 1;
		T_RadiusDamage (self, self, 35*cells, world);
      discharged = 0;
		W_SetCurrentAmmo ();
		return;
	}

//   if (self.t_width < time)
//   {
//      sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
//      self.t_width = time + 0.6;
//   }
//   self.punchangle_x = 12;

   self.currentammo = self.ammo_cells = self.ammo_cells - 15;

   HIP_SpawnMjolnirBase();
   };


void() HIP_FireMjolnir =
   {
   local vector   org;
   local float    cells;
   local float    damage;
   local vector   source;
   local vector   ang;

///////// pushback Mjolnir
	var float autocvar_pushback = 1;     	// set cvar 'pushback' default to 1
	if (autocvar_pushback != 0)		// if 'pushback' is other than '0', pushback is enabled
		{
		var float autocvar_pushbackmjolnir = 80;    // set cvar 'pushbackmjolnir' default to 80
		local vector pushback1, direc;
		direc = aim (self, 100);
		traceline (self.origin, self.origin + direc*autocvar_pushbackmjolnir, FALSE, self);
		pushback1 = (trace_endpos - self.origin); // + (normalize(direc) * 80);
		self.velocity = self.velocity - pushback1;
		}
   
   self.attack_finished = time + 0.4;
   source = self.origin + '0 0 16';
//   ang = self.angles;
//   ang_x = 0;
//   ang_y = 0;
   makevectors(self.v_angle);
   traceline (source, source + v_forward*32, FALSE, self);
   if (trace_fraction == 1.0 && (self.ammo_cells >= 15))
      {
      source = source + v_forward*32;
      traceline (source , source - v_up*50, FALSE, self);
//      dprint("fraction = ");
//      dprint(ftos(trace_fraction));
//      dprint("\n");
      if (trace_fraction > 0.3 && trace_fraction< 1.0)
         {
         HIP_FireMjolnirLightning();
         self.attack_finished = time + 1.5;
         return;
         }
      }
   org = trace_endpos - v_forward*4;

   if (trace_ent.takedamage)
      {
	var float autocvar_shootablebuttonsandsecrets = 1;     	// set cvar 'shootablebuttonsandsecrets' default to 1
	if (autocvar_shootablebuttonsandsecrets != 0)		// if 'shootablebuttonsandsecrets' is other than '0'
	{
		if ((trace_ent.takedamage != DAMAGE_AIM) && (trace_ent.classname != "monster_hell_knight2"))	// prevents shootable buttons, secret walls/meshes to spawn blood
		{
			if (autocvar_shootablebuttonsandsecrets == 1)		// if 'shootablebuttonsandsecrets' is '1', use a new "secret" particle effect, so that the player notice that he just shot a secret wall/button
				pointparticles(particleeffectnum("secret"), org, '0 0 0', 1); 
			else 							// if 'shootablebuttonsandsecrets' is '2', use standard particle effect
				pointparticles(particleeffectnum("TE_GUNSHOT"), org, '0 0 0', 1); 
	 		sound (self, CHAN_WEAPON, "hipweap/mjoltink.wav", 1, ATTN_NORM);
			T_Damage (trace_ent, self, self, autocvar_player_mjolnir_hit);	// default 50
			return;
		}
		if ((trace_ent.model == "maps/b_explob.bsp") || (trace_ent.model == "maps/b_exbox2.bsp"))	// prevents exploding boxes to spawn blood
		{
	 		sound (self, CHAN_WEAPON, "hipweap/mjoltink.wav", 1, ATTN_NORM);
			T_Damage (trace_ent, self, self, autocvar_player_mjolnir_hit);	// default 50
			return;
		}
	}
      damage = autocvar_player_mjolnir_hit;		// default 50
      if (trace_ent.classname == "monster_zombie")
         damage = autocvar_player_mjolnir_hit + 20;	// default 70
      trace_ent.axhitme = 1;
      SpawnBlood (org, v_forward, damage);
      T_Damage (trace_ent, self, self, damage);
      }
   else
      {  // hit wall
      if (trace_fraction != 1.0)
         {
		if (autocvar_evil_faces)
		{
			local float surfnum, zu;
			local string s;
			surfnum = getsurfacenearpoint(world, trace_endpos);
			if (surfnum >= 0)
			{
				s = getsurfacetexture(world, surfnum);
				if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
				{
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnBlood (org, '0 0 0', 20);
					sound (self, CHAN_AUTO, "zombie/z_hit.wav", 1, ATTN_NORM);
	   			    //  sound (self, CHAN_WEAPON, "hipweap/mjoltink.wav", 0.8, ATTN_NORM);
					if (facetime < time)
					{
						facetime = time + 2;						// only spawn a face every 2 seconds (not more/earlier)
						local vector face_spawn_pos, face_spawn_vel;
						face_spawn_pos = trace_endpos - trace_plane_normal * 20;	// face is spawned inside wall and comes out of it...
						face_spawn_vel = normalize (trace_plane_normal);	
						face_spawn_vel = face_spawn_vel * 10;
						spawn_face (face_spawn_pos, face_spawn_vel, 1);
					}
					return;						
				}
			}
		}		
//         sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);

	if (trace_ent.inflamed == 1)
	{
	   	self.attack_finished = time + 0.4;
		trace_ent.health = -1;
		trace_ent.nextthink = time;
		trace_ent.think = trace_ent.th_die;
		return;
	}

         sound (self, CHAN_WEAPON, "hipweap/mjoltink.wav", 1, ATTN_NORM);
         WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
         WriteByte (MSG_BROADCAST, TE_GUNSHOT);
         WriteCoord (MSG_BROADCAST, org_x);
         WriteCoord (MSG_BROADCAST, org_y);
         WriteCoord (MSG_BROADCAST, org_z);
         }
      else
         {
         sound (self, CHAN_WEAPON, "knight/sword1.wav", 1, ATTN_NORM);
         }
      }
   self.attack_finished = time + 0.4;
   };


void() crush =
{
	SpawnBlood (self.enemy.mjolnir_corpse_crush, '0 0 0', 50);
	T_Damage (self, self.enemy, self.enemy, autocvar_player_mjolnir_hit * 2);		// default 50
	return;
};

void() HIP_FireMjolnir2 =		// function which takes care of Mjolnir gibbing corpses
   {
	local	vector	source;
	local	vector	org;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*73, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.i_am_a_corpse)
	{
		self.mjolnir_corpse_crush = org;
		trace_ent.enemy = self;
		trace_ent.think = crush;
		trace_ent.nextthink = time + 0.25;
	}
};


// called by worldspawn
void() W_Precache =
{
	precache_sound ("weapons/r_exp3.wav");	// new rocket explosion
	precache_sound ("weapons/rocket1i.wav");	// spike gun
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/guncock.wav");	// player shotgun
	precache_sound ("weapons/ric1.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");	// ricochet (used in c code)
	precache_sound ("weapons/spike2.wav");	// super spikes
	precache_sound ("weapons/tink1.wav");	// spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav");	// grenade launcher
	precache_sound ("weapons/bounce.wav");		// grenade bounce
	precache_sound ("weapons/shotgn2.wav");	// super shotgun
//MED
   precache_sound ("enforcer/enfstop.wav");   // laser cannon
//MED 11/06/96
   precache_sound ("knight/sword1.wav");   // laser cannon
   precache_sound ("hipweap/laserg.wav");   // laser cannon
   precache_sound ("hipweap/laserric.wav");   // laser cannon ricochet
   precache_sound ("hipweap/proxwarn.wav");   // proximity bomb
   precache_sound ("hipweap/proxbomb.wav");   // proximity bomb
//MED 11/19/96
   precache_sound ("hipweap/mjolhit.wav");   // mjolnir
   precache_sound ("hipweap/mjolslap.wav");   // mjolnir
   precache_sound ("hipweap/mjoltink.wav");   // mjolnir
};

float() crandom =
{
	return 2*(random() - 0.5);
};

/*
================
W_FireAxe
================
*/
void() W_FireAxe =
{
	local	vector	source;
	local	vector	org;
	local float 	zufall;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;
		
	////  added GYRO below
	local entity axeforce;
	local vector axevec;
	local vector dir;

	dir = aim (self, 1000);
	axevec = (trace_endpos - self.origin) + (normalize(dir) * 80);
	axeforce = Gyro_Force_Create("axe_hit", self.origin);

	Gyro_Force_ApplyFalloff_ConeLinear(axeforce, axevec, 20, 20);
	Gyro_Force_ApplyAffector_Directional(axeforce, axevec, 555, FALSE);
	Gyro_Force_AddProperty_Instant(axeforce);
	Gyro_Force_Ignore(axeforce, self); 	

	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		var float autocvar_shootablebuttonsandsecrets = 1;     	// set cvar 'shootablebuttonsandsecrets' default to 1
		if (autocvar_shootablebuttonsandsecrets != 0)		// if 'shootablebuttonsandsecrets' is other than '0'
		{
			if ((trace_ent.takedamage != DAMAGE_AIM) && (trace_ent.classname != "monster_hell_knight2"))	// prevents shootable buttons, secret walls/meshes to spawn blood
			{
				if (autocvar_shootablebuttonsandsecrets == 1)		// if 'shootablebuttonsandsecrets' is '1', use a new "secret" particle effect, so that the player notice that he just shot a secret wall/button
					pointparticles(particleeffectnum("secret"), org, '0 0 0', 1); 
				else 							// if 'shootablebuttonsandsecrets' is '2', use standard particle effect
					pointparticles(particleeffectnum("TE_GUNSHOT"), org, '0 0 0', 1); 
				sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
				T_Damage (trace_ent, self, self, autocvar_player_axe);	// default 20
				return;
			}
			if ((trace_ent.model == "maps/b_explob.bsp") || (trace_ent.model == "maps/b_exbox2.bsp"))	// prevents exploding boxes to spawn blood
			{
				sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
				T_Damage (trace_ent, self, self, autocvar_player_axe);	// default 20
				return;
			}
		}

		trace_ent.axhitme = 1;
		SpawnBlood (org, '0 0 0', 20);
		
		if (autocvar_zombienewmodelproperties >= 1)		// new zombie model is killable with axe 
			{
			if ((trace_ent.classname == "monster_zombie")&&(trace_ent.monstermodel == 2))   
				{
				if (trace_ent.axehitcount < 2)			
					T_Damage (trace_ent, self, self, autocvar_player_axe);	// default 20
				else	
					T_Damage (trace_ent, self, self, 500);		// when hitting the 3rd (!) time, do 500 damage --> zombie dies
				}
			else
				T_Damage (trace_ent, self, self, autocvar_player_axe);	// default 20
			}
		else	
			T_Damage (trace_ent, self, self, autocvar_player_axe);	// default 20

		zufall = random();
		if (zufall > 0.66)
			sound (self, CHAN_WEAPON, "player/axeflesh1.wav", 0.7, ATTN_NORM);
		else if (zufall < 0.34)
			sound (self, CHAN_WEAPON, "player/axeflesh2.wav", 0.7, ATTN_NORM);
		else
			sound (self, CHAN_WEAPON, "player/axeflesh3.wav", 0.7, ATTN_NORM);
						

		var float autocvar_fleshsplat = 1;     	// set cvar 'fleshsplat' default to 1
		if (autocvar_fleshsplat == 1)		
		{
			if (trace_ent.classname == "monster_wizard")
			{        
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1);
		 		ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 1); 
			}
			else if (trace_ent.classname == "monster_army")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
			}
			else if (trace_ent.classname == "monster_ogre")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
			}
			else if (trace_ent.classname == "monster_hell_knight")
			{
				pointparticles(particleeffectnum("sparks"), org, '0 0 0', 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
			}
			else if (trace_ent.classname == "monster_hell_knight2")
			{
				pointparticles(particleeffectnum("sparks"), org, '0 0 0', 1); 
				if (trace_ent.dodge_finished < time)		// do not spawn blood when monster is in dodge mode (in combat.qc it will not get hurt in this time)
				{
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				}
			}
			else if (trace_ent.classname == "monster_knight")
			{
				pointparticles(particleeffectnum("sparks"), org, '0 0 0', 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
			}
			else if (trace_ent.classname == "monster_demon1")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 1);
			}
			else if (trace_ent.classname == "monster_dog")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1); 
			}
			else if (trace_ent.classname == "monster_shalrath")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 1); 
			}
			else if (trace_ent.classname == "monster_tarbaby")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 1); 
			}
			else if (trace_ent.classname == "monster_shambler")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
			}
			else 
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 1);
			}
		}
				
	}
	else
	{	// hit wall
		if (autocvar_evil_faces)
		{
			local float surfnum, zu;
			local string s;
			surfnum = getsurfacenearpoint(world, trace_endpos);
			if (surfnum >= 0)
			{
				s = getsurfacetexture(world, surfnum);
				if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
				{
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnBlood (org, '0 0 0', 20);
					zu = random();
					if (zu > 0.66)
						sound (self, CHAN_WEAPON, "player/axeflesh1.wav", 0.7, ATTN_NORM);
					else if (zu < 0.34)
						sound (self, CHAN_WEAPON, "player/axeflesh2.wav", 0.7, ATTN_NORM);
					else
						sound (self, CHAN_WEAPON, "player/axeflesh3.wav", 0.7, ATTN_NORM);
					if (facetime < time)
					{
						facetime = time + 2;						// only spawn a face every 2 seconds (not more/earlier)
						local vector face_spawn_pos, face_spawn_vel;
						face_spawn_pos = trace_endpos - trace_plane_normal * 20;	// face is spawned inside wall and comes out of it...
						face_spawn_vel = normalize (trace_plane_normal);	
						face_spawn_vel = face_spawn_vel * 10;
						spawn_face (face_spawn_pos, face_spawn_vel, 1);
					}
					return;						
				}
			}
		}
		if (trace_ent.inflamed == 1)
		{
			trace_ent.health = -1;
			trace_ent.nextthink = time;
			trace_ent.think = trace_ent.th_die;
			return;
		}
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};


void() W_FireAxe2 =		// function which takes care of axe gibbing corpses
{
	local	vector	source;
	local	vector	org;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*70, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.i_am_a_corpse)
	{
		SpawnBlood (org, '0 0 0', 20);
		T_Damage (trace_ent, self, self, autocvar_player_axe);	// default 20
		local float zufall;
		zufall = random();
		if (zufall > 0.66)
			sound (self, CHAN_WEAPON, "player/axeflesh1.wav", 0.7, ATTN_NORM);
		else if (zufall < 0.34)
			sound (self, CHAN_WEAPON, "player/axeflesh2.wav", 0.7, ATTN_NORM);
		else
			sound (self, CHAN_WEAPON, "player/axeflesh3.wav", 0.7, ATTN_NORM);
	}
};


//============================================================================


vector() wall_velocity =
{
	local vector	vel;

	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	return vel;
};


/*
================
SpawnMeatSpray
================
*/
void(vector org, vector vel) SpawnMeatSpray =
{
	local	entity missile, mpuff;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 250 + 50*random();

	missile.avelocity = '3000 1000 2000';

// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, org);
};

/*
================
SpawnBlood
================
*/
void(vector org, vector vel, float damage) SpawnBlood =
{
	if (trace_ent.classname == "ShalrathMissile")	// do not spawn blood on shalrath missile
		return;	
	if (trace_ent.dodge_finished < time)		// do not spawn blood when monster is in dodge mode (in combat.qc it will not get hurt in this time)
		particle (org, vel*0.1, 73, damage*2);
};

/*
================
spawn_touchblood
================
*/
void(float damage) spawn_touchblood =
{
	local vector	vel;

	vel = wall_velocity () * 0.2;
	SpawnBlood (self.origin + vel*0.01, vel, damage);
};


/*
================
SpawnChunk
================
*/
void(vector org, vector vel) SpawnChunk =
{
	particle (org, vel*0.02, 0, 10);
};

/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

entity	multi_ent;
float	multi_damage;

void() ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
};

void() ApplyMultiDamage =
{
	if (!multi_ent)
		return;
	T_Damage (multi_ent, self, self, multi_damage);
};

void(entity hit, float damage) AddMultiDamage =
{
	if (!hit)
		return;

	if (hit != multi_ent)
	{
		ApplyMultiDamage ();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = multi_damage + damage;
};

/*
==============================================================================

BULLETS

==============================================================================
*/

/*
================
TraceAttack
================
*/
void(float damage, vector dir) TraceAttack =
{
	local	vector	vel, org;

	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{
		var float autocvar_shootablebuttonsandsecrets = 1;     	// set cvar 'shootablebuttonsandsecrets' default to 1
		if (autocvar_shootablebuttonsandsecrets != 0)		// if 'shootablebuttonsandsecrets' is other than '0'
		{
			if ((trace_ent.takedamage != DAMAGE_AIM) && (trace_ent.classname != "monster_hell_knight2"))	// prevents shootable buttons, secret walls/meshes to spawn blood
			{
				if (autocvar_shootablebuttonsandsecrets == 1)		// if 'shootablebuttonsandsecrets' is '1', use a new "secret" particle effect, so that the player notice that he just shot a secret wall/button
				{
					if (self.weapon == IT_SUPER_SHOTGUN)
						pointparticles(particleeffectnum("secret_shot2"), org, '0 0 0', 1); 
					else
						pointparticles(particleeffectnum("secret_shot1"), org, '0 0 0', 1); 
				}
				else 							// if 'shootablebuttonsandsecrets' is '2', use standard particle effect
					pointparticles(particleeffectnum("TE_GUNSHOT"), org, '0 0 0', 1); 
				AddMultiDamage (trace_ent, damage);
				return;
			}
			if ((trace_ent.model == "maps/b_explob.bsp") || (trace_ent.model == "maps/b_exbox2.bsp"))	// prevents exploding boxes to spawn blood
			{
				AddMultiDamage (trace_ent, damage);
				return;
			}

		}
		
		if (trace_ent.classname == "monster_spider")
			{
			local float resist;
			resist = autocvar_spider_attack_resistance * 0.01;
			if (random () > resist)		// decides if spider will resist this attack
				{
				SpawnBlood (org, vel*0.2, damage);
				AddMultiDamage (trace_ent, damage);
				}
			else
				return;
			}
		else
			{
			SpawnBlood (org, vel*0.2, damage);
			AddMultiDamage (trace_ent, damage);
			}

		var float autocvar_fleshsplat = 1;     	// set cvar 'fleshsplat' default to 1
		if (autocvar_fleshsplat == 1)		
		{
			if (trace_ent.classname == "monster_wizard")
			{        
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 1, 0); 
			}
			else if (trace_ent.classname == "monster_army")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 0);
			}
			else if (trace_ent.classname == "monster_ogre")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 0);
			}
			else if (trace_ent.classname == "monster_hell_knight")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 0); 
				pointparticles(particleeffectnum("sparks"), org, '0 0 0', 1); 
			}
			else if (trace_ent.classname == "monster_hell_knight2")
			{
				pointparticles(particleeffectnum("sparks"), org, '0 0 0', 1); 
				if (trace_ent.dodge_finished < time)		// do not spawn blood when monster is in dodge mode (in combat.qc it will not get hurt in this time)
				{
					ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 0); 
				}
			}
			else if (trace_ent.classname == "monster_knight")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 0);
				pointparticles(particleeffectnum("sparks"), org, '0 0 0', 1); 
			}
			else if (trace_ent.classname == "monster_demon1")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 3, 0);
			}
			else if (trace_ent.classname == "monster_dog")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 0); 
			}
			else if (trace_ent.classname == "monster_shalrath")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 4, 0); 
			}
			else if (trace_ent.classname == "monster_tarbaby")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 5, 0); 
			}
			else if (trace_ent.classname == "monster_shambler")
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 0);
			}
			else 
			{
				ThrowBloodSplat(dir, trace_endpos, trace_ent, 2, 0);
			}
		}

	}	
	else
	{
		if (autocvar_evil_faces)
		{
			local float surfnum;
			local string s;
			surfnum = getsurfacenearpoint(world, trace_endpos);
			if (surfnum >= 0)
			{
				s = getsurfacetexture(world, surfnum);
				if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
				{
					SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
					SpawnBlood (org, '0 0 0', 5);
					if (facetime < time)
					{
						facetime = time + 2;						// only spawn a face every 2 seconds (not more/earlier)
						local vector face_spawn_pos, face_spawn_vel;
						face_spawn_pos = trace_endpos - trace_plane_normal * 20;	// face is spawned inside wall and comes out of it...
						face_spawn_vel = normalize (trace_plane_normal);	
						face_spawn_vel = face_spawn_vel * 10;
						spawn_face (face_spawn_pos, face_spawn_vel, 1);
					}
					return;
				}						
			}
		}
		
	 	local float surfacenum;
		local string tex;
		surfacenum = getsurfacenearpoint(world, trace_endpos);
		if (surfacenum >= 0)
		{
			tex = getsurfacetexture(world, surfacenum);
			if ((tex == "sky1") || (tex == "sky4") || (tex == "sky10") || (tex == "sky_tele"))
				return;
		}
		
		if (trace_ent.inflamed == 1)
		{
			trace_ent.health = -1;
			trace_ent.nextthink = time;
			trace_ent.think = trace_ent.th_die;
			return;
		}

		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
	}
};


/*
=========================
W_BulletSplash    (Thanx to Qrv for the code !)
=========================
*/
void (vector org) spawn_splash =
{
   	pointparticles(particleeffectnum("watersplash"), org, '0 0 0', 1);
	precache_sound ("player/watersplash.wav");	
	sound (self, CHAN_VOICE, "player/watersplash.wav", 0.5, ATTN_NORM); 
};

void (vector org) spawn_lavasplash =
{
   	pointparticles(particleeffectnum("lavasplash"), org, '0 0 0', 1);
	precache_sound ("ambience/lavasplash_shotgun.wav");	
	sound (self, CHAN_VOICE, "ambience/lavasplash_shotgun.wav", 0.5, ATTN_NORM); 
};


void(vector dir ) W_BulletSplash =
{
   local vector shot_src;
   local float steps;
   local float stepsize;
   local float shot_length;
   local float old_contents;
   
   // How far the bullets travel, FireBullets has this as 2048
   shot_length = 2048;
   
   // How large the check step is, larger = less accurate, but faster probably.
   // Keep this as a multiple of 2, ie, 2, 4, 8, 16, 32, ...
   stepsize = 2;
   
   // This calculates the correct stepping between shot_length and stepsize;
   steps = shot_length / stepsize;
   
   // Nicked from FireBullets, but we increase the Z a little, for strange situations when stood in water... o.O
   shot_src = self.origin + v_forward*10;
   shot_src_z = self.absmin_z + self.size_z * 0.75;
   
   // If the 'gun' is underwater here, we wont make a splash...
   if (( pointcontents(shot_src) == CONTENT_WATER )||( pointcontents(shot_src) == CONTENT_SLIME )||( pointcontents(shot_src) == CONTENT_LAVA))
   {
      //bprint("Hmm, shot started in water...\n");
      return;
   }

   // This may not be needed, but meh, it seems to work... o.o
   old_contents = pointcontents(shot_src);   
   
   // K, trace the line to the end of the shot
   traceline( shot_src, shot_src + dir * shot_length, FALSE, self );
   
   // We in water?
   if ( trace_inwater )
   {
      //bprint("Hit in water!\n");
      
      // Now, we'l check the traceline, till we find the point we enter the water
      while ( steps > 0 )
      {   
         shot_src = shot_src + dir * stepsize;
         
         if ( (pointcontents(shot_src) == CONTENT_WATER) || (pointcontents(shot_src) == CONTENT_SLIME) && ( old_contents != CONTENT_WATER) )
         {
            //bprint("In Water!\n");
            
            // Here, is where you would spawn your splash effect, shot_src is the closest origin to the
            // water brush intersection of the bullets our trace stepper has found.
		   spawn_splash (shot_src);

            // All done here
            return;
         }
         if ( (pointcontents(shot_src) == CONTENT_LAVA) && ( old_contents != CONTENT_WATER) )
         {
            //bprint("In Lava!\n");
            
            // Here, is where you would spawn your splash effect, shot_src is the closest origin to the
            // water brush intersection of the bullets our trace stepper has found.
		   spawn_lavasplash (shot_src);

            // All done here
            return;
         }
         steps = steps - 1;
      }
   }
};



/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/
void(float shotcount, vector dir, vector spread) FireBullets =
{
	local	vector direction;
	local	vector	src;
   //JIM
//   local float bullet;	// removed old bullet holes code, because SMC uses its own
//   bullet = 0;

	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();
	while (shotcount > 0)
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
         //JIM
//       {
			TraceAttack (autocvar_player_shotgun_pellets, direction);	// default 4
//       if ( ( !bullet ) && ( trace_ent == world ) )		// removed old bullet holes code, because SMC uses its own
//          {
//          placebullethole( trace_endpos );
//          bullet = 1;
//          }
//       }

		var float autocvar_watersplash = 1;    	// set cvar 'watersplash' default to 1
		if (autocvar_watersplash == 1)		
			W_BulletSplash (direction);    	// Calls the water splash function	

		shotcount = shotcount - 1;

		////  added GYRO below
		local entity shot;
		local vector shotvector, align;
		align = dir + v_up * 0.25;								// aligns the angle of the force
		traceline (self.origin, self.origin + align*200, FALSE, self);		// sets the max distance of the force
		shotvector = (trace_endpos - self.origin) + (normalize(dir) * 80);	// sets the force vector
		shot = Gyro_Force_Create("gunshot", self.origin);				
		Gyro_Force_ApplyFalloff_ConeLinear(shot, shotvector, 18, 18);
		if (self.weapon == IT_SUPER_SHOTGUN)
			Gyro_Force_ApplyAffector_Directional(shot, shotvector, 88, FALSE);	// if player fires supershotgun (=14 shotcount)
		else
			Gyro_Force_ApplyAffector_Directional(shot, shotvector, 130, FALSE);	// if player fires shotgun (=6 shotcount)
		Gyro_Force_AddProperty_Instant(shot);
		Gyro_Force_Ignore(shot, self); 

	}
	ApplyMultiDamage ();
};


void(float shotcount, vector dir, vector spread) FireBullets_soldier =
{
	local	vector direction;
	local	vector	src;
	
	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();
	while (shotcount > 0)
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
		{
			var float autocvar_soldier_size_influenced_attack = 0; 			// set cvar 'soldier_size_influenced_attack' default to 0
			if (autocvar_soldier_size_influenced_attack == 1)			// if 'soldier_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
				TraceAttack (autocvar_soldier_gun * self.scale, direction);	// default 4
			else
				TraceAttack (autocvar_soldier_gun, direction);			// default 4
		}

	var float autocvar_watersplash = 1;     // set cvar 'watersplash' default to 1
	if (autocvar_watersplash == 1)		
		W_BulletSplash (direction);    	// Calls the water splash function	

		shotcount = shotcount - 1;

	////  added GYRO below
	local entity shot;
	local vector shotvector, align;
	align = dir + v_up * 0.25;								// aligns the angle of the force
	traceline (self.origin, self.origin + align*200, FALSE, self);		// sets the max distance of the force
	shotvector = (trace_endpos - self.origin) + (normalize(dir) * 80);	// sets the force vector
	shot = Gyro_Force_Create("gunshot", self.origin);				
	Gyro_Force_ApplyFalloff_ConeLinear(shot, shotvector, 18, 18);
	if (self.weapon == IT_SUPER_SHOTGUN)
		Gyro_Force_ApplyAffector_Directional(shot, shotvector, 88, FALSE);	// if player fires supershotgun (=14 shotcount)
	else
		Gyro_Force_ApplyAffector_Directional(shot, shotvector, 130, FALSE);	// if player fires shotgun (=6 shotcount)
	Gyro_Force_AddProperty_Instant(shot);
	Gyro_Force_Ignore(shot, self); 

	}
	ApplyMultiDamage ();
};


/*
================
W_FireShotgun
================
*/
void() W_FireShotgun =
{
	local vector dir;

	sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);	

	var float autocvar_muzzleflash = 1;     // set cvar 'muzzleflash' default to 1
	if (autocvar_muzzleflash == 1)		// if 'muzzleflash' doesnt exist in autoexec.cfg, or if 'muzzleflash' is set via autoexec.cfg to '1' 
	{
		if (cvar("chase_active"))
			pointparticles(particleeffectnum("shotgun_muzzleflash"), self.origin + self.view_ofs + v_up * -5.5 + v_right * -2 + v_forward*15, self.velocity*50, 1);
		else
			pointparticles(particleeffectnum("shotgun_muzzleflash"), self.origin + self.view_ofs + v_up * -8 + v_forward*20, self.velocity*50, 1);
	}

	self.punchangle_x = -2;

	///////// pushback SG
	var float autocvar_pushback = 1;     	// set cvar 'pushback' default to 1
	if (autocvar_pushback != 0)	// if 'pushback' is other than '0', pushback is enabled
	{
		var float autocvar_pushbackshot1 = 60;    // set cvar 'pushbackshot1' default to 60
		local vector pushback1, direc;
		direc = aim (self, 100);
		traceline (self.origin, self.origin + direc*autocvar_pushbackshot1, FALSE, self);
		pushback1 = (trace_endpos - self.origin); // + (normalize(direc) * 80);
		self.velocity = self.velocity - pushback1;
	}
	
	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	dir = aim (self, 100000);
 	FireBullets (6, dir, '0.04 0.04 0');
};


/*
================
W_FireSuperShotgun
================
*/
void() W_FireSuperShotgun =
{
	local vector dir;

	if (self.currentammo == 1)
	{
		W_FireShotgun ();
		return;
	}
		
	sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);	

	var float autocvar_muzzleflash = 1;    	// set cvar 'muzzleflash' default to 1
	if (autocvar_muzzleflash == 1)		// if 'muzzleflash' doesnt exist in autoexec.cfg, or if 'muzzleflash' is set via autoexec.cfg to '1' 
	{
		if (cvar("chase_active"))
			pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin + self.view_ofs + v_right * -3.5 + v_forward*17, self.velocity*50, 1);
		else
			pointparticles(particleeffectnum("double_shotgun_muzzleflash"), self.origin + self.view_ofs + v_up * -8 + v_forward*20, self.velocity*50, 1);
	}

	self.punchangle_x = -4;

	///////// pushback SSG
	var float autocvar_pushback = 1;     	// set cvar 'pushback' default to 1
	if (autocvar_pushback != 0)		// if 'pushback' is other than '0', pushback is enabled
	{
		var float autocvar_pushbackshot2 = 75;    // set cvar 'pushbackshot2' default to 75
		local vector pushback1, direc;
		direc = aim (self, 100);
		traceline (self.origin, self.origin + direc*autocvar_pushbackshot2, FALSE, self);
		pushback1 = (trace_endpos - self.origin); // + (normalize(direc) * 80);
		self.velocity = self.velocity - pushback1;
	}
	
	self.currentammo = self.ammo_shells = self.ammo_shells - 2;
	dir = aim (self, 100000);
	FireBullets (14, dir, '0.14 0.08 0');
};


/*
==============================================================================

ROCKETS

==============================================================================
*/

void()	s_explode1	=	[0,		s_explode2] {};
void()	s_explode2	=	[1,		s_explode3] {};
void()	s_explode3	=	[2,		s_explode4] {};
void()	s_explode4	=	[3,		s_explode5] {};
void()	s_explode5	=	[4,		s_explode6] {};
void()	s_explode6	=	[5,		SUB_Remove] {};

void() BecomeExplosion =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
};

void() T_MissileTouch =
{
	local float	damg;
	local vector detonate;		// for seperation of explosion effect

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	local float surfacenum;
	local string tex;
	surfacenum = getsurfacenearpoint(world, self.origin);
	if (surfacenum >= 0)
	{
		tex = getsurfacetexture(world, surfacenum);
		if ((tex == "sky1") || (tex == "sky4") || (tex == "sky10") || (tex == "sky_tele"))
		{
			remove(self);
			return;
		}
	}

	if (other.inflamed == 1)
	{
		other.health = -100;
		other.nextthink = time;
		other.think = other.th_die;
	}
	
	if (autocvar_evil_faces)
	{
		local float surfnum;
		local string s;
		local vector backwards;
		surfnum = getsurfacenearpoint(world, self.origin);
		if (surfnum >= 0)
		{
			s = getsurfacetexture(world, surfnum);
			if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
			{
				backwards = self.origin;
				backwards = backwards - 8*normalize(self.velocity);
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnBlood (backwards, '0 0 0', 17);
				sound (self, CHAN_AUTO, "zombie/z_hit.wav", 1, ATTN_NORM);
				if (facetime < time)
				{
					facetime = time + 2;						// only spawn a face every 2 seconds (not more/earlier)
					local vector face_spawn_pos, face_spawn_vel;
					face_spawn_vel = normalize (trace_plane_normal);	
					face_spawn_vel = face_spawn_vel * 10;
					makevectors(self.angles);
					face_spawn_pos = self.origin - trace_plane_normal * 20;		// face is spawned inside wall and comes out of it...
					spawn_face (face_spawn_pos, face_spawn_vel, 0);
				}
				remove(self); 
				return; 
			}
		}		
	}

	damg = autocvar_player_rocket_impact + random()*20;	// default 100

var float autocvar_explosiondebris = 0;
if ( autocvar_explosiondebris == 0 )
{
	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
		detonate = self.origin;
		detonate = detonate - 8*normalize(self.velocity);
		pointparticles(particleeffectnum("rocket_explosion_nodebris"), detonate, '0 0 0', 1);
	}
	else
	{
		detonate = self.origin;
		detonate = detonate - 8*normalize(self.velocity);
		pointparticles(particleeffectnum("rocket_explosion"), detonate, '0 0 0', 1);
	}
}
else
{
	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
	}
	detonate = self.origin;
	detonate = detonate - 8*normalize(self.velocity);
	pointparticles(particleeffectnum("rocket_explosion"), detonate, '0 0 0', 1);
}	
	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, autocvar_player_rocket_radius, other);	// default 120

	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
/*	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
*/
	BecomeExplosion ();
};



void() T_MissileTouch_chton =
{
	local float	damg;
	local vector detonate;		// for seperation of explosion effect

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	local float surfacenum;
	local string tex;
	surfacenum = getsurfacenearpoint(world, self.origin);
	if (surfacenum >= 0)
	{
		tex = getsurfacetexture(world, surfacenum);
		if ((tex == "sky1") || (tex == "sky4") || (tex == "sky10") || (tex == "sky_tele"))
		{
			remove(self);
			return;
		}
	}

	if (autocvar_evil_faces)
	{
		local float surfnum;
		local string s;
		local vector backwards;
		surfnum = getsurfacenearpoint(world, self.origin);
		if (surfnum >= 0)
		{
			s = getsurfacetexture(world, surfnum);
			if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
			{
				backwards = self.origin;
				backwards = backwards - 8*normalize(self.velocity);
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnBlood (backwards, '0 0 0', 17);
				sound (self, CHAN_AUTO, "zombie/z_hit.wav", 1, ATTN_NORM);
				if (facetime < time)
				{
					facetime = time + 2;						// only spawn a face every 2 seconds (not more/earlier)
					local vector face_spawn_pos, face_spawn_vel;
					face_spawn_vel = normalize (trace_plane_normal);	
					face_spawn_vel = face_spawn_vel * 10;
					makevectors(self.angles);
					face_spawn_pos = self.origin - trace_plane_normal * 20;		// face is spawned inside wall and comes out of it...
					spawn_face (face_spawn_pos, face_spawn_vel, 0);
				}
				remove(self); 
				return; 
			}
		}		
	}

	damg = autocvar_chton_lavaballs + random()*20;	// default 100

var float autocvar_explosiondebris = 0;
if ( autocvar_explosiondebris == 0 )
{
	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
		detonate = self.origin;
		detonate = detonate - 8*normalize(self.velocity);
		pointparticles(particleeffectnum("rocket_explosion_nodebris"), detonate, '0 0 0', 1);
	}
	else
	{
		detonate = self.origin;
		detonate = detonate - 8*normalize(self.velocity);
		pointparticles(particleeffectnum("rocket_explosion"), detonate, '0 0 0', 1);
	}
}
else
{
	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
	}
	detonate = self.origin;
	detonate = detonate - 8*normalize(self.velocity);
	pointparticles(particleeffectnum("rocket_explosion"), detonate, '0 0 0', 1);
}	
	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, 120, other);

	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
/*	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
*/
	BecomeExplosion ();
};



/*
================
W_FireRocket
================
*/
void() W_FireRocket =
{
	local	entity missile, mpuff;

	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;
	
///////// pushback RL
var float autocvar_pushback = 1;     	// set cvar 'pushback' default to 1
	if (autocvar_pushback != 0)		// if 'pushback' is other than '0', pushback is enabled
		{
		var float autocvar_pushbackrocket = 90;    // set cvar 'pushbackrocket' default to 90
		local vector pushback1, direc;
		direc = aim (self, 100);
		traceline (self.origin, self.origin + direc*autocvar_pushbackrocket, FALSE, self);
		pushback1 = (trace_endpos - self.origin); // + (normalize(direc) * 80);
		self.velocity = self.velocity - pushback1;
		}

	missile = spawn ();
missile.cansplash = TRUE;
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";

// set missile speed

	makevectors (self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);

	missile.touch = T_MissileTouch;

// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');
//MED 11/09/96
   newmis = missile;
};

/*
===============================================================================

LIGHTNING

===============================================================================
*/

/*
=================
LightningDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) LightningDamage =
{
	local entity		e1, e2;
	local vector		f, ziel;
	
	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
//JIM
	if (trace_ent.takedamage && !trace_ent.wetsuit_finished )
	{
		var float autocvar_shootablebuttonsandsecrets = 1;     	// set cvar 'shootablebuttonsandsecrets' default to 1
		if (autocvar_shootablebuttonsandsecrets != 0)		// if 'shootablebuttonsandsecrets' is other than '0'
		{
			ziel = trace_endpos + '0 0 2';
			if ((trace_ent.takedamage != DAMAGE_AIM) && (trace_ent.classname != "monster_hell_knight2"))	// prevents shootable buttons, secret walls/meshes to spawn blood
			{
				if (autocvar_shootablebuttonsandsecrets == 1)		// if 'shootablebuttonsandsecrets' is '1', use a new "secret" particle effect, so that the player notice that he just shot a secret wall/button
					pointparticles(particleeffectnum("secret"), ziel, '0 0 0', 1); 
				else 							// if 'shootablebuttonsandsecrets' is '2', use standard particle effect
					pointparticles(particleeffectnum("Lightning_gun_impact"), ziel, '0 0 0', 1); 
				T_Damage (trace_ent, from, from, damage);
				return;
			}
			if ((trace_ent.model == "maps/b_explob.bsp") || (trace_ent.model == "maps/b_exbox2.bsp"))	// prevents exploding boxes to spawn blood
			{
				T_Damage (trace_ent, from, from, damage);
				return;
			}
		}
		if (trace_ent.classname != "ShalrathMissile")		// do not spawn blood on shootable shalrath missile
			particle (trace_endpos, '0 0 100', 225, damage);
		T_Damage (trace_ent, from, from, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}

		////  added GYRO below
		
		local entity lightforce;
		local vector lightvec, dir, align;
		dir = aim (self, 10000);
		align = dir + v_up*0.33;
		traceline (p1, p2 + align*200, FALSE, self);
		lightvec = (trace_endpos - self.origin) + (normalize(dir) * 80);
		lightforce = Gyro_Force_Create("light_hit", self.origin);
		Gyro_Force_ApplyFalloff_ConeLinear(lightforce, lightvec, 20, 20);
		Gyro_Force_ApplyAffector_Directional(lightforce, lightvec, 666, FALSE);
		Gyro_Force_AddProperty_Instant(lightforce);
		Gyro_Force_Ignore(lightforce, self); 	

	}
	else if ((trace_fraction != 1.0)&&(!trace_ent.health))
	{
	 	local float surfacenum;
		local string tex;
		surfacenum = getsurfacenearpoint(world, trace_endpos);
		if (surfacenum >= 0)
		{
			tex = getsurfacetexture(world, surfacenum);
			if ((tex == "sky1") || (tex == "sky4") || (tex == "sky10") || (tex == "sky_tele"))
				return;
			else
			{
				ziel = trace_endpos + '0 0 2';
				pointparticles(particleeffectnum("Lightning_gun_impact"), ziel, '0 0 0', 1);
			}
		}
	}

     	if ((trace_ent.inflamed == 1) && (trace_ent.inflamekillafterdeath == 0))
	{
		trace_ent.inflamekillafterdeath = 1;
		trace_ent.health = -1;
		trace_ent.nextthink = time;
		trace_ent.think = trace_ent.th_die;
		return;
	}

	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
//JIM
	if (trace_ent != e1 && trace_ent.takedamage &&
		!trace_ent.wetsuit_finished )
	{
		particle (trace_endpos, '0 0 100', 225, damage*2);
		T_Damage (trace_ent, from, from, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
//JIM
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage &&
		!trace_ent.wetsuit_finished )
	{
		particle (trace_endpos, '0 0 100', 225, damage*2);
		T_Damage (trace_ent, from, from, damage);
	}
};


void() W_FireLightning =
{
	local	vector		org;
	local	float		cells;

	if (self.ammo_cells < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_cells;
		self.ammo_cells = 0;
      //MED 01/05/97 added discharge flag
      discharged = 1;
		T_RadiusDamage (self, self, 35*cells, world);
      discharged = 0;
		W_SetCurrentAmmo ();
		return;
	}

	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	self.punchangle_x = -2;

///////// pushback LG
var float autocvar_pushback = 1;     	// set cvar 'pushback' default to 1
	if (autocvar_pushback != 0)		// if 'pushback' is other than '0', pushback is enabled
		{
		var float autocvar_pushbacklight = 15;    // set cvar 'pushbacklight' default to 15
		local vector pushback1, direc;
		direc = aim (self, 100);
		traceline (self.origin, self.origin + direc*autocvar_pushbacklight, FALSE, self);
		pushback1 = (trace_endpos - self.origin); // + (normalize(direc) * 80);
		self.velocity = self.velocity - pushback1;
		}


	self.currentammo = self.ammo_cells = self.ammo_cells - 1;

	org = self.origin + '0 0 16';

	traceline (org, org + v_forward*600, TRUE, self);

	if (autocvar_evil_faces)
	{
		local float surfnum;
		local string s;
		surfnum = getsurfacenearpoint(world, trace_endpos);
		if (surfnum >= 0)
		{
			s = getsurfacetexture(world, surfnum);
			if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
			{
				SpawnMeatSpray_eviltexture (trace_endpos, '50 50 50');
				SpawnBlood (trace_endpos, '0 0 0', 2);
				if (facetime < time)
				{
					facetime = time + 2;						// only spawn a face every 2 seconds (not more/earlier)
					local vector face_spawn_pos, face_spawn_vel;
					face_spawn_pos = trace_endpos - trace_plane_normal * 20;	// face is spawned inside wall and comes out of it...
					face_spawn_vel = normalize (trace_plane_normal);	
					face_spawn_vel = face_spawn_vel * 10;
					spawn_face (face_spawn_pos, face_spawn_vel, 1);
				}
			}
		}		
	}
	
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	LightningDamage (self.origin, trace_endpos + v_forward*4, self, autocvar_player_lightninggun);	// default 30
};


//=============================================================================


void() GrenadeExplode =
{
	T_RadiusDamage (self, self.owner, autocvar_player_grenades, world);	// default 120

	var float autocvar_explosiondebris = 0;
	if ( autocvar_explosiondebris == 0 )
	{
		if (other.health)
			pointparticles(particleeffectnum("grenade_explosion_nodebris"), self.origin, '0 0 0', 1);
		else
			pointparticles(particleeffectnum("grenade_explosion"), self.origin, '0 0 0', 1);
	}
	else
		pointparticles(particleeffectnum("grenade_explosion"), self.origin, '0 0 0', 1);
/*
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
*/
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	BecomeExplosion ();
};

void() GrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner

	if (other.inflamed == 1)
	{
		other.health = -100;
		other.nextthink = time;
		other.think = other.th_die;
		GrenadeExplode();
		return;
	}

	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
	}
	
	if (autocvar_evil_faces)
	{
		local float surfnum;
		local string s;
		local vector backwards;
		surfnum = getsurfacenearpoint(world, self.origin);
		if (surfnum >= 0)
		{
			s = getsurfacetexture(world, surfnum);
			if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
			{
				backwards = self.origin;
				backwards = backwards - 8*normalize(self.velocity);
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnBlood (backwards, '0 0 0', 17);
				sound (self, CHAN_AUTO, "zombie/z_hit.wav", 1, ATTN_NORM);
				if (facetime < time)
				{
					facetime = time + 2;						// only spawn a face every 2 seconds (not more/earlier)
					local vector face_spawn_pos, face_spawn_vel;
					face_spawn_vel = normalize (trace_plane_normal);	
					face_spawn_vel = face_spawn_vel * 10;
					makevectors(self.angles);
					face_spawn_pos = self.origin - trace_plane_normal * 20;		// face is spawned inside wall and comes out of it...
					spawn_face (face_spawn_pos, face_spawn_vel, 0);
				}
				remove(self); 
				return; 
			}
		}		
	}

	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

/*
================
W_FireGrenade
================
*/
void() W_FireGrenade =
{
	local	entity missile, mpuff;

	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;
	
///////// pushback GL
var float autocvar_pushback = 1;     	// set cvar 'pushback' default to 1
	if (autocvar_pushback != 0)		// if 'pushback' is other than '0', pushback is enabled
		{
		var float autocvar_pushbackgrenade = 70;    // set cvar 'pushbackgrenade' default to 70
		local vector pushback1, direc;
		direc = aim (self, 100);
		traceline (self.origin, self.origin + direc*autocvar_pushbackgrenade, FALSE, self);
		pushback1 = (trace_endpos - self.origin); // + (normalize(direc) * 80);
		self.velocity = self.velocity - pushback1;
		}

	missile = spawn ();
missile.cansplash = TRUE;
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";

// set missile speed

	makevectors (self.v_angle);

	if (self.v_angle_x)
		missile.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
	}

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);

	missile.touch = GrenadeTouch;

// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = GrenadeExplode;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin);
};


//=============================================================================

void() ProximityExplode =
{
   T_RadiusDamage (self, self.owner, autocvar_player_proximity_bomb, world);	// default 95

var float autocvar_explosiondebris = 0;
if ( autocvar_explosiondebris == 0 )
{
	if (other.health)
		pointparticles(particleeffectnum("grenade_explosion_nodebris"), self.origin, '0 0 0', 1);
	else
		pointparticles(particleeffectnum("grenade_explosion"), self.origin, '0 0 0', 1);
}
else
	pointparticles(particleeffectnum("grenade_explosion"), self.origin, '0 0 0', 1);
/*
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
*/
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);

	BecomeExplosion ();
};

//MED 10/31/96
float NumProximityGrenades;
/*
================
ProximityGrenadeExplode
================
*/
void() ProximityGrenadeExplode =
   {
   self.takedamage = DAMAGE_NO;
   NumProximityGrenades = NumProximityGrenades - 1;
   self.deathtype = "exploding";
   self.nextthink = time + 0.1;
   self.owner = self.lastvictim;
   self.think = ProximityExplode;
   };

/*
================
ProximityGrenadeTouch
================
*/
void() ProximityGrenadeTouch =
   {
   if (other == self)
      return;
      
	if (other.inflamed == 1)
	{
		other.health = -100;
		other.nextthink = time;
		other.think = other.th_die;
		ProximityGrenadeExplode();
		return;
	}

   if (other.classname == self.classname)
      return;
   self.movetype = MOVETYPE_TOSS;
   if (self.state == 1)
      return;
   if (vlen(other.velocity) > 0)
      {
      ProximityGrenadeExplode();
      self.think();
      return;
      }
   if (other.takedamage == DAMAGE_AIM)
      {
      ProximityGrenadeExplode();
      self.think();
      return;
      }
      
      	if (autocvar_evil_faces)
	{
		local float surfnum;
		local string s;
		local vector backwards;
		surfnum = getsurfacenearpoint(world, self.origin);
		if (surfnum >= 0)
		{
			s = getsurfacetexture(world, surfnum);
			if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
			{
				backwards = self.origin;
				backwards = backwards - 8*normalize(self.velocity);
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnBlood (backwards, '0 0 0', 17);
				sound (self, CHAN_AUTO, "zombie/z_hit.wav", 1, ATTN_NORM);
				if (facetime < time)
				{
					facetime = time + 2;						// only spawn a face every 2 seconds (not more/earlier)
					local vector face_spawn_pos, face_spawn_vel;
					face_spawn_vel = normalize (trace_plane_normal);	
					face_spawn_vel = face_spawn_vel * 10;
					makevectors(self.angles);
					face_spawn_pos = self.origin - trace_plane_normal * 20;		// face is spawned inside wall and comes out of it...
					spawn_face (face_spawn_pos, face_spawn_vel, 0);
				}
				remove(self); 
				return; 
			}
		}		
	}
   
 	local float surfacenum;
	local string tex;
	surfacenum = getsurfacenearpoint(world, self.origin);
	if (surfacenum >= 0)
	{
		tex = getsurfacetexture(world, surfacenum);
		if ((tex == "sky1") || (tex == "sky4") || (tex == "sky10") || (tex == "sky_tele"))
		{
			self.movetype = MOVETYPE_BOUNCE;
			return;
		}
	}

   sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM); // bounce sound
   self.movetype = MOVETYPE_NONE;
   setsize (self, '-8 -8 -8', '8 8 8');
   self.state = 1;
   self.spawnmaster = other;
   };

/*
================
ProximityBomb
================
*/
void() ProximityBomb =
   {
   local entity   head;
   local float    blowup;

   if ((time > self.delay) || (NumProximityGrenades > 15) || (vlen(self.spawnmaster.velocity)>0) )
      {
      ProximityGrenadeExplode();
      self.think();
      return;
      }
   self.owner = world;
   self.takedamage = DAMAGE_YES;
   head = findradius(self.origin, 140);
   blowup = 0;

   while (head)
      {
      if ((head != self) && (head.health > 0) && (head.flags & (FL_CLIENT|FL_MONSTER)) && (head.classname!=self.classname))
         blowup = 1;
      if ((head.classname == self.classname) && (head.state==0))
         blowup = 1;
      traceline(self.origin,head.origin,TRUE,self);
      if (trace_fraction != 1.0)
         blowup = 0;
      if (blowup==1)
         {
         sound (self, CHAN_WEAPON, "hipweap/proxwarn.wav", 1, ATTN_NORM);
         ProximityGrenadeExplode();
         self.nextthink = time + 0.5;
         return;
         }
      head = head.chain;
      }
   self.nextthink = time + 0.25;
   };

/*
================
W_FireProximityGrenade
================
*/
void() W_FireProximityGrenade =
   {
   local entity missile, mpuff;

   NumProximityGrenades = NumProximityGrenades + 1;
   self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

   sound (self, CHAN_WEAPON, "hipweap/proxbomb.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;
	
///////// pushback ProximityGrenade
var float autocvar_pushback = 1;     	// set cvar 'pushback' default to 1
if (autocvar_pushback != 0)		// if 'pushback' is other than '0', pushback is enabled
	{
var float autocvar_pushbackprox = 70;    // set cvar 'pushbackprox' default to 70
local vector pushback1, direc;
direc = aim (self, 100);
traceline (self.origin, self.origin + direc*autocvar_pushbackprox, FALSE, self);
pushback1 = (trace_endpos - self.origin); // + (normalize(direc) * 80);
self.velocity = self.velocity - pushback1;
}

   missile = spawn ();
missile.cansplash = TRUE;
   missile.owner = self;
   missile.lastvictim = self;
   missile.movetype = MOVETYPE_TOSS;
	missile.solid = SOLID_BBOX;
   missile.classname = "proximity_grenade";
   missile.takedamage = DAMAGE_NO;
   missile.health = 5;
   missile.state = 0;

// set missile speed

	makevectors (self.v_angle);

	if (self.v_angle_x)
		missile.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
	}

   missile.avelocity = '100 600 100';

	missile.angles = vectoangles(missile.velocity);

   missile.touch = ProximityGrenadeTouch;

// set missile duration
   missile.nextthink = time + 2;
   missile.delay = time + 15 + (10*random());
   missile.think = ProximityBomb;
   missile.th_die = ProximityGrenadeExplode;

   setmodel (missile, "progs/proxbomb.mdl");
   setorigin (missile, self.origin);
   setsize (missile, '-1 -1 -1', '1 1 1');
   };

//=============================================================================

void() spike_touch;
void() superspike_touch;
void() spike_enemy_touch; //ooppee addon, need to make enemy projectiles (knight and scrag projectils use a copy of the id1 code WITHOUT the stuck in walls code)

/*
===============
start OoPpEe
Launch enemy spike! Needs to be different so it DOESNT call "spike_touch" which results in stuck in walls
===============
*/
void(vector org, vector dir) launch_enemy_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);
	
	newmis.touch = spike_enemy_touch; //OoPpEe no more calling the in wall code now :D
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	setorigin (newmis, org);

	newmis.velocity = dir * 1000;
};
//end ooppee
/*
===============
launch_spike

Used for both the player and the ogre
===============
*/
void(vector org, vector dir) launch_spike =
{
	newmis = spawn ();
newmis.cansplash = TRUE;
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);

	newmis.touch = spike_touch;
	if (self.classname == "monster_scourge")
		newmis.classname = "scourge_spike";
	else
		newmis.classname = "spike";
	newmis.think = SUB_Remove;
newmis.traileffectnum = particleeffectnum("spike_bubble_trail");
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, org);

	newmis.velocity = dir * 1000;
};

void() W_FireSuperSpikes =
{
	local vector	dir;
	local entity	old;

	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);

	var float autocvar_muzzleflash = 1;     	// set cvar 'muzzleflash' default to 1
	if (autocvar_muzzleflash == 1)		// if 'muzzleflash' doesnt exist in autoexec.cfg, or if 'muzzleflash' is set via autoexec.cfg to '1' 
	{
		if (cvar("chase_active"))
			pointparticles(particleeffectnum("supernailgun_muzzleflash"), self.origin + self.view_ofs + v_up * -7 + v_right * -1.5 + v_forward * 14, self.velocity*50, 1);
		else
			pointparticles(particleeffectnum("supernailgun_muzzleflash"), self.origin + self.view_ofs + v_up * -8 + v_forward*20, self.velocity*50, 1);
	}

	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 2;
	dir = aim (self, 1000);
	if (cvar("chase_active"))
		launch_spike (self.origin + self.view_ofs + v_up * -8 + v_right * -2, dir);
	else
		launch_spike (self.origin + self.view_ofs + v_up * -8 , dir);
	newmis.touch = superspike_touch;
	setmodel (newmis, "progs/s_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	self.punchangle_x = -2;
	
///////// pushback SNG
var float autocvar_pushback = 1;     	// set cvar 'pushback' default to 1
	if (autocvar_pushback != 0)		// if 'pushback' is other than '0', pushback is enabled
		{
		var float autocvar_pushbacknail2 = 30;    // set cvar 'pushbacknail2' default to 30
		local vector pushback1, direc;
		direc = aim (self, 100);
		traceline (self.origin, self.origin + direc*autocvar_pushbacknail2, FALSE, self);
		pushback1 = (trace_endpos - self.origin); // + (normalize(direc) * 80);
		self.velocity = self.velocity - pushback1;
		}

	
////  added GYRO below
	local entity nail;
	local	vector align, nailvec;

	makevectors(self.v_angle);
	align = dir + v_up*0.27;
	traceline (self.origin, self.origin + align*200, FALSE, self);
	nailvec = (trace_endpos - self.origin) + (normalize(dir) * 80);
	nail = Gyro_Force_Create("nailhit", self.origin);
	Gyro_Force_ApplyFalloff_ConeLinear(nail, nailvec, 16, 16);
	Gyro_Force_ApplyAffector_Directional(nail, nailvec, 400, FALSE);
	Gyro_Force_AddProperty_Instant(nail);
	Gyro_Force_Ignore(nail, self); 

};

void(float ox) W_FireSpikes =
{
	local vector	dir;
	local entity	old;

	makevectors (self.v_angle);

	if (self.ammo_nails >= 2 && self.weapon == IT_SUPER_NAILGUN)
	{
		W_FireSuperSpikes ();
		return;
	}

	if (self.ammo_nails < 1)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	
	var float autocvar_muzzleflash = 1;     	// set cvar 'muzzleflash' default to 1
	if (autocvar_muzzleflash == 1)		// if 'muzzleflash' doesnt exist in autoexec.cfg, or if 'muzzleflash' is set via autoexec.cfg to '1' 
	{
		if (cvar("chase_active"))
		{
			pointparticles(particleeffectnum("nailgun_muzzleflash"), self.origin + self.view_ofs + v_up * -8 + v_right * 2 + v_forward * 13, self.velocity*50, 1);
			pointparticles(particleeffectnum("nailgun_muzzleflash"), self.origin + self.view_ofs + v_up * -8 + v_right * -4.6 + v_forward * 13, self.velocity*50, 1);
		}
		else
		{
			pointparticles(particleeffectnum("nailgun_muzzleflash"), self.origin + self.view_ofs + v_up * -8 + v_right*3.3 + v_forward*20, self.velocity*50, 1);
			pointparticles(particleeffectnum("nailgun_muzzleflash"), self.origin + self.view_ofs + v_up * -8 + v_right*-3.3 + v_forward*20, self.velocity*50, 1);
		}
	}

	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 1;
	dir = aim (self, 1000);
	launch_spike (self.origin + self.view_ofs + v_up * -8 + v_right*ox, dir);

	self.punchangle_x = -2;
	
///////// pushback NG
var float autocvar_pushback = 1;     	// set cvar 'pushback' default to 1
	if (autocvar_pushback != 0)		// if 'pushback' is other than '0', pushback is enabled
		{
		var float autocvar_pushbacknail1 = 20;    // set cvar 'pushbacknail1' default to 20
		local vector pushback1, direc;
		direc = aim (self, 100);
		traceline (self.origin, self.origin + direc*autocvar_pushbacknail1, FALSE, self);
		pushback1 = (trace_endpos - self.origin); // + (normalize(direc) * 80);
		self.velocity = self.velocity - pushback1;
		}


////  added GYRO below
	local entity nail;
	local	vector align, nailvec;

	makevectors(self.v_angle);
	align = dir + v_up*0.27;
	traceline (self.origin, self.origin + align*200, FALSE, self);
	nailvec = (trace_endpos - self.origin) + (normalize(dir) * 80);
	nail = Gyro_Force_Create("nailhit", self.origin);
	Gyro_Force_ApplyFalloff_ConeLinear(nail, nailvec, 16, 16);
	Gyro_Force_ApplyAffector_Directional(nail, nailvec, 300, FALSE);
	Gyro_Force_AddProperty_Instant(nail);
	Gyro_Force_Ignore(nail, self); 
};



.float hit_z;
void() spike_stuck_think = 
{ 
   if (self.aflag <= time) 
   { 
      remove (self); 
      return; 
   } 

   setorigin(self, self.pos1 + self.owner.origin - self.pos2); 

   self.nextthink = time; 
}; 

//OoPpEe - now to copy over the old id1 code that DOESNT stick in walls. A simple copy and paste
void() spike_enemy_touch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (9);	// leave this alone, as blood amount would look wrong
		if (self.classname == "wizspike")
		{
			var float autocvar_wizard_size_influenced_attack = 0; 	  	// set cvar 'wizard_size_influenced_attack' default to 0
			if (autocvar_wizard_size_influenced_attack == 1)		// if 'wizard_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
				T_Damage (other, self, self.owner, autocvar_wizard_missile * self.owner.scale);	// default 9
			else
				T_Damage (other, self, self.owner, autocvar_wizard_missile);			// default 9
			if (autocvar_wizard_projectiles_poison_chance)
			{
				local float zufall;
				zufall = random() * 100;
				if (zufall <= autocvar_wizard_projectiles_poison_chance)	// checks if wizards projectile impact poisons the player
				{
					other.poisoned = 1;
					other.poisontime = time + autocvar_wizard_projectiles_and_slime_poison_time;	  	// max total time of poison hurting the player
					other.poisonpause = time + autocvar_wizard_projectiles_and_slime_poison_frequence;  	// to avoid more damage from projectile
				}
			}
		}
		else if (self.classname == "knightspike")
		{
			var float autocvar_hknight_size_influenced_attack = 0; 	  	// set cvar 'hknight_size_influenced_attack' default to 0
			if (autocvar_hknight_size_influenced_attack == 1)		// if 'hknight_size_influenced_attack' is set via autoexec.cfg to '1' raise monster´s attack values according to its size 
				T_Damage (other, self, self.owner, autocvar_hellknight_missile * self.owner.scale);  // default 9
			else
				T_Damage (other, self, self.owner, autocvar_hellknight_missile);		// default 9
			if (autocvar_hellknight_projectiles_inflame_chance)
			{
				local float zufal;
				zufal = random() * 100;
				if (zufal <= autocvar_hellknight_projectiles_inflame_chance)	// checks if hellknights projectile impact inflame the player
				{
					other.inflamed = 1;
					other.inflametime = time + autocvar_fire_projectiles_and_lava_inflame_time;		// max total time of fire hurting the player
					other.inflamepause = time + autocvar_fire_projectiles_and_lava_inflame_frequence;  	// to avoid more damage from projectile
					if ((autocvar_fire_projectiles_and_lava_inflame_particles) && (self.inflamed ==0)) 	// play sounds only once
					{
						sound (other, CHAN_AUTO, "player/inflame.wav", 1, ATTN_NORM); 		// play ignition sound
						sound (other, 120, "zombie/corpse_fire.wav", 1, ATTN_NORM); 	       	// play fire loop sound
					}
				}
			}
		}
		else	// warlord
		{
			T_Damage (other, self, self.owner, autocvar_warlord_missile);				// default 9
			if (autocvar_warlord_projectiles_inflame_chance)
			{
				local float zufa;
				zufa = random() * 100;
				if (zufa <= autocvar_warlord_projectiles_inflame_chance)	// checks if warlords projectile impact inflame the player
				{
					other.inflamed = 1;
					other.inflametime = time + autocvar_fire_projectiles_and_lava_inflame_time;		// max total time of fire hurting the player
					other.inflamepause = time + autocvar_fire_projectiles_and_lava_inflame_frequence;  	// to avoid more damage from projectile
					if ((autocvar_fire_projectiles_and_lava_inflame_particles) && (self.inflamed ==0)) 	// play sounds only once
					{
						sound (other, CHAN_AUTO, "player/inflame.wav", 1, ATTN_NORM); 		// play ignition sound
						sound (other, 120, "zombie/corpse_fire.wav", 1, ATTN_NORM); 	       	// play fire loop sound
					}
				}
			}
		}
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		
		if (self.classname == "wizspike")
			WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
		else if ((self.classname == "knightspike")||(self.classname == "knight2spike"))
			WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
		else
			WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);

};
//OoPpEe end

void() spike_touch = 
{ 
        if (other == self.owner) 
                return; 

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

        if (pointcontents(self.origin) == CONTENT_SKY) 
        { 
                remove(self); 
                return; 
        } 

 	local float surfacenum;
	local string tex;
	surfacenum = getsurfacenearpoint(world, self.origin);
	if (surfacenum >= 0)
	{
		tex = getsurfacetexture(world, surfacenum);
		if ((tex == "sky1") || (tex == "sky4") || (tex == "sky10") || (tex == "sky_tele"))
		{
			remove(self);
			return;
		}
	}

     	if ((self.classname != "scourge_spike") && (other.inflamed == 1) && (other.inflamekillafterdeath == 0))
	{
		other.inflamekillafterdeath = 1;
		other.health = -1;
		other.nextthink = time;
		other.think = other.th_die;
	}

// hit something that bleeds 
        if (other.takedamage) 
        { 
		var float autocvar_shootablebuttonsandsecrets = 1;     	// set cvar 'shootablebuttonsandsecrets' default to 1
		if (autocvar_shootablebuttonsandsecrets != 0)		// if 'shootablebuttonsandsecrets' is other than '0'
		{
			if ((trace_ent.takedamage != DAMAGE_AIM) && (trace_ent.classname != "monster_hell_knight2"))		// prevents shootable buttons, secret walls/meshes to spawn blood
			{
				if (autocvar_shootablebuttonsandsecrets == 1)		// if 'shootablebuttonsandsecrets' is '1', use a new "secret" particle effect, so that the player notice that he just shot a secret wall/button
					pointparticles(particleeffectnum("secret"), self.origin, '0 0 0', 1); 
				else 							// if 'shootablebuttonsandsecrets' is '2', use standard particle effect
					pointparticles(particleeffectnum("TE_SPIKE"), self.origin, '0 0 0', 1); 
				if (self.classname == "scourge_spike")
					T_Damage (other, self, self.owner, autocvar_scourge_nails);	// default 9
				else	
					T_Damage (other, self, self.owner, autocvar_player_nailgun);	// default 9
				remove(self);   //add this so they don't float... 
				return;
			}
			if ((trace_ent.model == "maps/b_explob.bsp") || (trace_ent.model == "maps/b_exbox2.bsp"))	// prevents exploding boxes to spawn blood
			{
				if (self.classname == "scourge_spike")
					T_Damage (other, self, self.owner, autocvar_scourge_nails);	// default 9
				else	
					T_Damage (other, self, self.owner, autocvar_player_nailgun);	// default 9
				remove(self);   //add this so they don't float... 
				return;
			}
		}

		if (other.classname == "monster_spider")
			{
			local float resist;
			resist = autocvar_spider_attack_resistance * 0.01;
			if (random () > resist)		// decides if spider will resist this attack
				{
        		        spawn_touchblood (9); 
				if (self.classname == "scourge_spike")
					T_Damage (other, self, self.owner, autocvar_scourge_nails);	// default 9
				else	
					T_Damage (other, self, self.owner, autocvar_player_nailgun);	// default 9
				}
			else
				return;
			}
		else
			{
        	        spawn_touchblood (9); 
			if (self.classname == "scourge_spike")
				T_Damage (other, self, self.owner, autocvar_scourge_nails);	// default 9
			else	
				T_Damage (other, self, self.owner, autocvar_player_nailgun);	// default 9
			}

		var float autocvar_fleshsplat = 1;     	// set cvar 'fleshsplat' default to 1
		if (autocvar_fleshsplat == 1)		
		{
			self.angles_x = self.angles_x*-1; //account for error in makevectors with non-player entities
			makevectors(self.angles); //find direction nail is facing

			if (other.classname == "monster_wizard")
			{        
				ThrowBloodSplat(v_forward, self.origin, other, 1, 1); 
			}
			else if (other.classname == "monster_army")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
			}
			else if (other.classname == "monster_ogre")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
			}
			else if (other.classname == "monster_hell_knight")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1); 
				pointparticles(particleeffectnum("sparks"), self.origin, '0 0 0', 1); 
			}
			else if (other.classname == "monster_hell_knight2")
			{
				pointparticles(particleeffectnum("sparks"), self.origin, '0 0 0', 1); 
				if (other.dodge_finished < time)		// do not spawn blood when monster is in dodge mode (in combat.qc it will not get hurt in this time)
				{
					ThrowBloodSplat(v_forward, self.origin, other, 2, 1); 
				}
			}
			else if (other.classname == "monster_knight")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
				pointparticles(particleeffectnum("sparks"), self.origin, '0 0 0', 1); 
			}
			else if (other.classname == "monster_demon1")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 3, 1);
			}
			else if (other.classname == "monster_dog")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1); 
			}
			else if (other.classname == "monster_shalrath")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 4, 1); 
			}
			else if (other.classname == "monster_tarbaby")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 5, 1); 
			}
			else if (other.classname == "monster_shambler")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
			}
			else 
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
			}
		}
                
                remove(self);   //add this so they don't float... 
                return;         //add this to avoid errors 
        } 

        else if (other.solid != SOLID_BSP) 
        { 
                remove(self); 
                return; 
        } 
	
	if (autocvar_evil_faces)
	{
		local float surfnum;
		local string s;
		local vector backwards;
		surfnum = getsurfacenearpoint(world, self.origin);
		if (surfnum >= 0)
		{
			s = getsurfacetexture(world, surfnum);
			if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
			{
				backwards = self.origin;
				backwards = backwards - 8*normalize(self.velocity);
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnBlood (backwards, '0 0 0', 5);
				if (facetime < time)
				{
					facetime = time + 2;						// only spawn a face every 2 seconds (not more/earlier)
					local vector face_spawn_pos, face_spawn_vel;
					face_spawn_vel = normalize (trace_plane_normal);	
					face_spawn_vel = face_spawn_vel * 10;
					face_spawn_pos = self.origin - trace_plane_normal * 20;		// face is spawned inside wall and comes out of it...
					spawn_face (face_spawn_pos, face_spawn_vel, 0);
				}
				remove(self); 
				return; 
			}
		}		
	}

        WriteByte (MSG_BROADCAST, SVC_TEMPENTITY); 
                
        if (self.classname == "wizspike") 
                WriteByte (MSG_BROADCAST, TE_WIZSPIKE); 
        else if (self.classname == "knightspike") 
                WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE); 
        else 
                WriteByte (MSG_BROADCAST, TE_SPIKE); 
        WriteCoord (MSG_BROADCAST, self.origin_x); 
        WriteCoord (MSG_BROADCAST, self.origin_y); 
        WriteCoord (MSG_BROADCAST, self.origin_z); 

        self.solid = SOLID_NOT; 
        self.movetype = MOVETYPE_NONE; 

        setorigin (self, self.origin - normalize(self.velocity) * 3); 
        self.velocity = '0 0 0';         //add this, it makes the nail stop 

	if (other.solid == SOLID_BSP && other != world) 
	{ 
	        self.owner = other; 
	        self.pos1 = self.origin; 
	        self.pos2 = other.origin; 
	        self.aflag = time + 10; 
	        self.think = spike_stuck_think; 
	        self.nextthink = time; 
	} 
	else 
	{ 
	        self.nextthink = time + autocvar_spikelifetime;     	//add this, to prevent packet overflows 
	        self.think = SUB_Remove;        			//add this for same reason as above 
	} 
};

void() superspike_touch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

        if (pointcontents(self.origin) == CONTENT_SKY) 
        { 
                remove(self); 
                return; 
        } 

 	local float surfacenum;
	local string tex;
	surfacenum = getsurfacenearpoint(world, self.origin);
	if (surfacenum >= 0)
	{
		tex = getsurfacetexture(world, surfacenum);
		if ((tex == "sky1") || (tex == "sky4") || (tex == "sky10") || (tex == "sky_tele"))
		{
			remove(self);
			return;
		}
	}

     	if ((other.inflamed == 1) && (other.inflamekillafterdeath == 0))
	{
		other.inflamekillafterdeath = 1;
		other.health = -1;
		other.nextthink = time;
		other.think = other.th_die;
	}

// hit something that bleeds 
        if (other.takedamage) 
        { 
		var float autocvar_shootablebuttonsandsecrets = 1;     	// set cvar 'shootablebuttonsandsecrets' default to 1
		if (autocvar_shootablebuttonsandsecrets != 0)		// if 'shootablebuttonsandsecrets' is other than '0'
		{
			if ((trace_ent.takedamage != DAMAGE_AIM) && (trace_ent.classname != "monster_hell_knight2"))		// prevents shootable buttons, secret walls/meshes to spawn blood
			{
				if (autocvar_shootablebuttonsandsecrets == 1)		// if 'shootablebuttonsandsecrets' is '1', use a new "secret" particle effect, so that the player notice that he just shot a secret wall/button
					pointparticles(particleeffectnum("secret"), self.origin, '0 0 0', 1); 
				else 							// if 'shootablebuttonsandsecrets' is '2', use standard particle effect
					pointparticles(particleeffectnum("TE_SUPERSPIKE"), self.origin, '0 0 0', 1); 
				T_Damage (other, self, self.owner, autocvar_player_supernailgun);	// default 18
				remove(self);   //add this so they don't float... 
				return;
			}
			if ((trace_ent.model == "maps/b_explob.bsp") || (trace_ent.model == "maps/b_exbox2.bsp"))	// prevents exploding boxes to spawn blood
			{
				T_Damage (other, self, self.owner, autocvar_player_supernailgun);	// default 18
				remove(self);   //add this so they don't float... 
				return;
			}
		}
		
		if (other.classname == "monster_spider")
			{
			local float resist;
			resist = autocvar_spider_attack_resistance * 0.01;
			if (random () > resist)		// decides if spider will resist this attack
				{
           		    	spawn_touchblood (18); 
				T_Damage (other, self, self.owner, autocvar_player_supernailgun);	// default 18
				}
			else
				return;
			}
		else
			{
           	   	spawn_touchblood (18); 
			T_Damage (other, self, self.owner, autocvar_player_supernailgun);	// default 18
			}

		var float autocvar_fleshsplat = 1;     	// set cvar 'fleshsplat' default to 1
		if (autocvar_fleshsplat == 1)		
		{
		    self.angles_x = self.angles_x*-1; //account for error in makevectors with non-player entities
		    makevectors(self.angles); //find direction nail is facing

			if (other.classname == "monster_wizard")
			{        
				ThrowBloodSplat(v_forward, self.origin, other, 1, 1); 
			}
			else if (other.classname == "monster_army")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
			}
			else if (other.classname == "monster_ogre")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
			}
			else if (other.classname == "monster_hell_knight")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1); 
				pointparticles(particleeffectnum("sparks"), self.origin, '0 0 0', 1); 
			}
			else if (other.classname == "monster_hell_knight2")
			{
				pointparticles(particleeffectnum("sparks"), self.origin, '0 0 0', 1); 
				if (other.dodge_finished < time)		// do not spawn blood when monster is in dodge mode (in combat.qc it will not get hurt in this time)
				{
					ThrowBloodSplat(v_forward, self.origin, other, 2, 1); 
				}
			}
			else if (other.classname == "monster_knight")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
				pointparticles(particleeffectnum("sparks"), self.origin, '0 0 0', 1); 
			}
			else if (other.classname == "monster_demon1")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 3, 1);
			}
			else if (other.classname == "monster_dog")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1); 
			}
			else if (other.classname == "monster_shalrath")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 4, 1); 
			}
			else if (other.classname == "monster_tarbaby")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 5, 1); 
			}
			else if (other.classname == "monster_shambler")
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
			}
			else 
			{
				ThrowBloodSplat(v_forward, self.origin, other, 2, 1);
			}
		}

                remove(self);   //add this so they don't float... 
                return;         //add this to avoid errors 
        } 

        else if (other.solid != SOLID_BSP) 
        { 
                remove(self); 
                return; 
        }

	if (autocvar_evil_faces)
	{
		local float surfnum;
		local string s;
		local vector backwards;
		surfnum = getsurfacenearpoint(world, self.origin);
		if (surfnum >= 0)
		{
			s = getsurfacetexture(world, surfnum);
			if ((s == "altarb_1") || (s == "altarb_2") || (s == "dem4_1") || (s == "dem4_4") || (s == "dem5_3") || (s == "demc4_4"))  // met5_3, metalt1_2, metalt1_7 and muh_bad are jesus faces
			{
				backwards = self.origin;
				backwards = backwards - 8*normalize(self.velocity);
				SpawnMeatSpray_eviltexture (backwards, '50 50 50');
				SpawnBlood (backwards, '0 0 0', 5);
				if (facetime < time)
				{
					facetime = time + 2;						// only spawn a face every 2 seconds (not more/earlier)
					local vector face_spawn_pos, face_spawn_vel;
					face_spawn_vel = normalize (trace_plane_normal);	
					face_spawn_vel = face_spawn_vel * 10;
					face_spawn_pos = self.origin - trace_plane_normal * 20;		// face is spawned inside wall and comes out of it...
					spawn_face (face_spawn_pos, face_spawn_vel, 0);
				}
				remove(self); 
				return; 
			}
		}		
	}
	
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
		
        self.solid = SOLID_NOT; 
        self.movetype = MOVETYPE_NONE; 

        setorigin (self, self.origin - normalize(self.velocity) * 3); 
        self.velocity = '0 0 0';         //add this, it makes the nail stop 

      if (other.solid == SOLID_BSP && other != world) 
      { 
         self.owner = other; 
         self.pos1 = self.origin; 
         self.pos2 = other.origin; 
         self.aflag = time + 10; 
         self.think = spike_stuck_think; 
         self.nextthink = time; 
      } 
      else 
      { 
         self.nextthink = time + autocvar_spikelifetime;    	//add this, to prevent packet overflows 
         self.think = SUB_Remove;        			//add this for same reason as above 
      } 
};


/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/

//MED 10/18/96 added HIPWEAPONS
void() W_SetCurrentAmmo =
{
	player_run ();		// get out of any weapon firing states

	self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) );
	
	var float autocvar_weaponandplayertransparency = 100;	// set cvar 'weaponandplayertransparency' default to 100 (= 100% = fully opaque).  Set the percentage how much transparent the view_weapons / player shall be (0= fully invisible). Choose any value you want between 0 and 100
	self.alpha = autocvar_weaponandplayertransparency * 0.01;

	if (self.weapon == IT_AXE)
	{
		self.currentammo = 0;
		if (autocvar_zombieaxeanimation == 1)		// Axe is animated when aiming at new zombies
			self.weaponmodel = "progs/v_axe_zombie00.mdl";
		else
			self.weaponmodel = "progs/v_axe.mdl";
		self.weaponframe = 0;
		axeequipped = 1;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
		axeequipped = 0;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
		axeequipped = 0;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
		axeequipped = 0;
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
		axeequipped = 0;
	}
//MED
   else if (self.weapon == IT_LASER_CANNON)
	{
		self.currentammo = self.ammo_cells;
		self.weaponmodel = "progs/v_laserg.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
		axeequipped = 0;
	}
   else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
		axeequipped = 0;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
		axeequipped = 0;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		self.currentammo = self.ammo_cells;
		self.weaponmodel = "progs/v_light.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
//MED
   else if (self.weapon == IT_MJOLNIR)
	{
      self.currentammo = self.ammo_cells;
      self.weaponmodel = "progs/v_hammer.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
		axeequipped = 0;
	}
//MED
   else if (self.weapon == IT_PROXIMITY_GUN)
	{
      self.currentammo = self.ammo_rockets;
      self.weaponmodel = "progs/v_prox.mdl";
		self.weaponframe = 0;
      self.items = self.items | IT_ROCKETS;
		axeequipped = 0;
	}
   else
	{
		self.currentammo = 0;
		self.weaponmodel = "";
		self.weaponframe = 0;
		axeequipped = 0;
	}
};

float() W_BestWeapon =
{
	local	float	it;

	it = self.items;

   if (self.waterlevel <= 1 && self.ammo_cells >= 1 && (it & IT_LIGHTNING) )
      return IT_LIGHTNING;
//MED
   else if(self.ammo_cells >= 1 && (it & IT_LASER_CANNON) )
      return IT_LASER_CANNON;
   else if(self.ammo_nails >= 2 && (it & IT_SUPER_NAILGUN) )
		return IT_SUPER_NAILGUN;
	else if(self.ammo_shells >= 2 && (it & IT_SUPER_SHOTGUN) )
		return IT_SUPER_SHOTGUN;
	else if(self.ammo_nails >= 1 && (it & IT_NAILGUN) )
		return IT_NAILGUN;
	else if(self.ammo_shells >= 1 && (it & IT_SHOTGUN) )
		return IT_SHOTGUN;
//MED
   else if( it & IT_MJOLNIR )
      return IT_MJOLNIR;

/*
	if(self.ammo_rockets >= 1 && (it & IT_ROCKET_LAUNCHER) )
		return IT_ROCKET_LAUNCHER;
	else if(self.ammo_rockets >= 1 && (it & IT_GRENADE_LAUNCHER) )
		return IT_GRENADE_LAUNCHER;

*/

	return IT_AXE;
};

float() W_CheckNoAmmo =
{
	if (self.currentammo > 0)
		return TRUE;

	if (self.weapon == IT_AXE)
		return TRUE;

//MED
   if (self.weapon == IT_MJOLNIR)
      {
      return TRUE;
      }

   self.weapon = W_BestWeapon ();

	W_SetCurrentAmmo ();

// drop the weapon down
	return FALSE;
};


void() shellcasing_touch =
{
	if (other.solid == SOLID_BSP)		// noting can touch it, only the map brushes
		{
		self.velocity = self.velocity * 0.7;	// make it less bouncing
		if (autocvar_casingdropsound)
			{
			local float zufall;
			zufall = random();
			if (zufall <= 0.4)
				sound (self, CHAN_WEAPON, "weapons/casings1.wav", autocvar_casingdropsound, ATTN_NORM);
			else if (zufall >= 0.6)
				sound (self, CHAN_WEAPON, "weapons/casings2.wav", autocvar_casingdropsound, ATTN_NORM);
			else 
				sound (self, CHAN_WEAPON, "weapons/casings3.wav", autocvar_casingdropsound, ATTN_NORM);
			}
		self.touch = SUB_Null;
		}
};

void() gibsfade_noblood;
void() casing_placement =		// place it on ground, so that it looks a little bit random, but does not sink into floor
{
	if (self.flags & FL_ONGROUND)
		{
		self.angles_x = 0 + crandom() * 30;		// makes it look random but still keeps it flat
		if (autocvar_casingusegyro == 1)
			MonsterPhysics (self, autocvar_casingmass);
		self.nextthink = time + autocvar_casinglifetime;
		self.think = gibsfade_noblood;			// casings will fade away
		return;
		}
	self.nextthink = time + 0.1;
};

void(float checkgrunt) casing =
{
	local entity shellcasing;
	local vector ejectpos;
	local float correction;

	shellcasing = spawn();
	correction = autocvar_casingejectpos - 8;	// makes the z-position adjustable via cvar  (-8 is default)
	if (checkgrunt == 0)				// player did the shot
		{
		ejectpos = self.origin + self.view_ofs + v_forward * 10 + v_right * 2 + v_up * correction;	
		shellcasing.angles = self.v_angle;
		shellcasing.angles_x = shellcasing.angles_x * -1;	// old Quake bug...
		}
	else						// grunt did the shot
		{
		makevectors (self.angles);	
		ejectpos = self.origin + v_up*13 + v_right*7 + v_forward*8;
		shellcasing.angles = self.angles;
		}
	setorigin (shellcasing, ejectpos);
	setmodel (shellcasing, "progs/casing.mdl");
	shellcasing.scale = 1;	
	setsize (shellcasing, '0 0 0', '0 0 0');
	shellcasing.alpha = 1;
	shellcasing.movetype = MOVETYPE_BOUNCE;
	shellcasing.solid = SOLID_TRIGGER;
	shellcasing.touch = shellcasing_touch;
	shellcasing.takedamage = DAMAGE_NO;
	shellcasing.velocity = self.velocity * 0.25 + v_right * 77 + v_up * 33 + randomvec() * 22;
	shellcasing.avelocity = '0 222 0' + randomvec() * 44;
	shellcasing.nextthink = time;
	shellcasing.think = casing_placement;
	shellcasing.cansplash = TRUE;		// Yes, its fun  ;)
};


/*
============
W_Attack

An attack impulse can be triggered now
============
*/
void()	player_axe1;
void()	player_axeb1;
void()	player_axec1;
void()	player_axed1;
void()	player_shot1;
void()	player_nail1;
void()	player_light1;
void()	player_rocket1;
//MED
void()   player_laser1;
void()   player_hammer1;
void()   player_mjolnir1;


void() W_Attack =
{
	local	float	r;

	if (!W_CheckNoAmmo ())
		return;

	makevectors	(self.v_angle);			// calculate forward angle for velocity
	self.show_hostile = time + 1;	// wake monsters up

	if (self.weapon == IT_AXE)
	{
		sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
		r = random();
		if (r < 0.25)
			player_axe1 ();
		else if (r<0.5)
			player_axeb1 ();
		else if (r<0.75)
			player_axec1 ();
		else
			player_axed1 ();
		W_FireAxe2();
		self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		player_shot1 ();
		W_FireShotgun ();
		self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		player_shot1 ();
		W_FireSuperShotgun ();
		self.attack_finished = time + 0.7;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		player_rocket1();
		W_FireGrenade();
		self.attack_finished = time + 0.6;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		player_rocket1();
		W_FireRocket();
		self.attack_finished = time + 0.8;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		player_light1();
		self.attack_finished = time + 0.1;
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
	}
//MED
   else if (self.weapon == IT_LASER_CANNON)
   {
      player_laser1();
   }
//MED
   else if (self.weapon == IT_MJOLNIR)
   {
      if (self.ammo_cells < 30)
         player_hammer1();
      else
         player_mjolnir1();
      HIP_FireMjolnir2();
      self.attack_finished = time + 0.8;
   }
//MED
   else if (self.weapon == IT_PROXIMITY_GUN)
   {
      player_rocket1();
      W_FireProximityGrenade();
      self.attack_finished = time + 0.6;
   }
};

/*
============
W_ChangeWeapon

============
*/
//MED 10/18/96 added hipweapons
void() W_ChangeWeapon =
{
	local	float	it, am, fl;
   local float oldimpulse;

	it = self.items;
	am = 0;

//MED
	if (self.impulse == 1)
	{
      fl = IT_AXE;
   }
	else if (self.impulse == 2)
	{
		fl = IT_SHOTGUN;
		if (self.ammo_shells < 1)
			am = 1;
	}
	else if (self.impulse == 3)
	{
		fl = IT_SUPER_SHOTGUN;
		if (self.ammo_shells < 2)
			am = 1;
	}
	else if (self.impulse == 4)
	{
		fl = IT_NAILGUN;
		if (self.ammo_nails < 1)
			am = 1;
	}
//MED
	else if (self.impulse == 5)
	{
      fl = IT_SUPER_NAILGUN;
      if (self.ammo_nails < 2)
         am = 1;

	}
//MED
	else if (self.impulse == 6)
	{
      if (self.weapon == IT_GRENADE_LAUNCHER)
         {
         fl = IT_PROXIMITY_GUN;
         }
      else
         {
         fl = IT_GRENADE_LAUNCHER;
         }
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 7)
	{
		fl = IT_ROCKET_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
//MED
	else if (self.impulse == 8)
	{
      fl = IT_LIGHTNING;
      if (self.ammo_cells < 1)
         am = 1;
   }
   else if (self.impulse == 225)
	{
      fl = IT_LASER_CANNON;
      if (self.ammo_cells < 1)
         am = 1;
   }
   else if (self.impulse == 226)
	{
      fl = IT_MJOLNIR;
   }

//MED
   oldimpulse = self.impulse;
	self.impulse = 0;

	if (!(self.items & fl))
      {
//MED
      if (fl == IT_GRENADE_LAUNCHER)
         {
         fl = IT_PROXIMITY_GUN;
         if (!(self.items & fl))
            {
            sprint (self, "no weapon.\n");
            return;
            }
         if (self.ammo_rockets < 1)
            am = 1;
         else
            am = 0;
         }
      else
         {
         sprint (self, "no weapon.\n");
         return;
         }
      }

	if (am)
	{	// don't have the ammo
		sprint (self, "not enough ammo.\n");
		return;
	}

//
// set weapon, set ammo
//
   self.weapon = fl;
	W_SetCurrentAmmo ();
	
// plays weapon-change-sound when player uses keyboard keys to change weapons
	if (autocvar_changeweaponsounds)
	{
	if (fl == IT_AXE)
		sound (self, CHAN_VOICE, "weapons/weapon1.wav", autocvar_changeweaponsounds, ATTN_NORM);
	else if (fl == IT_SHOTGUN)
		sound (self, CHAN_VOICE, "weapons/weapon2.wav", autocvar_changeweaponsounds, ATTN_NORM);
	else if (fl == IT_SUPER_SHOTGUN)
		sound (self, CHAN_VOICE, "weapons/weapon3.wav", autocvar_changeweaponsounds, ATTN_NORM);
	else if (fl == IT_NAILGUN)
		sound (self, CHAN_VOICE, "weapons/weapon4.wav", autocvar_changeweaponsounds, ATTN_NORM);
	else if (fl == IT_SUPER_NAILGUN)
		sound (self, CHAN_VOICE, "weapons/weapon5.wav", autocvar_changeweaponsounds, ATTN_NORM);
	else if (fl == IT_GRENADE_LAUNCHER)
		sound (self, CHAN_VOICE, "weapons/weapon6.wav", autocvar_changeweaponsounds, ATTN_NORM);
	else if (fl == IT_PROXIMITY_GUN)
		sound (self, CHAN_VOICE, "weapons/weapon6_prox.wav", autocvar_changeweaponsounds, ATTN_NORM);
	else if (fl == IT_ROCKET_LAUNCHER)
		sound (self, CHAN_VOICE, "weapons/weapon7.wav", autocvar_changeweaponsounds, ATTN_NORM);
	else if (fl == IT_LIGHTNING)
		sound (self, CHAN_VOICE, "weapons/weapon8.wav", autocvar_changeweaponsounds, ATTN_NORM);
	else if (fl == IT_LASER_CANNON)
		sound (self, CHAN_VOICE, "weapons/weapon9_laser.wav", autocvar_changeweaponsounds, ATTN_NORM);
	else if (fl == IT_MJOLNIR)
		sound (self, CHAN_VOICE, "weapons/weapon10_mjolnir.wav", autocvar_changeweaponsounds, ATTN_NORM);
	}
};

/*
============
CheatCommand
============
*/
void() CheatCommand =
{
	if (deathmatch || coop)
		return;

	self.ammo_rockets = autocvar_rockets_max_capacity;	// default 100
	self.ammo_nails = autocvar_nails_max_capacity;		// default 200
	self.ammo_shells = autocvar_shells_max_capacity;	// default 100
	self.items = self.items | 
		IT_AXE |
		IT_SHOTGUN |
		IT_SUPER_SHOTGUN |
		IT_NAILGUN |
		IT_SUPER_NAILGUN |
		IT_GRENADE_LAUNCHER |
		IT_ROCKET_LAUNCHER |
		IT_KEY1 | IT_KEY2;

	self.ammo_cells = autocvar_cells_max_capacity;		// default 100
	self.items = self.items | IT_LIGHTNING;
//MED
   self.items = self.items | IT_LASER_CANNON;
   self.items = self.items | IT_MJOLNIR;
   self.items = self.items | IT_PROXIMITY_GUN;

	self.weapon = IT_ROCKET_LAUNCHER;
	self.impulse = 0;
	W_SetCurrentAmmo ();
};

/*
============
CycleWeaponCommand

Go to the next weapon with ammo
============
*/
void() CycleWeaponCommand =
{
	local	float	it, am;

	it = self.items;
	self.impulse = 0;

	while (1)
	{
		am = 0;

//MED
      if (self.weapon == IT_MJOLNIR)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
         self.weapon = IT_SHOTGUN;
         if (self.ammo_shells < 1)
				am = 1;
      }
      else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
         self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
//MED
      else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
         self.weapon = IT_PROXIMITY_GUN;
			if (self.ammo_rockets < 1)
				am = 1;
		}
//MED
      else if (self.weapon == IT_PROXIMITY_GUN)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
      else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}
      else if (self.weapon == IT_LIGHTNING)
		{
         self.weapon = IT_LASER_CANNON;
         if (self.ammo_cells < 1)
				am = 1;
		}
      else if (self.weapon == IT_LASER_CANNON)
		{
         self.weapon = IT_MJOLNIR;
		}

		if ( (self.items & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			// plays weapon-change-sound when player uses mouse-wheel to change weapons
			if (autocvar_changeweaponsounds)
			{
			if (self.weapon == IT_AXE)
				sound (self, CHAN_VOICE, "weapons/weapon1.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_SHOTGUN)
				sound (self, CHAN_VOICE, "weapons/weapon2.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_SUPER_SHOTGUN)
				sound (self, CHAN_VOICE, "weapons/weapon3.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_NAILGUN)
				sound (self, CHAN_VOICE, "weapons/weapon4.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_SUPER_NAILGUN)
				sound (self, CHAN_VOICE, "weapons/weapon5.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_GRENADE_LAUNCHER)
				sound (self, CHAN_VOICE, "weapons/weapon6.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_PROXIMITY_GUN)
				sound (self, CHAN_VOICE, "weapons/weapon6_prox.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_ROCKET_LAUNCHER)
				sound (self, CHAN_VOICE, "weapons/weapon7.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_LIGHTNING)
				sound (self, CHAN_VOICE, "weapons/weapon8.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_LASER_CANNON)
				sound (self, CHAN_VOICE, "weapons/weapon9_laser.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_MJOLNIR)
				sound (self, CHAN_VOICE, "weapons/weapon10_mjolnir.wav", autocvar_changeweaponsounds, ATTN_NORM);
			}
			return;
		}
	}

};

/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
void() CycleWeaponReverseCommand =
{
	local	float	it, am;

	it = self.items;
	self.impulse = 0;

	while (1)
	{
		am = 0;

//MED
      if (self.weapon == IT_MJOLNIR)
		{
         self.weapon = IT_LASER_CANNON;
         if (self.ammo_cells < 1)
				am = 1;
		}
//MED
      else if (self.weapon == IT_LASER_CANNON)
		{
         self.weapon = IT_LIGHTNING;
         if (self.ammo_cells < 1)
				am = 1;
		}
      else if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
      else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
         self.weapon = IT_PROXIMITY_GUN;
			if (self.ammo_rockets < 1)
				am = 1;
		}
      else if (self.weapon == IT_PROXIMITY_GUN)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
      else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
      else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
         self.weapon = IT_MJOLNIR;
		}

		if ( (it & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			// plays weapon-change-sound when player uses mouse-wheel to change weapons
			if (autocvar_changeweaponsounds)
			{
			if (self.weapon == IT_AXE)
				sound (self, CHAN_VOICE, "weapons/weapon1.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_SHOTGUN)
				sound (self, CHAN_VOICE, "weapons/weapon2.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_SUPER_SHOTGUN)
				sound (self, CHAN_VOICE, "weapons/weapon3.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_NAILGUN)
				sound (self, CHAN_VOICE, "weapons/weapon4.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_SUPER_NAILGUN)
				sound (self, CHAN_VOICE, "weapons/weapon5.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_GRENADE_LAUNCHER)
				sound (self, CHAN_VOICE, "weapons/weapon6.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_PROXIMITY_GUN)
				sound (self, CHAN_VOICE, "weapons/weapon6_prox.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_ROCKET_LAUNCHER)
				sound (self, CHAN_VOICE, "weapons/weapon7.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_LIGHTNING)
				sound (self, CHAN_VOICE, "weapons/weapon8.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_LASER_CANNON)
				sound (self, CHAN_VOICE, "weapons/weapon9_laser.wav", autocvar_changeweaponsounds, ATTN_NORM);
			else if (self.weapon == IT_MJOLNIR)
				sound (self, CHAN_VOICE, "weapons/weapon10_mjolnir.wav", autocvar_changeweaponsounds, ATTN_NORM);
			}
			return;
		}
	}

};

/*
============
ServerflagsCommand

Just for development
============
*/
void() ServerflagsCommand =
{
	serverflags = serverflags * 2 + 1;
};

void() QuadCheat =
{
	if (deathmatch || coop)
		return;
	precache_sound ("items/damage.wav");
	precache_sound ("items/damage2.wav");
	precache_sound ("items/damage3.wav");
	sound (self, CHAN_ITEM, "items/damage.wav", 1, ATTN_NORM);
	sprint (other, "You got the ");
	sprint (other, "Quad Damage");
	sprint (other,"\n");
	self.super_time = 1;
	self.super_damage_finished = time + 30;
	self.items = self.items | IT_QUAD;
	dprint ("quad cheat\n");
};

void() RingCheat =
{
	if (deathmatch || coop)
		return;
	precache_sound ("items/inv1.wav");
	precache_sound ("items/inv2.wav");
	precache_sound ("items/inv3.wav");
	sound (self, CHAN_ITEM, "items/inv1.wav", 1, ATTN_NORM);
	sprint (other, "You got the ");
	sprint (other, "Ring of Shadows");
	sprint (other,"\n");
	self.invisible_time = 1;
	self.invisible_finished = time + 30;
	self.items = self.items | IT_INVISIBILITY;
	dprint ("ring cheat\n");
};

void() PentCheat =
{
	if (deathmatch || coop)
		return;
	precache_sound ("items/protect.wav");
	precache_sound ("items/protect2.wav");
	precache_sound ("items/protect3.wav");
	sound (self, CHAN_ITEM, "items/protect.wav", 1, ATTN_NORM);
	sprint (other, "You got the ");
	sprint (other, "Pentagram of Protection");
	sprint (other,"\n");
	self.invincible_time = 1;
	self.invincible_finished = time + 30;
	self.items = self.items | IT_INVULNERABILITY;
	dprint ("pent cheat\n");
};

void() BiosuitCheat =
{
	if (deathmatch || coop)
		return;
	precache_sound ("items/suit.wav");
	precache_sound ("items/suit2.wav");
	sound (self, CHAN_ITEM, "items/suit.wav", 1, ATTN_NORM);
	sprint (other, "You got the ");
	sprint (other, "Biosuit");
	sprint (other,"\n");
	self.rad_time = 1;
	self.radsuit_finished = time + 30;
	self.items = self.items | IT_SUIT;
	dprint ("biosuit cheat\n");
};


//MED
void() WetsuitCheat =
	{
   if (deathmatch || coop)
		return;
   precache_sound ("misc/wetsuit.wav");
   precache_sound ("misc/weton.wav");
   precache_sound ("items/suit2.wav");
   sound (self, CHAN_ITEM, "misc/weton.wav", 1, ATTN_NORM);
   sprint (other, "You got the ");
   sprint (other, "Wetsuit");
   sprint (other,"\n");
   self.items2 = self.items2 | HIP_IT_WETSUIT;
   self.wetsuit_time = 1;
   self.wetsuit_finished = time + 30;
   //bprint( "wetsuit cheat\n" );
	};

//MED
void() EmpathyShieldsCheat =
	{
   if (deathmatch || coop)
		return;
   precache_sound("hipitems/empathy.wav");
   precache_sound("hipitems/empathy2.wav");
   precache_sound ("items/suit2.wav");
   sound (self, CHAN_ITEM, "hipitems/empathy.wav", 1, ATTN_NORM);
   sprint (other, "You got the ");
   sprint (other, "Empathy Shield");
   sprint (other,"\n");
   self.items2 = self.items2 | HIP_IT_EMPATHY_SHIELDS;
   self.empathy_time = 1;
   self.empathy_finished = time + 30;
   //bprint( "empathy shields cheat\n" );
	};

void() DumpEntities =
   {
   local entity   head;
   local float i;

   i = 1;
   head = nextent(world);
   while (head!=world)
      {
      dprint(ftos(i));
      dprint(" ");
      dprint(head.classname);
      dprint("\n");
      head = nextent(head);
      i = i + 1;
      }
   };

void() DumpLiveEntities =
   {
   local entity   head;
   local float i;

   i = 1;
   head = nextent(world);
   while (head!=world)
      {
      if (head.health > 0)
         {
         dprint(ftos(i));
         dprint(" ");
         dprint(head.classname);
         dprint(" ");
         dprint(vtos(head.origin));
         dprint("\n");
         dprint("--------------------\n");
         }
      head = nextent(head);
      i = i + 1;
      }
   };

void() Genocide =
   {
   local entity   head;

   if (deathmatch || coop)
		return;
   bprint("Genocide!\n");
   head = nextent(world);
   while (head!=world)
      {
      if ((head.health > 0) && (head.flags & FL_MONSTER))
         {
         T_Damage(head,world,world,head.health+10);
         }
      head = nextent(head);
      }
   };

float dump_coord;
void () ToggleDump =
   {
   dump_coord = 1 - dump_coord;
   if (dump_coord == 1)
      bprint("Dumping Player Location\n");
   };
void () DumpCoordinates =
   {
   local entity pl;
   pl = checkclient();
   if (pl)
      {
      bprint("Player: ");
      bprint(vtos(pl.origin));
      bprint("\n");
      }
   };
/*
============
ImpulseCommands

============
*/
void() ImpulseCommands =
{
	if (self.impulse >= 1 && self.impulse <= 8)
		W_ChangeWeapon ();

   if (self.impulse >= 225 && self.impulse <= 226)
		W_ChangeWeapon ();

	if (self.impulse == 9)
		CheatCommand ();
   if (self.impulse == 10)
		CycleWeaponCommand ();
	if (self.impulse == 11)
		ServerflagsCommand ();
	if (self.impulse == 12)
		CycleWeaponReverseCommand ();
	if (self.impulse == 30) 	// flashlight 
	{
		if (autocvar_flashlight_type == 1)
		        flash_toggle();
		else if (autocvar_flashlight_type == 2)
		        flash_toggle_cubemap();
	}

//JIM
	if ( self.impulse == 200 )
		WetsuitCheat();
//MED
   if ( self.impulse == 201 )
      EmpathyShieldsCheat();
   if ( self.impulse == 205 )
      Genocide();
   if ( self.impulse == 206 )
      ToggleDump();
   if ( self.impulse == 202 )
      DumpEntities();
   if ( self.impulse == 203 )
      DumpLiveEntities();
   if (self.impulse == 252)
	RingCheat ();
   if (self.impulse == 253)
	PentCheat ();
   if (self.impulse == 254)
	BiosuitCheat ();
   if (self.impulse == 255)
		QuadCheat ();
   if (dump_coord == 1)
      DumpCoordinates();

	self.impulse = 0;
};


void() checkzombie =		// checks for NEW zombie via traceline in a distance of max. 777 Quake units
{
local vector source;
	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*777, FALSE, self);

	if ((trace_ent.model == "progs/zombie_new.mdl")||(trace_ent.model == "progs/zombie_new_headless.mdl"))
		{
		self.weaponmodel = "progs/v_axe_zombie01.mdl";		// Axe + glow is animated
		self.glow_color = 75;
		self.glow_size = 888;
		}
	else						// Axe + glow is fading out
		{
		self.weaponmodel = "progs/v_axe_zombie00.mdl";
		self.glow_color = 0;
		self.glow_size = 0;
		}
};


/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
void() W_WeaponFrame =
{

if (!(deathmatch || coop))
{
if (world.model == "maps/start.bsp")
	{
	if ( welcomenote == 1 )
		{
		if (self.welcomeshown <= 7)		// set endtime of welcome message here
			{
			if (time > self.welcomeshown)	// needed to set delay for welcome message
				{
				if (self.welcomeshown == 0)
					self.welcomeshown = time + 1;	// set delay for welcome message here
				else
					{
					self.welcomeshown = time + 1.5;
					centerprint(self, "Have fun with the Small_Mod_Compilation\nBe sure to read the included readme.txt how to set\nall features via cvars to your personal likings.\n");
					}
				}
			}
		}
	}
}


if (autocvar_zombieaxeanimation == 1)		// if cvar "zombieaxeanimation" is enabled, axe is animated when aiming at NEW zombies
	{
	if (autocvar_zombienewmodelproperties >= 1)	// new zombie model is killable with axe
		{
		if (self.weapon == IT_AXE)
			checkzombie();
		else
			{
			self.glow_color = 0;
			self.glow_size = 0;
			}
		}
	}


	if (time < self.attack_finished)
		return;

	ImpulseCommands ();

// check for attack
	if (self.button0)
	{
		SuperDamageSound ();
		W_Attack ();
	}
};

/*
========
SuperDamageSound

Plays sound if needed
========
*/
void() SuperDamageSound =
{
	if (self.super_damage_finished > time)
	{
		if (self.super_sound < time)
		{
			self.super_sound = time + 1;
			sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
		}
	}
	return;
};
