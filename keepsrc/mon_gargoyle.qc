/*==============================================================================
GARGOYLE / IMP (Hexen2 Model)
==============================================================================*/
// Fall on back to ground
$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12 death13 death14

// Single attack routine, fling fireball
$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11 attack12 attack13 attack14 attack15 attack16
$frame attack17 attack18 attack19 attack20 attack21

// Classic idle
$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8
$frame fly9 fly10 fly11 fly12 fly13 fly14 fly15 fly16
$frame fly17 fly18 fly19 fly20

// Special minion grow animation
// Removed excessive frames (0.05 timing)
$frame grow1 grow2 grow3 grow4 grow5 grow6 grow7 grow8 grow9 grow10

// Move from perch to flying (can be reversed)
$frame flyup1 flyup2 flyup3 flyup4 flyup5 flyup6 flyup7 flyup8
$frame flyup9 flyup10 flyup11 flyup12 flyup13 flyup14 flyup15 flyup16
$frame flyup17 flyup18 flyup19 flyup20 flyup21 flyup22 flyup23

// Idle animation for perching (sitting down)
$frame perch1 perch2 perch3 perch4 perch5 perch6 perch7 perch8
$frame perch9 perch10 perch11 perch12 perch13 perch14 perch15 perch16
$frame perch17 perch18 perch19 perch20 perch21 perch22 perch23 perch24

// Going into a nosedive
$frame swoop1 swoop2 swoop3 swoop4 swoop5 swoop6 swoop7 swoop8
$frame swoop9 swoop10 swoop11 swoop12 swoop13 swoop14 swoop15 swoop16
$frame swoop17 swoop18 swoop19 swoop20

$frame swpcyc1 swpcyc2 swpcyc3 swpcyc4

$frame swpend1 swpend2 swpend3 swpend4 swpend5 swpend6 swpend7 swpend8
$frame swpend9 swpend10 swpend11 swpend12 swpend13 swpend14 swpend15

$frame swpout1 swpout2 swpout3 swpout4 swpout5 swpout6 swpout7 swpout8
$frame swpout9 swpout10 swpout11 swpout12 swpout13 swpout14 swpout15

void() imp_touch;
void() imp_down1;
void() imp_up1;

void() gargoylewings = { // [FUNCTION]
	if (self.classtype == CT_MONGARGOYLE_MEGA) sound(self,CHAN_ITEM,"drake/imp/swoopbig.wav",1,ATTN_IDLE);
	else sound(self,CHAN_ITEM,"ad171/gargoyle/wings1.wav",1,ATTN_IDLE);
};

// Sets movetype to real flight and other stats needed for swooping.
void() imp_movefly = { // [FUNCTION]
    self.count      = 140;      // Flight speed.
    self.yaw_speed  = 30;
    self.velocity   = '0 0 0';
    self.movetype   = MOVETYPE_FLY;
    self.touch      = imp_touch;
    gargoylewings();
};

// Sets imp movement to movetype_step and other stats.
void() imp_movestep = { // [FUNCTION]
    self.count      = 0;
    self.yaw_speed  = 15;
    self.velocity   = '0 0 0';
    self.movetype   = MOVETYPE_STEP;
    self.touch      = SUB_Null;
    self.flags      = self.flags - (self.flags & FL_ONGROUND);
};

// Make the imp ready for dodging.
void(float left, float motion) imp_set_dodge = { // [FUNCTION]
    self.lefty = left;
    self.attack_state = motion;
    if (motion == AS_VERTICAL) {
        if (self.movetype == MOVETYPE_FLY) imp_movestep (); // Break out of swoop physics.

        self.waitmin = time + 1.5;
        if (left) imp_down1 ();
        else imp_up1 ();
    } else self.waitmin = time + 1;
};

void()	garg_idle1	= [	$fly2,	garg_idle2	] { monster_idle_sound(); ai_stand(); };
void()	garg_idle2	= [	$fly4,	garg_idle3	] { ai_stand(); };
void()	garg_idle3	= [	$fly6,	garg_idle4	] { gargoylewings(); ai_stand(); };
void()	garg_idle4	= [	$fly8,	garg_idle5	] { ai_stand(); };
void()	garg_idle5	= [	$fly10,	garg_idle6	] { ai_stand(); };
void()	garg_idle6	= [	$fly12,	garg_idle7	] { ai_stand(); };
void()	garg_idle7	= [	$fly14,	garg_idle8	] { ai_stand(); };
void()	garg_idle8	= [	$fly16,	garg_idle9	] { ai_stand(); };
void()	garg_idle9	= [	$fly18,	garg_idle10	] { ai_stand(); };
void()	garg_idle10	= [	$fly20,	garg_idle1	] { ai_stand(); };


void()	garg_walk1	= [	$fly1,	garg_walk2	] { monster_idle_sound(); ai_walk(8); };
void()	garg_walk2	= [	$fly3,	garg_walk3	] { ai_walk(8); };
void()	garg_walk3	= [	$fly5,	garg_walk4	] { gargoylewings(); ai_walk(8); };
void()	garg_walk4	= [	$fly7,	garg_walk5	] { ai_walk(8); };
void()	garg_walk5	= [	$fly9,	garg_walk6	] { ai_walk(8); };
void()	garg_walk6	= [	$fly11,	garg_walk7	] { ai_walk(8); };
void()	garg_walk7	= [	$fly13,	garg_walk8	] { ai_walk(8); };
void()	garg_walk8	= [	$fly15,	garg_walk9	] { ai_walk(8); };
void()	garg_walk9	= [	$fly17,	garg_walk10	] { ai_walk(8); };
void()	garg_walk10	= [	$fly19,	garg_walk1	] { ai_walk(8); };


void()	garg_run1	= [	$fly1,	garg_run2	] { // [FUNCTION]
	monster_idle_sound();
	if (self.attachment && self.attachment.state == STATE_ON) SUB_FinishAttachment();
	// Switch direction of strafing (random duration)
	if (self.meleeattack < time) {
		self.meleeattack = time + 4 + (random() + random() + random() * 4);
		self.lefty = rint(1 - self.lefty);
	}
	ai_run(4);
};
void()	garg_run2	= [	$fly3,	garg_run3	] { ai_run(5); };
void()	garg_run3	= [	$fly5,	garg_run4	] { gargoylewings(); ai_run(6); };
void()	garg_run4	= [	$fly7,	garg_run5	] { ai_run(7); };
void()	garg_run5	= [	$fly9,	garg_run6	] { ai_run(8); };
void()	garg_run6	= [	$fly11,	garg_run7	] { ai_run(4); };
void()	garg_run7	= [	$fly13,	garg_run8	] { ai_run(5); };
void()	garg_run8	= [	$fly15,	garg_run9	] { ai_run(6); };
void()	garg_run9	= [	$fly17,	garg_run10	] { ai_run(7); };
void()	garg_run10	= [	$fly19,	garg_run1	] { ai_run(8); };

// 25 27 29 31 33 35 25 15 5 -5
// Note:  Imp will be locked in a mini-swoop, so don't call ai_run until
// it is done.  Use 'ai_up(-dist)' to move.
void() imp_down1  =[ $swoop1,   imp_down2  ] {};    //ai_down(0);};
void() imp_down2  =[ $swoop3,   imp_down3  ] {ai_down(4);};
void() imp_down3  =[ $swoop5,   imp_down4  ] {ai_down(8);};
void() imp_down4  =[ $swoop7,   imp_down5  ] {ai_down(16);};
void() imp_down5  =[ $swoop9,   imp_down6  ] {ai_down(24);};
void() imp_down6  =[ $swoop11,  imp_down7  ] {ai_down(32);};
void() imp_down7  =[ $swoop13,  imp_down8  ] {ai_down(32);};
void() imp_down8  =[ $swoop15,  imp_down9  ] {ai_down(24);};
void() imp_down9  =[ $swoop17,  imp_down10 ] {ai_down(16);};
void() imp_down10 =[ $swoop19,  imp_down11 ] {ai_down(8);};
void() imp_down11 =[ $swpout3,  imp_down12 ] {};    //ai_run(0);};
void() imp_down12 =[ $swpout5,  imp_down13 ] {};    //ai_run(0);};
void() imp_down13 =[ $swpout7,  imp_down14 ] {};    //ai_run(0);};
void() imp_down14 =[ $swpout9,  imp_down15 ] {};    //ai_run(0);};
void() imp_down15 =[ $swpout11, garg_run1    ] {};    //ai_run(0);};

// 30 30 31 31 32 32 33 20 10 0
void() imp_up1  =[ $fly1,  imp_up2  ] {ai_run(8);};
void() imp_up2  =[ $fly3,  imp_up3  ] {ai_run(16);};
void() imp_up3  =[ $fly5,  imp_up4  ] {ai_run(24);};
void() imp_up4  =[ $fly7,  imp_up5  ] {ai_run(32);};
void() imp_up5  =[ $fly9,  imp_up6  ] {ai_run(32);};
void() imp_up6  =[ $fly11, imp_up7  ] {ai_run(24);};
void() imp_up7  =[ $fly13, imp_up8  ] {ai_run(16);};
// Note:  Hexen2 froze $fly14 a few frames for longer ascent.
void() imp_up8  =[ $fly14, imp_up9  ] {ai_run(12);};
void() imp_up9  =[ $fly14, imp_up10 ] {ai_run(12);};
void() imp_up10 =[ $fly15, imp_up11 ] {ai_run(8);};
void() imp_up11 =[ $fly17, imp_up12 ] {ai_run(4);};
void() imp_up12 =[ $fly19, garg_run1  ] {ai_run(0);};

// Range attack
void() garg_fbthrow = { // [FUNCTION]
	local vector org, dir;
	
	makevectors(self.angles);
	org = self.origin + attack_vector(self.attack_offset);
	dir = normalize(SUB_orgEnemyTarget() - org);
	self.attack_speed = SPEED_GARGMISSILE + (skill * SPEED_GARGSKILL);
	launch_projectile(org,dir,NO_SPIN,CT_PROJ_GARG,self.attack_speed);
};

void(float fbframe, vector fbofs) garg_fbupdate = { // [FUNCTION]
	if (self.health < 1) return;
	if (!self.attachment) {
		self.attachment = spawn();
		self.attachment.owner = self;
		self.attachment.classtype = CT_ATTACHMENT;
		self.attachment.mdl = MODEL_PROJ_GARGBALL;
		self.attachment.alpha = 0.85;
	}
	
	if (fbframe == 0) {
		self.attachment.state = STATE_ON;
		self.pain_finished = time + 1.5;		//don't go into pain whilst firing
		setorigin(self.attachment, self.origin);
		setmodel(self.attachment, self.attachment.mdl);
		setsize (self.attachment, VEC_ORIGIN, VEC_ORIGIN);
		self.attachment.movetype = MOVETYPE_NONE;
		self.attachment.solid = SOLID_NOT;
		sound(self,CHAN_WEAPON,"ad171/gargoyle/attack1.wav",1,ATTN_NORM);
	}

	ai_face();					// Turn towards enemy
	makevectors(self.angles);
	self.attachment.origin = self.origin + v_forward*fbofs_x + v_right*fbofs_y;
	self.attachment.origin_z = self.attachment.origin_z + fbofs_z;
	setorigin(self.attachment, self.attachment.origin);
	self.attachment.angles = self.angles;
	self.attachment.frame = fbframe;
};

// Original offset position for gargoyle fireball (designed for a sprite)
// 10 16 0, 4 24 2, -7 28 15, -25 26 28, -38 12 45, -38 9 45, -17 36 30, 24 16 10
// Changed the offset to match the new model instead
// Positioned the fireball to match the hand orientation
void() garg_fire1	= [$attack2, garg_fire2 ] { garg_fbupdate(0,'10 16 -2'); };
void() garg_fire2	= [$attack4, garg_fire3 ] { garg_fbupdate(2,'0 20 -2'); };
void() garg_fire3	= [$attack6, garg_fire4 ] { garg_fbupdate(3,'-6 23 6');gargoylewings(); };
void() garg_fire4	= [$attack8, garg_fire5 ] { garg_fbupdate(4,'-16 26 18'); };
void() garg_fire5	= [$attack10, garg_fire6 ] { garg_fbupdate(5,'-29 18 38'); };
void() garg_fire6	= [$attack12, garg_fire7 ] { garg_fbupdate(4,'-34 9 45'); };
void() garg_fire7	= [$attack14, garg_fire8 ] { garg_fbupdate(3,'-32 22 38'); };
void() garg_fire8	= [$attack16, garg_fire9 ] { SUB_FinishAttachment(); garg_fbthrow(); };
void() garg_fire9	= [$attack18, garg_fire10 ] { ai_face();monster_idle_sound(); };
void() garg_fire10	= [$attack20, garg_run1 ] { ai_face();
	// If enemy really close, goto into a frenzy of fireball attacks
	self.enemydist = range_distance(self.enemy,FALSE);
	if (SUB_healthEnemyTarget() > 0 && self.enemydist < MON_RANGE_CLOSE) self.think = garg_fire1;
	else self.attack_state = AS_STRAIGHT;
};

void()	garg_perch1	= [	$perch2,	garg_perch2	] { monster_idle_sound(); ai_stand(); };
void()	garg_perch2	= [	$perch4,	garg_perch3	] { ai_stand(); };
void()	garg_perch3	= [	$perch6,	garg_perch4	] { ai_stand(); };
void()	garg_perch4	= [	$perch8,	garg_perch5	] { ai_stand(); };
void()	garg_perch5	= [	$perch10,	garg_perch6	] { ai_stand(); };
void()	garg_perch6	= [	$perch12,	garg_perch7	] { ai_stand(); };
void()	garg_perch7	= [	$perch14,	garg_perch8	] { ai_stand(); };
void()	garg_perch8	= [	$perch16,	garg_perch9	] { ai_stand(); };
void()	garg_perch9	= [	$perch18,	garg_perch10	] { ai_stand(); };
void()	garg_perch10= [	$perch20,	garg_perch11	] { ai_stand(); };
void()	garg_perch11= [	$perch22,	garg_perch12	] { ai_stand(); };
void()	garg_perch12= [	$perch24,	garg_perch1	] { ai_stand(); };

// Sightsound and very quick animation while moving forward
void()	garg_wakeup1	= [	$flyup2,	garg_wakeup2	] {};
void()	garg_wakeup2	= [	$flyup4,	garg_wakeup3	] { ai_forward(4); };
void()	garg_wakeup3	= [	$flyup6,	garg_wakeup4	] { ai_forward(8); };
void()	garg_wakeup4	= [	$flyup14,	garg_wakeup5	] { ai_forward(8);gargoylewings(); };
void()	garg_wakeup5	= [	$flyup16,	garg_wakeup6	] { ai_forward(4); };
void()	garg_wakeup6	= [	$flyup20,	garg_run1	] {
	self.spawnstatue = FALSE;	// No longer stationary
	self.th_stand = garg_idle1;	// Restore all think state functions
	self.th_walk = garg_walk1;
	self.th_run = garg_run1;
	self.th_missile = garg_fire1;
	monster_targets();			// Find target (angry/path_corner)
	self.nextthink = time + 0.1;// Next frame
};

void() gargoyle_wakeup = { // [FUNCTION]
	// Dead already?
	if (self.health < 1) return;

	self.takedamage = DAMAGE_AIM;		// Can receive damage
	self.use = SUB_Null;				// no re-trigger
	
	// Only call wakeup function once
	self.th_walk = self.th_run = SUB_Null;

	// No longer need statue spawnflag, remove it
	if (self.spawnflags & MON_STATUE) 
		self.spawnflags = self.spawnflags - MON_STATUE;
	
	// No longer need perch spawnflag, remove it
	if (self.spawnflags & MON_GARGOYLE_PERCH) 
		self.spawnflags = self.spawnflags - MON_GARGOYLE_PERCH;

	// Allow gargoyle to fly up, no more ground checks
	if (!(self.flags & FL_FLY)) self.flags = self.flags | FL_FLY;
	self.movetype = MOVETYPE_STEP;
	// self.movetype = MOVETYPE_FLY;		// Original setup
	self.pain_finished = time + 1.5;		// No pain
	SUB_AttackFinished(2 + random());		// No attacking
	garg_wakeup1();
};

void() gargoyle_statue = { // [FUNCTION]
	if (random() < MON_IDLE_SOUND) sound(self,CHAN_VOICE, self.idle_sound,1,ATTN_NORM);
	
 	self.think = gargoyle_statue;
 	self.nextthink = time + 5 + random()*5;
};

// MINION - Grow and spin up from nothing
void() gargoyle_grow1 = [$grow1, gargoyle_grow2 ] {};
void() gargoyle_grow2 = [$grow2, gargoyle_grow3 ] { SUB_GrowAngle(); };
void() gargoyle_grow3 = [$grow3, gargoyle_grow4 ] { SUB_GrowAngle(); };
void() gargoyle_grow4 = [$grow4, gargoyle_grow5 ] { SUB_GrowAngle(); };
void() gargoyle_grow5 = [$grow5, gargoyle_grow6 ] { SUB_GrowAngle(); };
void() gargoyle_grow6 = [$grow6, gargoyle_grow7 ] { SUB_GrowAngle(); };
void() gargoyle_grow7 = [$grow7, gargoyle_grow8 ] { SUB_GrowAngle(); };
void() gargoyle_grow8 = [$grow8, gargoyle_grow9 ] { SUB_GrowAngle(); };
void() gargoyle_grow9 = [$grow9, gargoyle_grow10] { SUB_GrowAngle(); };
void() gargoyle_grow10= [$grow10, garg_run1 ] {
	// Is the gargoyle stuck? cannot move?
	if (pointcontents(self.origin) == CONTENT_SOLID) {
		// Time to die!
		self.health = self.gibhealth;
		Killed(self, self);
	} else {
		// Finally spin back to original position
		self.angles_y = self.angles_y + self.lefty;
		// Setup goals and warn other monsters
		FoundHuntTarget(TRUE);

		// Restore all think state functions
		self.th_stand = garg_idle1;
		self.th_walk = garg_walk1;
		self.th_run = garg_run1;
		self.th_missile = garg_fire1;
		self.scale = 1;
	}
};

void() gargoyle_grow = { // [FUNCTION]
	// Only call wakeup function once
	self.th_stand = self.th_walk = self.th_run  = SUB_Null;
	if (random() < 0.5) self.lefty = 36;
	else self.lefty = -36;
	monster_sightsound();
	gargoyle_grow1();
};

// ATTACK (Swoop)
// Called and used only by imp_tocuh.
void() imp_swpend = { // [FUNCTION]
    self.flags = self.flags - (self.flags & FL_ONGROUND);
    self.velocity_x = self.velocity_x / 1.2;
    self.velocity_y = self.velocity_y / 1.2;
    self.velocity_z = self.velocity_z + 30;     //Hexen2 used 15.
};

void() imp_swpend1  =[ $swpend1,  imp_swpend2  ] {imp_swpend();};
void() imp_swpend2  =[ $swpend3,  imp_swpend3  ] {imp_swpend();};
void() imp_swpend3  =[ $swpend5,  imp_swpend4  ] {imp_swpend();};
void() imp_swpend4  =[ $swpend7,  imp_swpend5  ] {imp_swpend();};
void() imp_swpend5  =[ $swpend9,  imp_swpend6  ] {imp_swpend();};
void() imp_swpend6  =[ $swpend11, imp_swpend7  ] {imp_swpend();};
void() imp_swpend7  =[ $swpend13, imp_swpend8  ] {imp_swpend();};
void() imp_swpend8  =[ $swpend15, garg_run1      ] {imp_swpend(); SUB_AttackFinished(1); imp_movestep();};

void() imp_bounce1  =[ $swoop9,  imp_bounce2  ] {imp_swpend();};
void() imp_bounce2  =[ $swoop7,  imp_bounce3  ] {imp_swpend();};
void() imp_bounce3  =[ $swoop5,  imp_bounce4  ] {imp_swpend();};
void() imp_bounce4  =[ $swoop3,  imp_bounce5  ] {imp_swpend();};
void() imp_bounce5  =[ $swoop1,  garg_run1      ] {imp_swpend(); SUB_AttackFinished(1); imp_movestep();};

void() garg_pain1;

void() imp_touch = { // [FUNCTION]
    local float damage, dx;

    self.touch = SUB_Null;
    if ( (( self.frame >= $swpcyc1 ) && ( self.frame <= $swpcyc4 ))
		|| (( self.frame >= $swoop10 ) && ( self.frame <= $swoop20 )) ) { // PM:  Included more frames that imp can damage other with.
        self.flags = self.flags - (self.flags & FL_ONGROUND);
        sound (self, CHAN_WEAPON,"drake/weapons/axhit.wav", 1, ATTN_NORM);
        if ( self.frame <= $swoop15 ) self.think = imp_bounce1;
        else self.think = imp_swpend2;   //swpend1;

        if (other.takedamage) {
            if (( self.frame >= $swpcyc1 ) && ( self.frame <= $swpcyc4 )) dx = self.count;
            else if (( self.frame >= $swoop16 ) && ( self.frame <= $swoop20 )) dx = ( self.frame - $swoop16 ) * 5;
            else dx = 0;

            damage = 10 + dx / 2; // Damage was x4/3, a bit much now.
            damage = damage * 1.2; // Hexen2 pcs began with sub-100 hp.
            if (self.classtype == CT_MONGARGOYLE_MEGA) damage = 30 + dx * 2; // Hexen2 damage was 33+dx*5 -- way too much!
            T_Damage(other,self,self,damage,DAMARMOR);
        } else if ( self.frame > $swoop15 ) {
            imp_movestep();
            garg_pain1();
        }
    } else {
        if ( self.frame <= $swoop9 ) { // Extra recovery logic.
            if ( self.frame <= $swoop3 ) self.think = imp_bounce5;
            else if ( self.frame <= $swoop5 ) self.think = imp_bounce4;
            else if ( self.frame <= $swoop7 ) self.think = imp_bounce3;
            else self.think = imp_bounce2;
        } else if ( self.frame >= $swpout9 ) self.think = garg_run1;
        else if ( self.frame >= $swpout5 ) self.think = imp_swpend3;
        else self.think = imp_swpend2;

        if (vlen(self.velocity) > 300) sound(self, CHAN_WEAPON, "drake/weapons/axhit.wav", 1, ATTN_NORM);
    }
};

void() imp_slow = { // [FUNCTION]
    if (self.velocity_x > 10) self.velocity_x = self.velocity_x / 2;
    else self.velocity_x = 0;

    if (self.velocity_y > 10) self.velocity_y = self.velocity_y / 2;
    else self.velocity_y = 0;
};

void() imp_abort1  =[ $swpout1,  imp_abort2  ] {imp_slow();};
void() imp_abort2  =[ $swpout3,  imp_abort3  ] {imp_slow();};
void() imp_abort3  =[ $swpout5,  imp_abort4  ] {imp_slow();};
void() imp_abort4  =[ $swpout7,  imp_abort5  ] {imp_slow();};
void() imp_abort5  =[ $swpout9,  imp_abort6  ] {imp_slow();};
void() imp_abort6  =[ $swpout11, imp_abort7  ] {imp_slow();};
void() imp_abort7  =[ $swpout13, imp_abort8  ] {imp_slow();};
void() imp_abort8  =[ $swpout15, garg_run1     ] {imp_slow(); SUB_AttackFinished(1);};

// Charging.
void() imp_charge = { // [FUNCTION]
	local float tempfov;

    if (self.enemy.attack_time + 0.5 > time) {
		tempfov = self.fov;
		self.fov = 0.5; // 45 degrees
        if (infront(self.enemy)) {
			self.fov = tempfov; 
            if (vlen(self.enemy.origin - self.origin) > 250) { // PM:  Also added more checks.
                self.velocity_z = self.velocity_z + 150;
                imp_abort1 ();
                return;
            } // ELSE... keep going for the hit!
        }
		self.fov = tempfov;
    }
    if (visible(self.enemy))
    if (infront(self.enemy))
    if (range(self.enemy) < RANGE_FAR)
    {
        local   vector  spot1, spot2, dir;

        spot1 = self.origin;    //Midpoint (self);
        spot2 = Aimpoint (self.enemy);
        dir = normalize (spot2 - spot1);
        self.velocity = dir * (self.count * 10 + 500);   //(self.count * 7 + 377);

        ai_face();
        // Should increment counter by 2 due to game framerate differences,
        // but the swoop wouldn't last long enough for long range attacking.
        // Thus, up counter by 1, not 2, to give roughly three second swoop.
        self.count = self.count + 1;
        if (self.flags & FL_ONGROUND || self.count > 30)
        {
            self.flags = self.flags - (self.flags & FL_ONGROUND);
            imp_abort1 ();
        }
        return;
    }
    imp_abort1 ();
};
void() imp_charge1 =[ $swpcyc1,  imp_charge2 ] {imp_charge();};
void() imp_charge2 =[ $swpcyc2,  imp_charge3 ] {imp_charge();};
void() imp_charge3 =[ $swpcyc3,  imp_charge4 ] {imp_charge();};
void() imp_charge4 =[ $swpcyc4,  imp_charge1 ] {imp_charge();};

// Dive-and-swoop.
void() imp_dive;
void() imp_swoop1  =[ $swoop1,  imp_swoop2  ] {imp_movefly(); imp_dive();};
void() imp_swoop2  =[ $swoop3,  imp_swoop3  ] {imp_dive();};
void() imp_swoop3  =[ $swoop5,  imp_swoop4  ] {imp_dive();};
void() imp_swoop4  =[ $swoop7,  imp_swoop5  ] {imp_dive();};
void() imp_swoop5  =[ $swoop9,  imp_swoop6  ] {imp_dive();};
void() imp_swoop6  =[ $swoop11, imp_swoop7  ] {imp_dive();};
void() imp_swoop7  =[ $swoop13, imp_swoop7  ] {imp_dive();};  // Loop
void() imp_swoop8  =[ $swoop15, imp_swoop9  ] {imp_dive();};
void() imp_swoop9  =[ $swoop17, imp_swoop10 ] {imp_dive();};
void() imp_swoop10 =[ $swoop19, imp_charge1 ] {imp_dive(); self.count = 0;};
void() imp_dive = { // [FUNCTION]
    ai_face();
    self.count = self.count * 1.3225;   // 1.15 * 1.15 = 1.3225.
    if ( self.frame >= $swoop12 )
    {
        local   vector  spot1, spot2, dir;

        spot1 = self.origin;
        spot1_z = self.absmin_z;
        spot2 = Aimpoint(self.enemy);
        dir = normalize(spot2 - spot1);
        self.velocity = dir * self.count;
        if ( self.frame <= $swoop13 )
            self.velocity_x = self.velocity_y = 0;
        if ( self.frame == $swoop13 )
            if (self.absmin_z - self.enemy.absmax_z > 50)
                self.frame = $swoop12;
    }
    if (( self.frame == $swoop12 ) || ( self.frame == $swoop13 ))
    {
        if ((self.flags & FL_ONGROUND) || (self.origin_z - self.enemy.origin_z < 60))
        {
            self.flags = self.flags - (self.flags & FL_ONGROUND);
            self.count = 280;
            self.think = imp_swoop8;
        }
        // PM:  Always send the imp down so it doesn't get stuck in loop.
        else if (self.velocity_z > -80)
            self.velocity_z = -80;      // Equivalent to 8 pixel shift.
    }
    // If last frame, set speed to 0.  (Done elsewhere.)
};

float() imp_guard = { // [FUNCTION]
	local float dist, dot, tempfov;
    local vector p1, p2, pd;

    if (self.enemy.attack_time + 0.5 < time) return FALSE; // Hexen2 used one second.  Too long for me, so use half that.

	tempfov = self.fov;
	self.fov = 0.5;
    if (infront(self.enemy)) {
		self.fov = tempfov;
        p1 = self.enemy.origin + '0 0 16';   // player firing point - close enough.
        p2 = Midpoint (self);       // Imp's center.
    	// PM:  The rest differs from Hexen2 to something I can understand more easily.
        pd = normalize (p2 - p1);
        if (self.enemy.flags & FL_CLIENT) {
            makevectors (self.enemy.v_angle);
            pd = v_forward;
        }
        else if (self.pain_finished <= time) return FALSE;   // Don't dodge monsters unless hurt recently.

        makevectors (self.angles);
        dot = pd * v_right;
        if (dot > 0.1) { // Go left.
            imp_set_dodge (1, AS_SLIDING);
            return TRUE;
        }
        if (dot < -0.1) { // Go right.
            imp_set_dodge (0, AS_SLIDING);
            return TRUE;
        }
        if (self.classtype == CT_MONGARGOYLE_MEGA)
            dist = 0.5; // Don't let imp lords swoop so easily.
        else
            dist = 0.2;
        dot = pd * v_up;
        if (dot > dist)
        {   // Go down.
            imp_set_dodge (1, AS_VERTICAL);
            return TRUE;
        }
        // PM:  Changed to <= so imps can go up sometimes from centered aim.
        if (dot <= 0)   //(dot < 0)
        {   // Go up.
            imp_set_dodge (0, AS_VERTICAL);
            return TRUE;
        }
    }
	self.fov = tempfov;
    return FALSE;
};

// Straight swoop.
void() imp_out = { // [FUNCTION]
    ai_face();
//    if ( !((self.enemy.flags & FL_CLIENT) && (self.enemy.war & WARx_AXE_FRAMES)) )
    if (imp_guard ())   // Abort if TRUE.
    {
        if (self.attack_state != AS_VERTICAL)
            garg_run1 ();
//        return;
    }
};
void() imp_swpout1  =[ $swpout15, imp_swpout2  ] {imp_movefly(); imp_out();};
void() imp_swpout2  =[ $swpout13, imp_swpout3  ] {imp_out();};
void() imp_swpout3  =[ $swpout11, imp_swpout4  ] {imp_out();};
void() imp_swpout4  =[ $swpout9,  imp_swpout5  ] {imp_out();};
void() imp_swpout5  =[ $swpout7,  imp_swpout6  ] {imp_out();};
void() imp_swpout6  =[ $swpout5,  imp_swpout7  ] {imp_out();};
void() imp_swpout7  =[ $swpout3,  imp_swpout8  ] {imp_out();};
void() imp_swpout8  =[ $swpout1,  imp_charge1  ] {self.count = 0; imp_out();};

// Select an attack for the imp to use.
void() ImpAttack = {
    local float  lo, nodrop, dx, dy;
    local vector spot1, spot2, spot3, down;

    if (self.classtype == CT_MONGARGOYLE_MEGA && random() < 0.5) { garg_fire1();  return; } // Lords shoot more and dive less.

    nodrop = FALSE;
    spot1 = Midpoint(self);     //self.origin + self.view_ofs;
    spot2 = self.enemy.origin + '0 0 16';   //self.enemy.view_ofs;
    spot3 = spot2;
    spot3_z = spot1_z;
    dx = vlen(spot3 - spot1);
    if (self.classtype == CT_MONGARGOYLE_MEGA) dy = self.absmin_z - spot2_z;
    else dy = spot1_z - spot2_z;

    if (dy <= 36) if (random() < 0.3) nodrop = TRUE;
    if (self.classtype == CT_MONGARGOYLE_MEGA) lo = 140;
    else lo = 100;

    if (dx > lo)
        if ((dy > 36) || nodrop) {
            down = '0 0 -1' * dy;
            fat_trace (spot1, spot1 + down);
            if ((trace_fraction == 1) || nodrop) {
                if (nodrop) traceline (spot1, spot2, 2, self);
                else traceline (spot1 + down, spot2, 2, self);

                if (trace_ent == self.enemy) {
                    if (nodrop) imp_swpout1(); // Head straight.
                    else imp_swoop1(); // Dive, then go.

                    return;
                }
            }
        }

    // Fire imps attack less -- try to get close.
    // Update:  Does not apply to lords.
    if (self.classtype != CT_MONGARGOYLE_MEGA) {
        if ((self.ryuflags & RYU_ELEMENTS) == RYU_USE_FIRE)
            if (random() < 0.5) return;
    }

    garg_fire1();
};

// The gargoyle does not have a specific pain animation
// - Kinn created one from the death animation (Marcher progs)
void()	garg_pain1	= [	$death3,	garg_pain2	] {};
void()	garg_pain2	= [	$death4,	garg_pain3	] {};
void()	garg_pain3	= [	$death3,	garg_pain4	] {};
void()	garg_pain4	= [	$death2,	garg_pain5	] {};
void()	garg_pain5	= [	$death1,	garg_run1	] {};

void(entity inflictor, entity attacker, float damage) garg_pain = {
	// Check for perching gargoyles, need special wakeup
	if (self.spawnflags & MON_GARGOYLE_PERCH) gargoyle_wakeup();
	// Statues don't feel pain!
	else if (self.spawnflags & MON_STATUE) return;
	else {
		// Check all pain conditions and set up what to do next
		monster_pain_check(attacker, damage);
		SUB_FinishAttachment(); // make sure any fireball is hidden

		// Any pain animation/sound required?
		if (self.pain_check > 0) {
			if (random() < 0.5) sound(self,CHAN_VOICE, self.pain_sound,1,ATTN_NORM);
			else sound(self,CHAN_VOICE, self.pain_sound2,1,ATTN_NORM);
			if (self.pain_check == 1 || self.pain_check == 2) {
				garg_pain1();
			}
		}
	}
};

void()	garg_death1	= [	$death1,	garg_death2	] {};
void()	garg_death2	= [	$death3,	garg_death3	] { monster_check_gib(); };
void()	garg_death3	= [	$death5,	garg_death4	] { monster_check_gib(); self.solid = SOLID_NOT; };
void()	garg_death4	= [	$death7,	garg_death5	] {};
void()	garg_death5	= [	$death9,	garg_death6	] {};
void()	garg_death6	= [	$death11,	garg_death7	] {};
void()	garg_death7	= [	$death13,	garg_death8	] { monster_death_postcheck(); };
void()	garg_death8	= [	$death14,	garg_death8	] { monster_deadbody_check(); };

void() garg_die = {
	// Statues don't die!
	if (self.spawnflags & MON_STATUE) return;
	
	StopSound(self,CHAN_ITEM); // Make sure any wings sound is silenced

	// Check for perching gargoyles, need to blow up in gibs
	// In an awkward pose that does not go well into death animations
	if (self.spawnflags & MON_GARGOYLE_PERCH) self.gibondeath = TRUE;

	// If creating a Fireball, make it explode!
	if (self.attachment) {
		if (self.attachment.state == STATE_ON) {
			self.gibondeath = TRUE;
			SpawnProjectileSmoke(self.origin, 200, 50, 150);
			SpawnProjectileSmoke(self.origin, 200, 50, 150);
			particle_explode(self.origin-'0 0 16', 50+random()*50, 2, PARTICLE_BURST_FIRE, PARTICLE_BURST_UPWARD);
			makevectors(self.angles);
			self.oldorigin = self.origin + v_forward*8;
			SpawnExplosion(EXPLODE_BIG, self.oldorigin, SOUND_REXP3);
		}
		SUB_FinishAttachment(); // Make sure any fireball is hidden.
	}

	monster_death_precheck(); // Pre-check routine to tidy up extra entities.
	
	// If not gibbed, then drop to ground
	if (!self.gibbed) { 
		sound(self,CHAN_VOICE, "ad171/gargoyle/death1.wav",1,ATTN_NORM);
		self.flags = FL_MONSTER;				// reset all flag conditions
		self.movetype = MOVETYPE_TOSS;			// Affected by gravity
		self.velocity_x = -200 + 400*random();
		self.velocity_y = -200 + 400*random();
		self.velocity_z = 100 + 100*random();
		garg_death1();
	}
};

void() setup_gargoyle;

void() monster_gargoyle_precache = {
	precache_model("progs/ad171/mon_gargoyle.mdl");
	precache_model("progs/mon_impling.mdl");
	if (self.classtype == CT_MONGARGOYLE_MEGA) precache_model("progs/drake/h_imp2.mdl");
	else precache_model("progs/ad171/h_gargoyle.mdl");
	precache_model(MODEL_PROJ_GARGBALL);		// FB growing 8 frames
	precache_model(MODEL_PROJ_GARGOYLE);		// red/smoke wiz projectile
	precache_model(MODEL_PROJ_GARGOYLEGRN);	// acid/smoke wiz projectile
	precache_model("progs/ad171/gib_gargwing1.mdl");
	precache_model("progs/ad171/gib_gargwing2.mdl");
	precache_sound("ad171/gargoyle/idle1.wav");
	precache_sound("ad171/gargoyle/perch1.wav");
	precache_sound("ad171/gargoyle/perch2.wav");
	precache_sound("ad171/gargoyle/attack1.wav");	// Doom imp fireball!
	precache_sound("ad171/gargoyle/swoop1.wav");
	precache_sound("ad171/gargoyle/swoop2.wav");
	precache_sound("ad171/gargoyle/swoop1hit.wav");
	precache_sound("ad171/gargoyle/wings1.wav");
	precache_sound("ad171/gargoyle/pain75.wav");
	precache_sound("ad171/gargoyle/pain100.wav");
	precache_sound("ad171/gargoyle/death1.wav");
	precache_sound("ad171/gargoyle/sight1.wav");
	precache_sound("ad171/statue/idle1.wav");
	precache_sound("ad171/statue/idle2.wav");
	precache_sound("drake/weapons/axhit.wav");
	if (self.classtype == CT_MONGARGOYLE_MEGA) {
		precache_model("progs/drake/imp_lord.mdl");
		precache_model("progs/drake/h_imp2.mdl");
		precache_model("progs/drake/impwing2.mdl");
		precache_sound("drake/imp/swoopbig.wav");
		precache_sound("drake/imp/upbig.wav");
	}
};

// QUAKED monster_gargoyle (0.8 0 0.2) (-16 -16 -24) (16 16 40) AMBUSH STATUE PERCH NOSIGHT NOIDLE NOGFX STARTOFF ANGRY Not_Easy Not_Normal Not_Hard Not_DM
// { model(":progs/ad171/mon_gargoyle.mdl"); }
// Gargoyle, 120 health points.
// -------- KEYS --------
// -------- SPAWNFLAGS --------
// STATUE : Stone statue until triggered (always starts in a perched position)
// PERCH : Start in a sitting down, place 44 units out from perching edge, 4 units higher

void() monster_gargoyle = {
	if (monster_checkrandomizer() == TRUE) return; // Check for any random monster setups
	if (monster_checkspawn() == TRUE) return; // Check all spawn exceptions (monsters.qc)

	self.mdl = "progs/ad171/mon_gargoyle.mdl";
	self.gib1mdl = "progs/ad171/gib_gargwing1.mdl";	// Left wing
	self.gib2mdl = "progs/ad171/gib_gargwing2.mdl";	// Right wing
	self.headmdl = "progs/ad171/h_gargoyle.mdl";
	if (self.classtype == CT_MONGARGOYLE_MINI) self.mdl = "progs/mon_impling.mdl";
	else if (self.classtype == CT_MONGARGOYLE_MEGA) {
		self.mdl = "progs/drake/imp_lord.mdl";
		self.headmdl = "progs/drake/h_imp2.mdl";
		self.gib1mdl = "progs/drake/impwing2.mdl";
	}

	self.idle_sound = "ad171/gargoyle/idle1.wav";
	self.idle_soundcom = "ad171/gargoyle/perch1.wav";
	self.idle_soundcom2 = "ad171/gargoyle/perch2.wav";
	self.pain_sound = "ad171/gargoyle/pain75.wav";
	self.pain_sound2 = "ad171/gargoyle/pain100.wav";
	self.sight_sound = "ad171/gargoyle/sight1.wav";
	if (self.classtype != CT_CACHEGARGOYLE) setup_gargoyle(); // Cache gargoyle is a special class used for precache only
};

void() monster_minotaurminion = { // [ENTITY], Redirect
	self.classtype = CT_CACHEGARGOYLE; 
	monster_gargoyle();
};

// From Kinn
void() monster_imp = { // [ENTITY], Redirect
	if (self.deathstring == "")  self.deathstring = " was incinerated by an Imp\n";
	monster_gargoyle();
};

// From Kinn
void() monster_impling = { // [ENTITY]
	self.classtype = CT_MONGARGOYLE_MINI;
	if (self.deathstring == "")  self.deathstring = " was incinerated by an Impling\n";
	monster_gargoyle();
};

// From Kinn
void() monster_imp_lord = { // [ENTITY]
	local float rnd;

	if (self.deathstring == "") {
		rnd = random();
		if (rnd < 0.5) self.deathstring = " was jacked up by an Imp Lord\n";
		else if (rnd < 0.5) self.deathstring = " was raked by an Imp Lord\n";
		else if (rnd < 0.5) self.deathstring = " was crashed by an Imp Lord\n";
		else if (rnd < 0.5) self.deathstring = " was chilled out by an Imp Lord\n";
		else self.deathstring = " was roasted by an Imp\n";
	}
	self.classtype = CT_MONGARGOYLE_MEGA;
	monster_gargoyle();
};

// From Quake 1.5
void() monster_afrit = { // [ENTITY], Redirect
	if (self.deathstring == "")  self.deathstring = " was burned down by the Afrits\n";
	self.classname = "monster_imp";
	monster_gargoyle();
};


void() setup_gargoyle = { // [FUNCTION]
	if (random() < 0.5) self.gib1mdl = ""; // Randomize gib parts by removing some
	else if (random() < 0.5) self.gib2mdl = "";

	self.solid = SOLID_NOT;				// No interaction with world
	self.movetype = MOVETYPE_NONE;		// Static item, no movement
	if (self.skin > 5) self.skin = 5;
	if (self.exactskin > 5) self.exactskin = 5;
	if (self.classtype == CT_MONGARGOYLE_MINI) {
		if (self.bboxtype < 1) self.bboxtype = BBOX_SHORT; // Tiny imp
		if (self.health < 1) self.health = 80;
		self.gibhealth = -35;
	} else if (self.classtype == CT_MONGARGOYLE_MEGA) {
		if (self.skin > 4) self.skin = 4;
		if (self.exactskin > 4) self.exactskin = 4;
		if (self.bboxtype < 1) {
			self.bbmins = '-32 -32 -24';	// Special Size
			self.bbmaxs = '32 32 16';
			self.bboxtype = BBOX_CUSTOM;
		}

		if (self.health < 1) self.health = 300; // Hexen2 had 600, Drake used 300 for better Quake balance.
		self.gibhealth = -80;				// Need a powerful weapon to GIB
		self.mass = MASS_HEAVY;
	} else {
		if (self.bboxtype < 1) self.bboxtype = BBOX_TALL; // Normal gargoyle
		if (self.health < 1) self.health = 120;
		self.gibhealth = -60;				// Need a powerful weapon to GIB
	}

	if ((self.classtype == CT_MONGARGOYLE_MEGA && (self.skin == 4 || self.exactskin == 4))
		|| (self.skin == 1 || self.skin == 5 || self.exactskin == 1 || self.exactskin == 5)) { // Stony
		self.gibhealth = -100;
		self.hittype = HIT_STONE;
		self.resist_nails = 0.5;
		self.mass = MASS_HEAVY;
	}
	self.gibbed = FALSE;				// no falling apart
	self.pain_flinch = 70;				// High pain threshold
	self.blockudeath = TRUE;			// no humanoid death sound
	if (self.height == 0) self.height = MONAI_ABOVEDIST; // Custom height
	self.attack_offset = '16 28 22';	// fireball start location
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	if (self.deathstring == "")  self.deathstring = " was burned by a Gargoyle\n";
	self.th_checkattack = StrafeFlyerCheckAttack;
	self.th_pain = garg_pain; 
	self.th_die = garg_die;
	if (!self.classtype) self.classtype = CT_MONGARGOYLE;
	if (!self.classgroup) self.classgroup = CG_WIZARD;
	self.classmove = MON_MOVEFLY;

	// Fix double spawnflags problem - default to statue
	if (self.spawnflags & MON_STATUE && self.spawnflags & MON_GARGOYLE_PERCH) {
		dprint("\b[GARGOYLE]\b Cannot be perch and statue!\n");
		self.spawnflags = self.spawnflags - MON_GARGOYLE_PERCH;
	}

	if (self.spawnflags & MON_GARGOYLE_PERCH) {
		// Perched Gargoyles have special idle animation + idle sounds
		// The AI needs to be setup 40 units forward and 24 units up to be positioned feet flat on perch surface.
		self.th_stand = self.th_walk = garg_perch1;
		self.th_run = self.th_missile = gargoyle_wakeup;
	} else if (self.spawnflags & MON_STATUE) {
		// Statue Gargoyles setup in perch position with statue idle sounds.  Randomly picks a frame position from perch animation set
		self.hittype = HIT_STONE;
		self.idle_sound = "ad171/statue/idle1.wav"; // Setup stone idle sounds
		self.idle_sound2 = "ad171/statue/idle2.wav";	
		self.spawnstatue = TRUE;			// Start as a statue
		self.th_stand = gargoyle_statue;	// Stone idle pose
		self.think1 = gargoyle_wakeup;		// Wakeup statue angry at player
		self.skin = 1;						// Stone like skin
		self.gib1skin = self.gib2skin = 1;
		self.resist_nails = 0.5;			// Stone resistance
		// Work out random starting pose
		self.pos1_x = $perch1;
		self.pos1_y = $perch24;
		self.pos1_z = fabs(self.pos1_y - self.pos1_x);
		self.frame = rint(self.pos1_x + random() * self.pos1_z);
	} else if (self.classtype == CT_MINIONGARGOYLE) {
		// Special spawning minion need to start spinning
		self.th_stand = self.th_walk = self.th_run = gargoyle_grow;
		self.th_missile = SUB_Null;
	} else {
		// Default gargoyle setup
		self.th_stand = garg_idle1;
		self.th_walk = garg_walk1;
		self.th_run = garg_run1;
		self.th_missile = ImpAttack;
		self.th_melee = imp_swoop1;
	}
	monster_start();
};

// A code way to spawn gargoyles (requires monster_minotaurminion entity)
void(vector minion_org, entity minion_targ) minion_gargoyle = { // [FUNCTION]
	local entity minion;

	if (!InOpenOrLiquid(minion_org)) return; // Check if there is space to spawn entity

	update_minioncount(self, 1);			// Update spawn counters.  Self = minotaur, there is no egg 
	minion = spawn();
	minion.classname = "monster_gargoyle";	// For function searching
	setorigin(minion, minion_org);			// Move to new location
	minion.owner = self;					// Spawner Parent Link
	minion.master = self;	
	minion.effects = minion.flags = 0;		// make sure are blank
	minion.alpha = self.alpha;
	minion.alignment = self.alignment;
	minion.gibondeath = 1;					// Always gib on death
	minion.classtype = CT_MINIONGARGOYLE;	// Special minion class
	minion.enemy = minion_targ;				// Target to attack
	minion.spawnflags = 0;
	minion.classgroup = CG_DEMON;			// Don't turn on master
	minion.minion_active = TRUE;			// Minion flag
	minion.bodyfadeaway = TRUE;				// Get rid of body
	
	// Check for poison gibs being cached first
	if (gibpoison && self.poisonous == TRUE) {
		minion.poisonous = self.poisonous;	// carry over from host spawner 
		minion.gibtype = GIBTYPE_POISON;	// Poisonous blood trails
	}
	
	// Adopt parameters from host spawner
	minion.infightextra = self.infightextra;
	minion.mdl = "progs/ad171/mon_gargoyle.mdl";
	minion.headmdl = "progs/ad171/h_gargoyle.mdl";
	minion.gib1mdl = "progs/ad171/gib_gargwing1.mdl";	// Left wing
	minion.gib2mdl = "progs/ad171/gib_gargwing2.mdl";	// Right wing
	minion.pain_sound = "ad171/gargoyle/pain75.wav";
	minion.pain_sound2 = "ad171/gargoyle/pain100.wav";
	minion.idle_sound = "ad171/gargoyle/idle1.wav";
	minion.idle_soundcom = "ad171/gargoyle/perch1.wav";
	minion.idle_soundcom2 = "ad171/gargoyle/perch2.wav";
	minion.sight_sound = "ad171/gargoyle/sight1.wav";
	minion.nextthink = time + 0.01;
	minion.think = setup_gargoyle;
};