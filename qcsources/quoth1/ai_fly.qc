void(float dist) ai_walkfly = 
{
	local vector mtemp;
	local vector org;
	local float ass;
	local vector org_flat;
	local vector oldorg_flat;
	local vector oldorg;
	local vector reqvel;
	local float d;
	oldorg = self.origin;
	self.movetype = MOVETYPE_STEP;
	ai_walk(dist);
	d = vlen(self.origin - oldorg);
	self.velocity = VEC_ORIGIN;
	if (d <= dist + AS_BLINDFIRE)
	{
		self.movetype = MOVETYPE_FLY;
		reqvel = normalize(self.origin - oldorg) * dist * TE_WIZSPIKE;
		setorigin(self, oldorg);
		self.velocity = reqvel;
	}
};

void(float dist) ai_runfly = 
{
	local vector mtemp;
	local vector org;
	local float ass;
	local vector org_flat;
	local vector oldorg_flat;
	local vector oldorg;
	local vector reqvel;
	local float d;
	oldorg = self.origin;
	self.movetype = MOVETYPE_STEP;
	ai_run(dist);
	d = vlen(self.origin - oldorg);
	self.velocity = VEC_ORIGIN;
	if (d <= dist + AS_BLINDFIRE)
	{
		self.movetype = MOVETYPE_FLY;
		reqvel = normalize(self.origin - oldorg) * dist * TE_WIZSPIKE;
		setorigin(self, oldorg);
		self.velocity = reqvel;
	}
};

