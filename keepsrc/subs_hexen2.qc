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