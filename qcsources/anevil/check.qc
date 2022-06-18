float(entity head, vector spot) PM_TraceCheck = 
{
	local vector p1;
	local vector p2;
	p1 = spot + self.mins;
	p2 = spot + self.maxs;
	traceline(p1, p2, 0, head);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	p1_x = spot_x + self.maxs_x;
	p2_x = spot_x + self.mins_x;
	traceline(p1, p2, 0, head);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	p1_y = spot_y + self.maxs_y;
	p2_y = spot_y + self.mins_y;
	traceline(p1, p2, 0, head);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	p1_x = spot_x + self.mins_x;
	p2_x = spot_x + self.maxs_x;
	traceline(p1, p2, 0, head);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	p1 = p2 = spot + self.maxs;
	p2_z = spot_z + self.mins_z;
	traceline(p1, p2, 0, head);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	p1_x = p2_x = spot_x + self.mins_x;
	traceline(p1, p2, 0, head);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	p1_y = p2_y = spot_y + self.mins_x;
	traceline(p1, p2, 0, head);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	p1_x = p2_x = spot_x + self.maxs_x;
	traceline(p1, p2, 0, head);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	p1 = p2 = spot + self.mins;
	p2_x = spot_x + self.maxs_x;
	traceline(p1, p2, 0, head);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	p1 = p2;
	p2_y = spot_y + self.maxs_y;
	traceline(p1, p2, 0, head);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	p1 = p2;
	p2_x = spot_x + self.mins_x;
	traceline(p1, p2, 0, head);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	p1 = p2;
	p2_y = spot_y + self.mins_y;
	traceline(p1, p2, 0, head);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	p1 = p2 = spot + self.maxs;
	p2_x = spot_x + self.mins_x;
	traceline(p1, p2, 0, head);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	p1 = p2;
	p2_y = spot_y + self.mins_y;
	traceline(p1, p2, 0, head);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	p1 = p2;
	p2_x = spot_x + self.maxs_x;
	traceline(p1, p2, 0, head);
	if (trace_fraction < SPAWNFLAG_SUPERSPIKE)
	{
		return 0;
	}
	p1 = p2;
	p2_y = spot_y + self.maxs_y;
	traceline(p1, p2, 0, head);
	return trace_fraction == SPAWNFLAG_SUPERSPIKE;
};

float(entity head, vector spot) PM_InWall = 
{
	local vector p;
	p = spot;
	if (pointcontents(p) == CONTENT_SOLID)
	{
		return 1;
	}
	if (pointcontents(p) == CONTENT_SKY)
	{
		return 1;
	}
	p_x = spot_x + head.mins_x;
	if (pointcontents(p) == CONTENT_SOLID)
	{
		return 1;
	}
	if (pointcontents(p) == CONTENT_SKY)
	{
		return 1;
	}
	p_x = spot_x + head.maxs_x;
	if (pointcontents(p) == CONTENT_SOLID)
	{
		return 1;
	}
	if (pointcontents(p) == CONTENT_SKY)
	{
		return 1;
	}
	p = spot;
	p_y = spot_y + head.mins_y;
	if (pointcontents(p) == CONTENT_SOLID)
	{
		return 1;
	}
	if (pointcontents(p) == CONTENT_SKY)
	{
		return 1;
	}
	p_y = spot_y + head.maxs_y;
	if (pointcontents(p) == CONTENT_SOLID)
	{
		return 1;
	}
	if (pointcontents(p) == CONTENT_SKY)
	{
		return 1;
	}
	p = spot;
	p_z = spot_z + head.mins_z;
	if (pointcontents(p) == CONTENT_SOLID)
	{
		return 1;
	}
	if (pointcontents(p) == CONTENT_SKY)
	{
		return 1;
	}
	p_z = spot_z + head.maxs_z;
	if (pointcontents(p) == CONTENT_SOLID)
	{
		return 1;
	}
	if (pointcontents(p) == CONTENT_SKY)
	{
		return 1;
	}
	p_x = spot_x + head.maxs_x;
	p_y = spot_y + head.maxs_y;
	if (pointcontents(p) == CONTENT_SOLID)
	{
		return 1;
	}
	if (pointcontents(p) == CONTENT_SKY)
	{
		return 1;
	}
	p_x = spot_x + head.mins_x;
	if (pointcontents(p) == CONTENT_SOLID)
	{
		return 1;
	}
	if (pointcontents(p) == CONTENT_SKY)
	{
		return 1;
	}
	p_x = spot_x + head.maxs_x;
	p_y = spot_y + head.mins_y;
	if (pointcontents(p) == CONTENT_SOLID)
	{
		return 1;
	}
	if (pointcontents(p) == CONTENT_SKY)
	{
		return 1;
	}
	p_x = spot_x + head.mins_x;
	if (pointcontents(p) == CONTENT_SOLID)
	{
		return 1;
	}
	if (pointcontents(p) == CONTENT_SKY)
	{
		return 1;
	}
	p_x = spot_x + head.maxs_x;
	p_y = spot_y + head.maxs_y;
	p_z = spot_z + head.mins_z;
	if (pointcontents(p) == CONTENT_SOLID)
	{
		return 1;
	}
	if (pointcontents(p) == CONTENT_SKY)
	{
		return 1;
	}
	p_x = spot_x + head.mins_x;
	if (pointcontents(p) == CONTENT_SOLID)
	{
		return 1;
	}
	if (pointcontents(p) == CONTENT_SKY)
	{
		return 1;
	}
	p_x = spot_x + head.maxs_x;
	p_y = spot_y + head.mins_y;
	if (pointcontents(p) == CONTENT_SOLID)
	{
		return 1;
	}
	if (pointcontents(p) == CONTENT_SKY)
	{
		return 1;
	}
	p_x = spot_x + head.mins_x;
	if (pointcontents(p) == CONTENT_SOLID)
	{
		return 1;
	}
	return pointcontents(p) == CONTENT_SKY;
};

void(entity head, vector spot) PM_InEmpty = 
{
	local vector p;
	p = spot;
	if (pointcontents(p) != CONTENT_EMPTY)
	{
		return 0;
	}
	p_x = spot_x + head.mins_x;
	if (pointcontents(p) != CONTENT_EMPTY)
	{
		return 0;
	}
	p_x = spot_x + head.maxs_x;
	if (pointcontents(p) != CONTENT_EMPTY)
	{
		return 0;
	}
	p = spot;
	p_y = spot_y + head.mins_y;
	if (pointcontents(p) != CONTENT_EMPTY)
	{
		return 0;
	}
	p_y = spot_y + head.maxs_y;
	if (pointcontents(p) != CONTENT_EMPTY)
	{
		return 0;
	}
	p = spot;
	p_z = spot_z + head.mins_z;
	if (pointcontents(p) != CONTENT_EMPTY)
	{
		return 0;
	}
	p_z = spot_z + head.maxs_z;
	if (pointcontents(p) != CONTENT_EMPTY)
	{
		return 0;
	}
	p_x = spot_x + head.maxs_x;
	p_y = spot_y + head.maxs_y;
	if (pointcontents(p) != CONTENT_EMPTY)
	{
		return 0;
	}
	p_x = spot_x + head.mins_x;
	if (pointcontents(p) != CONTENT_EMPTY)
	{
		return 0;
	}
	p_x = spot_x + head.maxs_x;
	p_y = spot_y + head.mins_y;
	if (pointcontents(p) != CONTENT_EMPTY)
	{
		return 0;
	}
	p_x = spot_x + head.mins_x;
	if (pointcontents(p) != CONTENT_EMPTY)
	{
		return 0;
	}
	p_x = spot_x + head.maxs_x;
	p_y = spot_y + head.maxs_y;
	p_z = spot_z + head.mins_z;
	if (pointcontents(p) != CONTENT_EMPTY)
	{
		return 0;
	}
	p_x = spot_x + head.mins_x;
	if (pointcontents(p) != CONTENT_EMPTY)
	{
		return 0;
	}
	p_x = spot_x + head.maxs_x;
	p_y = spot_y + head.mins_y;
	if (pointcontents(p) != CONTENT_EMPTY)
	{
		return 0;
	}
	p_x = spot_x + head.mins_x;
	return pointcontents(p) == CONTENT_EMPTY;
};

float(entity head) PM_InLiquid = 
{
	if (pointcontents(head.origin) == CONTENT_WATER)
	{
		return 1;
	}
	if (pointcontents(head.origin) == CONTENT_SLIME)
	{
		return 1;
	}
	if (pointcontents(head.origin) == CONTENT_LAVA)
	{
		return 1;
	}
	return 0;
};

