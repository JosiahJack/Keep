/* ------------------------------------------------ */
/* | The Chain-Lightning Gun - Shoots out a bolt  | */
/* |  of lightning, if there is an enemy near-by  | */
/* |  the lightning will 'chain' onto it.  It     | */
/* |  will continue 'chaining' to enemies until   | */
/* |  it has run out of power.  It starts at      | */
/* |  CHAIN_DAMAGE, and decrements by 5 each time | */
/* |  it 'chains' - about 7 hops.			  | */
/* ------------------------------------------------ */

void(entity zapped) ChainZap =
{
	//dprint("zap\n");
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	WriteCoord (MSG_BROADCAST, (zapped.origin_x + zapped.view_ofs_x));
	WriteCoord (MSG_BROADCAST, (zapped.origin_y + zapped.view_ofs_y));
	WriteCoord (MSG_BROADCAST, (zapped.origin_z + zapped.view_ofs_z));

	sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
	particle (zapped.origin, '0 0 100', 225, 120);
	T_Damage (zapped, self.owner, self.owner, self.dmg);
};


void() MakeChain =
{
local entity	head;

	if (self.dmg <= 0)
	{
		remove(self);
		return;
	}

	head = findradius(self.origin, 500);   //this is how far it will chain
	while (head)
	{
		if (head.flags & FL_MONSTER || head.flags & FL_CLIENT)
		{
		 if (head != self.owner)
		 {
		  if (head != self.aiment)
		  {
		   if (head != self.enemy)
		   {
		    if (head != self.oldenemy)
		    {
		     if (head.health > 0 && head.takedamage)
		     {
			if (visible(head))
			{
			  ChainZap(head);
			  if(!self.aiment)
				self.aiment = head;
			  else if(!self.enemy)
			     	self.enemy = head;
			  else if(!self.oldenemy)
				self.oldenemy = head;
			  self.origin = (head.origin + head.view_ofs);
			  self.think = MakeChain;
			  self.dmg = self.dmg - 5;
			  self.nextthink = time + 0.05;
			  return;
			}
		     }
		    }
		   }
		  }
		 }
		 //dprint("chain refused ");dprint(head.classname);dprint("\n");
		}
		head = head.chain;
	}
	//dprint("chain ran out of entities?\n");
};

// ---------------------------------------------------------
// ChainLightDamage - Trace a single line, and if it hits
// a living creature, then do the damage, and start a new
// entity to be the chain lightning.
// ----------------------------------------------------------
void(vector p1, vector p2, entity from, float damage) ChainLightDamage =
{
local entity	l_chain;

	traceline (p1, p2, FALSE, self);
	if (trace_ent.health > 0 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, (damage - 5));
		l_chain = spawn();
		l_chain.origin = trace_ent.origin;
		l_chain.owner = self;
		l_chain.aiment = trace_ent;
		l_chain.t_width = self.t_width;
		l_chain.dmg = damage - 5;
		l_chain.nextthink = time + 0.01;
		l_chain.think = MakeChain;
	}
};

// ----------------------------------------
// Pretty standard id Lightning gun routine
// ----------------------------------------
void() W_FireChainLight =
{
	local	vector	org;
	local	float		cells;
	local float		CHAIN_DAMAGE = 40;

	if (deathmatch)
		CHAIN_DAMAGE = 35;

	if (self.ammo_cells < 3)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
		return;
	}

// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_cells;
		self.ammo_cells = 0;
		W_SetCurrentAmmo ();
		T_RadiusDamage (self, self, 35*cells, world);
		return;
	}

	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	self.punchangle_x = -2;

	self.currentammo = self.ammo_cells = self.ammo_cells - 3;

	org = self.origin + '0 0 16';
	
	traceline (org, org + v_forward*600, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	ChainLightDamage (self.origin, trace_endpos + v_forward*4, self, CHAIN_DAMAGE);
	if (self.ammo_cells < 3)
	{
		self.weapon = W_BestWeapon ();
		W_SetCurrentAmmo ();
	}
};
