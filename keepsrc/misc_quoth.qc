void () misc_biobox_l = {
	self.mdl = "maps/quoth/b_bio_l.bsp";
	precache_model (self.mdl);
	precache_model ("progs/quoth/polypgib.mdl");
	precache_sound ("quoth/drole/explode3.wav");
	self.noise = "quoth/drole/explode3.wav";
	self.bbmins = '-16 -16 0';
	self.bbmaxs = '16 16 64';
	self.dmg = 80;
	self.skin_override = 3; // Green particle burst
	misc_explobox_setup();
};

void () misc_biobox_s = {
	self.mdl = "maps/quoth/b_bio_s.bsp";
	precache_model (self.mdl);
	precache_model ("progs/quoth/polypgib.mdl");
	precache_sound ("quoth/drole/explode3.wav");
	self.noise = "quoth/drole/explode3.wav";
	self.bbmins = '-16 -16 0';
	self.bbmaxs = '16 16 32';
	self.dmg = 80;
	self.skin_override = 3; // Green particle burst
	misc_explobox_setup();
};

void () misc_plasmabox_l = {
	self.mdl = "maps/quoth/b_plas_l.bsp";
	precache_model (self.mdl);
	precache_sound ("rogue/plasma/explode.wav");
	self.noise = "rogue/plasma/explode.wav";
	self.bbmins = '-16 -16 0';
	self.bbmaxs = '16 16 64';
	self.dmg = 200;
	self.skin_override = 2; // Blue particle burst
	misc_explobox_setup();
};

void () misc_plasmabox_s = {
	self.mdl = "maps/quoth/b_plas_s.bsp";
	precache_model (self.mdl);
	precache_sound ("rogue/plasma/explode.wav");
	self.noise = "rogue/plasma/explode.wav";
	self.bbmins = '-16 -16 0';
	self.bbmaxs = '16 16 32';
	self.dmg = 200;
	self.skin_override = 2; // Blue particle burst
	misc_explobox_setup();
};