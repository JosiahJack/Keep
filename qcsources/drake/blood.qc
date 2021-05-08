//==========================================================================
//
//  BLOOD
//
//==========================================================================

//================
// SpawnBlood
//================
void(vector org, vector vel, float damage, float btype) SpawnBlood =
{
//    if (btype <= 1)     //btype == BLOOD_NONE || btype == BLOOD_METAL
//        {particle (org, vel*0.02, 0, 10); return;}  // This was 'SpawnChunks'.
//    particle (org, vel*0.1, btype, damage*2);

    if (btype > 0)
        vel = vel*0.1;
    else
    {   // Chunks.
        vel = vel*0.02;
        if (btype < 0)
            btype = 0 - btype;
        else
            damage = 5;     // 5 * 2 = 10.  Emulate 'SpawnChunks'.
    }

    damage = floor(damage * 2);
    if (damage >= 255)      // range from 0 to 255, 255 causes TE_EXPLOSION.
        damage = 254;
    particle (org, vel, btype, damage);
};

// General version of 'spawn_touchblood'.  Usable by hitscan and missile
// attacks, as long as the relevant variables are passed.
void(entity inflictor, vector delta, vector spot, float damage, float btype)
    blood_impact =
{
    local   vector  vel;

    delta = normalize(delta);
// Fixed new 'wall_velocity' here.
    vel = vectoangles (delta);
    makevectors (vel);
    vel = v_forward + (v_up*(random() - 0.5)) + (v_right*(random() - 0.5));
    vel = normalize (vel);
    traceline (spot, spot + delta*64, FALSE, inflictor);
    vel = (vel + 2*trace_plane_normal) * 40;    // 200 * 0.2 = 40.

    SpawnBlood (spot + vel*0.01, vel, damage, btype);
};

//================
// spawn_touchblood
//
// Called by nailguns.
//================
void(float damage, float btype) spawn_touchblood =
{
// FIXME:  Replace 'self.dest' with another field.
    blood_impact (self, self.dest, self.origin, damage, btype);
};


//==========================================================================
//  MEAT SPRAY
//==========================================================================

// Precaches and enables the use of a requested blood model.
// Note:  BLOOD_RED is standard and automatically precached by worldspawn.
void(float btype) precache_blood =
{
    if (btype == BLOOD_GREEN)
    {
        precache_model ("progs/blood_gr.mdl");
        precache_model ("progs/gr_gib.mdl");
        bloodbank = bloodbank | BB_GREEN;
    }
    else if (btype == BLOOD_PURPLE)
    {
//        precache_model ("progs/blood_pu.mdl");
        precache_model ("progs/pur_gib.mdl");
        bloodbank = bloodbank | BB_PURPLE;
    }
    else if (btype == BLOOD_FIRE)
    {
//        precache_model ("progs/smoke.mdl");
        precache_model ("progs/ember.mdl");
        bloodbank = bloodbank | BB_FIRE;
    }
};

// Spawns a particle trail for an invisible blood model.
// Useful for any monster with blood of unusual color (like black or blue).
// It could be motor oil, antifreeze, milk, or fruit juice for all we know.
void() MeatSprayThink =
{
    if (self.delay <= time)
        {remove(self); return;}

    local   vector  dir;

    dir = normalize (self.velocity);
    particle (self.origin, dir, self.bloodtype, 10);

    self.nextthink = time + sys_ticrate;
};

//================
// SpawnMeatSpray
//================
void(vector org, vector vel, float btype) SpawnMeatSpray =
{
    local   string  text;

    if (btype == BLOOD_RED)
        text = "progs/zom_gib.mdl";
    else if (btype == BLOOD_GREEN)
        {if (bloodbank & BB_GREEN) text = "progs/gr_gib.mdl";}
    else if (btype == BLOOD_PURPLE)
        {if (bloodbank & BB_PURPLE) text = "progs/pur_gib.mdl";}
    else if ((btype == BLOOD_FIRE) && (bloodbank & BB_FIRE))
        {text = "progs/ember.mdl";}
    else if (btype != BLOOD_DARK)
        return;     // Unable to spew gore.

    local   entity  gib;

    gib = spawn ();
    gib.owner       = self;
    gib.movetype    = MOVETYPE_BOUNCE;
    gib.solid       = SOLID_NOT;

    gib.velocity    = vel;
    gib.velocity_z  = gib.velocity_z + 250 + 50*random();
    gib.avelocity   = '3000 1000 2000';

// set missile duration
    if (text)
    {
        gib.nextthink   = time + 1;
        gib.think       = SUB_Remove;
        setmodel (gib, text);
    }
    else
    {
        gib.bloodtype   = btype;
        gib.delay       = time + 1;
        gib.nextthink   = 0.01;
        gib.think       = MeatSprayThink;
        gib.modelindex  = 0;
    }
    setsize (gib, '0 0 0', '0 0 0');        
    setorigin (gib, org);
};


//==========================================================================

//void(vector org, vector vel, float damage, float btype) blood_spawn =
//    {SpawnBlood (org, vel, damage, btype);};
//void(vector vel, float damage, float btype) blood_impact =
//    {spawn_touchblood (damage, btype);};
//void(vector org, vector vel, float btype) blood_meatspray =
//    {SpawnMeatSpray (org, vel, btype);};


//==========================================================================
//  BLOOD SPRAYS
//==========================================================================

// Creates blood spawning entities.  This is a variation of SpawnMeatSpray.
// Used by decapitation code.
void(vector org, vector vel) SpawnBloodSpray =
{
    local   entity  gib;
    local   string  text;

    if (self.bloodtype == BLOOD_RED)
        text = "progs/blood.mdl";
    else if ((self.bloodtype == BLOOD_GREEN) && (bloodbank & BB_GREEN))
        text = "progs/blood_gr.mdl";
//    else if (self.bloodtype == BLOOD_PURPLE)
//        {if (bloodbank & BB_PURPLE) text = "progs/pur_gib.mdl";}
    else
        return;

    gib = spawn ();
    gib.owner       = self;
    gib.movetype    = MOVETYPE_TOSS;
    gib.solid       = SOLID_NOT;

    gib.velocity    = vel;
    gib.velocity_z  = gib.velocity_z + 250 + 50*random();

// set missile duration
    gib.nextthink   = time + 1;
    gib.think       = SUB_Remove;
    setmodel (gib, text);

    setsize (gib, '0 0 0', '0 0 0');
    setorigin (gib, org);
};

// Sprays blood from a given point.  Used by decapitation code.
void(vector org, float loop) blood_spray =
{
    local   vector  vel;

    makevectors (self.angles);
    org = self.origin + (v_forward * org_x) + (v_right * org_y) + (v_up * org_z);
    if (loop == -1)
    {   // Cheesy check to make one final blood spurt ahead.
        vel = (v_forward * (random() * 100 + 100));     //+ (v_up * 50);
        SpawnBloodSpray (org, vel);
        return;
    }
    while (loop > 0)
    {
        vel_x = crandom();  vel_y = crandom();  vel_z = 0;
        vel = normalize(vel) * 200;
        SpawnBloodSpray (org, vel);

        loop = loop - 1;
    }
};


//===========================/  END OF FILE  /===========================//
