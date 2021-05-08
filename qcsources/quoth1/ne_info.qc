void() info_command_use = 
{
	if (self.message)
	{
		localcmd(self.message);
	}
};

void() info_command = 
{
	self.use = info_command_use;
};

void() info_bomb = 
{
	precache_sound("weapons/bomb.wav");
	precache_sound("weapons/bombfar.wav");
	precache_model("progs/v_bomb.mdl");
	precache_model("progs/smlexp.spr");
	precache_model("progs/bigexp.spr");
	precache_model("progs/boom.mdl");
	precache_model("progs/shockwave.mdl");
	self.use = W_Bomb;
};

