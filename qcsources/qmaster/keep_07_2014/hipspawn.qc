
void () spawn_think = {

   self.think = spawn_think;
   self.nextthink = (time + TRUE);

};

void () spawn_use = {

   local entity spawnentity;

   if ( ((self.spawnmulti == TRUE) || horn_active) ) {

      spawnentity = spawn ();
      SUB_CopyEntity (self.spawnmaster,spawnentity);

   } else {

      spawnentity = self.spawnmaster;

   }
   spawnentity.model = spawnentity.spawnmodel;
   spawnentity.solid = spawnentity.spawnsolidtype;
   spawnentity.think = spawnentity.spawnthink;
   setmodel (spawnentity,spawnentity.model);
   setorigin (spawnentity,spawnentity.origin);
   spawnentity.mins = spawnentity.spawnmins;
   spawnentity.maxs = spawnentity.spawnmaxs;
   setsize (spawnentity,spawnentity.mins,spawnentity.maxs);
   if ( (self.spawnsilent == FALSE) ) {

      spawn_tfog (spawnentity.origin);

   }
   if ( horn_active ) {

      spawnentity.charmer = horn_charmer;
      spawnentity.charmed = TRUE;

   }
   if ( (spawnentity.flags & FL_MONSTER) ) {

      if ( ((self.spawnmulti != FALSE) && (horn_active == FALSE)) ) {

         total_monsters = (total_monsters + TRUE);
         WriteByte (MSG_BROADCAST,SVC_UPDATESTAT);
         WriteByte (MSG_BROADCAST,STAT_TOTALMONSTERS);
         WriteLong (MSG_BROADCAST,total_monsters);

      }
      if ( horn_active ) {

         spawnentity.effects = (spawnentity.effects | EF_DIMLIGHT);

      }

   }
   if ( ((self.spawnmulti == FALSE) && (horn_active == FALSE)) ) {

      remove (self);

   }

};

void () func_spawn = {

   local entity tempself;
   local entity monster;
   local float tempdeathmatch;
   local float temptotal_monsters;
   local float spawnchance;

   tempself = self;
   tempdeathmatch = deathmatch;
   deathmatch = FALSE;
   if ( !self.spawnfunction ) {

      spawnchance = random ();
      monster = tempself;
      temptotal_monsters = total_monsters;
      self = spawn ();
      SUB_CopyEntity (tempself,self);
      self.spawnfunction = monster_dog;
      self.spawnclassname = "monster_dog";
      self.classname = self.spawnclassname;
      self.spawnfunction ();
      self.spawnmodel = self.model;
      self.spawnmins = self.mins;
      self.spawnmaxs = self.maxs;
      setmodel (self,"");
      setsize (self,self.spawnmins,self.spawnmaxs);
      self.spawnsolidtype = self.solid;
      self.solid = SOLID_NOT;
      self.spawnthink = self.think;
      self.think = spawn_think;
      self.nextthink = (time + TRUE);
      if ( ((spawnchance < 0.500) && (monster == tempself)) ) {

         monster = self;

      }
      self = spawn ();
      SUB_CopyEntity (tempself,self);
      self.spawnfunction = monster_ogre;
      self.spawnclassname = "monster_ogre";
      self.classname = self.spawnclassname;
      self.spawnfunction ();
      self.spawnmodel = self.model;
      self.spawnmins = self.mins;
      self.spawnmaxs = self.maxs;
      setmodel (self,"");
      setsize (self,self.spawnmins,self.spawnmaxs);
      self.spawnsolidtype = self.solid;
      self.solid = SOLID_NOT;
      self.spawnthink = self.think;
      self.think = spawn_think;
      self.nextthink = (time + TRUE);
      if ( ((spawnchance < 0.800) && (monster == tempself)) ) {

         monster = self;

      }
      self = spawn ();
      SUB_CopyEntity (tempself,self);
      self.spawnfunction = monster_demon1;
      self.spawnclassname = "monster_demon1";
      self.classname = self.spawnclassname;
      self.spawnfunction ();
      self.spawnmodel = self.model;
      self.spawnmins = self.mins;
      self.spawnmaxs = self.maxs;
      setmodel (self,"");
      setsize (self,self.spawnmins,self.spawnmaxs);
      self.spawnsolidtype = self.solid;
      self.solid = SOLID_NOT;
      self.spawnthink = self.think;
      self.think = spawn_think;
      self.nextthink = (time + TRUE);
      if ( ((spawnchance < 0.920) && (monster == tempself)) ) {

         monster = self;

      }
      self = spawn ();
      SUB_CopyEntity (tempself,self);
      self.spawnfunction = monster_zombie;
      self.spawnclassname = "monster_zombie";
      self.classname = self.spawnclassname;
      self.spawnfunction ();
      self.spawnmodel = self.model;
      self.spawnmins = self.mins;
      self.spawnmaxs = self.maxs;
      setmodel (self,"");
      setsize (self,self.spawnmins,self.spawnmaxs);
      self.spawnsolidtype = self.solid;
      self.solid = SOLID_NOT;
      self.spawnthink = self.think;
      self.think = spawn_think;
      self.nextthink = (time + TRUE);
      if ( ((spawnchance < 0.970) && (monster == tempself)) ) {

         monster = self;

      }
      self = spawn ();
      SUB_CopyEntity (tempself,self);
      self.spawnfunction = monster_shambler;
      self.spawnclassname = "monster_shambler";
      self.classname = self.spawnclassname;
      self.spawnfunction ();
      self.spawnmodel = self.model;
      self.spawnmins = self.mins;
      self.spawnmaxs = self.maxs;
      setmodel (self,"");
      setsize (self,self.spawnmins,self.spawnmaxs);
      self.spawnsolidtype = self.solid;
      self.solid = SOLID_NOT;
      self.spawnthink = self.think;
      self.think = spawn_think;
      self.nextthink = (time + TRUE);
      if ( (monster == tempself) ) {

         monster = self;

      }
      total_monsters = (temptotal_monsters + TRUE);

   } else {

      self = spawn ();
      SUB_CopyEntity (tempself,self);
      temptotal_monsters = total_monsters;
      if ( (self.spawnclassname == string_null) ) {

         objerror ("No spawnclassname defined");

      }
      self.classname = self.spawnclassname;
      self.spawnfunction ();
      if ( (self.spawnmulti != FALSE) ) {

         total_monsters = temptotal_monsters;

      }
      self.spawnmodel = self.model;
      self.spawnmins = self.mins;
      self.spawnmaxs = self.maxs;
      setmodel (self,"");
      self.model = "";
      setsize (self,self.spawnmins,self.spawnmaxs);
      self.spawnsolidtype = self.solid;
      self.solid = SOLID_NOT;
      self.spawnthink = self.think;
      self.think = spawn_think;
      self.nextthink = (time + TRUE);
      monster = self;

   }
   self = tempself;
   deathmatch = tempdeathmatch;
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_NONE;
   self.modelindex = FALSE;
   self.model = "";
   setmodel (self,self.model);
   self.use = spawn_use;
   self.spawnmaster = monster;

};

void () func_spawn_small = {

   func_spawn ();

};
