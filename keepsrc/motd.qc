//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Rogue, Feb'97 by ZOID <zoid@threewave.com> under contract to
//               id software for Rogue Entertainment
// 
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
// Entity count: 
// Function count: 
//
// Implements: Rogue Teamplay Variants Message of the Day function
//
// Description:
// Message of the day from Rogue's three wave capture the flag mode.
//=============================================================================

.float motd_time;
.float motd_count;

void() MOTD = { // [FUNCTION]
	local string tp;
	
	if (self.motd_count < 5) {
		if (teamplay > 3 && teamplay < 7) {
			tp = ftos(teamplay);
			stuffcmd(self, "teamplay ");
			stuffcmd(self, tp);
			stuffcmd(self, "\n");
		}
		self.motd_time = time + 1;
		self.motd_count = self.motd_count + 1;
		if (teamplay == TEAM_DMATCH_TAG) centerprint(self, "Welcome to\nThe Dissolution of Eternity!\nBy Rogue Entertainment\n\nDeathmatch Tag!\n");
		else if (teamplay == TEAM_CTF) {
			if (self.steam == TEAM1) centerprint(self, "Welcome to\nThe Dissolution of Eternity!\nBy Rogue Entertainment\n\nCAPTURE THE FLAG!\n\nYou are ��� team!\n");
			else centerprint(self, "Welcome to\nThe Dissolution of Eternity!\nBy Rogue Entertainment\n\nCAPTURE THE FLAG!\n\nYou are ���� team!\n");
        } else if (teamplay == TEAM_CTF_ONEFLAG) {
			if (self.steam == TEAM1) centerprint(self, "Welcome to\nThe Dissolution of Eternity!\nBy Rogue Entertainment\n\nCAPTURE THE FLAG!\n(One Flag Mode)\n\nYou are ��� team!\n");
			else centerprint(self, "Welcome to\nThe Dissolution of Eternity!\nBy Rogue Entertainment\n\nCAPTURE THE FLAG!\n(One Flag Mode)\n\nYou are ���� team!\n");
        } else if (teamplay == TEAM_CTF_ALT) {
			if (self.steam == TEAM1) centerprint(self, "Welcome to\nThe Dissolution of Eternity!\nBy Rogue Entertainment\n\nCAPTURE THE FLAG!\n(Three Team Mode)\n\nYou are ��� team!\n");
			else if (self.steam == TEAM2) centerprint(self, "Welcome to\nThe Dissolution of Eternity!\nBy Rogue Entertainment\n\nCAPTURE THE FLAG!\n(Three Team Mode)\n\nYou are ���� team!\n");
			else centerprint(self, "Welcome to\nThe Dissolution of Eternity!\nBy Rogue Entertainment\n\nCAPTURE THE FLAG!\n(Three Team Mode)\n\nYou are ���� team!\n");
        }
		return;
	}
	self.motd_time = 0;
};

void() CheckMOTD = { // [FUNCTION]
	if (self.motd_time) { 
		if(self.motd_time < time) MOTD();
	}
};

void() SetMOTD = { // [FUNCTION]
	self.motd_time = time + 3;
	if (teamplay == 3) self.motd_count = 2;
	else self.motd_count = 0;
};