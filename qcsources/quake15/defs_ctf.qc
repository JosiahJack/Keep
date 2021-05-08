entity	blue_flag,		red_flag,	// denotes flags, flagbases will set *_flag to their owners, *_flags will be owned by flag carriers
		blue_flagbase,	red_flagbase;	// denotes flagbases

float recorded_flag_positions_yet;	// set in startframe, we need to record what positions the flags drop down to after startframe does its thing

.float	ctf_item;

void(float addfrags, float whatteam) AddFragsToTeam;

void(string whatstring, float whatteam) CenterprintToTeam;

void()	DropFlag,
		flag_dropped_think,
		flag_carried_think,
		flagbase_touch,
		flag_restore,
		flag_touch;

void(float whichteam, entity whom) BotList_Add;
void(float whichteam, entity whom) BotList_Remove;

entity	botlist_red_head,
		botlist_blue_head;

.entity	botlist_next,
		botlist_last;