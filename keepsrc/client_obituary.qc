//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: All
//
//
// Distribution / Copyright / Permissions 
//
// Please do not use any of these assets in ANY COMMERCIAL PROJECT.
// and remember to give credit if you use any of these assets. Please credit
// the appropriate authors of the various content used.  Refer to the credits
// folder.
//				  
// The QC files in this MOD are based on 1.06 source files by ID Software.
// These files are released under the terms of GNU General Public License v2 or
// later. You may use the source files as a base to build your own MODs as long
// as you release them under the same license and make the source available.
// Please also give proper credit. Check http://www.gnu.org for details.
//
// Quake is a registered trademark of id Software, Inc.
//
// All of these resources may be electronically distributed only at 
// NO CHARGE to the recipient.
//
// Stats:
// Entity count: 0
// Function count: 1
//
// Implements: Death Messages for when the player is killed
//
// Description:
// Prints a message to the top left corner of the screen to let the player know
// what killed them.  Incredibly useful for seeing the name of something by
// dying on purpose from it.
//=============================================================================

void(entity targ, entity attacker) dmatch_score;

// Called when a player dies, deals with all death messages
void(entity targ, entity attacker) ClientObituary = { // [FUNCTION]
	local float rnum;
	local string clientstring, clientstring2;

	rnum = random();
	if (targ.flags & FL_CLIENT) {
		if (attacker.classname == "teledeath") {
			bprint (targ.netname);
			bprint (" was telefragged by ");
			bprint (attacker.owner.netname);
			bprint ("\n");
			attacker.owner.frags = attacker.owner.frags + 1;
			return;
		}

		if (attacker.classname == "teledeath2") {
			bprint ("Satan's power deflects ");
			bprint (targ.netname);
			bprint ("'s telefrag\n");
			targ.frags = targ.frags - 1;
			return;
		}

		if (attacker.flags & FL_CLIENT) { // Player was killed by a player.
			if (targ == attacker) { // Suicide.
				attacker.frags = attacker.frags - 1;
				bprint (targ.netname);
				
				if (targ.weapon == IT_LIGHTNING && !self.weaponismoditems && targ.waterlevel > 1) { bprint (" discharges into the water.\n"); return; }

				if (targ.weapon == IT_GRENADE_LAUNCHER && !self.weaponismoditems) bprint (" tries to put the pin back in\n");
				else if (teamplay && (targ.team != targ.steam)) {
					if (cvar("gamecfg") & GAMECFG_ALLOW_CHG)
						bprint(" changed teams\n");
					else
						bprint(" tried to change teams\n");
				} else bprint (" becomes bored with life\n");
				return;
			} else if ( (teamplay == 2) && (targ.team > 0)&&(targ.team == attacker.team) ) {
				if (rnum < 0.25) clientstring = " mows down a teammate\n";
				else if (rnum < 0.50) clientstring = " checks his glasses\n";
				else if (rnum < 0.75) clientstring = " gets a frag for the other team\n";
				else clientstring = " loses another friend\n";

				bprint (attacker.netname);
				bprint (clientstring);
				attacker.frags = attacker.frags - 1;
				return;
			} else {
				if (teamplay == TEAM_DMATCH_TAG) dmatch_score(targ,attacker);
				else {
					attacker.frags = attacker.frags + 1;
					TeamAssists(targ, attacker); // --ZOID
				}
				rnum = attacker.weapon;
				if (rnum == IT_SHOTGUN) {
					if ( (random () < 0.500) ) {
						clientstring = " chewed on ";
						clientstring2 = "'s boomstick\n";
					} else {
						clientstring = " was gunned down by ";
						clientstring2 = "\n";
					}
	
					if (targ.health < -40) {
						clientstring = " was gibbed by ";
						clientstring2 = "'s puny shotgun\n";
					}
				}
				if (rnum == IT_SUPER_SHOTGUN) {
					if ( (random () < 0.500) ) {
						clientstring = " ate 2 loads of ";
						clientstring2 = "'s buckshot\n";
					} else {
						clientstring = " took both barrels from ";
						clientstring2 = "\n";
					}
					
					if (targ.health < -40) {
						clientstring = " was gibbed by ";
						clientstring2 = "'s Widowmaker!\n";
					}
				}
				if (rnum == IT_NAILGUN) {
					clientstring = " was nailed by ";
					clientstring2 = "\n";
					if (targ.health < -40) {
						clientstring = " was gibbed by ";
						clientstring2 = "'s nails\n";
					}
				}
				if (rnum == IT_SUPER_NAILGUN) {
					if ( (random () < 0.500) ) {
						clientstring = " was punctured by ";
					} else {
						clientstring = " was perforated by ";
					}

					clientstring2 = "\n";
					if (targ.health < -40) {
						clientstring = " was gibbed by ";
						clientstring2 = "'s furious nails\n";
					}
				}
				if (rnum == IT_GRENADE_LAUNCHER) {
					if ( (random () < 0.500) ) {
						clientstring = " eats ";
						clientstring2 = "'s pineapple\n";
					} else {
						clientstring = " caught ";
						clientstring2 = "'s grenade\n";
					}

					if (targ.health < -40) {
						clientstring = " was gibbed by ";
						clientstring2 = "'s grenade\n";
					}
				}
				if (rnum == IT_ROCKET_LAUNCHER) {
					if ( (random () < 0.500) ) {
						if ( (random () < 0.500) ) {
							clientstring = " rides ";
						} else {
							clientstring = " eats ";
						}
						clientstring2 = "'s rocket\n";
					} else {
						if ( (random () < 0.500) ) {
							clientstring = " was smeared by ";
						} else {
							clientstring = " was ripped a new one by ";
						}
						clientstring2 = "'s rocket\n";
					}

					if (targ.health < -40) {
						clientstring = " was gibbed by ";
						clientstring2 = "'s rocket\n" ;
					}
				}
				if (rnum == IT_LIGHTNING) {
					if ( (random () < 0.500) ) {
						clientstring = " accepts ";
						if (attacker.waterlevel > 1) clientstring2 = "'s discharge\n"; //typically gibs, no gib specific message
						else clientstring2 = "'s shaft\n";
					} else {
						clientstring = " was shafted by ";
						if (attacker.waterlevel > 1) clientstring = " was electrocuted by "; //typically gibs, no gib specific message
						else clientstring2 = "\n";
					}

				}
				if (rnum == IT_AXE) {
					clientstring = " was ax-murdered by ";
					clientstring2 = "\n";
					if (targ.health < -40) {
						clientstring = " was chopped to pieces by ";
						clientstring2 = "\n";
					}

					if (attacker.perms & IT_CHAINSAW) {
						if ( (random () < 0.500) ) {
							clientstring = " was chainsaw-massacred by ";
						} else {
							clientstring = " was chewed up by ";
						}
						clientstring2 = "'s bloody chainsaw\n";
						if (targ.health < -40) {
							clientstring = " was turned to gibs by ";
							clientstring2 = "'s bloody chainsaw\n";
						}
					}
				}
				if (rnum == IT_LAVA_NAILGUN) {
					clientstring = " was burned by ";
					clientstring2 = "'s lava nails\n";
					if (targ.health < -40) {
						clientstring = " was gibbed by ";
						clientstring2 = "'s fire and nails\n";
					}
				}
				if (rnum == IT_LAVA_SUPER_NAILGUN) {
					clientstring = " was burned with fury by ";
					clientstring2 = "'s lava nails\n";
					if (targ.health < -40) {
						clientstring = " was gibbed by ";
						clientstring2 = "'s furious fire and nails\n";
					}
				}
				if (rnum == IT_MULTI_GRENADE) {
					clientstring = " was blasted to bits by ";
					clientstring2 = "'s multi-grenade\n";
					if (targ.health < -40) {
						clientstring = " was turned into fireworks by ";
						clientstring2 = "'s multi-grenade party\n";
					}
				}
				if (rnum == IT_MULTI_ROCKET) {
					clientstring = " was obliterated by ";
					clientstring2 = "'s multi-rockets\n";
					if (targ.health < -40) {
						clientstring = " was completely obliterated by ";
						clientstring2 = "'s multi-rockets\n";
					}
				}
				if (rnum == IT_PLASMA_GUN) {
					if ( (random () < 0.500) ) {
						clientstring = " was fused by ";
					} else {
						clientstring = " was electrified by ";
					}
					clientstring2 = "'s plasma\n";
					if (targ.health < -40) {
						clientstring = " was melted by ";
						clientstring2 = "'s plasma\n";
					}
				}
				if (rnum == IT_CROSSBOW) {
					if (attacker.perms & IT_FROSTBOW) {
						clientstring = " was frozen by ";
						clientstring2 = "'s frost bolt\n";
						if (targ.health < -40) {
							clientstring = " was shattered into bits of ice by ";
							clientstring2 = "'s frost bolt\n";
						}
					} else {
						clientstring = " was skewered by ";
						clientstring2 = "\n";
						if (targ.health < -40) {
							clientstring = " was splintered to bits by ";
							clientstring2 = "'s bolt\n";
						}
					}
				}
				if (rnum == IT2_CHAINLIGHTNING) {
					clientstring = " accepts ";
					if (attacker.waterlevel > 1) clientstring2 = "'s chain discharges\n"; //typically gibs, no gib specific message
					else clientstring2 = "'s chain shafts\n";
				}
				if (rnum == IT2_PROXIMITY_GUN) {
					if ( (random () < 0.500) ) {
						clientstring = " got too friendly with ";
					} else {
						clientstring = " did the rhumba with ";
					}
					if ( (random () < 0.500) ) {
						clientstring2 = "'s bomb\n";
					} else {
						clientstring2 = "'s mine\n";
					}
					clientstring2 = "'s mine\n";
					if (targ.health < -40) {
						clientstring = " was surprise shattered by ";
						clientstring2 = "'s mine\n";
					}
				}
				if (rnum == IT2_MJOLNIR) {
					if ( (random () < 0.500) ) {
						clientstring = " was hammered by ";
					} else {
						clientstring = " was slammed by ";
					}

					clientstring2 = "'s Mjolnir\n";
					if (targ.health < -40) {
						clientstring = " was gibbed by ";
						clientstring2 = "'s mighty Mjolnir!\n" ;
					}
				}
				if (rnum == IT2_LASER_CANNON || ((rnum == IT_SHOTGUN) && (attacker.perms & IT_BLASTER))) {
					if ( (random () < 0.500) ) {
						clientstring = " was toasted by ";
					} else {
						if ( (random () < 0.500) ) {
							clientstring = " saw the light from ";
						} else {
							clientstring = " was radiated by ";
						}
					}
					clientstring2 = "'s laser\n";
					if (targ.health < -40) {
						clientstring = " was gibbed by ";
						clientstring2 = "'s laser\n";
					}
				}
				if (rnum == IT2_GRAPPLE) {
					clientstring = " was grappled by ";
					clientstring2 = "\n";
					if (targ.health < -40) {
						clientstring = " was chewed to shreds by ";
						clientstring2 = "'s grapple\n";
					}
				}
				bprint (targ.netname);
				bprint (clientstring);
				bprint (attacker.netname);
				bprint (clientstring2);
			}
			return;
		} else { // Killed by not a player, something else then...
			targ.frags = targ.frags - 1;
			bprint(targ.netname);
			// All the monster death messages are now defined in the monster QC.  It is much easier to add for each new monster than find/edit them here!
			if (attacker.flags & FL_MONSTER) {
				if (attacker.deathstring != "") bprint (attacker.deathstring);
				else bprint(" was killed by Quake's unnamed minion!\n");
				return;
			}

			// tricks and traps
			if (attacker.solid == SOLID_BSP && attacker != world) bprint (" was squished\n");
			else if (attacker.classtype == CT_EXPLO_BOX) bprint (" blew up\n");
			else if (attacker.classtype == CT_SPIKESHOOTER) bprint (" did not stick around\n");
			else if (attacker.classtype == CT_GRENADESHOOTER) bprint (" was pineappled\n");
			else if (attacker.classtype == CT_ROCKETSHOOTER) bprint (" was blasted\n");
			else if (attacker.classtype == CT_PROXMINE) bprint (" tripped on a mine\n");
			else if (attacker.classtype == CT_LIGHTSHOOTER) bprint (" was struck down\n");
			else if (attacker.classtype == CT_GASSHOOTER) bprint (" was burnt to a crisp\n");
			else if (attacker.classtype == CT_PENDULUM) bprint (" was cleaved in two\n");
			else if (attacker.classtype == CT_SAWBLADE) bprint (" was sliced to pieces\n");
			else if (attacker.classtype == CT_FIREBALL) bprint (" ate a lavaball\n");
			else if (attacker.classtype == CT_TRIGLEVEL) bprint (" tried to leave\n");
			else if (targ.watertype == -3) { // in-water deaths
				if (random() < 0.5) bprint (" sleeps with the fishes\n");
				else bprint (" sucks it down\n");
			} else if (targ.watertype == -4) {
				if (random() < 0.5) bprint (" gulped a load of slime\n");
				else bprint (" can't exist on slime alone\n");
			} else if (targ.watertype == -5) {
				if (targ.health < -15) bprint (" burst into flames\n");
				else if (random() < 0.5) bprint (" turned into hot slag\n");
				else bprint (" visits the Volcano God\n");
			} else if (targ.burning) bprint (" was burnt to a crisp\n"); // Debuff deaths
			else if (targ.poisoned) bprint (" was poisoned\n");
			else if (targ.bleeding) bprint (" bled to death\n");
			else if (targ.deathtype == "loadingevil") { // Special blocking of evil skill savegames
				targ.deathtype = "";
				bprint (" is too EVIL to live again!\n");
			} else if (targ.deathtype == "falling") { // fell to their death?
				targ.deathtype = "";
				bprint (" fell to his death\n");
			} else if (targ.deathtype == "fire") {
				targ.deathtype = "";
				bprint (" was scorched by fire\n");
			} else if (targ.deathtype == "lightning") {
				targ.deathtype = "";
				bprint (" was struck by lightning!\n");
			} else if (targ.touchedvoid) {
				targ.deathtype = "";
				bprint (" touched the void\n");
			} else if (attacker.deathstring != "") bprint(attacker.deathstring);
			else bprint (" is dead Jim!\n"); // heck if I know; he's just dead!!!
		}
	}
};