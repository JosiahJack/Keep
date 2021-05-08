void() sparkeffect = 
{
	if (self.attack_finished < time)
	{
		remove(self);
	}
	particle(self.origin, VEC_ORIGIN, 111, TE_LIGHTNING2);
	self.nextthink = time + 0.010000;
};

void() fx_think = 
{
	if (self.frame < AS_MELEE)
	{
		self.frame = self.frame + IT_RELIC1;
	}
	else
	{
		if (sprite_count > STATE_TOP)
		{
			sprite_count = sprite_count - IT_RELIC1;
		}
		remove(self);
		return;
	}
	frameskip(0.07);
};

void() firesprite_think = 
{
	if (self.frame < TE_LIGHTNING2)
	{
		self.frame = self.frame + IT_RELIC1;
	}
	else
	{
		if (sprite_count > STATE_TOP)
		{
			sprite_count = sprite_count - IT_RELIC1;
		}
		remove(self);
		return;
	}
	self.nextthink = time + 0.07;
};

void() explodemodel_think = 
{
	if (self.frame < TE_LIGHTNING1)
	{
		self.frame = self.frame + IT_RELIC1;
		if (self.alpha > 0.15)
		{
			self.alpha = self.alpha - 0.15;
		}
	}
	else
	{
		if (sprite_count > STATE_TOP)
		{
			sprite_count = sprite_count - IT_RELIC1;
		}
		remove(self);
		return;
	}
	frameskip(0.07);
};

void() efxflashe_think = 
{
	if (self.frame < TE_LIGHTNING1)
	{
		self.frame = self.frame + IT_RELIC1;
	}
	else
	{
		if (sprite_count > STATE_TOP)
		{
			sprite_count = sprite_count - IT_RELIC1;
		}
		remove(self);
		return;
	}
	self.alpha = self.alpha - 0.15;
	frameskip(0.080000);
};

void() divingshit_think = 
{
	if (self.alpha > 0.1)
	{
		self.alpha = self.alpha - 0.1;
	}
	if (self.frame < TE_LIGHTNING3)
	{
		self.frame = self.frame + IT_RELIC1;
	}
	else
	{
		if (sprite_count > STATE_TOP)
		{
			sprite_count = sprite_count - IT_RELIC1;
		}
		remove(self);
		return;
	}
	frameskip(0.020000);
};

void() dust_think = 
{
	if (self.owner.angles_y == STATE_TOP)
	{
		self.velocity_x = -200;
	}
	else
	{
		if (self.owner.angles_y == 180)
		{
			self.velocity_x = 200;
		}
	}
	if (self.frame < IT_RELIC2)
	{
		self.alpha = 0.3;
		self.frame = self.frame + IT_RELIC1;
	}
	else
	{
		if (sprite_count > STATE_TOP)
		{
			sprite_count = sprite_count - IT_RELIC1;
		}
		remove(self);
		return;
	}
	self.nextthink = time + 0.05;
};

