


entity rift;
vector tower = '1664 -1664 0';
vector gate = '2600 -2600 250';
void() azoth_fire1;

void() azoth_throw1;

void() azoth_leap1;
void() azoth_land1;
void() azoth_land2;
void() azoth_dive1;
void() azoth_hammer1;
void() azoth_deflect1;
void() AzothFloorAttack;
void() azoth_phase2b;
void() azoth_flee;
void() azoth_phase2;
void() azoth_phase4;
void() azoth_phase5;
void() azoth_phase7;
void() azoth_phase7b;
//flight targets
float TARGET_TOWER = 0;
float TARGET_GATE = 1;
float TARGET_BURN = 2;
float TARGET_EXIT = 3;
float TARGET_PLAYER = 4;
float TARGET_RIFT = 5;

//fixme - possibly have a target for flying round the tower which pushes in a bit
/*
vector(float h, float q) azoth_phase5_location =
{
if(q & 1)
	{
	if(q == 1)
		{
		if (h > 700)
			return '1024 -2560 1200';
		else
			return '1024 -2560 650';
		}

	else if(q == 3)
		{
		if (h > 700)
			return '2304 -768 1210';
		else
			return '2304 -768 600';
		}
	}
else
	{
	if(q == 2)
		{
		if (h > 700)
			return '768 -1024 1197';
		else
			return '768 -1024 630';
		}

	else if(q == 4)
		{
		if (h > 700)
			return '2560 -2368 1213';
		else
			return '2560 -2368 660';
		}
	}
}
*/
float() azoth_new_flightpoint =
{
//at this point, have reached a waypoint in the air, so either are at the tower
//or should be able to reach the tower by flying straight to it
// returns true if the flight function should abort after this - ie new phase

local vector d;

if (coop == 2)
{
	if (!IsAlive(self.enemy))
		self.enemy = world;
}

if(self.state == TARGET_TOWER) //flying in to a level of the tower
{
d = self.origin - tower;
d_z = 0;	//don't care about the vertical

if(vlen(d) < 400)
	{

	azoth_land1();
	self.attack_finished = time - 1;
	AzothFloorAttack();
	}
else
	{
	self.pos1 = self.origin - 0.2 * d;
	self.pos1_z = self.origin_z + 5;
	self.attack_finished = time + 1;//Checkpoint! Time extended!
	}
}
else if(self.state == TARGET_GATE) //the clearing on the ground in front of the teleporter
{

	if(vlen(self.origin - gate) <= 100)
		{
		azoth_phase2b();
		self.velocity = '0 0 0';//will this work?

		self.state = 0;
		self.attack_finished = time + 2;//don't attack while dropping, but become alert if you fall off the edge somehow
		return FALSE;
		}
	traceline(self.origin, gate, TRUE, self.enemy);
	if(trace_fraction != 1)
		self.pos1 = '1600 -1728 1800';
	else
		self.pos1 = gate;



	self.attack_finished = time + 15;
}

else if(self.state == TARGET_RIFT) //below where the portal opens
{

	if(vlen(self.origin - rift.origin + '0 0 300') <= 100)
		{

			azoth_phase7b();
			self.velocity = '0 0 0';
			self.state = 0;
			self.attack_finished = time + 2;
			return TRUE;
		}
	traceline(self.origin, rift.origin - '0 0 300', TRUE, self.enemy);
	if(trace_fraction != 1)
		self.pos1 = self.origin + '0 0 100';
	else
		self.pos1 = rift.origin - '0 0 300';



	self.attack_finished = time + 15;
}




else if(self.state == TARGET_EXIT)//going to the level exit
{
if(self.pos1 == '2782 -3381 0')
	{
	setorigin(self,  self.pos1 + '0 1 0');
	self.velocity = '0 0 0';
	self.movetype = MOVETYPE_NONE;
//	dprint("teleport to site\n");
	azoth_land1();
	self.attack_finished = time - 1;
		self.state = 0;
	}
else if(self.pos1 == '2782 -3311 0')
	{
//	dprint("second approach target\n");
	self.pos1 = '2782 -3381 0';
	self.attack_finished = time + 5;
	}

else
	self.pos1 = '2782 -3311 0';
	self.attack_finished = time + 25;
}
else if(self.state == TARGET_PLAYER)//going for the player
{
d = self.origin - self.enemy.origin;
d_z = 0;
if(vlen(d) < 250)
	{
	azoth_dive1();
//	self.velocity = normalize(d) * -2000;
//	self.velocity = '0 0 -2000';
	self.attack_finished = time + 1;
	return FALSE;
	}
else
	{
	azoth_land1();
	AzothFloorAttack();
	self.attack_finished = time + 1;
	}

}

return FALSE;
}

float(entity ent) towerquadrant =
{
local float q;
q = vectoyaw(ent.origin - tower);
if(q<0)
	dprint("angles less than 0\n");
if(q <= 90)
	return 1;
else if(q <= 180)
	return 2;
else if(q <= 270)
	return 3;
else return 4;
}

void(float q) Azoth_jumproundGo =
{
local vector spot;
	spot_y = q * 90;
	makevectors(spot);
	self.pos1 = tower + v_forward * 345;
	self.pos1_z = 500;

	if(vlen(self.origin - self.pos1) > 200)
		return;//only jump when near the side

if(self.enemy.origin_z <= 418 && enemy_range < RANGE_MID)
	{
	//hiding in the gaps, don't jump, just flush him out
	self.attack_finished = time + 0.2;
	azoth_throw1();
	return;
	}


	azoth_leap1();
	self.attack_finished = time + 3;
}

void() Azoth_jumproundfirst =
{
local float s,p;
s = towerquadrant(self);
p = towerquadrant(self.enemy);
/*
local string debug;
debug = ftos(s);
dprint("self quadrant:");
dprint(debug);
dprint("\n");
debug = ftos(p);
dprint("player quadrant:");
dprint(debug);
dprint("\n");
*/
if (s== p)
	return;
if(p == 4 && s == 1)
	Azoth_jumproundGo(s - 1.1);
else if (p > s)
	Azoth_jumproundGo(s + 0.1);

else if(s == 4 && p == 1)
	Azoth_jumproundGo(s + 0.1);
else
	Azoth_jumproundGo(s - 1.1);
}

void() Azoth_flytofirst
{
local vector spot,vout,vperp;
/*	if((self.origin_z > 400) && (self.origin_z < 650) )//redundant now?
		{
		Azoth_jumproundfirst();
		return;
		}
*/

		vout = normalize(self.origin - tower - ('0 0 1' * self.origin_z));
		vperp = '-1 0 0' * vout_y + '1 0 0' * vout_x;

if(random() < 0.5)
		spot = 600 * vout + 100 * vperp;
else
		spot = 600 * vout - 100 * vperp;	//one direction should free Azoth
							//so eventually he'll escape
spot_z = 500;

if(spot_z < self.origin_z)
	{
	//flying straight there will cause problems with getting stuck flying into the ground.
	//so give monster a chuck before it starts flying, should hopefully clear the ledge first
	self.movetype = MOVETYPE_TOSS;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.velocity = spot * 1.2;
	}

traceline(spot + tower, tower + '0 0 500',FALSE, self);

if(trace_fraction < 0.8)
	return;	//don't jump if there's a pillar in the way, it just won't work.
		//perhaps call a function here that strafes him round for a better jumpspot
if(pointcontents(tower + spot * (670 / 600) - '0 0 200') == CONTENT_SOLID)
	{
//	dprint("jump would hit pillar\n");
	return;//same idea, if under a pillar
	}

//fly out to this point first, then back in to the tower
self.pos1 = spot + tower;

azoth_leap1();
self.attack_finished = time + 3;//time to finish the flight

}


void(float q) Azoth_flyroundGo =
{
local vector spot;
local float dist;
	spot_y = q * 90;
	makevectors(spot);
	self.pos1 = tower + v_forward * 345;
	self.pos1_z = 1200;

	//if azoth is too close to the pillar he's leaping or too far in to the tower
	//he tends to miss the jump for various reasons
	//these two lines try to preempt this and push him into a better spot to jump from

dist = vlen(self.origin - self.pos1);

	if(dist > 500)//don't jump just because you can, only do it if you're close to the edge
		return;

	if(dist < 430)
		{
//		dprint("too close\n");
		self.movetype = MOVETYPE_TOSS;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.velocity = (self.origin - self.pos1) * 2;
	self.velocity_z = 200;
		}

	if(vlen(self.origin - tower) < 300)
		{
//		dprint("too close\n");
		self.movetype = MOVETYPE_TOSS;
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	self.velocity = (self.origin - tower) * 2;
	self.velocity_z = 200;
		}
	azoth_leap1();
	self.attack_finished = time + 3;
}

void() Azoth_flyroundsecond =
{
local float s,p;
if(self.enemy.origin_z > 1350)
	return;//If the player is on top of the tower, it's much better to just keep lobbing skulls than try chasing him

s = towerquadrant(self);
p = towerquadrant(self.enemy);
/*
local string debug;
debug = ftos(s);
dprint("self quadrant:");
dprint(debug);
dprint("\n");
debug = ftos(p);
dprint("player quadrant:");
dprint(debug);
dprint("\n");
*/
if (s == p)
	return;
if(p == 4 && s == 1)
	Azoth_flyroundGo(s - 1.1);
else if (p > s)
	Azoth_flyroundGo(s + 0.1);

else if(s == 4 && p == 1)
	Azoth_flyroundGo(s + 0.1);
else
	Azoth_flyroundGo(s - 1.1);
}


void() Azoth_flytosecond
{
local vector spot;
	if(self.origin_z > 650)
		{
		Azoth_flyroundsecond();
		return;
		}

spot = 600 * normalize(self.origin - tower - ('0 0 1' * self.origin_z));
spot_z = 900;

//fly out to this point first, then back in to the tower



traceline(spot + tower, tower + '0 0 900', FALSE, self);

if(trace_fraction < 0.3)

	{
	if(self.th_die == azoth_flee)
		spot = spot + '100 100 0';
	else
		return;
		//don't jump if there's a pillar in the way, it just won't work.
		//perhaps call a function here that strafes him round for a better jumpspot
		// FIXME: This is what's breaking phase 3, sort it out!
	}
self.pos1 = spot + tower;
azoth_leap1();
self.attack_finished = time + 10;//bit longer for this one

}
float() AzothCheckMissile =
//checks if a missile thrown directly will hit the player
{
makevectors(self.angles);
traceline(self.origin + '0 0 160' + v_forward * 14 + v_right * 65, self.enemy.origin + '0 0 15', FALSE, self);
if(trace_ent == self.enemy)
	return TRUE;
else return FALSE;
}





void() AzothFloorAttack =
{
local float r;
	if (enemy_range == RANGE_FAR)
		{
		self.attack_finished = time + 0.6;
		if(random() < 0.3)
			azoth_throw1();
		else if(!enemy_vis)
			{
			if(self.th_die == azoth_phase7)
				{
				if(random() < 0.1 && self.origin_z < 150)
					{
//					dprint("repositioning...\n");

					azoth_leap1();
					self.attack_finished = time + 7;//time to finish the flight

					self.state = TARGET_PLAYER;
					self.pos1 = rift.origin;
					}
				else
					self.attack_finished = time + 0.6;
				}
			else
				self.attack_finished = time + 0.1;
			}
		}
	else if (enemy_range == RANGE_MID)
		{
		self.attack_finished = time + 0.8;

		if(self.th_die == azoth_phase7)
			{
			r = random();
			if((self.enemy.attack_finished - time) < r && (self.enemy.attack_finished - time) > 0 && r < 0.85)
				{
				// if player fired recently, relative to the weapon
				// (deliberately skewed in favour of deflecting eg. a rocket
				// rather than a nail)
				// try to deflect it
				azoth_deflect1();
				self.attack_finished = time + 1.1;
				return;
				}
			}

		if(random() < 0.6 || AzothCheckMissile())
			azoth_throw1();
		else if(!enemy_vis)
			{
			if(self.th_die == azoth_phase7)
				{
				if(random() < 0.1 && self.origin_z < 150)
					{
//					dprint("repositioning...\n");

					azoth_leap1();
					self.attack_finished = time + 7;//time to finish the flight

					self.state = TARGET_PLAYER;
					self.pos1 = rift.origin;

					}
				else
					self.attack_finished = time + 0.6;
				}
			else
				self.attack_finished = time + 0.1;
			}
		}
	else if (enemy_range == RANGE_NEAR)
		{
		self.attack_finished = time + 0.5;
		if(enemy_vis && random() < 0.6 && (self.enemy.origin_z - self.origin_z < 20))
			azoth_fire1();
		else if (random() < 0.2)
			azoth_throw1();
		else if(!enemy_vis)
			{
			if(self.th_die == azoth_phase7)
				{
				if(random() < 0.1 && self.origin_z < 150)
					{
//					dprint("repositioning...\n");


					azoth_leap1();
					self.attack_finished = time + 7;//time to finish the flight

					self.state = TARGET_PLAYER;
					self.pos1 = rift.origin;
					}
				else
					self.attack_finished = time + 0.6;
				}
			else
				self.attack_finished = time + 0.1;
			}
		}
	else if (enemy_range == RANGE_MELEE)
		{
		self.attack_finished = time + 0.8;
		azoth_hammer1();
		}
}


//consider setting attack_finished to 0.1 in most cases the player isn't visible, to make a decision as soon as he emerges
float() AzothCheckAttack_Phase1 = //phase 2 doesn't require thinking : - )
{

	local vector	spot1, spot2;
	local entity	targ;
if(self.attack_finished > time)
	return FALSE;//always respect attack_finished


	targ = self.enemy;

if(targ.origin_z < 340)
	{

	// PLAYER ON GROUND FLOOR

if(self.origin_z < 340)
	AzothFloorAttack();
else
	{
	if(random() < 0.3)
		{
		azoth_throw1();
		//SUB_AttackFinished(1);
		self.attack_finished = time + 1;
		}
	else
		{
		spot1 = normalize(self.origin - tower - ('0 0 1' * self.origin_z));
		spot1_z = 1;
		self.movetype = MOVETYPE_TOSS;
		self.flags = self.flags - (self.flags & FL_ONGROUND);
		self.velocity = spot1 * 300;
		self.attack_finished = time + 0.2;
		azoth_land2();
		}
	}
return TRUE;
	}


else if (targ.origin_z < 650)
	{

	// PLAYER ON FIRST FLOOR
if(self.origin_z < 400)
	{

		if(random() < 0.5)
			{
			azoth_throw1();
			self.attack_finished = time + 1;
			//SUB_AttackFinished(1);
			}
		else
			{
			if (vlen(tower - self.origin + self.origin_z * '0 0 1') < 850)
				Azoth_flytofirst();
			//See if there isn't a way to put a "covering" shot here first, to distract the player while making the flight

			else
				self.attack_finished = time + 1.1;
			//	SUB_AttackFinished(1.1);
			//	PREACH: this forces him to walk towards the tower for a while, rather than keep checking to attack
			}
	}
else if(self.origin_z < 650)
	{
	Azoth_jumproundfirst();
	if(self.attack_finished < time) // might have been set by flyroundfirst, return if so
		AzothFloorAttack();
	}
else
	{
		if(random() < 0.6)
			{
			azoth_throw1();
			self.attack_finished = time + 1;
			//SUB_AttackFinished(1);
			}
		else
				Azoth_flytofirst();
	}
return TRUE;
	}


else
	{

	// PLAYER ON SECOND FLOOR(OR HIGHER)

if(self.origin_z < 400)
	{

		if(random() < 0.5)
			{
			azoth_throw1();
			self.attack_finished = time + 1;
			//SUB_AttackFinished(1);
			}
		else
			{
			if (vlen(tower - self.origin + self.origin_z * '0 0 1') < 850)
				Azoth_flytosecond();
			//See if there isn't a way to put a "covering" shot here first, to distract the player while making the flight
			else
				self.attack_finished = time + 1.1;
			//SUB_AttackFinished(1.1);
			//	PREACH: this forces him to walk towards the tower for a while, rather than keep checking to attack
			}
	}
else if(self.origin_z < 650)
	{
		if(random() < 0.6)
			{
			azoth_throw1();
			self.attack_finished = time + 1;
		//	SUB_AttackFinished(1);
			}
		else
				Azoth_flytosecond();
	}
else
	{
	Azoth_flyroundsecond();
	if(self.attack_finished < time) // might have been set by flyroundsecond, return if so
		AzothFloorAttack();
	}

return TRUE;
	}

}
float() AzothCheckAttack_Phase5 =
{

	local vector	spot1, spot2;
	local entity	targ;


if(self.attack_finished > time)
	return FALSE;//always respect attack_finished


	targ = self.enemy;

if(targ.origin_z < 650)
	{

	// PLAYER ON GROUND FLOOR OR FIRST
	// think about moving around the tower sometimes if the player is on the ground and in same quadrant...
if(self.origin_z < 650)
	Azoth_flytosecond();
else
	{
	if(random() < 0.5)
		{
		azoth_throw1();
		//SUB_AttackFinished(1);
		self.attack_finished = time + 1;
		}
	else
		self.attack_finished = time + 0.5;
	}
return TRUE;
	}


else
	{

	// PLAYER ON SECOND FLOOR(OR HIGHER)

if(self.origin_z > 650 || self.origin_z < 400)
		Azoth_flytofirst();


else
	{
		if(random() < 0.6)
			{
			azoth_throw1();
			self.attack_finished = time + 1;
		//	SUB_AttackFinished(1);
			}
		else
			{
//			self.attack_finished = time + 0.5;
			Azoth_jumproundfirst();
			}
return TRUE;
	}
	}
return FALSE;
}

float() AzothCheckAttack_Phase4 = //On QTFIN3 - FIRST PHASE
{

	local vector	spot1, spot2;
	local entity	targ;


if(self.attack_finished > time)
	return FALSE;//always respect attack_finished


	targ = self.enemy;

if(targ.origin_z > 180)
	{

	// PLAYER ON FIRST

if((self.origin_z < 150 && random() < 0.4) || (enemy_range == RANGE_FAR && random() < 0.1))
	{
	if(self.flags & FL_ONGROUND)
		{
		self.state = TARGET_PLAYER;
		self.pos1 = (self.origin + targ.origin * 4) * 0.2;
		self.pos1_z = 450;
		azoth_leap1();
		self.attack_finished = time + 3;
		}
	}
else
	AzothFloorAttack();


return TRUE;
	}


else
	{
	if(targ.origin_z > 150) //probably exploiting on the trees
		{
		if(self.origin_z < 150)
				{
					azoth_leap1();
					self.attack_finished = time + 7;//time to finish the flight

					self.state = TARGET_PLAYER;
					self.pos1 = rift.origin;
				}
		else
				AzothFloorAttack();
		return TRUE;
		}

if((self.origin_z > 150 && random() < 0.4) || (enemy_range == RANGE_FAR && random() < 0.1))
	{
	if(self.flags & FL_ONGROUND)
		{
		self.state = TARGET_PLAYER;
		self.pos1 = (self.origin + targ.origin * 4) * 0.2;
		self.pos1_z = 450;
		azoth_leap1();
		self.attack_finished = time + 3;
		}
	}
else
	AzothFloorAttack();


return TRUE;

	}
return FALSE;
}


void() azoth_dief1;
float() AzothCheckAttack =
{

if(self.origin_z < -200)
	{//PANIC! AZOTH HAS FALLEN DOWN
	self.pos1 = self.origin;
	self.pos1_z = 200;
	azoth_leap1();
	self.attack_finished = time + 20;
	return FALSE;
	}
if(self.state == TARGET_GATE || self.state == TARGET_EXIT || self.state == TARGET_RIFT)
	{
	if (coop == 2)
	{
		if (!rift)
		{
			rift = spawn ();
			rift.classname = "rift_dummy";
			rift.origin = self.origin;
		}

		azoth_dief1 ();
		return FALSE;
	}

//	dprint("reached AzothCheckAttack but have a critical target, will teleport to waypoint\n");
	setorigin(self, self.pos1);
	self.flags = self.flags - (self.flags & FL_ONGROUND);
	azoth_new_flightpoint();
	return FALSE;
	}
if(self.th_die == azoth_phase2)
	return AzothCheckAttack_Phase1();
if(self.th_die == azoth_phase7)
	return AzothCheckAttack_Phase4();
if(self.th_die == azoth_flee)
	return AzothCheckAttack_Phase5();

return FALSE;

}

