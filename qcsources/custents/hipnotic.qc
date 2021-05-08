// for damagethreshold triggers
float MULTI_USE = 1;
float INVISIBLE = 2;

// for exploders
float USE_PARTICLES = 1;

// for particle fields
float USE_COUNT = 1;

// for counters
float COUNTER_TOGGLE = 1;
float COUNTER_LOOP = 2;
float COUNTER_STEP = 4;
float COUNTER_RESET = 8;
float COUNTER_RANDOM = 16;
float COUNTER_FINISHCOUNT = 32;
float COUNTER_START_ON = 64;

// for earthquakes
float earthquake;
float quakeactive;

// for rotating stuff
float STATE_ACTIVE      = 0;
float STATE_INACTIVE    = 1;
float STATE_SPEEDINGUP  = 2;
float STATE_SLOWINGDOWN = 3;
float STATE_CLOSED   = 4;
float STATE_OPEN     = 5;
float STATE_OPENING  = 6;
float STATE_CLOSING  = 7;
float STATE_WAIT = 0;
float STATE_MOVE = 1;
float STATE_STOP = 2;
float STATE_FIND = 3;
float STATE_NEXT = 4;
float OBJECT_ROTATE = 0;
float OBJECT_MOVEWALL  = 1;
float OBJECT_SETORIGIN = 2;
float TOGGLE   = 1;
float START_ON = 2;
float ROTATION = 1;
float ANGLES   = 2;
float STOP     = 4;
float NO_ROTATE = 8;
float DAMAGE   = 16;
float MOVETIME = 32;
float SET_DAMAGE = 64;
float VISIBLE = 1;
float TOUCH = 2;
float NONBLOCKING = 4;
float STAYOPEN = 1;

//=========================
//
// SUB_CopyEntity
//
//=========================

void (entity srcent, entity destent) SUB_CopyEntity =
   {
   destent.modelindex=srcent.modelindex;
   destent.absmin=srcent.absmin;
   destent.absmax=srcent.absmax;
   destent.ltime=srcent.ltime;
   destent.movetype=srcent.movetype;
   destent.solid=srcent.solid;
   destent.origin=srcent.origin;
   destent.oldorigin=srcent.oldorigin;
   destent.velocity=srcent.velocity;
   destent.angles=srcent.angles;
   destent.avelocity=srcent.avelocity;
   destent.punchangle=srcent.punchangle;
   destent.classname=srcent.classname;
   destent.model=srcent.model;
   destent.frame=srcent.frame;
   destent.skin=srcent.skin;
   destent.effects=srcent.effects;
   destent.mins=srcent.mins;
   destent.maxs=srcent.maxs;
   destent.size=srcent.size;
   destent.touch=srcent.touch;
   destent.use=srcent.use;
   destent.think=srcent.think;
   destent.blocked=srcent.blocked;
   destent.nextthink=srcent.nextthink;
   destent.groundentity=srcent.groundentity;
   destent.health=srcent.health;
   destent.frags=srcent.frags;
   destent.weapon=srcent.weapon;
   destent.weaponmodel=srcent.weaponmodel;
   destent.weaponframe=srcent.weaponframe;
   destent.currentammo=srcent.currentammo;
   destent.ammo_shells=srcent.ammo_shells;
   destent.ammo_nails=srcent.ammo_nails;
   destent.ammo_rockets=srcent.ammo_rockets;
   destent.ammo_cells=srcent.ammo_cells;
   destent.items=srcent.items;
   destent.takedamage=srcent.takedamage;
   destent.chain=srcent.chain;
   destent.deadflag=srcent.deadflag;
   destent.view_ofs=srcent.view_ofs;
   destent.button0=srcent.button0;
   destent.button1=srcent.button1;
   destent.button2=srcent.button2;
   destent.impulse=srcent.impulse;
   destent.fixangle=srcent.fixangle;
   destent.v_angle=srcent.v_angle;
   destent.idealpitch=srcent.idealpitch;
   destent.netname=srcent.netname;
   destent.enemy=srcent.enemy;
   destent.flags=srcent.flags;
   destent.colormap=srcent.colormap;
   destent.team=srcent.team;
   destent.max_health=srcent.max_health;
   destent.teleport_time=srcent.teleport_time;
   destent.armortype=srcent.armortype;
   destent.armorvalue=srcent.armorvalue;
   destent.waterlevel=srcent.waterlevel;
   destent.watertype=srcent.watertype;
   destent.ideal_yaw=srcent.ideal_yaw;
   destent.yaw_speed=srcent.yaw_speed;
   destent.aiment=srcent.aiment;
   destent.goalentity=srcent.goalentity;
   destent.spawnflags=srcent.spawnflags;
   destent.target=srcent.target;
   destent.targetname=srcent.targetname;
   destent.dmg_take=srcent.dmg_take;
   destent.dmg_save=srcent.dmg_save;
   destent.dmg_inflictor=srcent.dmg_inflictor;
   destent.owner=srcent.owner;
   destent.movedir=srcent.movedir;
   destent.message=srcent.message;
   destent.sounds=srcent.sounds;
   destent.noise=srcent.noise;
   destent.noise1=srcent.noise1;
   destent.noise2=srcent.noise2;
   destent.noise3=srcent.noise3;
   destent.wad=srcent.wad;
   destent.map=srcent.map;
   destent.worldtype=srcent.worldtype;
   destent.killtarget=srcent.killtarget;
   destent.light_lev=srcent.light_lev;
   destent.style=srcent.style;
   destent.th_stand=srcent.th_stand;
   destent.th_walk=srcent.th_walk;
   destent.th_run=srcent.th_run;
   destent.th_missile=srcent.th_missile;
   destent.th_melee=srcent.th_melee;
   destent.th_pain=srcent.th_pain;
   destent.th_die=srcent.th_die;
   destent.th_turn=srcent.th_turn;
   destent.oldenemy=srcent.oldenemy;
   destent.speed=srcent.speed;
   destent.lefty=srcent.lefty;
   destent.search_time=srcent.search_time;
   destent.attack_state=srcent.attack_state;
   destent.walkframe=srcent.walkframe;
   destent.attack_finished=srcent.attack_finished;
   destent.pain_finished=srcent.pain_finished;
   destent.invincible_finished=srcent.invincible_finished;
   destent.invisible_finished=srcent.invisible_finished;
   destent.super_damage_finished=srcent.super_damage_finished;
   destent.radsuit_finished=srcent.radsuit_finished;
   destent.invincible_time=srcent.invincible_time;
   destent.invincible_sound=srcent.invincible_sound;
   destent.invisible_time=srcent.invisible_time;
   destent.invisible_sound=srcent.invisible_sound;
   destent.super_time=srcent.super_time;
   destent.super_sound=srcent.super_sound;
   destent.rad_time=srcent.rad_time;
   destent.fly_sound=srcent.fly_sound;
   destent.axhitme=srcent.axhitme;
   destent.show_hostile=srcent.show_hostile;
   destent.jump_flag=srcent.jump_flag;
   destent.swim_flag=srcent.swim_flag;
   destent.air_finished=srcent.air_finished;
   destent.bubble_count=srcent.bubble_count;
   destent.deathtype=srcent.deathtype;
   destent.mdl=srcent.mdl;
   destent.mangle=srcent.mangle;
   destent.oldorigin=srcent.oldorigin;
   destent.t_length=srcent.t_length;
   destent.t_width=srcent.t_width;
   destent.dest=srcent.dest;
   destent.dest1=srcent.dest1;
   destent.dest2=srcent.dest2;
   destent.wait=srcent.wait;
   destent.delay=srcent.delay;
   destent.trigger_field=srcent.trigger_field;
   destent.noise4=srcent.noise4;
   destent.pausetime=srcent.pausetime;
   destent.movetarget=srcent.movetarget;
   destent.aflag=srcent.aflag;
   destent.dmg=srcent.dmg;
   destent.cnt=srcent.cnt;
   destent.think1=srcent.think1;
   destent.finaldest=srcent.finaldest;
   destent.finalangle=srcent.finalangle;
   destent.count=srcent.count;
   destent.lip=srcent.lip;
   destent.state=srcent.state;
   destent.pos1=srcent.pos1;
   destent.pos2=srcent.pos2;
   destent.height=srcent.height;
   destent.waitmin=srcent.waitmin;
   destent.waitmax=srcent.waitmax;
   destent.distance=srcent.distance;
   destent.volume=srcent.volume;
   destent.gorging=srcent.gorging;
   destent.stoleweapon=srcent.stoleweapon;
   destent.spawnfunction=srcent.spawnfunction;
   destent.spawnthink=srcent.spawnthink;
   destent.spawnmodel=srcent.spawnmodel;
   destent.spawnsolidtype=srcent.spawnsolidtype;
   destent.spawnmins=srcent.spawnmins;
   destent.spawnmaxs=srcent.spawnmaxs;
   destent.spawnclassname=srcent.spawnclassname;
   };

//=========================
//
// SUB_NormalizeAngles
//
//=========================

vector ( vector ang ) SUB_NormalizeAngles =
   {
   while( ang_x > 360 )
      {
      ang_x = ang_x - 360;
      }
   while( ang_x < 0 )
      {
      ang_x = ang_x + 360;
      }

   while( ang_y > 360 )
      {
      ang_y = ang_y - 360;
      }
   while( ang_y < 0 )
      {
      ang_y = ang_y + 360;
      }

   while( ang_z > 360 )
      {
      ang_z = ang_z - 360;
      }
   while( ang_z < 0 )
      {
      ang_z = ang_z + 360;
      }

   return ang;
   };

void() damagethreshold_killed =
	{
	self.health = self.max_health;

//   self.solid = SOLID_NOT;
   activator = damage_attacker;
	self.takedamage = DAMAGE_NO;
	SUB_UseTargets ();
	self.takedamage = DAMAGE_YES;

	if ( !( self.spawnflags & MULTI_USE ) )
	   {
	   remove( self );
	   }
	};

void() damagethreshold_pain =
	{
	self.health = self.max_health;
	};

/*QUAKED trigger_damagethreshold (0 .5 .8) ? MULTI_USE INVISIBLE
Triggers only when a threshold of damage is exceeded.
When used in conjunction with func_breakawaywall, allows
walls that may be destroyed with a rocket blast.

MULTI_USE tells the trigger to not to remove itself after
being fired.  Allows the trigger to be used multiple times.

INVISIBLE tells the trigger to not be visible.

"health" specifies how much damage must occur before trigger fires.
Default is 60.

*/

void() trigger_damagethreshold =

{
	self.mangle = self.angles;
	self.angles = '0 0 0';

	self.classname = "damagethreshold";
   self.solid = SOLID_BSP;
   self.movetype = MOVETYPE_PUSH;
   setorigin (self, self.origin);
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
   if ( self.spawnflags & INVISIBLE )
      {
      self.model = string_null;
      }

	if (!self.health)
		{
		self.health = 60;
		}
	self.max_health = self.health;
	self.takedamage = DAMAGE_YES;

	self.blocked = SUB_Null;
	self.th_pain = damagethreshold_pain;
	self.th_die  = damagethreshold_killed;
	};

/*QUAKED func_breakawaywall (0 .5 .8) ?
Special walltype that removes itself when triggered.
*/

void() func_breakawaywall =
	{
	self.mangle = self.angles;
	self.angles = '0 0 0';

	self.classname = "breakaway";
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
	self.use = SUB_Remove;
	};

void() BecomeExplosion;

void() exploder_fire =
	{
	local entity temp;

	temp = self;
	activator = other;
	SUB_UseTargets ();
	self = temp;
	other = self;
   if (self.dmg<120)
      {
      sound (self , CHAN_AUTO, "misc/shortexp.wav", self.volume, self.speed);
      }
   else
      {
      sound (self , CHAN_AUTO, "misc/longexpl.wav", self.volume, self.speed);
      }
   T_RadiusDamage (self, self.owner, self.dmg, other);
   if (self.spawnflags & USE_PARTICLES)
      {
      WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST, TE_EXPLOSION);
      WriteCoord (MSG_BROADCAST, self.origin_x);
      WriteCoord (MSG_BROADCAST, self.origin_y);
      WriteCoord (MSG_BROADCAST, self.origin_z);
      }
   BecomeExplosion();
	};

void() exploder_use =
	{
	if (self.delay)
		{
		self.nextthink = time + self.delay;
		self.delay = 0;
		self.think = exploder_fire;
		}
	else
		{
		exploder_fire();
		}
	};

/*QUAKED func_exploder (0.4 0 0) (0 0 0) (8 8 8) particles
  Spawns an explosion when triggered.  Triggers any targets.

  "dmg" specifies how much damage to cause.  Negative values
  indicate no damage.  Default or 0 indicates 120.
  "volume" volume at which to play explosions (default 1.0)
  "speed" attenuation for explosions (default normal)
*/
void() func_exploder =
	{
   precache_sound ("misc/shortexp.wav");
   precache_sound ("misc/longexpl.wav");
	self.classname = "exploder";
	self.use = exploder_use;
	if ( self.dmg == 0 )
	   {
	   self.dmg = 120;
	   }
	if ( self.dmg < 0 )
	   {
	   self.dmg = 0;
	   }
   if ( self.speed == 0 )
	   {
      self.speed = 1;
	   }
   if ( self.volume == 0 )
	   {
      self.volume = 1.0;
	   }
   };

void() multi_exploder_fire =
	{
	local entity temp;
   local entity expl;

   self.nextthink = time + self.wait;
   if (self.state == 0)
      {
      self.state = 1;
      self.duration = time + self.duration;
      temp = self;
      activator = other;
      SUB_UseTargets ();
      self = temp;
      other = self;
      }
   if (time > self.duration)
      {
      remove(self);
      return;
      }
   expl = spawn();
   expl.owner = self.owner;
   expl.dmg = self.dmg;
   expl.origin_x = self.absmin_x + (random() * (self.absmax_x - self.absmin_x));
   expl.origin_y = self.absmin_y + (random() * (self.absmax_y - self.absmin_y));
   expl.origin_z = self.absmin_z + (random() * (self.absmax_z - self.absmin_z));
   sound (expl , CHAN_VOICE, "misc/shortexp.wav", self.volume, self.speed);
   T_RadiusDamage (expl, self.owner, self.dmg, other);
   if (self.spawnflags & USE_PARTICLES)
      {
      WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST, TE_EXPLOSION);
      WriteCoord (MSG_BROADCAST, expl.origin_x);
      WriteCoord (MSG_BROADCAST, expl.origin_y);
      WriteCoord (MSG_BROADCAST, expl.origin_z);
      }
   temp = self;
   self = expl;
   BecomeExplosion();
   self = temp;
	};

void( vector loc, float rad, float damage, float dur, float pause, float vol) multi_explosion =
	{
   local entity temp;

   temp = self;
   self = spawn();
   self.origin = loc;
   self.dmg = damage;
   self.duration = dur;
   self.wait = pause;
   self.owner = world;
   self.absmin = self.origin - (rad * '1 1 1');
   self.absmax = self.origin + (rad * '1 1 1');
   self.think = multi_exploder_fire;
   self.volume = vol;
   multi_exploder_fire();
   self = temp;
	};

void() multi_exploder_use =
	{
   if (self.delay)
		{
		self.nextthink = time + self.delay;
		self.delay = 0;
      self.think = multi_exploder_fire;
      }
	else
		{
      self.think = multi_exploder_fire;
      multi_exploder_fire();
		}
	};

/*QUAKED func_multi_exploder (0.4 0 0) ?
  Spawns an explosion when triggered.  Triggers any targets.
  size of brush determines where explosions will occur.

  "dmg" specifies how much damage to cause from each explosion
  Negative values indicate no damage.  Default or 0 indicates 120.
  "delay" delay before exploding (Default 0 seconds)
  "duration" how long to explode for (Default 1 second)
  "wait" time between each explosion (default 0.25 seconds)
  "volume" volume to play explosion sound at (default 0.5)
  "speed" attenuation for explosions (default normal)

*/
void() func_multi_exploder =
	{
   precache_sound ("misc/shortexp.wav");
   precache_sound ("misc/longexpl.wav");
	self.classname = "exploder";
   self.use = multi_exploder_use;
   setmodel(self,self.model);
   self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
   self.model = "";
	if ( self.dmg == 0 )
	   {
	   self.dmg = 120;
	   }
	if ( self.dmg < 0 )
	   {
	   self.dmg = 0;
	   }
   if (self.duration == 0)
      self.duration = 1.0;
   if (self.speed == 0)
      self.speed = 1.0;
   if (self.volume == 0)
      self.volume = 0.5;
   if (self.wait == 0)
      self.wait = 0.25;
   self.state = 0;
   };

void () particlefield_XZ =
	{
	local vector pos;
   local vector start;
   local vector end;

   if ( ( self.spawnflags & USE_COUNT ) &&
      ( counter_GetCount( other ) != self.cnt ) )
      {
      return;
      }
//   dprint( "XZ\n" );

   self.ltime = time + 0.25;
   if ( self.noise )
      {
      sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
      }

   // Only show particles if client is visible.
   // This helps to keep network traffic down to a minimum.
   if (!checkclient() )
      return;

   start = self.dest1 + self.origin;
   end   = self.dest2 + self.origin;
   pos_y = start_y;
   pos_z = start_z;
   while( pos_z <= end_z )
		{
      pos_x = start_x;
      while( pos_x <= end_x )
			{
         particle ( pos, '0 0 0', self.color, self.count );
         pos_x = pos_x + 16;
			}
      pos_z = pos_z + 16;
		}
	};

void () particlefield_YZ =
	{
	local vector pos;
   local vector start;
   local vector end;

   if ( ( self.spawnflags & USE_COUNT ) &&
      ( counter_GetCount( other ) != self.cnt ) )
      {
      return;
      }

//   dprint( "YZ: " );
//   dprint( vtos( self.dest1 ) );
//   dprint( " - " );
//   dprint( vtos( self.dest2 ) );
//   dprint( "\n" );
   self.ltime = time + 0.25;
   if ( self.noise )
      {
      sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
      }

   // Only show particles if client is visible.
   // This helps to keep network traffic down to a minimum.
   if (!checkclient() )
      return;

   start = self.dest1 + self.origin;
   end   = self.dest2 + self.origin;
   pos_x = start_x;
   pos_z = start_z;
   while( pos_z < end_z )
		{
      pos_y = start_y;
      while( pos_y < end_y )
			{
         particle ( pos, '0 0 0', self.color, self.count );
			pos_y = pos_y + 16;
			}
		pos_z = pos_z + 16;
		}
	};

void () particlefield_XY =
	{
	local vector pos;
   local vector start;
   local vector end;

   if ( ( self.spawnflags & USE_COUNT ) &&
      ( counter_GetCount( other ) != self.cnt ) )
      {
      return;
      }

//   dprint( "XY\n" );
   self.ltime = time + 0.25;
   if ( self.noise )
      {
      sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
      }

   // Only show particles if client is visible.
   // This helps to keep network traffic down to a minimum.
   if (!checkclient() )
      return;


   start = self.dest1 + self.origin;
   end   = self.dest2 + self.origin;
   pos_x = start_x;
   pos_z = start_z;
   while( pos_x < end_x )
		{
      pos_y = start_y;
      while( pos_y < end_y )
			{
         particle ( pos, '0 0 0', self.color, self.count );
			pos_y = pos_y + 16;
			}
		pos_x = pos_x + 16;
		}
	};

void () particlefield_touch =
	{
   if ( !self.dmg )
      return;

   if ( time > self.ltime)
      return;

	if (time < self.attack_finished)
		return;
	self.attack_finished = time + 0.5;
	T_Damage (other, self, self, self.dmg);
   };

/*QUAKED func_particlefield (0 .5 .8) ? USE_COUNT
Creates a brief particle flash roughly the size of the defining
brush each time it is triggered.

USE_COUNT when the activator is a func_counter, the field will only
   activate when count is equal to "cnt".  Same as using a func_oncount
   to trigger.

"cnt" is the count to activate on when USE_COUNT is set.
"color" is the color of the particles.  Default is 192 (yellow).
"count" is the density of the particles.  Default is 2.
"noise" is the sound to play when triggered.  Do not use a looping sound here.
"dmg" is the amount of damage to cause when touched.
*/

void() func_particlefield =
	{
   if ( !self.color )
	   {
      self.color = 192;
	   }
   if ( self.count == 0 )
	   {
      self.count = 2;
	   }
   self.classname = "particlefield";
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_NONE;
   setmodel (self, self.model);
   self.model = string_null;

   self.origin = ( self.mins + self.maxs ) * 0.5;
   setorigin (self, self.origin);
   self.dest = self.maxs - self.mins - '16 16 16';
   self.dest1 = self.mins + '8 8 8' - self.origin;
   self.dest2 = self.maxs + '7.9 7.9 7.9' - self.origin;
   setsize (self, self.mins, self.maxs);
   self.touch = particlefield_touch;
//   dprint( vtos( self.dest ) );
//   dprint( "  " );
   if ( self.dest_x > self.dest_z )
		{
      if ( self.dest_y > self.dest_z )
			{
//         dprint( "XY1 - " );
//         dprint( ftos( self.cnt ) );
//         dprint( "\n" );
         self.use = particlefield_XY;
         self.dest1_z = ( self.dest1_z + self.dest2_z ) / 2;
			}
		else
			{
//         dprint( "XZ1 - " );
//         dprint( ftos( self.cnt ) );
//         dprint( "\n" );
         self.use = particlefield_XZ;
         self.dest1_y = ( self.dest1_y + self.dest2_y ) / 2;
			}
		}
	else
		{
      if ( self.dest_y > self.dest_x )
         {
//         dprint( "YZ2 - " );
//         dprint( ftos( self.cnt ) );
//         dprint( "\n" );
         self.use = particlefield_YZ;
         self.dest1_x = ( self.dest1_x + self.dest2_x ) / 2;
			}
		else
			{
//         dprint( "XZ2 - " );
//         dprint( ftos( self.cnt ) );
//         dprint( "\n" );
         self.use = particlefield_XZ;
         self.dest1_y = ( self.dest1_y + self.dest2_y ) / 2;
			}
		}

   if ( self.noise )
      {
      precache_sound( self.noise );
      }
   self.ltime = time;
   };

void () blocker_touch =
	{
   if ( !self.dmg )
      return;

	if (time < self.attack_finished)
		return;
	self.attack_finished = time + 0.5;
	T_Damage (other, self, self, self.dmg);
   };

void () blocker_use =
	{
   if ( !self.state )
      {
      self.state = 1;
      setorigin( self, self.origin - '8000 8000 8000' );
      sound(self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
      }
   else
      {
      self.state = 0;
      setorigin( self, self.origin + '8000 8000 8000' );
      sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
      }
   };

/*QUAKED func_togglewall (0 .5 .8) ? START_OFF
Creates a invisible wall that can be toggled on and off.

START_OFF wall doesn't block until triggered.

"noise" is the sound to play when wall is turned off.
"noise1" is the sound to play when wall is blocking.
"dmg" is the amount of damage to cause when touched.
*/

void() func_togglewall =
	{
   self.classname = "togglewall";
   self.movetype = MOVETYPE_PUSH;
   self.mdl = self.model;
   setmodel (self, self.model);
   setsize (self, self.mins, self.maxs);
   setorigin (self, self.origin);
   self.touch = blocker_touch;
   self.use = blocker_use;
   if ( !self.noise )
      {
      self.noise = ("misc/null.wav");
      }
   if ( !self.noise1 )
      {
      self.noise1 = ("misc/null.wav");
      }

   precache_sound( self.noise );
   precache_sound( self.noise1 );

   self.solid = SOLID_BSP;
   self.model = string_null;
   if ( self.spawnflags & START_OFF )
      {
      self.state = 0;
      setorigin( self, self.origin + '8000 8000 8000' );
      }
   else
      {
      self.state = 1;
      sound(self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
      }
   };

void() push_use =
	{
	local vector delta;
	local float x;
	local float y;

//	walkmove (other.angles_y, 16 * frametime);
/*
	if ( (other.angles_y >= 315) || (other.angles_y < 45))
		{
		walkmove ( 0, 16 * frametime);
		}
	else if ( (other.angles_y >= 45) && (other.angles_y < 135))
		{
		walkmove ( 90, 16 * frametime);
		}
	else if ( (other.angles_y >= 135) && (other.angles_y < 225))
		{
		walkmove ( 180, 16 * frametime);
		}
	else if ( (other.angles_y >= 225) && (other.angles_y < 315))
		{
		walkmove ( 270, 16 * frametime);
		}
	else
		{
		return;
		}
*/
	makevectors(other.angles);
	
//	x = fabs( v_forward_x );
//	y = fabs( v_forward_y );
	x = fabs( other.velocity_x );
	y = fabs( other.velocity_y );
	dprint( ftos( x ) );
	dprint( ", " );
	dprint( ftos( y ) );
	if ( x > y )
		{
		dprint( " x move\n\n\n\n" );
		if ( other.velocity_x > 0 )
			{
			walkmove ( 0, 16 * frametime);
			}
		else
			{
			walkmove( 180, 16 * frametime );
			}
		}
	else
		{
		dprint( " y move\n\n\n\n" );
		if ( other.velocity_y > 0 )
			{
			walkmove ( 90, 16 * frametime);
			}
		else
			{
			walkmove( 270, 16 * frametime );
			}
		}
	
	delta = self.origin - self.oldorigin;
	setorigin (self.owner, self.owner.oldorigin + delta );
	};

/*QUAKED func_pushable (0 .5 .8) ?
Pushable walls.
*/

void() func_pushable =
	{
	local entity new;
	local vector newsize;

	self.mangle = self.angles;
	self.angles = '0 0 0';

	self.classname = "pushablewall";
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setmodel (self, self.model);
	setorigin( self, self.origin );
	setsize (self, self.mins, self.maxs );
	self.oldorigin = self.origin;

	new = spawn();
	new.owner = self;
	new.mangle = self.mangle;
	new.angles = self.angles;

	new.classname = "pushablewallproxy";
	new.solid = SOLID_BBOX;
	new.movetype = MOVETYPE_STEP;
	new.origin = ( self.mins + self.maxs ) * 0.5 + '0 0 1';
	newsize = ( self.maxs - self.mins ) * 0.5;
   new.mins = '-1 -1 0' - newsize;
   new.maxs = '1 1 -2' + newsize;
	setsize( new, new.mins, new.maxs );
	setorigin( new, new.origin );
	new.oldorigin = new.origin;
 	new.touch = push_use;
   };

void() clock_setpos =
   {
   local float pos;
   local float ang;
   local float seconds;
   local string temp;

   // How much time has elapsed.
   seconds = time + self.cnt;

   // divide by time it takes for one revolution
   pos = seconds / self.count;

   // chop off non-fractional component
   pos = pos - floor( pos );

   ang = 360 * pos;
   if ( self.event )
      {
      if ( self.ltime > ang )
         {
         // past twelve
         temp = self.target;
         self.target = self.event;
         SUB_UseTargets();
         self.target = temp;
         }
      }

   self.angles_x = ang * self.movedir_x;
   self.angles_y = ang * self.movedir_y;
   self.angles_z = ang * self.movedir_z;
   RotateTargetsFinal();

   self.ltime = ang;
   };

void() clock_think =
	{
   clock_setpos();
   self.nextthink = time + 1;
   };

void() clock_firstthink =
   {
   LinkRotateTargets();
   self.think = clock_think;
   clock_think();
   };

/*QUAKED func_clock (0 0 0.5) (0 0 0) (32 32 32)
Creates one hand of a "clock".

Set the angle to be the direction the clock is facing.

"event" is the targetname of the entities to trigger when hand strikes 12.
"cnt" is the time to start at.
"count" is the # of seconds it takes to make a full revolution (seconds is 60, minutes 3600, hours 43200).  default is 60.
*/

void() func_clock =
	{
   local vector temp;

   self.classname = "clock";
   self.think = clock_firstthink;
   self.nextthink = time + 0.1;
   self.ltime = time;
   SetMovedir();
   temp = self.movedir;
   self.movedir_x = 0 - temp_y;
   self.movedir_y = 0 - temp_z;
   self.movedir_z = 0 - temp_x;

   if ( !self.count )
      {
      self.count = 60;
      }
   self.cnt = self.cnt * ( self.count / 12 );
   };

void() counter_on_use;
void() counter_off_use;

void() counter_think =
	{
	self.cnt = self.cnt + 1;
	if ( self.spawnflags & COUNTER_RANDOM )
		{
		self.state = random() * self.count;
		self.state = floor( self.state ) + 1;
		}
	else
		{
		self.state = self.cnt;
		}

	activator = other;
	SUB_UseTargets();
	self.nextthink = time + self.wait;

	if ( self.spawnflags & COUNTER_STEP )
		{
		counter_on_use();
		}

	if ( self.cnt >= self.count )
		{
		self.cnt = 0;
		if ( ( self.aflag ) || !( self.spawnflags & COUNTER_LOOP ) )
			{
			if (self.spawnflags & COUNTER_TOGGLE)
				{
				counter_on_use();
				}
			else
				{
				remove (self);
				}
			}
		}
	};

void() counter_on_use =
	{
	if ( ( self.cnt != 0 ) && ( self.spawnflags & COUNTER_FINISHCOUNT ) )
		{
		self.aflag = TRUE;
		return;
		}

	self.use = counter_off_use;
	self.think = SUB_Null;
	self.aflag = FALSE;
	};

void() counter_off_use =
	{
	self.aflag = FALSE;
	if (self.spawnflags & COUNTER_TOGGLE)
		{
		self.use = counter_on_use;
		}
	else
		{
		self.use = SUB_Null;
		}

	if ( self.spawnflags & COUNTER_RESET )
		{
		self.cnt = 0;
		self.state = 0;
		}
	self.think = counter_think;
	if (self.delay)
		{
		self.nextthink = time + self.delay;
		}
	else
		{
		counter_think();
		}
	};

float( entity counter ) counter_GetCount =
	{
	local float value;

	if ( counter.classname == "counter" )
		{
		return counter.state;
		}
	return 0;
	};

/*QUAKED func_counter (0 0 0.5) (0 0 0) (32 32 32) TOGGLE LOOP STEP RESET RANDOM FINISHCOUNT START_ON
TOGGLE causes the counter to switch between an on and off state
each time the counter is triggered.

LOOP causes the counter to repeat infinitly.  The count resets to zero
after reaching the value in "count".

STEP causes the counter to only increment when triggered.  Effectively,
this turns the counter into a relay with counting abilities.

RESET causes the counter to reset to 0 when restarted.

RANDOM causes the counter to generate random values in the range 1 to "count"
at the specified interval.

FINISHCOUNT causes the counter to continue counting until it reaches "count"
before shutting down even after being set to an off state.

START_ON causes the counter to be on when the level starts.

"count" specifies how many times to repeat the event.  If LOOP is set,
it specifies how high to count before reseting to zero.  Default is 10.

"wait"  the length of time between each trigger event. Default is 1 second.

"delay" how much time to wait before firing after being switched on.
*/

void() func_counter =
	{
	if ( !self.wait )
	   {
	   self.wait = 1;
	   }

	self.count = floor( self.count );
	if ( self.count <= 0 )
	   {
	   self.count = 10;
	   }
	self.cnt = 0;
	self.state = 0;

	self.classname = "counter";
	self.use = counter_off_use;
	self.think = SUB_Null;
   if ( self.spawnflags & COUNTER_START_ON )
      {
      self.think = counter_off_use;
      self.nextthink = time + 0.1;
      }
	};

void() oncount_use =
	{
	if ( counter_GetCount( other ) == self.count )
		{
		activator = other;
		SUB_UseTargets();
		}
	};

/*QUAKED func_oncount (0 0 0.5) (0 0 0) (16 16 16)
Must be used as the target for func_counter.  When the counter
reaches the value set by count, func_oncount triggers its targets.

"count" specifies the value to trigger on.  Default is 1.

"delay" how much time to wait before firing after being triggered.
*/

void() func_oncount =
	{
	self.count = floor( self.count );
	if ( self.count <= 0 )
	   {
	   self.count = 1;
	   }

	self.classname = "oncount";
	self.use = oncount_use;
	self.think = SUB_Null;
	};

void() StopEarthQuake =
   {
   earthquake = 0;
   };

void( float value ) EarthQuakeTime =
   {
   value = value + time;
   if ( value > earthquake )
      {
      earthquake = value;
      }
   };

void() earthquake_prethink =
   {
//   if ( lastearthquake )
//      {
//      self.view_ofs_z = self.savedz;
//      lastearthquake = 0;
//      }
   };

void() earthquake_postthink =
	{
	if ( earthquake > time )
		{
      if (quakeactive == 0)
         {
         sound (self, CHAN_VOICE, "misc/quake.wav", 1, ATTN_NONE);
         quakeactive = 1;
         }
//      lastearthquake = 1;
//      self.savedz = self.view_ofs_z;
		if ( self.flags & FL_ONGROUND )
			{
//         self.view_ofs_z = self.view_ofs_z - 5 + random() * 10;
         self.velocity = self.velocity + (random() * '0 0 150');
         }
		}
   else
      {
      if (quakeactive == 1)
         {
         sound (self, CHAN_VOICE, "misc/quakeend.wav", 1, ATTN_NONE);
         quakeactive = 0;
         }
      }
	};

void() earthquake_use =
	{
	EarthQuakeTime( self.dmg );
	};

/*QUAKED func_earthquake (0 0 0.5) (0 0 0) (32 32 32)
Causes an earthquake.  Triggers targets.

"dmg" is the duration of the earthquake.  Default is 0.8 seconds.
*/

void() func_earthquake =
	{
   quakeactive = 0;
   precache_sound("misc/quake.wav");
   precache_sound("misc/quakeend.wav");
   self.classname = "earthquake";
	self.use = earthquake_use;
	self.think = SUB_Null;
	if ( !self.dmg )
	   {
	   self.dmg = 0.8;
	   }
	};

/*QUAKED info_rotate (0 0.5 0) (-4 -4 -4) (4 4 4)
Used as the point of rotation for rotatable objects.
*/
void() info_rotate =
{
// remove self after a little while, to make sure that entities that
// have targeted it have had a chance to spawn
   self.nextthink = time + 2;
   self.think = SUB_Remove;
};

void() RotateTargets =
   {
   local entity ent;
   local vector vx;
   local vector vy;
   local vector vz;
   local vector org;

   makevectors (self.angles);

   ent = find( world, targetname, self.target);
   while( ent )
      {
      if ( ent.rotate_type == OBJECT_SETORIGIN )
         {
         org = ent.oldorigin;
         vx = ( v_forward * org_x );
         vy = ( v_right   * org_y );
         vy = vy * -1;
         vz = ( v_up      * org_z );
         ent.neworigin = vx + vy + vz;
         setorigin( ent, ent.neworigin + self.origin );
         }
      else if ( ent.rotate_type == OBJECT_ROTATE )
         {
         ent.angles = self.angles;
         org = ent.oldorigin;
         vx = ( v_forward * org_x );
         vy = ( v_right   * org_y );
         vy = vy * -1;
         vz = ( v_up      * org_z );
         ent.neworigin = vx + vy + vz;
         setorigin( ent, ent.neworigin + self.origin );
         }
      else
         {
         org = ent.oldorigin;
         vx = ( v_forward * org_x );
         vy = ( v_right   * org_y );
         vy = vy * -1;
         vz = ( v_up      * org_z );
         ent.neworigin = vx + vy + vz;
         ent.neworigin = self.origin - self.oldorigin + (ent.neworigin - ent.oldorigin);
         ent.velocity = (ent.neworigin-ent.origin)*25;
         }
      ent = find( ent, targetname, self.target);
      }
   };

void() RotateTargetsFinal =
   {
   local entity ent;

   ent = find( world, targetname, self.target);
   while( ent )
      {
      ent.velocity = '0 0 0';
      if ( ent.rotate_type == OBJECT_ROTATE )
         {
         ent.angles = self.angles;
         }
      ent = find( ent, targetname, self.target);
      }
   };

void() SetTargetOrigin =
   {
   local entity ent;

   ent = find( world, targetname, self.target);
   while( ent )
      {
      if ( ent.rotate_type == OBJECT_MOVEWALL )
         {
         setorigin( ent, self.origin - self.oldorigin +
            (ent.neworigin - ent.oldorigin) );
         }
      else
         {
         setorigin( ent, ent.neworigin + self.origin );
         }
      ent = find( ent, targetname, self.target);
      }
   };

void() LinkRotateTargets =
   {
   local entity ent;
   local vector tempvec;

   self.oldorigin = self.origin;
   ent = find( world, targetname, self.target);
   while( ent )
      {
      if ( ent.classname == "rotate_object" )
         {
         ent.rotate_type = OBJECT_ROTATE;
         ent.oldorigin = ent.origin - self.oldorigin;
         ent.neworigin = ent.origin - self.oldorigin;
         ent.owner = self;
         }
      else if ( ent.classname == "func_movewall" )
         {
         ent.rotate_type = OBJECT_MOVEWALL;
         tempvec = ( ent.absmin + ent.absmax ) * 0.5;
         ent.oldorigin = tempvec - self.oldorigin;
         ent.neworigin = ent.oldorigin;
         ent.owner = self;
         }
      else
         {
         ent.rotate_type = OBJECT_SETORIGIN;
         ent.oldorigin = ent.origin - self.oldorigin;
         ent.neworigin = ent.origin - self.oldorigin;
         }
      ent = find (ent, targetname, self.target);
      }
   };

void( float amount ) SetDamageOnTargets =
   {
   local entity ent;

   ent = find( world, targetname, self.target);
   while( ent )
      {
      if ( ent.classname == "trigger_hurt" )
         {
         hurt_setdamage( ent, amount );
         }
      else if ( ent.classname == "func_movewall" )
         {
         ent.dmg = amount;
         }
      ent = find( ent, targetname, self.target);
      }
   };


//************************************************
//
// Simple continual rotatation
//
//************************************************

void() rotate_entity_think =
   {
   local float t;

   t = time - self.ltime;
   self.ltime = time;

   if ( self.state == STATE_SPEEDINGUP )
      {
      self.count = self.count + self.cnt * t;
      if ( self.count > 1 )
         {
         self.count = 1;
         }

      // get rate of rotation
      t = t * self.count;
      }
   else if ( self.state == STATE_SLOWINGDOWN )
      {
      self.count = self.count - self.cnt * t;
      if ( self.count < 0 )
         {
         RotateTargetsFinal();
         self.state = STATE_INACTIVE;
         self.think = SUB_Null;
         return;
         }

      // get rate of rotation
      t = t * self.count;
      }

   self.angles = self.angles + ( self.rotate * t );
   self.angles = SUB_NormalizeAngles( self.angles );
   RotateTargets();
   self.nextthink = time + 0.02;
   };

void() rotate_entity_use =
   {
   // change to alternate textures
	self.frame = 1 - self.frame;

   if ( self.state == STATE_ACTIVE )
      {
      if ( self.spawnflags & TOGGLE )
         {
         if ( self.speed )
            {
            self.count = 1;
            self.state = STATE_SLOWINGDOWN;
            }
         else
            {
            self.state = STATE_INACTIVE;
            self.think = SUB_Null;
            }
         }
      }
   else if ( self.state == STATE_INACTIVE )
      {
      self.think = rotate_entity_think;
      self.nextthink = time + 0.02;
      self.ltime = time;
      if ( self.speed )
         {
         self.count = 0;
         self.state = STATE_SPEEDINGUP;
         }
      else
         {
         self.state = STATE_ACTIVE;
         }
      }
   else if ( self.state == STATE_SPEEDINGUP )
      {
      if ( self.spawnflags & TOGGLE )
         {
         self.state = STATE_SLOWINGDOWN;
         }
      }
   else
      {
      self.state = STATE_SPEEDINGUP;
      }
   };

void() rotate_entity_firstthink =
   {
   LinkRotateTargets();
   if ( self.spawnflags & START_ON )
      {
      self.state = STATE_ACTIVE;
      self.think = rotate_entity_think;
      self.nextthink = time + 0.02;
      self.ltime = time;
      }
   else
      {
      self.state = STATE_INACTIVE;
      self.think = SUB_Null;
      }
   self.use = rotate_entity_use;
   };

/*QUAKED func_rotate_entity (0 .5 .8) (-8 -8 -8) (8 8 8) TOGGLE START_ON
Creates an entity that continually rotates.  Can be toggled on and
off if targeted.

TOGGLE = allows the rotation to be toggled on/off

START_ON = wether the entity is spinning when spawned.  If TOGGLE is 0, entity can be turned on, but not off.

If "deathtype" is set with a string, this is the message that will appear when a player is killed by the train.

"rotate" is the rate to rotate.
"target" is the center of rotation.
"speed"  is how long the entity takes to go from standing still to full speed and vice-versa.
*/

void() func_rotate_entity =
   {
   self.solid    = SOLID_NOT;
   self.movetype = MOVETYPE_NONE;

   setmodel (self, self.model);
   setsize( self, self.mins, self.maxs );

   if ( self.speed != 0 )
      {
      self.cnt = 1 / self.speed;
      }

   self.think = rotate_entity_firstthink;
   self.nextthink = time + 0.1;
   self.ltime = time;
   };

//************************************************
//
// Train with rotation functionality
//
//************************************************

/*QUAKED path_rotate (0.5 0.3 0) (-8 -8 -8) (8 8 8) ROTATION ANGLES STOP NO_ROTATE DAMAGE MOVETIME SET_DAMAGE
 Path for rotate_train.

 ROTATION tells train to rotate at rate specified by "rotate".  Use '0 0 0' to stop rotation.

 ANGLES tells train to rotate to the angles specified by "angles" while traveling to this path_rotate.  Use values < 0 or > 360 to guarantee that it turns in a certain direction.  Having this flag set automatically clears any rotation.

 STOP tells the train to stop and wait to be retriggered.

 NO_ROTATE tells the train to stop rotating when waiting to be triggered.

 DAMAGE tells the train to cause damage based on "dmg".

 MOVETIME tells the train to interpret "speed" as the length of time to take moving from one corner to another.

 SET_DAMAGE tells the train to set all targets damage to "dmg"

 "noise" contains the name of the sound to play when train stops.
 "noise1" contains the name of the sound to play when train moves.
 "event" is a target to trigger when train arrives at path_rotate.
*/
void() path_rotate =
   {
   if ( self.noise )
      {
      precache_sound( self.noise );
      }
   if ( self.noise1 )
      {
      precache_sound( self.noise1 );
      }
   };


void() rotate_train;
void() rotate_train_next;
void() rotate_train_find;

void() rotate_train_think =
   {
   local float t;
   local float timeelapsed;

   t = time - self.ltime;
   self.ltime = time;

   if ( ( self.endtime ) && ( time >= self.endtime ) )
      {
      self.endtime = 0;
      if ( self.state == STATE_MOVE )
         {
         setorigin(self, self.finaldest);
         self.velocity = '0 0 0';
         }

      if (self.think1)
         self.think1();
      }
   else
      {
      timeelapsed = (time - self.cnt) * self.duration;
      if ( timeelapsed > 1 )
         timeelapsed = 1;
      setorigin( self, self.dest1 + ( self.dest2 * timeelapsed ) );
      }

   self.angles = self.angles + ( self.rotate * t );
   self.angles = SUB_NormalizeAngles( self.angles );
   RotateTargets();

   self.nextthink = time + 0.02;
   };

void() rotate_train_use =
   {
   if (self.think1 != rotate_train_find)
		{
		if ( self.velocity != '0 0 0' )
			return;		// already activated
      if ( self.think1 )
         {
         self.think1();
         }
      }
   };

void() rotate_train_wait =
	{
   self.state = STATE_WAIT;

   if ( self.goalentity.noise )
      {
      sound (self, CHAN_VOICE, self.goalentity.noise, 1, ATTN_NORM);
      }
   else
      {
      sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
      }
   if ( self.goalentity.spawnflags & ANGLES )
      {
      self.rotate = '0 0 0';
      self.angles = self.finalangle;
      }
   if ( self.goalentity.spawnflags & NO_ROTATE )
      {
      self.rotate = '0 0 0';
      }
   self.endtime = self.ltime + self.goalentity.wait;
   self.think1 = rotate_train_next;
   };

void() rotate_train_stop =
	{
   self.state = STATE_STOP;

   if ( self.goalentity.noise )
      {
      sound (self, CHAN_VOICE, self.goalentity.noise, 1, ATTN_NORM);
      }
   else
      {
      sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
      }
   if ( self.goalentity.spawnflags & ANGLES )
      {
      self.rotate = '0 0 0';
      self.angles = self.finalangle;
      }
   if ( self.goalentity.spawnflags & NO_ROTATE )
      {
      self.rotate = '0 0 0';
      }

   self.dmg = 0;
   self.think1 = rotate_train_next;
   };

void() rotate_train_next =
{
   local entity targ;
   local entity current;
   local vector   vdestdelta;
   local float    len, traveltime, div;
   local string temp;

   self.state = STATE_NEXT;

   current = self.goalentity;
   targ = find (world, targetname, self.path );
   if ( targ.classname != "path_rotate" )
      objerror( "Next target is not path_rotate" );

   if ( self.goalentity.noise1 )
      {
      self.noise1 = self.goalentity.noise1;
      }
   sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);

   self.goalentity = targ;
   self.path = targ.target;
   if (!self.path )
      objerror ("rotate_train_next: no next target");

   if ( targ.spawnflags & STOP )
      {
      self.think1 = rotate_train_stop;
      }
   else if (targ.wait)
		{
      self.think1 = rotate_train_wait;
      }
	else
		{
      self.think1 = rotate_train_next;
		}

   if ( current.event )
      {
      // Trigger any events that should happen at the corner.
      temp = self.target;
      self.target = current.event;
      self.message = current.message;
      SUB_UseTargets();
      self.target = temp;
      self.message = string_null;
      }

   if ( current.spawnflags & ANGLES )
      {
      self.rotate = '0 0 0';
      self.angles = self.finalangle;
      }

   if ( current.spawnflags & ROTATION )
      {
      self.rotate = current.rotate;
      }

   if ( current.spawnflags & DAMAGE )
      {
      self.dmg = current.dmg;
      }

   if ( current.spawnflags & SET_DAMAGE )
      {
      SetDamageOnTargets( current.dmg );
      }

   if ( current.speed == -1 )
		{
		// Warp to the next path_corner
      setorigin( self, targ.origin );
      self.endtime = self.ltime + 0.01;
      SetTargetOrigin();

      if ( targ.spawnflags & ANGLES )
         {
         self.angles = targ.angles;
         }

      self.duration = 1;         // 1 / duration
      self.cnt = time;           // start time
      self.dest2 = '0 0 0';      // delta
      self.dest1 = self.origin;  // original position
      self.finaldest = self.origin;
      }
	else
		{
      self.state = STATE_MOVE;

      self.finaldest = targ.origin;
      if (self.finaldest == self.origin)
         {
         self.velocity = '0 0 0';
         self.endtime = self.ltime + 0.1;

         self.duration = 1;        // 1 / duration
         self.cnt = time;          // start time
         self.dest2 = '0 0 0';     // delta
         self.dest1 = self.origin; // original position
         self.finaldest = self.origin;
         return;
         }
      // set destdelta to the vector needed to move
      vdestdelta = self.finaldest - self.origin;

      // calculate length of vector
      len = vlen (vdestdelta);

      if ( current.spawnflags & MOVETIME )
         {
         traveltime = current.speed;
         }
      else
         {
         // check if there's a speed change
         if (current.speed>0)
            self.speed = current.speed;

         if (!self.speed)
            objerror("No speed is defined!");

         // divide by speed to get time to reach dest
         traveltime = len / self.speed;
         }

      if (traveltime < 0.1)
         {
         self.velocity = '0 0 0';
         self.endtime = self.ltime + 0.1;
         if ( targ.spawnflags & ANGLES )
            {
            self.angles = targ.angles;
            }
         return;
         }

      // qcc won't take vec/float
      div = 1 / traveltime;

      if ( targ.spawnflags & ANGLES )
         {
         self.finalangle = SUB_NormalizeAngles( targ.angles );
         self.rotate = ( targ.angles - self.angles ) * div;
         }

      // set endtime to trigger a think when dest is reached
      self.endtime = self.ltime + traveltime;

      // scale the destdelta vector by the time spent traveling to get velocity
      self.velocity = vdestdelta * div;

      self.duration = div;      // 1 / duration
      self.cnt = time;          // start time
      self.dest2 = vdestdelta;  // delta
      self.dest1 = self.origin; // original position
      }
   };

void() rotate_train_find =
   {
   local entity targ;

   self.state = STATE_FIND;

   LinkRotateTargets();

   // the first target is the point of rotation.
   // the second target is the path.
   targ = find ( world, targetname, self.path);
   if ( targ.classname != "path_rotate" )
      objerror( "Next target is not path_rotate" );

   // Save the current entity
   self.goalentity = targ;

   if ( targ.spawnflags & ANGLES )
      {
      self.angles = targ.angles;
      self.finalangle = SUB_NormalizeAngles( targ.angles );
      }

   self.path = targ.target;
   setorigin (self, targ.origin );
   SetTargetOrigin();
   RotateTargetsFinal();
   self.think1 = rotate_train_next;
   if (!self.targetname)
      {
      // not triggered, so start immediately
      self.endtime = self.ltime + 0.1;
      }
   else
      {
      self.endtime = 0;
      }

   self.duration = 1;        // 1 / duration
   self.cnt = time;          // start time
   self.dest2 = '0 0 0';     // delta
   self.dest1 = self.origin; // original position
   };

/*QUAKED func_rotate_train (0 .5 .8) (-8 -8 -8) (8 8 8)
In path_rotate, set speed to be the new speed of the train after it reaches
the path change.  If speed is -1, the train will warp directly to the next
path change after the specified wait time.  If MOVETIME is set on the
path_rotate, the train to interprets "speed" as the length of time to
take moving from one corner to another.

"noise" contains the name of the sound to play when train stops.
"noise1" contains the name of the sound to play when train moves.
Both "noise" and "noise1" defaults depend upon "sounds" variable and
can be overridden by the "noise" and "noise1" variable in path_rotate.

Also in path_rotate, if STOP is set, the train will wait until it is
retriggered before moving on to the next goal.

Trains are moving platforms that players can ride.
"path" specifies the first path_rotate and is the starting position.
If the train is the target of a button or trigger, it will not begin moving until activated.
The func_rotate_train entity is the center of rotation of all objects targeted by it.

If "deathtype" is set with a string, this is the message that will appear when a player is killed by the train.

speed	default 100
dmg      default  0
sounds
1) ratchet metal
*/

void() rotate_train =
   {
   objerror ("rotate_train entities should be changed to rotate_object with\nfunc_rotate_train controllers\n");
   };

void() func_rotate_train =
   {
   if (!self.speed)
		self.speed = 100;
	if (!self.target)
      objerror ("rotate_train without a target");

   if ( !self.noise )
      {
      if (self.sounds == 0)
         {
         self.noise = ("misc/null.wav");
         }

      if (self.sounds == 1)
         {
         self.noise = ("plats/train2.wav");
         }
      }
   if ( !self.noise1 )
      {
      if (self.sounds == 0)
         {
         self.noise1 = ("misc/null.wav");
         }
      if (self.sounds == 1)
         {
         self.noise1 = ("plats/train1.wav");
         }
      }

   precache_sound( self.noise );
   precache_sound( self.noise1 );

   self.cnt = 1;
   self.solid    = SOLID_NOT;
   self.movetype = MOVETYPE_STEP;
   self.use = rotate_train_use;

   setmodel (self, self.model);
   setsize (self, self.mins, self.maxs);
	setorigin (self, self.origin);

// start trains on the second frame, to make sure their targets have had
// a chance to spawn
   self.ltime = time;
	self.nextthink = self.ltime + 0.1;
   self.endtime = self.ltime + 0.1;
   self.think = rotate_train_think;
   self.think1 = rotate_train_find;
   self.state = STATE_FIND;

   self.duration = 1;        // 1 / duration
   self.cnt = 0.1;           // start time
   self.dest2 = '0 0 0';     // delta
   self.dest1 = self.origin; // original position


   self.flags = self.flags | FL_ONGROUND;
   };

//************************************************
//
// Moving clip walls
//
//************************************************

void() rotate_door_reversedirection;
void() rotate_door_group_reversedirection;

void() movewall_touch =
   {
   if (time < self.owner.attack_finished)
		return;

   if ( self.dmg )
      {
      T_Damage (other, self, self.owner, self.dmg);
      self.owner.attack_finished = time + 0.5;
      }
   else if ( self.owner.dmg )
      {
      T_Damage (other, self, self.owner, self.owner.dmg);
      self.owner.attack_finished = time + 0.5;
      }
   };

void() movewall_blocked =
   {
   local entity temp;

   if (time < self.owner.attack_finished)
		return;

   self.owner.attack_finished = time + 0.5;

   if ( self.owner.classname == "func_rotate_door" )
      {
      temp = self;
      self = self.owner;
      rotate_door_group_reversedirection();
      self = temp;
      }

   if ( self.dmg )
      {
      T_Damage (other, self, self.owner, self.dmg);
      self.owner.attack_finished = time + 0.5;
      }
   else if ( self.owner.dmg )
      {
      T_Damage (other, self, self.owner, self.owner.dmg);
      self.owner.attack_finished = time + 0.5;
      }
   };

void() movewall_think =
   {
   self.ltime = time;
   self.nextthink = time + 0.02;
   };

/*QUAKED func_movewall (0 .5 .8) ? VISIBLE TOUCH NONBLOCKING
Used to emulate collision on rotating objects.

VISIBLE causes brush to be displayed.

TOUCH specifies whether to cause damage when touched by player.

NONBLOCKING makes the brush non-solid.  This is useless if VISIBLE is set.

"dmg" specifies the damage to cause when touched or blocked.
*/
void() func_movewall =
   {
   self.angles = '0 0 0';
   self.movetype = MOVETYPE_PUSH;
   if ( self.spawnflags & NONBLOCKING )
      {
      self.solid = SOLID_NOT;
      }
   else
      {
      self.solid = SOLID_BSP;
      self.blocked = movewall_blocked;
      }
   if ( self.spawnflags & TOUCH )
      {
      self.touch = movewall_touch;
      }
   setmodel (self,self.model);
   if ( !( self.spawnflags & VISIBLE ) )
      {
      self.model = string_null;
      }
   self.think = movewall_think;
   self.nextthink = time + 0.02;
   self.ltime = time;
   };

/*QUAKED rotate_object (0 .5 .8) ?
This defines an object to be rotated.  Used as the target of func_rotate_door.
*/
void() rotate_object =
   {
   self.classname = "rotate_object";
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_NONE;
   setmodel (self,self.model);
   setsize( self, self.mins, self.maxs );
   self.think = SUB_Null;
   };

//************************************************
//
// Rotating doors
//
//************************************************

void() rotate_door_think2 =
   {
   local float t;

   t = time - self.ltime;
   self.ltime = time;

   // change to alternate textures
   self.frame = 1 - self.frame;

   self.angles = self.dest;

   if ( self.state == STATE_OPENING )
      {
      self.state = STATE_OPEN;
      }
   else
      {
      if ( self.spawnflags & STAYOPEN )
         {
         rotate_door_group_reversedirection();
         return;
         }
      self.state = STATE_CLOSED;
      }

   sound(self, CHAN_VOICE, self.noise3, 1, ATTN_NORM);
   self.think = SUB_Null;

   RotateTargetsFinal();
   };

void() rotate_door_think =
   {
   local float t;

   t = time - self.ltime;
   self.ltime = time;

   if ( time < self.endtime )
      {
      self.angles = self.angles + ( self.rotate * t );
      RotateTargets();
      }
   else
      {
      self.angles = self.dest;
      RotateTargets();
      self.think = rotate_door_think2;
      }

   self.nextthink = time + 0.01;
   };

void() rotate_door_reversedirection =
   {
   local vector start;

   // change to alternate textures
	self.frame = 1 - self.frame;

   if ( self.state == STATE_CLOSING )
      {
      start = self.dest1;
      self.dest = self.dest2;
      self.state = STATE_OPENING;
      }
   else
      {
      start = self.dest2;
      self.dest = self.dest1;
      self.state = STATE_CLOSING;
      }

   sound(self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);

   self.rotate = ( self.dest - start ) * ( 1 / self.speed );
   self.think = rotate_door_think;
   self.nextthink = time + 0.02;
   self.endtime = time + self.speed - ( self.endtime - time );
   self.ltime = time;
   };

void() rotate_door_group_reversedirection =
   {
   local string name;

   // tell all associated rotaters to reverse direction
   if ( self.group )
      {
      name = self.group;
      self = find( world, group, name);
      while( self )
         {
         rotate_door_reversedirection();
         self = find( self, group, name);
         }
      }
   else
      {
      rotate_door_reversedirection();
      }
   };

void() rotate_door_use =
   {
   local entity t;
   local vector start;

   if ( ( self.state != STATE_OPEN ) && ( self.state != STATE_CLOSED ) )
      return;

   if ( !self.cnt )
      {
      self.cnt = 1;
      LinkRotateTargets();
      }

   // change to alternate textures
	self.frame = 1 - self.frame;

   if ( self.state == STATE_CLOSED )
      {
      start = self.dest1;
      self.dest = self.dest2;
      self.state = STATE_OPENING;
      }
   else
      {
      start = self.dest2;
      self.dest = self.dest1;
      self.state = STATE_CLOSING;
      }

   sound(self, CHAN_VOICE, self.noise2, 1, ATTN_NORM);

   self.rotate = ( self.dest - start ) * ( 1 / self.speed );
   self.think = rotate_door_think;
   self.nextthink = time + 0.01;
   self.endtime = time + self.speed;
   self.ltime = time;
   };


/*QUAKED func_rotate_door (0 .5 .8) (-8 -8 -8) (8 8 8) STAYOPEN
Creates a door that rotates between two positions around a point of
rotation each time it's triggered.

STAYOPEN tells the door to reopen after closing.  This prevents a trigger-
once door from closing again when it's blocked.

"dmg" specifies the damage to cause when blocked.  Defaults to 2.  Negative numbers indicate no damage.
"speed" specifies how the time it takes to rotate

"sounds"
1) medieval (default)
2) metal
3) base
*/

void() func_rotate_door =
   {
   if (!self.target)
      {
      objerror( "rotate_door without target." );
      }

   self.dest1 = '0 0 0';
   self.dest2 = self.angles;
   self.angles = self.dest1;

   // default to 2 seconds
   if ( !self.speed )
      {
      self.speed = 2;
      }

   self.cnt = 0;

   if (!self.dmg)
		self.dmg = 2;
   else if ( self.dmg < 0 )
      {
      self.dmg = 0;
      }

   if (self.sounds == 0)
      self.sounds = 1;
	if (self.sounds == 1)
	{
		precache_sound ("doors/latch2.wav");
		precache_sound ("doors/winch2.wav");
		precache_sound ("doors/drclos4.wav");
		self.noise1 = "doors/latch2.wav";
		self.noise2 = "doors/winch2.wav";
		self.noise3 = "doors/drclos4.wav";
	}
	if (self.sounds == 2)
	{
		precache_sound ("doors/airdoor1.wav");
		precache_sound ("doors/airdoor2.wav");
		self.noise2 = "doors/airdoor1.wav";
		self.noise1 = "doors/airdoor2.wav";
		self.noise3 = "doors/airdoor2.wav";
	}
	if (self.sounds == 3)
	{
		precache_sound ("doors/basesec1.wav");
		precache_sound ("doors/basesec2.wav");
		self.noise2 = "doors/basesec1.wav";
		self.noise1 = "doors/basesec2.wav";
		self.noise3 = "doors/basesec2.wav";
	}

   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_NONE;
   setmodel (self, self.model);
   setorigin( self, self.origin );
   setsize( self, self.mins, self.maxs );
   self.state = STATE_CLOSED;
   self.use = rotate_door_use;
   self.think = SUB_Null;
   };

void() hipRubbleTouch =
	{
	if ( self.ltime < self.pausetime )
	   return;
	   
	if (other.takedamage)
		{
		T_Damage (other, self, self.owner, 10 );
		sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
		self.pausetime = self.ltime + 0.1;
		}
	};

void(string rubblename) hipThrowRubble =
{
	local	entity new;
	
	new = spawn();
	new.origin = self.origin;
	setmodel (new, rubblename );
	setsize (new, '0 0 0', '0 0 0');
	new.velocity_x = 70 * crandom();
	new.velocity_y = 70 * crandom();
	new.velocity_z = 140 + 70 * random();
	new.movetype = MOVETYPE_BOUNCE;
	new.solid = SOLID_BBOX;
	new.avelocity_x = random()*600;
	new.avelocity_y = random()*600;
	new.avelocity_z = random()*600;
	new.think = SUB_Remove;
	new.touch = hipRubbleTouch;
	new.ltime = time;
	new.nextthink = time + 13 + random()*10;
	self.pausetime = time;
	new.frame = 0;
	new.flags = 0;
};

void() rubble_use =
	{
	local float which;
	local float index;
	
	index = 0;
	
	do 
	   {
		which = self.cnt;
		if ( self.cnt == 0 )
			{
			which = 1 + 3*random();
			which = floor( which );
			}
		if ( which == 1 )
		   {
		   hipThrowRubble( "progs/rubble1.mdl" );
		   }
		else if ( which == 2 )
		   {
		   hipThrowRubble( "progs/rubble3.mdl" );
		   }
		else
		   {
		   hipThrowRubble( "progs/rubble2.mdl" );
		   }
		index = index + 1;
		}
	while( index < self.count );
	};

/*QUAKED func_rubble (0.4 0.4 0.2) (0 0 0) (32 32 32)
  Spawns random sized rubble when triggered.  
  
  "count" is the number of pieces of rubble to spawn.  Default is 1.
*/
void() func_rubble =
	{
	precache_model ("progs/rubble1.mdl");
	precache_model ("progs/rubble2.mdl");
	precache_model ("progs/rubble3.mdl");
	precache_sound ("zombie/z_hit.wav");
	self.classname = "rubble";
	self.cnt = 0;
	self.use = rubble_use;
	};
	
/*QUAKED func_rubble1 (0.4 0.4 0.2) (0 0 0) (8 8 8)
  Spawns small rubble when triggered.  
  
  "count" is the number of pieces of rubble to spawn.  Default is 1.
*/
void() func_rubble1 =
	{
	precache_model ("progs/rubble1.mdl");
	precache_sound ("zombie/z_hit.wav");
	self.classname = "rubble1";
	self.cnt = 1;
	self.use = rubble_use;
	};
	
/*QUAKED func_rubble2 (0.4 0.4 0.2) (0 0 0) (16 16 16)
  Spawns medium rubble when triggered.  
  
  "count" is the number of pieces of rubble to spawn.  Default is 1.
*/
void() func_rubble2 =
	{
	precache_model ("progs/rubble3.mdl");
	precache_sound ("zombie/z_hit.wav");
	self.classname = "rubble2";
	self.cnt = 2;
	self.use = rubble_use;
	};
	
/*QUAKED func_rubble3 (0.4 0.4 0.2) (0 0 0) (32 32 32)
  Spawns large rubble when triggered.  
  
  "count" is the number of pieces of rubble to spawn.  Default is 1.
*/
void() func_rubble3 =
	{
	precache_model ("progs/rubble2.mdl");
	precache_sound ("zombie/z_hit.wav");
	self.classname = "rubble3";
	self.cnt = 3;
	self.use = rubble_use;
	};

//================
//
// spawn_think
//
//================

void() spawn_think =
   {
   self.think = spawn_think;
   self.nextthink = time + 1;
   };

//================
//
// spawn_use
//
//================

void() spawn_use =
   {
   local entity spawnentity;
   local entity tempself;

   if ((self.spawnmulti == 1) || (horn_active))
      {
      // spawn the new entity
      spawnentity = spawn();
      // copy the master mold
      SUB_CopyEntity(self.spawnmaster,spawnentity);
      }
   else
      {
      spawnentity = self.spawnmaster;
      }
   // restore the model
   spawnentity.model = spawnentity.spawnmodel;
   //restore solid flag
   spawnentity.solid = spawnentity.spawnsolidtype;
   //restore thinking function
   spawnentity.think = spawnentity.spawnthink;
   setmodel (spawnentity, spawnentity.model);
   setorigin (spawnentity, spawnentity.origin);
   spawnentity.mins = spawnentity.spawnmins;
   spawnentity.maxs = spawnentity.spawnmaxs;
   setsize (spawnentity, spawnentity.mins, spawnentity.maxs);
   // spawn the teleport effect
   if (self.spawnsilent == 0)
      spawn_tfog (spawnentity.origin);
//   horn_active = 0;
//   horn_charmer = find( world, classname, "player" );
   // call spawnentity think function
   if (horn_active)
      {
      spawnentity.charmer = horn_charmer;
      spawnentity.charmed = 1;
      }
//   if (spawnentity.think)
//      {
//      spawnentity.nextthink = time+0.1;
//      tempself = self;
//      self = spawnentity;
//      self.think();
//      self = tempself;
//      spawnentity.nextthink = time+0.1;
//      self.nextthink = 1;
//      if (spawnentity.nextthink < time)
//         spawnentity.nextthink = 1;
//      }
   // check to see if it is a monster
   if (spawnentity.flags & FL_MONSTER)
      {
      if ((self.spawnmulti != 0) && (horn_active == 0))
         {
         total_monsters = total_monsters + 1;
         WriteByte (MSG_BROADCAST, SVC_UPDATESTAT);
         WriteByte (MSG_BROADCAST, STAT_TOTALMONSTERS);
         WriteLong (MSG_BROADCAST, total_monsters);
         }
      // spawn the telefrag effect
//      if (self.spawnsilent == 0)
//         spawn_tdeath(spawnentity.origin, spawnentity);
      if (horn_active)
         {
         spawnentity.effects = spawnentity.effects | EF_DIMLIGHT;
//         spawnentity.effects = spawnentity.effects | EF_BRIGHTFIELD;
         }
      }
   if ((self.spawnmulti == 0) && (horn_active == 0))
      {
      remove(self);
      }
   };

//================
//
// func_spawn
//
//================
/*QUAKED func_spawn (0 .5 .8) (-32 -32 -24) (32 32 64) big/ambush megahealth
This will spawn a thing upon being used. The thing that
is spawned depends upon the value of "spawnfunction".
"spawnclassname" should contain the same value as "spawnfunction".
If "spawnfunction" is unspecified a random monster is chosen.
The angles, target and all flags are passed on
Think of it like setting up a normal entity.
"spawnsilent" set this to 1 if you want a silent spawn.
"spawnmulti" set this to 1 if you want this spawn to be reoccuring.
*/

void() func_spawn =
   {
   local entity tempself;
   local entity monster;
   local float tempdeathmatch;
   local float temptotal_monsters;
   local vector mn,mx;

//   if (deathmatch)
//   {
//      remove(self);
//      return;
//   }

   // save off deathmatch and zero it out
   tempself = self;
   tempdeathmatch = deathmatch;
   deathmatch = 0;
   if (!self.spawnfunction)
      {
      local float spawnchance;

      spawnchance = random();
      monster = tempself;

      // save off monster count so it doesn't get f'ed up
      temptotal_monsters = total_monsters;

      // spawn dog
      // spawn the new entity
      self = spawn();
      // copy over everything
      SUB_CopyEntity(tempself,self);
      self.spawnfunction = monster_dog;
      self.spawnclassname = "monster_dog";
      self.classname = self.spawnclassname;

      // call the named spawn function
      self.spawnfunction();
      self.spawnmodel = self.model;
      self.spawnmins = self.mins;
      self.spawnmaxs = self.maxs;
      setmodel (self, "");
      setsize (self, self.spawnmins, self.spawnmaxs);
      //save off solid flag
      self.spawnsolidtype = self.solid;
      self.solid = SOLID_NOT;
      //save off think func and
      //get rid of his thinking
      self.spawnthink = self.think;
      self.think = spawn_think;
      self.nextthink = time + 1;

      if (spawnchance<0.5 && monster==tempself)
         {
         monster = self;
         }

      // spawn ogre
      // spawn the new entity
      self = spawn();
      // copy over everything
      SUB_CopyEntity(tempself,self);
      self.spawnfunction = monster_ogre;
      self.spawnclassname = "monster_ogre";
      self.classname = self.spawnclassname;

      // call the named spawn function
      self.spawnfunction();
      self.spawnmodel = self.model;
      self.spawnmins = self.mins;
      self.spawnmaxs = self.maxs;
      setmodel (self, "");
      setsize (self, self.spawnmins, self.spawnmaxs);
      //save off solid flag
      self.spawnsolidtype = self.solid;
      self.solid = SOLID_NOT;
      //save off think func and
      //get rid of his thinking
      self.spawnthink = self.think;
      self.think = spawn_think;
      self.nextthink = time + 1;

      if (spawnchance<0.8 && monster==tempself)
         {
         monster = self;
         }

      // spawn fiend
      // spawn the new entity
      self = spawn();
      // copy over everything
      SUB_CopyEntity(tempself,self);
      self.spawnfunction = monster_demon1;
      self.spawnclassname = "monster_demon1";
      self.classname = self.spawnclassname;

      // call the named spawn function
      self.spawnfunction();
      self.spawnmodel = self.model;
      self.spawnmins = self.mins;
      self.spawnmaxs = self.maxs;
      setmodel (self, "");
      setsize (self, self.spawnmins, self.spawnmaxs);
      //save off solid flag
      self.spawnsolidtype = self.solid;
      self.solid = SOLID_NOT;
      //save off think func and
      //get rid of his thinking
      self.spawnthink = self.think;
      self.think = spawn_think;
      self.nextthink = time + 1;

      if (spawnchance<0.92 && monster==tempself)
         {
         monster = self;
         }

      // spawn zombie
      // spawn the new entity
      self = spawn();
      // copy over everything
      SUB_CopyEntity(tempself,self);
      self.spawnfunction = monster_zombie;
      self.spawnclassname = "monster_zombie";
      self.classname = self.spawnclassname;

      // call the named spawn function
      self.spawnfunction();
      self.spawnmodel = self.model;
      self.spawnmins = self.mins;
      self.spawnmaxs = self.maxs;
      setmodel (self, "");
      setsize (self, self.spawnmins, self.spawnmaxs);
      //save off solid flag
      self.spawnsolidtype = self.solid;
      self.solid = SOLID_NOT;
      //save off think func and
      //get rid of his thinking
      self.spawnthink = self.think;
      self.think = spawn_think;
      self.nextthink = time + 1;

      if (spawnchance<0.97 && monster==tempself)
         {
         monster = self;
         }

      // spawn shambler
      // spawn the new entity
      self = spawn();
      // copy over everything
      SUB_CopyEntity(tempself,self);
      self.spawnfunction = monster_shambler;
      self.spawnclassname = "monster_shambler";
      self.classname = self.spawnclassname;

      // call the named spawn function
      self.spawnfunction();
      self.spawnmodel = self.model;
      self.spawnmins = self.mins;
      self.spawnmaxs = self.maxs;
      setmodel (self, "");
      setsize (self, self.spawnmins, self.spawnmaxs);
      //save off solid flag
      self.spawnsolidtype = self.solid;
      self.solid = SOLID_NOT;
      //save off think func and
      //get rid of his thinking
      self.spawnthink = self.think;
      self.think = spawn_think;
      self.nextthink = time + 1;

      if (monster==tempself)
         {
         monster = self;
         }
      // make sure monster count is correct
      total_monsters = temptotal_monsters + 1;
      }
   else
      {
      // spawn the new entity
      self = spawn();
      // copy over everything
      SUB_CopyEntity(tempself,self);

      // save off monster count so it doesn't get f'ed up
      temptotal_monsters = total_monsters;
      if (self.spawnclassname == string_null)
         {
         objerror("No spawnclassname defined");
         }
      self.classname = self.spawnclassname;
      // call the named spawn function
      self.spawnfunction();
      if (self.spawnmulti != 0)
         {
         // make sure monster count is correct
         total_monsters = temptotal_monsters;
         }
      self.spawnmodel = self.model;
      self.spawnmins = self.mins;
      self.spawnmaxs = self.maxs;
      setmodel (self, "");
      self.model = "";
      setsize (self, self.spawnmins, self.spawnmaxs);
      //save off solid flag
      self.spawnsolidtype = self.solid;
      self.solid = SOLID_NOT;
      //save off think func and
      //get rid of his thinking
      self.spawnthink = self.think;
      self.think = spawn_think;
      self.nextthink = time + 1;
      monster = self;
      }
   self = tempself;
   deathmatch = tempdeathmatch;
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
   setmodel (self, self.model);  // set size and link into world
   self.use = spawn_use;
   self.spawnmaster = monster;
   };

//================
//
// func_spawn_small
//
//================
/*QUAKED func_spawn_small (0 .5 .8) (-16 -16 -24) (16 16 40) big/ambush megahealth
This will spawn a thing upon being used. The thing that
is spawned depends upon the value of "spawnfunction".
"spawnclassname" should contain the same value as "spawnfunction".
If "spawnfunction" is unspecified a random monster is chosen.
The angles, target and all flags are passed on
Think of it like setting up a normal entity.
"spawnsilent" set this to 1 if you want a silent spawn.
"spawnmulti" set this to 1 if you want this spawn to be reoccuring.
*/

void() func_spawn_small =
   {
   func_spawn();
   };
