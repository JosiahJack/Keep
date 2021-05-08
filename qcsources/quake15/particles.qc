void() particle_emitter =
{
	self.partname = self.partname;
	self.traileffectnum = particleeffectnum(self.partname);
	
	self = spawn();
	setorigin(self, self.origin);
	
};