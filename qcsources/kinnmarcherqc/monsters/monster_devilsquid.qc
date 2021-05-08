
// TODO: sucking attack at 20 fps for smoothness?

void(vector endpos) squid_launch_tentacle =
{
	local vector org;

	makevectors(self.angles);
	org = self.origin - v_forward*8;	// spawn tentacle just inside body

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_BEAM);		// the parasite tongue from quake 2
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, endpos_x);
	WriteCoord (MSG_BROADCAST, endpos_y);
	WriteCoord (MSG_BROADCAST, endpos_z);
};

void(float t) squid_suck_velocity =
{
	// returns velocity to give enemy in order to reach self at time + t
	// in an ideal situation, of course

	local vector d;
	local vector v;

	d = vlen(self.enemy.origin - self.origin);

	v = normalize(self.origin - self.enemy.origin);
	v = v*(d/t);

	self.enemy.velocity = v;
};	

void() squid_attack1 = [160, squid_attack2]{ai_face();};
void() squid_attack2 = [162, squid_attack2]{ai_face();};
void() squid_attack3 = [164, squid_attack2]{ai_face();};
void() squid_attack4 = [166, squid_attack2]{ai_face();};
void() squid_attack5 = [167, squid_attack2]
{
	ai_face();
	//launch tentacle - travels half the distance to victim
	squid_launch_tentacle(0.5*(self.enemy.origin + self.origin));
};
void() squid_attack6 = [168, squid_attack2]
{
	//tentacle grabs onto victim and starts pulling him in
	ai_face();
	squid_launch_tentacle(self.enemy.origin);
	squid_suck_velocity(0.4);
};
void() squid_attack7 = [169, squid_attack2]
{
	ai_face();
	squid_launch_tentacle(self.enemy.origin);
	squid_suck_velocity(0.3);

};
void() squid_attack8 = [170, squid_attack2]
{
	ai_face();
	squid_launch_tentacle(self.enemy.origin);
	squid_suck_velocity(0.2);

};
void() squid_attack9 = [171, squid_attack2]
{	ai_face();
	squid_launch_tentacle(self.enemy.origin);
	squid_suck_velocity(0.1);
};
