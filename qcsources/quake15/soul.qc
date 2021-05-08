/*
==============================================================================

Creates "Relieved souls of the enslaved" effect.    

Modelname, Modelframe and wings z-position is taken from call inside individual monster  qc´s :    
void(string modelname, float modelframe, float zet) soul;
Example: 
soul ("progs/soldier.mdl", $death10, 20);		// zet= 20 is ideal value for the soldier for example

Function must be declared at the end of defs.qc:
void(string modelname, float modelframe, float zet) soul; 

==============================================================================
*/

			// alt_death1 to 15   --> sequence where the soul lifts up 
			// alt_death14  	    --> smoke effect and flash is spawned (soul disappearing effect)
			// 			    	  --> Attention: effectinfo.txt entry "soulvanish" is necessary


void()	alt_death15	= {	
	self.alpha = -1;
	self.glow_color = 5;
	self.glow_size = 10;
	self.nextthink = time + 0.15;
      self.think = SUB_Remove;
};	
void()	alt_death14	= {  
	self.alpha = 0.01;
	self.glow_color = 5;
	self.glow_size = 10;
	te_customflash (self.origin, 500, 0.7, '0.5 0.5 0.5');
	sendParticle("soulvanish", self.origin, '0 0 0', 1);
	self.nextthink = time + 0.15; 
	self.think = alt_death15;
};	
void()	alt_death13	= {		
	sound (self, CHAN_WEAPON, "soul/flash.wav", 0.6, 4);    	
	self.alpha = 0.04;
	self.glow_color = 5;
	self.glow_size = 40;
 	self.nextthink = time + 0.2;
	self.think = alt_death14;
};
void()	alt_death12	= {
	self.alpha = 0.07;
	self.glow_color = 5;
	self.glow_size = 70;
	self.nextthink = time + 0.2;
	self.think = alt_death13;
};
void()	alt_death11	= {
	self.alpha = 0.1;
	self.glow_color = 5;
	self.glow_size = 100;
	self.nextthink = time + 0.2;
	self.think = alt_death12;
};
void()	alt_death10	= {
	self.alpha = 0.13;
	self.glow_color = 5;
	self.glow_size = 150;
	self.nextthink = time + 0.2;
	self.think = alt_death11;
};
void()	alt_death9 	= {
	self.alpha = 0.16;
	self.glow_color = 5;
	self.glow_size = 200;
	self.nextthink = time + 0.2;
	self.think = alt_death10;
};
void()	alt_death8 	= {
	self.alpha = 0.19;
	self.glow_color = 5;
	self.glow_size = 250;
	self.nextthink = time + 0.2;
	self.think = alt_death9;
};
void()	alt_death7 	= {
	self.alpha = 0.22;
	self.glow_color = 5;
	self.glow_size = 300;
	self.nextthink = time + 0.2;
	self.think = alt_death8;
};
void()	alt_death6 	= {
	self.alpha = 0.25;
	self.glow_color = 5;
	self.glow_size = 350;
	self.nextthink = time + 0.2;
	self.think = alt_death7;
};
void()	alt_death5 	= {
	self.alpha = 0.28;
	self.glow_color = 5;
	self.glow_size = 400;
	self.nextthink = time + 0.2;
	self.think = alt_death6;
};
void()	alt_death4 	= {
	self.alpha = 0.31;
	self.glow_color = 5;
	self.glow_size = 450;
	self.nextthink = time + 0.2;
	self.think = alt_death5;
};
void()	alt_death3 	= {
	self.alpha = 0.34;
	self.glow_color = 5;
	self.glow_size = 500;
	self.nextthink = time + 0.2;
	self.think = alt_death4;
};
void()	alt_death2 	= {
	self.alpha = 0.37;
	self.glow_color = 5;
	self.glow_size = 500;
	self.nextthink = time + 0.2;
	self.think = alt_death3;
};
void()	alt_death1 	= {
	self.velocity = '0 0 25'; 
 	self.alpha = 0.4;
	self.glow_color = 5;
	self.glow_size = 500;
	self.nextthink = time + 0.5;
	self.think = alt_death2;
};




				// alt_death001 to 006   --> sequence where the corpse overbrights 


void()	alt_death006 	= {
	self.alpha = 0.4;
	self.colormod = '7 7 7';
	self.glow_color = 5;
	self.glow_size = 450;
	self.nextthink = time + 0.1;
	self.think = alt_death1;
};
void()	alt_death005 	= {
	self.alpha = 0.4;
	self.colormod = '6 6 6';
	self.glow_color = 5;
	self.glow_size = 450;
	self.nextthink = time + 0.1;
	self.think = alt_death006;
};
void()	alt_death004 	= {
	self.alpha = 0.4;
	self.colormod = '5 5 5';
	self.glow_color = 5;
	self.glow_size = 350;
	self.nextthink = time + 0.1;
	self.think = alt_death005;
};
void()	alt_death003 	= {
sound (self, CHAN_WEAPON, "soul/liftup.wav", 0.4, 1);
	self.alpha = 0.4;
	self.colormod = '4 4 4';
	self.glow_color = 5;
	self.glow_size = 270;
	self.nextthink = time + 0.1;
	self.think = alt_death004;
};
void()	alt_death002 	= {
	self.alpha = 0.4;
	self.colormod = '3 3 3';
	self.glow_color = 5;
	self.glow_size = 185;
	self.nextthink = time + 0.1;
	self.think = alt_death003;
}; 
void()	alt_death001 	= {
	self.alpha = 0.4;
	self.colormod = '2 2 2';
	self.glow_color = 5;
	self.glow_size = 110;
	self.nextthink = time + 0.1;
	self.think = alt_death002;
};
void()	alt_death000 	= {     // delay for 0.7 seconds before overbright process really begins
	self.alpha = 0.4;			  // Reason: Waiting for winged-demon animation
	self.glow_color = 5;
	self.glow_size = 20;
	self.nextthink = time + 0.7;
	self.think = alt_death001;
};



//////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////             winged-demon code:          //////////////////////////
//////////// Unfortunately I had to use this awkward way for the wings animation !    ////////
////////////           Reasons: Different params in individual frames.          //////////////
////////////             No bugs, when multiple wings are spawned.          //////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

$origin 0 0 24
$base base		
$skin skin


$frame fr_1 fr_2 fr_3 fr_4 fr_5 fr_6 fr_7 fr_8 fr_9 fr_10 
$frame fr_11 fr_12 fr_13 fr_14 fr_15 fr_16 fr_17 fr_18 fr_19 fr_20 
$frame fr_21 fr_22 fr_23 fr_24 fr_25 fr_26 fr_27 fr_28 fr_29 fr_30 
$frame fr_31 fr_32 fr_33 fr_34 fr_35 fr_36 fr_37 fr_38 fr_39 fr_40 
$frame fr_41 fr_42 fr_43 fr_44 fr_45 fr_46 fr_47 fr_48 fr_49 fr_50 
$frame fr_51 fr_52 fr_53 fr_54 fr_55 fr_56 fr_57 fr_58 fr_59 fr_60
$frame fr_61 fr_62 fr_63 fr_64 fr_65 fr_66 fr_67 fr_68 fr_69 fr_70
$frame fr_71 fr_72 fr_73 fr_74 fr_75 fr_76 fr_77 



void() wingsend =
{
	self.nextthink = time + 0.01;  
  	self.think = SUB_Remove;   
};


//////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////   starting from here: animation WITH winged-demon attack   ///////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

void()	wings01 	= [	$fr_21,	wings02	] {
	self.alpha = 0.05;
	self.glow_color = 5;
	self.glow_size = 20;
	self.nextthink = time + 0.05;
};
void()	wings02 	= [	$fr_22,	wings03	] {
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.07;
	self.glow_color = 5;
	self.glow_size = 60;
	self.nextthink = time + 0.05;
};
void()	wings03 	= [	$fr_23,	wings04	] {
sound (self, CHAN_VOICE, "soul/awake.wav", 0.6, 4);
     	self.alpha = 0.09;
	self.glow_color = 5;
	self.glow_size = 100;
	self.nextthink = time + 0.05;
};
void()	wings04 	= [	$fr_24,	wings05	] {
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
    	self.alpha = 0.11;
	self.glow_color = 5;
	self.glow_size = 120;
	self.nextthink = time + 0.05;
};
void()	wings05 	= [	$fr_25,	wings06	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
    	self.alpha = 0.13;
	self.glow_color = 5;
	self.glow_size = 160;
	self.nextthink = time + 0.05;
};
void()	wings06 	= [	$fr_26,	wings07	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.15;
	self.glow_color = 5;
	self.glow_size = 200;
	self.nextthink = time + 0.05;
};
void()	wings07 	= [	$fr_27,	wings08	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
     	self.alpha = 0.17;
	self.glow_color = 5;
	self.glow_size = 240;
	self.nextthink = time + 0.05;
};
void()	wings08 	= [	$fr_28,	wings09	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
sound (self, CHAN_WEAPON, "soul/wingsflap.wav", 0.9, 1);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.19;
	self.glow_color = 5;
	self.glow_size = 280;
	self.nextthink = time + 0.05;
};
void()	wings09 	= [	$fr_29,	wings10	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
     	self.alpha = 0.21;
	self.glow_color = 5;
	self.glow_size = 320;
	self.nextthink = time + 0.05;
};
void()	wings10 	= [	$fr_30,	wings11	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.23;
	self.glow_color = 5;
	self.glow_size = 360;
	self.nextthink = time + 0.05;
};
void()	wings11 	= [	$fr_31,	wings12	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
     	self.alpha = 0.25;
	self.glow_color = 5;
	self.glow_size = 400;
	self.nextthink = time + 0.05;
};
void()	wings12 	= [	$fr_32,	wings13	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.27;
	self.glow_color = 5;
	self.glow_size = 440;
	self.nextthink = time + 0.05;
};
void()	wings13 	= [	$fr_33,	wings14	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
     	self.alpha = 0.29;
	self.glow_color = 5;
	self.glow_size = 444;
	self.nextthink = time + 0.05;
};
void()	wings14 	= [	$fr_34,	wings15	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.31;
	self.nextthink = time + 0.05;
};
void()	wings15 	= [	$fr_35,	wings16	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.33;
	self.nextthink = time + 0.05;
};
void()	wings16 	= [	$fr_21,	wings17	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.35;
	self.nextthink = time + 0.05;
};
void()	wings17 	= [	$fr_22,	wings18	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.37;
	self.nextthink = time + 0.05;
};
void()	wings18 	= [	$fr_23,	wings19	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.39;
	self.nextthink = time + 0.05;
};
void()	wings19 	= [	$fr_24,	wings20	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.41;
	self.nextthink = time + 0.05;
};
void()	wings20 	= [	$fr_25,	wings21	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
    	self.alpha = 0.43;
	self.nextthink = time + 0.05;
};
void()	wings21 	= [	$fr_26,	wings22	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.alpha = 0.45;
	self.nextthink = time + 0.05;
};
void()	wings22 	= [	$fr_27,	wings23	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.47;
	self.nextthink = time + 0.05;
};
void()	wings23 	= [	$fr_28,	wings24	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
sound (self, CHAN_WEAPON, "soul/wingsflap.wav", 1, 1);
     	self.alpha = 0.49;
	self.nextthink = time + 0.05;
};
void()	wings24 	= [	$fr_29,	wings25	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.51;
	self.nextthink = time + 0.05;
};
void()	wings25 	= [	$fr_30,	wings26	] {	
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.53;
	self.nextthink = time + 0.05;
};
void()	wings26 	= [	$fr_31,	wings27	] {		  // wings start to lift up
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
self.velocity = '0 0 25';  
     	self.alpha = 0.55;
	self.nextthink = time + 0.05;
};
void()	wings27 	= [	$fr_32,	wings28	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.57;
	self.nextthink = time + 0.05;
};
void()	wings28 	= [	$fr_75,	wings29	] {			// new modified frame "33"
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.6;
	self.nextthink = time + 0.05;
};
void()	wings29 	= [	$fr_76,	wings30	] {			// new modified frame "34"
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings30 	= [	$fr_77,	wings31	] {			// new modified frame "35"
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	wings31 	= [	$fr_36,	wings32	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings32 	= [	$fr_37,	wings33	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
sound (self, CHAN_VOICE, "soul/wingshot.wav", 1, 1);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	wings33 	= [	$fr_38,	wings34	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings34 	= [	$fr_39,	wings35	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	wings35 	= [	$fr_40,	wings36	] {			// laser attack left hand	
local	vector	offang, org, dir;

sendParticle("soulwings", self.origin, '0 0 0', 2);

	offang = vectoangles (self.enemy.origin - self.origin);
	makevectors (offang);  

	org = self.origin + v_right * -13 + v_up * 7;
	dir = self.enemy.origin + '0 0 16' - org;
	dir = normalize (dir);

	traceline (org, self.origin + dir*190, TRUE, self); 

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);		
	WriteEntity (MSG_BROADCAST, self);		
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	var float autocvar_souldamage = 0;   	// set cvar 'souldamage' default to 0
	if (autocvar_souldamage == 0)	  		// if 'souldamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		{						// soul effect doesnt hurt the player
		}	
	else
		{							// if value is NOT "0" (example: '1'), player can get hurt from this effect !
		LightningDamage (org, trace_endpos, self, 1);   // -1 hit point
		}

	self.nextthink = time + 0.05;
};
void()	wings36 	= [	$fr_41,	wings37	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	wings37 	= [	$fr_42,	wings38	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings38 	= [	$fr_43,	wings39	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	wings39 	= [	$fr_44,	wings40	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings40 	= [	$fr_45,	wings41	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	wings41 	= [	$fr_46,	wings42	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings42 	= [	$fr_47,	wings43	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	wings43 	= [	$fr_48,	wings44	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
sound (self, CHAN_WEAPON, "soul/wingsflap.wav", 1, 1);
	self.nextthink = time + 0.05;
};
void()	wings44 	= [	$fr_49,	wings45	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	wings45 	= [	$fr_50,	wings46	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings46 	= [	$fr_51,	wings47	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	wings47 	= [	$fr_52,	wings48	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings48 	= [	$fr_53,	wings49	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	wings49 	= [	$fr_54,	wings50	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings50 	= [	$fr_55,	wings51	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	wings51 	= [	$fr_56,	wings52	] {	
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings52 	= [	$fr_57,	wings53	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	wings53 	= [	$fr_58,	wings54	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings54 	= [	$fr_59,	wings55	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	wings55 	= [	$fr_60,	wings56	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings56 	= [	$fr_61,	wings57	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	wings57 	= [	$fr_62,	wings58	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings58 	= [	$fr_63,	wings59	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
sound (self, CHAN_VOICE, "soul/wingshot.wav", 1, 1);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	wings59 	= [	$fr_64,	wings60	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings60 	= [	$fr_65,	wings61	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings61 	= [	$fr_66,	wings62	] {				// laser attack right hand
local	vector	org, offang, dir;

sendParticle("soulwings", self.origin, '0 0 0', 2);

	offang = vectoangles (self.enemy.origin - self.origin);
	makevectors (offang);  

	org = self.origin + v_right * 3 + v_up * -6 + v_forward * 20;	
	dir = self.enemy.origin + '0 0 16' - org;
	dir = normalize (dir);

	traceline (org, self.origin + dir*190, TRUE, self); 

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);		
	WriteEntity (MSG_BROADCAST, self);		
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	var float autocvar_souldamage = 0;   	// set cvar 'souldamage' default to 0
	if (autocvar_souldamage == 0)	  		// if 'souldamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		{						// soul effect doesnt hurt the player
		}	
	else
		{							// if value is NOT "0" (example: '1'), player can get hurt from this effect !
		LightningDamage (org, trace_endpos, self, 1);   // -1 hit point
		}

	self.nextthink = time + 0.05;
};
void()	wings62 	= [	$fr_67,	wings63	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings63 	= [	$fr_68,	wings64	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings64 	= [	$fr_69,	wings65	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
sound (self, CHAN_WEAPON, "soul/wingsflap.wav", 1, 1);
	self.nextthink = time + 0.05;
};
void()	wings65 	= [	$fr_70,	wings66	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings66 	= [	$fr_71,	wings67	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings67 	= [	$fr_72,	wings68	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	wings68 	= [	$fr_73,	wings69	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.56;
	self.nextthink = time + 0.05;
};
void()	wings69 	= [	$fr_74,	wings70	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.52;
	self.nextthink = time + 0.05;
};
void()	wings70 	= [	$fr_1,	wings71	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.48;
	self.nextthink = time + 0.05;
};
void()	wings71 	= [	$fr_2,	wings72	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.44;
	self.glow_color = 5;
	self.glow_size = 420;
	self.nextthink = time + 0.05;
};
void()	wings72 	= [	$fr_3,	wings73	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.4;
	self.glow_color = 5;
	self.glow_size = 400;
	self.nextthink = time + 0.05;
};
void()	wings73 	= [	$fr_4,	wings74	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.36;
	self.nextthink = time + 0.05;
};
void()	wings74 	= [	$fr_5,	wings75	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.32;
	self.nextthink = time + 0.05;
};
void()	wings75 	= [	$fr_6,	wings76	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.28;
	self.nextthink = time + 0.05;
};
void()	wings76 	= [	$fr_7,	wings77	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);   
     	self.alpha = 0.24;  	
	self.nextthink = time + 0.05;
};
void()	wings77 	= [	$fr_8,	wings78	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.2;
	self.nextthink = time + 0.05;
};
void()	wings78 	= [	$fr_9,	wings79	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.16;
	self.nextthink = time + 0.05;
};
void()	wings79 	= [	$fr_10,	wings80	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.12;
	self.nextthink = time + 0.05;
};
void()	wings80 	= [	$fr_11,	wings81	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.08;
// sound (self, CHAN_WEAPON, "soul/wingsflap.wav", 1, 1);
	self.nextthink = time + 0.05;
};
void()	wings81 	= [	$fr_12,	wings82	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.04;
	self.nextthink = time + 0.05;
};
void()	wings82 	= [	$fr_13,	wings83	] {				// this is the last visible winged-demon frame
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.01;
	self.nextthink = time + 0.05;
};

void()	wings83 	= [	$fr_14,	wings84	] {		
     	self.alpha = -1;
	self.glow_color = 5;
	self.glow_size = 1;
	self.nextthink = time + 0.03;
};
void()	wings84 	= [	$fr_15,	wings85	] {
local	vector	org, destin, dir;
local float zufall, souldmg;

zufall = random();
	if (zufall > 0.5)
		destin = self.origin - '0 10 30';  
	else 
		destin = self.origin - '8 8 30';  

	org = self.origin + '0 0 -23';	
	dir = destin - org;
	dir = normalize (dir);
	traceline (org, self.origin + dir*174, TRUE, self); 

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);		
	WriteEntity (MSG_BROADCAST, self);		
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	var float autocvar_souldamage = 0;   	// set cvar 'souldamage' default to 0
	if (autocvar_souldamage == 0)	  		// if 'souldamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		{						// soul effect doesnt hurt the player
		}	
	else
		{							// if value is NOT "0" (example: '1'), player get hurt from this effect !
		souldmg = rint(1.5 + (2 * random()));  	// chances=  50%: 2 damage /  50%: 3 damage
		LightningDamage (org, trace_endpos, self, souldmg);   
		}

	self.nextthink = time + 0.05;
};
void()	wings85 	= [	$fr_16,	wings86	] {
local	vector	org, destin, dir;
local float zufall, souldmg;

zufall = random();
	if (zufall > 0.5)
		destin = self.origin - '0 -10 30';  
	else 
		destin = self.origin - '-8 -8 30';  

	org = self.origin + '0 0 -23';	
	dir = destin - org;
	dir = normalize (dir);
	traceline (org, self.origin + dir*174, TRUE, self); 

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);	
	WriteEntity (MSG_BROADCAST, self);		
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	var float autocvar_souldamage = 0;   	// set cvar 'souldamage' default to 0
	if (autocvar_souldamage == 0)	  		// if 'souldamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		{						// soul effect doesnt hurt the player
		}	
	else
		{							// if value is NOT "0" (example: '1'), player get hurt from this effect !
		souldmg = rint(1.5 + (2 * random()));  	// chances=  50%: 2 damage /  50%: 3 damage
		LightningDamage (org, trace_endpos, self, souldmg);   
		}

	self.nextthink = time + 0.05;
};
void()	wings86 	= [	$fr_17,	wings87	] {
local	vector	org, destin, dir;
local float zufall, souldmg;

zufall = random();
	if (zufall > 0.5)
		destin = self.origin - '10 0 30';  
	else 
		destin = self.origin - '8 -8 30';  

	org = self.origin + '0 0 -23';
	dir = destin - org;
	dir = normalize (dir);
	traceline (org, self.origin + dir*174, TRUE, self); 

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);		
	WriteEntity (MSG_BROADCAST, self);		
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	var float autocvar_souldamage = 0;   	// set cvar 'souldamage' default to 0
	if (autocvar_souldamage == 0)	  		// if 'souldamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		{						// soul effect doesnt hurt the player
		}
	else
		{							// if value is NOT "0" (example: '1'), player get hurt from this effect !
		souldmg = rint(1.5 + (2 * random()));  	// chances=  50%: 2 damage /  50%: 3 damage
		LightningDamage (org, trace_endpos, self, souldmg);   
		}

	self.nextthink = time + 0.05;
};
void()	wings87 	= [	$fr_18,	wings88	] {
local	vector	org, destin, dir;
local float zufall, souldmg;

zufall = random();
	if (zufall > 0.5)
		destin = self.origin - '-10 0 30';  
	else 
		destin = self.origin - '-8 8 30';  

	org = self.origin + '0 0 -23';	
	dir = destin - org;
	dir = normalize (dir);
	traceline (org, self.origin + dir*174, TRUE, self); 

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);	
	WriteEntity (MSG_BROADCAST, self);	
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	var float autocvar_souldamage = 0;   	// set cvar 'souldamage' default to 0
	if (autocvar_souldamage == 0)	  		// if 'souldamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		{						// soul effect doesnt hurt the player
		}	
	else
		{							// if value is NOT "0" (example: '1'), player get hurt from this effect !
		souldmg = rint(1.5 + (2 * random()));  	// chances=  50%: 2 damage /  50%: 3 damage
		LightningDamage (org, trace_endpos, self, souldmg);   
		}

	self.nextthink = time + 0.05;
};
void()	wings88 	= [	$fr_19,	wingsend	] {
local	vector	org, destin, dir;
local float souldmg;

	destin = self.origin - '0 0 30';    
	org = self.origin + '0 0 -23';
	dir = destin - org;
	dir = normalize (dir);
	traceline (org, self.origin + dir*96, TRUE, self);  

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);	
	WriteEntity (MSG_BROADCAST, self);		
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	var float autocvar_souldamage = 0;   	// set cvar 'souldamage' default to 0
	if (autocvar_souldamage == 0)	  		// if 'souldamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		{						// soul effect doesnt hurt the player
		}	
	else
		{							// if value is NOT "0" (example: '1'), player get hurt from this effect !
		souldmg = rint(1.5 + (2 * random()));  	// chances=  50%: 2 damage /  50%: 3 damage
		LightningDamage (org, trace_endpos, self, souldmg);   
		}

	self.nextthink = time + 0.04;
};



//////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////// starting from here: animation WITHOUT winged-demon attack  ///////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////


void()	nowingsattack01 	= [	$fr_21,	nowingsattack02	] {
	self.alpha = 0.05;
	self.glow_color = 5;
	self.glow_size = 20;
	self.nextthink = time + 0.05;
};
void()	nowingsattack02 	= [	$fr_22,	nowingsattack03	] {
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.07;
	self.glow_color = 5;
	self.glow_size = 60;
	self.nextthink = time + 0.05;
};
void()	nowingsattack03 	= [	$fr_23,	nowingsattack04	] {
sound (self, CHAN_VOICE, "soul/awake.wav", 0.6, 4);
     	self.alpha = 0.09;
	self.glow_color = 5;
	self.glow_size = 100;
	self.nextthink = time + 0.05;
};
void()	nowingsattack04 	= [	$fr_24,	nowingsattack05	] {
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
    	self.alpha = 0.11;
	self.glow_color = 5;
	self.glow_size = 120;
	self.nextthink = time + 0.05;
};
void()	nowingsattack05 	= [	$fr_25,	nowingsattack06	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
    	self.alpha = 0.13;
	self.glow_color = 5;
	self.glow_size = 160;
	self.nextthink = time + 0.05;
};
void()	nowingsattack06 	= [	$fr_26,	nowingsattack07	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.15;
	self.glow_color = 5;
	self.glow_size = 200;
	self.nextthink = time + 0.05;
};
void()	nowingsattack07 	= [	$fr_27,	nowingsattack08	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
     	self.alpha = 0.17;
	self.glow_color = 5;
	self.glow_size = 240;
	self.nextthink = time + 0.05;
};
void()	nowingsattack08 	= [	$fr_28,	nowingsattack09	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
sound (self, CHAN_WEAPON, "soul/wingsflap.wav", 0.9, 1);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.19;
	self.glow_color = 5;
	self.glow_size = 280;
	self.nextthink = time + 0.05;
};
void()	nowingsattack09 	= [	$fr_29,	nowingsattack10	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
     	self.alpha = 0.21;
	self.glow_color = 5;
	self.glow_size = 320;
	self.nextthink = time + 0.05;
};
void()	nowingsattack10 	= [	$fr_30,	nowingsattack11	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.23;
	self.glow_color = 5;
	self.glow_size = 360;
	self.nextthink = time + 0.05;
};
void()	nowingsattack11 	= [	$fr_31,	nowingsattack12	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
     	self.alpha = 0.25;
	self.glow_color = 5;
	self.glow_size = 400;
	self.nextthink = time + 0.05;
};
void()	nowingsattack12 	= [	$fr_32,	nowingsattack13	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.27;
	self.glow_color = 5;
	self.glow_size = 440;
	self.nextthink = time + 0.05;
};
void()	nowingsattack13 	= [	$fr_33,	nowingsattack14	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
     	self.alpha = 0.29;
	self.glow_color = 5;
	self.glow_size = 444;
	self.nextthink = time + 0.05;
};
void()	nowingsattack14 	= [	$fr_34,	nowingsattack15	] {
sendParticle("soulwings", self.origin, '0 0 0', 1);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.31;
	self.nextthink = time + 0.05;
};
void()	nowingsattack15 	= [	$fr_35,	nowingsattack16	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.33;
	self.nextthink = time + 0.05;
};
void()	nowingsattack16 	= [	$fr_21,	nowingsattack17	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.35;
	self.nextthink = time + 0.05;
};
void()	nowingsattack17 	= [	$fr_22,	nowingsattack18	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.37;
	self.nextthink = time + 0.05;
};
void()	nowingsattack18 	= [	$fr_23,	nowingsattack19	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.39;
	self.nextthink = time + 0.05;
};
void()	nowingsattack19 	= [	$fr_24,	nowingsattack20	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.41;
	self.nextthink = time + 0.05;
};
void()	nowingsattack20 	= [	$fr_25,	nowingsattack21	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
    	self.alpha = 0.43;
	self.nextthink = time + 0.05;
};
void()	nowingsattack21 	= [	$fr_26,	nowingsattack22	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.alpha = 0.45;
	self.nextthink = time + 0.05;
};
void()	nowingsattack22 	= [	$fr_27,	nowingsattack23	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.47;
	self.nextthink = time + 0.05;
};
void()	nowingsattack23 	= [	$fr_28,	nowingsattack24	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
sound (self, CHAN_WEAPON, "soul/wingsflap.wav", 1, 1);
     	self.alpha = 0.49;
	self.nextthink = time + 0.05;
};
void()	nowingsattack24 	= [	$fr_29,	nowingsattack25	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.51;
	self.nextthink = time + 0.05;
};
void()	nowingsattack25 	= [	$fr_30,	nowingsattack26	] {	
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.53;
	self.nextthink = time + 0.05;
};
void()	nowingsattack26 	= [	$fr_31,	nowingsattack27	] {		 // winged-demon start to lift up
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
self.velocity = '0 0 25';  
     	self.alpha = 0.55;
	self.nextthink = time + 0.05;
};
void()	nowingsattack27 	= [	$fr_32,	nowingsattack28	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.57;
	self.nextthink = time + 0.05;
};
void()	nowingsattack28 	= [	$fr_33,	nowingsattack29	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
     	self.alpha = 0.6;
	self.nextthink = time + 0.05;
};
void()	nowingsattack29 	= [	$fr_34,	nowingsattack30	] {	
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack30 	= [	$fr_35,	nowingsattack31	] {	
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	nowingsattack31 	= [	$fr_21,	nowingsattack32	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack32 	= [	$fr_22,	nowingsattack33	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	nowingsattack33 	= [	$fr_23,	nowingsattack34	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack34 	= [	$fr_24,	nowingsattack35	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	nowingsattack35 	= [	$fr_25,	nowingsattack36	] {	
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack36 	= [	$fr_26,	nowingsattack37	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	nowingsattack37 	= [	$fr_27,	nowingsattack38	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack38 	= [	$fr_28,	nowingsattack39	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
sound (self, CHAN_WEAPON, "soul/wingsflap.wav", 0.9, 1);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	nowingsattack39 	= [	$fr_29,	nowingsattack40	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack40 	= [	$fr_30,	nowingsattack41	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	nowingsattack41 	= [	$fr_31,	nowingsattack42	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack42 	= [	$fr_32,	nowingsattack43	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	nowingsattack43 	= [	$fr_33,	nowingsattack44	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack44 	= [	$fr_34,	nowingsattack45	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	nowingsattack45 	= [	$fr_35,	nowingsattack46	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack46 	= [	$fr_21,	nowingsattack47	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	nowingsattack47 	= [	$fr_22,	nowingsattack48	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack48 	= [	$fr_23,	nowingsattack49	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	nowingsattack49 	= [	$fr_24,	nowingsattack50	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack50 	= [	$fr_25,	nowingsattack51	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	nowingsattack51 	= [	$fr_26,	nowingsattack52	] {	
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack52 	= [	$fr_27,	nowingsattack53	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	nowingsattack53 	= [	$fr_28,	nowingsattack54	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
sound (self, CHAN_WEAPON, "soul/wingsflap.wav", 0.9, 1);
	self.nextthink = time + 0.05;
};
void()	nowingsattack54 	= [	$fr_29,	nowingsattack55	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	nowingsattack55 	= [	$fr_30,	nowingsattack56	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack56 	= [	$fr_31,	nowingsattack57	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	nowingsattack57 	= [	$fr_32,	nowingsattack58	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack58 	= [	$fr_33,	nowingsattack59	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
local vector faceplayer1, faceplayer2;
faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the demon to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
self.angles = vectoangles(faceplayer2);  
	self.nextthink = time + 0.05;
};
void()	nowingsattack59 	= [	$fr_34,	nowingsattack60	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack60 	= [	$fr_35,	nowingsattack61	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack61 	= [	$fr_21,	nowingsattack62	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack62 	= [	$fr_22,	nowingsattack63	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack63 	= [	$fr_23,	nowingsattack64	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack64 	= [	$fr_24,	nowingsattack65	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack65 	= [	$fr_25,	nowingsattack66	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack66 	= [	$fr_26,	nowingsattack67	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack67 	= [	$fr_27,	nowingsattack68	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack68 	= [	$fr_28,	nowingsattack69	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
sound (self, CHAN_WEAPON, "soul/wingsflap.wav", 1, 1);
	self.nextthink = time + 0.05;
};
void()	nowingsattack69 	= [	$fr_29,	nowingsattack70	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
	self.nextthink = time + 0.05;
};
void()	nowingsattack70 	= [	$fr_30,	nowingsattack71	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.56;
	self.nextthink = time + 0.05;
};
void()	nowingsattack71 	= [	$fr_31,	nowingsattack72	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.52;
	self.glow_color = 5;
	self.glow_size = 420;
	self.nextthink = time + 0.05;
};
void()	nowingsattack72 	= [	$fr_32,	nowingsattack73	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.48;
	self.glow_color = 5;
	self.glow_size = 400;
	self.nextthink = time + 0.05;
};
void()	nowingsattack73 	= [	$fr_33,	nowingsattack74	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.44;
	self.nextthink = time + 0.05;
};
void()	nowingsattack74 	= [	$fr_34,	nowingsattack75	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.4;
	self.nextthink = time + 0.05;
};
void()	nowingsattack75 	= [	$fr_35,	nowingsattack76	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.36;
	self.nextthink = time + 0.05;
};
void()	nowingsattack76 	= [	$fr_21,	nowingsattack77	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);   
     	self.alpha = 0.32;  	
	self.nextthink = time + 0.05;
};
void()	nowingsattack77 	= [	$fr_22,	nowingsattack78	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.28;
	self.nextthink = time + 0.05;
};
void()	nowingsattack78 	= [	$fr_23,	nowingsattack79	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.24;
	self.nextthink = time + 0.05;
};
void()	nowingsattack79 	= [	$fr_24,	nowingsattack80	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.2;
	self.nextthink = time + 0.05;
};
void()	nowingsattack80 	= [	$fr_25,	nowingsattack81	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.16;
	self.nextthink = time + 0.05;
};
void()	nowingsattack81 	= [	$fr_26,	nowingsattack82	] {
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.12;
	self.nextthink = time + 0.05;
};
void()	nowingsattack82 	= [	$fr_27,	nowingsattack83	] {		// this is the last visible winged-demon frame
sendParticle("soulwings", self.origin, '0 0 0', 2);
     	self.alpha = 0.07;
	self.nextthink = time + 0.05;
};

void()	nowingsattack83 	= [	$fr_28,	nowingsattack84	] {		
     	self.alpha = -1;
	self.glow_color = 5;
	self.glow_size = 1;
	self.nextthink = time + 0.03;
};
void()	nowingsattack84 	= [	$fr_29,	nowingsattack85	] {
local	vector	org, destin, dir;
local float zufall, souldmg;

zufall = random();
	if (zufall > 0.5)
		destin = self.origin - '0 10 30';  
	else 
		destin = self.origin - '8 8 30';  

	org = self.origin + '0 0 -23';	
	dir = destin - org;
	dir = normalize (dir);
	traceline (org, self.origin + dir*174, TRUE, self); 

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);		
	WriteEntity (MSG_BROADCAST, self);		
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	var float autocvar_souldamage = 0;   	// set cvar 'souldamage' default to 0
	if (autocvar_souldamage == 0)	  		// if 'souldamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		{						// soul effect doesnt hurt the player
		}	
	else
		{							// if value is NOT "0" (example: '1'), player get hurt from this effect !
		souldmg = rint(1.5 + (2 * random()));  	// chances=  50%: 2 damage /  50%: 3 damage
		LightningDamage (org, trace_endpos, self, souldmg);   
		}

	self.nextthink = time + 0.05;
};
void()	nowingsattack85 	= [	$fr_30,	nowingsattack86	] {
local	vector	org, destin, dir;
local float zufall, souldmg;

zufall = random();
	if (zufall > 0.5)
		destin = self.origin - '0 -10 30';  
	else 
		destin = self.origin - '-8 -8 30';  

	org = self.origin + '0 0 -23';	
	dir = destin - org;
	dir = normalize (dir);
	traceline (org, self.origin + dir*174, TRUE, self); 

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);	
	WriteEntity (MSG_BROADCAST, self);		
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	var float autocvar_souldamage = 0;   	// set cvar 'souldamage' default to 0
	if (autocvar_souldamage == 0)	  		// if 'souldamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		{						// soul effect doesnt hurt the player
		}	
	else
		{							// if value is NOT "0" (example: '1'), player get hurt from this effect !
		souldmg = rint(1.5 + (2 * random()));  	// chances=  50%: 2 damage /  50%: 3 damage
		LightningDamage (org, trace_endpos, self, souldmg);   
		}

	self.nextthink = time + 0.05;
};
void()	nowingsattack86 	= [	$fr_31,	nowingsattack87	] {
local	vector	org, destin, dir;
local float zufall, souldmg;

zufall = random();
	if (zufall > 0.5)
		destin = self.origin - '10 0 30';  
	else 
		destin = self.origin - '8 -8 30';  

	org = self.origin + '0 0 -23';
	dir = destin - org;
	dir = normalize (dir);
	traceline (org, self.origin + dir*174, TRUE, self); 

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);		
	WriteEntity (MSG_BROADCAST, self);		
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	var float autocvar_souldamage = 0;   	// set cvar 'souldamage' default to 0
	if (autocvar_souldamage == 0)	  		// if 'souldamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		{						// soul effect doesnt hurt the player
		}
	else
		{							// if value is NOT "0" (example: '1'), player get hurt from this effect !
		souldmg = rint(1.5 + (2 * random()));  	// chances=  50%: 2 damage /  50%: 3 damage
		LightningDamage (org, trace_endpos, self, souldmg);   
		}

	self.nextthink = time + 0.05;
};
void()	nowingsattack87 	= [	$fr_32,	nowingsattack88	] {
local	vector	org, destin, dir;
local float zufall, souldmg;

zufall = random();
	if (zufall > 0.5)
		destin = self.origin - '-10 0 30';  
	else 
		destin = self.origin - '-8 8 30';  

	org = self.origin + '0 0 -23';	
	dir = destin - org;
	dir = normalize (dir);
	traceline (org, self.origin + dir*174, TRUE, self); 

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);	
	WriteEntity (MSG_BROADCAST, self);	
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	var float autocvar_souldamage = 0;   	// set cvar 'souldamage' default to 0
	if (autocvar_souldamage == 0)	  		// if 'souldamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		{						// soul effect doesnt hurt the player
		}	
	else
		{							// if value is NOT "0" (example: '1'), player get hurt from this effect !
		souldmg = rint(1.5 + (2 * random()));  	// chances=  50%: 2 damage /  50%: 3 damage
		LightningDamage (org, trace_endpos, self, souldmg);   
		}

	self.nextthink = time + 0.05;
};
void()	nowingsattack88 	= [	$fr_33,	wingsend	] {
local	vector	org, destin, dir;
local float souldmg;

	destin = self.origin - '0 0 30';    
	org = self.origin + '0 0 -23';
	dir = destin - org;
	dir = normalize (dir);
	traceline (org, self.origin + dir*96, TRUE, self);  

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING1);	
	WriteEntity (MSG_BROADCAST, self);		
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	var float autocvar_souldamage = 0;   	// set cvar 'souldamage' default to 0
	if (autocvar_souldamage == 0)	  		// if 'souldamage' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to '0'
		{						// soul effect doesnt hurt the player
		}	
	else
		{							// if value is NOT "0" (example: '1'), player get hurt from this effect !
		souldmg = rint(1.5 + (2 * random()));  	// chances=  50%: 2 damage /  50%: 3 damage
		LightningDamage (org, trace_endpos, self, souldmg);   
		}

	self.nextthink = time + 0.04;
};



void(float zet) wings = 
{
	local entity soulwings;
	local	vector org, faceplayer1, faceplayer2;

//	precache_model ("progs/wings.mdl");	// precached in worldspawn() due to savegame-bug

	soulwings = spawn ();
	soulwings.owner = self;
	soulwings.enemy = self.enemy;
	soulwings.movetype = MOVETYPE_FLY;
	soulwings.solid = SOLID_NOT;

faceplayer1 = vectoangles (self.enemy.origin - self.origin);	// adjust the wings to face the player !!!
makevectors (faceplayer1);
faceplayer2 = normalize (v_forward);
soulwings.angles = vectoangles(faceplayer2);  

	setmodel (soulwings, "progs/wings.mdl");
	setsize (soulwings, '0 0 0', '0 0 0');    // setsize (soulwings, VEC_ORIGIN, VEC_ORIGIN);	
   	soulwings.touch = SUB_Null;  

	soulwings.scale = 1.3;
	soulwings.alpha = 0.03;
 	soulwings.colormod = '1.7 0.3 0.3';
	soulwings.effects = EF_FULLBRIGHT;

org = self.origin; 
org_z = org_z + zet;   		// z-position of the wings (in relation to soul). Depending on the monster it spawnes.

	setorigin (soulwings, org);

	var float autocvar_soulattack = 2;  	// set cvar 'soulattack' default to 2
	if (autocvar_soulattack == 0)	  		// if 'soulattack' is set via autoexec.cfg to '0', play animation without attack
		soulwings.think = nowingsattack01;						
	else if (autocvar_soulattack == 1)		// if 'soulattack' is set via autoexec.cfg to '1' play animation with attack

		soulwings.think = wings01;	
	else							// if 'soulattack' doesnt exist in autoexec.cfg, or is set via autoexec.cfg to example '2'
		{						// play randomly animation with or without attack
		if (random() > 0.5)
			soulwings.think = nowingsattack01;
		else 
			soulwings.think = wings01;
		}

	soulwings.nextthink = time + 0.05;	
};

//////////////////////////////////////////////////////////////////
////////////    wings  end     ///////////////////////////////////
//////////////////////////////////////////////////////////////////



void(string modelname, float modelframe, float zet) soul =
{
local vector v;  				

v_x = (self.origin_x);
v_y = (self.origin_y);
v_z = (self.origin_z);

//	precache_sound ("soul/liftup.wav");	// precached in worldspawn() due to savegame-bug
//	precache_sound ("soul/flash.wav");	// precached in worldspawn() due to savegame-bug
//	precache_sound ("soul/wingsflap.wav");	// precached in worldspawn() due to savegame-bug
//	precache_sound ("soul/wingshot.wav");	// precached in worldspawn() due to savegame-bug
//	precache_sound ("soul/awake.wav");	// precached in worldspawn() due to savegame-bug


      self.origin = v; 
//	self.velocity = '0 0 25'; 	  // the corpse first gets overbright, before it starts to lift up. Therefore edited out
//	self.avelocity = '0 270 0';     // the corpse first gets overbright, before it starts to lift up. Therefore edited out
   	self.touch = SUB_Null;                
	self.movetype = MOVETYPE_FLY;
	setmodel (self, modelname);    // modelname is depending on the individual monster (included in soul call)
   	self.solid = SOLID_NOT;
	setsize (self, '0 0 0', '0 0 0');
	self.frame = modelframe;	 // modelframe is depending on the individual monster (included in soul call)

	alt_death000 ();			 // starts the soul animation
	wings(zet);				 // starts the wings animation (with 'zet' = z-position for the wings related to soul)

Gyro_Object_ClearPhysics(self);
};


