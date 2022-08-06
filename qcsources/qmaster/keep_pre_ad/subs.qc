
void () body_kill;

void (vector tdest, float tspeed, void() func) SUB_CalcMove;
void (entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt;
void (vector destangle, float tspeed, void() func) SUB_CalcAngleMove;
void () SUB_CalcMoveDone;
void () SUB_CalcAngleMoveDone;
void () SUB_UseTargets;
void () SUB_Remove;
void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
float (entity e, float healamount, float ignore) T_Heal;
float (entity targ, entity inflictor) CanDamage;

entity nullentity;
entity bulletholes;
entity lastbullet;
float numbulletholes /* = 0.000 */;

.void() th_turn;

float AS_DODGING    = 5.000;
float CHARMED_RADIUS    = 1500.000;
float MAX_CHARMER_DISTANCE    = 200.000;
float MIN_CHARMER_DISTANCE    = 150.000;
float TOOCLOSE_CHARMER_DISTANCE    = 120.000;
float visible_distance /* = 0.000 */;
float footsteps /* = 0.000 */;
float SPAWNFLAG_SUPERSPIKE    = 1.000;
float SPAWNFLAG_LASER    = 2.000;
float SPAWNFLAG_LAVABALL    = 4.000;
float SPAWNFLAG_ROCKET    = 8.000;
float SPAWNFLAG_SILENT    = 16.000;
float MIN_ANGLE_DELTA    = 10.000;
.float wetsuit_finished;
.float wetsuit_time;
.float empathy_finished;
.float empathy_time;
.float empathy_sound;
.float color;
.float items2;
.float gorging;
.float stoleweapon;
.entity lastvictim;
.void() spawnfunction;
.string spawnclassname;
.float spawnsolidtype;
.string spawnmodel;
.void() spawnthink;
.entity spawnmaster;
.vector spawnmins;
.vector spawnmaxs;
.float spawnsilent;
.float spawnmulti;
.float charmed;
.entity charmer;
.float huntingcharmer;
float horn_active /* = 0.000 */;
entity horn_charmer;
.vector old_velocity;
.float duration;
.entity next_ent;
.float struck_by_mjolnir;
.vector neworigin;
.vector rotate;
.float endtime;
.float rotate_type;
.string path;
.string group;
.string event;
.float gravity;
float discharged;
entity hipdecoy;

void () StopEarthQuake;

void (float value) EarthQuakeTime;

void () earthquake_postthink;

void () earthquake_prethink;

float (entity counter) counter_GetCount;
vector (vector ang) SUB_NormalizeAngles;

void (entity srcent, entity destent) SUB_CopyEntity;

void (vector loc, float rad, float damage, float dur, float pause, float vol) multi_explosion;

void (string targ, vector orig) become_decoy;

void () RotateTargets;

void () RotateTargetsFinal;

void () SetTargetOrigin;

void () LinkRotateTargets;

void () SUB_Null = {


};

void () SUB_Remove = {

   remove (self);

};

void () SetMovedir = {

   if ( (self.angles == '0.000 -1.000 0.000') ) {

      self.movedir = '0.000 0.000 1.000';

   } else {

      if ( (self.angles == '0.000 -2.000 0.000') ) {

         self.movedir = '0.000 0.000 -1.000';

      } else {

         makevectors (self.angles);
         self.movedir = v_forward;

      }

   }
   self.angles = VEC_ORIGIN;

};

void () InitTrigger = {

   if ( (self.angles != VEC_ORIGIN) ) {

      SetMovedir ();

   }
   self.solid = SOLID_TRIGGER;
   setmodel (self,self.model);
   self.movetype = MOVETYPE_NONE;
   self.modelindex = FALSE;
   self.model = "";

};

void (entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt = {

   local entity stemp;

   stemp = self;
   self = ent;
   SUB_CalcMove (tdest,tspeed,func);
   self = stemp;

};

void (vector tdest, float tspeed, void() func) SUB_CalcMove = {

   local vector vdestdelta;
   local float len;
   local float traveltime;

   if ( !tspeed ) {

      objerror ("No speed is defined!");

   }
   self.think1 = func;
   self.finaldest = tdest;
   self.think = SUB_CalcMoveDone;
   if ( (tdest == self.origin) ) {

      self.velocity = VEC_ORIGIN;
      self.nextthink = (self.ltime + 0.100);
      return ;

   }
   vdestdelta = (tdest - self.origin);
   len = vlen (vdestdelta);
   traveltime = (len / tspeed);
   if ( (traveltime < 0.100) ) {

      self.velocity = VEC_ORIGIN;
      self.nextthink = (self.ltime + 0.100);
      return ;

   }
   self.nextthink = (self.ltime + traveltime);
   self.velocity = (vdestdelta * (TRUE / traveltime));

};

void () SUB_CalcMoveDone = {

   setorigin (self,self.finaldest);
   self.velocity = VEC_ORIGIN;
   self.nextthink = CONTENT_EMPTY;
   if ( self.think1 ) {

      self.think1 ();

   }

};

void (entity ent, vector destangle, float tspeed, void() func) SUB_CalcAngleMoveEnt = {

   local entity stemp;

   stemp = self;
   self = ent;
   SUB_CalcAngleMove (destangle,tspeed,func);
   self = stemp;

};

void (vector destangle, float tspeed, void() func) SUB_CalcAngleMove = {

   local vector destdelta;
   local float len;
   local float traveltime;

   if ( !tspeed ) {

      objerror ("No speed is defined!");

   }
   destdelta = (destangle - self.angles);
   len = vlen (destdelta);
   traveltime = (len / tspeed);
   self.nextthink = (self.ltime + traveltime);
   self.avelocity = (destdelta * (TRUE / traveltime));
   self.think1 = func;
   self.finalangle = destangle;
   self.think = SUB_CalcAngleMoveDone;

};

void () SUB_CalcAngleMoveDone = {

   self.angles = self.finalangle;
   self.avelocity = VEC_ORIGIN;
   self.nextthink = CONTENT_EMPTY;
   if ( self.think1 ) {

      self.think1 ();

   }

};

void () DelayThink = {

   activator = self.enemy;
   SUB_UseTargets ();
   remove (self);

};

void () SUB_UseTargets = {

   local entity t;
   local entity stemp;
   local entity otemp;
   local entity act;

   if ( self.delay ) {

      t = spawn ();
      t.classname = "DelayedUse";
      t.nextthink = (time + self.delay);
      t.think = DelayThink;
      t.enemy = activator;
      t.message = self.message;
      t.killtarget = self.killtarget;
      t.target = self.target;
      return ;

   }
   if ( ((activator.classname == "player") && (self.message != "")) ) {

      centerprint (activator,self.message);
      if ( !self.noise ) {

         sound (activator,CHAN_VOICE,"misc/talk.wav",TRUE,ATTN_NORM);

      }

   }
   if ( self.killtarget ) {

      t = world;
      do {

         t = find (t,targetname,self.killtarget);
         if ( !t ) {

            return ;

         }
         remove (t);

      } while ( TRUE );

   }
   if ( self.target ) {

      act = activator;
      t = world;
      do {

         t = find (t,targetname,self.target);
         if ( !t ) {

            return ;

         }
         stemp = self;
         otemp = other;
         self = t;
         other = stemp;
         if ( (self.use != SUB_Null) ) {

            if ( self.use ) {

               self.use ();

            }

         }
         self = stemp;
         other = otemp;
         activator = act;

      } while ( TRUE );

   }

};

void (float normal) SUB_AttackFinished = {

   self.cnt = FALSE;
   if ( (skill != MOVETYPE_WALK) ) {

      self.attack_finished = (time + normal);

   }

};
float (entity targ) visible;

void (void() thinkst) SUB_CheckRefire = {

   if ( (skill != MOVETYPE_WALK) ) {

      return ;

   }
   if ( (self.cnt == TRUE) ) {

      return ;

   }
   if ( !visible (self.enemy) ) {

      return ;

   }
   self.cnt = TRUE;
   self.think = thinkst;

};
