
void() DebugMenu =
{

	if (time - self.delay >= 1)
	{
		centerprint(self, strcat("press 1-8 to choose different monsters to summon",
					"\n ^2[ 1 ]^7 Grunt      ",
					"\n ^2[ 2 ]^7 Enforcer   ",
					"\n ^2[ 3 ]^7 Ogre       ",
					"\n ^2[ 4 ]^7 Zombie     ",
					"\n ^2[ 5 ]^7 Knight     ",
					"\n ^2[ 6 ]^7 DeathKnight"
					"\n ^2[ 0 ]^7 Close Menu "));
			
		local entity monspawner = spawn();
		
		monspawner.origin = self.origin + v_forward*130;
		monspawner.angles = self.angles;
		
		if (self.impulse == 1)
		{
			monspawner.think = monster_army;
		}
		if (self.impulse == 2)
		{
			monspawner.think = monster_enforcer;
		}
		if (self.impulse == 3)
		{
			monspawner.think = monster_ogre;
			monspawner.nextthink = time;
		}	
		if (self.impulse == 4)
		{
			monspawner.think = monster_zombie;
		}
		if (self.impulse == 5)
		{
			monspawner.think = monster_knight;
		}
		if (self.impulse == 6)
		{
			monspawner.think = monster_hell_knight;
		}
		
		if (self.impulse > 0 && self.impulse < 10)
			monspawner.nextthink = time;
		if (self.impulse == 10)
			self.dmenu = 0;
	}
	
	
}
