//==========================================================================
//
//  DRILL BOMBS
//  (Drake's version of the spear rocket.)
//
//==========================================================================

// Launched by an exploding augmented (by Tome of Power) drill bomb.
// Missile launched is a slow, medium ranged homing rocket.
void(vector start, vector dir) DrillMissile_Launch =
{
    Rocket_Launch (start, dir);
    newmis.speed     = 400;
    newmis.velocity  = dir * newmis.speed;
    newmis.height    = 0;
    newmis.volume    = 0.7071;
    newmis.enemy     = SuperRocket_Target (self.master, start, dir, 1000, 0);
    newmis.yaw_speed = 20;
    newmis.dmg       = 95;
//- - - - - - - - -
    newmis.cnt       = 0;   // Increase yaw_speed by this after each think.
    newmis.state     = 0;   // Aim directly at enemy.  Use 1 to intercept.
//- - - - - - - - -
    newmis.delay     = time + 2.5;
    newmis.nextthink = time + 0.1;
    newmis.think     = SuperRocket_Think;
    newmis.think1    = SmallExplosion;
    setform (newmis, "progs/memissil.mdl", '0 0 0', '0 0 0');
};

void() DrillBomb_Ping =
{
    if (self.cnt <= time)
    {   // Ping as sprockets.
        self.cnt = self.cnt + 0.25;
        if (!IsOut (self.enemy) || (!self.enemy))
        {
            if (!self.modelindex)
                setorigin (self, self.enemy.origin);
            SUB_Flash ();
            sound (self, CHAN_VOICE, "weapons/sprocket.wav", 1, ATTN_NORM);
        }
    }
};

void() DrillBomb_Think =
{
    if (self.delay <= time)
    {   // Time's up!  Time to blow.
        if (!self.modelindex)
        {   // Embedded in someone.
            if (IsOut (self.enemy))
            {   // No explosion or damage if target phased out of the level.
                // Since magic is involved, let's say "A wizard did it!"
                remove (self);
                return;
            }
            setorigin (self, self.enemy.origin);
            if (self.tome_finished)
            {   // Since it's inside someone, just make a stronger explosion.
                self.dmg = 120;
                self.think1 = world.null_func;
            }
        }
        else
        {
            if (self.tome_finished)
            {   // Launch a short-range homing missile toward someone.
                DrillMissile_Launch (self.origin, self.movedir);
                newmis.master = self.master;
            }
            // ELSE... Do nothing more than the explosion.
        }
//        self.touch = SUB_Null;    // In case it didn't touch anything before.
        T_MissileExplode ();
        return;
    }
//- - - - - - - - -
// The dead may respawn, and we don't want bombs to stick to the target
// after it respawns.  Since minimum delay between death and respawn is
// 1.5 seconds (for clients, monsters take longer), speed up countdown
// so bomb explodes before respawning can happen.
//
// We could detonate all of the bombs at the time of respawning,
// but that is a pain to do (because that needs to happen each time
// PutClientInServer or monster_respawn is called), and we don't
// want anymore overhead than necessary.
    if (self.enemy.deadflag)
    {
        if (self.delay > time + 1)  // Speed up timer if necessary.
            {self.delay = time + 1;  self.cnt = time;}
    }
//- - - - - - - - -

    self.nextthink = time + sys_ticrate;

    DrillBomb_Ping ();

    if (self.modelindex)
    {
        if (self.enemy)
        {   // Stuck on a possible mobile surface.
            if (vlen (self.enemy.velocity) > 0)
            {
                T_MissileExplode ();
                return;
            }
        }
    }
    else
    {   // Imbedded
        if (!self.enemy)
        {   // Removed from the game.
            remove (self);
            return;
        }
        // Drill into the enemy, causing damage in the process.
        if (self.enemy.takedamage || (self.enemy.xfl & XFL_SHIELDS))
        if (self.wait <= time)      // Let's keep call frequency reasonable.
        {
            local   vector  spray;
            local   float   damage;

            damage = self.distance;
            if (self.tome_finished)
            {
                self.lefty = !self.lefty;
                if (self.lefty)
                    if (self.enemy.h2olevel < 3)
                        MakeFlame (self.enemy);
                damage = damage + 2;
            }
            T_NewDamage (self.enemy, self, self.master, damage, DF_TIMED|DF_NO_ARMOR|DF_NO_SHIELDS, "crash_drill");
            spray_x = 100 * crandom();
            spray_y = 100 * crandom();
            spray_z = 100 * crandom() + 50;
            SpawnBlood (self.enemy.origin, spray, 10, self.enemy.bloodtype);
            self.wait = time + 0.1;
        }
    }
};

void() DrillBomb_Touch =
{
    local   float   pc;

    pc = pointcontents (self.origin);
    if (pc == CONTENT_SKY)
        {remove (self);  return;}
    if (pc == CONTENT_LAVA)     // Explode if in lava.
        {T_MissileExplode ();  return;}
    if (Reflected ())
        return;

    if (other.takedamage == DAMAGE_AIM)
    {
        if (Reflected_Damage (COURAGE_DAMAGE))
            return;

        T_NewDamage (other, self, self.master, 10, DF_NONE, "crash_hit");

// DISABLED -- It's more fun for the bomb to drill then explode.
//        if (IsDead (other))
//            T_MissileExplode ();
//        else
        {
        // The bomb burrows into the target...
        // The bomb becomes invisible and intangible.  After that, it
        // doesn't matter where the bomb is, so we don't need to make
        // the bomb stick every frame, just when we need it to.
            self.modelindex = 0;
            self.solid      = SOLID_NOT;
            self.movetype   = MOVETYPE_NONE;
            self.enemy      = other;
//            self.delay      = self.nextthink;
            self.nextthink  = time + 0.1;
            self.think      = DrillBomb_Think;
            // Play Nehahra's sprocket thump sound.
            sound (other, CHAN_WEAPON, "weapons/thump.wav", 1, ATTN_NORM);
        }
        return;
    }

    sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);
    if (other.solid != SOLID_BSP)   // e.g., shielded mega enforcer.
    {   // Bounce off object.
        if (self.velocity == '0 0 0')
            self.avelocity = '0 0 0';

        if (self.count > 2)     // Don't let it bounce too much.
            {self.touch = SUB_Null;  T_MissileExplode ();}
        else
            self.count = self.count + 1;
        return;
    }
// Imbed into the surface.
    self.movetype   = MOVETYPE_NONE;
    self.movedir    = '0 0 1';
    self.velocity   = self.avelocity    = '0 0 0';
    self.touch      = SUB_Null;
    self.enemy      = other;    // Hit something that may move later.
//    self.delay      = self.nextthink;
    self.nextthink  = time + sys_ticrate;
    self.think      = DrillBomb_Think;

//- - - - - - - - -
// Orient the bomb perpendicular to the surface.
    local   vector  spot1, spot2;

    spot2 = self.angles;  spot2_x = 0 - spot2_x;
    makevectors (spot2);
    spot2 = 16*v_forward;
    spot1 = self.origin - spot2;
    spot2 = self.origin + spot2;
    traceline (spot1, spot2, FALSE, self);  // see through other monsters
    if (trace_fraction < 1)
    {
        self.movedir = trace_plane_normal;
        self.angles = vectoangles (trace_plane_normal * -1);
    }
//- - - - - - - - -
};

void() DrillBomb_Fly =
{
    if (self.delay <= time)
        {T_MissileExplode ();  return;}
    else
    {
        self.movedir = normalize (self.velocity);
        self.angles = vectoangles(self.movedir);
        self.nextthink = time + sys_ticrate;    //time + 0.1;
        DrillBomb_Ping ();
    }
};

void(vector start, vector dir, vector add) DrillBomb_Launch =
{
    newmis = spawn ();
    newmis.master       = newmis.owner     = self;
    newmis.movetype     = MOVETYPE_TOSS;
    newmis.solid        = SOLID_BBOX;
    newmis.classname    = "crash_bomb";
// set newmis speed
    newmis.speed        = 800;      // Nehahra's sprocket speed = 700.
    newmis.velocity     = (dir * 800) + add;
// Disabled spinning because angles get updated each frame.
//    newmis.avelocity    = '0 0 -500';
    newmis.angles       = vectoangles(newmis.velocity);
// set newmis damage
    newmis.dmg          = 95;       // Proxy gun damage.  Sprockets are 85.
    newmis.distance     = 2;        // Drill damage.
    newmis.enemy        = world;
    newmis.style        = DF_ROCKET | DF_NO_SHIELDS;    // Shamblers take half damage.
    newmis.xfl          = XFL_WIND;     // Ride wind tunnels.
//    newmis.worldtype    = MDAM_RANDOM;
    newmis.count        = 0;
    newmis.tome_finished= self.tome_finished;
// set newmis duration
    newmis.touch        = DrillBomb_Touch;
    newmis.nextthink    = time + 0.1;
    newmis.cnt          = time + 1.5;   // Time to start warning ping.
    newmis.delay        = time + 2.5;
    newmis.think        = DrillBomb_Fly;
    newmis.think1       = Old_Explosion1;

    setall (newmis, "progs/drilbomb.mdl", '0 0 0', '0 0 0', start);
};

// Part grenade, part sprocket.  Something that isn't weak as proxy gun.
void() W_FireDrillBomb =
{
    if (self.ammo_rockets < 1)
        return;

    self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
    sound (self, CHAN_WEAPON, "hipweap/proxbomb.wav", 1, ATTN_NORM);
    self.punchangle_x = -2;

    local   vector  start, vec;

    makevectors (self.v_angle);
    start = self.origin;    //+ v_forward*8 + v_right*12 + '0 0 12';
    vec = '0 0 200';
    if (self.v_angle_x)
        {vec = vec + crandom()*v_right*10; vec = vec + crandom()*v_up*10;}

    DrillBomb_Launch (start, v_forward, vec);
};


//===========================/  END OF FILE  /===========================//
