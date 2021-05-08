void gib ()
{
	sound (self, CHAN_VOICE, "blob/death1.wav", 1, ATTN_NORM);
	ThrowGib ("progs/gib1.mdl", self.health);
	ThrowGib ("progs/gib2.mdl", self.health);
	ThrowGib ("progs/gib3.mdl", self.health);
}