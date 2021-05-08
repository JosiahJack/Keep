void  ()SUB_CalcAngleMoveDone;
void  ()SUB_Null;
void  ()SUB_UseTargets;
void  ()SUB_Remove;
void  (entity ToEnt,entity FromEnt,float Amount)AwardExperience;
void  ()SetModelAndThinks;
void  (entity e)stats_NewPlayer;
void  ()shock_think;
void  (vector org)spawnshockball;
void  (entity light_targ)lightstyle_change;
void  (entity targ,entity attacker,entity inflictor)Killed;
void  (float richter)MonsterQuake;
void  ()MultiExplode;
void  (entity targ,entity attacker,entity inflictor)ClientObituary;
void  (entity loser,float number)drop_level;
void  ()DarkExplosion;
float  ()FindMonsterTarget;
void  ()MonsterCheckContents;
float  (entity targ)visibility_good;
float  ()CheckJump;
void  ()W_SetCurrentWeapon;
void  (float explodetype)BecomeExplosion;
void  ()player_frames;
void  (entity spawner,vector spot1,vector spot2,string missilemodel,string missilename,float missileskin,float missilespeed,void() touchfunct)Create_Missile;
void  ()corpseblink;
void  (vector org,vector vel,float damage,entity victim)SpawnPuff;
void  (entity attacker)spawn_ghost;
void  ()precache_archer;
void  ()precache_spider;
void  (entity targ)get_visibility;

float  ()crandom =  {
   return ( random(-1.00000,1.00000) );
};


float  (float base,float exponent)fexp =  {
local float exp_count = 0.00000;
   exponent = rint ( exponent);
   if ( (exponent == 0.00000) ) {

      return ( 1.00000 );

   }
   if ( (exponent < 0.00000) ) {

      base = (1.00000 / base);
      exponent = fabs ( exponent);

   }
   if ( (exponent == 1.00000) ) {

      return ( base );

   }
   exponent -= 1.00000;
   while ( (exp_count < exponent) ) {

      exp_count += 1.00000;
      base = (base * base);

   }
   return ( base );
};


float  (float mult)byte_me =  {
local float mult_count = 0.00000;
local float base = 0.00000;
   mult = rint ( mult);
   if ( (mult == 0.00000) ) {

      return ( 0.00000 );

   }
   if ( (mult == 1.00000) ) {

      return ( 1.00000 );

   }
   if ( (mult == -1.00000) ) {

      return ( -1.00000 );

   }
   if ( (mult < 0.00000) ) {

      base = -1.00000;
      mult = fabs ( mult);
   } else {

      base = 1.00000;

   }
   mult -= 1.00000;
   while ( (mult_count < mult) ) {

      mult_count += 1.00000;
      base = (base * 2.00000);

   }
   return ( base );
};


vector  (vector vrange)RandomVector =  {
local vector newvec = '0.00000 0.00000 0.00000';
   newvec_x = random(vrange_x,(0.00000 - vrange_x));
   newvec_y = random(vrange_y,(0.00000 - vrange_y));
   newvec_z = random(vrange_z,(0.00000 - vrange_z));
   return ( newvec );
};

