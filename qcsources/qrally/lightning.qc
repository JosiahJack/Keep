void() lightning_think = 
{
	local vector org;
	local entity oself;
	if (!(self.flags & LIGHTNING_ON))
	{
		makevectors(self.angles);
		traceline(self.origin, self.origin + v_forward * 600, 1, self);
		org = self.origin;
		sound(self, CHAN_AUTO, "weapons/lhit.wav", 1, ATTN_NORM);
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
		WriteEntity(MSG_BROADCAST, self);
		WriteCoord(MSG_BROADCAST, org_x);
		WriteCoord(MSG_BROADCAST, org_y);
		WriteCoord(MSG_BROADCAST, org_z);
		WriteCoord(MSG_BROADCAST, trace_endpos_x);
		WriteCoord(MSG_BROADCAST, trace_endpos_y);
		WriteCoord(MSG_BROADCAST, trace_endpos_z);
		oself = self;
		self = self.owner;
		lightstyle(self.style, "z");
		self = oself;
		self.flags = self.flags | LIGHTNING_ON;
		self.nextthink = time + 0.3;
	}
	else
	{
		oself = self;
		self = self.owner;
		lightstyle(self.style, "a");
		self = oself;
		self.flags = self.flags - LIGHTNING_ON;
		self.nextthink = time + 0.5 + random() * 1;
	}
};

void() rally_lightning = 
{
	self.think = lightning_think;
	self.nextthink = time + 1 + random() * 2;
};

