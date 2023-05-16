//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: FrikBot X by Ryan "FrikaC" Smith
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
// Entity count: 
// Function count: 
//
// Implements: FrikBot AI
//
// Description:
// A bot that plays quake on its own.  Customized to adapt to the Keep mod.
// TODO actually customize it, heh
//=============================================================================

/*******************************F****************
*                                              *
*            FrikBot General AI                *
*     "The I'd rather be playing Quake AI"     *
*                                              *
***********************************************/

/*

This program is in the Public Domain. My crack legal
team would like to add:

RYAN "FRIKAC" SMITH IS PROVIDING THIS SOFTWARE "AS IS"
AND MAKES NO WARRANTY, EXPRESS OR IMPLIED, AS TO THE
ACCURACY, CAPABILITY, EFFICIENCY, MERCHANTABILITY, OR
FUNCTIONING OF THIS SOFTWARE AND/OR DOCUMENTATION. IN
NO EVENT WILL RYAN "FRIKAC" SMITH BE LIABLE FOR ANY
GENERAL, CONSEQUENTIAL, INDIRECT, INCIDENTAL,
EXEMPLARY, OR SPECIAL DAMAGES, EVEN IF RYAN "FRIKAC"
SMITH HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
DAMAGES, IRRESPECTIVE OF THE CAUSE OF SUCH DAMAGES. 

You accept this software on the condition that you
indemnify and hold harmless Ryan "FrikaC" Smith from
any and all liability or damages to third parties,
including attorney fees, court costs, and other
related costs and expenses, arising out of your use
of this software irrespective of the cause of said
liability. 

The export from the United States or the subsequent
reexport of this software is subject to compliance
with United States export control and munitions
control restrictions. You agree that in the event you
seek to export this software, you assume full
responsibility for obtaining all necessary export
licenses and approvals and for assuring compliance
with applicable reexport restrictions. 

Any reproduction of this software must contain
this notice in its entirety. 

*/

/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

target_onstack

checks to see if an entity is on the bot's stack

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

float(entity scot) target_onstack =
{
   if (scot == world)
      return FALSE;
   else if (self.target1 == scot)
      return 1;
   else if (self.target2 == scot)
      return 2;
   else if (self.target3 == scot)
      return 3;
   else if (self.target4 == scot)
      return 4;
   else
      return FALSE;
};

/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

target_add

adds a new entity to the stack, since it's a
LIFO stack, this will be the bot's new target1

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

void(entity ent) target_add =
{
   if (ent == world)
      return;
   if (target_onstack(ent))
      return;
   self.target4 = self.target3;
   self.target3 = self.target2;
   self.target2 = self.target1;
   self.target1 = ent;
   self.search_time = time + 5;
};


/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

target_drop

Removes an entity from the bot's target stack.
The stack will empty everything up to the object
So if you have target2 item_health, target1
waypoint, and you drop the health, the waypoint
is gone too.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

void(entity ent) target_drop =
{
   local float tg;
   
   tg = target_onstack(ent);
   if (tg == 1)
   {
      self.target1 = self.target2;
      self.target2 = self.target3;
      self.target3 = self.target4;
      self.target4 = world;
   }
   else if (tg == 2)
   {
      self.target1 = self.target3;
      self.target2 = self.target4;
      self.target3 = self.target4 = world;
   }
   else if (tg == 3)
   {
      self.target1 = self.target4;
      self.target2 = self.target3 = self.target4 = world;
   }
   else if (tg == 4)
      self.target1 = self.target2 = self.target3 = self.target4 = world;
   self.search_time = time + 5;
};

// Bot has lost its target.
void(entity targ, float success) bot_lost = {
   if (!targ) return;

   target_drop(targ);
   if (targ.classname == "waypoint") {
      targ.b_sound = targ.b_sound - (targ.b_sound & ClientBitFlag(self.b_clientno));
   }

   // find a new route
   if (!success) {
      self.target1 = self.target2 = self.target3 = self.target4 = world;
      self.last_way = world;
      ClearMyRoute();
      self.b_aiflags = 0;
   } else {
      if (targ.classname == "item_artifact_invisibility") {
         if (self.items & 524288) bot_start_topic(3);
      }

      if (targ.flags & FL_ITEM) {
         if (targ.model == string_null) targ._last = world;
         else targ._last = self;
      }
   }
   if (targ.classname != "player") targ.search_time = time + 5;
};

/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

bot_check_lost

decide if my most immediate target should be
removed.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/
void(entity targ) bot_check_lost =
{
   local vector dist;
   dist = realorigin(targ) - self.origin;
   dist_z = 0;
   if (targ == world)
      return;

   // waypoints and items are lost if you get close enough to them

   else if (targ.flags & FL_ITEM)
   {
      if (vlen(targ.origin - self.origin) < 32)
         bot_lost(targ, TRUE);
      else if (targ.model == string_null)
         bot_lost(targ, TRUE);
   }
   else if (targ.classname == "waypoint")
   {
      if (!(self.b_aiflags & (AI_SNIPER | AI_AMBUSH)))
      {
         if (self.b_aiflags & AI_RIDE_TRAIN)
         {
            if (vlen(targ.origin - self.origin) < 48)
               bot_lost(targ, TRUE);
         }
         else if (self.b_aiflags & AI_PRECISION)
         {
            if (vlen(targ.origin - self.origin) < 24)
               bot_lost(targ, TRUE);
         }
         else if (vlen(targ.origin - self.origin) < 32)
            bot_lost(targ, TRUE);
      }
   }
   else if (targ.classname == "temp_waypoint")
   {
      if (vlen(targ.origin - self.origin) < 32)
         bot_lost(targ, TRUE);
   }
   else if (targ.classname == "player")
   {
      if (targ.health <= 0)
         bot_lost(targ, TRUE);
      else if ((coop) || (teamplay && targ.team == self.team))
      {
         if (targ.target1.classname == "player")
         {
            if (!targ.target1.ishuman)
               bot_lost(targ, TRUE);
         }
         else if (targ.teleport_time > time)
         {
            // try not to telefrag teammates
            self.keys = self.keys & 960;
         }
         else if (vlen(targ.origin - self.origin) < 128)
         {
            if (vlen(targ.origin - self.origin) < 48)
               frik_walkmove(self.origin - targ.origin);
            else
            {
               self.keys = self.keys & 960;
               bot_start_topic(4);
            }
            self.search_time = time + 5; // never time out
         }
         else if (!fisible(targ))
            bot_lost(targ, FALSE);   
      }
      else if (waypoint_mode > WM_LOADED)
      {
         if (vlen(targ.origin - self.origin) < 128)
         {
            bot_lost(targ, TRUE);   
         }
      }
   }

   // buttons are lost of their frame changes
   else if (targ.classname == "func_button")
   {
      if (targ.frame)
      {
         bot_lost(targ, TRUE);
         if (self.enemy == targ)
            self.enemy = world;
         //if (self.target1)
         //   bot_get_path(self.target1, TRUE);
            
      }
   }
   // trigger_multiple style triggers are lost if their thinktime changes
   else if ((targ.movetype == MOVETYPE_NONE) && (targ.solid == SOLID_TRIGGER))
   {
      if (targ.nextthink >= time)
      {
         bot_lost(targ, TRUE);
         //if (self.target1)
         //   bot_get_path(self.target1, TRUE);
      }
   }
   // DRS: Teleporter target fix
   if(targ.classname == "trigger_teleport" && (self.bot_teleport_dest.classname == "info_teleport_destination" && vlen(self.bot_teleport_dest.origin - self.origin) < 32))
   {
    self.bot_teleport_dest = world;
    bot_lost(targ, TRUE);
   }
   // lose any target way above the bot's head
   // FIXME: if the bot can fly in your mod..
   if ((targ.origin_z - self.origin_z) > 64)
   {
      dist = targ.origin - self.origin;
      dist_z = 0;
      if (vlen(dist) < 32)
         if (self.flags & FL_ONGROUND)
            if(!frik_recognize_plat(FALSE))
               bot_lost(targ, FALSE);
   }
   else if (targ.classname == "train")
   {
      if (frik_recognize_plat(FALSE))
         bot_lost(targ, TRUE);
   }
   // targets are lost if the bot's search time has expired
   if (time > self.search_time)
      bot_lost(targ, FALSE);
};


/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

bot_handle_ai

This is a 0.10 addition. Handles any action
based b_aiflags.

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

void() bot_handle_ai =
{
   local entity newt;
   local vector v;

   // handle ai flags -- note, not all aiflags are handled
   // here, just those that perform some sort of action

   // wait is used by the ai to stop the bot until his search time expires / or route changes

   if (self.b_aiflags & AI_WAIT)
      self.keys = self.keys & 960;

   if (self.b_aiflags & AI_DOORFLAG) // was on a door when spawned
   {
      b_temp3 = self;
      self = self.last_way;
      if (!frik_recognize_plat(FALSE)) // if there is nothing there now
      {
         newt = FindThing("door"); // this is likely the door responsible (crossfingers)
         self = b_temp3;

         if (self.b_aiflags & AI_DOOR_NO_OPEN)
         {
            if (newt.nextthink)
               self.keys = self.keys & 960; // wait until it closes
            else
            {
               bot_lost(self.last_way, FALSE);
            }
         }
         else
         {
            if (newt.targetname)
            {
               newt = find(world, target, newt.targetname);
               if (newt.health > 0) 
               {
                  self.enemy = newt;
                  bot_weapon_switch(1);
               }
               else
               {
               //   target_drop(self.last_way);
                  target_add(newt);
               //   bot_get_path(newt, TRUE);
               }
            }
            self.b_aiflags = self.b_aiflags - AI_DOORFLAG;
         }
      }
      else
         self = b_temp3;
   }

   if (self.b_aiflags & AI_JUMP)
   {
      if (self.flags & FL_ONGROUND)
      {
         bot_jump();
         self.b_aiflags = self.b_aiflags - AI_JUMP;
      }
   }
   else if (self.b_aiflags & AI_SUPER_JUMP)
   {
      if (self.weapon != 32)
         self.impulse = 7;
      else if (self.flags & FL_ONGROUND)
      {
         self.b_aiflags = self.b_aiflags - AI_SUPER_JUMP;
         if (bot_can_rj(self))
         {
            bot_jump();
            self.v_angle_x = self.b_angle_x = 80;
            self.button0 = TRUE;
         }
         else
            bot_lost(self.target1, FALSE);         
      }
   }
   if (self.b_aiflags & AI_SURFACE)
   {
      if (self.waterlevel > 2)
        {
         self.keys = KEY_MOVEUP;
         self.button2 = TRUE; // swim!
          }
      else
         self.b_aiflags = self.b_aiflags - AI_SURFACE;
   }
   if (self.b_aiflags & AI_RIDE_TRAIN)
   {
      // simple, but effective
      // this can probably be used for a lot of different
      // things, not just trains (door elevators come to mind)
      b_temp3 = self;
      self = self.last_way;
   
      if (!frik_recognize_plat(FALSE)) // if there is nothing there now
      {
         self = b_temp3;
         self.keys = self.keys & 960;
      }
      else
      {
         self = b_temp3;
         if (frik_recognize_plat(FALSE))
         {
            v = realorigin(trace_ent) + trace_ent.origin - self.origin;
            v_z = 0;
            if (vlen(v) < 24)
               self.keys = self.keys & 960;
            else
            {
               self.b_aiflags = self.b_aiflags | AI_PRECISION;
               self.keys = frik_KeysForDir(v);
            }
         }
      }
   }
   if (self.b_aiflags & AI_PLAT_BOTTOM)
   {
      newt = FindThing("plat");
      if (newt.state != 1)
      {
         v =  self.origin - realorigin(newt);
         v_z = 0;
         if (vlen(v) > 96)
            self.keys = self.keys & 960;
         else
            frik_walkmove(v);
      }
      else
         self.b_aiflags = self.b_aiflags - AI_PLAT_BOTTOM;
   }
   if (self.b_aiflags & AI_DIRECTIONAL)
   {
      if ((normalize(self.last_way.origin - self.origin) * self.b_dir) > 0.4)
      {
         self.b_aiflags = self.b_aiflags - AI_DIRECTIONAL;
         bot_lost(self.target1, TRUE);
      }
   }
   if (self.b_aiflags & AI_SNIPER)
   {
      self.b_aiflags = (self.b_aiflags | AI_WAIT | AI_PRECISION) - AI_SNIPER;
      // FIXME: Add a switch to wep command
      // FIXME: increase delay?
   }
   if (self.b_aiflags & AI_AMBUSH)
   {
      self.b_aiflags = (self.b_aiflags | AI_WAIT) - AI_AMBUSH;
      // FIXME: Add a switch to wep command
      // FIXME: increase delay?
   }

};

/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

bot_path

Bot will follow a route generated by the
begin_route set of functions in bot_way.qc.
This code, while it works pretty well, can get
confused

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

void() bot_path = {
   local entity jj, tele;

   bot_check_lost(self.target1);
   if (!self.target1) {
      self.keys=0;
      return;
   }
   if (target_onstack(self.last_way)) return; // old waypoint still being hunted

   jj = FindRoute(self.last_way);
   if (!jj) {
      // this is an ugly hack
      if (self.target1.current_way != self.last_way) {
         if (self.target1.classname != "temp_waypoint")
            if (self.target1.classname != "player")
               bot_lost(self.target1, FALSE);
      }

      return;
   }

   // update the bot's special ai features
   // Readahed types are AI conditions to perform while heading to a waypoint
   // point types are AI flags that should be executed once reaching a waypoint
   self.b_aiflags = (jj.b_aiflags & AI_READAHEAD_TYPES) | (self.last_way.b_aiflags & AI_POINT_TYPES);
   target_add(jj);
   if (self.last_way) {
      traceline(self.last_way.origin, jj.origin, FALSE, self); // check for blockage
      if (trace_fraction != 1) {
         if (trace_ent.classname == "door" && !(self.b_aiflags & AI_DOOR_NO_OPEN)) { // a door blocks the way
            // linked doors fix
            if (trace_ent.owner)
               trace_ent = trace_ent.owner;
            if ((trace_ent.health > 0) && (self.enemy == world)) {
               self.enemy = trace_ent;
               bot_weapon_switch(1);
               self.b_aiflags = self.b_aiflags | AI_BLIND; // nick knack paddy hack
            } else if (trace_ent.targetname) {
               tele = find(world, target, trace_ent.targetname);
               if (tele.health > 0) {
                  self.enemy = tele;
                  bot_weapon_switch(1);
               } else {
               //   target_drop(jj);
                  target_add(tele);
               //   bot_get_path(tele, TRUE);
                  self.b_aiflags = self.b_aiflags | AI_BLIND; // give a bot a bone   
                  return;
               }               
            }      
         } else if (trace_ent.classname == "func_wall") {
            // give up
            bot_lost(self.target1, FALSE);
            return;
         }
      }
   }
   self.b_dir = normalize(jj.origin - self.last_way.origin); // this is used for AI_DRIECTIONAL
   self.last_way = jj;
};

// Returns weapon bonus to thisp for item according to skill with a weapon.
float(string wname) DRS_W_IT_Bonus = {
	local float bonus, ac_value;

	if(wname == "weapon_lightning") {
		ac_value = DRS_W_Accuracy(IT_LIGHTNING);
		if(self.b_fav_weapon == IT_LIGHTNING)
		bonus = 20;
	} else if(wname == "weapon_rocketlauncher") {
		ac_value = DRS_W_Accuracy(IT_ROCKET_LAUNCHER);
		if(self.b_fav_weapon == IT_LIGHTNING)
		bonus = 20;
	} else if(wname == "weapon_grenadelauncher") {
		ac_value = DRS_W_Accuracy(IT_GRENADE_LAUNCHER);
		if(self.b_fav_weapon == IT_LIGHTNING)
		bonus = 20;
	} else if(wname == "weapon_supernailgun") {
		ac_value = DRS_W_Accuracy(IT_SUPER_NAILGUN);
		if(self.b_fav_weapon == IT_LIGHTNING)
		bonus = 20;
	} else if(wname == "weapon_nailgun") {
		ac_value = DRS_W_Accuracy(IT_NAILGUN);
		if(self.b_fav_weapon == IT_LIGHTNING)
		bonus = 20;
	} else if(wname == "weapon_super_shotgun") {
		ac_value = DRS_W_Accuracy(IT_SUPER_SHOTGUN);
		if(self.b_fav_weapon == IT_LIGHTNING)
		bonus = 20;
	}

	if(ac_value <= 0) bonus = bonus + 30; // Zero or better is somewhat desirable.
	if(ac_value >= 10) bonus = bonus + 20;
	if(ac_value >= 20) bonus = bonus + 10;
	if(ac_value >= 30) bonus = 0; // greater than 30 is somewhat undesirable.
	return bonus;
};


// Bot Priority Look. What a stupid name. This is where the bot finds things it
// wants to kill/grab.
// priority scale
// 0 - 10 virtually ignore
// 10 - 30 normal item range
// 30 - 50 bot will consider this a target worth changing course for
// 50 - 90 bot will hunt these as vital items
// *!* Make sure you add code to bot_check_lost to remove the target *!*
float(entity thing) priority_for_thing = {
   local float thisp;
   thisp = 0;
   // This is the most executed function in the bot. Careful what you do here.

   if ((thing.flags & FL_ITEM) && thing.model != string_null && thing.search_time < time) {
      // ugly hack
      if (thing._last != self) thisp = 10*(random()) + 20;
   if (thing.classname == "item_artifact_super_damage")
         thisp = 19*(random()) + 40;
      else if (thing.classname == "item_artifact_invulnerability")
         thisp = 19*(random()) + 40;
      else if (thing.classname == "item_artifact_invisibility")
         thisp = 19*(random()) + 40;
      else if (thing.classname == "item_health") {
         if (self.health <= 50)
            thisp = 50;
         if (self.health > 50)
                  thisp = 35;
         if (self.health > 80)
                  thisp = 20;
         if (self.health > 95)
                  thisp = 0;
         if (thing.spawnflags & 2)
            thisp = 13*(random()) + 37;
      }

      else if (thing.classname == "item_armor1")
      {
         if (self.armorvalue <= 99)
            thisp = 13*(random()) + 26;

         if (self.armorvalue > 99)
                 thisp = 0;
      }

      else if (thing.classname == "item_armor2")
      {
         if (self.armorvalue <= 149)
            thisp = 13*(random()) + 35;

         if (self.armorvalue > 149)
                 thisp = 0;
      }

      else if (thing.classname == "item_armorInv")
      {
         if (self.armorvalue <= 199)
            thisp = 10*(random()) + 45;

         if (self.armorvalue > 199)
                 thisp = 0;
      }


      else if (thing.classname == "weapon_rocketlauncher")
      {
         if (!(self.items & 32)) // IT_ROCKET_LAUNCHER
//            thisp = 5*(random()) + 45;
              thisp = 10+(random()*DRS_W_IT_Bonus(thing.classname));
			  dprint(ftos(thisp));
			  dprint(" Rocketlauncher\n");
      }
      else if (thing.classname == "weapon_lightning")
      {
         if (!(self.items & 64)) // IT_LIGHTNING
//            thisp = 13*(random()) + 37;
              thisp = 10+(random()*DRS_W_IT_Bonus(thing.classname));
			  dprint(ftos(thisp));
			  dprint(" Lightning\n");
      }
      else if (thing.classname == "weapon_grenadelauncher")
      {
         if (!(self.items & 16)) // IT_GRENADE_LAUNCHER
//            thisp = 10*(random()) + 30;
              thisp = 10+(random()*DRS_W_IT_Bonus(thing.classname));
			  dprint(ftos(thisp));
			  dprint(" GrenadeLauncher\n");
      }
      else if (thing.classname == "weapon_supernailgun")
      {
         if (!(self.items & 8)) // IT_SUPER_NAILGUN
//            thisp = 8*(random()) + 25;
              thisp = 10+(random()*DRS_W_IT_Bonus(thing.classname));
			  dprint(ftos(thisp));
			  dprint(" supernailgun\n");
      }
      else if (thing.classname == "weapon_nailgun")
      {
         if (!(self.items & 4)) // IT_NAILGUN 
//            thisp = 8*(random()) + 15;
              thisp = 10+(random()*DRS_W_IT_Bonus(thing.classname));
			  dprint(ftos(thisp));
			  dprint(" nailgun\n");
      }
      else if (thing.classname == "weapon_supershotgun")
      {
         if (!(self.items & 2)) // IT_SUPER_SHOTGUN  
//            thisp = 8*(random()) + 20;
              thisp = 10+(random()*DRS_W_IT_Bonus(thing.classname));
			  dprint(ftos(thisp));
			  dprint(" supershotgun\n");
      }

      else if (thing.model == "progs/backpack.mdl")
         thisp = 18*(random()) + 20;
      else if (thing.classname == "item_artifact_envirosuit")
         thisp = 15;
   } else if ((thing.flags & FL_MONSTER) && thing.health > 0) thisp = 45;
   else if (thing.classname == "player") { 
      if (thing.health > 0) {
         if (thing == self) return 0;

         if (thing.items & IT_INVISIBILITY) {
            // if target has fired recently
            if(thing.show_hostile >= (time + 0.8)) thisp = 30; // target like normal
            else thisp = 2;
         } else if (coop) {
            thisp = 200;
            if (thing.target1.classname == "player")
               if (!thing.target1.ishuman) return 0;
         } else if (teamplay && thing.team == self.team) {
            thisp = 100;
            if (thing.target1.classname == "player") return 0;
         } else thisp = 30;
      }
   }

   if (pointcontents(thing.origin) < -3) return 0;

   if (thisp) {
      if (thing.current_way) {
         // check to see if it's unreachable
         if (thing.current_way.items == -1) return 0;

         thisp = thisp + (13000 - thing.current_way.items) * 0.05; 
      }
   }
   return thisp;
};

void(float scope) bot_look_for_crap = {
   local entity foe, best;
   local float thatp, bestp, dist;

   if (scope == 1) foe = findradius(self.origin, 13000);
   else foe = findradius(self.origin, 500);

   bestp = 1;
   while(foe) {
      thatp = priority_for_thing(foe);
      if (thatp && !scope) {
         traceline (self.origin, foe.origin, TRUE, self);
         if ((trace_ent != foe) && (trace_fraction != 1)) thatp = 0; // Can't see foe
      }

      if (thatp > bestp) {
         bestp = thatp;
         best = foe;
         dist = vlen(self.origin - foe.origin);
      }
      foe = foe.chain;
   }
   if (best == world) return;

   if (!target_onstack(best)) {   
      target_add(best);
      if (scope) {
         bot_get_path(best, FALSE);
         self.b_aiflags = self.b_aiflags | AI_WAIT;
      }
   }
};

// Sets the bots look keys & b_angle to point at the target - used for fighting
// and just generally making the bot look good.
void() bot_angle_set = {
   local float h, offset_amt, dist1, dist2;
   local vector view, voffset, offset, spot1, oldview, spotview;
   
   if (self.enemy) {
      if (self.missile_speed == 0) self.missile_speed = 10000;
      if (self.enemy.solid == SOLID_BSP) {
         view = (((self.enemy.absmin + self.enemy.absmax) * 0.5)); // - self.origin
         self.dontshoot = FALSE;
            view = normalize(view - (self.origin + self.view_ofs));
      } else {
			if(self.enemy.items & 524288) {
			   if((self.enemy.show_hostile > (time + 0.8)) || (infront(self.enemy) && (vlen(self.enemy.origin - self.origin) < 128))) {
			      //DRS: Always update a player last_origin
               // if they are infront, use direct aiming instead of b_enemy_last_origin
			      if(infront(self.enemy)) self.lockon_time = time + (0.5 + (random()*1));
				   if(self.e_sensed_lag < time && self.enemy.show_hostile >= (time + 0.8)) {
			         self.b_enemy_last_origin = self.enemy.origin;
				      self.e_sensed_lag = time + 1;
				   }
				   self.enemy_lastseen = time + (0.5 + (random()*2));
			   }
            if(self.enemy_lastseen < time) return;
			}

         if ((self.enemy.items & 524288) && (self.lockon_time > time)) spotview = self.enemy.origin; // invisibility, and lockon, shoot right at target
		   else if((self.enemy.items & 524288) && (self.lockon_time < time)) spotview = self.b_enemy_last_origin; // shoot at last seen point
		else spotview = self.enemy.origin; // just shoot right at target.
          // find lead point on target
          // then traceline to it, if blocked before full dist,
          // set targetpoint to stopped origin
          // then trace again to check if there's a clear path to
          // target, if not, just target enemy.origin.
          // also, check to see if trace endpoint is within 140 qu
          // of the bot, if so, aim at the enemy.origin, because
          // we are looking at a wall, and that could hurt if it's a rocketlauncher
            h = vlen(spotview - self.origin) / self.missile_speed; // need to get the speed of projectile
            if (self.enemy.flags & FL_ONGROUND)
               view = self.enemy.velocity * h; // Aim straight at enemy, not at his feet, that will be handled later
            else
               view = (self.enemy.velocity - (cvar("sv_gravity") * '0 0 1') * h) * h; // hes in the air, lead accordingly
            view = spotview + view; // set our leadpoint
            traceline(spotview, view, FALSE, self); // trace from enemy.origin to lead aimpoint
            view = trace_endpos; // set view origin to lead aimpoint
            traceline(self.origin + self.view_ofs, view, FALSE, self); // do a trace to view from self.
            spot1 = trace_endpos; // get trace_endpos
            dist1 = vlen(spot1 - (self.origin + self.view_ofs)); // range from self to trace
            dist2 = vlen(view - (self.origin + self.view_ofs)); // range from self to aimpoint
            if((dist1 < 140) && (dist1 != dist2)) // too close, shoot at enemy.origin
             view = spotview;
            else if(vlen(view - spot1) > 32 && trace_ent.takedamage == DAMAGE_NO)
             view = spotview; // something that can't be damaged in the way, just shoot at enemy.origin.
             dist2 = vlen(view - (self.origin+self.view_ofs));
            
         // DRS: Tweaked Supa Aimcode (wazat inspired) below
         // DRS: FIXME: Change this so that it's not so consistent...
             if(self.b_skill == 0)
            offset_amt = SKILL0_ACC + DRS_W_Accuracy(self.weapon);  //110
             else if (self.b_skill == 1)
                 offset_amt = SKILL1_ACC + DRS_W_Accuracy(self.weapon);  //80
             else if (self.b_skill == 2)
            offset_amt = SKILL2_ACC + DRS_W_Accuracy(self.weapon);  //80
             else if (self.b_skill == 3)
            offset_amt = SKILL3_ACC + DRS_W_Accuracy(self.weapon);  //80

			if(offset_amt < 0)
			 offset_amt = 0;
			
			if(self.enemy.items & 524288)
			 offset_amt = offset_amt + 30; // added inaccuracy for invisibility
						
             offset_x = crandom() * offset_amt;
             offset_y = crandom() * offset_amt;
             offset_z = crandom() * offset_amt;

          if(self.weapon == IT_GRENADE_LAUNCHER) // using grenades? Aim properly then!
            {
            local float realrange, flitime;
            local vector grndir;

            grndir = normalize(view - (self.origin + self.view_ofs));//normalize(self.enemy.origin - self.origin);
            realrange = dist2*mathlib_cos(grndir_x);
            flitime = realrange / self.missile_speed;
          
            view = view + '0 0 -20'; // aim at feet
			// DRS: Jitter the aim so that they aren't so accurate with the GL
			view_x = view_x + offset_x;
			view_z = view_z + offset_z;
			
            grndir = normalize(view - (self.origin + self.view_ofs));//normalize(self.enemy.origin - self.origin);
            grndir = grndir * 600;
            grndir_z = grndir_z + (cvar("sv_gravity")*flitime) * 0.3;
            view = normalize(grndir);
            self.dontshoot = FALSE;
         }
         if(self.weapon == IT_ROCKET_LAUNCHER && (self.enemy.flags & FL_ONGROUND)) // Rocketlauncher?  Aim at feet if they're on the ground!
         {
          oldview = view;
          view = view + '0 0 -20'; // aim at feet
          traceline(self.origin + self.view_ofs, view, FALSE, self);
           if(vlen(view - trace_endpos) > 32)
            view = oldview;
         }
       // DRS: Do a viability test on whether we actually should shoot or not
         if(self.enemy.solid != SOLID_BSP && self.weapon != IT_GRENADE_LAUNCHER)
         {
         traceline(self.origin+self.view_ofs, view, TRUE, self);
         if(vlen(trace_endpos - (self.origin+self.view_ofs)) < (dist2 - 32))
          self.dontshoot = TRUE;
         else if(vlen(trace_endpos - (self.origin+self.view_ofs)) > (dist2 + 32))
          self.dontshoot = TRUE;
         else self.dontshoot = FALSE;
        }
            
       if(self.weapon != IT_GRENADE_LAUNCHER)
           view = normalize((view + offset) - (self.origin + self.view_ofs));
      }   
      view = vectoangles(view);
      view_x = view_x * -1;
      self.b_angle = view;
   }
   else if (self.target1)
   {
      view = realorigin(self.target1);
      if (self.target1.flags & FL_ITEM)
            view = view + '0 0 48';
      view = view - (self.origin + self.view_ofs);
      view = vectoangles(view);
      view_x = view_x * -1;
      self.b_angle = view;
      self.dontshoot = TRUE;
   }
   else
    {
      self.b_angle_x = 0;
     self.dontshoot = TRUE;
    }

   // HACK HACK HACK HACK
   // The bot falls off ledges a lot because of "turning around"
   // so let the bot use instant turn around when not hunting a player
   if (self.b_skill == 3)
   {
      if (self.b_angle_x < -180)
         self.b_angle_x = self.b_angle_x + 360;
      if (self.b_angle_x > 180)
         self.b_angle_x = self.b_angle_x - 360;
         
      self.keys = self.keys & 63;   
      self.v_angle = self.b_angle;
   }
   else if ((self.enemy == world || self.enemy.movetype == MOVETYPE_PUSH) && self.target1.classname != "player")
   {
      if (self.b_angle_x < -180)
         self.b_angle_x = self.b_angle_x + 360;
      if (self.b_angle_x > 180)
         self.b_angle_x = self.b_angle_x - 360;

      self.keys = self.keys & 63;
      self.v_angle = self.b_angle;
   }
   else if (self.b_skill < 1) // skill 2 handled in bot_phys
   {
      if (self.b_angle_x < -180)
         self.b_angle_x = self.b_angle_x + 360;
      if (self.b_angle_x > 180)
         self.b_angle_x = self.b_angle_x - 360;
      self.keys = self.keys & 63;

      if (angcomp(self.b_angle_y, self.v_angle_y) > 10)
         self.keys = self.keys | KEY_LOOKLEFT;
      else if (angcomp(self.b_angle_y, self.v_angle_y) < -10)
         self.keys = self.keys | KEY_LOOKRIGHT;
      if (angcomp(self.b_angle_x, self.v_angle_x) < -10)
         self.keys = self.keys | KEY_LOOKUP;
      else if (angcomp(self.b_angle_x, self.v_angle_x) > 10)
         self.keys = self.keys | KEY_LOOKDOWN;
   }
};

/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

BotAI

This is the main ai loop. Though called every
frame, the ai_time limits it's actual updating

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/
float stagger_think;

void() BotAI =
{
   // am I dead? Fire randomly until I respawn
   // health < 1 is used because fractional healths show up as 0 on normal player
   // status bars, and the mod probably already compensated for that

   if (self.health < 1)
   { 
      self.button0 = floor(random() * 2);
      self.button2 = 0;
      self.keys = 0;
      self.b_aiflags = 0;
      ClearMyRoute();
      self.target1 = self.target2 = self.target3 = self.target4 = self.enemy = world;
      self.last_way = world;
      return;
   }
      
   // stagger the bot's AI out so they all don't think at the same time, causing game
   // 'spikes'
   if (self.b_skill < 1)
   {
      if (self.ai_time > time)
         return;

      self.ai_time = time + 0.05;
      if (bot_count > 0)
      {
         if ((time - stagger_think) < (0.1 / bot_count))
            self.ai_time = self.ai_time + 0.1 / (2 * bot_count);
      }
      else
         return;
   }
   if (self.view_ofs == '0 0 0')
      bot_start_topic(7);
   stagger_think = time;

   // shut the bot's buttons off, various functions will turn them on by AI end

   self.button2 = 0;
   self.button0 = 0;
   

   // target1 is like goalentity in normal Quake monster AI.
   // it's the bot's most immediate target
   if (route_table == self)
   {
      if (busy_waypoints <= 0)
      {
         if (waypoint_mode < WM_EDITOR)
            bot_look_for_crap(TRUE);
      }
      self.b_aiflags = 0;
      self.keys = 0;
   }
   else if (self.target1)
   {
      frik_movetogoal();
      bot_path();
   }
   else
   {
      if (waypoint_mode < WM_EDITOR)
                {
                   if(self.route_failed)
                   {
                      if (waypoint_mode == WM_DYNAMIC)
                              frik_bot_roam();
                           else
                              self.keys = 0;
                      self.route_failed = 0;
                   }
                        else if(!begin_route())
                        {   
                                bot_look_for_crap(FALSE);
                                self.keys = 0;
                        }
         
                }
      else
      {
         self.b_aiflags = AI_WAIT;
         self.keys = 0;
      }
   }

   // bot_angle_set points the bot at it's goal (self.enemy or target1)

   bot_angle_set();

   // fight my enemy. Enemy is probably a field QC coders will most likely use a lot
   // for their own needs, since it's unused on a normal player
   // FIXME
   if (self.enemy)
      bot_fight_style();
   else if (random() < 0.2)
      if (random() < 0.2)
         bot_weapon_switch(-1);
   bot_dodge_stuff();

   // checks to see if bot needs to start going up for air
   if (self.waterlevel > 2)
     {
      if (time > (self.air_finished - 2))
      {
         traceline (self.origin, self.origin + '0 0 6800', TRUE, self);
         if (trace_inopen)   
         {
            self.keys = KEY_MOVEUP;
            self.button2 = TRUE; // swim!
            return; // skip ai flags for now - this is life or death
         }
      }
       }

   // b_aiflags handling

   
   if (self.b_aiflags)
      bot_handle_ai(); 
   else
      bot_chat(); // don't want chat to screw him up if he's rjing or something
};

