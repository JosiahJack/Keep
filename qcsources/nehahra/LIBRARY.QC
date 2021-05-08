Void function monster_library();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  total_monsters = total_monsters + 1;
  precache_model2("progs/library.mdl");
  precache_model2("progs/archg.mdl");
  precache_model2("progs/h_gaunt.mdl");
  precache_model2("progs/gntspke.mdl");
  precache_model2("progs/rubble1.mdl");
  precache_model2("progs/rubble2.mdl");
  precache_model2("progs/rubble3.mdl");
  precache_model2("progs/rubble4.mdl");
  precache_model2("progs/rubble5.mdl");
  precache_model2("progs/rubble6.mdl");
  precache_model2("progs/gring.mdl");
  precache_sound2("boss3/nehdie4.wav");
  precache_sound2("archg/mykey.wav");
  precache_sound2("gaunt/gspike.wav");
  precache_sound2("gaunt/spkhit.wav");
  precache_sound2("archg/shsh.wav");
  precache_sound2("archg/fire2.wav");
  setmodel(self, "progs/library.mdl");
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  setsize(self, VEC_HULL_MIN, [12 12 48]);
  if (!(self.health)) {
    self.health = 666;
    }
  self.cnt = 0;
  self.th_stand = library_read_r;
  self.th_walk = library_read_r;
  self.th_run = library_2mad;
  self.th_pain = library_pain;
  self.th_die = library_pain;
  self.th_wins = library_hmm;
  self.th_greet = library_shush;
  self.th_special = library_watch;
  walkmonster_start();
}

Void function library_2archg();
{
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

Void function library_pain();
{
  if (self.health < 1) {
    self.health = 1;
    self.takedamage = DAMAGE_AIM;
    self.solid = SOLID_SLIDEBOX;
    }
  library_2archg();
  self.th_pain();
  exit;
}

Void function library_2mad();
{
  library_2archg();
  self.th_run();
  exit;
}

Void function library_read_r();
{
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

Void function library_flippage();
{
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

Void function library_flippage2();
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

Void function library_rtl();
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

Void function library_read_l();
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

Void function library_ltr();
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

Void function library_hmm();
{
  self.walkframe = 0;
  self.cnt = 1;
  library_lookup();
}

Void function library_shush();
{
  self.walkframe = 0;
  self.cnt = 2;
  self.th_greet = Sub_Null;
  library_lookup();
}

Void function library_lookup();
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

Void function library_lookdown();
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

Void function library_shsh();
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


Void function library_shsh2();
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

Void function library_watch();
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

Void function library_think();
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

Void function library_itemmad();
{
  sound(self, CHAN_VOICE, "archg/mykey.wav", 1, ATTN_NORM);
}

Void function ai_library();
{
  if (self.objekt && visible(self.objekt)) {
    if (self.aflag != 0 && CheckItemStuff()) {
      self.cnt = 666;
      self.walkframe = 0;
      self.th_special();
      }
    }
}

Void function CheckItemStuff();
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
}

Void function monster_oglib();
{
  if (deathmatch) {
    remove(self);
    exit;
    }
  total_monsters = total_monsters + 1;
  precache_model("progs/libogre.mdl");
  precache_model("progs/libcart.mdl");
  precache_model("progs/ogre.mdl");
  precache_model("progs/h_ogre.mdl");
  precache_model("progs/grenade.mdl");
  precache_model("progs/frubble1.mdl");
  precache_model("progs/frubble2.mdl");
  precache_model("progs/frubble3.mdl");
  precache_sound("ogre/cart1.wav");
  precache_sound("ogre/cart2.wav");
  precache_sound("ogre/cart3.wav");
  precache_sound("ogre/ogdrag.wav");
  precache_sound("ogre/ogdth.wav");
  precache_sound("ogre/ogidle.wav");
  precache_sound("ogre/ogidle2.wav");
  precache_sound("ogre/ogpain1.wav");
  precache_sound("ogre/ogsawatk.wav");
  precache_sound("ogre/ogwake.wav");
  precache_sound("wall/woodbrk.wav");
  self.solid = SOLID_SLIDEBOX;
  self.movetype = MOVETYPE_STEP;
  setmodel(self, "progs/libogre.mdl");
  setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
  if (!(self.health)) {
    self.health = 375;
    }
  self.button0 = 90;
  self.th_stand = oglib_stand;
  self.th_walk = oglib_walk1;
  self.th_run = oglib_run;
  self.th_die = oglib_die;
  self.th_melee = oglib_run;
  self.th_missile = oglib_run;
  self.th_pain = oglib_run;
  walkmonster_start();
}

Void function oglib_run();
{
  oglib_2ogre();
  self.th_run();
}

Void function oglib_die();
{
  oglib_2ogre();
  self.th_die();
}

Void function oglib_stand();
{
  if (self.walkframe >= 15) {
    self.walkframe = 0;
    if (random() < 0.7) {
      oglib_walk1();
      exit;
      }
    }
  #16 oglib_stand;
  self.frame = 16 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_stand();
}

Void function oglib_cartsound();
var
 num : Real;
{
  if (random() > 0.3) {
    exit;
    }
  num = random();
  if (num < 0.2) {
    sound(self, CHAN_AUTO, "ogre/cart1.wav", 1, ATTN_IDLE);
    }
  else {
    if (num < 0.7) {
      sound(self, CHAN_AUTO, "ogre/cart2.wav", 1, ATTN_IDLE);
      }
    else {
      sound(self, CHAN_AUTO, "ogre/cart3.wav", 1, ATTN_IDLE);
      }
    }
}

Void function oglib_walk1();
{
  #0 oglib_walk2;
  ai_walk(MOVETYPE_WALK);
}

Void function oglib_walk2();
{
  #1 oglib_walk3;
  ai_walk(FL_SWIM);
  oglib_cartsound();
}

Void function oglib_walk3();
{
  #2 oglib_walk4;
  ai_walk(FL_SWIM);
}

Void function oglib_walk4();
{
  #3 oglib_walk5;
  ai_walk(FL_SWIM);
}

Void function oglib_walk5();
{
  #4 oglib_walk6;
  ai_walk(FL_SWIM);
}

Void function oglib_walk6();
{
  #5 oglib_walk7;
  ai_walk(MOVETYPE_FLY);
  oglib_cartsound();
  if (random() < 0.1) {
    sound(self, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE);
    }
}

Void function oglib_walk7();
{
  #6 oglib_walk8;
  ai_walk(MOVETYPE_WALK);
}

Void function oglib_walk8();
{
  #7 oglib_walk9;
  ai_walk(FL_SWIM);
}

Void function oglib_walk9();
{
  #8 oglib_walk10;
  ai_walk(MOVETYPE_WALK);
  oglib_cartsound();
}

Void function oglib_walk10();
{
  #9 oglib_walk11;
  ai_walk(1);
}

Void function oglib_walk11();
{
  #10 oglib_walk12;
  ai_walk(FL_SWIM);
  oglib_cartsound();
}

Void function oglib_walk12();
{
  #11 oglib_walk13;
  ai_walk(MOVETYPE_WALK);
}

Void function oglib_walk13();
{
  #12 oglib_walk14;
  ai_walk(MOVETYPE_WALK);
  oglib_cartsound();
}

Void function oglib_walk14();
{
  #13 oglib_walk15;
  ai_walk(MOVETYPE_WALK);
  oglib_cartsound();
}

Void function oglib_walk15();
{
  #14 oglib_walk16;
  ai_walk(MOVETYPE_WALK);
}

Void function oglib_walk16();
{
  ai_walk(MOVETYPE_STEP);
  if (random() < 0.2) {
    #15 oglib_stand;
    sound(self, CHAN_VOICE, "ogre/ogidle.wav", 1, ATTN_IDLE);
    }
  else {
    #15 oglib_walk1;
    }
}

Void function oglib_2ogre();
{
  self.th_stand = ogre_stand1;
  self.th_walk = ogre_walk1;
  self.th_run = ogre_run1;
  self.th_die = ogre_die;
  self.th_melee = ogre_melee;
  self.th_missile = ogre_nail1;
  self.th_pain = ogre_pain;
  setmodel(self, "progs/ogre.mdl");
  setsize(self, VEC_HULL2_MIN, VEC_HULL2_MAX);
  ogrelib_throwcart();
  self.pain_finished = time + 1;
}

Void function ogrelib_throwcart();
var
 cart : Object;
 spot : Vector;
{
  cart = spawn();
  cart.owner = self;
  cart.solid = SOLID_BBOX;
  cart.movetype = MOVETYPE_STEP;
  cart.health = 69;
  cart.th_die = cart_boom;
  cart.takedamage = DAMAGE_AIM;
  cart.touch = player_push;
  setmodel(cart, "progs/libcart.mdl");
  setsize(cart, VEC_HULL_MIN, VEC_HULL_MAX);
  makevectors(self.angles);
  spot = self.origin + v_forward * 15;
  setorigin(cart, spot);
  cart.velocity = v_forward * 220 + [0 0 200];
  cart.origin_z = cart.origin_z + 1;
}

Void function cart_boom();
{
  self.dmg = 0;
  ThrowRubble("progs/frubble1.mdl", self.health);
  ThrowRubble("progs/frubble2.mdl", self.health);
  ThrowRubble("progs/frubble3.mdl", self.health);
  self.dmg = 2;
  ThrowRubble("progs/frubble1.mdl", self.health);
  ThrowRubble("progs/frubble2.mdl", self.health);
  ThrowRubble("progs/frubble3.mdl", self.health);
  sound(self, CHAN_ITEM, "wall/woodbrk.wav", 1, ATTN_IDLE);
  remove(self);
}


