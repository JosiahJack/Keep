
/////// clone monsters:
var float autocvar_clonemonsters = 0;		// set cvar 'clonemonsters' default to 0.  0= disabled   sets how many times monsters shall be cloned. "1" = will have 2 times as much monsters as original. "2" = will have 3 times as much monsters as original.  ...etc.
						// cvar settings for multiskin / multimodel feature is taken in account. Every cloned monster will make use of every available skin/model randomly.


////////////////////////////////////////////////
////////////////////////////////////////////////
//    for walking monsters 
////////////////////////////////////////////////

void() Clone =
{
   local entity clone, head;
   local float done, c, proceed;
   local vector ang, pos;

   done = 0;
   c = 0;
   ang = self.angles;
   while (done == 0)
      {
      makevectors(ang);
      pos = self.origin + (60 * v_forward) + (crandom() * 33 *v_right);		// randomize the spawn position !!
      head = findradius(pos, 35);
      proceed = 1;
      while (head)
         {
         if ((head.health > 0) && (head.flags & (FL_MONSTER | FL_CLIENT)))
            proceed = 0;
         head = head.chain;
         }
      traceline(self.origin,pos,FALSE,self);
      if (trace_fraction == 1 && (proceed == 1))
         {
         traceline(self.origin,(pos-'40 40 0'),FALSE,self);
         if (trace_fraction == 1)
            {
            traceline(self.origin,(pos+'40 40 0'),FALSE,self);
            if (trace_fraction == 1)
               {
               traceline(self.origin,(pos + '0 0 64'),FALSE,self);
               if (trace_fraction == 1)
                  {
                  traceline(self.origin,(pos - '0 0 64'),FALSE,self);
                  if (trace_fraction != 1)
                     {
                     traceline(pos,(pos - '0 0 64'),FALSE,self);
		     local vector checkforlavaslime;
		     checkforlavaslime = trace_endpos; 
		     if ((pointcontents(checkforlavaslime) != CONTENT_SLIME) && (pointcontents(checkforlavaslime) != CONTENT_LAVA))
			{
	                done = 1;
			}
                     }
                  }
               }
            }
         }
      if (done == 0)
         {
         ang_y = ang_y + 36;
         c = c + 1;
         if (c==10)
            {
            return;
            }
         }
      }
clone = spawn();
copyentity (self,clone);
total_monsters = total_monsters + 1;
setorigin(clone, pos);


// randomly transform skin and model of cloned monster, if multimodel/multiskin feature is used !

if (clone.monstermodel == 2)	//  = new/extended  dog and/or zombie model
	{
	if (clone.skin == 0)
		clone.skin = 1;
	else
		clone.skin = 0;
	return;
	}
		

local float zufall;
if (clone.multiskin == 1)		// multiskin = 1  means: use 2 different skins for (ID1) model
	{
	if (random() >= 0.5)
		clone.skin = 0;
	else 
		clone.skin = 1;
	}
else if (clone.multiskin == 2)		// multiskin = 2  means: use 2 models with 1 skin each
	{
	if (random() >= 0.5)		// use model 0 for clone
		{
		if (clone.monstermodel == 0)	// no need to change anything, clone uses already correct model
			return;
		else				// change to model 0, precache and set new models
			{
			if (clone.classname == "monster_demon1") 
				{
				setmodel (clone, "progs/demon.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_dog") 
				{
				setmodel (clone, "progs/dog.mdl");
				setsize (clone, '-32 -32 -24', '32 32 40');
				}
			else if (clone.classname == "monster_enforcer") 
				{
				setmodel (clone, "progs/enforcer.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_hell_knight") 
				{
				setmodel (clone, "progs/hknight.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_knight") 
				{
				setmodel (clone, "progs/knight.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_ogre") 
				{
				setmodel (clone, "progs/ogre.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_shalrath") 
				{
				setmodel (clone, "progs/shalrath.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_shambler") 
				{
				setmodel (clone, "progs/shambler.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_army") 
				{
				setmodel (clone, "progs/soldier.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_tarbaby") 
				{
				setmodel (clone, "progs/tarbaby.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_zombie") 
				{
				setmodel (clone, "progs/zombie.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_gremlin") 
				{
				setmodel (clone, "progs/grem.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_scourge") 
				{
				setmodel (clone, "progs/scor.mdl");
   				setsize (clone,VEC_HULL2_MIN,VEC_HULL2_MAX);
				}
			else
				return;			// unknown monster-type, better jump out of this function
			clone.monstermodel = 0;
			}
		}
	else 				// use model 1 for clone
		{
		if (clone.monstermodel == 1)	// no need to change anything, clone uses already correct model
			return;
		else				// change to model 1, precache and set new models
			{
			if (clone.classname == "monster_demon1") 
				{
				setmodel (clone, "progs/demon1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_dog") 
				{
				setmodel (clone, "progs/dog1.mdl");
				setsize (clone, '-32 -32 -24', '32 32 40');
				}
			else if (clone.classname == "monster_enforcer") 
				{
				setmodel (clone, "progs/enforcer1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_hell_knight") 
				{
				setmodel (clone, "progs/hknight1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_knight") 
				{
				setmodel (clone, "progs/knight1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_ogre") 
				{
				setmodel (clone, "progs/ogre1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_shalrath") 
				{
				setmodel (clone, "progs/shalrath1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_shambler") 
				{
				setmodel (clone, "progs/shambler1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_army") 
				{
				setmodel (clone, "progs/soldier1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_tarbaby") 
				{
				setmodel (clone, "progs/tarbaby1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_zombie") 
				{
				setmodel (clone, "progs/zombie1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_gremlin") 
				{
				setmodel (clone, "progs/grem1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_scourge") 
				{
				setmodel (clone, "progs/scor1.mdl");
   				setsize (clone,VEC_HULL2_MIN,VEC_HULL2_MAX);
				}
			else
				return;			// unknown monster-type, better jump out of this function
			clone.monstermodel = 1;
			}
		}
	}
else if (clone.multiskin == 3) 		// multiskin = 3  means: use 2 skins for model 0 and 1 skin for model 1
	{
	zufall = random();
	if (zufall > 0.66)		// use model 0 and skin 0 for clone
		{
		if ((clone.monstermodel == 0) && (clone.skin == 0))	// no need to change anything, clone uses already correct model and skin
			return;
		else if (clone.monstermodel == 0)			// model is correct already, only change skin
			{
			clone.skin = 0;
			return;
			}
		else				// change to model 0, precache and set new models
			{
			if (clone.classname == "monster_demon1") 
				{
				setmodel (clone, "progs/demon.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_dog") 
				{
				setmodel (clone, "progs/dog.mdl");
				setsize (clone, '-32 -32 -24', '32 32 40');
				}
			else if (clone.classname == "monster_enforcer") 
				{
				setmodel (clone, "progs/enforcer.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_hell_knight") 
				{
				setmodel (clone, "progs/hknight.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_knight") 
				{
				setmodel (clone, "progs/knight.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_ogre") 
				{
				setmodel (clone, "progs/ogre.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_shalrath") 
				{
				setmodel (clone, "progs/shalrath.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_shambler") 
				{
				setmodel (clone, "progs/shambler.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_army") 
				{
				setmodel (clone, "progs/soldier.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_tarbaby") 
				{
				setmodel (clone, "progs/tarbaby.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_zombie") 
				{
				setmodel (clone, "progs/zombie.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_gremlin") 
				{
				setmodel (clone, "progs/grem.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_scourge") 
				{
				setmodel (clone, "progs/scor.mdl");
   				setsize (clone,VEC_HULL2_MIN,VEC_HULL2_MAX);
				}
			else
				return;			// unknown monster-type, better jump out of this function
			clone.monstermodel = 0;
			}
		}
	else if (zufall < 0.34)		// use model 0 and skin 1 for clone
		{
		if ((clone.monstermodel == 0) && (clone.skin == 1))	// no need to change anything, clone uses already correct model and skin
			return;
		else if (clone.monstermodel == 0)			// model is correct already, only change skin
			{
			clone.skin = 1;
			return;
			}
		else				// change to model 0 + skin 1, precache and set new models
			{
			if (clone.classname == "monster_demon1") 
				{
				setmodel (clone, "progs/demon.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_dog") 
				{
				setmodel (clone, "progs/dog.mdl");
				setsize (clone, '-32 -32 -24', '32 32 40');
				}
			else if (clone.classname == "monster_enforcer") 
				{
				setmodel (clone, "progs/enforcer.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_hell_knight") 
				{
				setmodel (clone, "progs/hknight.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_knight") 
				{
				setmodel (clone, "progs/knight.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_ogre") 
				{
				setmodel (clone, "progs/ogre.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_shalrath") 
				{
				setmodel (clone, "progs/shalrath.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_shambler") 
				{
				setmodel (clone, "progs/shambler.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_army") 
				{
				setmodel (clone, "progs/soldier.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_tarbaby") 
				{
				setmodel (clone, "progs/tarbaby.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_zombie") 
				{
				setmodel (clone, "progs/zombie.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_gremlin") 
				{
				setmodel (clone, "progs/grem.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_scourge") 
				{
				setmodel (clone, "progs/scor.mdl");
   				setsize (clone,VEC_HULL2_MIN,VEC_HULL2_MAX);
				}
			else
				return;			// unknown monster-type, better jump out of this function
			clone.monstermodel = 0;
			clone.skin = 1;
			}
		}
	else				// use model 1 and skin 0 for clone
		{
		if ((clone.monstermodel == 1) && (clone.skin == 0))	// no need to change anything, clone uses already correct model and skin
			return;
		else				// change to model 1 + skin 0, precache and set new models
			{
			if (clone.classname == "monster_demon1") 
				{
				setmodel (clone, "progs/demon1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_dog") 
				{
				setmodel (clone, "progs/dog1.mdl");
				setsize (clone, '-32 -32 -24', '32 32 40');
				}
			else if (clone.classname == "monster_enforcer") 
				{
				setmodel (clone, "progs/enforcer1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_hell_knight") 
				{
				setmodel (clone, "progs/hknight1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_knight") 
				{
				setmodel (clone, "progs/knight1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_ogre") 
				{
				setmodel (clone, "progs/ogre1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_shalrath") 
				{
				setmodel (clone, "progs/shalrath1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_shambler") 
				{
				setmodel (clone, "progs/shambler1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_army") 
				{
				setmodel (clone, "progs/soldier1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_tarbaby") 
				{
				setmodel (clone, "progs/tarbaby1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_zombie") 
				{
				setmodel (clone, "progs/zombie1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_gremlin") 
				{
				setmodel (clone, "progs/grem1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_scourge") 
				{
				setmodel (clone, "progs/scor1.mdl");
   				setsize (clone,VEC_HULL2_MIN,VEC_HULL2_MAX);
				}
			else
				return;			// unknown monster-type, better jump out of this function
			clone.monstermodel = 1;
			clone.skin = 0;
			}
		}
	}
else if (clone.multiskin == 4)			// multiskin = 4  means: use 2 models with 2 skins each
	{
	zufall = random();
	if (zufall > 0.75)			// use model 0 and skin 0 for clone
		{
		if ((clone.monstermodel == 0) && (clone.skin == 0))	// no need to change anything, clone uses already correct model and skin
			return;
		else if (clone.monstermodel == 0)			// model is correct already, only change skin
			{
			clone.skin = 0;
			return;
			}
		else				// change to model 0 + skin 0, precache and set new models
			{
			if (clone.classname == "monster_demon1") 
				{
				setmodel (clone, "progs/demon.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_dog") 
				{
				setmodel (clone, "progs/dog.mdl");
				setsize (clone, '-32 -32 -24', '32 32 40');
				}
			else if (clone.classname == "monster_enforcer") 
				{
				setmodel (clone, "progs/enforcer.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_hell_knight") 
				{
				setmodel (clone, "progs/hknight.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_knight") 
				{
				setmodel (clone, "progs/knight.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_ogre") 
				{
				setmodel (clone, "progs/ogre.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_shalrath") 
				{
				setmodel (clone, "progs/shalrath.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_shambler") 
				{
				setmodel (clone, "progs/shambler.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_army") 
				{
				setmodel (clone, "progs/soldier.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_tarbaby") 
				{
				setmodel (clone, "progs/tarbaby.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_zombie") 
				{
				setmodel (clone, "progs/zombie.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_gremlin") 
				{
				setmodel (clone, "progs/grem.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_scourge") 
				{
				setmodel (clone, "progs/scor.mdl");
   				setsize (clone,VEC_HULL2_MIN,VEC_HULL2_MAX);
				}
			else
				return;			// unknown monster-type, better jump out of this function
			clone.monstermodel = 0;
			clone.skin = 0;
			}
		}
	else if (zufall > 0.5 && zufall <= 0.75)	// use model 0 and skin 1 for clone
		{
		if ((clone.monstermodel == 0) && (clone.skin == 1))	// no need to change anything, clone uses already correct model and skin
			return;
		else if (clone.monstermodel == 0)			// model is correct already, only change skin
			{
			clone.skin = 1;
			return;
			}
		else				// change to model 0 + skin 1, precache and set new models
			{
			if (clone.classname == "monster_demon1") 
				{
				setmodel (clone, "progs/demon.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_dog") 
				{
				setmodel (clone, "progs/dog.mdl");
				setsize (clone, '-32 -32 -24', '32 32 40');
				}
			else if (clone.classname == "monster_enforcer") 
				{
				setmodel (clone, "progs/enforcer.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_hell_knight") 
				{
				setmodel (clone, "progs/hknight.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_knight") 
				{
				setmodel (clone, "progs/knight.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_ogre") 
				{
				setmodel (clone, "progs/ogre.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_shalrath") 
				{
				setmodel (clone, "progs/shalrath.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_shambler") 
				{
				setmodel (clone, "progs/shambler.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_army") 
				{
				setmodel (clone, "progs/soldier.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_tarbaby") 
				{
				setmodel (clone, "progs/tarbaby.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_zombie") 
				{
				setmodel (clone, "progs/zombie.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_gremlin") 
				{
				setmodel (clone, "progs/grem.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_scourge") 
				{
				setmodel (clone, "progs/scor.mdl");
   				setsize (clone,VEC_HULL2_MIN,VEC_HULL2_MAX);
				}
			else
				return;			// unknown monster-type, better jump out of this function
			clone.monstermodel = 0;
			clone.skin = 1;
			}
		}
	else if (zufall > 0.25 && zufall <= 0.5)	// use model 1 and skin 0 for clone
		{
		if ((clone.monstermodel == 1) && (clone.skin == 0))	// no need to change anything, clone uses already correct model and skin
			return;
		else if (clone.monstermodel == 1)			// model is correct already, only change skin
			{
			clone.skin = 0;
			return;
			}
		else				// change to model 1 + skin 0, precache and set new models
			{
			if (clone.classname == "monster_demon1") 
				{
				setmodel (clone, "progs/demon1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_dog") 
				{
				setmodel (clone, "progs/dog1.mdl");
				setsize (clone, '-32 -32 -24', '32 32 40');
				}
			else if (clone.classname == "monster_enforcer") 
				{
				setmodel (clone, "progs/enforcer1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_hell_knight") 
				{
				setmodel (clone, "progs/hknight1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_knight") 
				{
				setmodel (clone, "progs/knight1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_ogre") 
				{
				setmodel (clone, "progs/ogre1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_shalrath") 
				{
				setmodel (clone, "progs/shalrath1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_shambler") 
				{
				setmodel (clone, "progs/shambler1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_army") 
				{
				setmodel (clone, "progs/soldier1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_tarbaby") 
				{
				setmodel (clone, "progs/tarbaby1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_zombie") 
				{
				setmodel (clone, "progs/zombie1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_gremlin") 
				{
				setmodel (clone, "progs/grem1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_scourge") 
				{
				setmodel (clone, "progs/scor1.mdl");
   				setsize (clone,VEC_HULL2_MIN,VEC_HULL2_MAX);
				}
			else
				return;			// unknown monster-type, better jump out of this function
			clone.monstermodel = 1;
			clone.skin = 0;
			}
		}
	else 						// use model 1 and skin 1 for clone
		{
		if ((clone.monstermodel == 1) && (clone.skin == 1))	// no need to change anything, clone uses already correct model and skin
			return;
		else if (clone.monstermodel == 1)			// model is correct already, only change skin
			{
			clone.skin = 1;
			return;
			}
		else				// change to model 1 + skin 1, precache and set new models
			{
			if (clone.classname == "monster_demon1") 
				{
				setmodel (clone, "progs/demon1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_dog") 
				{
				setmodel (clone, "progs/dog1.mdl");
				setsize (clone, '-32 -32 -24', '32 32 40');
				}
			else if (clone.classname == "monster_enforcer") 
				{
				setmodel (clone, "progs/enforcer1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_hell_knight") 
				{
				setmodel (clone, "progs/hknight1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_knight") 
				{
				setmodel (clone, "progs/knight1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_ogre") 
				{
				setmodel (clone, "progs/ogre1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_shalrath") 
				{
				setmodel (clone, "progs/shalrath1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_shambler") 
				{
				setmodel (clone, "progs/shambler1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_army") 
				{
				setmodel (clone, "progs/soldier1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_tarbaby") 
				{
				setmodel (clone, "progs/tarbaby1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_zombie") 
				{
				setmodel (clone, "progs/zombie1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "monster_gremlin") 
				{
				setmodel (clone, "progs/grem1.mdl");
				setsize (clone, VEC_HULL2_MIN, VEC_HULL2_MAX);
				}
			else if (clone.classname == "monster_scourge") 
				{
				setmodel (clone, "progs/scor1.mdl");
   				setsize (clone,VEC_HULL2_MIN,VEC_HULL2_MAX);
				}
			else
				return;			// unknown monster-type, better jump out of this function
			clone.monstermodel = 1;
			clone.skin = 1;
			}
		}
	}
else						// no multiskin used !
		{
		// clone is identical to original
		}
};


void() do_the_cloning =
{
if (autocvar_clonemonsters <= self.clone_me)
	return;
else
	Clone(); 

self.clone_me = self.clone_me + 1;
do_the_cloning();
};




////////////////////////////////////////////////
////////////////////////////////////////////////
//    for flying or swimming monsters 
////////////////////////////////////////////////

void() Clone_fly_swim =
{
   local entity clone, head;
   local float done, c, proceed;
   local vector ang, pos;

   done = 0;
   c = 0;
   ang = self.angles;
   while (done == 0)
      {
      makevectors(ang);
      pos = self.origin + (60 * v_forward) + (crandom() * 33 *v_right) + (crandom() * 25 *v_up);	// randomize the spawn position !!
      head = findradius(pos, 35);
      proceed = 1;
      while (head)
         {
         if ((head.health > 0) && (head.flags & (FL_MONSTER | FL_CLIENT)))
            proceed = 0;
         head = head.chain;
         }
      traceline(self.origin,pos,FALSE,self);
      if (trace_fraction == 1 && (proceed == 1))
         {
         traceline(self.origin,(pos-'40 40 0'),FALSE,self);
         if (trace_fraction == 1)
            {
            traceline(self.origin,(pos+'40 40 0'),FALSE,self);
            if (trace_fraction == 1)
               {
                  done = 1;
               }
            }
         }
      if (done == 0)
         {
         ang_y = ang_y + 36;
         c = c + 1;
         if (c==10)
            {
            return;
            }
         }
      }
clone = spawn();
copyentity (self,clone);
total_monsters = total_monsters + 1;
setorigin(clone, pos);

// randomly transform skin and model of cloned monster, if multimodel/multiskin feature is used !

local float zufall;
if (clone.multiskin == 1)		// multiskin = 1  means: use 2 different skins for (ID1) model
	{
	if (random() >= 0.5)
		clone.skin = 0;
	else 
		clone.skin = 1;
	}
else if (clone.multiskin == 2)		// multiskin = 2  means: use 2 models with 1 skin each
	{
	if (random() >= 0.5)		// use model 0 for clone
		{
		if (clone.monstermodel == 0)	// no need to change anything, clone uses already correct model
			return;
		else				// change to model 0, precache and set new models
			{
			if (clone.classname == "monster_fish") 
				{
				setmodel (clone, "progs/fish.mdl");
				setsize (clone, '-16 -16 -24', '16 16 24');
				}
			else if (clone.classname == "monster_wizard") 
				{
				setmodel (clone, "progs/wizard.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "trap_spike_mine") 
				{
				setmodel (clone, "progs/spikmine.mdl");
				setsize (clone, clone.mins, clone.maxs);
				}
			else
				return;			// unknown monster-type, better jump out of this function
			clone.monstermodel = 0;
			}
		}
	else 				// use model 1 for clone
		{
		if (clone.monstermodel == 1)	// no need to change anything, clone uses already correct model
			return;
		else				// change to model 1, precache and set new models
			{
			if (clone.classname == "monster_fish") 
				{
				setmodel (clone, "progs/fish1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 24');
				}
			else if (clone.classname == "monster_wizard") 
				{
				setmodel (clone, "progs/wizard1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "trap_spike_mine") 
				{
				setmodel (clone, "progs/spikmine1.mdl");
				setsize (clone, clone.mins, clone.maxs);
				}
			else
				return;			// unknown monster-type, better jump out of this function
			clone.monstermodel = 1;
			}
		}
	}
else if (clone.multiskin == 3) 		// multiskin = 3  means: use 2 skins for model 0 and 1 skin for model 1
	{
	zufall = random();
	if (zufall > 0.66)		// use model 0 and skin 0 for clone
		{
		if ((clone.monstermodel == 0) && (clone.skin == 0))	// no need to change anything, clone uses already correct model and skin
			return;
		else if (clone.monstermodel == 0)			// model is correct already, only change skin
			{
			clone.skin = 0;
			return;
			}
		else				// change to model 0, precache and set new models
			{
			if (clone.classname == "monster_fish") 
				{
				setmodel (clone, "progs/fish.mdl");
				setsize (clone, '-16 -16 -24', '16 16 24');
				}
			else if (clone.classname == "monster_wizard") 
				{
				setmodel (clone, "progs/wizard.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "trap_spike_mine") 
				{
				setmodel (clone, "progs/spikmine.mdl");
				setsize (clone, clone.mins, clone.maxs);
				}
			else
				return;			// unknown monster-type, better jump out of this function
			clone.monstermodel = 0;
			}
		}
	else if (zufall < 0.34)		// use model 0 and skin 1 for clone
		{
		if ((clone.monstermodel == 0) && (clone.skin == 1))	// no need to change anything, clone uses already correct model and skin
			return;
		else if (clone.monstermodel == 0)			// model is correct already, only change skin
			{
			clone.skin = 1;
			return;
			}
		else				// change to model 0 + skin 1, precache and set new models
			{
			if (clone.classname == "monster_fish") 
				{
				setmodel (clone, "progs/fish.mdl");
				setsize (clone, '-16 -16 -24', '16 16 24');
				}
			else if (clone.classname == "monster_wizard") 
				{
				setmodel (clone, "progs/wizard.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "trap_spike_mine") 
				{
				setmodel (clone, "progs/spikmine.mdl");
				setsize (clone, clone.mins, clone.maxs);
				}
			else
				return;			// unknown monster-type, better jump out of this function
			clone.monstermodel = 0;
			clone.skin = 1;
			}
		}
	else				// use model 1 and skin 0 for clone
		{
		if ((clone.monstermodel == 1) && (clone.skin == 0))	// no need to change anything, clone uses already correct model and skin
			return;
		else				// change to model 1 + skin 0, precache and set new models
			{
			if (clone.classname == "monster_fish") 
				{
				setmodel (clone, "progs/fish1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 24');
				}
			else if (clone.classname == "monster_wizard") 
				{
				setmodel (clone, "progs/wizard1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "trap_spike_mine") 
				{
				setmodel (clone, "progs/spikmine1.mdl");
				setsize (clone, clone.mins, clone.maxs);
				}
			else
				return;			// unknown monster-type, better jump out of this function
			clone.monstermodel = 1;
			clone.skin = 0;
			}
		}
	}
else if (clone.multiskin == 4)			// multiskin = 4  means: use 2 models with 2 skins each
	{
	zufall = random();
	if (zufall > 0.75)			// use model 0 and skin 0 for clone
		{
		if ((clone.monstermodel == 0) && (clone.skin == 0))	// no need to change anything, clone uses already correct model and skin
			return;
		else if (clone.monstermodel == 0)			// model is correct already, only change skin
			{
			clone.skin = 0;
			return;
			}
		else				// change to model 0 + skin 0, precache and set new models
			{
			if (clone.classname == "monster_fish") 
				{
				setmodel (clone, "progs/fish.mdl");
				setsize (clone, '-16 -16 -24', '16 16 24');
				}
			else if (clone.classname == "monster_wizard") 
				{
				setmodel (clone, "progs/wizard.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "trap_spike_mine") 
				{
				setmodel (clone, "progs/spikmine.mdl");
				setsize (clone, clone.mins, clone.maxs);
				}
			else
				return;			// unknown monster-type, better jump out of this function
			clone.monstermodel = 0;
			clone.skin = 0;
			}
		}
	else if (zufall > 0.5 && zufall <= 0.75)	// use model 0 and skin 1 for clone
		{
		if ((clone.monstermodel == 0) && (clone.skin == 1))	// no need to change anything, clone uses already correct model and skin
			return;
		else if (clone.monstermodel == 0)			// model is correct already, only change skin
			{
			clone.skin = 1;
			return;
			}
		else				// change to model 0 + skin 1, precache and set new models
			{
			if (clone.classname == "monster_fish") 
				{
				setmodel (clone, "progs/fish.mdl");
				setsize (clone, '-16 -16 -24', '16 16 24');
				}
			else if (clone.classname == "monster_wizard") 
				{
				setmodel (clone, "progs/wizard.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "trap_spike_mine") 
				{
				setmodel (clone, "progs/spikmine.mdl");
				setsize (clone, clone.mins, clone.maxs);
				}
			else
				return;			// unknown monster-type, better jump out of this function
			clone.monstermodel = 0;
			clone.skin = 1;
			}
		}
	else if (zufall > 0.25 && zufall <= 0.5)	// use model 1 and skin 0 for clone
		{
		if ((clone.monstermodel == 1) && (clone.skin == 0))	// no need to change anything, clone uses already correct model and skin
			return;
		else if (clone.monstermodel == 1)			// model is correct already, only change skin
			{
			clone.skin = 0;
			return;
			}
		else				// change to model 1 + skin 0, precache and set new models
			{
			if (clone.classname == "monster_fish") 
				{
				setmodel (clone, "progs/fish1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 24');
				}
			else if (clone.classname == "monster_wizard") 
				{
				setmodel (clone, "progs/wizard1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "trap_spike_mine") 
				{
				setmodel (clone, "progs/spikmine1.mdl");
				setsize (clone, clone.mins, clone.maxs);
				}
			else
				return;			// unknown monster-type, better jump out of this function
			clone.monstermodel = 1;
			clone.skin = 0;
			}
		}
	else 						// use model 1 and skin 1 for clone
		{
		if ((clone.monstermodel == 1) && (clone.skin == 1))	// no need to change anything, clone uses already correct model and skin
			return;
		else if (clone.monstermodel == 1)			// model is correct already, only change skin
			{
			clone.skin = 1;
			return;
			}
		else				// change to model 1 + skin 1, precache and set new models
			{
			if (clone.classname == "monster_fish") 
				{
				setmodel (clone, "progs/fish1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 24');
				}
			else if (clone.classname == "monster_wizard") 
				{
				setmodel (clone, "progs/wizard1.mdl");
				setsize (clone, '-16 -16 -24', '16 16 40');
				}
			else if (clone.classname == "trap_spike_mine") 
				{
				setmodel (clone, "progs/spikmine1.mdl");
				setsize (clone, clone.mins, clone.maxs);
				}
			else
				return;			// unknown monster-type, better jump out of this function
			clone.monstermodel = 1;
			clone.skin = 1;
			}
		}
	}
else						// no multiskin used !
		{
		// clone is identical to original
		}
};


void() do_the_cloning__fly_swim =		// for flying and swimming monsters
{
if (autocvar_clonemonsters <= self.clone_me)
	return;
else
	Clone_fly_swim(); 

self.clone_me = self.clone_me + 1;
do_the_cloning__fly_swim ();
};

