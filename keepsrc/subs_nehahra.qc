vector(float t) mindcrime_lead = {
	local float num;
	local vector dir, megadeth, vec;

	if (t < 1000) {
		num = 1000 - t;
		t = 1000 + num;
	} else {
		num = t - 1000;
		t = 1000 - num;
	}
	t = t * 0.000001;
	megadeth = self.enemy.origin - self.origin;
	num = vlen(megadeth);
	num = num * t;
	vec = self.enemy.velocity;
	vec_z = vec_z * 0.25;
	dir = self.enemy.origin + (vec * num);
	dir = normalize(dir - self.origin);
	return dir;
};