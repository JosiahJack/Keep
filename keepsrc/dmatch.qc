//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Rogue
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
// Entity count: 1
// Function count: 6
//
// Implements: Deathmatch Tag (Teamplay 3)
//
// Description:
// When cvar teamplay is set to 3, Deathmatch Tag is enabled.  A tag token can
// be placed in a map using dmatch_tag_token entity to provide the tag.  A
// player with the tag token will be IT and granted:
// - 3 frags per kill
// - Gain quad damage after 5 kills
// - Lose the tag after 10 kills
//
// Killing the player who has the token will grant you the token and grant 5
// frags for the kill.  Tag, I'm IT!
//
// The token will float above its owning player's head indicating to others
// who is IT.
//
// All other kills are only worth 1 frag.
//=============================================================================

void() tag_token_touch;

void() tag_token_respawn = { // [FUNCTION]
	local entity spawnPoint;
	local entity tagToken;
	
	tagToken = find(world,classname,"dmatch_tag_token");
	if(tagToken == world) return;
		
	spawnPoint = SelectSpawnPoint();
	setorigin(tagToken, spawnPoint.origin);
	tag_token_owner = world;
	tagToken.solid = SOLID_TRIGGER;
	tagToken.touch = tag_token_touch;
	tagToken.think = SUB_Null;
	tagToken.owner = world;
	tagToken.tag_frags = 0;
	droptofloor();
};

void() tag_token_fall = { // [FUNCTION]
	self.tag_frags = 0;
	self.think = tag_token_respawn;
	self.nextthink = time + 30;
	droptofloor();
};

void() tag_token_drop = { // [FUNCTION]
	local entity tagToken;
	
	tagToken = find(world,classname,"dmatch_tag_token");
	if(tagToken == world) return;
		
	bprint(tagToken.owner.netname);
	bprint(" lost the tag token!\n");
	tagToken.tag_frags = 0;
	tagToken.solid = SOLID_TRIGGER;
	tagToken.owner = world;
	tagToken.touch = tag_token_touch;
	tagToken.think = tag_token_fall;
	tagToken.nextthink = time + 0.1;
};

void() tag_token_think = { // [FUNCTION]
	if ( self.owner.health > 0) {
		if ( self.tag_message_time < time ) {
			bprint ( self.owner.netname );
			bprint ( " has the tag token!\n");
			self.tag_message_time = time + 30;
		}
		
		setorigin ( self, self.owner.origin + '0 0 48');
		self.think = tag_token_think;
		self.nextthink = time + 0.1;
	} else tag_token_drop();
};

void() tag_token_touch = { // [FUNCTION]
	if (other.classname != "player") return;
		
	tag_token_owner = other;
	self.tag_frags = 0;
	sound ( self, CHAN_AUTO, "rogue/runes/end1.wav", 1, ATTN_NORM);
	bprint ( other.netname );
	bprint ( " got the tag token!\n");
	self.tag_message_time = time + 30;
	self.owner = other;
	self.solid = SOLID_NOT;
	self.touch = SUB_Null;
	self.think = tag_token_think;
	self.nextthink = time + 0.1;
};

// QUAKED dmatch_tag_token (1 1 0) (-16 -16 -16) (16 16 16) The deathmatch tag token.
void() dmatch_tag_token = { // [ENTITY]
	if ( cvar("teamplay") != TEAM_DMATCH_TAG ) { remove (self); return; }

	item_setupmodel("progs/rogue/sphere.mdl",1);
	precache_sound("rogue/runes/end1.wav");
	setsize (self, '-16 -16 -16', '16 16 16');
	self.touch2 = tag_token_touch;
	self.effects = self.effects | EF_DIMLIGHT;
	item_start();
};

void(entity targ, entity attacker) dmatch_score = { // [FUNCTION]
	local entity tagToken;
	
	if ( teamplay == TEAM_DMATCH_TAG ) {
		tagToken = find (world, classname, "dmatch_tag_token");
		if(tagToken == world) {
			attacker.frags = attacker.frags + 1;
			return;
		}
		
		if ( attacker == tag_token_owner) {
			tagToken.tag_frags = tagToken.tag_frags + 1;
			attacker.frags = attacker.frags + 3;
			if ( tagToken.tag_frags == 5 ) {
				sprint (attacker, "You got the Quad Damage\n");
				attacker.items = attacker.items | IT_QUAD;
				stuffcmd (attacker, "bf\n");
				sound (attacker,CHAN_VOICE,"items/damage.wav", 1, ATTN_NORM);
				attacker.super_time = 1;
				attacker.super_damage_finished = time + 30;
			} else if (tagToken.tag_frags == 10) {
				bprint ( attacker.netname );
				bprint ( " lost the tag token\n" );
				tagToken.solid = SOLID_TRIGGER;
				tagToken.tag_frags = 0;
				tagToken.touch = tag_token_touch;
				tag_token_respawn();
			}
		} else {
			if (targ == tag_token_owner) {
				attacker.frags = attacker.frags + 5;
				sound ( self, CHAN_AUTO, "rogue/runes/end1.wav", 1, ATTN_NORM);
				if (attacker.classname == "player") {
					tag_token_owner = attacker;
					tagToken.tag_frags = 0;	
					tagToken.tag_message_time = time + 0.5;
					tagToken.owner = attacker;
					tagToken.solid = SOLID_NOT;
					tagToken.touch = SUB_Null;
					tagToken.think = tag_token_think;
					tagToken.nextthink = time + 0.1;
				}	
			} else attacker.frags = attacker.frags + 1;
		}
	}
}; 