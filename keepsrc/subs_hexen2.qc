float AdvanceFrame(float min, float max) = {
	if (self.frame < min) {
		self.frame = min;
		return self.frame;
	}

	if (self.frame > max) {
		self.frame = max;
		return self.frame;
	}

	if (self.frame < max) {
		self.frame = self.frame + 1;
		if (self.frame > max) self.frame = min;
		return self.frame;
	}

	return self.frame;
};

float  (entity targ,entity from,float scope)fov =  {
	local vector spot1 = '0.00000 0.00000 0.00000';
	local vector spot2 = '0.00000 0.00000 0.00000';
	local float dot = 0.00000;
	spot1 = (from.origin + from.attack_offset);
	spot2 = ((targ.absmin + targ.absmax) * 0.50000);
	if ((from.classname == "player")) {
	  makevectors ( from.v_angle);
	} else {
	  makevectors ( from.angles);
	}
	dot = (normalize ( (spot2 - spot1)) * v_forward);
	dot = (180.00000 - (dot * 180.00000));
	if ( (dot <= scope) ) return ( TRUE );

	return (FALSE);
};