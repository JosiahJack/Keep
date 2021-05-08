$frame close0  close1  close2  close3  close4  close5  close6  close7  close8  close9 close10

void() ironmaiden_move0 =[$close0,ironmaiden_move1 ] { self.nextthink = time + 0.15; };
void() ironmaiden_move1 =[$close1,ironmaiden_move2 ] { sound (self, CHAN_VOICE, "misc/ironmaiden.wav", 1, ATTN_NORM); };
void() ironmaiden_move2 =[$close2,ironmaiden_move3 ] {};
void() ironmaiden_move3 =[$close3,ironmaiden_move4 ] {};
void() ironmaiden_move4 =[$close4,ironmaiden_move5 ] {};
void() ironmaiden_move5 =[$close5,ironmaiden_move6 ] {};
void() ironmaiden_move6 =[$close6,ironmaiden_move7 ] {};
void() ironmaiden_move7 =[$close7,ironmaiden_move8 ] { SUB_UseTargets(); };
void() ironmaiden_move8 =[$close8,ironmaiden_move9 ] {};
void() ironmaiden_move9 =[$close9,ironmaiden_move10] {};
void() ironmaiden_move10=[$close10,ironmaiden_move11] {};
void() ironmaiden_move11=[$close9,ironmaiden_move12] {};
void() ironmaiden_move12=[$close8,ironmaiden_move13] {};
void() ironmaiden_move13=[$close7,ironmaiden_move14] {};
void() ironmaiden_move14=[$close6,ironmaiden_move15] {};
void() ironmaiden_move15=[$close5,ironmaiden_move16] {};
void() ironmaiden_move16=[$close4,ironmaiden_move17] {};
void() ironmaiden_move17=[$close3,ironmaiden_move18] {};
void() ironmaiden_move18=[$close2,ironmaiden_move19] {};
void() ironmaiden_move19=[$close1,ironmaiden_move0 ]
{
		self.frame = 0;
		self.nextthink = time - 1;
		self.think = SUB_Null;
		self.enemy.solid = SOLID_TRIGGER;
};

void ironmaiden_use (void)
{
	if(self.frame != 0) return;
	ironmaiden_move0();
}

void() ironmaiden_trigger_touch =
{
	if (!other.takedamage) return;
	
	self.solid = SOLID_NOT;
	T_Damage (other, self, self, self.dmg);
	
	self=self.enemy;
	self.use();
};

void ironmaiden_pair()
{
	entity trigger = find(world,netname,self.map);
	trigger.enemy = self;
	self.enemy = trigger;
	trigger.dmg = 2;
	trigger.touch = ironmaiden_trigger_touch;
}

/*QUAKED obj_ironmaiden (0.3 0.1 0.6) (-100 -100 -210) (100 100 8)
An iron maiden able to painfully close and go back open
Due to the entity assymetry relatively to its bounding box, it's easier to make it SOLID_NOT and define its "solidity" and trigger through external brushes
*/
void obj_ironmaiden (void)
{
	precache_sound("misc/ironmaiden.wav");
	precache_model("progs/torture/ironmaiden.mdl");

	setmodel(self, "progs/torture/ironmaiden.mdl");
	setsize (self, '-10 -10 30', '10 10 40');
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
	self.takedamage = FALSE;
	self.use = ironmaiden_use;
	
	//Pair with its trigger
	self.map = self.netname;
	self.netname = "";
	self.nextthink = time + 0.5;
	self.think=ironmaiden_pair;
}
