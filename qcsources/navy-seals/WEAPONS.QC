void () m60_precache;
void () player_zoomout;
void () player_zoom;
void () player_zoomb;
void () zoom;
void () hgren_precache;
void () kbar_precache;
void () moss_precache;
void () mp5_precache;
void () mp5sd_precache;
void () mk23_precache;
void () m16_precache;
void () raw_precache;
void () ashot_precache;
void () psg1_precache;
void () barrett_precache;
void (float shotcount,vector dir,vector spread) FireMossberg;

/*
*/
void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void () player_run;
void(entity bomb, entity attacker, float rad, entity ignore) T_RadiusDamage;
void(vector org, vector vel, float damage) SpawnBlood;
void() SuperDamageSound;



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
      precache_sound ("wizard/hit.wav");	//
      precache_model2 ("progs/blaser.mdl");
      moss_precache ();
      mp5_precache ();
      mp5sd_precache ();
      mk23_precache ();
      m16_precache ();
      raw_precache ();
      kbar_precache ();
      hgren_precache ();
      ashot_precache ();
      psg1_precache ();
      barrett_precache ();
      m60_precache ();
      // SEAL sQad modification, cache menus, SEAL sQad bots, and waypoints
      Menu_Precache ();
      Waypoint_Precache ();
      Squad_Precache ();
};

float() crandom =
{
	return 2*(random() - 0.5);
};


/*

void()	sparkle1	=	[0,		sparkle2] {};
void()	sparkle2	=	[1,		sparkle3] {};
void()	sparkle3	=	[2,		sparkle4] {};
void()	sparkle4	=	[3,		sparkle5] {};
void()	sparkle5	=	[4,		sparkle6] {};
void()	sparkle6	=	[5,		SUB_Remove] {};

void(vector org) DrawSpark =
{
    local entity spark;
 
    spark = spawn ();      
    spark.movetype = MOVETYPE_NONE;
    spark.velocity = '0 0 0';
    spark.touch = SUB_Null;
    setorigin(spark,org);
    setmodel (spark, "progs/spark.spr");
    spark.solid = SOLID_NOT;   
    spark.nextthink = time + 0.1;
    spark.think = SUB_Remove;
//    sparkle1 ();
};

*/

/*
================
W_FireAxe
================
*/

void() W_FireAxe =
{
	local	vector	source;
	local	vector	org;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
		SpawnBlood (org, '0 0 0', 20);
		T_Damage (trace_ent, self, self, 20);
	}
	else
	{	// hit wall
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord (MSG_BROADCAST, org_x);
		WriteCoord (MSG_BROADCAST, org_y);
		WriteCoord (MSG_BROADCAST, org_z);
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
	local	vector	org;

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

void (float damage, vector dir) TraceAttack = {

   local vector vel;
   local vector org;
   local vector meatdir;

   vel = normalize (((dir + (v_up * crandom ())) + (v_right * crandom ())));
   vel = (vel + (FL_SWIM * trace_plane_normal));
   vel = (vel * 200.000);
   org = (trace_endpos - (dir * MOVETYPE_STEP));
   if ( trace_ent.takedamage ) {

      SpawnBlood (org,(vel * 0.200),(damage * 100.000));
      AddMultiDamage (trace_ent,damage);
       
   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_GUNSHOT);
      WriteCoord (MSG_BROADCAST,org_x);
      WriteCoord (MSG_BROADCAST,org_y);
      WriteCoord (MSG_BROADCAST,org_z);
      particle (org,'3.000 2.000 7.000',192.000,TE_WIZSPIKE);
      particle (org,'7.000 6.000 8.000',192.000,TE_WIZSPIKE);
      sound (self.enemy,CHAN_AUTO,"weapons/mp5ric1.wav",TRUE,ATTN_NORM);         

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
	
	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;
      ClearMultiDamage ();
	while (shotcount > 0)
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttack (4, direction);

		shotcount = shotcount - 1;
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
	self.punchangle_x = -2;
     	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	dir = aim (self, 100000);
	FireMossberg (12, dir, '0.14 0.08 0.0');
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

	self.punchangle_x = -4;
	
	self.currentammo = self.ammo_shells = self.ammo_shells - 2;
	dir = aim (self, 100000);
      FireBullets (14.000,dir,'0.140 0.080 0.000');
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

void() Remove_Laser_Sights =
{
     local entity sight;

     sight = find(world, classname, "laser_sight");
     if (sight)
     {
        if (sight.owner == self)
        {
           self.sight_active = FALSE;
           remove(sight);
           return;
        }
     }
};

void() Sight_Think =
{
   local vector src;

   if (self.owner.reload)
   {
      remove(self);
      self.owner.sight_active = FALSE;
      return;
   }
     {
      if (self.owner.weapon == WP_MP5 || self.owner.weapon == WP_MP5SD)
       {
        makevectors (self.owner.v_angle);
        src = (self.owner.origin + (v_forward * TE_LAVASPLASH));
        src_z = (self.owner.absmin_z + (self.owner.size_z * 0.800));
        src_y = (self.owner.absmin_y + (self.owner.size_y * 0.400));
        traceline (src,(((src + (v_forward * IT_CELLS)) - (v_up * 110.000) - 
        (v_right * 55) ) ),FALSE,self.owner);

        self.lrange = vlen(self.owner.origin - trace_endpos);
        self.origin = (trace_endpos - (v_forward*10) );
       }
      if (self.owner.weapon == WP_MK23)
       {
        makevectors (self.owner.v_angle);
        src = (self.owner.origin + (v_forward * TE_LAVASPLASH));
        src_z = (self.owner.absmin_z + (self.owner.size_z * 0.800));
        src_y = (self.owner.absmin_y + (self.owner.size_y * 0.400));
        traceline (src,(((src + (v_forward * IT_CELLS)) - (v_up * 50.000)) -                   (v_right * 300)),FALSE,self.owner);

        self.lrange = vlen(self.owner.origin - trace_endpos);
        self.origin = (trace_endpos - (v_forward*10) );

       }
     
      if (self.owner.weapon == WP_M16)
       {
        makevectors (self.owner.v_angle);
        src = (self.owner.origin + (v_forward * TE_LAVASPLASH));
        src_z = (self.owner.absmin_z + (self.owner.size_z * 0.800));
        src_y = (self.owner.absmin_y + (self.owner.size_y * 0.400));
        traceline (src,(((src + (v_forward * IT_CELLS)) - (v_up * 130.000)) -  
        (v_right * 220)),FALSE,self.owner);

        self.lrange = vlen(self.owner.origin - trace_endpos);
        self.origin = (trace_endpos - (v_forward*10) );

       }
     

      if (self.owner.weapon == WP_PSG1 || self.owner.weapon == WP_BARRETT)
       {
        makevectors (self.owner.v_angle);
        src = (self.owner.origin + (v_forward * TE_LAVASPLASH));
        src_z = (self.owner.absmin_z + (self.owner.size_z * 0.800));
        src_y = (self.owner.absmin_y + (self.owner.size_y * 0.400));
        if (self.owner.zoomlevel != 0)
        {
         traceline (src,src + (v_forward * IT_CELLS),FALSE,self.owner);
        }
        else
        {
          traceline (src,(((src + (v_forward * IT_CELLS)) - (v_up * 90.000)) -
          (v_right * 120)),FALSE,self.owner);
        }

        self.origin = (trace_endpos - (v_forward*10) );
        self.lrange = vlen(self.owner.origin - trace_endpos);          

       }
     

     }
      if (self.lrange > 600) 
       {
        self.frame = 2;
       }
      else if (self.lrange > 300)
       {
        self.frame = 1;
       }
      else 
       {
        self.frame = 0;
       }

   self.nextthink = time;
   self.think = Sight_Think;
};

void (vector org) DrawLaser =
{
	local entity sight;

        sight = spawn ();
	sight.owner = self;
        sight.movetype = MOVETYPE_NOCLIP;
	sight.solid = SOLID_NOT;

	setmodel (sight, "progs/blaser.mdl");
	sight.classname = "laser_sight";

      if (self.lrange > 600) 
       {
        sight.frame = 2;
       }
      else if (self.lrange > 300)
       {
        sight.frame = 1;
       }
      else 
       {
        sight.frame = 0;
       }
	setorigin( sight, org );

        sight.think = Sight_Think;
        sight.nextthink = time;

};

void() T_MissileTouch =
{
	local float	damg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	damg = 100 + random()*20;
	
	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, 120, other);

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

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

	missile = spawn ();
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
	local vector		f;
	
	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
	if (trace_ent.takedamage)
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
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
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
		W_SetCurrentAmmo ();
		T_RadiusDamage (self, self, 35*cells, world);
		return;
	}

	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	self.punchangle_x = -2;

	self.currentammo = self.ammo_cells = self.ammo_cells - 1;

	org = self.origin + '0 0 16';
	
	traceline (org, org + v_forward*600, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	LightningDamage (self.origin, trace_endpos + v_forward*4, self, 30);
};


//=============================================================================


void() GrenadeExplode =
{
	T_RadiusDamage (self, self.owner, 120, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

void() GrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
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

	missile = spawn ();
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

void() spike_touch;
void() superspike_touch;


/*
===============
launch_spike

Used for both the player and the ogre
===============
*/
void(vector org, vector dir) launch_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);
	
	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
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
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 2;
	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16', dir);
	newmis.touch = superspike_touch;
	setmodel (newmis, "progs/s_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);		
	self.punchangle_x = -2;
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
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 1;
	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16' + v_right*ox, dir);

	self.punchangle_x = -2;
};



.float hit_z;
void() spike_touch =
{
local float rand;
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
		spawn_touchblood (9);
		T_Damage (other, self, self.owner, 9);
	}
	else
	{
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
	}

	remove(self);

};

void() superspike_touch =
{
local float rand;
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
		spawn_touchblood (18);
		T_Damage (other, self, self.owner, 18);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);

};


/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/


void() W_SetCurrentAmmo =
{
        local vector src;
	player_run ();		// get out of any weapon firing states

	self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) );
        Remove_Laser_Sights();  // remove any active laser sights

        if (self.weapon == WP_ONE)
	{
         if (self.hgrenade != 1)
           {
		self.currentammo = 0;
		self.weaponmodel = "progs/v_kbar.mdl";
		self.weaponframe = 0;
           }
         if (self.hgrenade == 1)
           {
            self.currentammo = self.ammo_rockets;
            self.weaponmodel = "progs/v_gren.mdl";
            self.weaponframe = 0;
            if (!self.use_clip_as_ammo)
              self.items = self.items | IT_ROCKETS;
           }
	}
        else if (self.weapon == WP_MK23)
	{
                  if (self.use_clip_as_ammo)
                    self.currentammo = self.mk23clip;
                  else
                    self.currentammo = self.ammo_shells;
		  self.weaponmodel = "progs/v_mk23.mdl";
		  self.weaponframe = 0;
                  if (!self.sight_active)
                  {
                    self.sight_active = TRUE;
                    makevectors (self.v_angle);
                    src = (self.origin + (v_forward * TE_LAVASPLASH));
                    src_z = (self.absmin_z + (self.size_z * 0.800));
                    src_y = (self.absmin_y + (self.size_y * 0.400));
                    traceline (src,(((src + (v_forward * IT_CELLS)) - (v_up * 50.000)) -                   (v_right * 300)),FALSE,self);

                    self.lrange = vlen(self.origin - trace_endpos);
                    DrawLaser (trace_endpos - (v_forward*10) );

                  }
                  if (!self.use_clip_as_ammo)
                    self.items = self.items | IT_SHELLS;
	}
        else if (self.weapon == WP_MOSS)
	{
                if (self.use_clip_as_ammo)
                  self.currentammo = self.mossclip;
                else
                  self.currentammo = self.ammo_shells;
                self.weaponmodel = "progs/v_moss.mdl";
		self.weaponframe = 0;
                if (!self.use_clip_as_ammo)
                  self.items = self.items | IT_SHELLS;
	}
        else if (self.weapon == WP_MP5)
      {
            if (self.use_clip_as_ammo)
              self.currentammo = self.mp5clip;
            else
              self.currentammo = self.ammo_nails;
            self.weaponmodel = "progs/v_mp5.mdl";
            self.weaponframe = FALSE;
        if (!self.sight_active)
        {
                  self.sight_active = TRUE;
          makevectors (self.v_angle);
          src = (self.origin + (v_forward * TE_LAVASPLASH));
          src_z = (self.absmin_z + (self.size_z * 0.800));
          src_y = (self.absmin_y + (self.size_y * 0.400));
          traceline (src,(((src + (v_forward * IT_CELLS)) - (v_up * 110.000) - 
          (v_right * 55) ) ),FALSE,self);

          self.lrange = vlen(self.origin - trace_endpos);
          DrawLaser (trace_endpos - (v_forward*10) );
        }
            if (!self.use_clip_as_ammo)
              self.items = (self.items | IT_NAILS);
      }
        else if (self.weapon == WP_MP5SD)
      {
            if (self.use_clip_as_ammo)
              self.currentammo = self.mp5clip;
            else
              self.currentammo = self.ammo_nails;
            self.weaponmodel = "progs/v_mp5sd.mdl";
            self.weaponframe = FALSE;
        if (!self.sight_active)
        {
                  self.sight_active = TRUE;
          makevectors (self.v_angle);
          src = (self.origin + (v_forward * TE_LAVASPLASH));
          src_z = (self.absmin_z + (self.size_z * 0.800));
          src_y = (self.absmin_y + (self.size_y * 0.400));
          traceline (src,(((src + (v_forward * IT_CELLS)) - (v_up * 110.000) - 
          (v_right * 55) ) ),FALSE,self);

          self.lrange = vlen(self.origin - trace_endpos);
          DrawLaser (trace_endpos - (v_forward*10) );
        }
            if (!self.use_clip_as_ammo)
              self.items = (self.items | IT_NAILS);
      }
        else if (self.weapon == WP_ASHOT)
	{
                self.currentammo = self.ammo_shells;
                self.weaponmodel = "progs/v_ashot.mdl";
		self.weaponframe = 0;
                if (!self.use_clip_as_ammo)
                  self.items = self.items | IT_SHELLS;
	}
        else if (self.weapon == WP_M16)
	{
                if (self.use_clip_as_ammo)
                  self.currentammo = self.m16clip;
                else
                  self.currentammo = self.ammo_nails;
            self.weaponmodel = "progs/v_m16.mdl";
		self.weaponframe = 0;
                if (!self.sight_active)
                {   
                  self.sight_active = TRUE;
                   makevectors (self.v_angle);
                   src = (self.origin + (v_forward * TE_LAVASPLASH));
                   src_z = (self.absmin_z + (self.size_z * 0.800));
                   src_y = (self.absmin_y + (self.size_y * 0.400));
                   traceline (src,(((src + (v_forward * IT_CELLS)) - (v_up * 130.000)) -  
                   (v_right * 220)),FALSE,self);

                    self.lrange = vlen(self.origin - trace_endpos);
                    DrawLaser (trace_endpos - (v_forward*10) );

                }
                if (!self.use_clip_as_ammo)
                  self.items = self.items | IT_NAILS;
	}
        else if (self.weapon == WP_M16RAW)
	{
                self.currentammo = self.ammo_rockets;
                self.weaponmodel = "progs/v_m16raw.mdl";
		self.weaponframe = 0;
                if (!self.use_clip_as_ammo)
                  self.items = self.items | IT_ROCKETS;
	}
        else if (self.weapon == WP_PSG1)
	{
                if (self.use_clip_as_ammo)
                  self.currentammo = self.psg1clip;
                else
                  self.currentammo = self.ammo_rockets;
                self.weaponmodel = "progs/v_psg1.mdl";
		self.weaponframe = 0;
                if (!self.sight_active)
                {
                  self.sight_active = TRUE;
                  makevectors (self.v_angle);
                  src = (self.origin + (v_forward * TE_LAVASPLASH));
                  src_z = (self.absmin_z + (self.size_z * 0.800));
                  src_y = (self.absmin_y + (self.size_y * 0.400));
                  traceline (src,(((src + (v_forward * IT_CELLS)) - (v_up * 90.000)) -  
                  (v_right * 120)),FALSE,self);
                  if (self.zoomlevel != 0)
                  traceline (src,src + (v_forward * IT_CELLS),FALSE,self);
         

                  self.lrange = vlen(self.origin - trace_endpos);          
                  DrawLaser (trace_endpos - (v_forward*10) );        

                }
                if (!self.use_clip_as_ammo)
                  self.items = self.items | IT_ROCKETS;
	}
        else if (self.weapon == WP_BARRETT)
	{
                if (self.use_clip_as_ammo)
                  self.currentammo = self.psg1clip;
                else
                  self.currentammo = self.ammo_rockets;
                self.weaponmodel = "progs/v_barret.mdl";
		self.weaponframe = 0;
                if (!self.sight_active)
                {
                  self.sight_active = TRUE;
                  makevectors (self.v_angle);
                  src = (self.origin + (v_forward * TE_LAVASPLASH));
                  src_z = (self.absmin_z + (self.size_z * 0.800));
                  src_y = (self.absmin_y + (self.size_y * 0.400));
                  traceline (src,(((src + (v_forward * IT_CELLS)) - (v_up * 90.000)) -  
                  (v_right * 120)),FALSE,self);
                  if (self.zoomlevel != 0)
                  traceline (src,src + (v_forward * IT_CELLS),FALSE,self);
         

                  self.lrange = vlen(self.origin - trace_endpos);          
                  DrawLaser (trace_endpos - (v_forward*10) );        

                }
                if (!self.use_clip_as_ammo)
                  self.items = self.items | IT_ROCKETS;
	}
        else if (self.weapon == WP_M60)
	{
                if (self.use_clip_as_ammo)
                  self.currentammo = self.m60clip;
                else
                  self.currentammo = self.ammo_cells;
                self.weaponmodel = "progs/v_m60.mdl";
                if (self.m60clip == 0)
                  self.weaponframe = 15;
                else
                self.weaponframe = 0;
                if (!self.use_clip_as_ammo)
                  self.items = self.items | IT_CELLS;
	}
	else
	{
		self.currentammo = 0;
		self.weaponmodel = "";
		self.weaponframe = 0;
	}
};

float() W_BestWeapon =
{
        local   float   wp;

        wp = self.weapons;
        // BUG, NS2.0
        /*
	if (self.waterlevel <= 1 && self.ammo_cells >= 1 && (it & IT_LIGHTNING) )
			return IT_LIGHTNING;
	if(self.ammo_nails >= 2 && (it & IT_SUPER_NAILGUN) )
		return IT_SUPER_NAILGUN;
	if(self.ammo_shells >= 2 && (it & IT_SUPER_SHOTGUN) )
		return IT_SUPER_SHOTGUN;
	if(self.ammo_nails >= 1 && (it & IT_NAILGUN) )
		return IT_NAILGUN;
	if(self.ammo_shells >= 1 && (it & IT_SHOTGUN) )
		return IT_SHOTGUN;
	return IT_AXE;
        */
        // M60
        if ((self.m60clip >= 1) && (wp & WP_M60) )
                        return WP_M60;
        // RAW
        if ((self.ammo_rockets >= 1) && (wp & WP_M16RAW))
          return WP_M16RAW;
        // M16
        if ((self.m16clip >= 1) && (wp & WP_M16))
          return WP_M16;
        // Barrett
        if ((self.psg1clip >= 1) && (wp & WP_BARRETT))
          return WP_BARRETT;
        // PSG1
        if ((self.psg1clip >= 1) && (wp & WP_PSG1))
          return WP_PSG1;
        // assault gun
        if ((self.ammo_shells > 2) && (wp & WP_ASHOT))
          return WP_ASHOT;
        // mp5sd
        if ((self.mp5clip >= 1) && (wp & WP_MP5SD))
          return WP_MP5SD;
        // mp5
        if ((self.mp5clip >= 1) && (wp & WP_MP5))
          return WP_MP5;
        // mossberg
        if ((self.mossclip >= 1) && (wp & WP_MOSS))
          return WP_MOSS;
        // mk23
        if ((self.mk23clip >= 1) && (wp & WP_MK23))
          return WP_MK23;

        return WP_ONE;
};

float() W_CheckNoAmmo =
{
        if (self.currentammo >= 0)
		return TRUE;

        if (self.weapon == WP_ONE)
		return TRUE;
	self.weapon = W_BestWeapon ();

	W_SetCurrentAmmo ();
// drop the weapon down
	return FALSE;
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
void()      player_mossberg;
void()      player_reload_mossberg;
void()      player_mp5a;
void()      player_mp5f;
void()      player_mp5g;
void()      player_reload_mp5;
void()      player_mp5_switch;
void()      player_mp5sda;
void()      player_mp5sdf;
void()      player_mp5sdg;
void()      player_reload_mp5sd;
void()      player_mp5sd_switch;
void()      player_mk23a;
void()      player_mk23b;
void()      player_reload_mk23;
void()      player_reload_m16;
void()      player_m16a;
void()      player_m16b;
void()      player_m16_grenade;
void()      player_raw;
void()      player_kbar;
void()      player_hgrenade;
void()      player_assaultshotgun;
void()      player_reload_psg1;
void()      player_reload_barrett;
void()      player_psg1;
void()      player_barrett;
void()      player_m60;
void()      player_reload_m60;
void()      player_m60_winchester;

void() W_Attack =
{
	local	float	r;

	if (!W_CheckNoAmmo ())
		return;
    
      if (self.reload == 1) 
       return;
      self.weaponfired = self.weapon;

	makevectors	(self.v_angle);			// calculate forward angle for velocity
	self.show_hostile = time + 1;	// wake monsters up

      r = random ();
        if (self.weapon == WP_ONE)
	{
       if (self.hgrenade != 1)
       {
            self.attack_finished = time + 1.5;
            player_kbar ();
       }
       if (self.hgrenade == 1)
        {
         if (self.ammo_rockets > 0) 
          {
           self.grenadetime = 0;
           self.attack_finished = time + 9999; //ugly hack, but lets you hold the grenade almost indefinately
           //(if you want to hold the attack button for a few hours, go right ahead hehe)
           player_hgrenade ();
           self.ammo_rockets = self.ammo_rockets - 1;
           self.currentammo = self.ammo_rockets;
          }
         else
          {
           self.hgrenade == 0;
           self.impulse = 1;
           return;
          }
         }
	}
        else if (self.weapon == WP_MK23)
	{
        if (self.mk23clip > 0)
         {
            if (r < 0.5)
             {
   		  player_mk23a ();
		  self.attack_finished = time + 0.18;
             }
            else
             {
              player_mk23b ();
		  self.attack_finished = time + 0.18;
             }
         }
        else
         {
            sound(self,CHAN_WEAPON,"weapons/mp5click.wav",TRUE,ATTN_NORM);
            self.attack_finished = time + 0.5;
         }
	}
        else if (self.weapon == WP_MOSS)
	{
        if (self.mossclip > 0)
         {       
		player_mossberg ();
		self.attack_finished = time + 0.850;
         }
        else 
         {
            sound (self,CHAN_WEAPON,"weapons/mp5click.wav",TRUE,ATTN_NORM);
            self.attack_finished = (time + 0.400);
         }

	}
        else if (self.weapon == WP_MP5)
      {
                      
                  if ( (self.mp5clip > 0) && (self.semiauto == 0) ) 
                      {                 
                       player_mp5g ();                                        
                       self.attack_finished = time + 0.21;
                      }
                  else if ( (self.mp5clip > 0) && (self.semiauto == 1) )
                      {
                       player_mp5f ();
                       self.attack_finished = time + 0.42;
                      }
                  else if ( (self.mp5clip > 0) && (self.semiauto == 2) )
                      {
                       player_mp5a ();
                      }                                   
                  else 
                    {
                     sound (self,CHAN_WEAPON,"weapons/mp5click.wav",TRUE,ATTN_NORM);
                     self.attack_finished = (time + 0.400);
                    }

      }
        else if (self.weapon == WP_MP5SD)
      {         
                      
                  if ( (self.mp5clip > 0) && (self.semiauto == 0) ) 
                      {                 
                       player_mp5sdg ();                                        
                       self.attack_finished = time + 0.21;
                      }
                  else if ( (self.mp5clip > 0) && (self.semiauto == 1) )
                      {
                       player_mp5sdf ();
                       self.attack_finished = time + 0.42;
                      }
                  else if ( (self.mp5clip > 0) && (self.semiauto == 2) )
                      {
                       player_mp5sda ();
                      }                                   
                  else 
                    {
                     sound (self,CHAN_WEAPON,"weapons/mp5click.wav",TRUE,ATTN_NORM);
                     self.attack_finished = (time + 0.400);
                    }

      }
        
        else if (self.weapon == WP_ASHOT)
	{
           player_assaultshotgun ();
           self.attack_finished = time + 0.35;
	}
        else if (self.weapon == WP_M16)
	{
          if (self.m16clip > 0) 
           {
              player_m16a();
              self.attack_finished = time + 0.1;
           }
          else
           {
            sound(self,CHAN_WEAPON,"weapons/mp5click.wav",TRUE,ATTN_NORM);
            self.attack_finished = time + 0.4;
           }
	}
        else if (self.weapon == WP_M16RAW)
	{
		player_raw ();
		self.attack_finished = time + 1.1;
	}
        else if (self.weapon == WP_PSG1)
	{
          if (self.psg1clip > 0)
           {
		player_psg1();
		self.attack_finished = time + 0.5;
           }
          else
           {
            sound(self,CHAN_WEAPON,"weapons/mp5click.wav",1,ATTN_NORM);
            self.attack_finished = time + 0.5;
           }
	}
        else if (self.weapon == WP_BARRETT)
	{
          if (self.psg1clip > 0)
           {
		player_barrett();
		self.attack_finished = time + 0.5;
           }
          else
           {
            sound(self,CHAN_WEAPON,"weapons/mp5click.wav",1,ATTN_NORM);
            self.attack_finished = time + 0.5;
           }
	}
        else if (self.weapon == WP_M60)
	{
         if (self.m60clip > 0)
          {
            if (self.m60clip <= 5)
             {
              player_m60_winchester ();
             }
            else
             {
   		  player_m60();
		  self.attack_finished = time + 0.1;	
             }
          }
         else
          {
            sound(self,CHAN_WEAPON,"weapons/mp5click.wav",1,ATTN_NORM);
          }
	}
};

/*
============
W_ChangeWeapon

============
*/
void() W_ChangeWeapon =
{
        local   float   wp, am, fl;
	
        wp = self.weapons;
	am = 0;

      if (self.reload)
       return;
	
	if (self.impulse == 1)
	{
          if (self.ammo_rockets < 1) 
           {
            fl = WP_ONE;
            self.hgrenade = 0;
           }
          else
           { 
            if (self.hgrenade == 1)
             {
                  fl = WP_ONE;
              self.hgrenade = 0;
             }
            else
             {
              fl = WP_ONE;
              self.hgrenade = 1;
             }
           }
	}
	else if (self.impulse == 2)
	{
                fl = WP_MK23;
                if (self.mk23clip < 1 && self.ammo_shells < 1)
		am = 1;
	}
	else if (self.impulse == 3)
	{
                fl = WP_MOSS;
                if (self.mossclip < 1 && self.ammo_shells < 1)
			am = 1;
	}
        else if ((self.impulse == 4) && (self.weapon != WP_MP5))
       {
                  self.semiauto == 0;
                  fl = WP_MP5;
               if ( (self.mp5clip < TRUE && self.ammo_nails < 1) ) {

                am = TRUE;
         }
       }
        else if ((self.impulse == 4) && (self.weapon == WP_MP5))
       {
                  self.semiauto == 0;
                  fl = WP_MP5SD;
               if ( (self.mp5clip < TRUE && self.ammo_nails < 1) ) {

                am = TRUE;
         }
       }

	else if (self.impulse == 5)
	{
                fl = WP_ASHOT;
                if (self.ammo_shells < 2)
			am = 1;
	}
        else if ((self.impulse == 6) && (self.weapon != WP_M16))
	{
                fl = WP_M16;
                if (self.m16clip < 1 && self.ammo_nails < 1)
			am = 1;
	}
        else if ((self.impulse == 6) && (self.weapon == WP_M16))
	{
                fl = WP_M16RAW;
		if (self.ammo_rockets < 1)
			am = 1;
	}
        else if ((self.impulse == 7) && (self.weapon != WP_PSG1))
	{
                fl = WP_PSG1;
                if (self.psg1clip < 1 && self.ammo_rockets < 1)
			am = 1;
	}
        else if ((self.impulse == 7) && (self.weapon == WP_PSG1))
	{
                fl = WP_BARRETT;
                if (self.psg1clip < 1 && self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 8)
	{
                fl = WP_M60;
                if (self.m60clip < 1 && self.ammo_cells < 1)
                	am = 1;
	}

	self.impulse = 0;
	
        if (!(wp & fl))
	{	// don't have the weapon or the ammo
		sprint (self, "no weapon.\n");
		return;
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

	self.ammo_rockets = 100;
	self.ammo_nails = 200;
	self.ammo_shells = 100;
	self.items = self.items | 
		IT_AXE |
		IT_SHOTGUN |
		IT_SUPER_SHOTGUN |
		IT_NAILGUN |
		IT_SUPER_NAILGUN |
		IT_GRENADE_LAUNCHER |
		IT_ROCKET_LAUNCHER |
		IT_KEY1 | IT_KEY2;
        self.weapons = self.weapons |
                WP_ONE |
                WP_MK23 |
                WP_MOSS |
                WP_MP5 |
                WP_MP5SD |
                WP_ASHOT |
                WP_M16 |
                WP_M16RAW |
                WP_PSG1 |
                WP_BARRETT |
                WP_M60;
	self.ammo_cells = 200;
        self.mk23clip = 13;
        self.mossclip = 8;
        self.mp5clip = 30;
        self.m16clip = 40;
        self.psg1clip = 20;
        self.m60clip = 200;
	self.items = self.items | IT_LIGHTNING;

        self.weapon = WP_PSG1;
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
        local   float   wp, am;

        wp = self.weapons;
	self.impulse = 0;

	while (1)
	{
		am = 0;

                if (self.weapon == WP_M60)
		{
                        self.weapon = WP_ONE;
		}
                else if (self.weapon == WP_ONE)
		{
                        self.weapon = WP_MK23;
                        if (self.mk23clip < 1 && self.ammo_shells < 1)
				am = 1;
		}
                else if (self.weapon == WP_MK23)
		{
                        self.weapon = WP_MOSS;
                        if (self.mossclip < 1 && self.ammo_shells < 1)
				am = 1;
		}
                else if (self.weapon == WP_MOSS)
		{
                        self.weapon = WP_MP5;
                        if (self.mp5clip < 1 && self.ammo_nails < 1)
				am = 1;
		}
                else if (self.weapon == WP_MP5)
		{
                        self.weapon = WP_MP5SD;
                        if (self.mp5clip < 1 && self.ammo_nails < 1)
				am = 1;
		}
                else if (self.weapon == WP_MP5SD)
		{
                        self.weapon = WP_ASHOT;
                        if (self.ammo_shells < 2)
				am = 1;
		}
                else if (self.weapon == WP_ASHOT)
		{
                        self.weapon = WP_M16;
			// BUG NS2.0 if (self.ammo_rockets < 1)
                        if (self.m16clip < 1 && self.ammo_nails < 1)
				am = 1;
		}
                else if (self.weapon == WP_M16)
		{
                        self.weapon = WP_M16RAW;
                        if (self.ammo_rockets < 1)
				am = 1;
		}
                else if (self.weapon == WP_M16RAW)
		{
                        self.weapon = WP_PSG1;
                        if (self.psg1clip < 1 && self.ammo_rockets < 1)
				am = 1;
		}
                else if (self.weapon == WP_PSG1)
		{
                        self.weapon = WP_BARRETT;
                        if (self.psg1clip < 1 && self.ammo_rockets < 1)
				am = 1;
		}
                else if (self.weapon == WP_BARRETT)
		{
                        self.weapon = WP_M60;
                        if (self.m60clip < 1 && self.ammo_cells < 1)
				am = 1;
		}

                if ( (wp & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
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

                if (self.weapon == WP_M60)
		{
                        self.weapon = WP_BARRETT;
                        if (self.psg1clip < 1 && self.ammo_rockets < 1)
				am = 1;
		}
                else if (self.weapon == WP_BARRETT)
		{
                        self.weapon = WP_PSG1;
                        if (self.psg1clip < 1 && self.ammo_rockets < 1)
				am = 1;
		}
                else if (self.weapon == WP_PSG1)
		{
                        self.weapon = WP_M16RAW;
			if (self.ammo_rockets < 1)
				am = 1;
		}
                else if (self.weapon == WP_M16RAW)
		{
                        self.weapon = WP_M16;
			// BUG NS2.0 if (self.ammo_rockets < 1)
                        if (self.m16clip < 1 && self.ammo_nails < 1)
				am = 1;
		}
                else if (self.weapon == WP_M16)
		{
                        self.weapon = WP_ASHOT;
                        if (self.ammo_shells < 1)
				am = 1;
		}
                else if (self.weapon == WP_ASHOT)
		{
                        self.weapon = WP_MP5SD;
                        if (self.mp5clip < 1 && self.ammo_nails < 1)
				am = 1;
		}
                else if (self.weapon == WP_MP5SD)
		{
                        self.weapon = WP_MP5;
                        if (self.mp5clip < 1 && self.ammo_nails < 1)
				am = 1;
		}
                else if (self.weapon == WP_MP5)
		{
                        self.weapon = WP_MOSS;
                        if (self.mossclip < 1 && self.ammo_shells < 1)
				am = 1;
		}
                else if (self.weapon == WP_MOSS)
		{
                        self.weapon = WP_MK23;
                        if (self.mk23clip < 1 && self.ammo_shells < 1)
				am = 1;
		}
                else if (self.weapon == WP_MK23)
                {
                        self.weapon == WP_ONE;
                }
                else if (self.weapon == WP_ONE)
		{
                        self.weapon = WP_M60;
                        if (self.m60clip < 1 && self.ammo_cells < 1)
				am = 1;
		}
	
		if ( (it & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
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
	self.super_time = 1;
	self.super_damage_finished = time + 30;
	self.items = self.items | IT_QUAD;
	dprint ("quad cheat\n");
};

/*
============
ImpulseCommands

============
*/
void() ImpulseCommands =
{  // SEAL sQad modifcation - added menu code
   // add user info to menu handler, if necessary
   if (Squad_Game_IsInfiltrate())
   if (MenuHandler_ProcessInput(menuHandler, self.impulse))
     return;
   // SEAL sQad modifcation - added menu code - end modification

      local vector src;
      local string sk;

	if (self.impulse >= 1 && self.impulse <= 8)
		W_ChangeWeapon ();

	if (self.impulse == 9)
		CheatCommand ();
	if (self.impulse == 10)
		CycleWeaponCommand ();
	if (self.impulse == 11)
		ServerflagsCommand ();
	if (self.impulse == 12)
		CycleWeaponReverseCommand ();
      if (self.impulse == 200)
            Grenadepick ();

	if (self.impulse == 255)
		QuadCheat ();

/************************ SEAL sQad impulses ****************/
        // SEAL sQad modification, accept additional impulses
        if (self.impulse == SQUAD_INFO)
            { Squad_Info();
            }
        if (self.impulse == WAYPOINT_PLOTPOSITION)
            { Waypoint_PlotPosition();
            }

/************************ CROUCHING *************************/

    if (self.impulse == 104)
    {
      if (self.duck == 0)
      {
        self.duck = 1;
        setsize (self, '-16 -16 -24', '16 16 15');
        self.view_ofs = '0 0 10';
        stuffcmd(self,"cl_forwardspeed 100 \n");
        stuffcmd(self,"cl_backspeed 90 \n");
        stuffcmd(self,"cl_sidespeed 100 \n");

      }
      else if (self.duck == 1)
      {
        self.duck = 0;
        setsize (self, '-16 -16 -24', '16 16 35');
        self.view_ofs = '0 0 22';
        stuffcmd(self,"cl_forwardspeed 320 \n");
        stuffcmd(self,"cl_backspeed 400 \n");
        stuffcmd(self,"cl_sidespeed 350 \n");
      }
    }

/******************** Mossberg reload sequence ***************************/

    if ((self.impulse == 100) && (self.weaponmodel == "progs/v_moss.mdl"))
     {
        if (self.mossclip == 8 || self.ammo_shells == 0 || self.reload || self.button0)
        {
            self.impulse = 0;
            return;
        }
        else player_reload_mossberg();
     }
    
/******************** MP5 reload sequence*********************************/

    if ( (self.impulse == 100.000) && (self.weaponmodel == "progs/v_mp5.mdl"))                        
    {
      if (self.mp5clip == 30 || self.ammo_nails == 0 || self.reload || self.button0)
      {
         self.impulse = 0;
         return;
      }
      else player_reload_mp5 ();
    }
	
/******************** MP5 Full/Semiauto/Single switch sequence ***************/
    
   if ( (self.impulse == 105) && (self.weaponmodel == "progs/v_mp5.mdl") )
    {
     if (self.semiauto == 0)
      {
//BUG NS2.0 in sprints
//       player_mp5_switch ();
       sound(self,CHAN_WEAPON,"weapons/gpull.wav",1,ATTN_NORM);
       self.semiauto = 1;
       sprint(self,"Burst-rate controlled mode\n");

      }
     else if (self.semiauto == 1)
      {
//       player_mp5_switch ();
       sound(self,CHAN_WEAPON,"weapons/gpull.wav",1,ATTN_NORM);
       self.semiauto = 2;
       sprint(self,"Full-Automatic mode\n");
      }
     else if (self.semiauto == 2)
      {
        sound(self,CHAN_WEAPON,"weapons/gpull.wav",1,ATTN_NORM);
        self.semiauto = 0;
        sprint(self,"Single Shot mode\n");
      }
    }

/******************** MP5SD reload sequence*********************************/

    if ( (self.impulse == 100.000) && (self.weaponmodel == "progs/v_mp5sd.mdl")) 
    {
      if (self.mp5clip == 30 || self.ammo_nails == 0 || self.reload || self.button0)
      {
         self.impulse = 0;
         return;
      }
      else player_reload_mp5sd ();
    }
/******************** MP5SD Full/Semiauto/Single switch sequence ***************/
    
   if ( (self.impulse == 105) && (self.weaponmodel == "progs/v_mp5sd.mdl") )
    {
     if (self.semiauto == 0)
      {
// BUG NS2.0
//       player_mp5sd_switch ();
       sound(self,CHAN_WEAPON,"weapons/gpull.wav",1,ATTN_NORM);
       self.semiauto = 1;
       sprint(self,"3 Round Burst mode\n");

      }
     else if (self.semiauto == 1)
      {
//       player_mp5sd_switch ();
       sound(self,CHAN_WEAPON,"weapons/gpull.wav",1,ATTN_NORM);
       self.semiauto = 2;
       sprint(self,"Full-Automatic mode\n");
      }
     else if (self.semiauto == 2)
      {
        sound(self,CHAN_WEAPON,"weapons/gpull.wav",1,ATTN_NORM);
        self.semiauto = 0;
        sprint(self,"Single Shot mode\n");
      }
    }

/******************** M60 reload sequence*********************************/

      if ((self.impulse == 100.00) && (self.weaponmodel == "progs/v_m60.mdl"))
      {
        if (self.m60clip == 200 || self.ammo_cells == 0 || self.reload || self.button0)
        {
            self.impulse = 0;
            return;
        }
        else player_reload_m60 ();
      }
/******************** PSG-1 reload sequence*********************************/

      if ( (self.impulse == 100.00) && (self.weaponmodel == "progs/v_psg1.mdl")) 
      {
        if (self.psg1clip == 20 || self.ammo_rockets == 0 || self.reload || self.button0)
        {
            self.impulse = 0;
            return;
        }
        else player_reload_psg1 ();
      }
/****************** Barrett reload sequence*********************************/

      if ( (self.impulse == 100.00) && (self.weaponmodel == "progs/v_barret.mdl"))
      {
        if (self.psg1clip == 20 || self.ammo_rockets == 0 || self.reload || self.button0)
        {
            self.impulse = 0;
            return;
        }
        else  player_reload_barrett();
      }
/******************** M-16 reload sequence*********************************/

      if ( (self.impulse == 100.00) && (self.weaponmodel == "progs/v_m16.mdl")) 
      {
         if (self.m16clip == 40 || self.ammo_nails == 0 || self.reload || self.button0)
         {
           self.impulse = 0;
           return;
         }
         else player_reload_m16 ();
      }
/******************** M16 grenade sequence*********************************/
      if ( (self.impulse == 101) && (self.weaponmodel == "progs/v_m16.mdl") && 
	     (self.m16_grenade_finished < time) )
       {
        if (self.ammo_rockets > 2)
         {
          player_m16_grenade ();
          self.ammo_rockets = self.ammo_rockets - 2;
//          self.attack_finished = time + 0.5;
          self.m16_grenade_finished = time + 1.0;
          self.weaponfired = WP_M16GRENADE;
         }
        else
         {
//          self.attack_finished = time + 0.3;
          sound(self,CHAN_WEAPON,"weapons/mp5click.wav",TRUE,ATTN_NORM);
         }
       }


/******************** Single MK23 reload sequence*********************************/
      if ((self.impulse == 100) && (self.weaponmodel == "progs/v_mk23.mdl"))
      {
        if (self.mk23clip == 13 || self.ammo_shells == 0 || self.reload || self.button0)
        {
            self.impulse = 0;
            return;
        }
         player_reload_mk23 ();
      } 
/******************* PSG-1 Zoom Feature ************************/
      if ( (self.impulse == 102) && (self.weapon == WP_PSG1 ) )
       {
        if (self.zoomlevel == 1)
         {
          player_zoomb ();
         }
        if (self.zoomlevel == 0)
         {
          player_zoom ();
         }
       }
      if ( (self.impulse == 103) && (self.weapon == WP_PSG1 ) &&
           (self.zoomlevel != 0) )
         {
          player_zoomout ();
         }
     

/******************* Barrett Zoom Feature ************************/
      if ( (self.impulse == 102) && (self.weapon == WP_BARRETT) )
       {
        if (self.zoomlevel == 1)
         {
          self.zoomlevel = 2;
          player_zoomb ();
         }
        if (self.zoomlevel == 0)
         {
          self.zoomlevel = 1;
          player_zoom ();
         }
       }
      if ( (self.impulse == 103) && (self.weapon == WP_BARRETT ) &&
           (self.zoomlevel != 0) )
         {
          self.zoomlevel = 0;
          player_zoomout ();
         }
     


/**********************************************************************************/

// Display Toggle
   if (self.impulse == 201)
   {
     if (self.button0 || self.reload)
     {
        self.impulse = 0;
        return;
     }

     if (self.use_clip_as_ammo)
     {
       self.use_clip_as_ammo = FALSE;
       centerprint (self, "Using Ammo Display Mode -> Standard\n");
       W_SetCurrentAmmo();
     }
     else
     {
       self.use_clip_as_ammo = TRUE;
       centerprint (self, "Using Ammo Display Mode -> Gun Clips\n");
       W_SetCurrentAmmo();
     }
   }


/**************************** PLAYER SKIN SELECT **********************************/

   if (self.impulse == 205)
   { 
     self.skin = self.skin + 1;
     if (self.skin > 8)
       self.skin = 0;
     sk = ftos(self.skin);
     sprint (self, "Using Player Skin -> #");
     sprint (self, sk);
     sprint (self, "\n");
   }

   self.impulse = 0;

};
       
void() Grenadepick =

            
            {
            
            self.grenadetype = self.grenadetype + 1;
            if (self.grenadetype == 2) self.grenadetype = 0;
            if (self.grenadetype == 0) centerprint(self,"Fragmentation Grenades\n");
            else if (self.grenadetype == 1) centerprint(self,"Flash-Bang Grenades\n");

            };


/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
void() W_WeaponFrame =
{
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


