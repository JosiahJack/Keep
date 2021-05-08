// Monster summoning tags.
// First, the npc actor types.
// Now the monsters.

float(string mtype) MonsterType =
{
    if (mtype == "monster_ogre")    // Don't bother with marksman variant.
        return ID_OGRE;
    if (mtype == "monster_ogre_flak")
        return ID_OGRE_FLAK;
    if (mtype == "monster_demon1")
        return ID_DEMON_CLASSIC;
    if (mtype == "monster_shambler")
        return ID_SHAMBLER_WHITE;
    if (mtype == "monster_shamvile")
        return ID_SHAMVILE;
    if (mtype == "monster_knight")
        return ID_KNIGHT_GRUNT1;
    if (mtype == "monster_warrior")
        return ID_KNIGHT_GRUNT2;
    if (mtype == "monster_army")
        return ID_ARMY_GRUNT;
    if (mtype == "monster_soldier")
        return ID_ARMY_SOLDIER;
    if (mtype == "monster_army_axe")
        return ID_ARMY_AXE;
    if (mtype == "monster_wizard")
        return ID_WIZARD_SCRAG;
    if (mtype == "monster_drake")
        return ID_WIZARD_DRAKE;
    if (mtype == "monster_dog")
        return ID_DOG_CLASSIC;
    if (mtype == "monster_hell_hound")
        return ID_DOG_HELL;
    if (mtype == "monster_zombie")
        return ID_ZOMBIE;
    if (mtype == "monster_mummy")
        return ID_ZOMBIE_MUMMY;

    if (mtype == "monster_tarbaby")
        return ID_TARBABY_BLUE;
    if (mtype == "monster_hell_knight")
        return ID_KNIGHT_HELL;
    if (mtype == "monster_hell_lord")
        return ID_KNIGHT_HELL_LORD;
    if (mtype == "monster_hkboss")
        return ID_KNIGHT_HELL_BOSS;
    if (mtype == "monster_dark_lord")
        return ID_KNIGHT_DARK_LORD;
    if (mtype == "monster_bane")
        return ID_KNIGHT_BANE;
    if (mtype == "monster_fish")
        return ID_FISH;
    if (mtype == "monster_shalrath")
        return ID_SHALRATH_CLASSIC;
    if (mtype == "monster_enforcer")
        return ID_ARMY_ENFORCER;
    if (mtype == "monster_commando")
        return ID_ARMY_COMMANDO;
    if (mtype == "monster_defender")
        return ID_ARMY_DEFENDER;
    if (mtype == "monster_gunner")
        return ID_ARMY_GUNNER;
    if (mtype == "monster_me")
        return ID_ARMY_ME;
    if (mtype == "monster_oldone")
        return ID_OLDONE;

    if (mtype == "monster_bandit")
        return ID_ARCHER_BANDIT;
    if (mtype == "monster_goblin")
        return ID_ARCHER_GOBLIN;
    if (mtype == "monster_rebel")
        return ID_ARCHER_REBEL;
    if (mtype == "monster_archer")
        return ID_ARCHER_ORC;
    if (mtype == "monster_archer_lord")
        return ID_ARCHER_LORD;
    if (mtype == "monster_thug")
        return ID_AXE_THUG;
    if (mtype == "monster_axeman")
        return ID_AXE_KNIGHT;
    if (mtype == "monster_cyberdemon")
        return ID_CYBERDEMON;
    if (mtype == "monster_dragon")
        return ID_DRAGON_RED;
    if (mtype == "monster_dragon_red")
        return ID_DRAGON_RED;
    if (mtype == "monster_dragon_green")
        return ID_DRAGON_GREEN;
    if (mtype == "monster_dragon_blue")
        return ID_DRAGON_BLUE;
    if (mtype == "monster_dragon_white")
        return ID_DRAGON_WHITE;
    if (mtype == "monster_drone")
        return ID_DRONE;
    if (mtype == "monster_golem")
        return ID_GOLEM_KNIGHT;
    if (mtype == "monster_imp")
        return ID_IMP_KINN;
    if (mtype == "monster_imp_fire")
        return ID_IMP_RED;
    if (mtype == "monster_imp_ice")
        return ID_IMP_BLUE;
    if (mtype == "monster_baron")
        return ID_KNIGHT_BARON;
    if (mtype == "monster_baron_fire")
        return ID_BARON_FIRE;
    if (mtype == "monster_baron_earth")
        return ID_BARON_EARTH;
    if (mtype == "monster_baron_air")
        return ID_BARON_AIR;
    if (mtype == "monster_baron_water")
        return ID_BARON_WATER;
    if (mtype == "monster_armagon")
        return ID_MP1_ARMAGON;
    if (mtype == "monster_gremlin")
        return ID_MP1_GREMLIN;
    if (mtype == "monster_scourge")
        return ID_MP1_SCORPION;
    if (mtype == "monster_eel")
        return ID_MP2_EEL;
    if (mtype == "monster_guardian")
        return ID_MP2_GUARDIAN;
    if (mtype == "monster_wrath")
        return ID_MP2_WRATH;
    if (mtype == "monster_super_wrath")
        return ID_MP2_WRATH_LORD;
    if (mtype == "monster_acolyte")
        return ID_EBON_ACOLYTE;
    if (mtype == "monster_sorcerer")
        return ID_EBON_SORCERER;
    if (mtype == "monster_warlock")
        return ID_EBON_WARLOCK;
    if (mtype == "monster_necromancer")
        return ID_EBON_NECROMANCER;
    if (mtype == "monster_nemesant")
        return ID_NEMESANT;
    if (mtype == "monster_trogboss")
        return ID_NEMESANT_LORD;
    if (mtype == "monster_nightshade")
        return ID_NIGHTSHADE;
    if (mtype == "monster_skull_wizard")
        return ID_SKULL_WIZARD;
    if (mtype == "monster_skull_wizard_lord")
        return ID_SKULL_LORD;
    if (mtype == "monster_skull_wizard_boss")
        return ID_SKULL_BOSS;
    if (mtype == "monster_spider")
        return ID_SPIDER;
    if (mtype == "monster_turret")
        return ID_TURRET_LASER;
    if (mtype == "monster_vomitus")
        return ID_VOMITUS;
    if (mtype == "monster_wraith")
        return ID_WRAITH;
    if (mtype == "monster_wraith_lord")
        return ID_WRAITH_LORD;
    if (mtype == "monster_yakman")
        return ID_YAKMAN_WHITE;

    if (mtype == "monster_ranger")
        return ID_PLAYER;

    return 0;   // Unknown.
};

