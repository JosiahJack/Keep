/*
This source code has been reconstructed from PROGS.DAT and may not be
identical to the original source code.

Copyright (C) 1997 Epochalypse. Malice is a trade name of Quantum Axcess.
*/

void () crate_push =
{
	local vector goto;
	local vector goto2;
	local vector goto_left;
	local vector goto_right;
	local entity head;

	if (other == world)
		return;
	if (other.origin_z > (self.origin_z + 30))
		return;
	if (other.classname == "player")
	{
		droptofloor (0, 0);
		makevectors (other.v_angle);
		goto_x = self.origin_x + (v_forward_x * 11);
		goto_y = self.origin_y + (v_forward_y * 11);
		goto_z = self.origin_z;
		if (self.classname == "small")
		{
			goto2 = (self.origin + (v_forward * 60));
			goto_left = ((self.origin + (v_forward * 30)) + (v_right * -20));
			goto_right = ((self.origin + (v_forward * 30)) + (v_right * 20));
		}
		else
		{
			goto2 = (self.origin + (v_forward * 80));
			goto_left = ((self.origin + (v_forward * 40)) + (v_right * -40));
			goto_right = ((self.origin + (v_forward * 40)) + (v_right * 40));
		}
		head = findradius (goto2, 40);
		while (head)
		{
			if ((((head.classname == "crate_small") || (head.classname == "crate_large")) && (head != self)))
				return;
			head = head.chain;
		}
		if ((((pointcontents (goto2) != CONTENT_SOLID) && (pointcontents (goto_left) != CONTENT_SOLID)) && (pointcontents (goto_right) != CONTENT_SOLID)))
		{
			SUB_CalcMove (goto, 100, SUB_Null);
			if (self.punish_eject > 9)
			{
				sound (self, CHAN_BODY, "misc/crate.wav", 1.00, ATTN_NORM);
				self.punish_eject = 0;
			}
			self.punish_eject = self.punish_eject + 1;
		}
		return;
	}
};


void () thing_crate1 =
{
	local float oldz;

	precache_model ("progs/crate.bsp");
	precache_sound ("misc/crate.wav");
	setmodel (self, "progs/crate.bsp");
	self.classname = "crate_small";
	self.touch = crate_push;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.velocity = VEC_ORIGIN;
	self.origin_z = self.origin_z + 6;
	oldz = self.origin_z;
	if (!droptofloor (0, 0))
	{
		dprint ("Item 'crate' fell out of level at ");
		dprint (vtos (self.origin));
		dprint ("\n");
		remove (self);
		return;
	}
};


void () thing_crate2 =
{
	local float oldz;

	precache_model ("progs/crate2.bsp");
	precache_sound ("misc/crate.wav");
	setmodel (self, "progs/crate2.bsp");
	self.classname = "crate_large";
	self.touch = crate_push;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.velocity = VEC_ORIGIN;
	self.origin_z = self.origin_z + 6;
	oldz = self.origin_z;
	if (!droptofloor (0, 0))
	{
		dprint ("Item 'crate' fell out of level at ");
		dprint (vtos (self.origin));
		dprint ("\n");
		remove (self);
		return;
	}
};


void () barrel_explode =
{
	self.takedamage = DAMAGE_NO;
	T_RadiusDamage (self, self, 100, world);
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	self.origin_z = self.origin_z + 32;
	self.movetype = MOVETYPE_NONE;
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;
	remove (self);
};


void () thing_barrel =
{
	local float oldz;

	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_model ("progs/barrel.mdl");
	setmodel (self, "progs/barrel.mdl");
	self.classname = "barrel";
	self.health = 120;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_YES;
	self.origin_z = self.origin_z + 2;
	oldz = self.origin_z;
	droptofloor (0, 0);
	if ((oldz - self.origin_z) > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos (self.origin));
		dprint ("\n");
		remove (self);
	}
};


void () thing_barrel2 =
{
	local float oldz;

	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;
	precache_model ("progs/barrel2.mdl");
	setmodel (self, "progs/barrel2.mdl");
	self.classname = "barrel";
	self.health = 120;
	self.th_die = barrel_explode;
	self.takedamage = DAMAGE_YES;
	self.origin_z = (self.origin_z + 2);
	oldz = self.origin_z;
	droptofloor (0, 0);
	if ((oldz - self.origin_z) > 250)
	{
		dprint ("item fell out of level at ");
		dprint (vtos (self.origin));
		dprint ("\n");
		remove (self);
	}
};

