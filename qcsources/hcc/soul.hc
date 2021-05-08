
void  ()crusader_soul_touch =  {
   if ( !(other.flags2 & FL_ALIVE) ) {

      return ;

   }
   if ( ((other.classname == "player") && (other.playerclass == CLASS_CRUSADER)) ) {

      sound ( self, CHAN_VOICE, "items/artpkup.wav", 1.00000, ATTN_NORM);
      other.super_damage_time = (time + 30.00000);
      other.super_damage = 1.00000;
      other.super_damage_low = 0.00000;
      self.touch = SUB_Null;
      self.think = SUB_Remove;
      AdvanceThinkTime(self,(HX_FRAME_TIME * 2.00000));
      self.enemy.think = SUB_Remove;
      AdvanceThinkTime(self.enemy,(HX_FRAME_TIME * 2.00000));
      sprint ( other, "You now have Holy Strength!\n");
   } else {

      if ( ((other.classname == "player") && ((other.playerclass == CLASS_NECROMANCER) || (other.playerclass == CLASS_ASSASSIN))) ) {

         if ( (self.pain_finished < time) ) {

            T_Damage ( other, self, self, 5.00000);

         }
         self.pain_finished = (time + 0.20000);

      }

   }
};


void  ()necro_soul_touch =  {
   if ( !(other.flags2 & FL_ALIVE) ) {

      return ;

   }
   if ( ((other.classname == "player") && (other.playerclass == CLASS_NECROMANCER)) ) {

      sound ( self, CHAN_VOICE, "items/artpkup.wav", 1.00000, ATTN_NORM);
      other.health += self.health;
      if ( (other.health > other.max_health) ) {

         other.health = other.max_health;

      }
      other.bluemana += self.bluemana;
      if ( (other.bluemana > other.max_mana) ) {

         other.bluemana = other.max_mana;

      }
      other.greenmana += self.greenmana;
      if ( (other.greenmana > other.max_mana) ) {

         other.greenmana = other.max_mana;

      }
      sprint ( other, "You have devoured a life force!\n");
      self.touch = SUB_Null;
      self.think = SUB_Remove;
      AdvanceThinkTime(self,(HX_FRAME_TIME * 2.00000));
      self.enemy.think = SUB_Remove;
      AdvanceThinkTime(self.enemy,(HX_FRAME_TIME * 2.00000));
   } else {

      if ( ((other.classname == "player") && ((other.playerclass == CLASS_PALADIN) || (other.playerclass == CLASS_CRUSADER))) ) {

         if ( (self.pain_finished < time) ) {

            T_Damage ( other, self, self, 5.00000);

         }
         self.pain_finished = (time + 0.20000);

      }

   }
};


void  ()soul_move =  {
local vector vel = '0.00000 0.00000 0.00000';
local float p_color = 0.00000;
   self.velocity_z += self.hoverz;
   if ( (self.velocity_z > 16.00000) ) {

      self.hoverz = -1.00000;
   } else {

      if ( (self.velocity_z < -16.00000) ) {

         self.hoverz = 1.00000;

      }

   }
   if ( (self.classname == "soulskull") ) {

      p_color = 144.00000;
      vel = random('-1.44000 -1.44000 -65.00000','1.44000 1.44000 -35.00000');
      particle2 ( (self.origin - '0.00000 0.00000 20.00000'), vel, vel, p_color, PARTICLETYPE_C_EXPLODE, (self.health / 4.00000));
   } else {

      if ( (self.classname == "soulcross") ) {

         p_color = 176.00000;
         vel = random('-1.44000 -1.44000 65.00000','1.44000 1.44000 35.00000');
         particle2 ( (self.origin + '0.00000 0.00000 25.00000'), vel, vel, p_color, PARTICLETYPE_C_EXPLODE, (self.health / 4.00000));

      }

   }
   setorigin ( self.enemy, self.origin);
   self.health -= 0.10000;
   self.think = soul_move;
   AdvanceThinkTime(self,0.10000);
   if ( (self.sound_time < time) ) {

      self.sound_time = (time + 4.00000);
      sound ( self, CHAN_VOICE, "raven/soul.wav", 1.00000, ATTN_NORM);

   }
   if ( (self.health <= 0.00000) ) {

      sound ( self, CHAN_VOICE, "misc/null.wav", 1.00000, ATTN_NORM);
      remove ( self);
      remove ( self.enemy);

   }
};


void  (entity ent)necromancer_sphere =  {
local entity new;
local entity new2;
local float chance = 0.00000;
   chance = (0.05000 + ((ent.level - 3.00000) * 0.03000));
   if ( (chance > 0.20000) ) {

      chance = 0.20000;

   }
   if ( (random() > chance) ) {

      return ;

   }
   new2 = spawn ( );
   new2.owner = new;
   new2.solid = SOLID_TRIGGER;
   new2.movetype = MOVETYPE_FLY;
   droptofloor ( );
   setorigin ( new2, (self.origin + '0.00000 0.00000 32.00000'));
   setmodel ( new2, "models/soulskul.mdl");
   new2.classname = "soulskull";
   setsize ( new2, new2.mins, new2.maxs);
   new2.think = soul_move;
   AdvanceThinkTime(new2,0.10000);
   new2.hoverz = 1.00000;
   new2.velocity_z = new.hoverz;
   new2.touch = necro_soul_touch;
   new2.flags = 0.00000;
   new2.lifespan = 15.00000;
   new2.health = (new2.lifespan * 2.00000);
   new2.avelocity_y = 200.00000;
   sound ( new, CHAN_VOICE, "raven/soul.wav", 1.00000, ATTN_NORM);
   new = spawn ( );
   new.owner = new;
   new.solid = SOLID_TRIGGER;
   new.movetype = MOVETYPE_FLY;
   setmodel ( new, "models/soulball.mdl");
   setsize ( new, new.mins, new.maxs);
   new.flags = 0.00000;
   setorigin ( new, new2.origin);
   new2.enemy = new;
};


void  (entity ent)crusader_sphere =  {
local entity new;
local entity new2;
local float chance = 0.00000;
   chance = (0.05000 + ((ent.level - 3.00000) * 0.03000));
   if ( (chance > 0.20000) ) {

      chance = 0.20000;

   }
   if ( (random() > chance) ) {

      return ;

   }
   new2 = spawn ( );
   new2.owner = new2;
   new2.solid = SOLID_TRIGGER;
   new2.movetype = MOVETYPE_FLY;
   droptofloor ( );
   setorigin ( new2, (self.origin + '0.00000 0.00000 32.00000'));
   setmodel ( new2, "models/cross.mdl");
   setsize ( new2, new2.mins, new2.maxs);
   new2.classname = "soulcross";
   new2.touch = crusader_soul_touch;
   new2.think = soul_move;
   AdvanceThinkTime(new2,0.10000);
   new2.hoverz = 1.00000;
   new2.velocity_z = new.hoverz;
   new2.flags = 0.00000;
   new2.lifespan = 15.00000;
   new2.health = (new2.lifespan * 2.00000);
   new2.avelocity_y = 200.00000;
   sound ( new, CHAN_VOICE, "raven/soul.wav", 1.00000, ATTN_NORM);
   new = spawn ( );
   new.owner = new;
   new.solid = SOLID_TRIGGER;
   new.movetype = MOVETYPE_FLY;
   setorigin ( new, new2.origin);
   setmodel ( new, "models/goodsphr.mdl");
   new.drawflags |= MLS_ABSLIGHT;
   setsize ( new, new.mins, new.maxs);
   new.hoverz = 1.00000;
   new.velocity_z = new.hoverz;
   new.flags = 0.00000;
   new.lifespan = 15.00000;
   new.health = (new.lifespan * 2.00000);
   new.sound_time = 2.00000;
   new2.enemy = new;
};

