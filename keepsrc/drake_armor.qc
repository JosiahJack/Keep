// Returns the damage absorbed by power armor.
// Called by 'T_Damage' in combat.qc.
float(entity targ, float damage, float drain) PowerArmor_Absorb = {
    local   float   save, fuel;

    save = 0;
	save = ceil (damage * 0.5);   // Absorb half damage, round up.
	fuel = floor(targ.ammo_cells * 2);  // uses 1 cell per 2 damage
	if (save > fuel) save = fuel;
	if (drain) {
		targ.ammo_cells = targ.ammo_cells - ceil(save / 2);  // uses 1 cell per 2 damage
		if (targ.ammo_cells < 0) targ.ammo_cells = 0;
		//Update_PowerArmor (targ);
		Particle_Cube (targ, 241, 241);
		sound (targ, CHAN_AUTO, "me/me_fire1.wav", 1, ATTN_NORM);
	}
    return save;
};

// Gives instructions to player.  Called on first pickup of usable armor.
void(entity ent) PowerArmor_Awaken = {
    if (!(other.flags & FL_CLIENT)) return;

    sound (ent, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
    centerprint (ent, "Power Armor!\nPress 'L' to toggle.\nUses cells when hit.");
};

void(entity ent) BerserkerArmor_Awaken = {
    if (!(other.flags & FL_CLIENT)) return;

    sound (ent, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
    centerprint (ent, "Berserker Armor!\nPress 'K' to expend for Quad Damage!");
};

void(entity ent) SpiritArmor_Awaken = {
    if (!(other.flags & FL_CLIENT)) return;

    sound (ent, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
    centerprint (ent, "Spirit Shroud!\nPress 'J' to expend for Invisibility!");
};

void(entity ent) DragonArmor_Awaken = {
    if (!(other.flags & FL_CLIENT)) return;

    sound (ent, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
    centerprint (ent, "Dragon Armor!\nPress 'H' to expend for Invulnerability.");
};

void(entity ent) OnyxArmor_Awaken = {
    if (!(other.flags & FL_CLIENT)) return;

    sound (ent, CHAN_VOICE, "misc/talk.wav", 1, ATTN_NORM);
    centerprint (ent, "Onyx Armor!\nAll damage permanently halved!");
};