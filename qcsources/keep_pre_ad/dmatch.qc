
void () tag_token_respawn = {

   local entity spawnPoint;
   local entity tagToken;

   tagToken = find (world,classname,"dmatch_tag_token");
   if ( (tagToken == world) ) {

      return ;

   }
   spawnPoint = SelectSpawnPoint ();
   setorigin (tagToken,spawnPoint.origin);
   tag_token_owner = world;
   tagToken.solid = SOLID_TRIGGER;
   tagToken.touch = tag_token_touch;
   tagToken.think = SUB_Null;
   tagToken.owner = world;
   tagToken.tag_frags = FALSE;
   droptofloor ();

};

void () tag_token_fall = {

   self.tag_frags = FALSE;
   self.think = tag_token_respawn;
   self.nextthink = (time + SVC_INTERMISSION);
   droptofloor ();

};

void () tag_token_drop = {

   local entity tagToken;

   tagToken = find (world,classname,"dmatch_tag_token");
   if ( (tagToken == world) ) {

      return ;

   }
   bprint (tagToken.owner.netname);
   bprint (" lost the tag token!\n");
   tagToken.tag_frags = FALSE;
   tagToken.solid = SOLID_TRIGGER;
   tagToken.owner = world;
   tagToken.touch = tag_token_touch;
   tagToken.think = tag_token_fall;
   tagToken.nextthink = (time + 0.100);

};

void () tag_token_think = {

   if ( (self.owner.health > FALSE) ) {

      if ( (self.tag_message_time < time) ) {

         bprint (self.owner.netname);
         bprint (" has the tag token!\n");
         self.tag_message_time = (time + SVC_INTERMISSION);

      }
      setorigin (self,(self.owner.origin + '0.000 0.000 48.000'));
      self.think = tag_token_think;
      self.nextthink = (time + 0.100);

   } else {

      tag_token_drop ();

   }

};

void () tag_token_touch = {

   if ( (other.classname != "player") ) {

      return ;

   }
   tag_token_owner = other;
   self.tag_frags = FALSE;
   sound (self,CHAN_AUTO,"runes/end1.wav",TRUE,ATTN_NORM);
   bprint (other.netname);
   bprint (" got the tag token!\n");
   self.tag_message_time = (time + SVC_INTERMISSION);
   self.owner = other;
   self.solid = SOLID_NOT;
   self.touch = SUB_Null;
   self.think = tag_token_think;
   self.nextthink = (time + 0.100);

};

void () dmatch_tag_token = {

   if ( (cvar ("teamplay") != TEAM_DMATCH_TAG) ) {

      remove (self);
      return ;

   }
   precache_model ("progs/sphere.mdl");
   precache_sound ("runes/end1.wav");
   setmodel (self,"progs/sphere.mdl");
   self.skin = TRUE;
   setsize (self,'-16.000 -16.000 -16.000','16.000 16.000 16.000');
   self.touch = tag_token_touch;
   self.effects = (self.effects | EF_DIMLIGHT);
   StartItem ();

};

void (entity targ, entity attacker) dmatch_score = {

   local entity tagToken;

   if ( (teamplay == TEAM_DMATCH_TAG) ) {

      tagToken = find (world,classname,"dmatch_tag_token");
      if ( (tagToken == world) ) {

         attacker.frags = (attacker.frags + TRUE);
         return ;

      }
      if ( (attacker == tag_token_owner) ) {

         tagToken.tag_frags = (tagToken.tag_frags + TRUE);
         attacker.frags = (attacker.frags + MOVETYPE_WALK);
         if ( (tagToken.tag_frags == MOVETYPE_FLY) ) {

            sprint (attacker,"You got the Quad Damage\n");
            attacker.items = (attacker.items | IT_QUAD);
            stuffcmd (attacker,"bf\n");
            sound (attacker,CHAN_VOICE,"items/damage.wav",TRUE,ATTN_NORM);
            attacker.super_time = TRUE;
            attacker.super_damage_finished = (time + SVC_INTERMISSION);

         } else {

            if ( (tagToken.tag_frags == MOVETYPE_BOUNCE) ) {

               bprint (attacker.netname);
               bprint (" lost the tag token\n");
               tagToken.solid = SOLID_TRIGGER;
               tagToken.tag_frags = FALSE;
               tagToken.touch = tag_token_touch;
               tag_token_respawn ();

            }

         }

      } else {

         if ( (targ == tag_token_owner) ) {

            attacker.frags = (attacker.frags + MOVETYPE_FLY);
            sound (self,CHAN_AUTO,"runes/end1.wav",TRUE,ATTN_NORM);
            if ( (attacker.classname == "player") ) {

               tag_token_owner = attacker;
               tagToken.tag_frags = FALSE;
               tagToken.tag_message_time = (time + 0.500);
               tagToken.owner = attacker;
               tagToken.solid = SOLID_NOT;
               tagToken.touch = SUB_Null;
               tagToken.think = tag_token_think;
               tagToken.nextthink = (time + 0.100);

            }

         } else {

            attacker.frags = (attacker.frags + TRUE);

         }

      }

   }

};
