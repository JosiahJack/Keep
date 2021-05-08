/*MAP OBJECTS*/


/*QUAKED mapobject_brazier (0 1 0) (-32 -32 0) (32 32 96)
Large brazier + Flame + Light
*/
void() mapobject_brazier =
{
	precache_model ("progs/ne_torch.mdl");
	setmodel (self, "progs/ne_torch.mdl");
	FireAmbient ();
	makestatic (self);
};


/*QUAKED mapobject_banner (0 1 0) (-8 -8 -8) (8 8 8)
Banner, Flutters lightly.
use "skin" to choose type of banner.
*/
//void() mapobject_banner =
//{
//	precache_model ("progs/banner.mdl");
//	setmodel (self, "progs/banner.mdl");
//	makestatic (self);
//};

void() light_flame_brazier_short =
{
	precache_model ("progs/brazshrt.mdl");
	setmodel (self, "progs/brazshrt.mdl");
	FireAmbient ();
	makestatic (self);
};

void() light_flame_brazier_tall =
{
	precache_model ("progs/braztall.mdl");
	setmodel (self, "progs/braztall.mdl");
	FireAmbient ();
	makestatic (self);
};

void() light_torch_long_walltorch =
{
	precache_model ("progs/longtrch.mdl");
	setmodel (self, "progs/longtrch.mdl");
	FireAmbient ();
	makestatic (self);
};
void() light_flame_spiky_tall =
{
	precache_model ("progs/spiktrch.mdl");
	setmodel (self, "progs/spiktrch.mdl");
	FireAmbient ();
	makestatic (self);
};





// CORPSES!!!



void() corpse_spin1  = [0,	corpse_spin2 ] 
{

	if (self.t_width == 1)

		self.lip = -2;

	else
		self.lip = 2;
	
	self.angles_y = self.angles_y + self.lip;
	self.nextthink = time + 1;
};
void() corpse_spin2  = [0,	corpse_spin3 ] {self.angles_y = self.angles_y + self.lip;self.nextthink = time + 0.4;};
void() corpse_spin3  = [0,	corpse_spin4 ] {self.angles_y = self.angles_y + self.lip;self.nextthink = time + 0.3;};
void() corpse_spin4  = [0,	corpse_spin5 ] {self.angles_y = self.angles_y + self.lip;self.nextthink = time + 0.2;};
void() corpse_spin5  = [0,	corpse_spin6 ] {self.angles_y = self.angles_y + self.lip;self.nextthink = time + 0.2;};
void() corpse_spin6  = [0,	corpse_spin7 ] 
{

	self.angles_y = self.angles_y + self.lip + self.cnt;


	if (self.count < 20)
		self.think = corpse_spin6;
	self.count = self.count + 1;
};


void() corpse_spin7  = [0,	corpse_spin8 ] {self.angles_y = self.angles_y + self.lip;self.nextthink = time + 0.1;self.count = 0;};
void() corpse_spin8  = [0,	corpse_spin9 ] {self.angles_y = self.angles_y + self.lip;self.nextthink = time + 0.2;};
void() corpse_spin9  = [0,	corpse_spin10] {self.angles_y = self.angles_y + self.lip;self.nextthink = time + 0.2;};
void() corpse_spin10 = [0,	corpse_spin11] {self.angles_y = self.angles_y + self.lip;self.nextthink = time + 0.3;};
void() corpse_spin11 = [0,	corpse_spin12] {self.angles_y = self.angles_y + self.lip;self.nextthink = time + 0.4;};
void() corpse_spin12 = [0,	corpse_spin1 ] 
{

	self.angles_y = self.angles_y + self.lip;
	self.nextthink = time + 1;
	self.t_width = 1 - self.t_width;
};


/*
void() corpse_sway1  = [0,	corpse_sway2 ] {self.angles_z = 1;self.nextthink = time + 0.1;};
void() corpse_sway2  = [0,	corpse_sway3 ] {self.angles_z = 2;self.nextthink = time + 0.1;};
void() corpse_sway3  = [0,	corpse_sway4 ] {self.angles_z = 3;self.nextthink = time + 1;};
void() corpse_sway4  = [0,	corpse_sway5 ] {self.angles_z = 2;self.nextthink = time + 0.1;};
void() corpse_sway5  = [0,	corpse_sway6 ] {self.angles_z = 1;self.nextthink = time + 0.1;};
void() corpse_sway6  = [0,	corpse_sway7 ] {self.angles_z = 0;self.nextthink = time + 0.1;};
void() corpse_sway7  = [0,	corpse_sway8 ] {self.angles_z = -1;self.nextthink = time + 0.1;};
void() corpse_sway8  = [0,	corpse_sway9 ] {self.angles_z = -2;self.nextthink = time + 0.1;};
void() corpse_sway9  = [0,	corpse_sway10] {self.angles_z = -3;self.nextthink = time + 1;};
void() corpse_sway10 = [0,	corpse_sway11] {self.angles_z = -2;self.nextthink = time + 0.1;};
void() corpse_sway11 = [0,	corpse_sway12] {self.angles_z = -1;self.nextthink = time + 0.1;};
void() corpse_sway12 = [0,	corpse_sway1 ] {self.angles_z = 0;self.nextthink = time + 0.1;};
*/
//Sucks, so removed.

//Feet

void() corpse_flayed1 =
{
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	precache_model ("progs/corpsef1.mdl");
	setmodel (self, "progs/corpsef1.mdl");

	self.nextthink = time + 0.5 + (8 * random());
	self.think = corpse_spin1;
};

void() corpse_flayed2 =
{
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	precache_model ("progs/corpsef2.mdl");
	setmodel (self, "progs/corpsef2.mdl");

	self.nextthink = time + 0.5 + (8 * random());
	self.think = corpse_spin1;
};

void() corpse_flayed3 =
{
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	precache_model ("progs/corpsef3.mdl");
	setmodel (self, "progs/corpsef3.mdl");

	self.nextthink = time + 0.5 + (8 * random());
	self.think = corpse_spin1;
};

void() corpse_flayed4 =
{
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	precache_model ("progs/corpsef4.mdl");
	setmodel (self, "progs/corpsef4.mdl");

	self.nextthink = time + 0.5 + (8 * random());
	self.think = corpse_spin1;
};



//Head

void() corpse_lynched1 =
{
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	precache_model ("progs/corpseh1.mdl");
	setmodel (self, "progs/corpseh1.mdl");

	self.nextthink = time + 0.5 + (8 * random());
	self.think = corpse_spin1;
};

void() corpse_lynched2 =
{
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	precache_model ("progs/corpseh2.mdl");
	setmodel (self, "progs/corpseh2.mdl");

	self.nextthink = time + 0.5 + (8 * random());
	self.think = corpse_spin1;
};

void() corpse_lynched3 =
{
	self.movetype = MOVETYPE_NOCLIP;
	self.solid = SOLID_NOT;
	precache_model ("progs/corpseh3.mdl");
	setmodel (self, "progs/corpseh3.mdl");

	self.nextthink = time + 0.5 + (8 * random());
	self.think = corpse_spin1;
};




void() corpse_crucified1 =
{
	precache_model ("progs/corpsec1.mdl");
	setmodel (self, "progs/corpsec1.mdl");
	makestatic (self);
};

void() corpse_crucified2 =
{
	precache_model ("progs/corpsec2.mdl");
	setmodel (self, "progs/corpsec2.mdl");
	makestatic (self);
};





void() corpse_impaled_back1 =
{
	precache_model ("progs/corpsib1.mdl");
	setmodel (self, "progs/corpsib1.mdl");
	makestatic (self);
};

void() corpse_impaled_back2 =
{
	precache_model ("progs/corpsib2.mdl");
	setmodel (self, "progs/corpsib2.mdl");
	makestatic (self);
};

void() corpse_impaled_back3 =
{
	precache_model ("progs/corpsib3.mdl");
	setmodel (self, "progs/corpsib3.mdl");
	makestatic (self);
};



void() corpse_impaled_front1 =
{
	precache_model ("progs/corpsif1.mdl");
	setmodel (self, "progs/corpsif1.mdl");
	makestatic (self);
};

void() corpse_impaled_front2 =
{
	precache_model ("progs/corpsif2.mdl");
	setmodel (self, "progs/corpsif2.mdl");
	makestatic (self);
};

void() corpse_impaled_front3 =
{
	precache_model ("progs/corpsif3.mdl");
	setmodel (self, "progs/corpsif3.mdl");
	makestatic (self);
};


void() corpse_impaled_horizontal1 =
{
	precache_model ("progs/corpsih1.mdl");
	setmodel (self, "progs/corpsih1.mdl");
	makestatic (self);
};

void() corpse_impaled_horizontal2 =
{
	precache_model ("progs/corpsih2.mdl");
	setmodel (self, "progs/corpsih2.mdl");
	makestatic (self);
};

void() corpse_impaled_horizontal3 =
{
	precache_model ("progs/corpsih3.mdl");
	setmodel (self, "progs/corpsih3.mdl");
	makestatic (self);
};

void() corpse_impaled_horizontal4 =
{
	precache_model ("progs/corpsih4.mdl");
	setmodel (self, "progs/corpsih4.mdl");
	makestatic (self);
};



void() corpse_impaled_vertical1 =
{
	precache_model ("progs/corpsiv1.mdl");
	setmodel (self, "progs/corpsiv1.mdl");
	makestatic (self);
};

void() corpse_impaled_vertical2 =
{
	precache_model ("progs/corpsiv2.mdl");
	setmodel (self, "progs/corpsiv2.mdl");
	makestatic (self);
};

void() corpse_impaled_vertical3 =
{
	precache_model ("progs/corpsiv3.mdl");
	setmodel (self, "progs/corpsiv3.mdl");
	makestatic (self);
};