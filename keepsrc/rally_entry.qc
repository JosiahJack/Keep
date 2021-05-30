void() item_rallycar_touch = {
	if (!(other.flags & FL_CLIENT)) return; // Only players can drive!
	if (other.in_a_vehicle) return; // Already in a car

	other.in_a_vehicle = TRUE; // Put them in the vehicle (handled in client_power.qc)
	other.vehicle_index = self.vehicle_index;
	other.vehicle_model = self.mdl;
	other.vehicle_skindex = self.vehicle_skindex;
	localcmd("chase_active 1\n");
	localcmd("chase_back 128\n"); // evil!
	remove(self);
};

void() item_rallycar = {
	if (!self.mdl) self.mdl = "progs/qrally/sumabase.mdl"; // Default to the stock car
	if (self.skin > 1) self.skin = 1; // cap it, models only have 2 skins
	self.vehicle_skindex = self.skin;
	self.solid = SOLID_TRIGGER;
	self.touch = item_rallycar_touch;
	self.scale = 2;
	setmodel(self,self.mdl);
	setsize(self,VEC_HULL2_MIN,VEC_HULL2_MAX);
};