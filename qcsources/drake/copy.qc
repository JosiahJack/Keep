//=========================
//
// SUB_CopyEntity
//
//=========================
void(entity from, entity to) SUB_CopyEntity =
{
//-----/ Copying ENTVARS_T fields /-----//
    to.modelindex       = from.modelindex;
    to.absmin           = from.absmin;
    to.absmax           = from.absmax;
    to.ltime            = from.ltime;
    to.movetype         = from.movetype;
    to.solid            = from.solid;
    to.origin           = from.origin;
    to.oldorigin        = from.oldorigin;
    to.velocity         = from.velocity;
    to.angles           = from.angles;
    to.avelocity        = from.avelocity;
    to.punchangle       = from.punchangle;
    to.classname        = from.classname;
    to.model            = from.model;
    to.frame            = from.frame;
    to.skin             = from.skin;
    to.effects          = from.effects;
    to.mins             = from.mins;
    to.maxs             = from.maxs;
    to.size             = from.size;
    to.touch            = from.touch;
    to.use              = from.use;
    to.think            = from.think;
    to.blocked          = from.blocked;
    to.nextthink        = from.nextthink;
    to.groundentity     = from.groundentity;
    to.health           = from.health;
    to.frags            = from.frags;
    to.weapon           = from.weapon;
    to.weaponmodel      = from.weaponmodel;
    to.weaponframe      = from.weaponframe;
    to.currentammo      = from.currentammo;
    to.ammo_shells      = from.ammo_shells;
    to.ammo_nails       = from.ammo_nails;
    to.ammo_rockets     = from.ammo_rockets;
    to.ammo_cells       = from.ammo_cells;
    to.items            = from.items;
    to.takedamage       = from.takedamage;
    to.chain            = from.chain;
    to.deadflag         = from.deadflag;
    to.view_ofs         = from.view_ofs;
    to.button0          = from.button0;
    to.button1          = from.button1;
    to.button2          = from.button2;
    to.impulse          = from.impulse;
    to.fixangle         = from.fixangle;
    to.v_angle          = from.v_angle;
    to.idealpitch       = from.idealpitch;
    to.netname          = from.netname;
    to.enemy            = from.enemy;
    to.flags            = from.flags;
    to.colormap         = from.colormap;
    to.team             = from.team;
    to.max_health       = from.max_health;
    to.teleport_time    = from.teleport_time;
    to.armortype        = from.armortype;
    to.armorvalue       = from.armorvalue;
    to.waterlevel       = from.waterlevel;
    to.watertype        = from.watertype;
    to.ideal_yaw        = from.ideal_yaw;
    to.yaw_speed        = from.yaw_speed;
    to.aiment           = from.aiment;
    to.goalentity       = from.goalentity;
    to.spawnflags       = from.spawnflags;
    to.target           = from.target;
    to.targetname       = from.targetname;
    to.dmg_take         = from.dmg_take;
    to.dmg_save         = from.dmg_save;
    to.dmg_inflictor    = from.dmg_inflictor;
    to.owner            = from.owner;
    to.movedir          = from.movedir;
    to.message          = from.message;
    to.sounds           = from.sounds;
    to.noise            = from.noise;
    to.noise1           = from.noise1;
    to.noise2           = from.noise2;
    to.noise3           = from.noise3;
//-----/ Copying non-referenced fields /-----//
    to.wad              = from.wad;
    to.map              = from.map;
    to.worldtype        = from.worldtype;
    to.killtarget       = from.killtarget;
    to.light_lev        = from.light_lev;
    to.style            = from.style;
    to.th_stand         = from.th_stand;
    to.th_walk          = from.th_walk;
    to.th_run           = from.th_run;
    to.th_missile       = from.th_missile;
    to.th_melee         = from.th_melee;
    to.th_pain          = from.th_pain;
    to.th_die           = from.th_die;
    to.oldenemy         = from.oldenemy;
    to.speed            = from.speed;
    to.lefty            = from.lefty;
    to.search_time      = from.search_time;
    to.attack_state     = from.attack_state;
    to.walkframe        = from.walkframe;
    to.attack_finished  = from.attack_finished;
    to.pain_finished    = from.pain_finished;
    to.invincible_finished  = from.invincible_finished;
    to.invincible_time      = from.invincible_time;
    to.invincible_sound     = from.invincible_sound;
    to.invisible_finished   = from.invisible_finished;
    to.invisible_time       = from.invisible_time;
    to.invisible_sound      = from.invisible_sound;
    to.super_damage_finished= from.super_damage_finished;
    to.super_time           = from.super_time;
    to.super_sound          = from.super_sound;
    to.radsuit_finished     = from.radsuit_finished;
    to.rad_time             = from.rad_time;
    to.fly_sound        = from.fly_sound;
    to.axhitme          = from.axhitme;
    to.show_hostile     = from.show_hostile;
    to.jump_flag        = from.jump_flag;
    to.swim_flag        = from.swim_flag;
    to.air_finished     = from.air_finished;
    to.bubble_count     = from.bubble_count;
    to.deathtype        = from.deathtype;
    to.mdl              = from.mdl;
    to.mangle           = from.mangle;
    to.oldorigin        = from.oldorigin;
    to.t_length         = from.t_length;
    to.t_width          = from.t_width;
    to.dest             = from.dest;
    to.dest1            = from.dest1;
    to.dest2            = from.dest2;
    to.wait             = from.wait;
    to.delay            = from.delay;
    to.trigger_field    = from.trigger_field;
    to.noise4           = from.noise4;
    to.pausetime        = from.pausetime;
    to.movetarget       = from.movetarget;
    to.aflag            = from.aflag;
    to.dmg              = from.dmg;
    to.cnt              = from.cnt;
    to.think1           = from.think1;
    to.finaldest        = from.finaldest;
    to.finalangle       = from.finalangle;
    to.count            = from.count;
    to.lip              = from.lip;
    to.state            = from.state;
    to.pos1             = from.pos1;
    to.pos2             = from.pos2;
    to.height           = from.height;
    to.waitmin          = from.waitmin;
    to.waitmax          = from.waitmax;
//    to.distance         = from.distance;
    to.volume           = from.volume;
//-----/ Copying non-referenced fields not in defs.qc /-----//
    to.healamount       = from.healamount;
    to.healtype         = from.healtype;
//-----/ Copying Hipnotic fields /-----//
//    to.th_turn          = from.th_turn;
    to.gorging          = from.gorging;
//    to.stoleweapon      = from.stoleweapon;
    to.spawnfunction    = from.spawnfunction;
    to.spawnthink       = from.spawnthink;
    to.spawnmodel       = from.spawnmodel;
    to.spawnsolidtype   = from.spawnsolidtype;
    to.spawnmins        = from.spawnmins;
    to.spawnmaxs        = from.spawnmaxs;
    to.spawnclassname   = from.spawnclassname;
// Don't inherit spawning info.
//    to.spawnsilent      = from.spawnsilent;
//    to.spawnmulti       = from.spawnmulti;
    to.spawnskin        = from.spawnskin;   // Custom, but part of spawn*.
//-----/ Copying custom fields /-----//
    to.gravity          = from.gravity;
    to.alpha            = from.alpha;
    to.sky              = from.sky;
    to.color            = from.color;

// PM:  Custom 'null_*' fields are for worldspawn use only and shouldn't
//  be copied.

    to.th_sight         = from.th_sight;
    to.th_check         = from.th_check;
    to.th_gib           = from.th_gib;
    to.th_harass        = from.th_harass;
    to.th_revive        = from.th_revive;
    to.th_spawn         = from.th_spawn;
    to.th_void          = from.th_void;
    to.th_win           = from.th_win;
    to.th_move          = from.th_move;
    to.th_goal          = from.th_goal;

    to.gib_health       = from.gib_health;

    to.resist_acid      = from.resist_acid;
    to.resist_rocket    = from.resist_rocket;
    to.resist_fire      = from.resist_fire;
    to.resist_light     = from.resist_light;
    to.resist_cold      = from.resist_cold;

    to.h2olevel         = from.h2olevel;
    to.h2otype          = from.h2otype;
    // PM:  Don't copy 'burner' entity.
    to.burn_ofs         = from.burn_ofs;

    to.hittype          = from.hittype;
    to.mass             = from.mass;

    to.armor_stats      = from.armor_stats;

// Only players should use morphing stuff.
//    to.form_active      = from.form_active;
//    to.baha_ammo        = from.baha_ammo;
//    to.baha_time        = from.baha_time;
//    to.baha_click       = from.baha_click;
// Ditto for jump button stuff.
//    to.b2_click         = from.b2_click;
//    to.b2_time          = from.b2_time;

    to.fallen           = from.fallen;
    to.master           = from.master;
    to.spawned          = from.spawned;
    to.mindex2          = from.mindex2;
    to.fighting         = from.fighting;
    to.level            = from.level;       // In case we copy a baron.
    to.punked           = from.punked;
    to.zones            = from.zones;
    to.purse            = from.purse;

    to.target2          = from.target2;
    to.mdl_head         = from.mdl_head;
    to.soul             = from.soul;

    to.saw_time         = from.saw_time;
    to.tracer_time      = from.tracer_time;
    to.zapper_time      = from.zapper_time;
    to.arsenal          = from.arsenal;
    to.war              = from.war;
    to.drama1           = from.drama1;
    to.ammo_super       = from.ammo_super;
    to.shots_max        = from.shots_max;
    to.shots_left       = from.shots_left;

// PM:  I think it's safe to ignore cutscene fields.

    to.xfl      = from.xfl;
    to.xf2      = from.xf2;
    to.xsf      = from.xsf;
    to.perms    = from.perms;

    to.thorns_finished  = from.thorns_finished;
    to.thorns_time      = from.thorns_time;
    to.thorns_sound     = from.thorns_sound;
    to.wing_finished    = from.wing_finished;
    to.wing_time        = from.wing_time;
    to.wing_sound       = from.wing_sound;
    to.mirror_finished  = from.mirror_finished;
    to.mirror_time      = from.mirror_time;
    to.mirror_sound     = from.mirror_sound;
    to.cross_finished   = from.cross_finished;
    to.cross_time       = from.cross_time;
    to.cross_sound      = from.cross_sound;
    to.tome_finished    = from.tome_finished;
    to.tome_time        = from.tome_time;
    to.curse_finished   = from.curse_finished;
    to.curse_type       = from.curse_type;
    to.curse_ping       = from.curse_ping;
    to.jump_time        = from.jump_time;

// PM:  Copying these should not be necessary unless we dupe books.
//    to.noise5           = from.noise5;
//    to.noise6           = from.noise6;
//    to.noise7           = from.noise7;
//    to.noise8           = from.noise8;

    to.zerc             = from.zerc;
    to.family           = from.family;

    to.duration         = from.duration;
    to.threats          = from.threats;
    to.pets             = from.pets;
    to.ryuflags         = from.ryuflags;

// PM:  'tronyn' field is for worldspawn only.
//-----/ Fields not in defs.qc. /-----//
//align.qc
    to.alignment        = from.alignment;
//blood.qc
    to.bloodtype        = from.bloodtype;
//hp.qc
//    to.healrate         = from.healrate;
    to.healrate         = from.healrate;
    to.healrate2        = from.healrate2;
    to.healtime         = from.healtime;
    to.poison_rate      = from.poison_rate;
    to.poison_finished  = from.poison_finished;
// Don't copy divine_* fields from 'cool.qc'.
};


//===========================/  END OF FILE  /===========================//
