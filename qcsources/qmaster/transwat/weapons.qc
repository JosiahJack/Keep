
void (vector org, vector vel) SpawnMeatSpray;
void () player_run;
void (vector org, vector vel, float damage) SpawnBlood;
void () SuperDamageSound;
void (float damage) spawn_touchblood;

void () HIP_LaserTouch = {

   local vector org;
   local vector spot1;
   local vector spot2;
   local vector oldvel;
   local float mag;
   local float r;

   self.owner = world;
   self.cnt = (self.cnt + TRUE);
   if ( (pointcontents (self.origin) == CONTENT_SKY) ) {

      remove (self);
      return ;

   }
   oldvel = normalize (self.old_velocity);
   spot1 = (self.origin - (FL_INWATER * oldvel));
   spot2 = (self.origin + (FL_INWATER * oldvel));
   traceline (spot1,spot2,FALSE,self);
   self.origin = trace_endpos;
   org = self.origin;
   if ( other.health ) {

      if ( (self.lastvictim == other) ) {

         self.dmg = (self.dmg / FL_SWIM);

      }
      spawn_touchblood (self.dmg);
      T_Damage (other,self,self.lastvictim,self.dmg);

   } else {

      if ( ((self.cnt == MOVETYPE_WALK) || (random () < 0.150)) ) {

         WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
         WriteByte (MSG_BROADCAST,TE_GUNSHOT);
         WriteCoord (MSG_BROADCAST,org_x);
         WriteCoord (MSG_BROADCAST,org_y);
         WriteCoord (MSG_BROADCAST,org_z);

      } else {

         self.dmg = (0.900 * self.dmg);
         self.velocity = (oldvel + (FL_SWIM * trace_plane_normal));
         self.velocity = normalize (self.velocity);
         self.velocity = (self.speed * self.velocity);
         self.old_velocity = self.velocity;
         if ( (self.flags & FL_ONGROUND) ) {

            self.flags = (self.flags - FL_ONGROUND);

         }
         r = random ();
         sound (self,CHAN_WEAPON,"hipweap/laserric.wav",TRUE,ATTN_STATIC);
         return ;

      }

   }
   sound (self,CHAN_WEAPON,"enforcer/enfstop.wav",TRUE,ATTN_STATIC);
   remove (self);

};

void () HIP_LaserThink = {

   local float delta;

   if ( (time > self.attack_finished) ) {

      remove (self);
      return ;

   }
   if ( (self.flags & FL_ONGROUND) ) {

      self.flags = (self.flags - FL_ONGROUND);

   }
   self.velocity = self.old_velocity;
   self.angles = vectoangles (self.velocity);
   self.nextthink = (time + 0.100);

};

void (vector org, vector vec, float light) HIP_LaunchLaser = {

   sound (self,CHAN_WEAPON,"hipweap/laserg.wav",TRUE,ATTN_NORM);
   vec = normalize (vec);
   newmis = spawn ();
   newmis.owner = self;
   newmis.classname = "hiplaser";
   newmis.lastvictim = self;
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   if ( light ) {

      newmis.effects = EF_DIMLIGHT;

   }
   setmodel (newmis,"progs/lasrspik.mdl");
   setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (newmis,org);
   newmis.speed = 1000.000;
   newmis.dmg = 18.000;
   newmis.velocity = (vec * newmis.speed);
   newmis.old_velocity = newmis.velocity;
   newmis.angles = vectoangles (newmis.velocity);
   newmis.avelocity = '0.000 0.000 400.000';
   newmis.nextthink = time;
   newmis.attack_finished = (time + MOVETYPE_FLY);
   newmis.think = HIP_LaserThink;
   newmis.touch = HIP_LaserTouch;
   newmis.count = FALSE;

};

void (float stat) HIP_FireLaser = {

   local vector org;
   local vector dir;
   local vector out;
   local float ofs;
   local float aofs;

   if ( !self.button0 ) {

      player_run ();
      return ;

   }
   if ( (self.ammo_cells < TRUE) ) {

      self.weapon = W_BestWeapon ();
      W_SetCurrentAmmo ();
      return ;

   }
   SuperDamageSound ();
   self.effects = (self.effects | EF_MUZZLEFLASH);
   makevectors (self.v_angle);
   ofs = MOVETYPE_TOSS;
   out = v_forward;
   out_z = FALSE;
   out = normalize (out);
   org = ((self.origin + ((STAT_TOTALMONSTERS - ofs) * v_up)) + (STAT_TOTALMONSTERS * out));
   dir = aim (self,1000.000);
   aofs = (ofs * 0.707);
   if ( (stat == FALSE) ) {

      self.ammo_cells = (self.ammo_cells - TRUE);
      self.currentammo = (self.currentammo - TRUE);
      org = (org + (aofs * v_right));
      org = (org - (aofs * v_up));
      HIP_LaunchLaser (org,dir,FALSE);
      org = (org - ((FL_SWIM * aofs) * v_right));
      HIP_LaunchLaser (org,dir,FALSE);

   } else {

      if ( (stat == TRUE) ) {

         self.ammo_cells = (self.ammo_cells - TRUE);
         self.currentammo = (self.currentammo - TRUE);
         org = (org + (ofs * v_up));
         if ( (random () < 0.100) ) {

            HIP_LaunchLaser (org,dir,TRUE);
            newmis.dmg = 25.000;

         } else {

            HIP_LaunchLaser (org,dir,FALSE);

         }

      }

   }
   self.punchangle_x = CONTENT_EMPTY;

};

void (vector p1, vector p2, entity from, float damage) HIP_HammerDamage = {

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
   if ( (trace_ent.takedamage && !trace_ent.wetsuit_finished) ) {

      particle (trace_endpos,'0.000 0.000 100.000',225.000,(damage * MOVETYPE_STEP));
      T_Damage (trace_ent,from,from,damage);
      if ( (self.classname == "player") ) {

         if ( (other.classname == "player") ) {

            trace_ent.velocity_z = (trace_ent.velocity_z + 400.000);

         }

      }

   }
   e1 = trace_ent;
   traceline ((p1 + f),(p2 + f),FALSE,self);
   if ( (((trace_ent != e1) && trace_ent.takedamage) && !trace_ent.wetsuit_finished) ) {

      particle (trace_endpos,'0.000 0.000 100.000',225.000,(damage * MOVETYPE_STEP));
      T_Damage (trace_ent,from,from,damage);

   }
   e2 = trace_ent;
   traceline ((p1 - f),(p2 - f),FALSE,self);
   if ( ((((trace_ent != e1) && (trace_ent != e2)) && trace_ent.takedamage) && !trace_ent.wetsuit_finished) ) {

      particle (trace_endpos,'0.000 0.000 100.000',225.000,(damage * MOVETYPE_STEP));
      T_Damage (trace_ent,from,from,damage);

   }

};

void () HIP_LightningThink = {

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
   local vector end;

   if ( (time > self.delay) ) {

      if ( (self.enemy != world) ) {

         self.enemy.struck_by_mjolnir = FALSE;

      }
      remove (self);
      return ;

   }
   oldstate = self.state;
   if ( (self.state == FALSE) ) {

      self.enemy = world;
      selected = world;
      cur_dist = self.distance;
      head = findradius (self.owner.origin,self.distance);
      while ( head ) {

         if ( (!(head.flags & FL_NOTARGET) && ((head.flags & FL_MONSTER) || (head.flags & FL_CLIENT))) ) {

            visible (head);
            if ( ((visible (head) && (head != self.owner.owner)) && (head.health > FALSE)) ) {

               head_dist = vlen ((head.origin - self.lastvictim.origin));
               if ( ((head_dist < cur_dist) && (head.struck_by_mjolnir == FALSE)) ) {

                  selected = head;
                  cur_dist = head_dist;

               }

            }

         }
         head = head.chain;

      }
      if ( (selected != world) ) {

         self.state = TRUE;
         self.enemy = selected;
         self.enemy.struck_by_mjolnir = TRUE;

      } else {

         makevectors (self.v_angle);
         org = self.owner.origin;
         end = (org + (v_forward * MAX_CHARMER_DISTANCE));
         end = (end + (((400.000 * random ()) - MAX_CHARMER_DISTANCE) * v_right));
         traceline (org,end,TRUE,self);
         WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
         WriteByte (MSG_BROADCAST,TE_LIGHTNING2);
         WriteEntity (MSG_BROADCAST,self);
         WriteCoord (MSG_BROADCAST,org_x);
         WriteCoord (MSG_BROADCAST,org_y);
         WriteCoord (MSG_BROADCAST,org_z);
         WriteCoord (MSG_BROADCAST,trace_endpos_x);
         WriteCoord (MSG_BROADCAST,trace_endpos_y);
         WriteCoord (MSG_BROADCAST,trace_endpos_z);
         self.nextthink = (time + 0.100);
         return ;

      }

   }
   org = self.lastvictim.origin;
   dst = (self.enemy.absmin + (0.250 * (self.enemy.absmax - self.enemy.absmin)));
   dst = (dst + ((random () * 0.500) * (self.enemy.absmax - self.enemy.absmin)));
   traceline (org,dst,TRUE,self.owner.owner);
   if ( ((trace_fraction != TRUE) || (self.enemy.health <= FALSE)) ) {

      self.enemy.struck_by_mjolnir = FALSE;
      self.state = FALSE;
      self.nextthink = (time + 0.100);
      return ;

   }
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_LIGHTNING2);
   WriteEntity (MSG_BROADCAST,self);
   WriteCoord (MSG_BROADCAST,org_x);
   WriteCoord (MSG_BROADCAST,org_y);
   WriteCoord (MSG_BROADCAST,org_z);
   WriteCoord (MSG_BROADCAST,trace_endpos_x);
   WriteCoord (MSG_BROADCAST,trace_endpos_y);
   WriteCoord (MSG_BROADCAST,trace_endpos_z);
   vec = normalize ((self.enemy.origin - self.owner.origin));
   dot = (vec * self.owner.movedir);
   head = self;
   self = self.owner.owner;
   if ( (oldstate == FALSE) ) {

      dam = 80.000;

   } else {

      dam = SVC_INTERMISSION;

   }
   if ( (dot > 0.300) ) {

      HIP_HammerDamage (org,trace_endpos,self,dam);

   } else {

      HIP_HammerDamage (org,trace_endpos,self,(dam * 0.500));

   }
   self = head;
   self.nextthink = (time + 0.200);

};

void (entity prev, entity own, float dst) HIP_SpawnMjolnirLightning = {

   local entity light;

   light = spawn ();
   light.delay = (time + 0.800);
   light.state = FALSE;
   light.lastvictim = prev;
   light.distance = dst;
   light.owner = own;
   light.v_angle = self.angles;
   light.v_angle_x = FALSE;
   light.v_angle_z = FALSE;
   light.origin = own.origin;
   light.think = HIP_LightningThink;
   light.nextthink = time;

};

void () HIP_SpawnMjolnirBase = {

   local entity light;

   light = spawn ();
   light.origin = trace_endpos;
   light.flags = FALSE;
   light.owner = self;
   light.struck_by_mjolnir = TRUE;
   light.think = SUB_Remove;
   light.nextthink = (time + TRUE);
   sound (light,CHAN_AUTO,"hipweap/mjolslap.wav",TRUE,ATTN_NORM);
   sound (light,CHAN_WEAPON,"hipweap/mjolhit.wav",TRUE,ATTN_NORM);
   makevectors (self.v_angle);
   light.movedir = v_forward;
   HIP_SpawnMjolnirLightning (light,light,350.000);
   HIP_SpawnMjolnirLightning (light,light,350.000);
   HIP_SpawnMjolnirLightning (light,light,350.000);
   HIP_SpawnMjolnirLightning (light,light,350.000);

};

void () HIP_FireMjolnirLightning = {

   local vector org;
   local float cells;

   if ( (self.waterlevel > TRUE) ) {

      cells = self.ammo_cells;
      self.ammo_cells = FALSE;
      discharged = TRUE;
      T_RadiusDamage (self,self,(35.000 * cells),world);
      discharged = FALSE;
      W_SetCurrentAmmo ();
      return ;

   }
   self.ammo_cells = (self.ammo_cells - 15.000);
   self.currentammo = (self.currentammo - 15.000);
   HIP_SpawnMjolnirBase ();

};

void () HIP_FireMjolnir = {

   local vector org;
   local float cells;
   local float damage;
   local vector source;
   local vector ang;

   self.attack_finished = (time + 0.400);
   source = (self.origin + '0.000 0.000 16.000');
   makevectors (self.v_angle);
   traceline (source,(source + (v_forward * FL_MONSTER)),FALSE,self);
   if ( ((trace_fraction == TRUE) && (self.ammo_cells >= 15.000)) ) {

      source = (source + (v_forward * FL_MONSTER));
      traceline (source,(source - (v_up * 50.000)),FALSE,self);
      if ( ((trace_fraction > 0.300) && (trace_fraction < TRUE)) ) {

         HIP_FireMjolnirLightning ();
         self.attack_finished = (time + 1.500);
         return ;

      }

   }
   org = (trace_endpos - (v_forward * MOVETYPE_STEP));
   if ( trace_ent.takedamage ) {

      damage = 50.000;
      if ( (trace_ent.classname == "monster_zombie") ) {

         damage = 70.000;

      }
      trace_ent.axhitme = TRUE;
      SpawnBlood (org,v_forward,damage);
      T_Damage (trace_ent,self,self,damage);

   } else {

      if ( (trace_fraction != TRUE) ) {

         sound (self,CHAN_WEAPON,"hipweap/mjoltink.wav",TRUE,ATTN_NORM);
         WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
         WriteByte (MSG_BROADCAST,TE_GUNSHOT);
         WriteCoord (MSG_BROADCAST,org_x);
         WriteCoord (MSG_BROADCAST,org_y);
         WriteCoord (MSG_BROADCAST,org_z);

      } else {

         sound (self,CHAN_WEAPON,"knight/sword1.wav",TRUE,ATTN_NORM);

      }

   }
   self.attack_finished = (time + 0.400);

};

void () W_Precache = {

   precache_sound ("weapons/r_exp3.wav");
   precache_sound ("weapons/rocket1i.wav");
   precache_sound ("weapons/sgun1.wav");
   precache_sound ("weapons/guncock.wav");
   precache_sound ("weapons/ric1.wav");
   precache_sound ("weapons/ric2.wav");
   precache_sound ("weapons/ric3.wav");
   precache_sound ("weapons/spike2.wav");
   precache_sound ("weapons/tink1.wav");
   precache_sound ("weapons/grenade.wav");
   precache_sound ("weapons/bounce.wav");
   precache_sound ("weapons/shotgn2.wav");

};
float () crandom = {

   return ( (FL_SWIM * (random () - 0.500)) );

};

void () W_FireAxe = {

   local vector source;
   local vector org;

   makevectors (self.v_angle);
   source = (self.origin + '0.000 0.000 16.000');
   traceline (source,(source + (v_forward * FL_GODMODE)),FALSE,self);
   if ( (trace_fraction == TRUE) ) {

      return ;

   }
   org = (trace_endpos - (v_forward * MOVETYPE_STEP));
   if ( trace_ent.takedamage ) {

      trace_ent.axhitme = TRUE;
      SpawnBlood (org,VEC_ORIGIN,20.000);
      T_Damage (trace_ent,self,self,20.000);

   } else {

      sound (self,CHAN_WEAPON,"player/axhit2.wav",TRUE,ATTN_NORM);
      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_GUNSHOT);
      WriteCoord (MSG_BROADCAST,org_x);
      WriteCoord (MSG_BROADCAST,org_y);
      WriteCoord (MSG_BROADCAST,org_z);

   }

};

vector () wall_velocity = {

   local vector vel;

   vel = normalize (self.velocity);
   vel = normalize (((vel + (v_up * (random () - 0.500))) + (v_right * (random () - 0.500))));
   vel = (vel + (FL_SWIM * trace_plane_normal));
   vel = (vel * 200.000);
   return ( vel );

};

void (vector org, vector vel) SpawnMeatSpray = {

   local entity missile;
   local entity mpuff;

   missile = spawn ();
   missile.owner = self;
   missile.movetype = MOVETYPE_BOUNCE;
   missile.solid = SOLID_NOT;
   makevectors (self.angles);
   missile.velocity = vel;
   missile.velocity_z = ((missile.velocity_z + 250.000) + (50.000 * random ()));
   missile.avelocity = '3000.000 1000.000 2000.000';
   missile.nextthink = (time + TRUE);
   missile.think = SUB_Remove;
   setmodel (missile,"progs/zom_gib.mdl");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,org);

};

void (vector org, vector vel, float damage) SpawnBlood = {

   particle (org,(vel * 0.100),73.000,(damage * FL_SWIM));

};

void (float damage) spawn_touchblood = {

   local vector vel;

   vel = (wall_velocity () * 0.200);
   SpawnBlood ((self.origin + (vel * 0.010)),vel,damage);

};

void (vector org, vector vel) SpawnChunk = {

   particle (org,(vel * 0.020),FALSE,MOVETYPE_BOUNCE);

};
entity multi_ent;
float multi_damage /* = 0.000 */;

void () ClearMultiDamage = {

   multi_ent = world;
   multi_damage = FALSE;

};

void () ApplyMultiDamage = {

   if ( !multi_ent ) {

      return ;

   }
   T_Damage (multi_ent,self,self,multi_damage);

};

void (entity hit, float damage) AddMultiDamage = {

   if ( !hit ) {

      return ;

   }
   if ( (hit != multi_ent) ) {

      ApplyMultiDamage ();
      multi_damage = damage;
      multi_ent = hit;

   } else {

      multi_damage = (multi_damage + damage);

   }

};

void (float damage, vector dir) TraceAttack = {

   local vector vel;
   local vector org;

   vel = normalize (((dir + (v_up * crandom ())) + (v_right * crandom ())));
   vel = (vel + (FL_SWIM * trace_plane_normal));
   vel = (vel * 200.000);
   org = (trace_endpos - (dir * MOVETYPE_STEP));
   if ( trace_ent.takedamage ) {

      SpawnBlood (org,(vel * 0.200),damage);
      AddMultiDamage (trace_ent,damage);

   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_GUNSHOT);
      WriteCoord (MSG_BROADCAST,org_x);
      WriteCoord (MSG_BROADCAST,org_y);
      WriteCoord (MSG_BROADCAST,org_z);

   }

};

void (float shotcount, vector dir, vector spread) FireBullets = {

   local vector direction;
   local vector src;

   makevectors (self.v_angle);
   src = (self.origin + (v_forward * MOVETYPE_BOUNCE));
   src_z = (self.absmin_z + (self.size_z * 0.700));
   ClearMultiDamage ();
   while ( (shotcount > FALSE) ) {

      direction = ((dir + ((crandom () * spread_x) * v_right)) + ((crandom () * spread_y) * v_up));
      traceline (src,(src + (direction * FL_WATERJUMP)),FALSE,self);
      if ( (trace_fraction != TRUE) ) {

         TraceAttack (MOVETYPE_STEP,direction);

      }
      shotcount = (shotcount - TRUE);

   }
   ApplyMultiDamage ();

};

void () W_FireShotgun = {

   local vector dir;

   sound (self,CHAN_WEAPON,"weapons/guncock.wav",TRUE,ATTN_NORM);
   self.punchangle_x = CONTENT_SOLID;
   self.ammo_shells = (self.ammo_shells - TRUE);
   self.currentammo = (self.currentammo - TRUE);
   dir = aim (self,100000.000);
   FireBullets (MOVETYPE_TOSS,dir,'0.040 0.040 0.000');

};

void () W_FireSuperShotgun = {

   local vector dir;

   if ( (self.currentammo == TRUE) ) {

      W_FireShotgun ();
      return ;

   }
   sound (self,CHAN_WEAPON,"weapons/shotgn2.wav",TRUE,ATTN_NORM);
   self.punchangle_x = CONTENT_SLIME;
   self.ammo_shells = (self.ammo_shells - FL_SWIM);
   self.currentammo = (self.currentammo - FL_SWIM);
   dir = aim (self,100000.000);
   FireBullets (14.00,dir,'0.140 0.080 0.000');

};

void () s_explode1 = [ 0.000, s_explode2 ] {


};

void () s_explode2 = [ 1.000, s_explode3 ] {


};

void () s_explode3 = [ 2.000, s_explode4 ] {


};

void () s_explode4 = [ 3.000, s_explode5 ] {


};

void () s_explode5 = [ 4.000, s_explode6 ] {


};

void () s_explode6 = [ 5.000, SUB_Remove ] {


};

void () BecomeExplosion = {

   self.movetype = MOVETYPE_NONE;
   self.velocity = VEC_ORIGIN;
   self.touch = SUB_Null;
   setmodel (self,"progs/s_explod.spr");
   self.solid = SOLID_NOT;
   s_explode1 ();

};

void () T_MissileTouch = {

   local float damg;

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (pointcontents (self.origin) == CONTENT_SKY) ) {

      remove (self);
      return ;

   }
   damg = (100.000 + (random () * 20.000));
   if ( other.health ) {

      if ( (other.classname == "monster_shambler") ) {

         damg = (damg * 0.500);

      }
      T_Damage (other,self,self.owner,damg);

   }
   T_RadiusDamage (self,self.owner,120.000,other);
   self.origin = (self.origin - (FL_CLIENT * normalize (self.velocity)));
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_EXPLOSION);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   BecomeExplosion ();

};

void () W_FireRocket = {

   local entity missile;
   local entity mpuff;

   self.ammo_rockets = (self.ammo_rockets - TRUE);
   self.currentammo = (self.currentammo - TRUE);
   sound (self,CHAN_WEAPON,"weapons/sgun1.wav",TRUE,ATTN_NORM);
   self.punchangle_x = CONTENT_SOLID;
   missile = spawn ();
   missile.owner = self;
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_BBOX;
   missile.classname = "missile";
   makevectors (self.v_angle);
   missile.velocity = aim (self,1000.000);
   missile.velocity = (missile.velocity * 1000.000);
   missile.angles = vectoangles (missile.velocity);
   missile.touch = T_MissileTouch;
   missile.nextthink = (time + MOVETYPE_FLY);
   missile.think = SUB_Remove;
   setmodel (missile,"progs/missile.mdl");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,((self.origin + (v_forward * FL_CLIENT)) + '0.000 0.000 16.000'));

};

void (vector p1, vector p2, entity from, float damage) LightningDamage = {

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

      particle (trace_endpos,'0.000 0.000 100.000',225.000,(damage * MOVETYPE_STEP));
      T_Damage (trace_ent,from,from,damage);
      if ( (self.classname == "player") ) {

         if ( (other.classname == "player") ) {

            trace_ent.velocity_z = (trace_ent.velocity_z + 400.000);

         }

      }

   }
   e1 = trace_ent;
   traceline ((p1 + f),(p2 + f),FALSE,self);
   if ( ((trace_ent != e1) && trace_ent.takedamage) ) {

      particle (trace_endpos,'0.000 0.000 100.000',225.000,(damage * MOVETYPE_STEP));
      T_Damage (trace_ent,from,from,damage);

   }
   e2 = trace_ent;
   traceline ((p1 - f),(p2 - f),FALSE,self);
   if ( (((trace_ent != e1) && (trace_ent != e2)) && trace_ent.takedamage) ) {

      particle (trace_endpos,'0.000 0.000 100.000',225.000,(damage * MOVETYPE_STEP));
      T_Damage (trace_ent,from,from,damage);

   }

};

void () W_FireLightning = {

   local vector org;
   local float cells;

   if ( (self.ammo_cells < TRUE) ) {

      self.weapon = W_BestWeapon ();
      W_SetCurrentAmmo ();
      return ;

   }
   if ( (self.waterlevel > TRUE) ) {

      cells = self.ammo_cells;
      self.ammo_cells = FALSE;
      W_SetCurrentAmmo ();
      T_RadiusDamage (self,self,(35.000 * cells),world);
      return ;

   }
   if ( (self.t_width < time) ) {

      sound (self,CHAN_WEAPON,"weapons/lhit.wav",TRUE,ATTN_NORM);
      self.t_width = (time + 0.600);

   }
   self.punchangle_x = CONTENT_SOLID;
   self.ammo_cells = (self.ammo_cells - TRUE);
   self.currentammo = (self.currentammo - TRUE);
   org = (self.origin + '0.000 0.000 16.000');
   traceline (org,(org + (v_forward * 100000.000)),TRUE,self);
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_LIGHTNING2);
   WriteEntity (MSG_BROADCAST,self);
   WriteCoord (MSG_BROADCAST,org_x);
   WriteCoord (MSG_BROADCAST,org_y);
   WriteCoord (MSG_BROADCAST,org_z);
   WriteCoord (MSG_BROADCAST,trace_endpos_x);
   WriteCoord (MSG_BROADCAST,trace_endpos_y);
   WriteCoord (MSG_BROADCAST,trace_endpos_z);
   LightningDamage (self.origin,(trace_endpos + (v_forward * MOVETYPE_STEP)),self,SVC_INTERMISSION);

};

void () GrenadeExplode = {

   T_RadiusDamage (self,self.owner,120.000,world);
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_EXPLOSION);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   BecomeExplosion ();

};

void () GrenadeTouch = {

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (other.takedamage == DAMAGE_AIM) ) {

      GrenadeExplode ();
      return ;

   }
   sound (self,CHAN_WEAPON,"weapons/bounce.wav",TRUE,ATTN_NORM);
   if ( (self.velocity == VEC_ORIGIN) ) {

      self.avelocity = VEC_ORIGIN;

   }

};

void () W_FireGrenade = {

   local entity missile;
   local entity mpuff;

   self.ammo_rockets = (self.ammo_rockets - TRUE);
   self.currentammo = (self.currentammo - TRUE);
   sound (self,CHAN_WEAPON,"weapons/grenade.wav",TRUE,ATTN_NORM);
   self.punchangle_x = CONTENT_SOLID;
   missile = spawn ();
   missile.owner = self;
   missile.movetype = MOVETYPE_BOUNCE;
   missile.solid = SOLID_BBOX;
   missile.classname = "grenade";
   makevectors (self.v_angle);
   if ( self.v_angle_x ) {

      missile.velocity = ((((v_forward * 600.000) + (v_up * 200.000)) + ((crandom () * v_right) * MOVETYPE_BOUNCE)) + ((crandom () * v_up) * MOVETYPE_BOUNCE));

   } else {

      missile.velocity = aim (self,10000.000);
      missile.velocity = (missile.velocity * 600.000);
      missile.velocity_z = 200.000;

   }
   missile.avelocity = '300.000 300.000 300.000';
   missile.angles = vectoangles (missile.velocity);
   missile.touch = GrenadeTouch;
   missile.nextthink = (time + 2.500);
   missile.think = GrenadeExplode;
   setmodel (missile,"progs/grenade.mdl");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,self.origin);

};

void () spike_touch;

void () superspike_touch;

void (vector org, vector dir) launch_spike = {

   newmis = spawn ();
   newmis.owner = self;
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   newmis.angles = vectoangles (dir);
   newmis.touch = spike_touch;
   newmis.classname = "spike";
   newmis.think = SUB_Remove;
   newmis.nextthink = (time + MOVETYPE_TOSS);
   setmodel (newmis,"progs/spike.mdl");
   setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (newmis,org);
   newmis.velocity = (dir * 1000.000);

};

void () W_FireSuperSpikes = {

   local vector dir;
   local entity old;

   sound (self,CHAN_WEAPON,"weapons/spike2.wav",TRUE,ATTN_NORM);
   self.attack_finished = (time + 0.200);
   self.ammo_nails = (self.ammo_nails - FL_SWIM);
   self.currentammo = (self.currentammo - FL_SWIM);
   dir = aim (self,1000.000);
   launch_spike ((self.origin + '0.000 0.000 16.000'),dir);
   newmis.touch = superspike_touch;
   setmodel (newmis,"progs/s_spike.mdl");
   setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
   self.punchangle_x = CONTENT_SOLID;

};

void (float ox) W_FireSpikes = {

   local vector dir;
   local entity old;

   makevectors (self.v_angle);
   if ( ((self.ammo_nails >= FL_SWIM) && (self.weapon == IT_SUPER_NAILGUN)) ) {

      W_FireSuperSpikes ();
      return ;

   }
   if ( (self.ammo_nails < TRUE) ) {

      self.weapon = W_BestWeapon ();
      W_SetCurrentAmmo ();
      return ;

   }
   sound (self,CHAN_WEAPON,"weapons/rocket1i.wav",TRUE,ATTN_NORM);
   self.attack_finished = (time + 0.200);
   self.ammo_nails = (self.ammo_nails - TRUE);
   self.currentammo = (self.currentammo - TRUE);
   dir = aim (self,1000.000);
   launch_spike (((self.origin + '0.000 0.000 16.000') + (v_right * ox)),dir);
   self.punchangle_x = CONTENT_SOLID;

};
.float hit_z;

void () spike_touch = {

   local float rand;

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (other.solid == SOLID_TRIGGER) ) {

      return ;

   }
   if ( (pointcontents (self.origin) == CONTENT_SKY) ) {

      remove (self);
      return ;

   }
   if ( other.takedamage ) {

      spawn_touchblood (MOVETYPE_FLYMISSILE);
      T_Damage (other,self,self.owner,MOVETYPE_FLYMISSILE);

   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      if ( (self.classname == "wizspike") ) {

         WriteByte (MSG_BROADCAST,TE_WIZSPIKE);

      } else {

         if ( (self.classname == "knightspike") ) {

            WriteByte (MSG_BROADCAST,TE_KNIGHTSPIKE);

         } else {

            WriteByte (MSG_BROADCAST,TE_SPIKE);

         }

      }
      WriteCoord (MSG_BROADCAST,self.origin_x);
      WriteCoord (MSG_BROADCAST,self.origin_y);
      WriteCoord (MSG_BROADCAST,self.origin_z);

   }
   remove (self);

};

void () superspike_touch = {

   local float rand;

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (other.solid == SOLID_TRIGGER) ) {

      return ;

   }
   if ( (pointcontents (self.origin) == CONTENT_SKY) ) {

      remove (self);
      return ;

   }
   if ( other.takedamage ) {

      spawn_touchblood (18.000);
      T_Damage (other,self,self.owner,18.000);

   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_SUPERSPIKE);
      WriteCoord (MSG_BROADCAST,self.origin_x);
      WriteCoord (MSG_BROADCAST,self.origin_y);
      WriteCoord (MSG_BROADCAST,self.origin_z);

   }
   remove (self);

};

void () W_SetCurrentAmmo = {

   player_run ();
   self.items = (self.items - (self.items & (((IT_SHELLS | IT_NAILS) | IT_ROCKETS) | IT_CELLS)));
   if ( (self.weapon == IT_AXE) ) {

      self.currentammo = FALSE;
      self.weaponmodel = "progs/v_axe.mdl";
      self.weaponframe = FALSE;

   } else {

      if ( (self.weapon == IT_SHOTGUN) ) {

         self.currentammo = self.ammo_shells;
         self.weaponmodel = "progs/v_shot.mdl";
         self.weaponframe = FALSE;
         self.items = (self.items | IT_SHELLS);

      } else {

         if ( (self.weapon == IT_SUPER_SHOTGUN) ) {

            self.currentammo = self.ammo_shells;
            self.weaponmodel = "progs/v_shot2.mdl";
            self.weaponframe = FALSE;
            self.items = (self.items | IT_SHELLS);

         } else {

            if ( (self.weapon == IT_NAILGUN) ) {

               self.currentammo = self.ammo_nails;
               self.weaponmodel = "progs/v_nail.mdl";
               self.weaponframe = FALSE;
               self.items = (self.items | IT_NAILS);

            } else {

               if ( (self.weapon == IT_SUPER_NAILGUN) ) {

                  self.currentammo = self.ammo_nails;
                  self.weaponmodel = "progs/v_nail2.mdl";
                  self.weaponframe = FALSE;
                  self.items = (self.items | IT_NAILS);

               } else {

                  if ( (self.weapon == IT_GRENADE_LAUNCHER) ) {

                     self.currentammo = self.ammo_rockets;
                     self.weaponmodel = "progs/v_rock.mdl";
                     self.weaponframe = FALSE;
                     self.items = (self.items | IT_ROCKETS);

                  } else {

                     if ( (self.weapon == IT_ROCKET_LAUNCHER) ) {

                        self.currentammo = self.ammo_rockets;
                        self.weaponmodel = "progs/v_rock2.mdl";
                        self.weaponframe = FALSE;
                        self.items = (self.items | IT_ROCKETS);

                     } else {

                        if ( (self.weapon == IT_LIGHTNING) ) {

                           self.currentammo = self.ammo_cells;
                           self.weaponmodel = "progs/v_light.mdl";
                           self.weaponframe = FALSE;
                           self.items = (self.items | IT_CELLS);

                        } else {

                           self.currentammo = FALSE;
                           self.weaponmodel = "";
                           self.weaponframe = FALSE;

                        }

                     }

                  }

               }

            }

         }

      }

   }

};
float () W_BestWeapon = {

   local float it;

   it = self.items;
   if ( (((self.waterlevel <= TRUE) && (self.ammo_cells >= TRUE)) && (it & IT_LIGHTNING)) ) {

      return ( IT_LIGHTNING );

   }
   if ( ((self.ammo_nails >= FL_SWIM) && (it & IT_SUPER_NAILGUN)) ) {

      return ( IT_SUPER_NAILGUN );

   }
   if ( ((self.ammo_shells >= FL_SWIM) && (it & IT_SUPER_SHOTGUN)) ) {

      return ( IT_SUPER_SHOTGUN );

   }
   if ( ((self.ammo_nails >= TRUE) && (it & IT_NAILGUN)) ) {

      return ( IT_NAILGUN );

   }
   if ( ((self.ammo_shells >= TRUE) && (it & IT_SHOTGUN)) ) {

      return ( IT_SHOTGUN );

   }
   return ( IT_AXE );

};
float () W_CheckNoAmmo = {

   if ( (self.currentammo > FALSE) ) {

      return ( TRUE );

   }
   if ( (self.weapon == IT_AXE) ) {

      return ( TRUE );

   }
   self.weapon = W_BestWeapon ();
   W_SetCurrentAmmo ();
   return ( FALSE );

};

void () player_axe1;

void () player_axeb1;

void () player_axec1;

void () player_axed1;

void () player_shot1;

void () player_nail1;

void () player_light1;

void () player_rocket1;

void () W_Attack = {

   local float r;

   if ( !W_CheckNoAmmo () ) {

      return ;

   }
   makevectors (self.v_angle);
   self.show_hostile = (time + TRUE);
   if ( (self.weapon == IT_AXE) ) {

      sound (self,CHAN_WEAPON,"weapons/ax1.wav",TRUE,ATTN_NORM);
      r = random ();
      if ( (r < 0.250) ) {

         player_axe1 ();

      } else {

         if ( (r < 0.500) ) {

            player_axeb1 ();

         } else {

            if ( (r < 0.750) ) {

               player_axec1 ();

            } else {

               player_axed1 ();

            }

         }

      }
      self.attack_finished = (time + 0.500);

   } else {

      if ( (self.weapon == IT_SHOTGUN) ) {

         player_shot1 ();
         W_FireShotgun ();
         self.attack_finished = (time + 0.500);

      } else {

         if ( (self.weapon == IT_SUPER_SHOTGUN) ) {

            player_shot1 ();
            W_FireSuperShotgun ();
            self.attack_finished = (time + 0.700);

         } else {

            if ( (self.weapon == IT_NAILGUN) ) {

               player_nail1 ();

            } else {

               if ( (self.weapon == IT_SUPER_NAILGUN) ) {

                  player_nail1 ();

               } else {

                  if ( (self.weapon == IT_GRENADE_LAUNCHER) ) {

                     player_rocket1 ();
                     W_FireGrenade ();
                     self.attack_finished = (time + 0.600);

                  } else {

                     if ( (self.weapon == IT_ROCKET_LAUNCHER) ) {

                        player_rocket1 ();
                        W_FireRocket ();
                        self.attack_finished = (time + 0.800);

                     } else {

                        if ( (self.weapon == IT_LIGHTNING) ) {

                           player_light1 ();
                           self.attack_finished = (time + 0.100);
                           sound (self,CHAN_AUTO,"weapons/lstart.wav",TRUE,ATTN_NORM);

                        }

                     }

                  }

               }

            }

         }

      }

   }

};

void () W_ChangeWeapon = {

   local float it;
   local float am;
   local float fl;

   it = self.items;
   am = FALSE;
   if ( (self.impulse == TRUE) ) {

      fl = IT_AXE;

   } else {

      if ( (self.impulse == FL_SWIM) ) {

         fl = IT_SHOTGUN;
         if ( (self.ammo_shells < TRUE) ) {

            am = TRUE;

         }

      } else {

         if ( (self.impulse == MOVETYPE_WALK) ) {

            fl = IT_SUPER_SHOTGUN;
            if ( (self.ammo_shells < FL_SWIM) ) {

               am = TRUE;

            }

         } else {

            if ( (self.impulse == MOVETYPE_STEP) ) {

               fl = IT_NAILGUN;
               if ( (self.ammo_nails < TRUE) ) {

                  am = TRUE;

               }

            } else {

               if ( (self.impulse == MOVETYPE_FLY) ) {

                  fl = IT_SUPER_NAILGUN;
                  if ( (self.ammo_nails < FL_SWIM) ) {

                     am = TRUE;

                  }

               } else {

                  if ( (self.impulse == MOVETYPE_TOSS) ) {

                     fl = IT_GRENADE_LAUNCHER;
                     if ( (self.ammo_rockets < TRUE) ) {

                        am = TRUE;

                     }

                  } else {

                     if ( (self.impulse == MOVETYPE_PUSH) ) {

                        fl = IT_ROCKET_LAUNCHER;
                        if ( (self.ammo_rockets < TRUE) ) {

                           am = TRUE;

                        }

                     } else {

                        if ( (self.impulse == FL_CLIENT) ) {

                           fl = IT_LIGHTNING;
                           if ( (self.ammo_cells < TRUE) ) {

                              am = TRUE;

                           }

                        }

                     }

                  }

               }

            }

         }

      }

   }
   self.impulse = FALSE;
   if ( !(self.items & fl) ) {

      sprint (self,"no weapon.\n");
      return ;

   }
   if ( am ) {

      sprint (self,"not enough ammo.\n");
      return ;

   }
   self.weapon = fl;
   W_SetCurrentAmmo ();

};

void () CheatCommand = {

   if ( (deathmatch || coop) ) {

      return ;

   }
   self.ammo_rockets = 100.000;
   self.ammo_nails = 200.000;
   self.ammo_shells = 100.000;
   self.items = (((((((((self.items | IT_AXE) | IT_SHOTGUN) | IT_SUPER_SHOTGUN) | IT_NAILGUN) | IT_SUPER_NAILGUN) | IT_GRENADE_LAUNCHER) | IT_ROCKET_LAUNCHER) | IT_KEY1) | IT_KEY2);
   self.ammo_cells = 200.000;
   self.items = (self.items | IT_LIGHTNING);
   self.weapon = IT_ROCKET_LAUNCHER;
   self.impulse = FALSE;
   W_SetCurrentAmmo ();

};

void () CycleWeaponCommand = {

   local float it;
   local float am;

   it = self.items;
   self.impulse = FALSE;
   while ( TRUE ) {

      am = FALSE;
      if ( (self.weapon == IT_LIGHTNING) ) {

         self.weapon = IT_AXE;

      } else {

         if ( (self.weapon == IT_AXE) ) {

            self.weapon = IT_SHOTGUN;
            if ( (self.ammo_shells < TRUE) ) {

               am = TRUE;

            }

         } else {

            if ( (self.weapon == IT_SHOTGUN) ) {

               self.weapon = IT_SUPER_SHOTGUN;
               if ( (self.ammo_shells < FL_SWIM) ) {

                  am = TRUE;

               }

            } else {

               if ( (self.weapon == IT_SUPER_SHOTGUN) ) {

                  self.weapon = IT_NAILGUN;
                  if ( (self.ammo_nails < TRUE) ) {

                     am = TRUE;

                  }

               } else {

                  if ( (self.weapon == IT_NAILGUN) ) {

                     self.weapon = IT_SUPER_NAILGUN;
                     if ( (self.ammo_nails < FL_SWIM) ) {

                        am = TRUE;

                     }

                  } else {

                     if ( (self.weapon == IT_SUPER_NAILGUN) ) {

                        self.weapon = IT_GRENADE_LAUNCHER;
                        if ( (self.ammo_rockets < TRUE) ) {

                           am = TRUE;

                        }

                     } else {

                        if ( (self.weapon == IT_GRENADE_LAUNCHER) ) {

                           self.weapon = IT_ROCKET_LAUNCHER;
                           if ( (self.ammo_rockets < TRUE) ) {

                              am = TRUE;

                           }

                        } else {

                           if ( (self.weapon == IT_ROCKET_LAUNCHER) ) {

                              self.weapon = IT_LIGHTNING;
                              if ( (self.ammo_cells < TRUE) ) {

                                 am = TRUE;

                              }

                           }

                        }

                     }

                  }

               }

            }

         }

      }
      if ( ((it & self.weapon) && (am == FALSE)) ) {

         W_SetCurrentAmmo ();
         return ;

      }

   }

};

void () CycleWeaponReverseCommand = {

   local float it;
   local float am;

   it = self.items;
   self.impulse = FALSE;
   while ( TRUE ) {

      am = FALSE;
      if ( (self.weapon == IT_LIGHTNING) ) {

         self.weapon = IT_ROCKET_LAUNCHER;
         if ( (self.ammo_rockets < TRUE) ) {

            am = TRUE;

         }

      } else {

         if ( (self.weapon == IT_ROCKET_LAUNCHER) ) {

            self.weapon = IT_GRENADE_LAUNCHER;
            if ( (self.ammo_rockets < TRUE) ) {

               am = TRUE;

            }

         } else {

            if ( (self.weapon == IT_GRENADE_LAUNCHER) ) {

               self.weapon = IT_SUPER_NAILGUN;
               if ( (self.ammo_nails < FL_SWIM) ) {

                  am = TRUE;

               }

            } else {

               if ( (self.weapon == IT_SUPER_NAILGUN) ) {

                  self.weapon = IT_NAILGUN;
                  if ( (self.ammo_nails < TRUE) ) {

                     am = TRUE;

                  }

               } else {

                  if ( (self.weapon == IT_NAILGUN) ) {

                     self.weapon = IT_SUPER_SHOTGUN;
                     if ( (self.ammo_shells < FL_SWIM) ) {

                        am = TRUE;

                     }

                  } else {

                     if ( (self.weapon == IT_SUPER_SHOTGUN) ) {

                        self.weapon = IT_SHOTGUN;
                        if ( (self.ammo_shells < TRUE) ) {

                           am = TRUE;

                        }

                     } else {

                        if ( (self.weapon == IT_SHOTGUN) ) {

                           self.weapon = IT_AXE;

                        } else {

                           if ( (self.weapon == IT_AXE) ) {

                              self.weapon = IT_LIGHTNING;
                              if ( (self.ammo_cells < TRUE) ) {

                                 am = TRUE;

                              }

                           }

                        }

                     }

                  }

               }

            }

         }

      }
      if ( ((it & self.weapon) && (am == FALSE)) ) {

         W_SetCurrentAmmo ();
         return ;

      }

   }

};

void () ServerflagsCommand = {

   serverflags = ((serverflags * FL_SWIM) + TRUE);

};

void () QuadCheat = {

   if ( (deathmatch || coop) ) {

      return ;

   }
   self.super_time = TRUE;
   self.super_damage_finished = (time + SVC_INTERMISSION);
   self.items = (self.items | IT_QUAD);
   dprint ("quad cheat\n");

};

void () ImpulseCommands = {

   if ( ((self.impulse >= TRUE) && (self.impulse <= FL_CLIENT)) ) {

      if (!(self.classmonster) ) {

         W_ChangeWeapon ();

      }

   }
   if ( (self.impulse == MOVETYPE_FLYMISSILE) ) {

      CheatCommand ();

   }
   if ( (self.impulse == MOVETYPE_BOUNCE) ) {

      CycleWeaponCommand ();

   }
   if ( (self.impulse == MOVETYPE_BOUNCEMISSILE) ) {

      ServerflagsCommand ();

   }
   if ( (self.impulse == 12.000) ) {

      CycleWeaponReverseCommand ();

   }
   if ( (self.impulse == 255.000) ) {

      QuadCheat ();

   }
   self.impulse = FALSE;

};

void () W_WeaponFrame = {

   if ( (time < self.attack_finished) ) {

      return ;

   }
   ImpulseCommands ();
   if ( self.button0 ) {

      SuperDamageSound ();
      W_Attack ();

   }

};

void () SuperDamageSound = {

   if ( (self.super_damage_finished > time) ) {

      if ( (self.super_sound < time) ) {

         self.super_sound = (time + TRUE);
         sound (self,CHAN_BODY,"items/damage3.wav",TRUE,ATTN_NORM);

      }

   }
   return ;

};
