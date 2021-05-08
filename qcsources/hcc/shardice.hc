
void  ()shardTouch =  {
local float damg = 0.00000;
   if ( (other == self.owner) ) {

      return ;

   }
   if ( (pointcontents ( self.origin) == CONTENT_SKY) ) {

      remove ( self);
      return ;

   }
   if ( (self.owner.classname == "monster_imp_lord") ) {

      damg = random(33.00000,77.00000);
   } else {

      damg = random(5.00000,10.00000);

   }
   if ( (((other.health <= damg) && (other.thingtype == THINGTYPE_FLESH)) && (random() < 0.10000)) ) {

      SnowJob ( other, self);
   } else {

      if ( other.health ) {

         T_Damage ( other, self, self.owner, damg);
         sound ( self, CHAN_BODY, "crusader/icehit.wav", 1.00000, ATTN_NORM);
         if ( (other.classname == "player") ) {

            other.artifact_active |= ARTFLAG_FROZEN;
            newmis = spawn ( );
            newmis.enemy = other;
            newmis.artifact_active = ARTFLAG_FROZEN;
            newmis.think = remove_artflag;
            AdvanceThinkTime(newmis,0.10000);

         }

      }

   }
   remove ( self);
};


void  ()shard_1 =  [  0.0, shard_1] {
};


void  (vector offset,float set_speed,vector dest_offset)do_shard =  {
local entity missile;
local vector vec = '0.00000 0.00000 0.00000';
   missile = spawn ( );
   missile.owner = self;
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_BBOX;
   missile.health = 10.00000;
   if ( (self.classname == "monster_imp_lord") ) {

      set_speed *= 2.00000;
      missile.scale = 2.00000;

   }
   setmodel ( missile, "models/shardice.mdl");
   setsize ( missile, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   makevectors ( self.angles);
   vec = ((self.origin + self.view_ofs) + v_factor ( offset));
   setorigin ( missile, vec);
   vec = (((self.enemy.origin - missile.origin) + self.enemy.proj_ofs) + dest_offset);
   vec = normalize ( vec);
   missile.velocity = (vec * set_speed);
   missile.angles = vectoangles ( missile.velocity);
   missile.touch = shardTouch;
   missile.think = shard_1;
   missile.nextthink = (time + HX_FRAME_TIME);
};

