float () ScourgeCheckAttack = {

   local vector spot1;
   local vector spot2;
   local entity targ;
   local float chance;

   targ = self.enemy;
   spot1 = (self.origin + self.view_ofs);
   spot2 = (targ.origin + targ.view_ofs);
   if ( (vlen ((spot1 - spot2)) <= 100.000) ) {

      if ( CanDamage (self.enemy,self) ) {

         self.attack_state = AS_MELEE;
         return ( TRUE );

      }

   }
   if ( (time < self.attack_finished) ) {

      return ( FALSE );

   }
   if ( !enemy_vis ) {

      return ( FALSE );

   }
   chance = (spot2_z - spot1_z);
   if ( (chance > FL_GODMODE) ) {

      return ( FALSE );

   } else {

      if ( (chance < -200.000) ) {

         return ( FALSE );

      }

   }
   if ( (vlen ((spot1 - spot2)) > 1000.000) ) {

      return ( FALSE );

   }
   if ( (vlen ((spot1 - spot2)) < MIN_CHARMER_DISTANCE) ) {

      return ( FALSE );

   }
   traceline (spot1,spot2,FALSE,self);
   if ( (trace_inopen && trace_inwater) ) {

      return ( FALSE );

   }
   if ( (trace_ent != targ) ) {

      return ( FALSE );

   }
   self.attack_state = AS_MISSILE;
   	if (autocvar_skill_adjusted_monster_rangedattack_frequence)
	{
		if (skill == 0)
			SUB_AttackFinished (2 + 2*random());
		else if (skill == 1)
			SUB_AttackFinished (1.4 + 2*random());
		else if (skill == 2)
			SUB_AttackFinished (0.8 + 2*random());
		else
			SUB_AttackFinished (2 + 2*random());	// will not be used in skill 3 by  SUB_AttackFinished  anyhow !!
	}
	else
		SUB_AttackFinished (2 + 2*random());
   return ( TRUE );

};


void (float ox) SCOURGE_FireSpikes = {

   local vector src;
   local vector vec;

   ai_face ();
   makevectors (self.angles);
   src = (((self.origin - '0.000 0.000 19.000') + (v_right * ox)) + (v_forward * 14.000));
   vec = ((self.enemy.origin + (MAX_CHARMER_DISTANCE * v_forward)) - src);
   vec = normalize (vec);
   sound (self,CHAN_WEAPON,"weapons/rocket1i.wav",TRUE,ATTN_NORM);
   launch_spike (src,vec);
   self.attack_finished = (time + 0.200);

};


void () Attack_With_Tail = {

   local float ldmg;
   local vector delta;

   ai_face ();
   delta = (self.enemy.origin - self.origin);
   if ( (vlen (delta) > 100.000) ) {

      return ;

   }
   if ( !CanDamage (self.enemy,self) ) {

      return ;

   }
   ldmg = (((random () + random ()) + random ()) * autocvar_scourge_tail);	// default 40
   T_Damage (self.enemy,self,self,ldmg);
   sound (self,CHAN_WEAPON,"shambler/smack.wav",TRUE,ATTN_NORM);
   SpawnMeatSpray ((self.origin + (v_forward * FL_INWATER)),((crandom () * 50.000) * v_right));

};


void () ScourgeTriggerThink;

void () ScourgeTriggerTouch;

void () scourge_think = {

   local entity trig;

   if ( !self.state ) {

      trig = spawn ();
      trig.angles = VEC_ORIGIN;
      trig.solid = SOLID_TRIGGER;
      setsize (trig,'-64.000 -64.000 -24.000','64.000 64.000 64.000');
      trig.takedamage = DAMAGE_NO;
      trig.movetype = MOVETYPE_NONE;
      trig.modelindex = FALSE;
      trig.model = "";
      trig.lastvictim = self;
      trig.think = ScourgeTriggerThink;
      trig.touch = ScourgeTriggerTouch;
      trig.nextthink = ((time + 0.100) + random ());
      setorigin (trig,self.origin);
      self.lastvictim = trig;
      self.state = TRUE;

   }
   if ( ((self.spawnsilent == FALSE) && (self.spawnmulti == TRUE)) ) {

      sound (self,CHAN_BODY,"misc/null.wav",TRUE,ATTN_IDLE);

   } else {

      if ( ((self.spawnsilent == TRUE) && (self.spawnmulti == FALSE)) ) {

         sound (self,CHAN_BODY,"scourge/walk.wav",TRUE,ATTN_IDLE);

      }

   }
   self.spawnmulti = self.spawnsilent;

};


void (float dist) ai_right = {

   walkmove ((self.angles_y + 90.000),dist);

};

void (float dist) ai_left = {

   walkmove ((self.angles_y + 270.000),dist);

};


void () scourge_stand1 = [ 0.000, scourge_stand2 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand2 = [ 1.000, scourge_stand3 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand3 = [ 2.000, scourge_stand4 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand4 = [ 3.000, scourge_stand5 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand5 = [ 4.000, scourge_stand6 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand6 = [ 5.000, scourge_stand7 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand7 = [ 6.000, scourge_stand8 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand8 = [ 7.000, scourge_stand9 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand9 = [ 8.000, scourge_stand10 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand10 = [ 9.000, scourge_stand11 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand11 = [ 10.000, scourge_stand12 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};

void () scourge_stand12 = [ 11.000, scourge_stand1 ] {

   self.spawnsilent = FALSE;
   ai_stand ();
   scourge_think ();

};


void () scourge_walk1 = [ 12.000, scourge_walk2 ] {

   if ( (random () < 0.100) ) {

      sound (self,CHAN_VOICE,"scourge/idle.wav",TRUE,ATTN_IDLE);

   }
   self.spawnsilent = TRUE;
   scourge_think ();
   ai_walk (FL_CLIENT);

};

void () scourge_walk2 = [ 13.000, scourge_walk3 ] {

   ai_walk (FL_CLIENT);

};

void () scourge_walk3 = [ 14.000, scourge_walk4 ] {

   ai_walk (FL_CLIENT);

};

void () scourge_walk4 = [ 15.000, scourge_walk5 ] {

   ai_walk (FL_CLIENT);

};

void () scourge_walk5 = [ 16.000, scourge_walk6 ] {

   ai_walk (FL_CLIENT);

};

void () scourge_walk6 = [ 17.000, scourge_walk1 ] {

   ai_walk (FL_CLIENT);

};


void () scourge_run1 = [ 12.000, scourge_run2 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   if ( (random () < 0.100) ) {

      sound (self,CHAN_VOICE,"scourge/idle.wav",TRUE,ATTN_IDLE);

   }
   self.spawnsilent = TRUE;
   scourge_think ();
   ai_run (18.000);

};

void () scourge_run2 = [ 13.000, scourge_run3 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   scourge_think ();
   ai_run (14.000);

};

void () scourge_run3 = [ 14.000, scourge_run4 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_run (14.000);

};

void () scourge_run4 = [ 15.000, scourge_run5 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_run (14.000);

};

void () scourge_run5 = [ 16.000, scourge_run6 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_run (14.000);

};

void () scourge_run6 = [ 17.000, scourge_run1 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_run (14.000);

};


void () scourge_strafeleft1 = [ 12.000, scourge_strafeleft2 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   self.spawnsilent = TRUE;
   scourge_think ();
   ai_left (20.000);

};

void () scourge_strafeleft2 = [ 13.000, scourge_strafeleft3 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_left (20.000);

};

void () scourge_strafeleft3 = [ 14.000, scourge_strafeleft4 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_left (20.000);

};

void () scourge_strafeleft4 = [ 15.000, scourge_strafeleft5 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_left (14.000);

};

void () scourge_strafeleft5 = [ 16.000, scourge_strafeleft6 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_left (14.000);

};

void () scourge_strafeleft6 = [ 17.000, scourge_run1 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_left (14.000);

};


void () scourge_straferight1 = [ 12.000, scourge_straferight2 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   self.spawnsilent = TRUE;
   scourge_think ();
   ai_right (20.000);

};

void () scourge_straferight2 = [ 13.000, scourge_straferight3 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_right (20.000);

};

void () scourge_straferight3 = [ 14.000, scourge_straferight4 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_right (20.000);

};

void () scourge_straferight4 = [ 15.000, scourge_straferight5 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_right (14.000);

};

void () scourge_straferight5 = [ 16.000, scourge_straferight6 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_right (14.000);

};

void () scourge_straferight6 = [ 17.000, scourge_run1 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_right (14.000);

};


void () scourge_turn1 = [ 12.000, scourge_turn2 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   self.spawnsilent = TRUE;
   scourge_think ();
   ai_turn_in_place ();

};

void () scourge_turn2 = [ 13.000, scourge_turn3 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_turn_in_place ();

};

void () scourge_turn3 = [ 14.000, scourge_turn4 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_turn_in_place ();

};

void () scourge_turn4 = [ 15.000, scourge_turn5 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_turn_in_place ();

};

void () scourge_turn5 = [ 16.000, scourge_turn6 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_turn_in_place ();

};

void () scourge_turn6 = [ 17.000, scourge_turn1 ] {self.nextthink = ((time + 0.1) - autocvar_monster_run_animation_speed_factor * 0.001);

   ai_turn_in_place ();

};


void () scourge_atk1 = [ 18.000, scourge_atk2 ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);

   self.spawnsilent = FALSE;
   scourge_think ();
   self.effects = (self.effects | EF_MUZZLEFLASH);
   SCOURGE_FireSpikes (40.000);

};

void () scourge_atk2 = [ 19.000, scourge_atk3 ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);

   self.effects = (self.effects | EF_MUZZLEFLASH);
   SCOURGE_FireSpikes (-56.000);

};

void () scourge_atk3 = [ 18.000, scourge_atk4 ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);

   self.effects = (self.effects | EF_MUZZLEFLASH);
   SCOURGE_FireSpikes (-40.000);

};

void () scourge_atk4 = [ 19.000, scourge_atk5 ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);

   self.effects = (self.effects | EF_MUZZLEFLASH);
   SCOURGE_FireSpikes (56.000);

};

void () scourge_atk5 = [ 18.000, scourge_atk6 ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);

   self.effects = (self.effects | EF_MUZZLEFLASH);
   SCOURGE_FireSpikes (40.000);

};

void () scourge_atk6 = [ 19.000, scourge_atk7 ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);

   self.effects = (self.effects | EF_MUZZLEFLASH);
   SCOURGE_FireSpikes (-56.000);

};

void () scourge_atk7 = [ 18.000, scourge_atk8 ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);

   self.effects = (self.effects | EF_MUZZLEFLASH);
   SCOURGE_FireSpikes (-40.000);

};

void () scourge_atk8 = [ 19.000, scourge_run1 ] {self.nextthink = ((time + 0.1) - autocvar_monster_rangedattack_animation_speed_factor * 0.001);

   self.effects = (self.effects | EF_MUZZLEFLASH);
   SCOURGE_FireSpikes (56.000);
if (autocvar_skill_adjusted_monster_rangedattack_frequence)
{
	if (skill == 0)
		SUB_AttackFinished (4*random());
	else if (skill == 1)
		SUB_AttackFinished (3*random());
	else if (skill == 2)
		SUB_AttackFinished (2*random());
	else
		SUB_AttackFinished (4*random());	// will not be used in skill 3 by  SUB_AttackFinished  anyhow !!        
}
else
	SUB_AttackFinished (4*random());

};


void () scourge_melee1 = [ 20.000, scourge_melee2 ] {

   self.spawnsilent = FALSE;
   scourge_think ();
   ai_charge (MOVETYPE_WALK);

};

void () scourge_melee2 = [ 21.000, scourge_melee3 ] {

   ai_charge (MOVETYPE_WALK);

};

void () scourge_melee3 = [ 22.000, scourge_melee4 ] {

   ai_charge (FL_SWIM);

};

void () scourge_melee4 = [ 23.000, scourge_melee5 ] {

   ai_charge (FL_SWIM);

};

void () scourge_melee5 = [ 24.000, scourge_melee6 ] {

   sound (self,CHAN_WEAPON,"scourge/tailswng.wav",TRUE,ATTN_NORM);
   ai_charge (MOVETYPE_WALK);

};

void () scourge_melee6 = [ 25.000, scourge_melee7 ] {

   ai_charge (TRUE);

};

void () scourge_melee7 = [ 26.000, scourge_melee8 ] {

   Attack_With_Tail (); 

};

void () scourge_melee8 = [ 27.000, scourge_melee9 ] {

   ai_face ();

};

void () scourge_melee9 = [ 28.000, scourge_melee10 ] {

   ai_face ();

};

void () scourge_melee10 = [ 29.000, scourge_melee11 ] {

   ai_face ();

};

void () scourge_melee11 = [ 30.000, scourge_run1 ] {

   ai_face ();
   SUB_CheckRefire (scourge_melee1);

};


void () scourge_pain1 = [ 31.000, scourge_pain2 ] {

   self.spawnsilent = FALSE;
   scourge_think ();

};

void () scourge_pain2 = [ 32.000, scourge_pain3 ] {


};

void () scourge_pain3 = [ 33.000, scourge_pain4 ] {


};

void () scourge_pain4 = [ 34.000, scourge_pain5 ] {


};

void () scourge_pain5 = [ 35.000, scourge_run1 ] {


};


void (entity attacker, float damage) scourge_pain = {
   local float r;
   if ( ((random () * 50.000) > damage) ) {
      return ;
   }
   if ( (self.pain_finished > time) ) {
      return ;
   }
   r = random ();
   sound (self,CHAN_VOICE,"scourge/pain.wav",TRUE,ATTN_NORM);
   self.pain_finished = (time + FL_SWIM);
   	if (autocvar_slowmotion >= 4)	// start slowmotion when hurting enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_scourge * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
   scourge_pain1 ();
};


var float autocvar_scourgecorpsehealth = 60;	// set cvar 'scourgecorpsehealth' default to 60
var float autocvar_scourgecorpseburnable = 0;	// set cvar 'scourgecorpseburnable' default to 0

void () scourge_die1 = [ 36.000, scourge_die2 ] {
   self.spawnsilent = FALSE;
   scourge_think ();
};

void () scourge_die2 = [ 37.000, scourge_die3 ] {
};

void () scourge_die3 = [ 38.000, scourge_die4 ] {
   self.solid = SOLID_NOT;
};

void () scourge_die4 = [ 39.000, scourge_die5 ] {
};

void () scourge_die5 = [ 40.000, scourge_die5 ] {
if (self.inflamed == 1)
{
	inflamed_die ();
	return;
}
	if (autocvar_scourgecorpseburnable == 1)		// corpses are burnable
		self.burnable_corpse = 1;
// 	auto_cvar 'scourgecorpsehealth' has been set to  default = 60  in code above already
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(autocvar_scourgecorpsehealth, "progs/h_scourg.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(autocvar_scourgecorpsehealth, "progs/h_scourg1.mdl");
};


void(float maxgibs, float gibscounter) producegibs_scourg =	 // creates as many gib-sets as defined in cvar 'gibsmultiplier'
{
if (gibscounter >= maxgibs)
	return;
else
	{
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);   	
	}
gibscounter = gibscounter + 1;
producegibs_scourg (maxgibs, gibscounter);
};


void()	scourge_lightning_death	=[	$attack7,	scourge_lightning_death1	] {
	if (autocvar_lightninggun_death_animation == 2)	  // start the "fade" effect instead of "coal" effect
		lightninggun_death_fade();
};

void()	scourge_lightning_death1	=[	$attack7,	scourge_lightning_death1	] {
	self.solid = SOLID_NOT;
	self.baked = 1;
	self.colormod = '0.25 0.22 0.22';	// skins gets darker (looks burned)
	if (self.monstermodel == 0)  
		CopyMonsterToBodyQue(1, "progs/h_scourg.mdl");
	if (self.monstermodel == 1)  
		CopyMonsterToBodyQue(1, "progs/h_scourg1.mdl");
};



void() scourge_die;
void() scourge_inflamed7;

void () scourge_inflamed1 = [ 12.000, scourge_inflamed2 ] {ai_run_inflamed(18);self.nextthink = time + 0.075;
if (random() < 0.7)
   sound (self,CHAN_VOICE,"scourge/pain.wav",TRUE,ATTN_NORM);
};
void () scourge_inflamed2 = [ 13.000, scourge_inflamed3 ] {ai_run_inflamed(14);self.nextthink = time + 0.075;};
void () scourge_inflamed3 = [ 14.000, scourge_inflamed4 ] {ai_run_inflamed(14);self.nextthink = time + 0.075;};
void () scourge_inflamed4 = [ 15.000, scourge_inflamed5 ] {ai_run_inflamed(14);self.nextthink = time + 0.075;};
void () scourge_inflamed5 = [ 16.000, scourge_inflamed6 ] {ai_run_inflamed(14);self.nextthink = time + 0.075;};
void () scourge_inflamed6 = [ 17.000, scourge_inflamed1 ] {ai_run_inflamed(14);self.nextthink = time + 0.075;
if (self.inflametime < time)
{
	scourge_die ();
	return;
}
if (random() < 0.65)
	scourge_inflamed7 ();	// pain anim
};

void () scourge_inflamed7 = [ 31.000, scourge_inflamed8 ] {
if (random() < 0.8)
   sound (self,CHAN_VOICE,"scourge/pain.wav",TRUE,ATTN_NORM);
};
void () scourge_inflamed8 = [ 32.000, scourge_inflamed9 ] {};
void () scourge_inflamed9 = [ 33.000, scourge_inflamed10 ] {};
void () scourge_inflamed10 = [ 34.000, scourge_inflamed11 ] {};
void () scourge_inflamed11 = [ 35.000, scourge_inflamed1 ] {
if (self.inflametime < time)
{
	scourge_die ();
	return;
}
};


void () scourge_die = {
	if (autocvar_lightninggun_death_animation)		// if 'lightninggun_death_animation' is enabled
	{
		if (self.enemy.weapon == IT_LIGHTNING)		// when enemy was killed with lightning gun, go into baked mode
		{
			scourge_lightning_death();
			return;
		}
	}
local float maxgibs, gibscounter;
   remove (self.lastvictim);
   self.spawnsilent = FALSE;
   scourge_think ();
   
// check for gib
   if ( (self.health < -35.000) ) 
   {
	if (autocvar_slowmotion >= 1)	// start slowmotion when gibbing living enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_scourge * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
      sound (self,CHAN_VOICE,"player/udeath.wav",TRUE,ATTN_NORM);
 	var float autocvar_gibsmultiplier = 1;         	// set cvar 'gibsmultiplier' default to 1
		if (autocvar_gibsmultiplier == 1)		// if 'gibsmultiplier' doesnt exist in autoexec.cfg, or if 'gibsmultiplier' is set via autoexec.cfg to '1'
			{
			if (self.monstermodel == 0)  
				ThrowHead ("progs/h_scourg.mdl", self.health);
			else if (self.monstermodel == 1)  
				ThrowHead ("progs/h_scourg1.mdl", self.health);
				ThrowGib ("progs/gib1.mdl", self.health);
				ThrowGib ("progs/gib2.mdl", self.health);
				ThrowGib ("progs/gib3.mdl", self.health);
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				return;
			}
			else 							// if 'gibsmultiplier' is set via autoexec.cfg to any other value than '1'
			{						// --> produce more gibs
				if (self.monstermodel == 0)  
					ThrowHead ("progs/h_scourg.mdl", self.health);
				else if (self.monstermodel == 1)  
					ThrowHead ("progs/h_scourg1.mdl", self.health);
				maxgibs = autocvar_gibsmultiplier;
				gibscounter = 0;
				if (autocvar_heartgib >= 1)		// if 'heartgib' doesnt exist in autoexec.cfg, or if 'heartgib' is set via autoexec.cfg to '1' or higher
					ThrowHeart ("progs/gibheart.mdl", self.health);
				if (autocvar_bloodextension == 1)		 // if 'bloodextension' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '1'
					pointparticles(particleeffectnum("blood_monster_gib"), self.origin, '0 0 0', 1);
				producegibs_scourg (maxgibs, gibscounter);
				return;
			}
   }
   
	if (autocvar_burning_monsters_death_animation)		// if 'burning_monsters_death_animation' is enabled
	{
		if (self.inflamed == 0) // enemy is not burning
		{
			local float zufa;
			zufa = random() * 100;
			if (((self.enemy.weapon == IT_GRENADE_LAUNCHER) || (self.enemy.weapon == IT_ROCKET_LAUNCHER) || (self.enemy.weapon == IT_PROXIMITY_GUN)) && (zufa <= autocvar_burning_monsters_death_animation) && (self.watertype != CONTENT_WATER))	// when enemy was killed with explosives, set it on fire
			{
				self.inflamed = 1;
				self.traileffectnum = particleeffectnum("burning_monster");
				self.inflametime = time + autocvar_burning_monsters_death_animation_time + random();
				scourge_inflamed1 ();
				return;
			}
		}
		else		// enemy is burning already and his "run-around-in-panic-time" has just ended
		{
			sound (self,CHAN_VOICE,"scourge/pain2.wav",TRUE,ATTN_NORM);
			scourge_die1 ();
			return;
		}
	}

// regular death
   	if (autocvar_slowmotion >= 3)	// start slowmotion when regular killing living enemies
		{
		if (random () <= (autocvar_slowmotion_randomness_scourge * 0.01))
			{
			the_matrix = 1;
			matrixcounter = time + (autocvar_slowmotion_intensity * autocvar_slowmotion_duration);	// Attention: formula needed to take the intensity into account. Time increase is much more when slowmo is active ! (time + 1 will be approx. 3seconds with slowmo 0.33 !)
			}
		}
   sound (self,CHAN_VOICE,"scourge/pain2.wav",TRUE,ATTN_NORM);
   scourge_die1 ();
};

void () scourge_melee = {

   local float chance;

   scourge_melee1 ();
   SUB_AttackFinished ((FL_SWIM * random ()));

};

void () ScourgeTriggerThink = {

   local entity targ;

   if ( (self.lastvictim.health <= FALSE) ) {

      remove (self);
      return ;

   }
   targ = self.lastvictim;
   makevectors (targ.angles);
   setorigin (self,(targ.origin + (v_forward * 300.000)));
   self.nextthink = (time + 0.100);

};

void () ScourgeTriggerTouch = {

   local entity targ;
   local entity tempent;
   local vector dir;

   if ( (other.flags & (FL_MONSTER | FL_CLIENT)) ) {

      return ;

   }
   if ( (other.movetype != MOVETYPE_FLYMISSILE) ) {

      return ;

   }
   targ = self.lastvictim;
   if ( (targ.health <= FALSE) ) {

      remove (self);
      return ;

   }
   dir = (targ.origin - other.origin);
   dir = normalize (dir);
   if ( ((dir * normalize (other.velocity)) < 0.800) ) {

      return ;

   }
   if ( (time > self.duration) ) {

      tempent = self;
      self = targ;
      if ( (random () < 0.500) ) {

         scourge_strafeleft1 ();

      } else {

         scourge_straferight1 ();

      }
      self.duration = (time + 1.500);

   }
   self = tempent;

};

void () monster_scourge = {

   local entity trig;

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   precache_model2 ("progs/scor.mdl");
   precache_model2 ("progs/h_scourg.mdl");
   precache_model2 ("progs/laser.mdl");
   precache_model2 ("progs/s_light.mdl");
   precache_model2 ("progs/spike.mdl");
   precache_sound ("misc/null.wav");
   precache_sound ("scourge/idle.wav");
   precache_sound ("scourge/pain.wav");
   precache_sound ("scourge/pain2.wav");
   precache_sound ("scourge/sight.wav");
   precache_sound ("scourge/tailswng.wav");
   precache_sound ("scourge/walk.wav");
   precache_sound2 ("shambler/smack.wav");
   precache_sound2 ("weapons/rocket1i.wav");
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_STEP;
   
   var float autocvar_scourgemultiskin = 0;     	// set cvar 'scourgemultiskin' default to 0
	local float zufall;
	if (autocvar_scourgemultiskin == 1)		// if 'scourgemultiskin' is set via autoexec.cfg to '1' use 2 different skins for ID1 model
	{
		self.multiskin = 1;
		setmodel (self, "progs/scor.mdl");
		zufall = random();
		if (zufall >= 0.5)
			{
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
	}
	else if (autocvar_scourgemultiskin == 2)	// if 'scourgemultiskin' is set via autoexec.cfg to '2' use 1 Id1 model skin AND external model
	{
		self.multiskin = 2;
		precache_model ("progs/scor1.mdl");
		precache_model ("progs/h_scourg1.mdl");
		zufall = random();
		if (zufall >= 0.5)
			{
			setmodel (self, "progs/scor.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else 
			{
			setmodel (self, "progs/scor1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_scourgemultiskin == 3)	// if 'scourgemultiskin' is set via autoexec.cfg to '3' use 2 Id1 model skins AND external model
	{
		self.multiskin = 3;
		precache_model ("progs/scor1.mdl");
		precache_model ("progs/h_scourg1.mdl");
		zufall = random();
		if (zufall > 0.66)
			{
			setmodel (self, "progs/scor.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall < 0.34)
			{
			setmodel (self, "progs/scor.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else
			{
			setmodel (self, "progs/scor1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
	}
	else if (autocvar_scourgemultiskin == 4)	// if 'scourgemultiskin' is set via autoexec.cfg to '4' use 2 Id1 model skins AND 2 external model skins
	{
		self.multiskin = 4;
		precache_model ("progs/scor1.mdl");
		precache_model ("progs/h_scourg1.mdl");
		zufall = random();
		if (zufall > 0.75)
			{
			setmodel (self, "progs/scor.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 0;
			}
		else if (zufall > 0.5 && zufall <= 0.75)
			{
			setmodel (self, "progs/scor.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 0;
			}
		else if (zufall > 0.25 && zufall <= 0.5)
			{
			setmodel (self, "progs/scor1.mdl");
			self.skin = 0;
			self.monsterskin = 0;
			self.monstermodel = 1;
			}
		else 
			{
			setmodel (self, "progs/scor1.mdl");
			self.skin = 1;
			self.monsterskin = 1;
			self.monstermodel = 1;
			}
	}
	else						// standard Quake
		{
		setmodel (self, "progs/scor.mdl");
		self.skin = 0;
		self.monsterskin = 0;
		self.monstermodel = 0;
		}
   
   setsize (self,VEC_HULL2_MIN,VEC_HULL2_MAX);
   self.health = autocvar_scourge_health;	// default 300
   self.health_initial = self.health;
   self.th_stand = scourge_stand1;
   self.th_walk = scourge_walk1;
   self.th_run = scourge_run1;
   self.th_pain = scourge_pain;
   self.th_die = scourge_die;
   self.th_melee = scourge_melee;
   self.th_missile = scourge_atk1;
   self.yaw_speed = 60.000;
   self.attack_state = AS_DODGING;
   self.state = FALSE;
   
   	if (autocvar_monster_random_skin_color_alteration && autocvar_scourge_random_skin_colors)	// modify/edit this monster types skin textures randomly (for higher variation in-game)
	{												// limit values to avoid extreme colors
		self.colormod_x = random ();
		if (self.colormod_x < 0.5)
			self.colormod_x = self.colormod_x + 0.5;
		if (autocvar_monster_random_skin_color_alteration == 1)		// only slight changes allowed
		{
			if (self.colormod_x < 0.75)
				self.colormod_x = self.colormod_x + 0.25;
		}
		else if (autocvar_monster_random_skin_color_alteration == 2)	// moderate changes allowed
		{
			if (self.colormod_x < 0.65)
				self.colormod_x = self.colormod_x + 0.25;
		}
		else								// stronger changes allowed
		{
			if (self.colormod_x < 0.55)
				self.colormod_x = self.colormod_x + 0.25;
		}
		self.colormod_y = random ();
		if (self.colormod_y < 0.5)
			self.colormod_y = self.colormod_y + 0.5;
		if (autocvar_monster_random_skin_color_alteration == 1)		// only slight changes allowed
		{
			if (self.colormod_y < 0.75)
				self.colormod_y = self.colormod_y + 0.25;
		}
		else if (autocvar_monster_random_skin_color_alteration == 2)	// moderate changes allowed
		{
			if (self.colormod_y < 0.65)
				self.colormod_y = self.colormod_y + 0.25;
		}
		else								// stronger changes allowed
		{
			if (self.colormod_y < 0.55)
				self.colormod_y = self.colormod_y + 0.25;
		}
		self.colormod_z = random ();
		if (self.colormod_z < 0.5)
			self.colormod_z = self.colormod_z + 0.5;
		if (autocvar_monster_random_skin_color_alteration == 1)		// only slight changes allowed
		{
			if (self.colormod_z < 0.75)
				self.colormod_z = self.colormod_z + 0.25;
		}
		else if (autocvar_monster_random_skin_color_alteration == 2)	// moderate changes allowed
		{
			if (self.colormod_z < 0.65)
				self.colormod_z = self.colormod_z + 0.25;
		}
		else								// stronger changes allowed
		{
			if (self.colormod_z < 0.55)
				self.colormod_z = self.colormod_z + 0.25;
		}
	}

   self.alpha = autocvar_monstertransparency * 0.01;

	if (autocvar_spider_replace_scourge)	// if scourge shall be replaced by spider. Check the chance and do it !!)
		{	
		local float replacer;		
		replacer = autocvar_spider_replace_scourge * 0.01;
		if (random () <= replacer)
			{
			self.skin = 5;
			self.health = 300;
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_spider_start();
			return;
			}
		}
		
	if (autocvar_afrit_replace_scourge)		// if scourge shall be replaced by afrit. Check the chance and do it !!)
		{	
		local float replac;		
		replac = autocvar_afrit_replace_scourge * 0.01;
		if (random () <= replac)
			{
			self.health = 300;
			self.nextthink = time + 0.3;	
			self.think = SUB_Remove;
			monster_afrit_liftorigin_start();
			return;
			}
		}

   walkmonster_start ();

do_the_cloning();

if (autocvar_afrit_supports_scourge)		// if afrit shall be spawned in ADDITION to an existing scourge. Check the chance and do it !!)
	{	
	local float replace;		
	replace = autocvar_afrit_supports_scourge * 0.01;
	if (random () <= replace)
		add_afrit_support_walk ();
	}

var float autocvar_scrgemass = 2100;
MonsterPhysics (self, autocvar_scrgemass);
};
