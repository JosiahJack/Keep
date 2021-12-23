void() monster_use;

void () decoy_stand1 = [ 17.000, decoy_stand1 ] {
	ChangeYaw ();
	if ( (self.walkframe >= 5) ) self.walkframe = 0;
	self.frame = (12 + self.walkframe);
	self.walkframe = (self.walkframe + TRUE);
	if ( (time > self.pausetime) ) self.th_walk ();
};

void(entity inflictor, entity attacker, float damage) decoy_pain = { decoy_stand1(); };

void () decoy_walk1 = [ 6.000, decoy_walk1 ] {
	local float r;

	movetogoal(12);
	self.weaponframe = 0;
	if (self.walkframe == 6) self.walkframe = 0;
	if ((self.walkframe == FL_SWIM) || (self.walkframe == 5)) {
		r = random ();
		if ( (r < 0.140) ) sound (self,CHAN_VOICE,"hipnotic/misc/foot1.wav",0.500,ATTN_NORM);
		else if ( (r < 0.290) ) sound (self,CHAN_VOICE,"hipnotic/misc/foot2.wav",0.500,ATTN_NORM);
		else if ( (r < 0.430) ) sound (self,CHAN_VOICE,"hipnotic/misc/foot3.wav",0.500,ATTN_NORM);
		else if ( (r < 0.580) ) sound (self,CHAN_VOICE,"hipnotic/misc/foot4.wav",0.500,ATTN_NORM);
		else if ( (r < 0.720) ) sound (self,CHAN_VOICE,"hipnotic/misc/foot5.wav",0.500,ATTN_NORM);
		else if ( (r < 0.860) ) sound (self,CHAN_VOICE,"hipnotic/misc/foot6.wav",0.500,ATTN_NORM);
		else sound (self,CHAN_VOICE,"hipnotic/misc/foot7.wav",0.500,ATTN_NORM);
	}

	self.frame = (self.frame + self.walkframe);
	self.walkframe = (self.walkframe + TRUE);
};

void() monster_decoy_go = {
   self.origin_z = (self.origin_z + TRUE);
   droptofloor();
   if ( !walkmove (FALSE,FALSE) ) {
      dprint ("decoy in wall at: ");
      dprint (vtos (self.origin));
      dprint ("\n");
   }
   self.takedamage = DAMAGE_AIM;
   self.ideal_yaw = (self.angles * '0.000 1.000 0.000');
   if (!self.yaw_speed) self.yaw_speed = 20.000;
   self.view_ofs = '0.000 0.000 25.000';
   self.use = monster_use;
   self.flags = (self.flags | FL_MONSTER);
   if (self.target) {
      self.movetarget = find (world,targetname,self.target);
      self.goalentity = find (world,targetname,self.target);
      self.ideal_yaw = vectoyaw ((self.goalentity.origin - self.origin));
      if ( !self.movetarget ) {
         dprint ("Monster can't find target at ");
         dprint (vtos (self.origin));
         dprint ("\n");
      }
      if ( (self.movetarget.classname == "path_corner") ) {
         self.th_walk ();
      } else {
         if ( (self.movetarget.classname == "path_corner_run") ) {
            self.th_run ();
         } else {
            self.pausetime = 100000000.000;
         }
      }
      self.th_stand ();
   } else {
      self.pausetime = 100000000.000;
      self.th_stand ();

   }
   self.nextthink = (self.nextthink + (random () * 0.500));
};

void (entity decoy) setup_decoy = {
   local entity pl;

   decoy.classname = "monster_decoy";
   setmodel (decoy,"progs/player.mdl");
   setsize (decoy,VEC_HULL_MIN,VEC_HULL_MAX);
   decoy.view_ofs = '0.000 0.000 22.000';
   decoy.solid = SOLID_SLIDEBOX;
   decoy.movetype = MOVETYPE_STEP;
   decoy.health = 3000000.000;
   decoy.th_stand = decoy_stand1;
   decoy.th_walk = decoy_walk1;
   decoy.th_run = decoy_walk1;
   decoy.th_missile = decoy_stand1;
   decoy.th_pain = decoy_pain;
   decoy.th_die = decoy_stand1;
   pl = find (world,classname,"player");
   decoy.colormap = pl.colormap; // TODO: Find random player in coop.
};

void() monster_decoy_precache = {
	precache_sound("hipnotic/misc/foot1.wav");
	precache_sound("hipnotic/misc/foot2.wav");
	precache_sound("hipnotic/misc/foot3.wav");
	precache_sound("hipnotic/misc/foot4.wav");
	precache_sound("hipnotic/misc/foot5.wav");
	precache_sound("hipnotic/misc/foot6.wav");
	precache_sound("hipnotic/misc/foot7.wav");
};

void () monster_decoy = {
	if ( deathmatch ) { remove(self); return; }

	setup_decoy(self);
	monster_decoy_go();
};

void (string targ, vector orig) become_decoy = {
	local entity decoy, temp;

	decoy = spawn();
	temp = self;
	self = decoy;
	setorigin(decoy,orig);
	decoy.origin = orig;
	decoy.target = targ;
	monster_decoy();
	self = temp;
};