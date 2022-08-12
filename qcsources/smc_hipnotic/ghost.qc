/* ============================================

Declaration for ghost and and all ghost effects.

============================================ */


$origin 0 0 24
$base base
$skin skin

$frame death1 death2 death3 death4 death5 death6 death7 death8

void()	ghost_die1	=[	$death1,	ghost_die2	] {
 	self.alpha = 0.2;
	self.glow_color = 75;
	self.glow_size = 40;
	self.nextthink = time + 0.13;
	sound (self, CHAN_WEAPON, "ghost/ghost.wav", 1, 3); };
void()	ghost_die2	=[	$death2,	ghost_die3	] {
 	self.alpha = 0.3;
	self.glow_color = 75;
	self.glow_size = 80;
	self.nextthink = time + 0.17;};
void()      ghost_die3  =[    $death3,   ghost_die4  ] {
 	self.alpha = 0.35;
	self.glow_color = 75;
	self.glow_size = 120;
	self.nextthink = time + 0.17;};
void()	ghost_die4	=[	$death4,	ghost_die5	] {
 	self.alpha = 0.4;
	self.glow_color = 75;
	self.glow_size = 160;
	self.nextthink = time + 0.17;};
void()	ghost_die5	=[	$death5,	ghost_die6	] {
	self.alpha = 0.45;
	self.glow_color = 75;
	self.glow_size = 200;
	self.nextthink = time + 0.17;};
void()	ghost_die6	=[	$death6,	ghost_die7	] {
	self.alpha = 0.5;
	self.glow_color = 75;
	self.glow_size = 250;
	self.nextthink = time + 0.17;};
void()	ghost_die7	=[	$death7,	ghost_die8	] {
	self.alpha = 0.55;
	self.nextthink = time + 0.17;};
void()	ghost_die8	=[	$death8,	ghost_die9	] {
	self.alpha = 0.6;
	self.glow_color = 75;
	self.glow_size = 300;
	self.nextthink = time + 0.17;};
void()	ghost_die9	=[	$death8,	ghost_die10	] {
	self.alpha = 0.65;
	self.glow_color = 75;
	self.glow_size = 330;
	self.nextthink = time + 0.25;};
void()	ghost_die10	=[	$death8,	ghost_die11	] {
	self.alpha = 0.65;
	self.glow_color = 75;
	self.glow_size = 290;
	self.nextthink = time + 0.25;};
void()	ghost_die11	=[	$death8,	ghost_die11	] {
	self.alpha = 0.65;
	self.glow_color = 75;
	self.glow_size = 250;
	self.nextthink = time + 4;
      self.think = SUB_Remove;};



void() ghost_die0 =
{
	local vector v;           //  vectors v,u,o are needed for the calculation and spawning of spiritual ghost glimmer effect
	local vector u;
	local vector o;

	local vector b;   	 //  vector b is needed for the blood splatter effect when ghost cracks out of corpse 


v_x = (self.origin_x);
v_y = (self.origin_y);
v_z = (self.origin_z);

u_x = (v_x - 40);
u_y = (v_y - 40);
u_z = (v_z - 50);

o_x = (u_x + 80);
o_y = (u_y + 80);
o_z = (u_z + 250);

//	precache_model ("progs/ghost.mdl");	// precached in worldspawn() due to savegame-bug
//	precache_sound ("ghost/ghost.wav");	// precached in worldspawn() due to savegame-bug

      self.origin_z = (self.origin_z -15); 
	self.velocity = '0 0 60'; 
	self.avelocity = '0 270 0';   
   	self.touch = SUB_Null;                
	self.movetype = MOVETYPE_NOCLIP; 
//	self.movetype = MOVETYPE_FLY;
	setmodel (self, "progs/ghost.mdl");
   	self.solid = SOLID_NOT;
	setsize (self, '0 0 0', '0 0 0');

	
	te_particlesnow(u, o, '0 0 60', 35, 20);  // colors: 5(white)  20(white/yellow)  35(leight blue)  85(leight yellow)


b_x = (v_x);                              // vector 'b' used for blood splatter effect when ghost cracks out of corpse
b_y = (v_y);
b_z = (v_z -15);
	te_blood (b,'0 120 1000', 15);	// used for blood splatter effect when ghost cracks out of corpse in all 4 directions
	te_blood (b,'120 0 1000', 15);
	te_blood (b,'-120 0 1000', 15);
	te_blood (b,'0 -120 1000', 15);

	ghost_die1 ();
};



void()	ghost_die 	= {     	// delay for 0.1 seconds before effect really begins
	self.scale = 1;
	self.nextthink = time + 0.1;
	self.think = ghost_die0;
		
Gyro_Object_ClearPhysics(self);
};

