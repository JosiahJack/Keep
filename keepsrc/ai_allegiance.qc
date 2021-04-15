// Monster AI Allegiance System
// Determines monster behavior outside of normal circumstances
// Defaults to standard monster behavior of:
//	- angry on sight of player
//	- angry on hearing fighting (nearby monster notification)
//	- angry when targeted
//	- chases player we are angry with (self.enemy) for indefinite amount of time

// Allegiance System Variables
// We have 3 variables that determine behavior on a monster.
// Alignment, Temprament, and Vulnerability
// All 3 can be changed by the mapper per monster.
// All monsters default to 0 for all 3, which is Evil Angry Normal
// Monsters now look for any other monster or player, noy just players
// All 3 are integers with the following ranges:

// Alignment (0 - 2)
//	- 0 Evil (Default) - Typical bad monsters
//	- 1 Good - Players are always good, useful for player allies
//	- 2 Neutral - Doesn't mind good or evil characters so long as they aren't hurt by them

// Temperament (0 - 4)
//	- 0 Angry (Default) - Will attack on sight, or even just hearing fights nearby
//	- 1 Cowardly - Will flee away unless cornered, with slight chance of fighting back when not cornered
//	- 2 Passive - Will not respond if others are getting attacked.  Only respond and get angry if attacked directly.
//	- 3 Calm - 
//	- 4 Psychotic

// Vulnerability (0 - 3)
//	- 0 Normal (Default)
//	- 1 Resistant
//	- 2 Seraphic
//	- 3 Undead

// The combination of these variables results in the following actions:
//	- Assault (Default) - attack! and chase
//	- Relax - keep doing what we were doing (walking, standing)
//	- Follow - follow the seen, if leader, else Relax
//	- Retreat - flee away

.float alignment;
.float temperament;
.float vulnerability;

//.float classgroup; Defined elsewhere