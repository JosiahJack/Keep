void() polyp_wake1;
void() polyp_pain;
void() polyp_float1;

.float		statevis;
.float		polyp_speed;

void() polypcheckdist =
{
	local	vector	dist;
        local   vector  dist2;
	local	float	d;
        local   float   d2;
        local vector org;
        local entity head;
        local   float   temp76;

	local vector		mtemp;
	local	vector	org;
	local	float	ass; //temp for debug
	local	vector	org_flat;
	local	vector	oldorg_flat;
	
	local	vector	oldorg; //velocity fix
	local	vector	reqvel;
	
	local	float	speedmulti;

	self.polyp_speed = self.polyp_speed * 0.95;

	
	if (self.polyp_speed < 14)

		self.polyp_speed = 35;
	//bprint (ftos(self.polyp_speed));
	//bprint ("\n");
	
	oldorg = self.origin;
	self.movetype = MOVETYPE_STEP;
	
	
	self.attack_state = AS_STRAIGHT;
	
	dist = self.enemy.origin - self.origin;
        dist_z = 0;
	
	d = vlen(dist);

        if (d < 200 && visible(self.enemy)) //close to the player and can see the player
        {
        	self.attack_state = AS_SLIDING;
	        ai_run(self.polyp_speed * -1.5);
        }

        else if (d < 200 && !visible(self.enemy)) //close to the player but can't see the player
                ai_run(self.polyp_speed);

        else if (d > 200 && d <= 400)
       	{
       		ai_run(self.polyp_speed * (d/400));
        	self.attack_state = AS_SLIDING;
	        ai_run(self.polyp_speed);
        	self.attack_state = AS_STRAIGHT;
	}
	
        else if (d >= 400)
                ai_run(self.polyp_speed * 2);




	if (self.lip == 0)
	{
	self.movetype = MOVETYPE_FLY;
	speedmulti = vlen (self.origin - oldorg);
	reqvel = normalize(self.origin - oldorg) * speedmulti * 7;
	
	setorigin (self, oldorg);
	self.velocity = reqvel;
	}
	if (self.lip == 1)
		self.lip = 0;


};


void() PolypFoundTarget =
{
	if (self.enemy.classname == "player")
	{	// let other monsters see this monster for a while
		sight_entity = self;
		sight_entity_time = time;
	}
	
	self.show_hostile = time + 1;		// wake up other monsters
	self.goalentity = self.enemy;
	SightSound ();
	
	//self.pain_finished = time + 5;
	if (self.startonground == 1)
		self.think = polyp_wake1;
	else
		self.think = self.th_run;
	self.nextthink = time + 0.1;

};



float() PolypFindTarget =
{
	local entity	client;
	local float		r;

// if the first spawnflag bit is set, the monster will only wake up on
// really seeing the player, not another monster getting angry

// spawnflags & 3 is a big hack, because zombie crucified used the first
// spawn flag prior to the ambush flag, and I forgot about it, so the second
// spawn flag works as well
	if (sight_entity_time >= time - 0.1 && !(self.spawnflags & 3) )
	{
		client = sight_entity;
		if (client.enemy == self.enemy)
			return;
	}
	else
	{
		client = checkclient ();
		if (!client)
			return FALSE;	// current check entity isn't in PVS
	}

	if (client == self.enemy)
		return FALSE;

	if (client.flags & FL_NOTARGET)
		return FALSE;
	if (client.items & IT_INVISIBILITY)
		return FALSE;

	r = range (client);
	if (r == RANGE_FAR)
		return FALSE;
		
	if (!visible (client))
		return FALSE;

	if (r == RANGE_NEAR)
	{
		if (client.show_hostile < time && !infront (client))
			return FALSE;
	}
	else if (r == RANGE_MID)
	{
		if (!infront (client))
			return FALSE;
	}
	
//
// got one
//
	self.enemy = client;
	if (self.enemy.classname != "player")
	{
		self.enemy = self.enemy.enemy;
		if (self.enemy.classname != "player")
		{
			self.enemy = world;
			return FALSE;
		}
	}
	
	PolypFoundTarget ();

	return TRUE;
};



//==============================================

void() ai_polyp_stand =
{
	if (PolypFindTarget ())
		return;
	
};



/*
==============================================================================

Polyp

==============================================================================
*/

$cd id1/models/tarbaby
$origin 0 0 24
$base base		

$skin skin

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10 idle11

$frame walk1 walk2 walk3 walk4  walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16 walk17 walk18 walk19
$frame walk20 walk21 walk22 walk23 walk24 walk25

$frame run1 run2 run3 run4 run5 run6  run7 run8 run9 run10 run11 run12 run13
$frame run14 run15 run16 run17 run18 run19 run20 run21 run22 run23
$frame run24 run25

$frame rise1 rise2 rise3 rise4 rise5 rise6

$frame twist1 twist2 twist3 twist4  twist5 twist6 twist7 twist8 twist9 twist10
$frame twist11 twist12 twist13 twist14 twist15

$frame bite1 bite2 bite3 bite4  bite5 bite6 bite7 bite8 bite9 bite10

$frame chomp1 chomp2 chomp3 chomp4  chomp5 chomp6 chomp7 chomp8

$frame gulp1 gulp2 gulp3 gulp4  gulp5 gulp6 gulp7 gulp8 gulp9 gulp10
$frame gulp11 gulp12 gulp13 gulp14

$frame slump1 slump2 slump3 slump4 slump5 slump6

$frame launch1 launch2 launch3 launch4 launch5 launch6  launch7 launch8 launch9 launch10 launch11 launch12 launch13

$frame launchb1 launchb2 launchb3 launchb4 launchb5 launchb6  launchb7 launchb8 launchb9 launchb10 launchb11 launchb12 launchb13 launchb14

$frame jump1 jump2 jump3 jump4 jump5 jump6

$frame fly1 fly2 fly3 fly4

$frame exp

$frame tele1 tele2 tele3
        

void()  polyp_stand0    =[      $idle11,         polyp_stand1    ] 
{
	setmodel (self, "progs/polyp.mdl");
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.view_ofs = '0 0 -8';
	self.th_stand = polyp_float1;
	

	self.origin_z = self.origin_z + 1;      // raise off floor a bit
	droptofloor();

};

void()  polyp_stand1    =[      $idle1,         polyp_stand2    ] {ai_polyp_stand();};
void()  polyp_stand2    =[      $idle2,         polyp_stand3    ] {ai_polyp_stand();};
void()  polyp_stand3    =[      $idle3,         polyp_stand4    ] {ai_polyp_stand();};
void()  polyp_stand4    =[      $idle4,         polyp_stand5    ] {ai_polyp_stand();};
void()  polyp_stand5    =[      $idle5,         polyp_stand6    ] {ai_polyp_stand();};
void()  polyp_stand6    =[      $idle6,         polyp_stand7    ] {ai_polyp_stand();};
void()  polyp_stand7    =[      $idle7,         polyp_stand8    ] {ai_polyp_stand();};
void()  polyp_stand8    =[      $idle8,         polyp_stand9    ] {ai_polyp_stand();};
void()  polyp_stand9    =[      $idle9,         polyp_stand10   ] {ai_polyp_stand();};
void()  polyp_stand10   =[      $idle10,        polyp_stand11   ] {ai_polyp_stand();};
void()  polyp_stand11   =[      $idle11,        polyp_stand1    ] {ai_polyp_stand();};

void()  polyp_wake1    =[      $launchb1,         polyp_wake2    ] {self.th_pain = polyp_pain;/*setsize (self, '-16 -16 -24', '16 16 20');*/};
void()  polyp_wake2    =[      $launchb2,         polyp_wake3    ] {/*setsize (self, '-16 -16 -8', '16 16 22');*/};
void()  polyp_wake3    =[      $launchb3,         polyp_wake4    ] {/*setsize (self, '-16 -16 -8', '16 16 24');*/};
void()  polyp_wake4    =[      $launchb4,         polyp_wake5    ] {/*setsize (self, '-16 -16 -8', '16 16 26');*/};
void()  polyp_wake5    =[      $launchb5,         polyp_wake6    ] {/*setsize (self, '-16 -16 -8', '16 16 28');*/};
void()  polyp_wake6    =[      $launchb6,         polyp_wake7    ] 
{

	self.movetype = MOVETYPE_FLY;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.velocity = '0 0 25';
	/*setsize (self, '-16 -16 -8', '16 16 30');*/
};
void()  polyp_wake7    =[      $launchb7,         polyp_wake8    ] {self.velocity = '0 0 50';/*setsize (self, '-16 -16 -8', '16 16 32');*/};
void()  polyp_wake8    =[      $launchb8,         polyp_wake9    ] {self.velocity = '0 0 175';/*setsize (self, '-16 -16 -8', '16 16 34');*/};
void()  polyp_wake9    =[      $launchb9,         polyp_wake10   ] {self.velocity = '0 0 125';/*setsize (self, '-16 -16 -8', '16 16 36');*/};
void()  polyp_wake10   =[      $launchb10,        polyp_wake11   ] {self.velocity = '0 0 75';/*setsize (self, '-16 -16 -8', '16 16 40');*/};
void()  polyp_wake11   =[      $launchb11,        polyp_wake12   ] {self.velocity = '0 0 50';/*setsize (self, '-16 -16 -8', '16 16 44');*/};
void()  polyp_wake12   =[      $launchb12,        polyp_wake13   ] {self.velocity = '0 0 25';/*setsize (self, '-16 -16 -8', '16 16 48');*/};
void()  polyp_wake13   =[      $launchb13,        polyp_wake14   ] {self.velocity = '0 0 15';/*setsize (self, '-16 -16 -8', '16 16 52');*/};
void()  polyp_wake14   =[      $launchb14,        polyp_hover1   ] 
{

	self.count = time + 2 + (1 * random());
	self.movetype = MOVETYPE_STEP;
	self.velocity = '0 0 0';
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.th_pain = polyp_pain;
};




void()  polyp_float1     =[      $fly1,         polyp_float2     ] 
{
	setmodel (self, "progs/polyp.mdl");
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	self.count = time + 2 + (1 * random());
	ai_stand();
	if (random() < 0.05)
		sound (self, CHAN_VOICE, "polyp/idle.wav", 1,  3);	
};
void()  polyp_float2     =[      $fly2,         polyp_float3     ] {self.count = time + 2 + (1 * random());ai_stand();};
void()  polyp_float3     =[      $fly3,         polyp_float4     ] {self.count = time + 2 + (1 * random());ai_stand();};
void()  polyp_float4     =[      $fly4,         polyp_float1     ] {self.count = time + 2 + (1 * random());ai_stand();};


void()  polyp_walk1     =[      $fly1,         polyp_walk2     ] {ai_walk(6);};
void()  polyp_walk2     =[      $fly2,         polyp_walk3     ] {ai_walk(6);};
void()  polyp_walk3     =[      $fly3,         polyp_walk4     ] {ai_walk(6);};
void()  polyp_walk4     =[      $fly4,         polyp_walk1     ] {ai_walk(6);};




void() polyp_visible1;
void() polyp_hover1;
void() polyp_air1;
void() polyp_idie1;
void() polyp_die1;


void() polyp_invisible_sound =
{
	if (self.ltime < time)
	{
                sound (self, CHAN_VOICE, "polyp/idle2.wav", 1,  1.5);
		self.ltime = time + 1;
	}
	return;
};

void()  polyp_ihover0     =[      0,         polyp_ihover1     ] 
{
	setmodel (self, "progs/s_null.spr");
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);//setsize (self, '-16 -16 -24', '16 16 32');
 	//particle (self.origin, '0 0 0', 48, 1);
	polypcheckdist();
	
};
void()  polyp_ihover1     =[      0,         polyp_ihover2     ] 
{

	polypcheckdist();
	
	polyp_invisible_sound();
	if (self.count < time)
	{
		//sound (self, CHAN_VOICE, "polyp/idle.wav", 1,  1.5);
		self.think = polyp_visible1;
	}
};
void()  polyp_ihover2     =[      0,         polyp_ihover3     ] {polypcheckdist();polyp_invisible_sound();};
void()  polyp_ihover3     =[      0,         polyp_ihover4     ] {polypcheckdist();polyp_invisible_sound();};
void()  polyp_ihover4     =[      0,         polyp_ihover1     ] {polypcheckdist();polyp_invisible_sound();};


void()  polyp_visible1     =[      0,         polyp_visible2     ]
{
        local	vector	org;
        
        self.statevis = 0;
        
        //bprint ("RETURN VISIBLE");
	//bprint ("\n");

	//if (random() < 0.8)
	//	return;
	
	org = self.origin;
	/*
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION2);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteByte (MSG_BROADCAST, 240);
	WriteByte (MSG_BROADCAST, 3);	
	*/
	sound (self, CHAN_AUTO, "polyp/decloak.wav", 1, ATTN_NORM);
	
	setmodel (self, "progs/polyp_t3.mdl");
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);

	self.count = time + 2 + (2 * random());

        self.th_missile = polyp_air1;
	self.th_die = polyp_die1;
	self.th_run = polyp_hover1;
	/*

	bprint ("Time: ");
	bprint (ftos(time));
	bprint ("Next Time: ");
	bprint (ftos(self.count));
	bprint ("\n");*/
};

void()  polyp_visible2     =[      0,         polyp_visible3     ] {setmodel (self, "progs/polyp_t2.mdl");setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);};
void()  polyp_visible3     =[      0,         polyp_hover0a     ] {setmodel (self, "progs/polyp_t1.mdl");setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);};


void()  polyp_invisible     =[      0,         polyp_invisible2     ]
{
	local	vector	org;

        //bprint ("BECOME INVISIBLE");
	//bprint ("\n");

        self.statevis = 1;

	org = self.origin;
	/*
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION2);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteByte (MSG_BROADCAST, 240);
	WriteByte (MSG_BROADCAST, 3);		
	*/
	sound (self, CHAN_AUTO, "polyp/cloak.wav", 1, ATTN_NORM);
	setmodel (self, "progs/polyp_t1.mdl");
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);

	self.th_missile = SUB_Null;
	self.th_run = SUB_Null;
	self.th_die = polyp_idie1;
	
	self.count = time + 2 + (2 * random());
	/*

	bprint ("Time: ");

	bprint (ftos(time));
	bprint ("Next Time: ");
	bprint (ftos(self.count));
	bprint ("\n");*/
	//polyp_ihover1();
};

void()  polyp_invisible2     =[      0,         polyp_invisible3     ] {setmodel (self, "progs/polyp_t2.mdl");setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);};
void()  polyp_invisible3     =[      0,         polyp_ihover0     ] {setmodel (self, "progs/polyp_t3.mdl");setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);};



void()  polyp_hover0     =[      $fly4,         polyp_hover1     ] 
{
	local	vector	dist;
	local	float	d;

	self.count = time + 2 + (2 * random());
	polypcheckdist();

	dist = self.enemy.origin - self.origin;
	d = vlen(dist);	

	if (d > 256)
		self.count = 0;
};

void()  polyp_hover0a     =[      $fly1,         polyp_hover2     ] 
{
	setmodel (self, "progs/polyp.mdl");
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
	polypcheckdist();
	if (self.count < time)
		self.think = polyp_invisible;
};

void()  polyp_hover1     =[      $fly1,         polyp_hover2     ] 
{
	if (self.flags & FL_ONGROUND)

		self.flags = self.flags - (self.flags & FL_ONGROUND);
		
	polypcheckdist();
	if (self.count < time)
		self.think = polyp_invisible;
};
void()  polyp_hover2     =[      $fly2,         polyp_hover3     ] {polypcheckdist();};
void()  polyp_hover3     =[      $fly3,         polyp_hover4     ] {polypcheckdist();};
void()  polyp_hover4     =[      $fly4,         polyp_hover1     ] {polypcheckdist();};


void()  airthink =
{
        local entity head;

	//particle (self.origin, '0 0 0', 32, 20);
	
	
	self.nextthink = time + 0.1;
	//self.frame = self.frame + 1;
	self.cnt = self.cnt + 1;
	if (self.cnt >= 5)
		self.think = SUB_Remove;
	else
		self.think = airthink;

		head = findradius(self.origin, self.cnt * 22); //20

		while (head)
		{
 			if (head.takedamage == DAMAGE_AIM && visible(head))
			{
		 		T_Damage (head, self, self.owner, 1);
		      	}
			head = head.chain;  // cycle to next head (entity)
		}



};

void()  airtouch =
{

	//particle (self.origin, '0 0 0', 32, 20);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_GUNSHOT);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);	

	if (other.takedamage == DAMAGE_AIM)
	{
		other.velocity = other.velocity + (self.velocity * 0.4) + '0 0 70';	
		if (random() < 0.4)  //0.2
			T_Damage (other, self, self.owner, 1);
	}

	//if (other.classname == "monster_polyp")
		//return;
		
	SUB_Remove();
	return;
};

void()  polyp_air =
{

	local	entity   missile;
	local   vector   vec;
	
	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "airchunk";
		
// set missile speed	

        vec = normalize(self.enemy.origin - self.origin);
        //vec_x = staffvec_x + random() * 0.05 - random() * 0.1;
        //vec_y = staffvec_y + random() * 0.05 - random() * 0.1;
        //vec_z = staffvec_z + random() * 0.025 - random() * 0.05; 

        missile.velocity = normalize(vec);
        missile.velocity = missile.velocity * 750;
	

	missile.angles = vectoangles(self.enemy.origin - self.origin);
	
	missile.touch = airtouch;
	
// set missile duration
	missile.nextthink = time + 0.1;
	missile.think = airthink;

	setmodel (missile, "progs/air.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');

};


/*
void(float indicator)  polyp_air_effect =
{

	local	entity   missile;
	local   vector   vec;
	
	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "airchunk";
		
// set missile speed	

        vec = normalize(self.enemy.origin - self.origin);
        //vec_x = staffvec_x + random() * 0.05 - random() * 0.1;
        //vec_y = staffvec_y + random() * 0.05 - random() * 0.1;
        //vec_z = staffvec_z + random() * 0.025 - random() * 0.05; 

        missile.velocity = normalize(vec);
        missile.velocity = missile.velocity * 750;
	

	missile.angles = vectoangles(self.enemy.origin - self.origin);
	
	missile.touch = airtouch;
	
// set missile duration
	missile.nextthink = time + 0.1;
	missile.think = airthink;

	setmodel (missile, "progs/s_null.spr");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');

};
*/

void()  polyp_air1     =[      $fly1,         polyp_air2     ] 
{

	if (self.count < time)
		self.think = polyp_invisible;
	ai_face();
	polyp_air();
	sound (self, CHAN_WEAPON, "polyp/blast.wav", 1, ATTN_NORM);
};
void()  polyp_air2     =[      $fly2,         polyp_air3     ] {ai_face();polyp_air();};
void()  polyp_air3     =[      $fly3,         polyp_air4     ] {ai_face();polyp_air();};
void()  polyp_air4     =[      $fly4,         polyp_air5     ] {ai_face();polyp_air();};
void()  polyp_air5     =[      $fly3,         polyp_hover1   ] {ai_face();polyp_air();};



//============================================================================



void()  polyp_jump5;

void()  polyp_fly1              =[      $fly1,  polyp_fly2      ] {};
void()  polyp_fly2              =[      $fly2,  polyp_fly3      ] {};
void()  polyp_fly3              =[      $fly3,  polyp_fly4      ] {};
void()  polyp_fly4              =[      $fly4,  polyp_fly1      ] {
self.cnt = self.cnt + 1;
if (self.cnt == 4)
{
//dprint ("spawn hop\n");
polyp_jump5 ();
}
};

void()  polyp_jump1             =[      $jump1, polyp_jump2             ] {ai_face();};
void()  polyp_jump2             =[      $jump2, polyp_jump3             ] {ai_face();};
void()  polyp_jump3             =[      $jump3, polyp_jump4             ] {ai_face();};
void()  polyp_jump4             =[      $jump4, polyp_jump5             ] {ai_face();};
void()  polyp_jump5             =[      $jump5, polyp_jump6             ]
{	
	self.movetype = MOVETYPE_BOUNCE;
	self.touch = Tar_JumpTouch;
	makevectors (self.angles);
	self.origin_z = self.origin_z + 1;
	self.velocity = v_forward * 600 + '0 0 200';
	self.velocity_z = self.velocity_z + random()*150;
	if (self.flags & FL_ONGROUND)
		self.flags = self.flags - FL_ONGROUND;
	self.cnt = 0;
};
void()  polyp_jump6     =[      $jump6,polyp_fly1       ] {};



//=============================================================================

void() pgibtouch =
{

/*	local   float   rndsnd;
	
	rndsnd = rint(random() * 2);			
		if (rndsnd == 1)
			sound (self, CHAN_AUTO, "polyp/gibimp1.wav", 1, ATTN_NORM);
		else if (rndsnd == 2)
			sound (self, CHAN_AUTO, "polyp/gibimp2.wav", 1, ATTN_NORM);
		else 
			sound (self, CHAN_AUTO, "polyp/gibimp3.wav", 1, ATTN_NORM);	*/

	self.think = SUB_Remove;
	self.nextthink = time + random()*5;

	if (other.takedamage == DAMAGE_AIM)

	{
		sound (self, CHAN_WEAPON, "zombie/z_hit.wav", 1, ATTN_NORM);
		T_Damage (other, self, self.owner.owner, 5);
		SUB_Remove();
	}
};

void(string gibname, float dm) throwpolypgib =
{
	local	entity new;

	new = spawn();
	new.origin = self.origin;

	setmodel (new, gibname);
	setsize (new, '0 0 0', '0 0 0');

	new.classname = "polypgib";
	new.velocity = VelocityForDamage (dm);
	new.movetype = MOVETYPE_BOUNCE;

	new.solid = SOLID_BBOX;

	new.avelocity_x = random()*600;
	new.avelocity_y = random()*600;
	new.avelocity_z = random()*600;

	new.think = SUB_Remove;
	new.nextthink = time + 5 + random()*5;
	

	new.touch = pgibtouch;
};



void()  polyp_die1      =[      $exp,           polyp_die2      ] {self.takedamage = DAMAGE_NO; self.nextthink = time + 0.2;self.velocity = '0 0 0';};
void()  polyp_die2      =[      $exp,           polyp_hover1    ] 
{
	//T_RadiusDamage (self, self, 120, world);
	//self.origin = self.origin - 8*normalize(self.velocity);

	sound (self, CHAN_VOICE, "polyp/gibsplt1.wav", 1, ATTN_NORM);

	throwpolypgib ("progs/polypgib.mdl", -40);
	throwpolypgib ("progs/polypgib.mdl", -40);
	throwpolypgib ("progs/polypgib.mdl", -40);
	throwpolypgib ("progs/polypgib.mdl", -50);
	throwpolypgib ("progs/polypgib.mdl", -50);
	throwpolypgib ("progs/polypgib.mdl", -60);
	throwpolypgib ("progs/polypgib.mdl", -60);
	throwpolypgib ("progs/polypgib.mdl", -75);
	throwpolypgib ("progs/polypgib.mdl", -75);

	SUB_Remove();
};

void()  polyp_idie1      =[      0,           polyp_idie2     ] {self.takedamage = DAMAGE_NO; self.nextthink = time + 0.2;self.velocity = '0 0 0';};
void()  polyp_idie2      =[      0,           polyp_hover1    ] 
{
	//T_RadiusDamage (self, self, 120, world);
	//self.origin = self.origin - 8*normalize(self.velocity);

	sound (self, CHAN_VOICE, "polyp/gibsplt1.wav", 1, ATTN_NORM);

	throwpolypgib ("progs/polypgib.mdl", -40);
	throwpolypgib ("progs/polypgib.mdl", -40);
	throwpolypgib ("progs/polypgib.mdl", -40);
	throwpolypgib ("progs/polypgib.mdl", -50);
	throwpolypgib ("progs/polypgib.mdl", -50);
	throwpolypgib ("progs/polypgib.mdl", -60);
	throwpolypgib ("progs/polypgib.mdl", -60);
	throwpolypgib ("progs/polypgib.mdl", -75);
	throwpolypgib ("progs/polypgib.mdl", -75);

	SUB_Remove();
};



void() polyp_missile =
{
	if (random() < 0.3 && self.fly_sound < time)
		return;
	
	self.fly_sound = time + 0.5;
	polyp_air1();
};




void() polyp_start =
{
	local vector	org;

	if (!(self.spawnflags & TRIGGER_SPAWNSILENT))
	{
	        //org = self.origin + 16 * v_forward;
	        spawn_tfog (self.origin);
	}

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

        setmodel (self, "progs/polyp.mdl");
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
		
	self.health = 150;
        
        monster_spawn();
        flymonster_start_go();
};

void() polyp_begin =
{
	if (self.delay)

		self.nextthink = time + self.delay;
	else if (self.delay == -1)
		self.nextthink = time + random() * 0.4;
	else
		self.nextthink = time + 0.1;
	self.think = polyp_start;
};


void() polyp_pain =
{
	//self.nextthink = time + 0.1;

	

	if (self.statevis == 1)
		polyp_visible1();//self.think = polyp_visible1;
	else
		return;
	
};

//=============================================================================


/*QUAKED monster_polyp (1 0 0) (-16 -16 -24) (16 16 24) Ambush
*/
void() monster_polyp =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
        precache_model ("progs/polyp.mdl");
        precache_model ("progs/polyp_t1.mdl");
        precache_model ("progs/polyp_t2.mdl");
        precache_model ("progs/polyp_t3.mdl");
        precache_model ("progs/s_null.spr");
        precache_model ("progs/polypgib.mdl");
        precache_model ("progs/air.mdl");

	precache_sound ("polyp/idle2.wav");
	precache_sound ("zombie/z_hit.wav");
	precache_sound ("polyp/cloak.wav");

	precache_sound ("polyp/decloak.wav");


	precache_sound ("polyp/gibsplt1.wav");
	precache_sound ("polyp/blast.wav");
	
	precache_sound ("polyp/sight.wav");
	precache_sound ("polyp/idle.wav");

	self.th_walk = polyp_walk1;
        self.th_run = polyp_hover0;
        self.th_missile = polyp_missile;
	self.th_die = polyp_die1;	
        self.yaw_speed = 30;
        
        if (self.startonground == 1)
	{
        	self.th_pain = polyp_wake1;
        	self.th_stand = polyp_stand0;
        }
        else
	{
        	self.th_pain = polyp_pain;
        	self.th_stand = polyp_float1;
        }
        
	if (self.spawnflags & TRIGGER_SPAWN)
	{
		self.use = polyp_begin;
		total_monsters = total_monsters + 1;
		return;
	}

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

        setmodel (self, "progs/polyp.mdl");
	setsize (self, VEC_HULL_MIN, VEC_HULL_MAX);
 
	
	self.health = 150;


        flymonster_start ();
};

