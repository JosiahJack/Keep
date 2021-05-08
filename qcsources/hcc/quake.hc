
void  ()ShakeRattleAndRoll =  {
local entity head;
local float inertia = 0.00000;
local float richter = 0.00000;
local float dist = 0.00000;
local float rand = 0.00000;
local float boost = 0.00000;
local vector dir = '0.00000 0.00000 0.00000';
   head = findradius ( self.origin, self.mass);
   richter = (((self.mass / 100.00000) * (self.lifetime - time)) / 3.00000);
   while ( head ) {

      if ( (((((((head.movetype == MOVETYPE_STEP) || (head.movetype == MOVETYPE_WALK)) || (head.movetype == MOVETYPE_PUSHPULL)) && (head.solid != SOLID_BSP)) && (head.mass < 500.00000)) && (head != self.owner)) && ((((head.classname != "monster_golem_bronze") && (head.classname != "monster_golem_iron")) && (head.classname != "monster_golem_stone")) && (head.classname != "monster_golem_crystal"))) ) {

         dist = (vlen ( (self.origin - head.origin)) / self.mass);
         if ( !head.mass ) {

            inertia = 1.00000;
         } else {

            inertia = (head.mass / 10.00000);

         }
         if ( ((((!(head.flags2 & FL_ALIVE) && head.takedamage) && head.health) && (random() < 0.20000)) && (head != self.owner)) ) {

            T_Damage ( head, self, self.owner, (richter * dist));

         }
         if ( (head.flags & FL_ONGROUND) ) {

            if ( (head != self.owner) ) {

               if ( (head.classname == "player") ) {

                  head.punchangle_x = ((random() * 10.00000) - 5.00000);
                  head.punchangle_y = ((random() * 8.00000) - 4.00000);
                  head.punchangle_z = ((random() * 8.00000) - 4.00000);
               } else {

                  if ( (head.flags2 & FL_ALIVE) ) {

                     head.angles_y += ((random() * 20.00000) - 10.00000);
                     rand = ((random() * 6.00000) - 3.00000);
                     if ( (((head.angles_x + rand) > 30.00000) || ((head.angles_x + rand) < -30.00000)) ) {

                        head.angles_x -= rand;
                     } else {

                        head.angles_x += rand;

                     }
                     rand = ((random() * 6.00000) - 3.00000);
                     if ( (((head.angles_z + rand) > 30.00000) || ((head.angles_z + rand) < -30.00000)) ) {

                        head.angles_z -= rand;
                     } else {

                        head.angles_z += rand;

                     }
                  } else {

                     if ( (head.movetype != MOVETYPE_BOUNCE) ) {

                        head.oldmovetype = head.movetype;
                        head.movetype = MOVETYPE_BOUNCE;
                     } else {

                        if ( !head.oldmovetype ) {

                           head.oldmovetype = MOVETYPE_BOUNCE;

                        }

                     }
                     head.avelocity_z = random(1.00000,10.00000);
                     head.avelocity_y = ((random() * 720.00000) - 360.00000);
                     head.avelocity_x = ((random() * 720.00000) - 360.00000);

                  }

               }
               boost = ((((random(100.00000) + 25.00000) / inertia) * richter) * dist);
               if ( (boost > 100.00000) ) {

                  boost = 100.00000;

               }
               head.velocity_z += boost;

            }
            if ( (self.owner.classname == "monster_golem_bronze") ) {

               dir = normalize ( (self.owner.origin - head.origin));
               dir_z = 0.00000;
               head.velocity = (head.velocity + (dir * (((((random() * 50.00000) - 25.00000) / inertia) * richter) * dist)));
            } else {

               head.velocity_y += (((((random() * 50.00000) - 25.00000) / inertia) * richter) * dist);
               head.velocity_x += (((((random() * 50.00000) - 25.00000) / inertia) * richter) * dist);
               head.flags ^= FL_ONGROUND;

            }

         }
         if ( (self.lifetime < (time + 0.20000)) ) {

            if ( ((head.movetype != head.oldmovetype) && (head.movetype == MOVETYPE_BOUNCE)) ) {

               head.movetype = head.oldmovetype;

            }
            if ( ((head.classname != "player") && ((head.angles_x != 0.00000) || (head.angles_y != 0.00000))) ) {

               head.angles_x = 0.00000;
               head.angles_z = 0.00000;

            }

         }

      }
      head = head.chain;

   }
   if ( (self.lifetime > time) ) {

      self.think = ShakeRattleAndRoll;
   } else {

      self.think = SUB_Remove;

   }
   self.nextthink = (time + 0.10000);
};


void  (float richter)MonsterQuake =  {
   newmis = spawn ( );
   newmis.owner = self;
   newmis.solid = SOLID_NOT;
   newmis.movetype = MOVETYPE_NONE;
   newmis.classname = "quake";
   newmis.think = ShakeRattleAndRoll;
   newmis.nextthink = time;
   newmis.mass = fabs ( richter);
   newmis.lifetime = (time + 3.00000);
   setorigin ( newmis, self.origin);
   sound ( newmis, CHAN_AUTO, "weapons/explode.wav", 1.00000, ATTN_NORM);
   sound ( newmis, CHAN_AUTO, "fx/quake.wav", 1.00000, ATTN_NORM);
};

