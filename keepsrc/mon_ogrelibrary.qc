void() oglib_walk;

/*void() monster_library_precache = {
  precache_model2("progs/nehahra/library.mdl");
  precache_model2("progs/nehahra/archg.mdl");
  precache_model2("progs/nehahra/h_archg.mdl");
  precache_model2("progs/nehahra/gntspke.mdl");
  precache_model2("progs/nehahra/rubble1.mdl");
  precache_model2("progs/nehahra/rubble2.mdl");
  precache_model2("progs/nehahra/rubble3.mdl");
  precache_model2("progs/nehahra/rubble4.mdl");
  precache_model2("progs/nehahra/rubble5.mdl");
  precache_model2("progs/nehahra/rubble6.mdl");
  precache_model2("progs/nehahra/gring.mdl");
  precache_sound2("boss3/nehahra/nehdie4.wav");
  precache_sound2("nehahra/archg/mykey.wav");
  precache_sound2("nehahra/gaunt/gspike.wav");
  precache_sound2("nehahra/gaunt/spkhit.wav");
  precache_sound2("nehahra/archg/shsh.wav");
  precache_sound2("nehahra/archg/fire2.wav");
};

void() monster_library = {
  if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
  if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

  self.mdl = "progs/library.mdl";
  self.headmdl = "progs/nehahra/h_archg.mdl";
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  self.solid = SOLID_NOT;				// No interaction with world
  self.movetype = MOVETYPE_NONE;		// Static item, no movement
  if (self.bboxtype < 1) self.bboxtype = BBOX_SHORT;
  self.gibbed = FALSE;
  self.pain_flinch = 40;
  if (self.health <= 0) self.health = 666;
  self.cnt = 0;
  self.th_stand = library_read_r;
  self.th_walk = library_read_r;
  self.th_run = library_2mad;
  self.th_pain = library_pain;
  self.th_die = library_pain;
  self.th_wins = library_hmm;
  self.th_greet = library_shush;
  self.th_special = library_watch;
	if (self.deathstring == "")  self.deathstring = " was turned over by a librarian\n";
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	SetDefaultDenizenAttributes(self); // Standard DENIZEN AI
	self.classtype = CT_MONLIBRARIAN;
	self.classgroup = CG_HARMLESS;
	self.classmove = MON_MOVEWALK;
  monster_start();
};

void() library_2archg = {
  setmodel(self, "progs/archg.mdl");
  setsize(self, VEC_HULL_MIN, [12 12 48]);
  ThrowGib("progs/book.mdl", -40);
  self.objekt = world;
  self.goalentity = world;
  self.th_stand = archg_stand;
  self.th_walk = archg_motion;
  self.th_run = archg_motion;
  self.th_missile = archg_control;
  self.th_pain = archg_pain;
  self.th_die = archg_die;
  self.th_wins = archg_bow1;
  self.th_greet = archg_bow1;
}

void() library_pain = {
  if (self.health < 1) {
    self.health = 1;
    self.takedamage = DAMAGE_AIM;
    self.solid = SOLID_SLIDEBOX;
    }
  library_2archg();
  self.th_pain();
  exit;
}

void()  library_2mad = {
  library_2archg();
  self.th_run();
  exit;
}

void()  library_read_r = {
  if (self.walkframe >= 24) {
    self.walkframe = 0;
    library_flippage();
    library_think();
    exit;
    }
  #0 library_read_r;
  self.frame = 0 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_library();
}

void()  library_flippage = {
  if (self.walkframe >= 13) {
    self.walkframe = 0;
    library_flippage2();
    exit;
    }
  #58 library_flippage;
  self.frame = 58 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_library();
}

void()  library_flippage2 = {
{
  if (self.walkframe >= 6) {
    self.walkframe = 0;
    library_rtl();
    library_think();
    exit;
    }
  #58 library_flippage2;
  self.frame = 63 - self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_library();
}

void()  library_rtl = {
{
  if (self.walkframe >= 11) {
    self.walkframe = 0;
    library_read_l();
    library_think();
    exit;
    }
  #24 library_rtl;
  self.frame = 24 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_library();
}

void()  library_read_l = {
{
  if (self.walkframe >= 23) {
    self.walkframe = 0;
    library_ltr();       
    library_think();
    exit;
    }
  #35 library_read_l;
  self.frame = 35 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_library();
}

void()  library_ltr = {
{
  if (self.walkframe >= 11) {
    self.walkframe = 0;
    library_read_r();
    library_think();
    exit;
    }
  #24 library_ltr;
  self.frame = 34 - self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_library();
}

void()  library_hmm = {
{
  self.walkframe = 0;
  self.cnt = 1;
  library_lookup();
}

void()  library_shush = {
{
  self.walkframe = 0;
  self.cnt = 2;
  self.th_greet = Sub_Null;
  library_lookup();
}

void()  library_lookup = {
{
  if (self.walkframe >= 7) {
    self.walkframe = 0;
    if (self.cnt == 1) {
      library_watch();
      exit;
      }
    if (self.cnt == 2) {
      library_shsh();
      exit;
      }
    library_lookdown();
    exit;
    }
  #71 library_lookup;
  self.frame = 71 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  if (self.objekt && self.cnt > 0) {
    ai_face_objekt();
    }
  ai_library();
}

void()  library_lookdown = {
{
  if (self.walkframe >= 7) {
    self.walkframe = 0;
    self.cnt = 0;
    library_read_r();
    exit;
    }
  #71 library_lookdown;
  self.frame = 77 - self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_library();
}

void()  library_shsh = {
{
  if (self.walkframe >= 14) {
    self.walkframe = 0;
    library_shsh2();
    exit;
    }
  #71 library_shsh;
  self.frame = 78 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  if (self.objekt) {
    ai_face_objekt();
    }
  if (self.walkframe == 10) {
    sound(self, CHAN_VOICE, "archg/shsh.wav", 1, ATTN_NORM);
    }
  ai_library();
}


void()  library_shsh2 = {
{
  if (self.walkframe >= 14) {
    self.walkframe = 0;
    self.cnt = 0;
    library_lookdown();
    exit;
    }
  #71 library_shsh2;
  self.frame = 91 - self.walkframe;
  self.walkframe = self.walkframe + 1;
  if (self.objekt) {
    ai_face_objekt();
    }
  ai_library();
}

void()  library_watch = {
{
  if (self.walkframe >= 9) {
    if (self.cnt == 666) {
      self.enemy = self.objekt;
      self.objekt = world;
      library_pain();
      exit;
      }
    self.walkframe = 0;
    self.cnt = 0;
    library_lookdown();
    exit;
    }
  #92 library_watch;
  self.frame = 92 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  if (self.walkframe == 2 && self.cnt == 666) {
    library_itemmad();
    }
  if (self.cnt == 666) {
    exit;
    }
  if (self.objekt) {
    ai_face_objekt();
    }
  ai_library();
}

void()  library_think = {
var
 head : Object;
 client : Object;
 megadeth : Vector;
{
  client = find(world, classname, "player");
  if (client == world || client.health < 1) {
    exit;
    }
  megadeth = client.origin - self.origin;
  if (vlen(megadeth) < 400 && visible(client)) {
    self.objekt = client;
    if (self.th_greet == library_shush) {
      self.th_greet();
      exit;
      }
    if (random() < 0.2) {
      self.th_wins();
      exit;
      }
    }
}

void()  library_itemmad = {
{
  sound(self, CHAN_VOICE, "archg/mykey.wav", 1, ATTN_NORM);
}

void()  ai_library = {
{
  if (self.objekt && visible(self.objekt)) {
    if (self.aflag != 0 && CheckItemStuff()) {
      self.cnt = 666;
      self.walkframe = 0;
      self.th_special();
      }
    }
}

void()  CheckItemStuff = {
var
 check : Real;
{
  if (self.aflag == 2) {
    check = IT_KEY1;
    }
  else {
    if (self.aflag == 3) {
      check = IT_KEY2;
      }
    else {
      if (self.aflag == 4) {
        check = IT_FLIGHT;
        }
      else {
        exit;
        }
      }
    }
  if (self.objekt.items & check) {
    return 1;
    exit;
    }
  return 0;
}*/

void() cart_boom = {
  self.origin = self.origin + '0 0 8';
  if (self.gib1mdl != "") ThrowGib(11, 2);
	if (self.gib2mdl != "") ThrowGib(12, 2);
	if (self.gib3mdl != "") ThrowGib(13, 2);
  if (self.gib4mdl != "") ThrowGib(14, floor(random() * 2));
  self.gib3mdl = "progs/redfield/misc_bookrk.mdl";
  self.gib3skin = SUB_ClampFloat(floor(random() * 9),0,8);
  ThrowGib(13, floor(random() * 2));
  self.gib3skin = SUB_ClampFloat(floor(random() * 9),0,8);
  ThrowGib(13, floor(random() * 2));
  self.gib3skin = SUB_ClampFloat(floor(random() * 9),0,8);
  ThrowGib(13, floor(random() * 2));
  self.gib3skin = SUB_ClampFloat(floor(random() * 9),0,8);
  ThrowGib(13, floor(random() * 2));
  self.gib3skin = SUB_ClampFloat(floor(random() * 9),0,8);
  ThrowGib(13, floor(random() * 2));
  sound(self, CHAN_ITEM, "nehahra/wall/woodbrk.wav", 1, ATTN_IDLE);
  self.think = SUB_Remove;
  self.nextthink = time + 0.05;
};

void() cart_think = {
  self.think = cart_think;
  if (self.health < 1) {
    self.think = self.th_die;
    self.health = -200;
  }
  self.nextthink = time + 0.1;
};

void() misc_librarycart = {
  self.classtype = CT_FUNCBREAKOBJ;
  self.classgroup = CG_BREAKABLE;
  self.solid = SOLID_BBOX;
  self.movetype = MOVETYPE_STEP;
  self.health = 69;
  self.max_health = MON_GIBFOUNTAIN;
  self.th_die = cart_boom;
  self.takedamage = DAMAGE_AIM;
  self.touch = player_push;
  self.bloodtype = MON_BCOLOR_BROWN;
  self.gibtype = GIBTYPE_WOOD;
	self.gib1mdl = "progs/nehahra/frubble1.mdl";	// Chainsaw
	self.gib2mdl = "progs/nehahra/frubble2.mdl";	// Left foot
	self.gib3mdl = "progs/nehahra/frubble3.mdl";	// Right foot
	self.gib4mdl = "progs/ad171/w_skullbook.mdl";	// Grenade Launcher
  setmodel(self,"progs/nehahra/libcart.mdl");
  setsize(self, VEC_HULL_MIN, VEC_HULL_MAX);
  self.origin_z = self.origin_z + 1;
  self.think = cart_think;
  self.nextthink = time + 0.1;
};

void() ogrelib_throwcart = {
  local entity cart;
  local vector spot;

  cart = spawn();

  cart.flags = 0;
  cart.owner = self;
  cart.classtype = CT_FUNCBREAKOBJ;
  cart.classgroup = CG_BREAKABLE;
  cart.solid = SOLID_BBOX;
  cart.movetype = MOVETYPE_STEP;
  cart.health = 69;
  cart.max_health = MON_GIBFOUNTAIN;
  cart.th_die = cart_boom;
  cart.takedamage = DAMAGE_AIM;
  cart.touch = player_push;
  cart.bloodtype = MON_BCOLOR_BROWN;
  cart.gibtype = GIBTYPE_WOOD;
	cart.gib1mdl = "progs/nehahra/frubble1.mdl";	// Chainsaw
	cart.gib2mdl = "progs/nehahra/frubble2.mdl";	// Left foot
	cart.gib3mdl = "progs/nehahra/frubble3.mdl";	// Right foot
	cart.gib4mdl = "progs/ad171/w_skullbook.mdl";	// Grenade Launcher
  setmodel(cart,"progs/nehahra/libcart.mdl");
  setsize(cart, VEC_HULL_MIN, VEC_HULL_MAX);
  makevectors(self.angles);
  spot = self.origin + v_forward * 15;
  setorigin(cart, spot);
  cart.velocity = v_forward * 220 + '0 0 200';
  cart.origin_z = cart.origin_z + 1;
  cart.think = cart_think;
  cart.nextthink = time + 0.1;
};

void() monster_ogre_library_becomenormal = {
  ogrelib_throwcart(); // Chuck it!
  self.mdl = "progs/ad171/mon_ogre.mdl";
  setmodel(self,self.mdl);
  setsize(self,self.bbmins, self.bbmaxs);
  self.idle_sound = "ogre/ogidle.wav";
	self.th_checkattack = OgreCheckAttack;
	self.th_stand = ogre_stand1;
	self.th_walk = ogre_walk1;
	self.th_run = ogre_run1;
	self.th_melee = ogre_melee;
  self.th_missile = ogre_adnail1;
	self.th_pain = ogre_pain;
	self.th_die = ogre_die;
	self.th_wakeup = ogre_wakeup1;
};

void() oglib_run = {
  monster_ogre_library_becomenormal();
  self.th_run();
};

void(entity inflictor, entity attacker, float damage) oglib_pain = {
  oglib_run();
};

void() oglib_die = {
  monster_ogre_library_becomenormal();
  self.th_die();
};

void() oglib_stand = {
  self.think = oglib_stand;
  self.nextthink = time + 0.1;
  if (self.walkframe >= 15) {
    self.walkframe = 0;
    if (random() < 0.7) { self.think = oglib_walk; return; }
  }
  self.frame = 16 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_stand();
}

void() oglib_cartsound = {
  local float num;

  if (random() > 0.3) return;
  num = random();
  if (num < 0.2) {
    sound(self, CHAN_AUTO, "nehahra/ogre/cart1.wav", 1, ATTN_IDLE);
  } else if (num < 0.7) {
    sound(self, CHAN_AUTO, "nehahra/ogre/cart2.wav", 1, ATTN_IDLE);
  } else {
    sound(self, CHAN_AUTO, "nehahra/ogre/cart3.wav", 1, ATTN_IDLE);
  }
};

void() oglib_walk = {
  self.think = oglib_walk;
  self.nextthink = time + 0.1;
  self.walkframe = SUB_ClampFloat(self.walkframe + 1,0,15);
  self.frame = self.walkframe;
  if (self.frame == 15) { self.walkframe = -1; }
  if (self.frame == 14) { ai_walk(4);
  } else if (self.frame == 13 || self.frame == 12) { oglib_cartsound(); ai_walk(3);
  } else if (self.frame == 11 || self.frame == 7) { oglib_cartsound(); ai_walk(2);
  } else if (self.frame == 10) { oglib_cartsound(); ai_walk(1);
  } else if (self.frame == 8) { oglib_cartsound();
  } else if (self.frame == 6) { oglib_cartsound(); ai_walk(3);
  } else if (self.frame == 5) { oglib_cartsound(); ai_walk(5);
  } else if (self.frame < 5 && self.frame != 1) { ai_walk(2);
  } else if (self.frame == 1) { oglib_cartsound(); ai_walk(2); }
  if (random() < 0.01) monster_idle_sound();
  if (random() < 0.01) self.th_stand();
};

void() monster_oglib_precache = {
  monster_ogre_precache();
  precache_model("progs/nehahra/libogre.mdl");
  precache_model("progs/nehahra/libcart.mdl");
  precache_model("progs/nehahra/frubble1.mdl");
  precache_model("progs/nehahra/frubble2.mdl");
  precache_model("progs/nehahra/frubble3.mdl");
  precache_model("progs/ad171/w_skullbook.mdl");
  precache_model("progs/redfield/misc_bookrk.mdl");
  precache_sound("nehahra/ogre/ogidle.wav");
  precache_sound("nehahra/ogre/cart1.wav");
  precache_sound("nehahra/ogre/cart2.wav");
  precache_sound("nehahra/ogre/cart3.wav");
  precache_sound("nehahra/wall/woodbrk.wav");
  precache_sound("nehahra/wall/statslid.wav");
  precache_sound("nehahra/wall/barslide.wav");
};

void() monster_oglib = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

  self.mdl = "progs/nehahra/libogre.mdl";
  self.headmdl = "progs/h_ogre.mdl";
	self.gib1mdl = "progs/ad171/w_chainsaw.mdl";	// Chainsaw
	self.gib2mdl = "progs/ad171/gib_ogfoot1.mdl";	// Left foot
	self.gib3mdl = "progs/ad171/gib_ogfoot2.mdl";	// Right foot
	self.gib4mdl = "progs/ad171/w_ogregl.mdl";	// Grenade Launcher
  self.idle_sound = "nehahra/ogre/ogidle.wav";
	self.idle_soundcom = "ogre/ogidle2.wav";
	self.pain_sound = "ogre/ogpain1.wav";
	self.sight_sound = "ogre/ogwake.wav";
	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	self.idmins = VEC_HULL2_MIN;		// -32 -32 -24, 32 32 64
	self.idmaxs = VEC_HULL2_MAX;
  self.button0 = 90;
	if (self.bboxtype < 1) self.bboxtype = BBOX_WIDE;
	self.gibhealth = -80;
	self.gibbed = FALSE;
	self.pain_flinch = 30;				// Low pain flinch
	self.pain_longanim = TRUE;			// Can be chopped with shadow axe
	self.steptype = FS_TYPESLOW;		// Small sounding feet
	self.meleerange = MONAI_MELEEOGRE;	// Chainsaw range
	self.no_zaware = TRUE;		
  if (self.health < 1) self.health = 375; // Librarians are not to be messed with.
  self.th_stand = oglib_stand;
  self.th_walk = oglib_walk;
  self.th_run = oglib_run;
  self.th_die = oglib_die;
  self.th_melee = oglib_run;
  self.th_missile = oglib_run;
  self.th_pain = oglib_pain;
  if (!self.ammo_rockets) self.ammo_rockets = 2;	// Default ammo drop
  if (self.deathstring == "")  self.deathstring = " was destroyed by an Ogre\n";
  self.pain_finished = time + 1;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.classtype = CT_MONOGRE;		// Old style ogre
	if (self.classname != "monster_ogre_marksman") self.classgroup = CG_OGRE; // One big happy ogre family! Except for those pesky marksmen (preserve original ID1 infight ability)
  SetDefaultDenizenAttributes(self);
	self.classmove = MON_MOVEWALK;
  self.classgroup = CG_HARMLESS;
  monster_start();
};
