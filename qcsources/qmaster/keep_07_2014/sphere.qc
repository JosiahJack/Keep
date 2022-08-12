
void () sphere_impact = {

   if ( other.health ) {

      T_Damage (other,self,self,1000.000);

   }
   T_RadiusDamage (self,self,300.000,other);
   self.origin = (self.origin - (FL_CLIENT * normalize (self.velocity)));
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_EXPLOSION);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   BecomeExplosion ();

};

void (entity ownerEntity) sphere_remove = {

   local entity theSphere;

   theSphere = find (world,classname,"Vengeance");
   while ( (theSphere != world) ) {

      if ( (theSphere.owner == self) ) {

         bprint (theSphere.owner.netname);
         bprint (" is denied Vengeance.\n");
         remove (theSphere);
         theSphere = find (world,classname,"Vengeance");

      } else {

         theSphere = find (theSphere,classname,"Vengeance");

      }

   }

};

void () sphere_attack = {

   self.solid = SOLID_TRIGGER;
   self.touch = sphere_impact;
   if ( (self.enemy.health < TRUE) ) {

      sprint (self.owner,"You are denied Vengeance");
      remove (self);
      return ;

   }
   ai_track (self.enemy,650.000);
   self.nextthink = (time + 0.100);
   self.think = sphere_attack;

};

void () sphere_think = {

   if ( (self.shieldSoundTime < time) ) {

      sound (self,CHAN_VOICE,"sphere/sphere.wav",TRUE,ATTN_NORM);
      self.shieldSoundTime = (time + MOVETYPE_STEP);

   }
   if ( (time > self.delay) ) {

      if ( (self.owner.items2 & IT2_V_SPHERE) ) {

         self.owner.items2 = (self.owner.items2 - IT2_V_SPHERE);

      }
      sprint (self.owner,"Vengeance Sphere Lost\n");
      remove (self);
      return ;

   }
   if ( (self.owner.health < TRUE) ) {

      if ( (self.owner.items2 & IT2_V_SPHERE) ) {

         self.owner.items2 = (self.owner.items2 - IT2_V_SPHERE);

      }
      if ( (self.owner.enemy.classname == "player") ) {

         self.enemy = self.owner.enemy;
         sphere_attack ();
         return ;

      }
      if ( (self.owner.enemy.owner.classname == "player") ) {

         self.enemy = self.owner.enemy.owner;
         sphere_attack ();
         return ;

      }
      remove (self);
      return ;

   }
   ai_orbit (self.owner,FL_INWATER,'0.000 0.000 48.000');
   self.think = sphere_think;
   self.nextthink = (time + 0.100);

};

void () sphere_spawn = {

   local entity missile;

   missile = spawn ();
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_NOT;
   missile.classname = "Vengeance";
   missile.owner = other;
   missile.weapon = FALSE;
   missile.delay = (time + SVC_INTERMISSION);
   setmodel (missile,"progs/sphere.mdl");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,self.origin);
   missile.avelocity = '40.000 40.000 40.000';
   missile.think = sphere_think;
   missile.nextthink = (time + 0.100);

};

void () item_sphere = {

   if ( !deathmatch ) {

      remove (self);
      return ;

   }
   precache_model ("progs/sphere.mdl");
   precache_sound ("sphere/sphere.wav");
   self.noise = "sphere/sphere.wav";
   self.netname = "Vengeance Sphere";
   self.touch = newitems_touch;
   setmodel (self,"progs/sphere.mdl");
   setsize (self,'-8.000 -8.000 -8.000','8.000 8.000 8.000');
   self.avelocity = '40.000 40.000 40.000';
   StartItem ();

};
