void() PM_Regenerate = 
{
	local float newhealth;
	if (self.count < SPAWNFLAG_SUPERSPIKE)
	{
		return;
	}
	if (self.wait < 0.1)
	{
		return;
	}
	if (self.health >= self.max_health)
	{
		self.healtime = time + self.wait;
		return;
	}
	if (self.healtime > time)
	{
		return;
	}
	if (self.health <= MSG_BROADCAST)
	{
		return;
	}
	newhealth = self.health + self.count;
	if (newhealth >= self.max_health)
	{
		self.health = self.max_health;
	}
	else
	{
		self.health = newhealth;
	}
	self.healtime = time + self.wait;
};

