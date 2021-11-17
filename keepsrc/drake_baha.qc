// PLAYER / DRAGON (i.e., players in dragon form)

$cd progs/drake/dragon
$origin 0 0 24
$base base 
$skin skin
$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8
$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame attack7 attack8 attack9
$frame pain1 pain2 pain3 pain4 pain5 pain6
$frame painb1 painb2 painb3 painb4 painb5 painb6
$frame painc1 painc2 painc3 painc4 painc5 painc6
$frame death1 death2 death3 death4 death5 death6 death7 death8 death9
$frame death10 death11 death12 death13
$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6

// STAND / RUN
void() baha_button = {if (!self.button0)  self.baha_click = 0;};

void() baha_run =[ $fly1,  player_run  ] {
    local float fadd;

    if ((self.frame > 7) || (self.walkframe >= 13))
        fadd = self.walkframe = 0;
    else if (self.walkframe >= 7)
        fadd = 14 - self.walkframe;
    else
        fadd = self.walkframe;

    self.frame = $fly1 + fadd;
    self.walkframe = self.walkframe + 1;

    if (intermission_running) return;

    if (self.frame == 7) {
		self.view_ofs_z = BAHA_VIEW + 4;
        if (self.waterlevel < 2)
            sound (self, CHAN_BODY, "dragon/fly.wav", 1, ATTN_IDLE);
        else if ((self.liquidbase == CONTENT_WATER) || (self.liquidbase == CONTENT_SLIME))
            sound (self, CHAN_BODY, "dragon/flywater.wav", 1, ATTN_IDLE);
    } else if (self.frame == 6)
        self.view_ofs_z = BAHA_VIEW + 3;
    else if (self.frame == 5)
        self.view_ofs_z = BAHA_VIEW + 2;
    else if (self.frame == 4)
        self.view_ofs_z = BAHA_VIEW + 1;
    else if (self.frame == 3)
        self.view_ofs_z = BAHA_VIEW + 1;
    else
        self.view_ofs_z = BAHA_VIEW;

    baha_button ();
};

void() baha_skip; // Attack ender function found below in this file.

// This returns the point of the dragon's mouth relative to its origin.  All frames from 8 to 16 are part of the attack scene.
vector() Baha_Offset = {
    local float fr;

    fr = self.frame;
	// Small size 32 dragon, used only by players.  Frames 10-12 are not commented out because players can attack during those frames even though AI-controlled dragons do not.
    if (fr==16)  return '24 -3 -5';		if (fr==15)  return '25 -2 0';
    if (fr==14)  return   '26 0 3';     if (fr==13)  return  '23 0 5';
    if (fr==12)  return   '19 0 8';     if (fr==11)  return  '22 0 4';
    if (fr==10)  return   '25 0 1'; // Frames 8 and 9 use the same point.
    return '26 0 0';
};

// For tome buffed dragon.
void() W_EchoFire = {
    local vector dir, spot;

    makevectors (self.v_angle);
    dir = aim (self, 1000);
    dir = Aim_Scatter (dir, '1.2 0.9 0');
    spot = self.angles;
    spot_x = 0 - spot_x;
    makevectors (spot);
    spot = Baha_Offset ();
    spot = self.origin + v_forward*spot_x + v_right*spot_y + v_up*spot_z; // Get the spot where the missile will spawn.
    Ryu_Fire (spot, dir, 1000, 0, 0); // Same attack function the monster uses.
};

// 3/15/2009:  Increased normal firepower by 50%.
void() W_DragonFire = {
    local vector dir, spot;
    local float damage, lite, ft;

    lite = FALSE;
    if (self.t_width < time) {
        sound (self, CHAN_WEAPON, "dragon/fire.wav", 1, ATTN_NORM);
        self.t_width = time + 1;
        self.tracer_time = 0;
    }

	// Get the aim vector to direct missile, then set the damage.
    makevectors (self.v_angle);
    if (self.baha_click == 2) { // Launching a meteor, so do the grenade launcher aim code instead.
        dir = v_forward*1000 + v_up*200;
        if (self.v_angle_x)
            {dir = dir + crandom()*v_right*10; dir = dir + crandom()*v_up*10;}
        dir = normalize (dir);

        if (self.tome_finished) damage = 120;
        else damage = 80;
        self.t_width = 0; // Always play launch sound.
    } else { // Fire spray.
        if (self.tome_finished)
            Echo_Shot (0.05, W_EchoFire);
        else {
			// Update:  4 shots every three frames like medium dragon.
            ft = self.currentammo - (floor (self.currentammo / 3) * 3); // Note:  Assumes ammo does not regenerate during attack.
            if (ft == 2) {Echo_Shot (0.05, W_EchoFire);  return;}
            if (ft == 1) {Echo_Shot (0.025, W_EchoFire);  return;}

            Echo_Shot (0.075, W_EchoFire);
        }

        dir = aim (self, 1000);
        dir = Aim_Scatter (dir, '1.2 0.9 0');
        damage = 0;     // 0 damage = small fireballs.
		if (self.tracer_time <= time) {
			lite = TRUE;
			self.tracer_time = time + 0.5; // Alternate fireball may not be fullbright in all GL ports.  In which case, make one glow once every half second.
		}
    }

	// Get the spot where the missile will spawn.
    spot    = self.angles;
    spot_x  = 0 - spot_x;
    makevectors (spot);
    spot = Baha_Offset ();
    spot = self.origin + v_forward*spot_x + v_right*spot_y + v_up*spot_z;
    Ryu_Fire (spot, dir, 1000, 0, damage); // Same attack function the monster uses.
    if (lite) newmis.effects = newmis.effects | EF_DIMLIGHT;
};

// What the magic numbers mean...
// -- auto --
// 0 = Fire only if the attack button is pressed.
// 1 = Always fire unless out of ammo.
// 2 = Check for double-click.  Do not fire while checking.
// -- .baha_click --
// 0 = Attack button pressed for the first time.
// 1 = Attack button released.
// 2 = Attack button pressed again (twice) while auto is 2.
void(float auto) baha_fire = {
    local float cost;

    if (intermission_running) return;

    cost = COST_BAHA_BOMB;
    self.view_ofs_z = BAHA_VIEW;
    self.weaponframe = 0;
    W_Reload(0.2);
    if (auto == 2) {
        if (self.baha_click == 0) {
			if (!self.button0) self.baha_click = 1;    // Just released attack button.
        } else {
			if (self.button0) {
                self.baha_click = 2;    // Clicked again.
                if (self.baha_ammo < cost) {baha_skip();  return;}  // Out of ammo.
            }
        }
        return;
    }

    if (!auto && !self.button0) {baha_skip ();  return;}  // Not attacking.

    if (self.baha_click == 2) { // Meteor mode
        if (self.baha_ammo < cost) {baha_skip();  return;}  // Out of ammo.
        if (self.frame != 8 && self.frame != 16) return;
    } else { // Rapid-fire mode
        cost = 1;
        if (self.baha_ammo < cost) {baha_skip();  return;}  // Out of ammo.
    }
    self.currentammo = self.baha_ammo = self.baha_ammo - cost;
    W_DragonFire ();
};

void() baha_fire1  =[ $attack1, baha_fire2  ] {baha_fire(2);};
void() baha_fire2  =[ $attack2, baha_fire3  ] {baha_fire(2);};
void() baha_fire3  =[ $attack3, baha_fire4  ] {baha_fire(2);};
void() baha_fire4  =[ $attack4, baha_fire5  ] {baha_fire(2);};
void() baha_fire5  =[ $attack5, baha_fire6  ] {baha_fire(2);};
void() baha_fire6  =[ $attack6, baha_fire7  ] {baha_fire(1);};
void() baha_fire7  =[ $attack7, baha_fire8  ] {baha_fire(1);};
void() baha_fire8  =[ $attack8, baha_fire9  ] {baha_fire(1);};
void() baha_fire9  =[ $attack9, baha_fire10 ] {baha_fire(1);};
void() baha_fire10 =[ $attack8, baha_fire11 ] {baha_fire(1);};
void() baha_fire11 =[ $attack7, baha_fire12 ] {baha_fire(1);};
void() baha_fire12 =[ $attack6, baha_fire13 ] {baha_fire(0);};
void() baha_fire13 =[ $attack5, baha_fire14 ] {baha_fire(0);};
void() baha_fire14 =[ $attack4, baha_fire15 ] {baha_fire(0);};
void() baha_fire15 =[ $attack3, baha_fire16 ] {baha_fire(0);};
void() baha_fire16 =[ $attack2, baha_fire17 ] {baha_fire(0);};
void() baha_fire17 =[ $attack1, baha_fire18 ] {baha_fire(0); if (!self.button0 || intermission_running) {self.think = player_run; self.walkframe = 0;} };
void() baha_fire18 =[ $attack2, baha_fire19 ] {baha_fire(0);};
void() baha_fire19 =[ $attack3, baha_fire20 ] {baha_fire(0);};
void() baha_fire20 =[ $attack4, baha_fire21 ] {baha_fire(0);};
void() baha_fire21 =[ $attack5, baha_fire22 ] {baha_fire(0);};
void() baha_fire22 =[ $attack6, baha_fire23 ] {baha_fire(0);};
void() baha_fire23 =[ $attack7, baha_fire24 ] {baha_fire(0);};
void() baha_fire24 =[ $attack8, baha_fire25 ] {baha_fire(0);};
void() baha_fire25 =[ $attack9, baha_fire26 ] {baha_fire(0);};
void() baha_fire26 =[ $attack8, baha_fire27 ] {baha_fire(0);};
void() baha_fire27 =[ $attack7, baha_fire12 ] {baha_fire(0);};
void() baha_fire28 =[ $attack8, baha_fire29 ] {baha_button();}; // Recovery
void() baha_fire29 =[ $attack7, baha_fire30 ] {baha_button();};
void() baha_fire30 =[ $attack6, baha_fire31 ] {baha_button();};
void() baha_fire31 =[ $attack5, baha_fire32 ] {baha_button();};
void() baha_fire32 =[ $attack4, baha_fire33 ] {baha_button();};
void() baha_fire33 =[ $attack3, baha_fire34 ] {baha_button();};
void() baha_fire34 =[ $attack2, baha_fire35 ] {baha_button();};
void() baha_fire35 =[ $attack1, player_run  ] {baha_button(); self.walkframe = 0;};

void() baha_skip = {
    if ( self.frame == $attack9 ) {self.think = baha_fire28;	  W_Reload(0.8);}
    else if ( self.frame == $attack8 ) {self.think = baha_fire29; W_Reload(0.7);}
    else if ( self.frame == $attack7 ) {self.think = baha_fire30; W_Reload(0.6);}
    else if ( self.frame == $attack6 ) {self.think = baha_fire31; W_Reload(0.5);}
    else if ( self.frame == $attack5 ) {self.think = baha_fire32; W_Reload(0.4);}
    else if ( self.frame == $attack4 ) {self.think = baha_fire33; W_Reload(0.3);}
    else if ( self.frame == $attack3 ) {self.think = baha_fire34; W_Reload(0.2);}
    else if ( self.frame == $attack2 ) {self.think = baha_fire35; W_Reload(0.1);}
    else {self.think = player_run; self.walkframe = 0;}
};

float() PainSound_Baha = {
    if (self.pain_finished > time) return FALSE;

    self.pain_finished = time + 1; // Don't make multiple pain sounds right after each other.  Human form has 0.5.
    if ((self.waterlevel == 3) && (self.liquidbase == CONTENT_WATER || self.liquidbase == CONTENT_SLIME)) { // water pain sounds
        DeathBubbles(1);
        sound (self, CHAN_VOICE, "player/drown1.wav", 1, ATTN_NORM); // 'drown1' for dragon is passable, but 'drown2'?  No way.
        return TRUE;
    }
    sound (self, CHAN_VOICE, "dragon/pain2.wav", 1, ATTN_NORM); // normal pain sounds
    return TRUE;
};

void() baha_pain1  =[ $pain1,  baha_pain2  ] {};
void() baha_pain2  =[ $pain2,  baha_pain3  ] {};
void() baha_pain3  =[ $pain3,  baha_pain4  ] {};
void() baha_pain4  =[ $pain4,  baha_pain5  ] {};
void() baha_pain5  =[ $pain5,  baha_pain6  ] {};
void() baha_pain6  =[ $pain6,  player_run  ] {};

void() baha_painb1 =[ $painb1, baha_painb2 ] {};
void() baha_painb2 =[ $painb2, baha_painb3 ] {};
void() baha_painb3 =[ $painb3, baha_painb4 ] {};
void() baha_painb4 =[ $painb4, baha_painb5 ] {};
void() baha_painb5 =[ $painb5, baha_painb6 ] {};
void() baha_painb6 =[ $painb6, player_run  ] {};

void() baha_painc1 =[ $painc1, baha_painc2 ] {};
void() baha_painc2 =[ $painc2, baha_painc3 ] {};
void() baha_painc3 =[ $painc3, baha_painc4 ] {};
void() baha_painc4 =[ $painc4, baha_painc5 ] {};
void() baha_painc5 =[ $painc5, baha_painc6 ] {};
void() baha_painc6 =[ $painc6, player_run  ] {};

void() baha_pain = {
    if ((self.frame >= $attack1) && (self.frame <= $attack9)) return; // attacking

    if (PainSound_Baha()) { // Show pain only when player makes noise.
        local float r;

        self.walkframe = self.weaponframe = 0;
        r = random();
        if (r < 0.4)
            baha_pain1 ();
        else if (r < 0.8)
            baha_painb1 ();
        else
            baha_painc1 ();
    }
};

void() baha_die1  =[ $death1,  baha_die2  ] {};
void() baha_die2  =[ $death2,  baha_die3  ] {};
void() baha_die3  =[ $death3,  baha_die4  ] {};
void() baha_die4  =[ $death4,  baha_die5  ] {};
void() baha_die5  =[ $death5,  baha_die6  ] {};
void() baha_die6  =[ $death6,  baha_die7  ] {};
void() baha_die7  =[ $death7,  baha_die8  ] {};
void() baha_die8  =[ $death8,  baha_die9  ] {};
void() baha_die9  =[ $death9,  baha_die10 ] {};
void() baha_die10 =[ $death10, baha_die11 ] {};
void() baha_die11 =[ $death11, baha_die12 ] {};
void() baha_die12 =[ $death12, baha_die13 ] {};
void() baha_die13 =[ $death13, PlayerDead ] {};

void() baha_dieb1 =[ $deathb1, baha_dieb2 ] {};
void() baha_dieb2 =[ $deathb2, baha_dieb3 ] {};
void() baha_dieb3 =[ $deathb3, baha_dieb4 ] {};
void() baha_dieb4 =[ $deathb4, baha_dieb5 ] {};
void() baha_dieb5 =[ $deathb5, baha_dieb6 ] {};
void() baha_dieb6 =[ $deathb6, PlayerDead ] {};

void() baha_die = {
    sound (self, CHAN_VOICE, "dragon/death1.wav", 1, ATTN_NONE);
    self.angles_x = self.angles_z = 0;
    if (random() < 0.5) { // Animate the death.
        self.velocity_z = 250 + 100*random();
        baha_die1 ();
    } else baha_dieb1 ();
};