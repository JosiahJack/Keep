void() monster_mistermax_precache = {
	precache_model("progs/nehahra/maxwell.mdl");
	precache_model("progs/nehahra/gntspke.mdl");
	precache_model("progs/drake/v_spike.mdl");
	precache_model("progs/nehahra/rubble1.mdl");
	precache_model("progs/nehahra/rubble4.mdl");
	precache_model("progs/nehahra/rubble6.mdl");
	precache_sound("zerstorer/ambience/thunder2.wav");
	precache_sound("nehahra/sets/set4_2.wav");
	precache_sound("nehahra/quake/inv3.wav");
	precache_sound("nehahra/wall/wall01.wav");
	precache_sound("drake/misc/wallbrk.wav");
	precache_sound("nehahra/sets/set4_1.wav");
	precache_sound("nehahra/ambience/secj.wav");
	precache_sound("nehahra/gaunt/gspike.wav");
	precache_sound("nehahra/gaunt/spkhit.wav");
	precache_sound("weapons/lhit.wav");
	precache_sound("nehahra/gaunt/boom.wav");
	precache_sound("nehahra/archg/lift.wav");
	precache_sound("nehahra/archg/lift3.wav");
	precache_sound("nehahra/archg/fire2.wav");
	precache_sound("nehahra/ambience/rych1.wav");
	precache_sound("shalrath/attack2.wav");
	precache_model("progs/nehahra/soul.mdl");
	precache_sound("shambler/sboom.wav");
	precache_sound("nehahra/max/step2.wav");
	precache_sound("nehahra/max/step3.wav");
	precache_sound("nehahra/max/laugh.wav");
	precache_sound("nehahra/max/laugh2.wav");
	precache_sound("nehahra/max/lava1.wav");
	precache_sound("nehahra/max/lava2.wav");
	precache_sound("shambler/sattck1.wav");
	precache_sound("hknight/idle.wav");
	precache_sound("ambience/fire1.wav");
	precache_sound("nehahra/weapons/sprfall1.wav");
	precache_sound("nehahra/weapons/sprfall2.wav");
	precache_sound("nehahra/boss3/hit.wav");
	precache_sound("nehahra/max/pain1.wav");
	precache_sound("nehahra/max/pain2.wav");
	precache_sound("nehahra/max/pain3.wav");
	precache_sound("nehahra/max/mpain1.wav");
	precache_sound("nehahra/max/mpain2.wav");
	precache_sound("nehahra/max/mpain3.wav");
};

void(vector megadeth, vector vec) spawn_maxteleport = {
	local entity mark;

	mark = spawn();
	setorigin(mark, megadeth);
	mark.charmer = self;
	mark.aether = vec;
	mark.think = max_teleport;
	mark.nextthink = time + 0.3;
};

void(vector megadeth, vector vec, string ing) spawn_newteleport = {
	local entity mark;

	mark = spawn();
	setorigin(mark, megadeth);
	mark.charmer = self;
	mark.event = ing;
	mark.aether = vec;
	mark.think = new_teleport;
	mark.nextthink = time + 0.3;
};

void() prepare_finale = {
	// spawn_moderator();
	// spawn_platpoint();
	// spawn_maxcontrol();
	// spawn_maxteleport('415 -1060 472', '416 -896 858');
	// spawn_newteleport('417 -75 856', '414 -898 -104', "maxtel2");
	// spawn_newteleport('414 -898 -104', '417 -75 856', "maxtel1");
	// spawn_movepoint('416 -373 -40', 1, '410 -115 -40', [410 -115 -40], VEC_ORIGIN);
	// spawn_movepoint('410 -115 -40', 1, [792 -93 -40', [792 -93 -40], [11 57 -40]);
	// spawn_movepoint('792 -93 -40', 1, [11 -57 -40', [780 678 -40], VEC_ORIGIN);
	// spawn_movepoint('11 -57 -40', 1, [57 678 -40', [792 -93 -40], VEC_ORIGIN);
	// spawn_movepoint('57 678 -40', 1, [780 678 -40', [11 -57 -40], VEC_ORIGIN);
	// spawn_movepoint('780 678 -40', 1, [792 -93 -40], [57 678 -40], VEC_ORIGIN);
	// spawn_movepoint('906 27.5 184', 2, [945 416 184], [-99 32.5 184], VEC_ORIGIN);
	// spawn_movepoint('945 416 184', 2, [926 804 184], [906 27.5 184], [-104 418 184]);
	// spawn_movepoint('926 804 184', 2, [-77 809 184], [945 416 184], VEC_ORIGIN);
	// spawn_movepoint('410 800 184], 2, [-77 809 184], [926 804 184], VEC_ORIGIN);
	// spawn_movepoint('-77 809 184], 2, [-104 418 184], [926 804 184], VEC_ORIGIN);
	// spawn_movepoint('-104 418 184], 2, [-99 32.5 184], [-77 809 184], [945 416 184]);
	// spawn_movepoint('-99 32.5 184], 2, [906 27.5 184], [-104 418 184], VEC_ORIGIN);
	// spawn_movepoint('761 170 472], 3, [423.5 192 472], [778 642 472], VEC_ORIGIN);
	// spawn_movepoint('423.5 192 472], 3, [43.6 207 472], [761 170 472], [416 -323 472]);
	// spawn_movepoint('43.6 207 472], 3, [77.6 668 472], [423.5 192 472], VEC_ORIGIN);
	// spawn_movepoint('77.6 668 472], 3, [778 642 472], [43.6 207 472], VEC_ORIGIN);
	// spawn_movepoint('778 642 472], 3, [761 170 472], [77.6 668 472], VEC_ORIGIN);
	// spawn_movepoint('441 -1050 472], 3, [612 -865 472], [393 -1055 472], VEC_ORIGIN);
	// spawn_movepoint('612 -865 472], 3, [831 -901 472], [411 -1050 472], VEC_ORIGIN);
	// spawn_movepoint('831 -901 472], 3, [847 -578 472], [612 -865 472], VEC_ORIGIN);
	// spawn_movepoint('847 -578 472], 3, [838 -249 472], [831 -901 472], [-18 -575 472]);
	// spawn_movepoint('838 -249 472], 3, [416 -323 472], [847 -578 472], VEC_ORIGIN);
	// spawn_movepoint('416 -323 472], 3, [-24 253 472], [838 -249 472], [423.5 192 472]);
	// spawn_movepoint('-24 -253 472], 3, [-18 -575 472], [416 -323 472], VEC_ORIGIN);
	// spawn_movepoint('-18 -575 472], 3, [-7 -923 472], [-24 253 472], [847 -578 472]);
	// spawn_movepoint('-7 -923 472], 3, [230 -855 472], [-18 -575 472], VEC_ORIGIN);
	// spawn_movepoint('230 -855 472], 3, [393 -1055 472], [-7 -923 472], VEC_ORIGIN);
	// spawn_movepoint('393 -1055 472], 3, [441 -1050 472], [230 -855 472], VEC_ORIGIN);
	// spawn_movepoint('569 -733 856], 4, [564 18.5 856], [268 -735 856], VEC_ORIGIN);
	// spawn_movepoint('564 18.5 856], 4, [409 180 856], [569 -733 856], VEC_ORIGIN);
	// spawn_movepoint('409 180 856], 4, [252 -96 856], [564 18.5 856], VEC_ORIGIN);
	// spawn_movepoint('252 -96 856], 4, [268 -735 856], [409 180 856], VEC_ORIGIN);
	// spawn_movepoint('268 -735 856], 4, [569 -733 856], [252 -96 856], VEC_ORIGIN);
	// spawn_downpoint('428 642 184], 2);
	// spawn_downpoint('408 185 184], 2);
	// spawn_downpoint('895 36 472], 3);
	// spawn_downpoint('781 807 472], 3);
	// spawn_downpoint('378 806 472], 3);
	// spawn_downpoint('-77 761 472], 3);
	// spawn_downpoint('-67 12 472], 3);
	// spawn_downpoint('644 66 472], 3);
	// spawn_downpoint('410 -573 472], 3);
	// spawn_downpoint('764 -572 856], 4);
	// spawn_downpoint('55 -566.5 856], 4);
	// spawn_downpoint('185 -880 856], 4);
	// spawn_downpoint('633 -888 856], 4);
	// spawn_downpoint('779 -269 856], 4);
	// spawn_downpoint('90 -272 856], 4);
};

void() max_teleport = {
	local vector megadeth;
	local entity head;

	head = self.charmer;
	megadeth = self.origin - head.origin;
	if (vlen(megadeth) < 120) {
		switchmethod(head);
		ai_teleport(head, self.aether);
	}
	self.think = max_teleport;
	self.nextthink = time + 0.3;
};

void() new_teleport = {
	local vector megadeth;
	local entity head, vec;

	head = self.charmer;
	megadeth = self.origin - head.origin;
	if (vlen(megadeth) < 90) {
		if (self.charmer.xgoal == self.origin) {
			switchmethod(head);
			vec = self.aether + [0 0 26];
			ai_teleport(head, vec);
		}
	}
	self.think = new_teleport;
	self.nextthink = time + 0.3;
};

void() spawn_moderator = {
var
 mark : Object;
{
  mark = spawn();
  mark.charmer = self;
  mark.origin = self.origin;
  mark.think = nehend_cllvl;
  mark.nextthink = time + 0.5;
}

void() nehend_cllvl = {
var
 num : Real;
 t : Real;
 mark : Object;
{
  mark = self.charmer;
  if (mark.health < 400) {
    T_Heal(mark, 0.2, 1);
    }
  if (mark.enemy != world && mark.xgoal != [410 800 184]) {
    self.enemy = mark.enemy;
    mark.relations = nehend_checklevel(mark);
    num = nehend_checklevel(mark.enemy);
    if (mark.health < 100) {
      if (!(mark.brain & FL_CLIENT)) {
        mark.brain = mark.brain | FL_CLIENT;
        }
      }
    else {
      if (mark.brain & FL_CLIENT) {
        mark.brain = mark.brain - FL_CLIENT;
        }
      }
    if (num == mark.relations) {
      if (mark.brain & FL_CLIENT) {
        if (num > 1) {
          nehend_downlevel(mark);
          }
        else {
          nehend_uplevel(mark);
          }
        }
      else {
        nehend_clearlevel(mark);
        }
      }
    else {
      if (num > mark.relations) {
        if (mark.brain & FL_CLIENT) {
          if (mark.relations > 1) {
            nehend_downlevel(mark);
            }
          else {
            nehend_clearlevel(mark);
            }
          }
        else {
          nehend_uplevel(mark);
          }
        }
      else {
        if (mark.brain & FL_CLIENT) {
          nehend_uplevel(mark);
          }
        else {
          nehend_downlevel(mark);
          }
        }
      }
    }
  self.think = nehend_cllvl;
  self.nextthink = time + 0.1;
}

void() nehend_clearlevel(mark : Object);
{
  if (mark.brain & FL_FLY) {
    mark.brain = mark.brain - FL_FLY;
    }
  if (mark.brain & FL_SWIM) {
    mark.brain = mark.brain - FL_SWIM;
    }
}

void() nehend_uplevel(mark : Object);
{
  if (!(mark.brain & FL_FLY)) {
    mark.brain = mark.brain | FL_FLY;
    if (mark.brain & FL_SWIM) {
      mark.brain = mark.brain - FL_SWIM;
      }
    }
}

void() nehend_downlevel(mark : Object);
{
  if (!(mark.brain & FL_SWIM)) {
    mark.brain = mark.brain | FL_SWIM;
    if (mark.brain & FL_FLY) {
      mark.brain = mark.brain - FL_FLY;
      }
    }
}

void(entity mark) nehend_checklevel = {
	if (mark.jump_flag == 666) return 5;
	if (mark.origin_z < -40) return 0;
	if (mark.origin_z < 184) return 1;
	if (mark.origin_z < 472) return 2;
	if (mark.origin_z < 856) return 3;
	return 4;
};

void() spawn_movepoint(vec : Vector; num : Real; megadeth : Vector; dave : Vector; spot : Vector);
var
 mark : Object;
{
  mark = spawn();
  mark.classname = "movepoint";
  mark.origin = vec;
  mark.relations = num;
  mark.xgoal = megadeth;
  mark.xtrace = dave;
  mark.aether = spot;
  setorigin(mark, vec);
  setsize(mark, [-16 -16 0], [16 16 56]);
  mark.solid = SOLID_TRIGGER;
  setmodel(mark, mark.model);
  mark.movetype = MOVETYPE_NONE;
  mark.modelindex = 0;
  mark.sky = "end";
  mark.model = "";
  mark.touch = movepoint_touch;
}

void() movepoint_touch = {
	local float num;

	if (other.health < 1) return;
	if (other.classname != "the_mister") return;
	if (other.xgoal != self.origin) return;

  if (self.aether != [0 0 0]) {
    num = random();
    if (other.brain & FL_FLY) {
      if (other.relations == 2) {
        if (self.origin == [945 416 184] || self.origin == [-104 418 184]) {
          num = 0.1;
          }
        }
      else {
        if (other.relations == 3) {
          if (self.origin == [423.5 192 472]) {
            other.method = 1;
            num = 0.1;
            }
          else {
            num = 0.8;
            }
          }
        }
      }
    if (num < 0.4) {
      other.xgoal = self.aether;
      return;
      }
    }
  if (other.method == 0) {
    other.xgoal = self.xgoal;
    } else {
    other.xgoal = self.xtrace;
    }
};

Real() situation(megadeth : Vector; dave : Vector; head : Object);
var
 spot1 : Vector;
 spot2 : Vector;
{
  spot1 = megadeth + [0 0 22];
  spot2 = dave + [0 0 22];
  traceline(spot1, spot2, 1, head);
  if (trace_fraction == 1) {
    return 1;
    }
  return 0;
}

void() spawn_downpoint(vec : Vector; num : Real);
var
 mark : Object;
{
  mark = spawn();
  mark.classname = "downpoint";
  mark.origin = vec;
  mark.sky = "end";
  mark.relations = num;
  setorigin(mark, vec);
}

void() spawn_platpoint = {
var
 mark : Object;
{
  mark = spawn();
  mark.classname = "platpoint";
  setorigin(mark, [413 1066 -40]);
  mark.sky = "end";
  self.think = platpoint_plat;
  self.nextthink = time + 0.1;
}

void() platpoint_plat = {
var
 head : Object;
 selected : Object;
{
  selected = world;
  head = find(world, classname, "func_plat");
  while(head) {
    if (head.height == 224) {
      selected = head;
      }
    head = find(world, classname, "func_plat");
    }
  if (selected == world) {
    self.think = platpoint_plat;
    self.nextthink = time + 0.1;
    }
  else {
    self.charmer = selected;
    }
}

void() switchmethod(head: Object);
{
  if (head.method == 0) {
    head.method = 1;
    }
  else {
    head.method = 0;
    }
}

void() maxnewteles = {
var
 t : Real;
 num : Real;
 head : Object;
 mark : Object;
{
  mark = find(world, targetname, "web");
  if (mark == world) {
    bprint("Max can't find teleports|");
    return;
    }
  if (mark.state) {
    return;
    }
  t = nehend_checklevel(self.enemy);
  if (t < 2 && self.relations == 4) {
    if (self.origin_y > 0) {
      head = find(world, event, "maxtel2");
      if (head == world) {
        return;
        }
      self.xgoal = head.origin;
      }
    return;
    }
  if (t == 4 && self.relations == 0) {
    head = find(world, event, "maxtel1");
    if (head == world) {
      bprint("no maxtel1|");
      return;
      }
    self.xgoal = head.origin;
    }
}

void() maxstep = {
	if (random() < 0.4) {
		sound(self, CHAN_AUTO, "nehahra/max/step2.wav", 0.7, ATTN_NORM);
		return;
	}
	sound(self, CHAN_AUTO, "nehahra/max/step3.wav", 0.7, ATTN_NORM);
};

void() max_painsound1 = {
	local float num;

	num = random();
	if (num < 0.333) sound(self, CHAN_VOICE, "nehahra/max/pain1.wav", 1, ATTN_NORM);
	else if (num < 0.666) { sound(self, CHAN_VOICE, "nehahra/max/pain2.wav", 1, ATTN_NORM);
	else sound(self, CHAN_VOICE, "nehahra/max/pain3.wav", 1, ATTN_NORM);
};

void() max_painsound2 = {
	local float num;

	num = random();
	if (num < 0.333) sound(self, CHAN_VOICE, "nehahra/max/mpain1.wav", 1, ATTN_NORM);
	else if (num < 0.666) { sound(self, CHAN_VOICE, "nehahra/max/mpain2.wav", 1, ATTN_NORM);
	else sound(self, CHAN_VOICE, "nehahra/max/mpain3.wav", 1, ATTN_NORM);
};

void() max_painsound = {
  if (self.lives > 2) {
    if (random() < 0.4) { max_painsound1(); return; }
  }
  max_painsound2();
};

void() ai_maxrun = {
var
 num : Real;
 putz : Object;
 head : Object;
 selected : object;
 dist : Real;
 spot : Vector;
 spot2 : Vector;
{
  if (pointcontents(self.origin) == CONTENT_LAVA) {
    Max_teleportsys();
    return;
    }
  if (self.enemy.health < 1) {
    self.xgoal = [0 0 0];
    self.enemy = world;
    self.th_stand();
    return;
    }
  if (max_quadfudge()) {
    return;
    }
  Max_survival();
  if (visible(self.enemy)) {
    movetogoal(25);
    if (random() < 0.3) {
      self.th_missile();
      return;
      }
    }
  if (self.brain & FL_SWIM) {
    if (findjumppath()) {
      return;
      }
    }
  if (self.xgoal == [413 1066 -40]) {
    if (self.origin_z > 130) {
      self.relations = 2;
      self.xgoal = [410 800 184];
      }
    else {
      ai4_face(self.xgoal);
      ai2_jump(self.angles, 220, [0 0 220]);
      return;
      }
    }
  maxnewteles();
  if (self.brain & FL_FLY) {
    if (self.relations == 1 && self.xgoal != [413 1066 -40]) {
      head = find(world, classname, "platpoint");
      if (visible(head)) {
        if (head.charmer.state == 0) {
          self.xgoal = head.origin;
          }
        }
      }
    }
  if (self.xgoal != [0 0 0]) {
    if (self.xgoal == [411 -1050 472] || self.xgoal == [441 -1050 472]) {
      if (random() < 0.4) {
        ai2_jump(self.angles, 200, [0 0 225]);
        return;
        }
      }
    if (situation(self.origin, self.xgoal, self)) {
      self.ideal_yaw = vectoyaw(self.xgoal - self.origin);
      ChangeYaw();
      if (walkmove(self.angles_y, 20) == FALSE) {
        if (self.relations == 2) {
          ai2_jump(self.angles, 200, [0 0 225]);
          return;
          }
        if (self.xgoal == [847 -578 472] || self.xgoal == [-18 -575 472]) {
          if (!(self.brain & FL_SWIM)) {
            ai2_jump(self.angles, 400, [0 0 325]);
            }
          }
        ai_run_slide(20);
        }
      return;
      }
    self.xgoal = [0 0 0];
    }
  dist = 300;
  selected = world;
  head = findradius(self.origin, 600);
  while (head) {
    if (head.classname == "movepoint" && head.relations == self.relations) {
      if (situation(self.origin, head.origin, self)) {
        selected = head;
        dist = trace_plane_dist;
        }
      }
    head = head.chain;
    }
  if (selected == world) {
    movetogoal(25);
    }
  else {
    self.xgoal = selected.origin;
    }
}

void() findjumppath = {
var
 dist : Real;
 selected : Object;
 head : Object;
 dave : Vector;
{
  if (!(self.flags & FL_ONGROUND)) {
    return 0;
    }
  dist = 300;
  selected = world;
  head = find(world, classname, "downpoint");
  while (head) {
    if (head.relations == self.relations) {
      if (visible(head)) {
        selected = head;
        dist = trace_plane_dist;
        }
      }
    head = find(head, classname, "downpoint");
    }
  if (selected == world) {
    return 0;
    }
  else {
    self.xgoal = [0 0 0];
    ai2_face(selected);
    dave = self.angles;
    dave_y = self.ideal_yaw;
    if (selected.origin == [410 -573 472]) {
      ai2_jump(self.angles, 200, [0 0 225]);
      }
    else {
      makevectors(dave);
      self.origin_z = self.origin_z + 1;
      self.velocity = v_forward * 300 + [0 0 325];
      self.flags = self.flags - FL_ONGROUND;
      return 1;
      }
    }
}

void() max_begin() = {
  self.enemy = find(world, classname, "player");
  self.th_stand = max_stand;
  self.th_run();
};

void() max_stand = {
var
  head : Object;
  selected : Object;
{
  if (self.tolerate == 1) {
    self.tolerate = 0;
    max_look();
    return;
    }
  if (self.walkframe >= 10) {
    self.walkframe = 0;
    if (random() < 0.2) {
      max_squint();
      return;
      }
    }
  #0 max_stand;
  self.frame = self.walkframe;
  self.walkframe = self.walkframe + 1;
  head = find(world, classname, "player");
  while (head) {
    if (head.health > 1) {
      selected = head;
      }
    head = find(head, classname, "player");
    }
  if (selected != world) {
    self.enemy = selected;
    self.th_run();
    return;
    }
  else {
    if (head.health < 1) {
      head = find(world, classname, "player");
      }
    ai4_face(head.origin);
    }
  FindTarget();
}

void() max_squint = {
var
  head : Object;
{
  if (self.walkframe >= 10) {
    self.walkframe = 0;
    max_stand();
    return;
    }
  #30 max_stand;
  self.frame = 30 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  head = find(world, classname, "player");
  if (head != world) {
    if (head.health > 1) {
      self.enemy = head;
      self.th_run();
      return;
      }
    else {
      ai4_face(head.origin);
      }
    }
  FindTarget();
}

void() max_look = {
var
 head : Object;
{
  if (self.walkframe >= 10) {
    self.walkframe = 0;
    max_look2();
    return;
    }
  #10 max_look;
  self.frame = 10 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  head = find(world, classname, "player");
  if (head != world) {
    ai4_face(head.origin);
    ai4_face(head.origin);
    }
}

void() max_look2 = {
{
  if (self.walkframe >= 10) {
    self.walkframe = 0;
    max_look3();
    return;
    }
  #10 max_look2;
  self.frame = 19 - self.walkframe;
  self.walkframe = self.walkframe + 1;
}

void() max_look3 = {
{
  if (self.walkframe >= 10) {
    self.walkframe = 0;
    max_look4();
    return;
    }
  #20 max_look3;
  self.frame = 20 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

void() max_look4 = {
{
  if (self.walkframe >= 10) {
    self.walkframe = 0;
    max_stand();
    return;
    }
  #20 max_look4;
  self.frame = 29 - self.walkframe;
  self.walkframe = self.walkframe + 1;
}

void() max_stroll = {
{
  if (self.walkframe >= 14) {
    self.walkframe = 0;
    }
  #40 max_stroll;
  self.frame = 40 + self.walkframe;
  self.walkframe = self.walkframe + 1;
}

void() max_attack = {
var
 megadeth : Vector;
{
  self.walkframe = 0;
  megadeth = self.enemy.origin - self.origin;
  if (vlen(megadeth) < 280) {
    if (random() < 0.3) {
      if (self.lives < 2) {
        max_s_light1();
        return;
        }
      max_light1();
      return;
      }
    }
  if (random() < 0.5) {
    max_gauntrang1();
    }
  else {
    if (random() > 0.4) {
      max_throw();
      }
    if (random() > 0.8 || self.lives < 2) {
      max_rapidfire1();
      return;
      }
    max_shalrath1();
    }
}

void() max_gauntrang1 = {
{
  #73 max_gauntrang2;
  ai_threats();
  self.pain_finished = time + 0.5;
}

void() max_gauntrang2 = {
{
  #74 max_gauntrang3;
  ai_threats();
  ai_face();
}

void() max_gauntrang3 = {
{
  #75 max_gauntrang4;
  ai_threats();
  ai_face();
}

void() max_gauntrang4 = {
{
  #76 max_gauntrang5;
  self.cnt = 0;
  ai_face();
  ai_threats();
}

void() max_gauntrang5 = {
{
  if (!visible(self.enemy)) {
    self.th_run();
    return;
    }
  if (self.enemy.health < 1) {
    self.th_stand();
    return;
    }
  #77 max_gauntrang6;
  self.cnt = self.cnt + 1;
  ai_face();
  ai_threats();
  GauntMissile();
  max_backorcharge();
}

void() max_gauntrang6 = {
{
  ai_threats();
  if (self.cnt > 8 || vlen(self.origin - self.enemy.origin) > 330) {
    self.cnt = 0;
    #76 max_gauntrang7;
    ai_face();
    }
  else {
    #78 max_gauntrang5;
    ai_face();
    GauntMissile();
    Max_Survival();
    }
}

void() max_gauntrang7 = {
{
  #75 max_gauntrang8;
  ai_threats();
}

void() max_gauntrang8 = {
{
  #74 max_run;
  ai_threats();
}

void() max_backorcharge = {
{
  if (self.brain & FL_CLIENT) {
    ai_back(5);
    }
  else {
    ai_face();
    movetogoal(15);
    }
}

void() max_light1 = {
{
  #60 max_light2;
  ai_face();
  ai_threats();
}

void() max_light2 = {
{
  #61 max_light3;
  ai_face();
  ai_threats();
}

void() max_light3 = {
{
  #62 max_light4;
  ai_face();
  sound(self, CHAN_BODY, "nehahra/gaunt/boom.wav", 1, ATTN_NORM);
  ai_threats();
}

void() max_light4 = {
{
  #63 max_light5;
  ai_face();
  max_backorcharge();
  if (random() < 0.5) {
    sound(self, CHAN_BODY, "weapons/lhit.wav", 1, ATTN_NORM);
    }
  MaxRedLightning();
  ai_threats();
}

void() max_light5 = {
{
  if (visible(self.enemy) && self.enemy.health > 1) {
    #64 max_light4;
    MaxRedLightning();
    max_backorcharge();
    ai_face();
    return;
    }
  #64 max_light6;
  ai_face();
  ai_threats();
}

void() max_light6 = {
{
  #63 max_light7;
  ai_face();
  ai_back(10);
  sound(self, CHAN_VOICE, "weapons/lhit.wav", 1, ATTN_NORM);
  ai_threats();
}

void() max_light7 = {
{
  #62 max_light8;
  ai_face();
  ai_back(10);
  ai_threats();
}

void() max_light8 = {
{
  #61 max_light9;
  ai_face();
  ai_back(10);
}

void() max_light9 = {
{
  #60 max_run;
  movetogoal(25);
}

void() max_shalrath1 = {
{
  #65 max_shalrath2;
  ai_face();
}

void() max_shalrath2 = {
{
  #66 max_shalrath3;
  if (self.flags & FL_ONGROUND) {
    Handle_threats();
    if (shal_clearance()) {
      self.flags = self.flags - FL_ONGROUND;
      self.origin_z = self.origin_z + 1;
      self.velocity_z = 700;
      return;
      }
    self.flags = self.flags - FL_ONGROUND;
    self.origin_z = self.origin_z + 1;
    self.velocity_z = 300;
    }
}

void() max_shalrath3 = {
{
  #67 max_shalrath4;
  ai_face();
  Handle_threats();
  self.pain_finished = time + 0.6;
};

void() max_shalrath4() = {
  #68 max_shalrath5;
  ai_face();
  self.velocity_z = 300;
  Handle_threats();
  sound(self, CHAN_VOICE, "shalrath/attack2.wav", 1, ATTN_NORM);
};

void() max_shalrath5() = {
  #69 max_shalrath6;
  ShalMissile();
};

void() max_shalrath6 = {
{
  #70 max_shalrath7;
  ai_face();
}

void() max_shalrath7 = {
{
  #71 max_shalrath8;
  ai_face();
}

void() max_shalrath8 = {
{
  #72 max_run;
  ai_face();
}

void() max_run = {
{
  if (self.walkframe >= 6) {
    self.walkframe = 0;
    }
  #54 max_run;
  self.frame = 54 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  if (self.flags & FL_ONGROUND) {
    if (self.walkframe == 1 || self.walkframe == 3 || self.walkframe == 5) {
      maxstep();
      }
    }
  ai_maxrun();
  if (self.frolic > time) {
    return;
    }
  if (self.walkframe == 3) {
    self.frolic = time + 2;
    if (random() < 0.2 && !visible(self.enemy)) {
      if (random() < 0.3) {
        sound(self, CHAN_VOICE, "nehahra/max/laugh2.wav", 1, ATTN_NORM);
        }
      else {
        sound(self, CHAN_VOICE, "nehahra/max/laugh.wav", 1, ATTN_NORM);
        }
      }
    }
}

void() max_die = {
var
 num : Real;
 t : Real;
{
  num = random();
  t = self.lives;
  if (t > 0) {
    bprint(ftos(t));
    bprint(" more times to go...|");
    }
  self.walkframe = 0;
  if (num < 0.2) {
    max_diea1();
    }
  else {
    max_diec1();
    }
}

void() max_pain = {
{
  switchmethod(self);
  if (self.pain_finished > time) {
    return;
    }
  self.pain_finished = time + 1;
  #110 max_pain2;
  max_painsound();
}

void() max_pain2 = {
{
  #111 max_pain3;
}

void() max_pain3 = {
{
  #112 max_pain4;
}

void() max_pain4 = {
{
  if (random() < 0.5) {
    #113 max_throw;
    }
  else {
    #113 max_run;
    }
}

void() max_diea1 = {
{
  if (self.walkframe >= 8) {
    self.walkframe = 0;
    self.aflag = 9 + random() + random() + random();
    #94 max_diea2;
    return;
    }
  #87 max_diea1;
  self.frame = 87 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  if (self.walkframe == 4) {
    self.solid = SOLID_NOT;
    }
}

void() max_diea2 = {
{
  if (self.cnt > self.aflag) {
    self.solid = SOLID_SLIDEBOX;
    if (!walkmove(0, 0)) {
      Max_teleportsys();
      }
    else {
      self.lives = self.lives - 1;
      if (self.lives < 0) {
        self.think = maxcorpse;
        self.nextthink = time + 0.1;
        AddToKills(self,self.enemy);
        max_is_dead();
        return;
        }
      self.cnt = 0;
      self.aflag = 0;
      self.health = 500;
      self.walkframe = 0;
      self.takedamage = DAMAGE_AIM;
      #95 max_getup;
      return;
      }
    }
  #94 max_diea2;
  if (self.enemy.items & IT_QUAD) {
    self.cnt = 0;
    }
  else {
    self.cnt = self.cnt + 1;
    }
}

void() max_getup = {
{
  #96 max_getup2;
}

void() max_getup2 = {
{
  #97 max_getup3;
}

void() max_getup3 = {
{
  #98 max_getup4;
  self.pain_finished = time + 1;
  Max_teleportsys();
}

void() max_getup4 = {
{
  #99 max_run;
}

void() max_diec1 = {
{
  if (self.walkframe >= 5) {
    self.walkframe = 0;
    self.aflag = 21 + random() + random() + random();
    #105 max_diec2;
    return;
    }
  #100 max_diec1;
  self.frame = 100 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  if (self.walkframe == 3) {
    self.solid = SOLID_NOT;
    }
}

void() max_diec2 = {
{
  if (self.cnt > self.aflag) {
    self.solid = SOLID_SLIDEBOX;
    if (!walkmove(0, 0)) {
      Max_teleportsys();
      }
    self.lives = self.lives - 1;
    if (self.lives < 0) {
      self.think = maxcorpse;
      self.nextthink = time + 0.1;
      max_is_dead();
      return;
      }
    self.cnt = 0;
    self.aflag = 0;
    self.health = 500;
    self.walkframe = 0;
    self.takedamage = DAMAGE_AIM;
    #106 max_recover;
    return;
    }
  #105 max_diec2;
  if (self.enemy.items & IT_QUAD) {
    self.cnt = 0;
    }
  else {
    self.cnt = self.cnt + 1;
    }
}

void() max_recover = {
{
  #107 max_recover2;
}

void() max_recover2 = {
{
  #108 max_recover3;
  self.pain_finished = time + 1;
  Max_teleportsys();
}

void() max_recover3 = {
{
  #109 max_run;
}

void() max_throw = {
{
  if (self.walkframe >= 8) {
    self.walkframe = 0;
    self.th_run();
    return;
    }
  #79 max_throw;
  self.frame = 79 + self.walkframe;
  self.walkframe = self.walkframe + 1;
  if (self.walkframe == 6) {
    if (random() < 0.2) {
      sound(self.enemy, CHAN_BODY, "nehahra/archg/lift3.wav", 1, ATTN_NORM);
      }
    else {
      sound(self.enemy, CHAN_BODY, "nehahra/archg/lift.wav", 1, ATTN_NORM);
      }
    if (random() < 0.6 && visible(self.enemy)) {
      self.walkframe = self.walkframe - 1;
      }
    }
  if (self.walkframe > 4 && self.walkframe < 7 && self.enemy != world) {
    if (visible(self.enemy)) {
      ThrashEnemy();
      }
    }
  ai_face();
  Handle_Threats();
}

void() Max_teleportsys = {
var
 num : Real;
 t : Real;
{
  if (self.flags & FL_GODMODE) {
    ai_teleport(self, [517 208 1782]);
    return;
    }
  if (self.origin_z > 1750) {
    num = 3;
    }
  else {
    num = self.relations;
    }
  if (num == 1) {
    if (self.method == 0) {
      t = random();
      if (t < 0.2) {
        ai_teleport(self, [88 631 300]);
        return;
        }
      if (t < 0.4) {
        ai_teleport(self, [80 197 300]);
        return;
        }
      if (t < 0.6) {
        ai_teleport(self, [769 235 300]);
        return;
        }
      ai_teleport(self, [759 628 300]);
      return;
      }
    t = random();
    if (t < 0.2) {
      ai_teleport(self, [517.5 200 352]);
      return;
      }
    if (t < 0.4) {
      ai_teleport(self, [412 -592 829]);
      return;
      }
    if (t < 0.6) {
      ai_teleport(self, [629 -587.5 100]);
      return;
      }
    ai_teleport(self, [209 -610.5 100]);
    return;
    }
  if (num == 2) {
    t = random();
    if (t < 0.2) {
      ai_teleport(self, [816 34.5 614]);
      return;
      }
    if (t < 0.4) {
      ai_teleport(self, [775 777 614]);
      return;
      }
    if (t < 0.6) {
      ai_teleport(self, [-31 772 540]);
      return;
      }
    ai_teleport(self, [-11 35 540]);
    return;
    }
  if (num == 3) {
    t = random();
    if (t < 0.2) {
      ai_teleport(self, [783 -579 948]);
      return;
      }
    if (t < 0.4) {
      ai_teleport(self, [31 -578 948]);
      return;
      }
    if (t < 0.6) {
      ai_teleport(self, [773 -272 941]);
      return;
      }
    if (t < 0.8) { 
      ai_teleport(self, [75 -270 941]);
      return;
      }
    ai_teleport(self, [441 587 537]);
    return;
    }
  t = random();
  if (t < 0.2) {
    ai_teleport(self, [413 70 1017.5]);
    return;
    }
  if (t < 0.5) {
    ai_teleport(self, [533 -595 1204]);
    return;
    }
  ai_teleport(self, [297 -580 1205]);
}; 

void() max_survival = {
var
 megadeth : Vector;
 head : Object;
 selected : Object;
 t : Real;
 num : Real;
{
  t = 1000;
  head = find(world, event, "thrett");
  while (head) {
    megadeth = self.origin - head.origin;
    num = vlen(megadeth);
    if (num < t && num < 500) { 
      if (situation(self.origin, head.origin, self)) {
        selected = head;
        }
      }
    head = find(head, event, "thrett");
    }
  if (selected != world) {
    if (selected.classname == "sprocket" && num < 80) {
      if (random() < 0.3) {
        ThrowSprocket(-125);
        remove(selected);
        Max_teleportsys();
        return;
        }
      }
    if (self.brain & FL_CLIENT) {
      if (random() < 0.2) {
        Max_teleportsys();
        return;
        }
      }
    if (random() < 0.9) {
      self.th_melee();
      }
    else {
      Max_teleportsys();
      }
    }
}

void() MaxRedLightning() = {
	local vector org, dir;
	local float num;

	if (self.lives < 3) { GauntLightning(); return; }

	self.effects = self.effects | EF_MUZZLEFLASH;
	ai_face();
	org = self.origin + [0 0 20];
	num = random();
	if (num < 0.2) {
		dir = self.enemy.origin + [0 0 16] - org;
		dir = normalize(dir);
	} else {
		if (num < 0.5) {
			dir = self.enemy.origin - self.enemy.velocity * 0.2;
			dir = normalize(dir - org);
		} else {
			dir = self.enemy.origin - self.enemy.velocity * -0.2;
			dir = normalize(dir - org);
		}
	}
	traceline(org, self.origin + dir * 600, 1, self);
	QC_ParseBeam(0,"progs/nehahra/beam.mdl", self, org, trace_endpos, 32);
	LightningDamage(org, trace_endpos, self, MOVETYPE_TOSS);
}

void() max_s_light1 = [60, max_s_light2] {
	ai_face();
	ai_threats();
	sound(self, CHAN_WEAPON, "shambler/sattck1.wav", 1, ATTN_NORM);
}

void() max_s_light2 = {
  #61 max_s_light3;
  ai_threats();
  ai_face();
};

void() max_s_light3 = {
  #62 max_s_light4;
  ai_face();
  ai_threats();
  sound(self, CHAN_ITEM, "shambler/sboom.wav", 1, ATTN_NORM);
};

void() max_s_light4 = {
  #63 max_s_light5;
  ai_face();
  ai_threats();
  max_backorcharge();
  if (random() < 0.5) {
    sound(self, CHAN_BODY, "weapons/lhit.wav", 1, ATTN_NORM);
    }
  self.effects = self.effects | EF_MUZZLEFLASH;
};

void() max_s_light5 = {
  if (visible(self.enemy) && self.enemy.health > 1) {
    #64 max_s_light4;
    CastLightning();
    max_backorcharge();
    ai_threats();
    ai_face();
    exit;
    }
  #64 max_s_light6;
  ai_face();
  ai_threats();
};

void() max_s_light6 = {
  #63 max_s_light7;
  ai_face();
  ai_back(10);
  ai_threats();
  sound(self, CHAN_VOICE, "weapons/lhit.wav", 1, ATTN_NORM);
};

void() max_s_light7 = {
  #62 max_s_light8;
  ai_face();
  ai_back(10);
};

void() max_s_light8 = {
  #61 max_s_light9;
  ai_face();
  ai_back(10);
};

void() max_s_light9 = {
  #60 max_run;
  movetogoal(25);
};

void() max_rapidfire1 = {
  #73 max_rapidfire2;
  self.pain_finished = time + 0.5;
  ai_threats();
}

void() max_rapidfire2 = {
{
  #74 max_rapidfire3;
  ai_face();
  ai_threats();
}

void() max_rapidfire3 = {
{
  #75 max_rapidfire4;
  ai_face();
  ai_threats();
}

void() max_rapidfire4 = {
{
  #76 max_rapidfire5;
  self.cnt = 0;
  ai_face();
  ai_threats();
}

void() max_rapidfire5 = {
{
  if (!visible(self.enemy)) {
    self.th_run();
    return;
    }
  if (self.enemy.health < 1) {
    self.th_stand();
    return;
    }
  #77 max_rapidfire6;
  self.cnt = self.cnt + 1;
  ai_face();
  max_shootfire();
  max_backorcharge();
  ai_threats();
}

void() max_rapidfire6 = {
{
  if (self.cnt > 8 || vlen(self.origin - self.enemy.origin) > 330) {
    self.cnt = 0;
    #76 max_rapidfire7;
    ai_face();
    ai_threats();
    }
  else {
    #78 max_rapidfire5;
    ai_face();
    self.effects = self.effects | EF_MUZZLEFLASH;
    max_shootfire();
    Max_Survival();
    ai_threats();
    }
}

void() max_rapidfire7 = {
{
  #75 max_rapidfire8;
  ai_threats();
}

void() max_rapidfire8 = {
{
  #74 max_run;
  ai_threats();
}

void() ThrowSprocket(dm : Real);
var
 new : Object;
{
  new = spawn();
  new.origin = self.origin;
  setmodel(new, "progs/nehahra/sprocket.mdl");
  setsize(new, [-16 -16 0], [16 16 56]);
  new.velocity = VelocityForDamage(dm);
  new.movetype = MOVETYPE_BOUNCE;
  new.solid = SOLID_TRIGGER;
  new.classname = "gib";
  new.avelocity_x = random() * 600;
  new.avelocity_y = random() * 600;
  new.avelocity_z = random() * 600;
  new.touch = spftouch;
  new.think = SUB_Remove;
  new.ltime = time;
  new.nextthink = time + MOVETYPE_FLY + random() * MOVETYPE_TOSS;
  new.frame = 0;
  new.flags = 0;
}

void() spftouch();
var
 v : Vector;
{
  if (pointcontents(self.origin) == CONTENT_LAVA) {
    sound(self, CHAN_AUTO, "nehahra/weapons/sprocket.wav", 0.5, ATTN_NORM);
    self.think = Sub_remove;
    self.nextthink = time + 2;
    return;
    }
  if (pointcontents(self.origin + self.velocity) == CONTENT_SOLID) {
    if (self.pain_finished > time) {
      }
    else {
      self.pain_finished = time + 0.2;
      if (random() < 0.9) {
        sound(self, CHAN_ITEM, "nehahra/weapons/sprfall2.wav", 0.8, ATTN_NORM);
        } else {
        sound(self, CHAN_ITEM, "nehahra/weapons/sprfall1.wav", 0.8, ATTN_NORM);
        }
      }
    }
  if (other.classname != "player") {
    return;
    }
  if (self.origin_z > other.origin_z) {
    return;
    }
  if (self.pain_finished > time) {
    } else {
    self.pain_finished = time + 0.2;
    sound(other, CHAN_WEAPON, "nehahra/weapons/sprfall2.wav", 0.8, ATTN_NORM);
    }
  v_x = other.velocity_x * WEAPON_ROCKET + 20 * random();
  v_y = other.velocity_y * WEAPON_ROCKET + 20 * random();
  v_z = 300 * random() + (other.velocity_z + other.velocity_x) * 0.3;
  self.flags = self.flags - (self.flags & FL_ONGROUND);
  self.velocity = v;
  self.avelocity = [100 100 100];
};

void() max_is_dead = {
	local entity head, mark;

	self.meleeattack = 666;
	mark = spawn();
	mark.think = play_secj;
	mark.nextthink = time + 0.5;
	head = find(world, targetname, "deadmax");
	if (head == world) {
		dprint("No maxdead targetname|");
		return;
	}
	remove(head);
	spawn_opens_hit();
	spawn_finalerubble();
	head = find(world, sky, "end");
	while(head) {
		if (random() < 0.5) {
			head.health = -100;
			head.think = Throwgibs;
			head.nextthink = time + (20 * random());
		}
		head = find(head, sky, "end");
	}
};

void() free_a_soul = {
	local entity soul;
	local vector vec;
	local float num;

	vec_x = random() * 300;
	if (random() < 0.4) {
	vec_x = vec_x * -1;
	}
	vec_y = random() * 300;
	if (random() > 0.5) {
	vec_x = vec_x * -1;
	}
	vec_z = random() * 500;
	soul = spawn();
	soul.origin = self.origin - [0 0 20];
	setmodel(soul, "progs/nehahra/soul.mdl");
	soul.solid = SOLID_NOT;
	soul.movetype = MOVETYPE_NOCLIP;
	soul.effects = soul.effects | EF_DIMLIGHT;
	setsize(soul, VEC_HULL_MIN, [16 16 16]);
	soul.velocity = vec;
	num = 5 - self.relations;
	soul.nextthink = time + (5 * num);
	soul.think = Sub_remove;
};

void() maxcorpse = {
{
  free_a_soul();
  self.think = maxcorpse;
  self.nextthink = time + random() + random();
}

void() max_quadfudge = {
var
 vec : Vector;
 num : Real;
 megadeth : Vector;
{
  if (!(self.enemy.items & IT_QUAD)) {
    return 0;
    }
  if (visible(self.enemy)) {
    return 0;
    }
  if (situation(self.origin, self.enemy.origin, self)) {
    return 0;
    }
  megadeth = self.origin - self.enemy.origin;
  if (vlen(megadeth) < 800) {
    return 0;
    exit;
    }
  num = random();
  if (self.relations < 2) {
    if (num < 0.3) {
      vec = [521 336 -35];
      }
    else {
      if (num < 0.7) {
        vec = [320 336 -35];
        }
      else {
        vec = [880 656 -35];
        }
      }
    }
  if (self.relations == 2 || self.relations == 3) {
    if (num < 0.2) {
      vec = [323.5 -808 478];
      }
    else {
      if (num < 0.5) {
        vec = [503 -871 478];
        }
      else {
        if (num < 0.8) {
          vec = [319 329 476];
          }
        else {
          vec = [518 352 476];
          }
        }
      }
    }
  if (self.relations > 3) {
    if (num < 0.2) {
      vec = [555 611 860];
      }
    else {
      if (num < 0.5) {
        vec = [751 256 860];
        }
      else {
        if (num < 0.8) {
          vec = [80 483 860];
          }
        else {
          vec = [436 -378 893];
          }
        }
      }
    }
  if (situation(vec, self.enemy.origin, self)) {
    return 0;
    }
  else {
    if (self.flags & FL_ONGROUND) {
      self.flags = self.flags - FL_ONGROUND;
      }
    self.origin = vec;
    max_qwait();
    return 1;
    }
}

void() max_qwait = {
{
  if (!(self.enemy.items & IT_QUAD)) {
    self.th_run();
    exit;
    }
  if (visible(self.enemy)) {
    max_gauntrang1();
    exit;
    }
  if (self.walkframe >= 10) {
    self.walkframe = 0;
    }
  #0 max_qwait;
  self.frame = self.walkframe;
  self.walkframe = self.walkframe + 1;
  ai_face();
}

void() spawn_finalerubble = {
var
 mark : Object;
{
  mark = spawn();
  mark.owner = self;
  mark.think = setup_finalerubble;
  mark.nextthink = time + 1;
}

void() setup_finalerubble = {
{
  spawn_rubblefall([-21 -242 962]);
  spawn_rubblefall([-6 -630 970]);
  spawn_rubblefall([844 -901 981]);
  spawn_rubblefall([817 -326 990]);
  spawn_rubblefall([567 -351 714]);
  spawn_rubblefall([270 -215 714]);
  spawn_rubblefall([-21 -242 962]);
  spawn_rubblefall([-6 -630 970]);
  spawn_rubblefall([844 -901 981]);
  spawn_rubblefall([817 -326 990]);
  spawn_rubblefall([567 -351 714]);
  spawn_rubblefall([270 -215 714]);
  if (self.owner.relations > 3) {
    spawn_rubblefall([565 273 1157]);
    spawn_rubblefall([552 447 1157]);
    spawn_rubblefall([287 418 1157]);
    spawn_rubblefall([283 254 1165]);
    spawn_rubblefall([191 -244 1111]);
    spawn_rubblefall([537 -244 1111]);
    spawn_rubblefall([410 340 1675]);
    spawn_rubblefall([565 273 1157]);
    spawn_rubblefall([552 447 1157]);
    spawn_rubblefall([287 418 1157]);
    spawn_rubblefall([283 254 1165]);
    spawn_rubblefall([191 -244 1111]);
    spawn_rubblefall([537 -244 1111]);
    spawn_rubblefall([410 340 1675]);
    }
  spawn_rubblefall([597 -716 192]);
  spawn_rubblefall([597 -693 192]);
  spawn_rubblefall([239 -493 192]);
  spawn_rubblefall([240 -734 192]);
  spawn_rubblefall([753 78 628.5]);
  spawn_rubblefall([-97 159 635]);
  spawn_rubblefall([96 899 635]);
  spawn_rubblefall([587 808 647]);
  spawn_rubblefall([426 410 606]);
  spawn_rubblefall([509 213 343]);
  spawn_rubblefall([311 220 343]);
  spawn_rubblefall([597 -716 192]);
  spawn_rubblefall([597 -693 192]);
  spawn_rubblefall([239 -493 192]);
  spawn_rubblefall([240 -734 192]);
  spawn_rubblefall([753 78 628.5]);
  spawn_rubblefall([-97 159 635]);
  spawn_rubblefall([96 899 635]);
  spawn_rubblefall([587 808 647]);
  spawn_rubblefall([426 410 606]);
  spawn_rubblefall([509 213 343]);
  spawn_rubblefall([311 220 343]);
  self.think = finalesnds;
  self.nextthink = time + 10;
}

void() spawn_rubblefall(vec : Vector);
var
  head : Object;
{
  head = spawn();
  head.origin = vec;
  setorigin(head, vec);
  head.cnt = 500 * random();
  head.health = -90;
  head.think = throwsomerub;
  head.nextthink = time + (random() * 20);
}

void() throwsomerub = {
{
  ThrowRubble("progs/nehahra/rubble4.mdl", -10);
  ThrowRubble("progs/nehahra/rubble6.mdl", -20);
  ThrowRubble("progs/nehahra/rubble1.mdl", -10);
  sound(self, CHAN_AUTO, "nehahra/wall/wall01.wav", 1, ATTN_NONE);
  self.think = Sub_remove;
  self.nextthink = time + 2;
}

void() finalesnds = {
	local float num;

	num = random();
	if (num < 0.2) {
		sound(self, CHAN_AUTO, "zerstorer/ambience/thunder2.wav", 1, ATTN_NONE);
	} else {
		if (num < 0.5)
			sound(self, CHAN_AUTO, "nehahra/sets/set4_2.wav", 1, ATTN_NONE);
		else
			sound(self, CHAN_AUTO, "nehahra/sets/set4_1.wav", 1, ATTN_NONE);
	}
	self.think = finalesnds;
	self.nextthink = time + 3;
};

void() spawn_lightshow = {
var
 mark : Object;
{
  mark = spawn();
  mark.origin = self.origin;
  mark.cnt = 0;
  mark.method = 0;
  mark.health = 1;
  mark.think = fogflash;
  mark.nextthink = time + random();
}

void() fogflash = {
var
  head : Object;
  num : Real;
{
  num = 0;
  if (self.health) {
    self.health = 0;
    num = 1;
    }
  head = find(world, classname, "player");
  while (head) {
    if (num == 1) {
      Safe_stuffcmd(head, "gl_fogdensity 0.2|");
      }
    if (self.method == 0) {
      Safe_stuffcmd(head, "gl_fogdensity 0.2|");
      Safe_stuffcmd(head, "gl_fogenable 1|");
      self.method = 1;
      }
    else {
      Safe_stuffcmd(head, "gl_fogenable 0|");
      self.method = 0;
      }
    head = find(head, classname, "player");
    }
  self.cnt = self.cnt + 1;
  if (self.cnt > 250 && self.method == 0) {
    self.think = Sub_remove;
    self.nextthink = time + 2;
    exit;
    }
  if (self.method == 1) {
    self.nextthink = time;
    }
  else {
    self.nextthink = time + 0.1;
    }
}

void() spawn_maxcontrol = {
var
 mark : Object;
{
  mark = spawn();
  setorigin(mark, self.origin);
  mark.charmer = self;
  mark.nojump = 0;
  mark.regen = 0;
  mark.lives = 0;
  mark.blink = 0;
  mark.brain = 0;
  mark.cnt = 0;
  mark.relations = 0;
  mark.think = comment_think;
  mark.nextthink = time + 0.2;
}

void() comment_think = {
var
 head : Object;
 megadeth : Vector;
{
  if (self.charmer.talk_finished > time) {
    self.think = comment_think;
    self.nextthink = time + 0.5;
    return;
    }
  if (self.charmer.health < 1 && self.charmer.lives < 1) {
    spawn_lightshow();
    self.cnt = 0;
    head = find(world, classname, "player");
    while (head) {
      head.flags = head.flags | FL_FLEE;
      head = find(head, classname, "player");
      }
    self.enemy = head;
    becomeearthquake();
    return;
    }
  if (self.charmer.think != max_stand) {
    self.think = comment_think;
    self.nextthink = time + 2;
    return;
    }
  if (deathmatch || coop) {
    self.think = comment_think;
    self.nextthink = time + 0.5;
    return;
    }
  head = find(world, classname, "player");
  if (head != world) {
    self.enemy = head;
    }
  self.noise = "NO";
  self.brain = 0;
  head = self.enemy;
  megadeth = self.charmer.origin - head.origin;
  if (head.health < 1) {
    if (head.watertype == -5) {
      if (random() < 0.4) {
        sound(head, CHAN_VOICE, "nehahra/max/lava1.wav", 1, ATTN_NORM);
        self.charmer.talk_finished = time + 3;
        remove(self);
        return;
        }
      sound(head, CHAN_VOICE, "nehahra/max/lava2.wav", 1, ATTN_NORM);
      self.charmer.talk_finished = time + 3;
      remove(self);
      return;
      }
    if (self.enemy.classname == "player" && vlen(megadeth) < 400) {
      if (head.lives > 0) {
        if (self.relations) {
          self.cnt = self.cnt + 1;
          if (self.cnt > 90) {
            if (random() < 0.3) {
              comment_waiting();
              }
            self.cnt = 0;
            }
          }
        else {
          if (head.boost > 0) {
            if (comment_blunder()) {
              self.think = comment_think;
              self.nextthink = time + 0.5;
              return;
              }
            }
          if (head.lives == 1 && self.charmer.lives > 3) {
            comment_case1();
            }
          else {
            if (head.lives > 1 && self.charmer.lives < 3) {
              comment_case2();
              }
            else {
              comment_case3();
              }
            }
          }
        }
      else {
        if (!coop && !deathmatch) {
          self.charmer.tolerate = 1;
          self.think = comment_final;
          self.nextthink = time;
          return;
          }
        }
      }
    }
  else {
    if (self.relations == 1) {
      self.relations = 0;
      }
    }
  self.think = comment_think;
  self.nextthink = time + 0.2;
}

void() becomeearthquake = {
	local entity head;

	sound(self, CHAN_AUTO, "nehahra/quake/inv3.wav", 1, ATTN_NONE);
	self.cnt = self.cnt + 1;
	if (self.cnt > 8) {
		head = find(world, classname, "player");
		while(head) {
			head.flags = head.flags - FL_FLEE;
			head = find(head, classname, "player");
		}
		remove(self);
		return;
	}
	self.think = becomeearthquake;
	self.nextthink = time + 2;
};

void() comment_waiting = {
{
  if (!(self.regen & FL_MONSTER)) {
    self.regen = self.regen | FL_MONSTER;
    self.noise = "nehahra/max/allday.wav";
    } else {
    if (!(self.regen & FL_GODMODE)) {
      self.regen = self.regen | FL_GODMODE;
      self.noise = "nehahra/max/taketime.wav";
      } else {
      if (!(self.regen & FL_NOTARGET)) {
        self.regen = self.regen | FL_NOTARGET;
        self.noise = "nehahra/max/suspense.wav";
        }
      }
    }
  if (self.noise == "NO") {
    if (random() < 0.5) {
      if (random() < 0.3) {
        self.noise = "nehahra/max/laugh.wav";
        } else {
        self.noise = "nehahra/max/laugh2.wav";
        }
      }
    }
  if (self.noise != "NO") {
    make_comment();
    }
};

void() comment_blunder = {
  if (self.enemy.boost == 1) {
    if (!(self.jump_flag & FL_CLIENT)) {
      self.jump_flag = self.jump_flag | FL_CLIENT;
      self.noise = "nehahra/max/grenade.wav";
      }
    }
  else {
    if (self.enemy.boost == 3) {
      if (!(self.jump_flag & FL_ITEM)) {
        self.jump_flag = self.jump_flag | FL_ITEM;
        self.noise = "nehahra/max/gravity.wav";
        }
      else {
        if (!(self.jump_flag & FL_ONGROUND)) {
          self.jump_flag = self.jump_flag | FL_ONGROUND;
          self.noise = "nehahra/max/bird.wav";
          }
        }
      }
    if (self.noise == "NO") {
      if (self.enemy.boost == 2) {
        if (!(self.jump_flag & FL_INWATER)) {
          self.jump_flag = self.jump_flag | FL_INWATER;
          self.noise = "nehahra/max/pathetic.wav";
          }
        else {
          if (!(self.jump_flag & FL_MONSTER)) {
            self.jump_flag = self.jump_flag | FL_MONSTER;
            self.noise = "nehahra/max/betray.wav";
            }
          else {
            if (!(self.jump_flag & FL_GODMODE)) {
              self.jump_flag = self.jump_flag | FL_GODMODE;
              self.noise = "nehahra/max/cantkill.wav";
              }
            else {
              if (!(self.jump_flag & FL_NOTARGET)) {
                self.jump_flag = self.jump_flag | FL_NOTARGET;
                self.noise = "nehahra/max/hurt.wav";
                }
              }
            }
          }
        }
      }
    }
  if (self.noise == "NO") {
    if (random() < 0.5) {
      if (random() < 0.3) {
        self.noise = "nehahra/max/laugh.wav";
        }
      else {
        self.noise = "nehahra/max/laugh2.wav";
        }
      }
    }
  if (self.noise != "NO") {
    self.relations = 1;
    self.enemy.boost = 0;
    make_comment();
    return 1;
    }
  else {
    return 0;
    }
}

void() comment_case1 = {
{
  if (!(self.regen & FL_ITEM)) {
    self.regen = self.regen | FL_ITEM;
    self.noise = "nehahra/max/comeback.wav";
    }
  else {
    if (!(self.regen & FL_ONGROUND)) {
      self.regen = self.regen | FL_ONGROUND;
      self.noise = "nehahra/max/pathop.wav";
      }
    else {
      if (!(self.regen & FL_PARTIALGROUND)) {
        self.regen = self.regen | FL_PARTIALGROUND;
        self.noise = "nehahra/max/onelife.wav";
        }
      }
    }
  if (self.noise != "NO") {
    self.relations = 1;
    make_comment();
    }
}

void()() comment_case2 = {
  if (!(self.regen & FL_WATERJUMP)) {
    self.regen = self.regen | FL_WATERJUMP;
    self.noise = "nehahra/max/worthop.wav";
    } else {
    if (!(self.regen & FL_JUMPRELEASED)) {
      self.regen = self.regen | FL_JUMPRELEASED;
      self.noise = "nehahra/max/nerves.wav";
      } else {
      if (!(self.regen & FL_BLOODLESS)) {
        self.regen = self.regen | FL_BLOODLESS;
        self.noise = "nehahra/max/eager.wav";
        }
      }
    }
  if (self.noise != "NO") {
    self.relations = 1;
    make_comment();
    }
}

void() comment_case3 = {
{
  if (!(self.regen & FL_FLY)) {
    self.regen = self.regen | FL_FLY;
    self.noise = "nehahra/max/tempor.wav";
    }
  else {
    if (!(self.regen & FL_SWIM)) {
      self.regen = self.regen | FL_SWIM;
      self.noise = "nehahra/max/humanity.wav";
      }
    else {
      if (!(self.regen & FL_CLIENT)) {
        self.regen = self.regen | FL_CLIENT;
        self.noise = "nehahra/max/yorick.wav";
        }
      else {
        if (!(self.regen & FL_INWATER)) {
          self.regen = self.regen | FL_INWATER;
          self.noise = "nehahra/max/fun.wav";
          }
        }
      }
    }
  if (self.noise == "NO") {
    if (random() < 0.5) {
      if (random() < 0.3) {
        self.noise = "nehahra/max/laugh.wav";
        }
      else {
        self.noise = "nehahra/max/laugh2.wav";
        }
      }
    }
  if (self.noise != "NO") {
    self.relations = 1;
    make_comment();
    }
}

void() comment_final = {
	local float num;

	self.charmer.talk_finished = time + 3;
	num = random();
	if (self.charmer.lives == 1) {
		if (num < 0.3) {
			self.noise = "nehahra/max/handful.wav";
			self.cnt = 3;
			ending1();
			return;
		}
		self.noise = "nehahra/max/tainted.wav";
		self.cnt = 2;
		ending1();
		return;
	}
	if (self.charmer.lives > 3) {
		if (num < 0.2) {
      self.noise = "nehahra/max/inconsid.wav";
      self.cnt = 18;
      ending1();
      return;
		} else {
			if (num < 0.6) {
				self.noise = "nehahra/max/dull.wav";
				self.cnt = 2;
			} else {
				self.noise = "nehahra/max/iamgod.wav";
				self.cnt = 3;
			}
      ending1();
      return;
      }
    }
  num = num + random();
  if (num < 0.3) {
    self.noise = "nehahra/max/death.wav";
    self.cnt = 3.5;
    }
  else {
    if (num < 0.6) {
      self.noise = "nehahra/max/towin.wav";
      self.cnt = 17;
      }
    else {
      if (num < 0.9) {
        self.noise = "nehahra/max/witty.wav";
        self.cnt = 3;
        }
      else {
        if (num < 1.2) {
          self.noise = "nehahra/max/nehah.wav";
          self.cnt = 7;
          }
        else {
          if (num < 1.6) {
            self.noise = "nehahra/max/enjoy.wav";
            self.cnt = 6.5;
            } else {
            self.noise = "nehahra/max/twisted.wav";
            self.cnt = 10;
            }
          }
        }
      }
    }
	ending1();
};

void() ending1 = {
	self.charmer.talk_finished = time + 3;
	Safe_stuffcmd(self.enemy,  "play ");
	Safe_stuffcmd(self.enemy, self.noise);
	Safe_stuffcmd(self.enemy, "|");
	self.relations = 1;
	self.think = remove_max;
	self.nextthink = time + self.cnt;
};

void() remove_max = {
	spawn_tfog(self.charmer.origin);
	remove(self.charmer);
	remove(self);
};

void() make_comment = {
	self.charmer.talk_finished = time + 3;
	Safe_stuffcmd(self.enemy,  "play ");
	Safe_stuffcmd(self.enemy, self.noise);
	Safe_stuffcmd(self.enemy, "|");
};

void() opens_hit_it = {
  Sub_UseTargets();
  remove(self);
};

void() spawn_opens_hit = {
	local entity mark;

	mark = spawn();
	mark.target = "deadmax";
	mark.think = opens_hit_it;
	mark.nextthink = time + 0.2;
};

void() spawn_mister = {
	local entity head;

	head = spawn();
	head.solid = SOLID_SLIDEBOX;
	head.movetype = MOVETYPE_STEP;
	head.model = "progs/nehahra/maxwell.mdl";
	head.classname = "the_mister";
	setmodel(head, "progs/nehahra/maxwell.mdl");
	setorigin(head, [429 -828 988]);
	setsize(head, VEC_HULL_MIN, VEC_HULL_MAX);
	head.yaw_speed = 80;
	head.health = 900;
	head.xgoal = [0 0 0];
	head.th_stand = max_begin;
	head.th_walk = max_stroll;
	head.th_missile = max_attack;
	head.th_melee = max_throw;
	head.th_run = max_run;
	head.th_pain = max_pain;
	head.th_die = max_die;
	head.th_special = max_qwait;
	head.origin_z = head.origin_z + 1;
	head.takedamage = DAMAGE_AIM;
	head.ideal_yaw = head.angles * [0 1 0];
	head.view_ofs = [0 0 28];
	head.lives = 5;
	head.use = monster_use;
	head.flags = head.flags | FL_MONSTER;
	head.pausetime = 100000000;
	head.think = head.th_stand;
	head.classtype = CT_MONMISTERMAX;
	head.nextthink = head.nextthink + random() * 0.5;
};

void() monster_mistermax = { spawn_mister(); };