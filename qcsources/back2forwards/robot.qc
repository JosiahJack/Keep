$frame base1

$frame stand1

$frame walk1 walk2 walk3 walk4 walk5 walk6

$frame	run1 run2 run3 run4 run5 run6

void () robot_stand =[	$stand1,	robot_stand	] {ai_stand();};

void() robot_walk1		=[      $walk1,        robot_walk2 ] {ai_walk(20);};
void() robot_walk2       =[      $walk2,        robot_walk3 ] {ai_walk(17);};
void() robot_walk3       =[      $walk3,        robot_walk4 ] {ai_walk(13);};
void() robot_walk4       =[      $walk4,        robot_walk5 ] {ai_walk(20);};
void() robot_walk5       =[      $walk5,        robot_walk6 ] {ai_walk(15);};
void() robot_walk6       =[      $walk6,        robot_walk1 ] {ai_walk(13);};

void() robot_run1		=[      $walk1,        robot_run2 ] {ai_run(20);};
void() robot_run2       =[      $walk2,        robot_run3 ] {ai_forward(17);};
void() robot_run3       =[      $walk3,        robot_run4 ] {ai_forward(13);};
void() robot_run4       =[      $walk4,        robot_run5 ] {ai_run(20);};
void() robot_run5       =[      $walk5,        robot_run6 ] {ai_forward(15);};
void() robot_run6       =[      $walk6,        robot_run1 ] {ai_forward(13);};

void() robot_fire1 = [ $stand1, robot_run1 ] {bprint("robot attack!\n"); self.nextthink = time + 1;};

void () monster_robot =
{
	self.classname = "monster_robot";
	precache_model ("progs/robot.mdl");

	setorigin (self,self.origin + '0 0 10');
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel (self, "progs/robot.mdl");

	setsize (self, VEC_HULL2_MIN, VEC_HULL2_MAX);
	self.health = 1000;

	self.th_stand = robot_stand;
	self.th_walk = robot_walk1;
	self.th_run = robot_run1;
	self.th_die = SUB_Remove;
// 	self.th_missile = robot_fire1;
	self.frame = $stand1 ;
	
	walkmonster_start();
};
