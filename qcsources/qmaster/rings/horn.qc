
entity () random_powerup = {

   local float randItem;
   local entity newPowerup;

   randItem = random ();
   newPowerup = spawn();
   if ( (randItem < 0.500) && (randItem > FALSE) ) {

      newPowerup.classname = "item_powerup_shield";
      newPowerup.touch = powerup_touch;
      newPowerup.noise = "shield/pickup.wav";
      setmodel (newPowerup,"progs/shield.mdl");
      newPowerup.netname = "Impact Shield";
      newPowerup.items = IT2_SHIELD;
      newPowerup.items2 = FALSE;

   } else {

      if ( (randItem < 0.600) && (randItem > 0.500) ) {

         newPowerup.classname = "item_powerup_belt";
         newPowerup.touch = powerup_touch;
         newPowerup.noise = "belt/pickup.wav";
         setmodel (newPowerup,"progs/beltup.mdl");
         newPowerup.netname = "Anti-Grav Belt";
         newPowerup.items = IT2_ANTIGRAV;
         newPowerup.items2 = FALSE;

      } else {

         if ( (randItem < 0.700) && (randItem > 0.600) ) {

            newPowerup.classname = "item_artifact_invulnerability";
            newPowerup.touch = powerup_touch;
            newPowerup.noise = "items/protect.wav";
            setmodel (newPowerup,"progs/invulner.mdl");
            newPowerup.netname = "Star-Circle!";
            newPowerup.items = IT_INVULNERABILITY;
            newPowerup.items2 = FALSE;

         } else {

            if ( (randItem < 0.750) && (randItem > 0.700) ) {

               newPowerup.classname = ("item_artifact_envirosuit");
               newPowerup.touch = powerup_touch;
               newPowerup.noise = "items/suit.wav";
               setmodel (newPowerup,"progs/suit.mdl");
               newPowerup.netname = "Biosuit";
               newPowerup.items = IT_SUIT;
               newPowerup.items2 = FALSE;

            } else {

               if ( (randItem < 0.800) && (randItem > 0.750) ) {

                  newPowerup.classname = ("item_artifact_lavasuit");
                  newPowerup.touch = powerup_touch;
                  newPowerup.noise = "items/suit.wav";
                  setmodel (newPowerup,"progs/suit.mdl");
                  newPowerup.skin = TRUE;
                  newPowerup.netname = "Thermal Protection Suit";
                  newPowerup.items = IT_LIGHTNING;
                  newPowerup.items2 = FALSE;

               } else {

                  if ( (randItem < 0.850) && (randItem > 0.800) ) {

                     newPowerup.classname = ("item_artifact_wetsuit");
                     newPowerup.touch = powerup_touch;
                     newPowerup.noise = "misc/weton.wav";
                     setmodel (newPowerup,"progs/wetsuit.mdl");
                     newPowerup.netname = "Wetsuit";
                     newPowerup.items = HIP_IT_WETSUIT;
                     newPowerup.items2 = FALSE;

                  } else {

                     if ( (randItem < 0.900) && (randItem > 0.850) ) {

                        newPowerup.classname = ("item_artifact_empathy_shields");
                        newPowerup.touch = powerup_touch;
                        setmodel (newPowerup,"progs/empathy.mdl");
                        newPowerup.noise = "hipitems/empathy.wav";
                        newPowerup.netname = "Empathy Shield";
                        newPowerup.items = HIP_IT_EMPATHY_SHIELDS;
                        newPowerup.items2 = FALSE;

                     } else {

                        if ( (randItem < 0.975) && (randItem > 0.900) ) {

                           newPowerup.classname = ("item_backpack");
                           newPowerup.touch = battery_ammo_touch;
                           setmodel (newPowerup,"progs/backpack.mdl");
                           newPowerup.noise = "weapons/lock4.wav";
                           newPowerup.netname = "Backpack full of battery cells";
                           newPowerup.aflag = rnd_backpack_ammo ();

                        } else {

                           newPowerup.classname = ("item_artifact_super_damage");
                           newPowerup.touch = powerup_touch;
                           newPowerup.noise = "items/damage.wav";
                           setmodel (newPowerup,"progs/quaddama.mdl");
                           newPowerup.netname = "Quad Speed";
                           newPowerup.items = IT_QUAD;
                           newPowerup.items2 = FALSE;

                        }

                     }

                  }

               }

            }

         }

      }

   }
   setsize (newPowerup,VEC_HULL_MIN,VEC_HULL_MAX);
   newPowerup.mdl = newPowerup.model;
   newPowerup.flags = FL_ITEM;
   newPowerup.solid = SOLID_TRIGGER;
   newPowerup.movetype = MOVETYPE_TOSS;
   newPowerup.velocity = VEC_ORIGIN;
   return (newPowerup);

};
float (entity thePoint) isSpawnPointEmpty = {

   local entity neighbors;
   local entity start;

   neighbors = findradius (thePoint.origin,FL_GODMODE);
   if ( (neighbors == world) ) {

      return ( TRUE );

   }
   start = neighbors;
   while ( neighbors ) {

      if ( (neighbors != thePoint) ) {

         if ( (neighbors.flags & FL_MONSTER) ) {

            return ( FALSE );

         } else {

            if ( (neighbors.classname == "player") ) {

               return ( FALSE );

            } else {

               if ( neighbors.think ) {

                  return ( FALSE );

               }

            }

         }

      }
      neighbors = neighbors.chain;
      if ( (neighbors == start) ) {

         return ( TRUE );

      }

   }
   return ( TRUE );

};
entity () horn_find_dest3 = {

   local entity furthestDest;
   local entity bestDest;
   local entity curDest;
   local entity thePlayer;
   local float theDist;
   local float curDist;
   local float dot;
   local vector curVector;

   furthestDest = world;
   bestDest = world;
   theDist = FALSE;
   thePlayer = find (world,classname,"player");
   curDest = world;
   makevectors (thePlayer.angles);
   while ( TRUE ) {

      curDest = find (curDest,classname,"info_horn_destination");
      if ( (curDest == world) ) {

         if ( (bestDest != world) ) {

            return ( bestDest );

         }
         return ( furthestDest );

      }
      if ( isSpawnPointEmpty (curDest) ) {

         curVector = (curDest.origin - thePlayer.origin);
         curDist = vlen (curVector);
         curVector = normalize (curVector);
         dot = (curVector * v_forward);
         if ( (dot > 0.600) ) {

            if ( (curDist > 150.000) ) {

               bestDest = curDest;

            }

         }
         if ( (curDist > theDist) ) {

            furthestDest = curDest;
            theDist = curDist;

         }

      }

   }
   return ( world );

};
entity () horn_find_dest = {

   local entity curDest;
   local entity lastDest;
   local float loopCount;

   curDest = find (world,classname,"info_horn_destination");
   if ( (curDest != world) ) {

      lastDest = curDest;
      loopCount = (random () * MOVETYPE_FLY);
      while ( (loopCount > TRUE) ) {

         curDest = nextent (curDest);
         curDest = find (curDest,classname,"info_horn_destination");
         if ( (curDest != world) ) {

            if ( isSpawnPointEmpty (curDest) ) {

               loopCount = (loopCount - TRUE);
               lastDest = curDest;

            } else {

               curDest = world;

            }

         } else {

            return ( lastDest );

         }

      }
      return ( curDest );

   }
   return ( curDest );

};

void () horn_teleport = {

   local entity tempent;
   local entity powerup;
   local entity theDest;
   local vector org;

   theDest = horn_find_dest3 ();
   powerup = random_powerup ();
   makevectors (powerup.angles);
   org = (theDest.origin + (FL_MONSTER * v_forward));
   spawn_tfog (org);
   setorigin (powerup,theDest.origin);
   tempent = self;
   self = powerup;
   StartItemFloating ();

};

void () info_horn_destination = {

   self.mangle = self.angles;
   self.angles = VEC_ORIGIN;
   self.model = "";

};