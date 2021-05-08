void() mapobject_brazier = 
{
	precache_model("progs/ne_torch.mdl");
	setmodel(self, "progs/ne_torch.mdl");
	FireAmbient();
	makestatic(self);
};

void() light_flame_brazier_short = 
{
	precache_model("progs/brazshrt.mdl");
	setmodel(self, "progs/brazshrt.mdl");
	FireAmbient();
	makestatic(self);
};

void() light_flame_brazier_tall = 
{
	precache_model("progs/braztall.mdl");
	setmodel(self, "progs/braztall.mdl");
	FireAmbient();
	makestatic(self);
};

void() light_torch_long_walltorch = 
{
	precache_model("progs/longtrch.mdl");
	setmodel(self, "progs/longtrch.mdl");
	FireAmbient();
	makestatic(self);
};

void() light_flame_spiky_tall = 
{
	precache_model("progs/spiktrch.mdl");
	setmodel(self, "progs/spiktrch.mdl");
	FireAmbient();
	makestatic(self);
};

void() corpse_flayed1 = 
{
	precache_model("progs/corpse_flay.mdl");
	setmodel(self, "progs/corpse_flay.mdl");
	self.frame = MSG_BROADCAST;
	self.skin = MSG_BROADCAST;
};

void() corpse_flayed2 = 
{
	precache_model("progs/corpse_flay.mdl");
	setmodel(self, "progs/corpse_flay.mdl");
	self.frame = MSG_BROADCAST;
	self.skin = SPAWNFLAG_SUPERSPIKE;
};

void() corpse_flayed3 = 
{
	precache_model("progs/corpse_flay.mdl");
	setmodel(self, "progs/corpse_flay.mdl");
	self.frame = SPAWNFLAG_LASER;
	self.skin = SPAWNFLAG_LASER;
};

void() corpse_flayed4 = 
{
	precache_model("progs/corpse_flay.mdl");
	setmodel(self, "progs/corpse_flay.mdl");
	self.frame = SPAWNFLAG_SUPERSPIKE;
	self.skin = SPAWNFLAG_SUPERSPIKE;
};

void() corpse_lynched1 = 
{
	precache_model("progs/corpse_lynch.mdl");
	setmodel(self, "progs/corpse_lynch.mdl");
	self.frame = MSG_BROADCAST;
	self.skin = MSG_BROADCAST;
};

void() corpse_lynched2 = 
{
	precache_model("progs/corpse_lynch.mdl");
	setmodel(self, "progs/corpse_lynch.mdl");
	self.frame = MSG_BROADCAST;
	self.skin = MSG_BROADCAST;
};

void() corpse_lynched3 = 
{
	precache_model("progs/corpse_lynch.mdl");
	setmodel(self, "progs/corpse_lynch.mdl");
	self.frame = SPAWNFLAG_SUPERSPIKE;
	self.skin = SPAWNFLAG_LASER;
};

void() corpse_crucified1 = 
{
	precache_model("progs/corpse_imp.mdl");
	setmodel(self, "progs/corpse_imp.mdl");
	self.skin = TE_WIZSPIKE;
	self.frame = TE_LIGHTNING3;
	makestatic(self);
};

void() corpse_crucified2 = 
{
	precache_model("progs/corpse_imp.mdl");
	setmodel(self, "progs/corpse_imp.mdl");
	self.skin = SECRET_NO_SHOOT;
	self.frame = TE_LAVASPLASH;
	makestatic(self);
};

void() corpse_impaled_back1 = 
{
	precache_model("progs/corpse_imp.mdl");
	setmodel(self, "progs/corpse_imp.mdl");
	self.skin = MSG_BROADCAST;
	self.frame = MSG_BROADCAST;
	makestatic(self);
};

void() corpse_impaled_back2 = 
{
	precache_model("progs/corpse_imp.mdl");
	setmodel(self, "progs/corpse_imp.mdl");
	self.skin = SPAWNFLAG_SUPERSPIKE;
	self.frame = MSG_BROADCAST;
	makestatic(self);
};

void() corpse_impaled_back3 = 
{
	precache_model("progs/corpse_imp.mdl");
	setmodel(self, "progs/corpse_imp.mdl");
	self.skin = SPAWNFLAG_LASER;
	self.frame = SPAWNFLAG_SUPERSPIKE;
	makestatic(self);
};

void() corpse_impaled_front1 = 
{
	precache_model("progs/corpse_imp.mdl");
	setmodel(self, "progs/corpse_imp.mdl");
	self.skin = MSG_BROADCAST;
	self.frame = SPAWNFLAG_LASER;
	makestatic(self);
};

void() corpse_impaled_front2 = 
{
	precache_model("progs/corpse_imp.mdl");
	setmodel(self, "progs/corpse_imp.mdl");
	self.skin = SPAWNFLAG_SUPERSPIKE;
	self.frame = SPAWNFLAG_LASER;
	makestatic(self);
};

void() corpse_impaled_front3 = 
{
	precache_model("progs/corpse_imp.mdl");
	setmodel(self, "progs/corpse_imp.mdl");
	self.skin = AS_MELEE;
	self.frame = AS_MELEE;
	makestatic(self);
};

void() corpse_impaled_horizontal1 = 
{
	precache_model("progs/corpse_imp.mdl");
	setmodel(self, "progs/corpse_imp.mdl");
	self.skin = MSG_BROADCAST;
	self.frame = SECRET_1ST_DOWN;
	makestatic(self);
};

void() corpse_impaled_horizontal2 = 
{
	precache_model("progs/corpse_imp.mdl");
	setmodel(self, "progs/corpse_imp.mdl");
	self.skin = SPAWNFLAG_SUPERSPIKE;
	self.frame = SECRET_1ST_DOWN;
	makestatic(self);
};

void() corpse_impaled_horizontal3 = 
{
	precache_model("progs/corpse_imp.mdl");
	setmodel(self, "progs/corpse_imp.mdl");
	self.skin = SECRET_1ST_DOWN;
	self.frame = AS_BLINDFIRE;
	makestatic(self);
};

void() corpse_impaled_horizontal4 = 
{
	precache_model("progs/corpse_imp.mdl");
	setmodel(self, "progs/corpse_imp.mdl");
	self.skin = AS_BLINDFIRE;
	self.frame = AS_LOITER;
	makestatic(self);
};

void() corpse_impaled_vertical1 = 
{
	precache_model("progs/corpse_imp.mdl");
	setmodel(self, "progs/corpse_imp.mdl");
	self.skin = MSG_BROADCAST;
	self.frame = TE_WIZSPIKE;
	makestatic(self);
};

void() corpse_impaled_vertical2 = 
{
	precache_model("progs/corpse_imp.mdl");
	setmodel(self, "progs/corpse_imp.mdl");
	self.skin = SPAWNFLAG_SUPERSPIKE;
	self.frame = TE_WIZSPIKE;
	makestatic(self);
};

void() corpse_impaled_vertical3 = 
{
	precache_model("progs/corpse_imp.mdl");
	setmodel(self, "progs/corpse_imp.mdl");
	self.skin = AS_LOITER;
	self.frame = SECRET_NO_SHOOT;
	makestatic(self);
};

