vector(float x, float y, float z) Vector =
{
	local vector swiz;
	swiz_x = x;
	swiz_y = y;
	swiz_z = z;
	return swiz;
}

vector(float num) SinCos =
{
	local vector angle, vf, vu, vr, result;
	
	vf = v_forward;
	vu = v_up;
	vr = v_right;
	
	angle = '0 1 0' * num;
	makevectors(angle);
	result = Vector(v_forward_y, v_forward_x, v_forward_x / v_forward_y);	// technically SinCosTan
	
	v_forward = vf;
	v_up = vu;
	v_right = vr;
	
	return result;
}

float(float num) cos =
{
	vector temp;
	temp = SinCos(num);
	return temp_y;
}

float(float in, float def) zeroconvertdefault =
{
	if (in == -1) return 0;
	if (in == 0) return def;
	return in;
}

/*
i've brought over the quoth convention of letting mappers set the 'model' key on func_*
to override an entity's model with something external, which must be precached, but that 
collides with the existing use of the model keyvalue, and also causes precache-out-of-turn
errors on maps with map hacks like mce.bsp

however, if the entity already has a modelindex, it already has a model internal to the
bsp and precache should never be called no matter what time it is. (do not call when self
is world, like in W_Precache)
*/
void(string s) precache_model_safe	=
{
	if (framecount)
		dprint("in an even darker timeline precaching ", s, " now would be an error\n");
	else if (s != string_null && !self.modelindex)
		precache_model2(s);
}

void func_bobbing_think();

void() func_bobbing_blocked = 
{
	T_Damage (other, self, self, self.dmg);
	
	if ((self.spawnflags & 2))	// don't reverse if we're a CRUSHER
		return;
		
	// reversing direction entails reversing the phase
	self.delay = (self.delay * -1) + 1;
	func_bobbing_think();
}

void() func_bobbing_use = 
{
	self.state = !self.state;
	
	
	if (self.state)
	{
		if (self.noise != string_null)	// cut off move sound with stop sound
			sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
		self.nextthink = 0;
		return;
	}
	
	if (self.noise1 != string_null)	// move
		sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.think();
}

vector(float phase) func_bobbing_pos =
{
	vector pos;
	float cosD;
	
	cosD = (1 - cos(360 * phase)) / 2;	// flip -1/1 and scale to 0-1
	pos = self.pos1 + (cosD * (self.pos2 - self.pos1));
	return pos;
}

void() func_bobbing_think = 
{
	vector dst;
	float phase;
	
	// delay = current phase offset (0-1)
	// frags = current think rate
	// wait = total wave interval
	phase = self.delay + self.frags / self.wait;	// advance the phase
	if ( (self.delay < 0.5 && phase > 0.5) || (self.delay < 1 && phase > 1) )
	{
		// when we pass either apex, repeat the noises
		if (self.noise1 != string_null)	// move
			sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
		if (self.noise != string_null)	// stop
			sound (self, CHAN_BODY, self.noise, 1, ATTN_NORM);
	}
	self.delay = phase;
	while (self.delay > 1)	// wrap phase to 0-1
		self.delay -= 1;
		
	dst = func_bobbing_pos(self.delay);
	self.velocity = (dst - self.origin) / self.frags;
	self.nextthink = self.ltime + self.frags;
}

/*QUAKED func_bobbing (0 .5 .8) ? START_OFF CRUSHER
bobbatron 2000. does not need a 'speed' key; specify "wait" for the period and the bobbalondo 9000 does the rest. 
trigger to freeze in place or reactivate.

"angle" set bobaxis
"distance" total distance of bob, will move half this far in either direction
"pos1"/"pos2" ignore angle/distance and set apex offsets directly
"wait" wavelength of bob in seconds
"delay" phase offset to start at (0 = pos1, 0.5 = pos2, 1.0 = back at pos1 again)
"sounds"
0) none, or, set your own with 'noise' (stop sound) and 'noise1' (move sound)
1) ratchet metal
2) base plat

Spawnflags
START_OFF	start off
CRUSHER		don't reverse when blocked
*/
/*FGD
@baseclass base(Targetname, TrainSounds, Angle) = Bob
[
	spawnflags(flags) = [
		1 : "Start off" : 0
		2 : "Crusher (no reverse)" : 0
	]
	wait(string) : "period of bob" : "4"
	distance(integer) : "length of bob" : 64
	delay(string) : "starting phase offset (0-1)" : "0.0"
	dmg(integer) : "Damage on block" : 2
	noise(string) : "Override stop sound"
	noise1(string) : "Override move sound"
	pos1(string) : "Override apex 1"
	pos2(string) : "Override apex 2"
]
@SolidClass base(Bob) = func_bobbing : "Bobbing platform"  []
*/
void() func_bobbing =
{
	self.solid = zeroconvertdefault(self.solid, SOLID_BSP);
	self.movetype = MOVETYPE_PUSH;

	SetMovedir();
	if (!self.distance)
		self.distance = 64;
	if (self.wait <= 0)
		self.wait = 4;
	
	self.dmg = zeroconvertdefault(self.dmg, 2);
	
	if (!self.pos1 && !self.pos2)
	{
		self.pos1 = self.origin + self.distance * 0.5 * self.movedir;
		self.pos2 = self.origin - self.distance * 0.5 * self.movedir;
	}
	self.use = func_bobbing_use;
	self.blocked = func_bobbing_blocked;
	self.think = func_bobbing_think;
	
	self.frags = min(0.1, self.wait / 6);
	
	self.state = self.spawnflags & 1;
	if (!(self.state))
		self.nextthink = self.ltime + self.frags;
	
	precache_model_safe(self.model);
	setmodel (self, self.model);
	setsize (self, self.mins, self.maxs);
	setorigin (self, func_bobbing_pos(self.delay));
}
