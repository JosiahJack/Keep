void() gremlin_glook1;
void() gremlin_jump1;
void() gremlin_jump12;
void() gremlin_setup;
void() gremlin_spawn1;
void() gremlin_look1;
void() gremlin_flip1;
void() gremlin_flip8;

float(float ammo) gremlin_ammo_steal = { // [FUNCTION]
	if (ammo > GREMLIN_AMMO_TAKE) return GREMLIN_AMMO_TAKE;
	return ammo;
};

void() gremlin_steal_shells = { // [FUNCTION]
      local float amount;

      amount = gremlin_ammo_steal(self.enemy.ammo_shells);
      self.enemy.ammo_shells = (self.enemy.ammo_shells - amount);
      self.ammo_shells = (self.ammo_shells + amount);
      self.currentammo = self.ammo_shells;
};

void() gremlin_steal_nails = { // [FUNCTION]
      local float amount;

      amount = gremlin_ammo_steal(self.enemy.ammo_nails);
      self.enemy.ammo_nails = (self.enemy.ammo_nails - amount);
      self.ammo_nails = (self.ammo_nails + amount);
      self.currentammo = self.ammo_nails;
};

void() gremlin_steal_rockets = { // [FUNCTION]
      float amount = gremlin_ammo_steal(self.enemy.ammo_rockets);
      self.enemy.ammo_rockets = (self.enemy.ammo_rockets - amount);
      self.ammo_rockets = (self.ammo_rockets + amount);
      self.currentammo = self.ammo_rockets;
};

void() gremlin_steal_cells = { // [FUNCTION]
      float amount = gremlin_ammo_steal(self.enemy.ammo_cells);
      self.enemy.ammo_cells = (self.enemy.ammo_cells - amount);
      self.ammo_cells = (self.ammo_cells + amount);
      self.currentammo = self.ammo_cells;
};

void() gremlin_steal_bolts = { // [FUNCTION]
      float amount = gremlin_ammo_steal(self.enemy.ammo_bolts);
      self.enemy.ammo_bolts = (self.enemy.ammo_bolts - amount);
      self.ammo_bolts = (self.ammo_bolts + amount);
      self.currentammo = self.ammo_bolts;
};

void() gremlin_steal_poison = { // [FUNCTION]
      float amount = gremlin_ammo_steal(self.enemy.ammo_poison);
      self.enemy.ammo_poison = (self.enemy.ammo_poison - amount);
      self.ammo_poison = (self.ammo_poison + amount);
      self.currentammo = self.ammo_poison;
};

void() gremlin_steal_multi_rockets = { // [FUNCTION]
      float amount = gremlin_ammo_steal(self.enemy.ammo_multi_rockets);
      self.enemy.ammo_multi_rockets = (self.enemy.ammo_multi_rockets - amount);
      self.ammo_multi_rockets = (self.ammo_multi_rockets + amount);
      self.currentammo = self.ammo_multi_rockets;
};

void() gremlin_steal_lava_nails = { // [FUNCTION]
      float amount = gremlin_ammo_steal(self.enemy.ammo_lava_nails);
      self.enemy.ammo_lava_nails = (self.enemy.ammo_lava_nails - amount);
      self.ammo_lava_nails = (self.ammo_lava_nails + amount);
      self.currentammo = self.ammo_lava_nails;
};

void() gremlin_steal_plasma = { // [FUNCTION]
      float amount = gremlin_ammo_steal(self.enemy.ammo_plasma);
      self.enemy.ammo_plasma = (self.enemy.ammo_plasma - amount);
      self.ammo_plasma = (self.ammo_plasma + amount);
      self.currentammo = self.ammo_plasma;
};

entity () GremlinFindVictim = { // [FUNCTION]
   local entity head, selected;
   local float dist, head_dist;

   self.search_time = (time + TRUE);
   selected = world;
   dist = 1000.000;
   head = findradius(self.origin,1000);
   while (head) {
      if (!Invisible(head) && (head.flags & FLx_CREATURE)) {
         if (head.health > 0 && head != self) {
            if (visible(head)) {
               head_dist = vlen ((head.origin - self.origin));
               if (head == self.lastvictim) head_dist = head_dist * 2;
               if ((head.flags & FL_CLIENT)) head_dist = head_dist / 1.5;
               if (head.classname == self.classname) head_dist = head_dist * 1.5;
               if (head_dist < dist) {
                  selected = head;
                  dist = head_dist;
               }
            }
         }
      }
      head = head.chain;
   }
   self.lastvictim = selected;
   return selected;
};

float () GremlinAttemptWeaponSteal = {
   local entity tempself, victim;
   local float wepID, wep;

   if (self.stoleweapon) return FALSE; // already stole a weapon
   if (!(self.enemy.flags & FL_CLIENT)) return FALSE; // only steal from players
   if ((vlen(self.enemy.origin - self.origin)) > 100.000) return FALSE; // not within 100 units
   if (random () < 0.500) return ( FALSE ); // 50% chance

   wepID = GetWepIDIndex(self.enemy.weapon,self.enemy.weaponismoditems);
   if (wepID == FALSE || wepID == ID_AXE_SHADAXE_CHAINSAW
       || wepID == ID_MACE || wepID == ID_GRAPPLE
       || wepID == ID_ICE || wepID == ID_SHOTGUN_BLASTER
       || wepID == ID_SUPER_SHOTGUN_WIDOWMAKER_SHOTCYCLER_QUADSHOTTY
       || wepID == ID_SCIMITAR || wepID == ID_RAPIER
       || wepID == ID_VOIDSTAFF || wepID == ID_SANGUINATORS
       || wepID == ID_THUNDERBOLT_AD_PLASMAGUN || wepID == ID_PLASMAGUN_ROGUE
       || wepID == ID_FLAK || wepID == ID_CHAINLIGHTNING
       || wepID == ID_WANDCROSS2 || wepID ==ID_MJOLNIR
       || wepID == ID_GUNGNIR || wepID == ID_AIRGUN) {
      return FALSE;
   }

   self.weapon = wep = self.enemy.weapon;
   self.weaponismoditems = self.enemy.weaponismoditems;
   if (wepID == ID_PROXIMITY_GRENADE || wepID == ID_LASER_CANNON) {
      self.enemy.items2 = (self.enemy.items2 - (self.enemy.items2 & self.weapon));
      self.items2 = (self.items2 | self.weapon);
   } else {
      self.enemy.items = (self.enemy.items - (self.enemy.items & self.weapon));
      self.items = (self.items | self.weapon);
   }

   // Take ammo along with the gun and sprint it to console
   if (wep == IT_SHOTGUN) {
      gremlin_steal_shells();
      sprint(self.enemy,"Gremlin stole your Shotgun\n");
   }
   if (wep == IT_SUPER_SHOTGUN) {
      gremlin_steal_shells();
      if (self.enemy.moditems & IT_UPGRADE_SSG) {
         self.moditems = self.moditems | IT_UPGRADE_SSG;
         sprint(self.enemy,"Gremlin stole your Widowmaker!\n");
      } else {
         sprint(self.enemy,"Gremlin stole your Double-Barrel Shotgun\n");
      }
   }
   if (wep == IT_NAILGUN) {
      gremlin_steal_nails();
      sprint(self.enemy,"Gremlin stole your Nailgun\n");
   }
   if (wep == IT_LAVA_NAILGUN) {
      gremlin_steal_lava_nails();
      sprint(self.enemy,"Gremlin stole your Lava Nailgun\n");
   }
   if (wep == IT_SUPER_NAILGUN) {
      gremlin_steal_nails();
      sprint(self.enemy,"Gremlin stole your Perforator\n");
   }
   if (wep == IT_LAVA_SUPER_NAILGUN) {
      gremlin_steal_lava_nails();
      sprint(self.enemy,"Gremlin stole your Lava Perforator!\n");
   }
   if (wep == IT_GRENADE_LAUNCHER) {
      gremlin_steal_rockets();
      sprint(self.enemy,"Gremlin stole your Grenade Launcher\n");
   }
   if (wep == IT2_PROXIMITY_GUN) {
      gremlin_steal_rockets();
      sprint(self.enemy,"Gremlin stole your Proximity Gun\n");
   }
   if (wep == IT_MULTI_GRENADE) {
      gremlin_steal_multi_rockets();
      sprint(self.enemy,"Gremlin stole your Multi-Grenade Launcher\n");
   }
   if (wep == IT_ROCKET_LAUNCHER) {
      gremlin_steal_rockets();
      sprint(self.enemy,"Gremlin stole your Rocket Launcher\n");
   }
   if (wep == IT_MULTI_ROCKET) {
      gremlin_steal_multi_rockets();
      sprint(self.enemy,"Gremlin stole your Multi-Rocket Launcher!\n");
   }
   if (wep == IT_LIGHTNING) {
      gremlin_steal_cells();
      if (self.enemy.moditems & IT_UPGRADE_LG) {
         self.moditems = self.moditems | IT_UPGRADE_LG;
         sprint(self.enemy,"Gremlin stole your Plasma Gun!\n");
      } else {
         sprint(self.enemy,"Gremlin stole your Thunderbolt\n");
      }
   }
   if (wep == IT_PLASMA_GUN) {
      gremlin_steal_plasma();
      sprint(self.enemy,"Gremlin stole your Plasma Lightning Gun\n");
   }
   if (wep == IT_EXTRA_WEAPON) {
      if (self.enemy.ammo_poison > FALSE) {
         gremlin_steal_poison();
      } else {
         gremlin_steal_bolts();
      }
      sprint(self.enemy,"Gremlin stole your Crossbow\n");
   }
   if (wep == IT2_LASER_CANNON) {
      gremlin_steal_cells();
      sprint(self.enemy,"Gremlin stole your Laser Cannon\n");
   }

   tempself = self;
   self = self.enemy; // switch to player we are stealing from
   self.weapon = W_BestWeapon (self);  // force switch to next best weapon
   W_SetCurrentAmmo(self,TRUE);  // check ammo now that we stole some
   self = tempself; // back to gremlin
   self.stoleweapon = TRUE;
   self.attack_finished = time;
   if ( (random () > 0.650) ) self.lastvictim = self.enemy;
   else self.lastvictim = self;

   victim = GremlinFindVictim();
   if (victim) {
      self.enemy = victim;
      FoundTarget();
      self.attack_finished = time;
      self.search_time = (time + TRUE);
   }
   return (TRUE);
};

float() GremlinFindTarget = {
   local entity head, gorge;
   local float dist, result;

   //FindTarget(); return; // FIX 2? 777
   if (self.enemy && self.enemy.gorging) return TRUE;

   if ( ((self.stoleweapon == FALSE) && (time > self.wait)) ) {
      self.wait = (time + TRUE);
      dist = 2000;
      gorge = world;
      head = nextent(world);
      while (head) {
         if (head.health < 1 && (head.flags & FL_MONSTER) && !head.gibbed) {
            if (head.classgroup != CG_HARMLESS) { // Don't eat denizens.
               if (!head.gorging) {
                  result = fabs(head.origin_z - self.origin_z);
                  if (visible(head) && result < 80) {
                     dist = visible_distance;
                     gorge = head;
                  }
               }
            }
         }
         head = nextent(head);
      }
      if ( ((gorge != world) && (dist < (700.000 * random ()))) ) {
         self.oldenemy = self.enemy;
         self.gorging = TRUE;
         self.enemy = gorge;
         self.enemy.gorging = TRUE;
         self.search_time = (time + MOVETYPE_STEP);
         FoundTarget();
         return TRUE;
      }
   } else {
      if (self.stoleweapon ) {
         head = GremlinFindVictim();
         if ( (head != world) ) {
            self.enemy = head;
            FoundTarget();
            self.attack_finished = time;
            self.search_time = (time + 2);
            return TRUE;
         }
      }
   }
   result = FindTarget();
   self.search_time = (time + 2);
   return result;
};

void(float dist) gremlin_walk = { // [FUNCTION]
   movedist = dist;
   if (GremlinFindTarget()) return;

   movetogoal(dist);
};

void() gremlin_stand = { // [FUNCTION]
   if ( FindTarget () )
      return ;

   if ( (time > self.pausetime) ) {
      self.th_walk();
      return ;
   }
};

float () GremlinCheckNoAmmo = { // [FUNCTION]
   if (self.currentammo > 0) return TRUE;

   self.stoleweapon = FALSE;
   return FALSE;
};

void(float dist) gremlin_run = {
   local float r, done, c, loopiter;
   local vector d, ang, end;

   if (self.health < 1) return;
   
   movedist = dist;
   movetogoal(dist);// return; FIX 1? 777
   if (self.stoleweapon) self.frame = ((self.frame + 164.000) - 29.000);

   if (self.gorging && self.enemy) {
      traceline (self.origin,self.enemy.origin,TRUE,self);
      if ( (trace_fraction != TRUE) ) {
         self.gorging = FALSE;
         return ;
      }

      if (!visible (self.enemy) ) {
         self.gorging = FALSE;
         return ;
      }

      r = vlen((self.enemy.origin - self.origin));
      if ( (r < 130.000) ) {
         ai_face();
         if ( (r < 45.000) ) {
            self.th_melee();
            self.attack_state = AS_STRAIGHT;
            return ;
         } else {
            if ( (walkmove (self.angles_y,dist) == FALSE) ) {
               self.gorging = FALSE;
               return;
            }
         }
         return ;
      }
      movetogoal(dist);
   } else {
      if ( (random () > 0.970) ) {
         if (GremlinFindTarget()) return;
      }
      if (self.stoleweapon && self.enemy) {
         if ( ((self.enemy.health < FALSE) && (self.enemy.classname == "player")) ) {
            gremlin_glook1();
            return ;
         }
         if ( !GremlinCheckNoAmmo () ) {
            if ( (self.t_length == TRUE) ) {
               remove (self.trigger_field);
               self.goalentity = self.enemy;
               self.t_length = FALSE;
            }
            return ;
         }
         r = vlen ((self.enemy.origin - self.origin));
         d = normalize ((self.origin - self.enemy.origin));
         if ( (self.t_length == FALSE) ) {
            if (r < 150) {
               self.trigger_field = spawn();
               setsize (self.trigger_field,'-1.000 -1.000 -1.000','1.000 1.000 1.000');
               self.t_length = TRUE;
            }
         }
         if ( (self.t_length == TRUE) ) {
            if ( (r > 250.000) ) {
               remove (self.trigger_field);
               self.goalentity = self.enemy;
               self.t_length = FALSE;
            } else {
               if ( (r < 160.000) ) {
                  ang = vectoangles (d);
                  done = FALSE;
                  c = 0;
                  loopiter = 0;
                  while (done == FALSE) {
                     loopiter = loopiter + 1;
                     if (loopiter >= 100) break;
                     makevectors(ang);
                     end = (self.enemy.origin + (v_forward * 350.000));
                     traceline (self.enemy.origin,end,FALSE,self);
                     if ( (trace_fraction == TRUE) ) {
                        traceline (self.origin,end,FALSE,self);
                        if ( (trace_fraction == TRUE) )
                           done = TRUE;
                     }
                     ang_y = anglemod ((ang_y + 36.000));
                     c = (c + 1);
                     if ((c == 10)) done = TRUE;
                  }
                  setorigin(self.trigger_field,end);
               }
               self.goalentity = self.trigger_field;
               self.ideal_yaw = vectoyaw (normalize ((self.goalentity.origin - self.origin)));
               ChangeYaw();
               movetogoal(dist);
               self.nextthink = (time + 0.100);
               return ;
            }
         }
      }



      // Inline ai_run() to fix infinite loop.
      local entity e, client;

      MonsterDeBuff();			// Check and apply poison
      if (self.ryuflags & RYU_REBEL) dist = ai_run_rebel (dist);
      if (self.slow_finished > time) dist = dist * 0.5;

      if (self.enemy) {
         if ((self.enemy.flags & FLx_CREATURE)) {
            if (visible(self.enemy)) {
               self.carry_time = 0;

               // Set yaw in case we need to face the fallen during the dance.
               self.ideal_yaw = vectoyaw (self.enemy.origin - self.origin);
            } else {
               self.carry_time = self.carry_time + 0.1;	
            }
         }
      }

      if (self.hasobject == "true") take_monster_object(self); // drop our stuff

      // Is the enemy dead or no longer taking damage?
      if (self.enemy.health < 1 || self.enemy.takedamage == DAMAGE_NO
          || self.enemyexit) {

         self.enemyexit = FALSE; // Reset any exit conditions
         self.enemy = self.goalentity = self.movetarget = world; // Reset enemy and target system

         // Is the old enemy still alive and can it be damaged?
         if (self.oldenemy.health > 0 && self.oldenemy.takedamage > 0) {
            self.enemy = self.oldenemy;
            HuntTarget();
         } else {
            if (self.passive_mode == TRUE) { // Was this a passive monster before combat?
               // Return to passive monster state (reset)
               self.passive_state = MON_PASSIVESTATE_RESET;
               check_passivestate_system(self);
               if (self.charmer) HuntCharmer(); // Go follow our leader again
            } else {
               if (self.charmer) {
                  HuntCharmer(); // Go follow our leader again
                  return; // Exit run function
               }

               // Go back on the beat
               if (self.target != "") self.movetarget = find(world, targetname, self.target); // Monster busy with something else?
               
               if (self.movetarget.classtype == CT_PATHCORNER) { // Check for path corners (patrols) and return to stand/walk
                  self.goalentity = self.movetarget;
                  self.think = self.th_walk;
               } else self.think = self.th_stand;
            }

            if (self.movetarget || self.charmer) self.th_walk();
            else self.th_stand();
            return; // Exit run function
         }
      }
      
      W_ShowHostile(); // Wake up other monsters.
      enemy_vis = visible(self.enemy); // check visibility of enemy
      if (enemy_vis) {
         self.search_time = time + 5;
         self.calm_memory_finished = time + 2;
         self.enemylastseen = time; // The last time the enemy was in sight
      } else {
         if (IsLoyal(self)) {
            if (!self.charmer) { // already have a leader to follow
               client = SeeFriendly(); // hey buddy!
               if (client) {
                  if ((IsLeader(client))) { FollowTheLeader(client); return; }
               }
            }
         }
         if (self.temperament == TEMPRA_COWARDLY) self.search_time = time - 1; // forget it, too SCARY!
      }

      // look for other coop players or go back to leader
      if ((coop || self.charmer) && self.search_time < time) {
         if (self.charmer) {  // already have a leader to follow
            // dprint("Ok boss, let's get out of here\n");
            self.enemy = self.oldenemy = world;
            HuntCharmer();	
            FindTarget();
            return;
         } else {
            if (IsLoyal(self) && self.calm_memory_finished < time) { // Find a leader
               client = SeeFriendly(); // hey buddy!
               if (client) {
                  if ((IsLeader(client))) { FollowTheLeader(client); return; }
               }
            }
         }
         if (FindTarget()) return;
      }

      if (self.enemy == world) return;

      // Calculate if goal/enemy is infront, the range and direction
      enemy_infront = infront(self.enemy);
      enemy_range = range(self.enemy);
      enemy_yaw = vectoyaw(self.enemy.origin - self.origin);
      self.enemydist = range_distance(self.enemy,FALSE);

      // Check for temporary turret mode via trigger_monsterturret
      if (self.turretactive.classtype == CT_TRIGMONTURRET && enemy_vis && self.th_missile) {
         if (self.turrettimer < time) {
            // Is there a chance to pause?
            if (random() < self.turretactive.count)  self.turrettimer = time + 1 + random()*2;
            self.attack_state = AS_TURRET;
            ai_facingideal_action(self.th_missile);
            return;
         }
      }
      
      // Check if tether system is active
      if (check_tethersystem() && self.health > 0) {
         self.tetherlock = TRUE;
         if (self.th_tether) self.think = self.th_tether;
         return;
      }

      if (check_passivestate_system(self)) return; // Check for the passive state system (reset/timer etc)

      CheckBlockedBreakable(); // Check if blocked by breakables
      if (self.attack_state == AS_MISSILE) {
         // Turn in place until within an angle to launch a missile attack
         ai_facingideal_action(self.th_missile);
         return;
      } else if (self.attack_state == AS_MELEE) {
         // Turn and close until within an angle to launch a melee attack
         ai_facingideal_action(self.th_melee);
         return;
      }

      if (self.enemymaxdist || self.attack_sniper || self.enemydist < MON_MAX_RANGE) {
         GremlinCheckAttack();
      }

      movetogoal(dist);
   }
};

void() gremlin_stand1 = [ 0.000, gremlin_stand2 ] { gremlin_stand(); self.nextthink = (time + 0.200); };
void() gremlin_stand2 = [ 1.000, gremlin_stand3 ] { gremlin_stand(); self.nextthink = (time + 0.200); };
void() gremlin_stand3 = [ 2.000, gremlin_stand4 ] { gremlin_stand(); self.nextthink = (time + 0.200); };
void() gremlin_stand4 = [ 3.000, gremlin_stand5 ] { gremlin_stand(); self.nextthink = (time + 0.200); };
void() gremlin_stand5 = [ 4.000, gremlin_stand6 ] { gremlin_stand(); self.nextthink = (time + 0.200); };
void() gremlin_stand6 = [ 5.000, gremlin_stand7 ] { gremlin_stand(); self.nextthink = (time + 0.200); };
void() gremlin_stand7 = [ 6.000, gremlin_stand8 ] { gremlin_stand(); self.nextthink = (time + 0.200); };
void() gremlin_stand8 = [ 7.000, gremlin_stand9 ] { gremlin_stand(); self.nextthink = (time + 0.200); };
void() gremlin_stand9 = [ 8.000, gremlin_stand10 ] { gremlin_stand(); self.nextthink = (time + 0.200); };
void() gremlin_stand10 = [ 9.000, gremlin_stand11 ] { gremlin_stand(); self.nextthink = (time + 0.200); };
void() gremlin_stand11 = [ 10.000, gremlin_stand12 ] { gremlin_stand(); self.nextthink = (time + 0.200); };
void() gremlin_stand12 = [ 11.000, gremlin_stand13 ] { gremlin_stand(); self.nextthink = (time + 0.200); };
void() gremlin_stand13 = [ 12.000, gremlin_stand14 ] { gremlin_stand(); self.nextthink = (time + 0.200); };
void() gremlin_stand14 = [ 13.000, gremlin_stand15 ] { gremlin_stand(); self.nextthink = (time + 0.200); };
void() gremlin_stand15 = [ 14.000, gremlin_stand16 ] { gremlin_stand(); self.nextthink = (time + 0.200); };
void() gremlin_stand16 = [ 15.000, gremlin_stand17 ] { gremlin_stand(); self.nextthink = (time + 0.200); };
void() gremlin_stand17 = [ 16.000, gremlin_stand1 ] { gremlin_stand(); self.nextthink = (time + 0.200); };

void() gremlin_walk1 = [ 17.000, gremlin_walk2 ] {
   if ( (random () < 0.100) )
      sound(self,CHAN_VOICE,"hipnotic/grem/idle.wav",TRUE,ATTN_IDLE);

   gremlin_walk (8);
};
void() gremlin_walk2 = [ 18.000, gremlin_walk3 ] { gremlin_walk (6); };
void() gremlin_walk3 = [ 19.000, gremlin_walk4 ] { gremlin_walk (8); };
void() gremlin_walk4 = [ 20.000, gremlin_walk5 ] { gremlin_walk (16);monster_footstep(FALSE); };
void() gremlin_walk5 = [ 21.000, gremlin_walk6 ] { gremlin_walk (8); };
void() gremlin_walk6 = [ 22.000, gremlin_walk7 ] { gremlin_walk (4); };
void() gremlin_walk7 = [ 23.000, gremlin_walk8 ] { gremlin_walk (2); };
void() gremlin_walk8 = [ 24.000, gremlin_walk9 ] { gremlin_walk (16); monster_footstep(FALSE); };
void() gremlin_walk9 = [ 25.000, gremlin_walk10 ] { gremlin_walk (10); };
void() gremlin_walk10 = [ 26.000, gremlin_walk11 ] { gremlin_walk (8); };
void() gremlin_walk11 = [ 27.000, gremlin_walk12 ] { gremlin_walk (6); };
void() gremlin_walk12 = [ 28.000, gremlin_walk1 ] { gremlin_walk (4); };

void() gremlin_run1 = [ 29.000, gremlin_run2 ] {
   if (random () < 0.1) sound(self,CHAN_VOICE,"hipnotic/grem/idle.wav",TRUE,ATTN_IDLE);
   monster_footstep(FALSE);
   gremlin_run(0);
};
void() gremlin_run2 = [ 30.000, gremlin_run3 ] { gremlin_run(8); };
void() gremlin_run3 = [ 31.000, gremlin_run4 ] { gremlin_run(12); };
void() gremlin_run4 = [ 32.000, gremlin_run5 ] { gremlin_run(24); }; // Was 16, -Qmaster
void() gremlin_run5 = [ 33.000, gremlin_run6 ] { gremlin_run(24); }; // Was 16, -Qmaster
void() gremlin_run6 = [ 34.000, gremlin_run7 ] { gremlin_run(12); };
void() gremlin_run7 = [ 35.000, gremlin_run8 ] { gremlin_run(8); };
void() gremlin_run8 = [ 36.000, gremlin_run9 ] { gremlin_run(0); };
void() gremlin_run9 = [ 37.000, gremlin_run10 ] { gremlin_run(8); monster_footstep(FALSE); };
void() gremlin_run10 = [ 38.000, gremlin_run11 ] { gremlin_run(12); };
void() gremlin_run11 = [ 39.000, gremlin_run12 ] { gremlin_run(24); }; // Was 16, -Qmaster
void() gremlin_run12 = [ 40.000, gremlin_run13 ] { gremlin_run(24); }; // Was 16, -Qmaster
void() gremlin_run13 = [ 41.000, gremlin_run14 ] { gremlin_run(12); };
void() gremlin_run14 = [ 42.000, gremlin_run15 ] { gremlin_run(8); };
void() gremlin_run15 = [ 43.000, gremlin_run1 ] { gremlin_run(2); monster_footstep(FALSE); }; // Was 0, -Qmaster

void() Gremlin_JumpTouch = { // [FUNCTION]
   if ( (self.health <= FALSE) ) return ;

   if ( !checkbottom (self) ) {
      if ( (self.flags & FL_ONGROUND) ) {
         self.touch = SUB_Null;
         self.think = gremlin_jump1;
         self.nextthink = (time + 0.100);
      }
      return ;
   }
   self.touch = SUB_Null;
   self.think = gremlin_jump12;
   self.nextthink = (time + 0.100);
};

void() gremlin_jump1 = [ 44.000, gremlin_jump2 ] { ai_face(); };
void() gremlin_jump2 = [ 45.000, gremlin_jump3 ] { ai_face(); };
void() gremlin_jump3 = [ 46.000, gremlin_jump4 ] { ai_face(); };
void() gremlin_jump4 = [ 47.000, gremlin_jump5 ] { ai_face(); monster_footstep(FALSE); };
void() gremlin_jump5 = [ 48.000, gremlin_jump6 ] {
   ai_face();
   if ((self.flags & FL_ONGROUND)) {
      self.touch = Gremlin_JumpTouch;
      makevectors(self.angles);
      self.origin_z = (self.origin_z + TRUE);
      self.velocity = ((v_forward * 300.000) + '0.000 0.000 300.000');
      SUB_RemoveFlags(self,FL_ONGROUND);
   } else {
      gremlin_run1();
   }
};
void() gremlin_jump6 = [ 49.000, gremlin_jump7 ] {};
void() gremlin_jump7 = [ 50.000, gremlin_jump8 ] {};
void() gremlin_jump8 = [ 51.000, gremlin_jump9 ] {};
void() gremlin_jump9 = [ 52.000, gremlin_jump10 ] {};
void() gremlin_jump10 = [ 53.000, gremlin_jump11 ] {};
void() gremlin_jump11 = [ 54.000, gremlin_jump1 ] { self.nextthink = (time + MOVETYPE_WALK); };
void() gremlin_jump12 = [ 55.000, gremlin_jump13 ] {};
void() gremlin_jump13 = [ 56.000, gremlin_jump14 ] {};
void() gremlin_jump14 = [ 57.000, gremlin_jump15 ] {};
void() gremlin_jump15 = [ 58.000, gremlin_jump16 ] {};
void() gremlin_jump16 = [ 59.000, gremlin_run1 ] {};

void() gremlin_shot1 = [ 135.000, gremlin_shot2 ] {};
void() gremlin_shot2 = [ 136.000, gremlin_shot3 ] {};
void() gremlin_shot3 = [ 137.000, gremlin_shot4 ] {};
void() gremlin_shot4 = [ 138.000, gremlin_shot5 ] {};
void() gremlin_shot5 = [ 139.000, gremlin_shot6 ] {};
void() gremlin_shot6 = [ 140.000, gremlin_run1 ] {};

void() GremlinFireSpikes = { // [FUNCTION]
	local vector dir;

	dir = normalize ((self.enemy.origin - self.origin));
	self.v_angle = vectoangles (dir);
	makevectors(self.v_angle);
	dir = ((dir + ((crandom () * 0.100) * v_right)) + ((crandom () * 0.100) * v_up));
	dir = normalize (dir);
	if (self.ammo_nails > 1 && self.weapon == IT_SUPER_NAILGUN) {
		sound(self,CHAN_WEAPON,"weapons/spike2.wav",1,ATTN_NORM);
		self.currentammo = self.currentammo - 2;
		self.ammo_nails = self.ammo_nails - 2;
		launch_projectile((self.origin + '0 0 16'),dir,NO_SPIN,CT_PROJ_SNG,SPEED_PLAYSPIKE);
	} else {
		sound(self,CHAN_WEAPON,"weapons/rocket1i.wav",1,ATTN_NORM);
		self.currentammo = self.currentammo - 1;
		self.ammo_nails = self.ammo_nails - 1;
		launch_projectile((self.origin + '0 0 16'),dir,NO_SPIN,CT_PROJ_NG,SPEED_PLAYSPIKE);
	}
};

void() GremlinFireLavaSpikes = { // [FUNCTION]
	local vector dir;

	dir = normalize ((self.enemy.origin - self.origin));
	self.v_angle = vectoangles (dir);
	makevectors(self.v_angle);
	dir = ((dir + ((crandom () * 0.100) * v_right)) + ((crandom () * 0.100) * v_up));
	dir = normalize (dir);
	if (self.ammo_lava_nails > 1 && self.weapon == IT_LAVA_SUPER_NAILGUN) {
		sound(self,CHAN_WEAPON,"weapons/spike2.wav",1,ATTN_NORM);
		self.currentammo = self.currentammo - 2;
		self.ammo_lava_nails = self.ammo_lava_nails - 2;
		launch_projectile((self.origin + '0 0 16'),dir,NO_SPIN,CT_PROJ_LAVASNG,SPEED_PLAYSPIKE);
	} else {
		sound(self,CHAN_WEAPON,"weapons/rocket1i.wav",1,ATTN_NORM);
		self.currentammo = self.currentammo - 1;
		self.ammo_lava_nails = self.ammo_lava_nails - 1;
		launch_projectile((self.origin + '0 0 16'),dir,NO_SPIN,CT_PROJ_LAVANG,SPEED_PLAYSPIKE);
	}
};

void() gremlin_nail1 = [ 135.000, gremlin_nail2 ] { GremlinFireSpikes(); };
void() gremlin_nail2 = [ 135.000, gremlin_nail3 ] { GremlinFireSpikes(); };
void() gremlin_nail3 = [ 135.000, gremlin_nail4 ] { GremlinFireSpikes(); };
void() gremlin_nail4 = [ 135.000, gremlin_nail5 ] { GremlinFireSpikes(); };
void() gremlin_nail5 = [ 135.000, gremlin_nail6 ] { GremlinFireSpikes(); };
void() gremlin_nail6 = [ 135.000, gremlin_nail7 ] { GremlinFireSpikes(); };
void() gremlin_nail7 = [ 135.000, gremlin_nail8 ] { GremlinFireSpikes(); };
void() gremlin_nail8 = [ 135.000, gremlin_run1 ] { GremlinFireSpikes(); };

void() gremlin_lava_nail1 = [ 135.000, gremlin_lava_nail2 ] { GremlinFireLavaSpikes(); };
void() gremlin_lava_nail2 = [ 135.000, gremlin_lava_nail3 ] { GremlinFireLavaSpikes(); };
void() gremlin_lava_nail3 = [ 135.000, gremlin_lava_nail4 ] { GremlinFireLavaSpikes(); };
void() gremlin_lava_nail4 = [ 135.000, gremlin_lava_nail5 ] { GremlinFireLavaSpikes(); };
void() gremlin_lava_nail5 = [ 135.000, gremlin_lava_nail6 ] { GremlinFireLavaSpikes(); };
void() gremlin_lava_nail6 = [ 135.000, gremlin_lava_nail7 ] { GremlinFireLavaSpikes(); };
void() gremlin_lava_nail7 = [ 135.000, gremlin_lava_nail8 ] { GremlinFireLavaSpikes(); };
void() gremlin_lava_nail8 = [ 135.000, gremlin_run1 ] { GremlinFireLavaSpikes(); sound(self,CHAN_WEAPON,"rogue/weapons/snail.wav",1,ATTN_NORM); };

void() gremlin_snail1 = [ 135.000, gremlin_snail2 ] { GremlinFireSpikes(); };
void() gremlin_snail2 = [ 135.000, gremlin_snail3 ] { GremlinFireSpikes(); };
void() gremlin_snail3 = [ 135.000, gremlin_snail4 ] { GremlinFireSpikes(); };
void() gremlin_snail4 = [ 135.000, gremlin_snail5 ] { GremlinFireSpikes(); };
void() gremlin_snail5 = [ 135.000, gremlin_snail6 ] { GremlinFireSpikes(); };
void() gremlin_snail6 = [ 135.000, gremlin_snail7 ] { GremlinFireSpikes(); };
void() gremlin_snail7 = [ 135.000, gremlin_snail8 ] { GremlinFireSpikes(); };
void() gremlin_snail8 = [ 135.000, gremlin_run1 ] { GremlinFireSpikes(); };

void() gremlin_lava_snail1 = [ 135.000, gremlin_lava_snail2 ] { GremlinFireLavaSpikes(); };
void() gremlin_lava_snail2 = [ 135.000, gremlin_lava_snail3 ] { GremlinFireLavaSpikes(); };
void() gremlin_lava_snail3 = [ 135.000, gremlin_lava_snail4 ] { GremlinFireLavaSpikes(); };
void() gremlin_lava_snail4 = [ 135.000, gremlin_lava_snail5 ] { GremlinFireLavaSpikes(); };
void() gremlin_lava_snail5 = [ 135.000, gremlin_lava_snail6 ] { GremlinFireLavaSpikes(); };
void() gremlin_lava_snail6 = [ 135.000, gremlin_lava_snail7 ] { GremlinFireLavaSpikes(); };
void() gremlin_lava_snail7 = [ 135.000, gremlin_lava_snail8 ] { GremlinFireLavaSpikes(); };
void() gremlin_lava_snail8 = [ 135.000, gremlin_run1 ] { GremlinFireLavaSpikes(); sound(self,CHAN_WEAPON,"rogue/weapons/snail.wav",1,ATTN_NORM); };

void() GremlinFireLaser = { // [FUNCTION]
	local vector org, dir;

	self.currentammo = self.ammo_cells = self.ammo_cells - 1;
	dir = normalize ((self.enemy.origin - self.origin));
	self.v_angle = vectoangles (dir);
	makevectors(self.v_angle);
	dir = ((dir + ((crandom () * 0.100) * v_right)) + ((crandom () * 0.100) * v_up));
	dir = normalize (dir);
	sound(self,CHAN_WEAPON,"hipnotic/weapons/laserg.wav",TRUE,ATTN_NORM);
	self.attack_finished = time + 0.9;
	org = self.origin + '0 0 16';
	HIP_LaunchLaser (org,dir,TRUE);
};

void() gremlin_laser1 = [ 135.000, gremlin_laser2 ] { GremlinFireLaser(); self.attack_finished = (time + 0.100); };
void() gremlin_laser2 = [ 135.000, gremlin_run1 ] { GremlinFireLaser(); self.attack_finished = (time + 0.100); };

void() GremlinFireLightning = {
   local vector org;
   local vector dir;
   local float cells;

   if ( (self.watertype <= CONTENT_WATER) ) {
      cells = self.ammo_cells;
      self.ammo_cells = FALSE;
      discharged = TRUE;
      T_RadiusDamage(self,self,(35.000 * cells),world,DAMAGEALL);
      discharged = FALSE;
      return ;
   }
   self.effects = (self.effects | EF_MUZZLEFLASH);
   ai_face();
   self.ammo_cells = self.ammo_cells - 1;
   self.currentammo = self.currentammo - 1;
   self.v_angle = vectoangles (dir);
   makevectors(self.v_angle);
   org = (self.origin + '0.000 0.000 16.000');
   dir = ((self.enemy.origin + '0.000 0.000 16.000') - org);
   dir = normalize (dir);
   dir = ((dir + ((crandom () * 0.100) * v_right)) + ((crandom () * 0.100) * v_up));
   traceline (org,(self.origin + (dir * 600.000)),TRUE,self);
   Tent_Beam(TE_LIGHTNING2,self,org,trace_endpos);
   LightningDamage(org,trace_endpos+ (dir * MOVETYPE_STEP),self,SVC_INTERMISSION);
};

void() gremlin_light1 = [ 135.000, gremlin_light2 ] { GremlinFireLightning(); };
void() gremlin_light2 = [ 135.000, gremlin_light3 ] { GremlinFireLightning(); };
void() gremlin_light3 = [ 135.000, gremlin_light4 ] { GremlinFireLightning(); };
void() gremlin_light4 = [ 135.000, gremlin_light5 ] { GremlinFireLightning(); };
void() gremlin_light5 = [ 135.000, gremlin_run1 ] { GremlinFireLightning(); };

void() gremlin_grenade1 = [ 135.000, gremlin_grenade2 ] { self.effects = (self.effects | EF_MUZZLEFLASH); MonsterGrenadeSound(); self.attack_speed = MonsterGrenadeSpeed(); self.attack_elev = SUB_Elevation(ELEV_DEFAULT, self.origin, self.enemy.origin, self.attack_speed); };
void() gremlin_grenade2 = [ 136.000, gremlin_grenade3 ] { self.attack_elev = SUB_Elevation(ELEV_DEFAULT, self.origin, self.enemy.origin, self.attack_speed); };
void() gremlin_grenade3 = [ 137.000, gremlin_grenade4 ] { self.attack_elev = SUB_Elevation(ELEV_DEFAULT, self.origin, self.enemy.origin, self.attack_speed); };
void() gremlin_grenade4 = [ 138.000, gremlin_grenade5 ] { MonsterFireGrenade(self.origin, self.enemy.origin); self.currentammo = self.currentammo - 1; self.ammo_rockets = self.ammo_rockets -1; };
void() gremlin_grenade5 = [ 139.000, gremlin_grenade6 ] {};
void() gremlin_grenade6 = [ 140.000, gremlin_run1 ] {};

void() gremlin_prox1 = [ 135.000, gremlin_prox2 ] { self.effects = (self.effects | EF_MUZZLEFLASH); MonsterGrenadeSound(); self.attack_speed = MonsterGrenadeSpeed(); self.attack_elev = SUB_Elevation(ELEV_DEFAULT, self.origin, self.enemy.origin, self.attack_speed); };
void() gremlin_prox2 = [ 136.000, gremlin_prox3 ] { self.attack_elev = SUB_Elevation(ELEV_DEFAULT, self.origin, self.enemy.origin, self.attack_speed); };
void() gremlin_prox3 = [ 137.000, gremlin_prox4 ] { self.attack_elev = SUB_Elevation(ELEV_DEFAULT, self.origin, self.enemy.origin, self.attack_speed); };
void() gremlin_prox4 = [ 138.000, gremlin_prox5 ] { MonsterFireGrenade(self.origin, self.enemy.origin); self.currentammo = self.currentammo - 1; self.ammo_rockets = self.ammo_rockets -1; };
void() gremlin_prox5 = [ 139.000, gremlin_prox6 ] {};
void() gremlin_prox6 = [ 140.000, gremlin_run1 ] {};

void() gremlin_multi_grenade1 = [ 135.000, gremlin_multi_grenade2 ] { self.effects = (self.effects | EF_MUZZLEFLASH); MonsterGrenadeSound(); self.attack_speed = MonsterGrenadeSpeed(); self.attack_elev = SUB_Elevation(ELEV_DEFAULT, self.origin, self.enemy.origin, self.attack_speed); };
void() gremlin_multi_grenade2 = [ 136.000, gremlin_multi_grenade3 ] { self.attack_elev = SUB_Elevation(ELEV_DEFAULT, self.origin, self.enemy.origin, self.attack_speed); };
void() gremlin_multi_grenade3 = [ 137.000, gremlin_multi_grenade4 ] { self.attack_elev = SUB_Elevation(ELEV_DEFAULT, self.origin, self.enemy.origin, self.attack_speed); };
void() gremlin_multi_grenade4 = [ 138.000, gremlin_multi_grenade5 ] { MonsterFireGrenade(self.origin, self.enemy.origin); self.currentammo = self.currentammo - 1; self.ammo_multi_rockets = self.ammo_multi_rockets -1; };
void() gremlin_multi_grenade5 = [ 139.000, gremlin_multi_grenade6 ] {};
void() gremlin_multi_grenade6 = [ 140.000, gremlin_run1 ] {};

void() GremlinFireRocket = {
	local vector dir;

	dir = normalize ((self.enemy.origin - self.origin));
	self.v_angle = vectoangles (dir);
	makevectors(self.v_angle);
	dir = ((dir + ((crandom () * 0.100) * v_right)) + ((crandom () * 0.100) * v_up));
	dir = normalize (dir);
	sound(self,CHAN_WEAPON,"weapons/sgun1.wav",1,ATTN_NORM);
	self.currentammo = self.currentammo - 1;
	self.ammo_rockets = self.ammo_rockets - 1;
	launch_projectile((self.origin + '0 0 16'),dir,NO_SPIN,CT_PROJ_ARMY,SPEED_RLPLAYER);
};

void() gremlin_rocket1 = [ 135.000, gremlin_rocket2 ] {};
void() gremlin_rocket2 = [ 136.000, gremlin_rocket3 ] {};
void() gremlin_rocket3 = [ 137.000, gremlin_rocket4 ] {};
void() gremlin_rocket4 = [ 138.000, gremlin_rocket5 ] { GremlinFireRocket(); };
void() gremlin_rocket5 = [ 139.000, gremlin_rocket6 ] {};
void() gremlin_rocket6 = [ 140.000, gremlin_run1 ] {};

void() GremlinFireMultiRocket = {
	local vector dir;

	dir = normalize ((self.enemy.origin - self.origin));
	self.v_angle = vectoangles (dir);
	makevectors(self.v_angle);
	dir = ((dir + ((crandom () * 0.100) * v_right)) + ((crandom () * 0.100) * v_up));
	dir = normalize (dir);
	sound(self,CHAN_WEAPON,"weapons/sgun1.wav",1,ATTN_NORM);
	self.currentammo = self.currentammo - 1;
	self.ammo_multi_rockets = self.ammo_multi_rockets - 1;
	MultiRocketLaunch(-10.000,2);
	MultiRocketLaunch(CONTENT_LAVA,MOVETYPE_WALK);
	MultiRocketLaunch(5,FALSE);
	MultiRocketLaunch(10,TRUE);
};

void() gremlin_multi_rocket1 = [ 135.000, gremlin_multi_rocket2 ] {};
void() gremlin_multi_rocket2 = [ 136.000, gremlin_multi_rocket3 ] {};
void() gremlin_multi_rocket3 = [ 137.000, gremlin_multi_rocket4 ] {};
void() gremlin_multi_rocket4 = [ 138.000, gremlin_multi_rocket5 ] { GremlinFireMultiRocket(); };
void() gremlin_multi_rocket5 = [ 139.000, gremlin_multi_rocket6 ] {};
void() gremlin_multi_rocket6 = [ 140.000, gremlin_run1 ] {};

void() GremlinFirePlasma = {
	local vector org, dir;

	dir = normalize ((self.enemy.origin - self.origin));
	self.v_angle = vectoangles (dir);
	makevectors(self.v_angle);
	dir = ((dir + ((crandom () * 0.100) * v_right)) + ((crandom () * 0.100) * v_up));
	dir = normalize (dir);
	org = self.origin + '0.000 0.000 16.000';
	sound(self,CHAN_WEAPON,"ad171/weapons/plasma_fire.wav",1,ATTN_NORM);
	self.currentammo = self.currentammo - 1;
	self.ammo_cells = self.ammo_cells - 1;
	launch_projectile(org,dir,NO_SPIN,CT_PROJ_PLASMA,SPEED_PLAYPLASMA);
};

void() gremlin_plasma1 = [135.000, gremlin_plasma2] { GremlinFirePlasma(); };
void() gremlin_plasma2 = [135.000, gremlin_run1] { GremlinFirePlasma(); };

void() GremlinFirePlasmaGun = {
	local vector dir;
	local entity missile;

	if (self.attack_finished > time) return;

	dir = normalize ((self.enemy.origin - self.origin));
	self.v_angle = vectoangles (dir);
	makevectors(self.v_angle);
	dir = ((dir + ((crandom () * 0.100) * v_right)) + ((crandom () * 0.100) * v_up));
	dir = normalize (dir);
	sound(missile,CHAN_WEAPON,"rogue/plasma/flight.wav",TRUE,ATTN_NORM);
	self.currentammo = self.currentammo - 1;
	sound(self,CHAN_WEAPON,"rogue/plasma/fire.wav",0.500,ATTN_NORM);
	self.punchangle_x = CONTENT_SOLID;
	missile = spawn();
	missile.classgroup = CG_PROJALL;
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "plasma";
	makevectors(self.v_angle);
	missile.velocity = aim (self,1250);
	missile.velocity = (missile.velocity * 1250);
	missile.avelocity = '300.000 300.000 300.000';
	missile.angles = vectoangles (missile.velocity);
	missile.touch = PlasmaTouch;
	setmodel(missile,"progs/plasma.mdl");
	setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
	setorigin(missile,((self.origin + (v_forward * FL_CLIENT)) + '0.000 0.000 16.000'));
	sound(missile,CHAN_WEAPON,"rogue/plasma/flight.wav",TRUE,ATTN_NORM);
	missile.think = PlasmaGroundOut;
	missile.nextthink = (time + 5);
	self.attack_finished = time + 0.8;
};

void() gremlin_plasmalight1 = [135.000, gremlin_run1] { GremlinFirePlasmaGun(); };

void() GremlinFireCrossbow = {
	local vector org, dir;

	self.currentammo = self.ammo_bolts = self.ammo_bolts - 1;

	dir = normalize ((self.enemy.origin - self.origin));
	self.v_angle = vectoangles (dir);
	makevectors(self.v_angle);
	dir = ((dir + ((crandom () * 0.100) * v_right)) + ((crandom () * 0.100) * v_up));
	dir = normalize (dir);
	sound(self,CHAN_WEAPON,"ad171/weapons/crossbow_fire.wav",1,ATTN_NORM);
	self.attack_finished = time + 0.9;

	org = self.origin + '0 0 16';
	if (self.ammo_poison > 0) {
		launch_projectile(org,dir,NO_SPIN,CT_PROJ_BOLT2,SPEED_DCROSS + (skill*SPEED_BOLTSKILL));
	} else {
		launch_projectile(org,dir,NO_SPIN,CT_PROJ_BOLT1,SPEED_DCROSS + (skill*SPEED_BOLTSKILL));
	}
};

void() gremlin_crossbow1 = [ 135.000, gremlin_crossbow2 ] {};
void() gremlin_crossbow2 = [ 136.000, gremlin_crossbow3 ] {};
void() gremlin_crossbow3 = [ 137.000, gremlin_crossbow4 ] {};
void() gremlin_crossbow4 = [ 138.000, gremlin_crossbow5 ] { GremlinFireCrossbow(); };
void() gremlin_crossbow5 = [ 139.000, gremlin_crossbow6 ] {};
void() gremlin_crossbow6 = [ 140.000, gremlin_run1 ] {};

void(float side) Gremlin_Melee = {
   local float ldmg;
   local vector delta;

   ai_face();
   delta = (self.enemy.origin - self.origin);
   if (vlen(delta) > 100) return;
   if (!CanDamage(self.enemy,self)) return;

   sound(self,CHAN_WEAPON,"hipnotic/grem/attack.wav",TRUE,ATTN_NORM);
   ldmg = (10 + (5 * random ()));
   T_Damage(self.enemy,self,self,ldmg,DAMARMOR);
   SpawnMeatSpray(self,self.enemy,side);
};

void() gremlin_lunge1 = [ 124.000, gremlin_lunge2 ] { ai_charge(FALSE); };
void() gremlin_lunge2 = [ 125.000, gremlin_lunge3 ] { ai_charge(FALSE); };
void() gremlin_lunge3 = [ 126.000, gremlin_lunge4 ] { ai_charge(FALSE); };
void() gremlin_lunge4 = [ 127.000, gremlin_lunge5 ] { ai_charge(FALSE); };
void() gremlin_lunge5 = [ 128.000, gremlin_lunge6 ] { ai_charge(FALSE); };
void() gremlin_lunge6 = [ 129.000, gremlin_lunge7 ] { ai_charge(FALSE); };
void() gremlin_lunge7 = [ 130.000, gremlin_lunge8 ] { ai_charge(18.000); }; // Was 15, -Qmaster
void() gremlin_lunge8 = [ 131.000, gremlin_lunge9 ] { ai_charge(1); Gremlin_Melee (FALSE); }; // Was 0, -Qmaster
void() gremlin_lunge9 = [ 132.000, gremlin_lunge10 ] { ai_charge(FALSE); };
void() gremlin_lunge10 = [ 133.000, gremlin_lunge11 ] { ai_charge(FALSE); };
void() gremlin_lunge11 = [ 134.000, gremlin_run1 ] { ai_charge(FALSE); };

void() gremlin_claw1 = [ 60.000, gremlin_claw2 ] { ai_charge(FALSE); };
void() gremlin_claw2 = [ 61.000, gremlin_claw3 ] { ai_charge(FALSE); };
void() gremlin_claw3 = [ 62.000, gremlin_claw4 ] { ai_charge(FALSE); };
void() gremlin_claw4 = [ 63.000, gremlin_claw5 ] { ai_charge(FALSE); };
void() gremlin_claw5 = [ 64.000, gremlin_claw6 ] { ai_charge(FALSE); };
void() gremlin_claw6 = [ 65.000, gremlin_claw7 ] { ai_charge(FALSE); Gremlin_Melee (200); };
void() gremlin_claw7 = [ 66.000, gremlin_claw8 ] { ai_charge(15.000); };
void() gremlin_claw8 = [ 67.000, gremlin_claw9 ] { ai_charge(FALSE); };
void() gremlin_claw9 = [ 68.000, gremlin_claw10 ] { ai_charge(FALSE); };
void() gremlin_claw10 = [ 69.000, gremlin_claw11 ] { ai_charge(FALSE); };
void() gremlin_claw11 = [ 70.000, gremlin_run1 ] { ai_charge(FALSE); };

void() Gremlin_Split = {
   local entity grem, temp, head;
   local float done, c, proceed;
   local vector ang, pos;

   done = FALSE;
   c = FALSE;
   ang = self.angles;
   while ( (done == FALSE) ) {
      makevectors(ang);
      pos = (self.origin + (80.000 * v_forward));
      head = findradius (pos,35.000);
      proceed = TRUE;
      while ( head ) {
         if (head.health > 0 && (head.flags & FLx_CREATURE)) proceed = FALSE;
         head = head.chain;
      }
      traceline (self.origin,pos,FALSE,self);
      if ( ((trace_fraction == TRUE) && (proceed == TRUE)) ) {
         traceline (self.origin,(pos - '40.000 40.000 0.000'),FALSE,self);
         if ( (trace_fraction == TRUE) ) {
            traceline (self.origin,(pos + '40.000 40.000 0.000'),FALSE,self);
            if ( (trace_fraction == TRUE) ) {
               traceline (self.origin,(pos + '0.000 0.000 64.000'),FALSE,self);
               if ( (trace_fraction == TRUE) ) {
                  traceline (self.origin,(pos - '0.000 0.000 64.000'),FALSE,self);
                  if ( (trace_fraction != TRUE) )
                     done = TRUE;
               }
            }
         }
      }
      if (done == FALSE) {
         ang_y = ang_y + 36.000;
         c = c + TRUE;
         if (c == 10) return;
      }
   }
   grem = spawn();
   setorigin(grem,pos);
   grem.owner = grem.master = self;
   temp = self;
   self = grem;
   gremlin_setup();
   gremlin_spawn1();
   self.enemy = world;
   self.gorging = FALSE;
   AddToTotals(self);
   self = temp;
};

void(entity targ, entity inflictor, entity attacker, float damage) Gremlin_Damage_Corpse = {
   if (Indestructable(targ)) return;
   if (teamplay && targ.team > 0 && targ.team == attacker.team) return;

   targ.health = (targ.health - damage);
};

void(float side) Gremlin_Gorge = {
   local float ldmg;
   local vector delta;
   local entity temp;

   delta = (self.enemy.origin - self.origin);
   sound(self,CHAN_WEAPON,"demon/dhit2.wav",TRUE,ATTN_NORM);
   ldmg = (MOVETYPE_PUSH + (MOVETYPE_FLY * random ()));
   Gremlin_Damage_Corpse (self.enemy,self,self,ldmg);
   SpawnMeatSpray (self, self.enemy,side);
   if ( (self.enemy.health < -200.000) ) {
      if ( (self.enemy.gorging < 2) ) {
         self.enemy.gorging = 2;
         sound(self,CHAN_VOICE,"player/udeath.wav",TRUE,ATTN_NORM);
         temp = self;
         self = self.enemy;
         monster_ThrowGib();
         self = temp;
         ldmg = (150 + (100.000 * random ()));
         T_Heal (self,ldmg,FALSE);
         Gremlin_Split();
      }
      self.enemy = world;
      self.gorging = FALSE;
      gremlin_look1();
   }
};

void() gremlin_gorge1 = [ 71.000, gremlin_gorge2 ] { ai_charge(TRUE); };
void() gremlin_gorge2 = [ 72.000, gremlin_gorge3 ] { ai_charge(TRUE); };
void() gremlin_gorge3 = [ 73.000, gremlin_gorge4 ] { ai_charge(FL_SWIM); };
void() gremlin_gorge4 = [ 74.000, gremlin_gorge5 ] { ai_charge(FALSE); };
void() gremlin_gorge5 = [ 75.000, gremlin_gorge6 ] { ai_charge(FALSE); };
void() gremlin_gorge6 = [ 76.000, gremlin_gorge7 ] { ai_charge(FALSE); Gremlin_Gorge (200); };
void() gremlin_gorge7 = [ 77.000, gremlin_gorge8 ] { ai_charge(FALSE); };
void() gremlin_gorge8 = [ 78.000, gremlin_gorge9 ] { ai_charge(FALSE); Gremlin_Gorge (-200.000); };
void() gremlin_gorge9 = [ 79.000, gremlin_gorge10 ] { ai_charge(FALSE); };
void() gremlin_gorge10 = [ 80.000, gremlin_gorge11 ] { ai_charge(FALSE); };
void() gremlin_gorge11 = [ 81.000, gremlin_gorge12 ] { ai_charge(FALSE); };
void() gremlin_gorge12 = [ 82.000, gremlin_gorge13 ] { ai_charge(FALSE); };
void() gremlin_gorge13 = [ 83.000, gremlin_gorge1 ] { ai_charge(FALSE); };

void() gremlin_look1 = [ 90.000, gremlin_look2 ] { self.nextthink = (time + 0.200); };
void() gremlin_look2 = [ 91.000, gremlin_look3 ] { self.nextthink = (time + 0.200); };
void() gremlin_look3 = [ 92.000, gremlin_look4 ] { self.nextthink = (time + 0.200); };
void() gremlin_look4 = [ 93.000, gremlin_look5 ] { self.nextthink = (time + 0.200); };
void() gremlin_look5 = [ 94.000, gremlin_look6 ] { self.nextthink = (time + 0.200); };
void() gremlin_look6 = [ 95.000, gremlin_look7 ] { self.nextthink = (time + 0.200); };
void() gremlin_look7 = [ 96.000, gremlin_look8 ] { self.nextthink = (time + 0.200); };
void() gremlin_look8 = [ 97.000, gremlin_look9 ] { self.nextthink = (time + 0.200); };
void() gremlin_look9 = [ 98.000, gremlin_run1 ] {
   if ( (self.oldenemy.health > FALSE) ) {
      self.enemy = self.oldenemy;
      HuntTarget();
   } else {
      if (self.movetarget ) {
         self.th_walk();
      } else {
         self.th_stand();
      }
   }
};

void() gremlin_glook1 = [ 141.000, gremlin_glook2 ] {};
void() gremlin_glook2 = [ 142.000, gremlin_glook3 ] {};
void() gremlin_glook3 = [ 143.000, gremlin_glook4 ] {};
void() gremlin_glook4 = [ 144.000, gremlin_glook5 ] {};
void() gremlin_glook5 = [ 145.000, gremlin_glook6 ] {};
void() gremlin_glook6 = [ 146.000, gremlin_glook7 ] {};
void() gremlin_glook7 = [ 147.000, gremlin_glook8 ] {};
void() gremlin_glook8 = [ 148.000, gremlin_glook9 ] {};
void() gremlin_glook9 = [ 149.000, gremlin_glook10 ] {};
void() gremlin_glook10 = [ 150.000, gremlin_glook11 ] {};
void() gremlin_glook11 = [ 151.000, gremlin_glook12 ] {};
void() gremlin_glook12 = [ 152.000, gremlin_glook13 ] {};
void() gremlin_glook13 = [ 153.000, gremlin_glook14 ] {};
void() gremlin_glook14 = [ 154.000, gremlin_glook15 ] {};
void() gremlin_glook15 = [ 155.000, gremlin_glook16 ] {};
void() gremlin_glook16 = [ 156.000, gremlin_glook17 ] {};
void() gremlin_glook17 = [ 157.000, gremlin_glook18 ] {};
void() gremlin_glook18 = [ 158.000, gremlin_glook19 ] {};
void() gremlin_glook19 = [ 159.000, gremlin_glook20 ] {};
void() gremlin_glook20 = [ 160.000, gremlin_glook20 ] {
   DropBackpack();
   self.stoleweapon = FALSE;
   if ( (self.oldenemy.health > FALSE) ) {
      self.enemy = self.oldenemy;
      HuntTarget();
   } else {
      if (self.movetarget ) {
         self.th_walk();
      } else {
         self.th_stand();
      }
   }
};

void() gremlin_pain1 = [ 100.000, gremlin_pain2 ] { ai_back (MOVETYPE_STEP); };
void() gremlin_pain2 = [ 101.000, gremlin_pain3 ] { ai_back (MOVETYPE_STEP); };
void() gremlin_pain3 = [ 102.000, gremlin_pain4 ] { ai_back (FL_SWIM); };
void() gremlin_pain4 = [ 103.000, gremlin_run1 ] {};
void() gremlin_gunpain1 = [ 161.000, gremlin_gunpain2 ] { ai_back (MOVETYPE_STEP); };
void() gremlin_gunpain2 = [ 162.000, gremlin_gunpain3 ] { ai_back (FL_SWIM); };
void() gremlin_gunpain3 = [ 163.000, gremlin_run1 ] {};

void(entity inflictor, entity attacker, float damage) gremlin_pain = {
   local float r;

   if ( (random () < 0.800) ) {
      self.gorging = FALSE;
      self.enemy = attacker;
      FoundTarget();
   }

   if ( (self.touch == Gremlin_JumpTouch) ) return;
   if ( (self.pain_finished > time) ) return;

   self.pain_finished = (time + TRUE);
   r = random();
   if ( (r < 0.330) ) {
      sound(self,CHAN_VOICE,"hipnotic/grem/pain1.wav",TRUE,ATTN_NORM);
   } else {
      if ( (r < 0.660) ) {
         sound(self,CHAN_VOICE,"hipnotic/grem/pain2.wav",TRUE,ATTN_NORM);
      } else {
         sound(self,CHAN_VOICE,"hipnotic/grem/pain3.wav",TRUE,ATTN_NORM);
      }
   }
   if (self.stoleweapon) {
      gremlin_gunpain1();
   } else {
      gremlin_pain1();
   }
};

void() gremlin_spawn1 = [ 84.000, gremlin_spawn2 ] { self.nextthink = (time + 0.300); self.th_pain = SUB_Null_pain; };
void() gremlin_spawn2 = [ 85.000, gremlin_spawn3 ] { self.nextthink = (time + 0.300); monster_check_gib(); };
void() gremlin_spawn3 = [ 86.000, gremlin_spawn4 ] { self.nextthink = (time + 0.300); monster_check_gib(); };
void() gremlin_spawn4 = [ 87.000, gremlin_spawn5 ] { self.nextthink = (time + 0.300); };
void() gremlin_spawn5 = [ 88.000, gremlin_spawn6 ] { self.nextthink = (time + 0.300); };
void() gremlin_spawn6 = [ 89.000, gremlin_run1 ] { self.th_pain = gremlin_pain; };

void() gremlin_die1 = [ 104.000, gremlin_die2 ] { sound(self,CHAN_VOICE,"hipnotic/grem/death.wav",TRUE,ATTN_NORM); };
void() gremlin_die2 = [ 105.000, gremlin_die3 ] { ai_forward(2); };
void() gremlin_die3 = [ 106.000, gremlin_die4 ] { ai_forward(1); };
void() gremlin_die4 = [ 107.000, gremlin_die5 ] { ai_forward(2); };
void() gremlin_die5 = [ 108.000, gremlin_die6 ] { ai_forward(1); };
void() gremlin_die6 = [ 109.000, gremlin_die7 ] { self.solid = SOLID_NOT; };
void() gremlin_die7 = [ 110.000, gremlin_die8 ] { ai_forward(2); };
void() gremlin_die8 = [ 111.000, gremlin_die9 ] { ai_forward(1); };
void() gremlin_die9 = [ 112.000, gremlin_die10 ] { ai_forward(2); };
void() gremlin_die10 = [ 113.000, gremlin_die11 ] { ai_forward(1); };
void() gremlin_die11 = [ 114.000, gremlin_die12 ] { ai_forward(2); monster_death_postcheck(); };
void() gremlin_die12 = [ 115.000, gremlin_die12 ] { monster_deadbody_check(); };

void() Gremlin_FlipTouch = {
   if (!checkbottom(self)) {
      if ((self.flags & FL_ONGROUND)) {
         self.touch = SUB_Null;
         self.think = gremlin_flip1;
         self.nextthink = (time + 0.100);
      }
      return;
   }
   self.touch = SUB_Null;
   self.think = gremlin_flip8;
   self.nextthink = time + 0.1;
};

void() gremlin_flip1 = [ 116.000, gremlin_flip2 ] {
   ai_face();
   makevectors(self.angles);
   self.origin_z = (self.origin_z + TRUE);
   self.velocity = ('0.000 0.000 350.000' - (v_forward * 200));
   SUB_RemoveFlags(self,FL_ONGROUND);
   sound(self,CHAN_VOICE,"hipnotic/grem/death.wav",TRUE,ATTN_NORM);
};
void() gremlin_flip2 = [ 117.000, gremlin_flip3 ] { ai_face(); monster_check_gib(); };
void() gremlin_flip3 = [ 118.000, gremlin_flip4 ] { monster_check_gib(); };
void() gremlin_flip4 = [ 119.000, gremlin_flip5 ] {};
void() gremlin_flip5 = [ 120.000, gremlin_flip6 ] {};
void() gremlin_flip6 = [ 121.000, gremlin_flip7 ] { self.touch = Gremlin_FlipTouch; self.bodyonflr = MON_ONFLR; };
void() gremlin_flip7 = [ 122.000, gremlin_flip8 ] {  monster_death_postcheck(); self.nextthink = (time + MOVETYPE_WALK); };
void() gremlin_flip8 = [ 123.000, gremlin_flip8 ] {  monster_deadbody_check();  };

void() gremlin_die = {
   local vector vec;
   local float dot;

   monster_death_precheck();
   if (self.items || self.items2 ) {
      DropBackpack();
      self.stoleweapon = FALSE;
   }

   if (self.gibbed) return;

   makevectors(self.angles);
   vec = normalize ((damage_attacker.origin - self.origin));
   dot = (vec * v_forward);
   if ( (((dot > 0.700) && (random () < 0.500)) && (self.flags & FL_ONGROUND)) ) {
      gremlin_flip1();
   } else gremlin_die1();
};

float () GremlinWeaponAttack = {
	if (!GremlinCheckNoAmmo()) return FALSE;

	W_ShowHostile(); // Wake up other monsters.
	if (self.weapon == IT_SHOTGUN) {
		gremlin_shot1();
		W_FireShotgun();
		SUB_AttackFinished(TRUE);
	} else if (self.weapon == IT_SUPER_SHOTGUN) {
      gremlin_shot1();
      W_FireSuperShotgun();
      SUB_AttackFinished (TRUE);
   } else if (self.weapon == IT_NAILGUN) {
      gremlin_nail1();
      SUB_AttackFinished (TRUE);
   } else if (self.weapon == IT_LAVA_NAILGUN) {
         gremlin_lava_nail1();
         SUB_AttackFinished (TRUE);
   } else if (self.weapon == IT_SUPER_NAILGUN) {
      gremlin_snail1();
      SUB_AttackFinished (TRUE);
   } else if (self.weapon == IT_LAVA_SUPER_NAILGUN) {
      gremlin_lava_snail1();
      SUB_AttackFinished (TRUE);
   } else if (self.weapon == IT_GRENADE_LAUNCHER) {
      gremlin_grenade1();
      SUB_AttackFinished (TRUE);
   } else if (self.weapon == IT2_PROXIMITY_GUN) {
         gremlin_prox1();
         SUB_AttackFinished (TRUE);
   } else if (self.weapon == IT_MULTI_GRENADE) {
      gremlin_multi_grenade1();
      SUB_AttackFinished (TRUE);
   } else if (self.weapon == IT_ROCKET_LAUNCHER) {
      gremlin_rocket1();
      SUB_AttackFinished (TRUE);
   } else if (self.weapon == IT_MULTI_ROCKET) {
      gremlin_multi_rocket1();
      SUB_AttackFinished (TRUE);
   } else if (self.weapon == IT_LIGHTNING) {
      if (self.moditems & IT_UPGRADE_LG) {
         gremlin_plasma1();
      } else {
         gremlin_light1();
         sound(self,CHAN_AUTO,"weapons/lstart.wav",TRUE,ATTN_NORM);
      }
      SUB_AttackFinished (TRUE);
   } else if (self.weapon == IT_PLASMA_GUN) {
      gremlin_plasmalight1();
      SUB_AttackFinished (TRUE);
   } else if (self.weapon == IT2_LASER_CANNON) {
      gremlin_laser1();
      SUB_AttackFinished (TRUE);
   } else if (self.weapon == IT_EXTRA_WEAPON) {
      gremlin_crossbow1();
      SUB_AttackFinished (TRUE);
   }
	return TRUE;
};

void() Gremlin_MeleeAttack = {
   local float num;

   if (self.gorging) {
      gremlin_gorge1();
   } else {
      if ( (self.stoleweapon == TRUE) ) {
         GremlinWeaponAttack();
		return;
      } else {
         if ( ((self.enemy.flags & FL_CLIENT) && (random () < 0.400)) ) {
            if (GremlinAttemptWeaponSteal()) return;
         }
      }
      num = random();
      if ( (num < 0.300) ) {
         gremlin_claw1();
      } else {
         if ( (num < 0.600) ) {
            gremlin_lunge1();
         } else {
            gremlin_claw1();
         }
      }
   }
};

void() Gremlin_MissileAttack = {
   if (self.stoleweapon) {
      if (GremlinWeaponAttack()) return;

      if ( ((random () < 0.1) && (self.flags & FL_ONGROUND)) ) {
         gremlin_jump1();
         return;
      }
   }
   if ((self.flags & FL_ONGROUND)) gremlin_jump1(); // Jumpy little buggers.
};

void() monster_gremlin_precache = {
   precache_model ("progs/hipnotic/grem.mdl");
   precache_model ("progs/hipnotic/h_grem.mdl");
   precache_sound("hipnotic/grem/death.wav");
   precache_sound("hipnotic/grem/attack.wav");
   precache_sound("demon/djump.wav");
   precache_sound("demon/dhit2.wav");
   precache_sound("hipnotic/grem/pain1.wav");
   precache_sound("hipnotic/grem/pain2.wav");
   precache_sound("hipnotic/grem/pain3.wav");
   precache_sound("hipnotic/grem/idle.wav");
   precache_sound("hipnotic/grem/sight1.wav");
   precache_sound(SOUND_LASER_HIT);
};

void() GremlinCheckAttack;

void() gremlin_setup = {
   self.mdl = "progs/hipnotic/grem.mdl";
   self.headmdl = "progs/hipnotic/h_grem.mdl";
	self.hello_sound = "hipnotic/grem/idle.wav";
	self.sight_sound = "hipnotic/grem/sight1.wav";
   self.solid = SOLID_NOT;				// No interaction with world
   self.movetype = MOVETYPE_NONE;		// Static item, no movement
   if (self.bboxtype < 1) self.bboxtype = BBOX_WIDEFLAT;
   self.gibbed = FALSE;
   self.items = FALSE;
   self.items2 = FALSE;
   self.mass = MASS_MEDIUM;
   self.moditems = FALSE;
   self.perms = FALSE;
   if (self.health <= 0) self.health = 100;
   self.max_health = self.health;
   self.gibhealth = -50;
   self.steptype = FS_TYPESLOW;
   self.pain_flinch = 50;
   self.yaw_speed = 40;
   self.th_stand = gremlin_stand1;
   self.th_walk = gremlin_walk1;
   self.th_run = gremlin_run1;
   self.th_die = gremlin_die;
   self.th_melee = Gremlin_MeleeAttack;
   self.th_missile = Gremlin_MissileAttack;
   self.th_checkattack = GremlinCheckAttack;
   self.th_pain = gremlin_pain;
   self.takedamage = DAMAGE_AIM;
   Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
   if (!self.classtype) self.classtype = CT_MONGREMLIN;
   if (!self.classgroup) self.classgroup = CG_DOG;
   self.classmove = MON_MOVEWALK;
	if (self.deathstring == "")  self.deathstring = " was outsmarted by a Gremlin\n";
   monster_start();
};

void() monster_gremlin = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups

   self.mdl = "progs/hipnotic/grem.mdl";
   self.headmdl = "progs/hipnotic/h_grem.mdl";
   gremlin_setup();
};
