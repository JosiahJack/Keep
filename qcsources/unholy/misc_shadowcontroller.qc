
//Code by bmFbr, simplified for Church of the Unholy - 2021

/********************
misc_shadowcontroller

Controls switchable shadows on any bmodel entity (except doors).
Target entity must have set _switchableshadow set to 1.

speed: Controls the time in seconds it takes to fade the shadow in. Default is 0.5, and setting it to -1 disables fading.
speed2: Same as 'speed' but for the fade out animation. If unset it's the same value as 'speed'.
spawnflag 1: target shadow starts as disabled

*********************/

float SHADOWCONTROLLER_STARTOFF = 1;

void() shadow_fade_out =
{
	if (self.count < 0)
		self.count = 0;
	if (self.count > 12)
		self.count = 12;

	dprint(ftos(self.count));dprint("\n");

	lightstyle(self.switchshadstyle, lightstyle_fade_lookup(self.count));
	self.count = self.count + self.dmg;
	if (self.count > 12)
		return;

	self.think = shadow_fade_out;
	self.nextthink = time + self.delay;
};

void() shadow_fade_in =
{
	if (self.count < 0)
		self.count = 0;
	if (self.count > 12)
		self.count = 12;

	dprint(ftos(self.count));dprint("\n");

	lightstyle(self.switchshadstyle, lightstyle_fade_lookup(self.count));
	self.count = self.count - self.dmg;
	if (self.count < 0)
		return;

	self.think = shadow_fade_in;
	self.nextthink = time + self.delay;

};

void(float speed) misc_shadowcontroller_setsteps = {
	// self.delay -> time between steps
	// self.dmg -> step size
	if(speed >= 0.24) {
		self.delay = (speed/12);
		self.dmg = 1;
	}
	else if(speed >= 0.12) {
		self.delay = (speed/6);
		self.dmg = 2;
	}
	else if(speed >= 0.06) {
		self.delay = (speed/3);
		self.dmg = 4;
	}
	else if(speed >= 0.04) {
		self.delay = (speed/2);
		self.dmg = 6;
	}
	else {
		self.delay = 0;
		self.dmg = 12;
	}

}

void() misc_shadowcontroller_use = {

	if(self.shadowoff) {
		dprint("Fade in:\n");

		misc_shadowcontroller_setsteps(self.speed);

		shadow_fade_in();

		self.shadowoff = 0;
	} else {
		dprint("Fade out:\n");

		misc_shadowcontroller_setsteps(self.speed/*2*/);

		shadow_fade_out();

		self.shadowoff = 1;
	}
}

void() misc_shadowcontroller = {
	entity t1;

	if(!self.speed) self.speed = 0.5;
	/*if(!self.speed2) self.speed2 = self.speed;*/

	if(self.spawnflags & SHADOWCONTROLLER_STARTOFF) {
		lightstyle(self.switchshadstyle, "m");

		self.shadowoff = 1;
		self.count = 12;

		misc_shadowcontroller_setsteps(self.speed/*2*/);
	}
	else {
		lightstyle(self.switchshadstyle, "a");
		self.shadowoff = 0;
		self.count = 0;
		misc_shadowcontroller_setsteps(self.speed);
	}

	self.use = misc_shadowcontroller_use;
}
