/*==============================================================================
Lord Karasu (New Ravenkeep monster by Redfield)
==============================================================================*/

// 000-012
$frame beam1 beam2 beam3 beam4 beam5 beam6 beam7 beam8 beam9
$frame beam10 beam11 beam12 beam13

// 013-029 (Frame 29 is interpolation point -- Do not use!)
$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12 walk13 walk14 walk15 walk16 walk17

// 030-071 (Frame 71 is interpolation point -- Do not use!)
$frame idlea1 idlea2 idlea3 idlea4 idlea5 idlea6 idlea7 idlea8 idlea9
$frame idlea10 idlea11 idlea12 idlea13 idlea14 idlea15 idlea16 idlea17
$frame idlea18 idlea19 idlea20 idlea21 idlea22 idlea23 idlea24 idlea25 idlea26
$frame idlea27 idlea28 idlea29 idlea30 idlea31 idlea32 idlea33 idlea34 idlea35
$frame idlea36 idlea37 idlea38 idlea39 idlea40 idlea41 idlea42

// 072-082 (Frame 82 is interpolation point -- Do not use!)
$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11

// 083-092
$frame strike1 strike2 strike3 strike4 strike5 strike6 strike7 strike8
$frame strike9 strike10

// 093-103
$frame lightning1 lightning2 lightning3 lightning4 lightning5 lightning6 lightning7
$frame lightning8 lightning9 lightning10 lightning11

// 104-127
$frame idleb1 idleb2 idleb3 idleb4 idleb5 idleb6 idleb7 idleb8 idleb9  
$frame idleb10 idleb11 idleb12 idleb13 idleb14 idleb15 idleb16 idleb17 idleb18
$frame idleb19 idleb20 idleb21 idleb22 idleb23 idleb24

// 128-141
$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8 pain9
$frame pain10 pain11 pain12 pain13 pain14

// 142-163
$frame spell1 spell2 spell3 spell4 spell5 spell6 spell7 spell8 spell9
$frame spell10 spell11 spell12 spell13 spell14 spell15 spell16 spell17 spell18
$frame spell19 spell20 spell21 spell22

// 164-181
$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12 death13 death14 death15 death16
$frame death17 death18

// 182-212
$frame idlec1 idlec2 idlec3 idlec4 idlec5 idlec6 idlec7 idlec8 idlec9  
$frame idlec10 idlec11 idlec12 idlec13 idlec14 idlec15 idlec16 idlec17 idlec18
$frame idlec19 idlec20 idlec21 idlec22 idlec23 idlec24 idlec25 idlec26 idlec27
$frame idlec28 idlec29 idlec30 idlec31

// 213-225
$frame rocks1 rocks2 rocks3 rocks4 rocks5 rocks6 rocks7 rocks8
$frame rocks9 rocks10 rocks11 rocks12 rocks13 

// 226-234
$frame kick1 kick2 kick3 kick4 kick5 kick6 kick7 kick8
$frame kick9 

void() karasu_reset_attachment;
void() spell_Transition;
void() check_SpellTrig;

//===========================================================================
void()	karasu_idlea1	= [	$idlea1,	karasu_idlea2	] { ai_stand(); };
void()	karasu_idlea2	= [	$idlea2,	karasu_idlea3	] { ai_stand(); };
void()	karasu_idlea3	= [	$idlea3,	karasu_idlea4	] { ai_stand(); };
void()	karasu_idlea4	= [	$idlea4,	karasu_idlea5	] { ai_stand(); };
void()	karasu_idlea5	= [	$idlea5,	karasu_idlea6	] { ai_stand(); };
void()	karasu_idlea6	= [	$idlea6,	karasu_idlea7	] { ai_stand(); };
void()	karasu_idlea7	= [	$idlea7,	karasu_idlea8	] { ai_stand(); };
void()	karasu_idlea8	= [	$idlea8,	karasu_idlea9	] { ai_stand(); };
void()	karasu_idlea9	= [	$idlea9,	karasu_idlea10	] { ai_stand(); };
void()	karasu_idlea10	= [	$idlea10,	karasu_idlea11	] { ai_stand(); };
void()	karasu_idlea11	= [	$idlea11,	karasu_idlea12	] { ai_stand(); };
void()	karasu_idlea12	= [	$idlea12,	karasu_idlea13	] { ai_stand(); monster_idle_sound(); };
void()	karasu_idlea13	= [	$idlea13,	karasu_idlea14	] { ai_stand(); };
void()	karasu_idlea14	= [	$idlea14,	karasu_idlea15	] { ai_stand(); };
void()	karasu_idlea15	= [	$idlea15,	karasu_idlea16	] { ai_stand(); };
void()	karasu_idlea16	= [	$idlea16,	karasu_idlea17	] { ai_stand(); };
void()	karasu_idlea17	= [	$idlea17,	karasu_idlea18	] { ai_stand(); };
void()	karasu_idlea18	= [	$idlea18,	karasu_idlea19	] { ai_stand(); };
void()	karasu_idlea19	= [	$idlea19,	karasu_idlea20	] { ai_stand(); };
void()	karasu_idlea20	= [	$idlea20,	karasu_idlea21	] { ai_stand(); };
void()	karasu_idlea21	= [	$idlea21,	karasu_idlea22	] { ai_stand(); };
void()	karasu_idlea22	= [	$idlea22,	karasu_idlea23	] { ai_stand(); };
void()	karasu_idlea23	= [	$idlea23,	karasu_idlea24	] { ai_stand(); };
void()	karasu_idlea24	= [	$idlea24,	karasu_idlea25	] { ai_stand(); };
void()	karasu_idlea25	= [	$idlea25,	karasu_idlea26	] { ai_stand(); };
void()	karasu_idlea26	= [	$idlea26,	karasu_idlea27	] { ai_stand(); };
void()	karasu_idlea27	= [	$idlea27,	karasu_idlea28	] { ai_stand(); };
void()	karasu_idlea28	= [	$idlea28,	karasu_idlea29	] { ai_stand(); };
void()	karasu_idlea29	= [	$idlea29,	karasu_idlea30	] { ai_stand(); };
void()	karasu_idlea30	= [	$idlea30,	karasu_idlea31	] { ai_stand(); };
void()	karasu_idlea31	= [	$idlea31,	karasu_idlea32	] { ai_stand(); };
void()	karasu_idlea32	= [	$idlea32,	karasu_idlea33	] { ai_stand(); };
void()	karasu_idlea33	= [	$idlea33,	karasu_idlea34	] { ai_stand(); };
void()	karasu_idlea34	= [	$idlea34,	karasu_idlea35	] { ai_stand(); };
void()	karasu_idlea35	= [	$idlea35,	karasu_idlea36	] { ai_stand(); };
void()	karasu_idlea36	= [	$idlea36,	karasu_idlea37	] { ai_stand(); };
void()	karasu_idlea37	= [	$idlea37,	karasu_idlea38	] { ai_stand(); };
void()	karasu_idlea38	= [	$idlea38,	karasu_idlea39	] { ai_stand(); };
void()	karasu_idlea39	= [	$idlea39,	karasu_idlea40	] { ai_stand(); };
void()	karasu_idlea40	= [	$idlea40,	karasu_idlea41	] { ai_stand(); };
void()	karasu_idlea41	= [	$idlea41,	karasu_idleb1	] { ai_stand(); };

//===========================================================================
void()	karasu_idlec1	= [	$idlec1,	karasu_idlec2	] { ai_stand(); };
void()	karasu_idlec2	= [	$idlec2,	karasu_idlec3	] { ai_stand(); };
void()	karasu_idlec3	= [	$idlec3,	karasu_idlec4	] { ai_stand(); };
void()	karasu_idlec4	= [	$idlec4,	karasu_idlec5	] { ai_stand(); };
void()	karasu_idlec5	= [	$idlec5,	karasu_idlec6	] { ai_stand(); };
void()	karasu_idlec6	= [	$idlec6,	karasu_idlec7	] { ai_stand(); monster_idle_sound(); };
void()	karasu_idlec7	= [	$idlec7,	karasu_idlec8	] { ai_stand(); };
void()	karasu_idlec8	= [	$idlec8,	karasu_idlec9	] { ai_stand(); };
void()	karasu_idlec9	= [	$idlec9,	karasu_idlec10	] { ai_stand(); };
void()	karasu_idlec10	= [	$idlec10,	karasu_idlec11	] { ai_stand(); };
void()	karasu_idlec11	= [	$idlec11,	karasu_idlec12	] { ai_stand(); };
void()	karasu_idlec12	= [	$idlec12,	karasu_idlec13	] { ai_stand(); };
void()	karasu_idlec13	= [	$idlec13,	karasu_idlec14	] { ai_stand(); };
void()	karasu_idlec14	= [	$idlec14,	karasu_idlec15	] { ai_stand(); };
void()	karasu_idlec15	= [	$idlec15,	karasu_idlec16	] { ai_stand(); };
void()	karasu_idlec16	= [	$idlec16,	karasu_idlec17	] { ai_stand(); };
void()	karasu_idlec17	= [	$idlec17,	karasu_idlec18	] { ai_stand(); };
void()	karasu_idlec18	= [	$idlec18,	karasu_idlec19	] { ai_stand(); };
void()	karasu_idlec19	= [	$idlec19,	karasu_idlec20	] { ai_stand(); };
void()	karasu_idlec20	= [	$idlec20,	karasu_idlec21	] { ai_stand(); };
void()	karasu_idlec21	= [	$idlec21,	karasu_idlec22	] { ai_stand(); };
void()	karasu_idlec22	= [	$idlec22,	karasu_idlec23	] { ai_stand(); };
void()	karasu_idlec23	= [	$idlec23,	karasu_idlec24	] { ai_stand(); };
void()	karasu_idlec24	= [	$idlec24,	karasu_idlec25	] { ai_stand(); };
void()	karasu_idlec25	= [	$idlec25,	karasu_idlec26	] { ai_stand(); };
void()	karasu_idlec26	= [	$idlec26,	karasu_idlec27	] { ai_stand(); };
void()	karasu_idlec27	= [	$idlec27,	karasu_idlec28	] { ai_stand(); };
void()	karasu_idlec28	= [	$idlec28,	karasu_idlec29	] { ai_stand(); };
void()	karasu_idlec29	= [	$idlec29,	karasu_idlec30	] { ai_stand(); };
void()	karasu_idlec30	= [	$idlec30,	karasu_idlec31	] { ai_stand(); };
void()	karasu_idlec31	= [	$idlec31,	karasu_idleb1	] { ai_stand(); };

//===========================================================================
void()	karasu_idleb1	= [	$idleb1,	karasu_idleb2	] { self.idlebusy = FALSE; monster_idle_sound(); ai_stand(); };
void()	karasu_idleb2	= [	$idleb2,	karasu_idleb3	] { ai_stand(); };
void()	karasu_idleb3	= [	$idleb3,	karasu_idleb4	] { ai_stand(); };
void()	karasu_idleb4	= [	$idleb4,	karasu_idleb5	] { ai_stand(); };
void()	karasu_idleb5	= [	$idleb5,	karasu_idleb6	] { ai_stand(); };
void()	karasu_idleb6	= [	$idleb6,	karasu_idleb7	] { ai_stand(); };
void()	karasu_idleb7	= [	$idleb7,	karasu_idleb8	] { ai_stand(); };
void()	karasu_idleb8	= [	$idleb8,	karasu_idleb9	] { ai_stand(); };
void()	karasu_idleb9	= [	$idleb9,	karasu_idleb10	] { ai_stand(); };
void()	karasu_idleb10	= [	$idleb10,	karasu_idleb11	] { ai_stand(); };
void()	karasu_idleb11	= [	$idleb11,	karasu_idleb12	] { ai_stand(); };
void()	karasu_idleb12	= [	$idleb12,	karasu_idleb13	] { ai_stand(); };
void()	karasu_idleb13	= [	$idleb13,	karasu_idleb14	] { ai_stand(); };
void()	karasu_idleb14	= [	$idleb14,	karasu_idleb15	] { ai_stand(); };
void()	karasu_idleb15	= [	$idleb15,	karasu_idleb16	] { ai_stand(); };
void()	karasu_idleb16	= [	$idleb16,	karasu_idleb17	] { ai_stand(); };
void()	karasu_idleb17	= [	$idleb17,	karasu_idleb18	] { ai_stand(); };
void()	karasu_idleb18	= [	$idleb18,	karasu_idleb19	] { ai_stand(); };
void()	karasu_idleb19	= [	$idleb19,	karasu_idleb20	] { ai_stand(); };
void()	karasu_idleb20	= [	$idleb20,	karasu_idleb21	] { ai_stand(); };
void()	karasu_idleb21	= [	$idleb21,	karasu_idleb22	] { ai_stand(); };
void()	karasu_idleb22	= [	$idleb22,	karasu_idleb23	] { ai_stand(); };
void()	karasu_idleb23	= [	$idleb23,	karasu_idleb24	] { ai_stand(); };
void()	karasu_idleb24	= [	$idleb24,	karasu_idleb1	] {
	if (random() < MON_IDLE_ANIMATION) {
		self.lip = random();
		if (self.lip < 0.5) self.think = karasu_idlea1;		// Cross arms
		else self.think = karasu_idlec1;			// Hands on hips
	}
	ai_stand();
};

//===========================================================================
void()	karasu_walk1	= [	$walk1,		karasu_walk2	] { ai_walk(2);self.skin = 0;};
void()	karasu_walk2	= [	$walk2,		karasu_walk3	] { ai_walk(5); };
void()	karasu_walk3	= [	$walk3,		karasu_walk4	] { monster_footstep(FALSE); ai_walk(5); };
void()	karasu_walk4	= [	$walk4,		karasu_walk5	] { ai_walk(4); };
void()	karasu_walk5	= [	$walk5,		karasu_walk6	] { ai_walk(4); };
void()	karasu_walk6	= [	$walk6,		karasu_walk7	] { ai_walk(2); };
void()	karasu_walk7	= [	$walk7,		karasu_walk8	] { ai_walk(2); };
void()	karasu_walk8	= [	$walk8,		karasu_walk9	] { ai_walk(3); };
void()	karasu_walk9	= [	$walk9,		karasu_walk10	] { ai_walk(3); };
void()	karasu_walk10	= [	$walk10,	karasu_walk11	] { ai_walk(4); };
void()	karasu_walk11	= [	$walk11,	karasu_walk12	] { monster_footstep(FALSE); ai_walk(3); };
void()	karasu_walk12	= [	$walk12,	karasu_walk13	] { ai_walk(4); };
void()	karasu_walk13	= [	$walk13,	karasu_walk14	] { ai_walk(3); };
void()	karasu_walk14	= [	$walk14,	karasu_walk15	] { ai_walk(4); };
void()	karasu_walk15	= [	$walk15,	karasu_walk16	] { ai_walk(6); };
void()	karasu_walk16	= [	$walk16,	karasu_walk1	] { ai_walk(2); };

//----------------------------------------------------------------------

float spell_Stage;
float spell_Counter;

void() spell_partring = {
	particle_ring(self.origin + '0 0 -16', '0 0 4', '4 4 16', 60, 64, 1.4, 4);
} 


void()	karasu_spell1	= [	$spell1,	karasu_spell2	] {
self.pain_finished = time + 8.5;
self.takedamage = DAMAGE_NO;	// Immune to damage
spell_Counter = spell_Counter + 1;
Resist_Save(self);	// Save resistances for Later
//Immune to damage while casting
Resist_ChangeType(self, TRUE);
ai_forward(10);self.skin = 3;
};
void()	karasu_spell2	= [	$spell2,	karasu_spell3	] { ai_forward(8); };
void()	karasu_spell3	= [	$spell3,	karasu_spell4	] {};
void()	karasu_spell4	= [	$spell4,	karasu_spell5	] {};
void()	karasu_spell5	= [	$spell5,	karasu_spell6	] {
sound (self, CHAN_WEAPON, "redfield/karasu/spell.wav", 1, ATTN_NORM);
local entity r;
self.owner = spawn();
r = self.owner;
setmodel (r, MODEL_PROJ_KSPELL);
setorigin (r, self.origin);
r.nextthink = time + 7.3;
r.think = SUB_Remove;
check_SpellTrig(); };
void()	karasu_spell6	= [	$spell6,	karasu_spell7	] { spell_partring(); };
void()	karasu_spell7	= [	$spell7,	karasu_spell8	] {};
void()	karasu_spell8	= [	$spell8,	karasu_spell9	] {};
void()	karasu_spell9	= [	$spell9,	karasu_spell10	] {};
void()	karasu_spell10	= [	$spell10,	karasu_spell11	] {};
void()	karasu_spell11	= [	$spell11,	karasu_spell12	] {};
void()	karasu_spell12	= [	$spell12,	karasu_spell13	] {};
void()	karasu_spell13	= [	$spell13,	karasu_spell14	] {};
void()	karasu_spell14	= [	$spell14,	karasu_spell15	] {};
void()	karasu_spell15	= [	$spell15,	karasu_spell16	] {};
void()	karasu_spell16	= [	$spell16,	karasu_spell17	] { spell_Stage = spell_Stage + 1;};
void()	karasu_spell17	= [	$spell17,	karasu_spell6	] { spell_Transition(); };
void()	karasu_spell18	= [	$spell18,	karasu_spell19	] {};
void()	karasu_spell19	= [	$spell19,	karasu_spell20	] {};
void()	karasu_spell20	= [	$spell20,	karasu_spell21	] { ai_back(4);self.skin = 0;};
void()	karasu_spell21	= [	$spell21,	karasu_spell22	] {
sound (self, CHAN_VOICE, "redfield/karasu/taunt.wav", 1, ATTN_NONE);
ai_back(5); };
void()	karasu_spell22	= [	$spell22,	karasu_run1	] {
self.takedamage = DAMAGE_AIM;	// Start taking damage
//Restore normal damage
Resist_ChangeType(self, FALSE);
};

//----------------------------------------------------------------------

//Finsh the spell at the sixth cycle
void() spell_Transition = {	
	if (spell_Stage < 2)
		sound (self, CHAN_VOICE, "redfield/karasu/chant.wav", 1, ATTN_IDLE);
	else if (spell_Stage > 5)
		karasu_spell18();
};

//----------------------------------------------------------------------
// Check if HP below half and setup spell.
//----------------------------------------------------------------------

float() karasu_SpellCheck = {
	if (self.health > 1 && self.health < 900 && spell_Counter < 1) 
		{
		return TRUE;
		}
	return FALSE;
};

void() karasu_SpellRun = {
	if (karasu_SpellCheck() == TRUE) { karasu_spell1(); return;}
};

void() check_SpellTrig =
// Is there any trigger for the spell?
{
	if (self.noise != "") {
		self.attachment2 = find(world, targetname, self.noise);
			if (self.attachment2.classtype == CT_MONKARASUSPELL) {
				// Spawn any adds to keep player busy
				if (self.attachment2.target != "") 
					trigger_strs(self.attachment2.target, self);
		}
	}
};
				
//----------------------------------------------------------------------
void()	karasu_run1	= [	$run1,		karasu_run2	] { ai_run (16);karasu_reset_attachment();self.skin = 0;karasu_SpellRun(); };
void()	karasu_run2	= [	$run2,		karasu_run3	] { monster_footstep(FALSE); ai_run(19);karasu_SpellRun(); };
void()	karasu_run3	= [	$run3,		karasu_run4	] { ai_run(14);karasu_SpellRun(); };
void()	karasu_run4	= [	$run4,		karasu_run5	] { ai_run(13);karasu_SpellRun(); };
void()	karasu_run5	= [	$run5,		karasu_run6	] { ai_run(11);karasu_SpellRun(); };
void()	karasu_run6	= [	$run6,		karasu_run7	] { ai_run(14);karasu_SpellRun(); };
void()	karasu_run7	= [	$run7,		karasu_run8	] { monster_footstep(FALSE); ai_run(14);karasu_SpellRun(); };
void()	karasu_run8	= [	$run8,		karasu_run9	] { ai_run(16);karasu_SpellRun(); };
void()	karasu_run9	= [	$run9,		karasu_run10	] { ai_run(17);karasu_SpellRun(); };
void()	karasu_run10	= [	$run10,		karasu_run1	] { ai_run(11);karasu_SpellRun(); };

//----------------------------------------------------------------------
void()	karasu_strike1	= [	$strike1,	karasu_strike2	] { ai_charge(4); };
void()	karasu_strike2	= [	$strike2,	karasu_strike3	] { ai_charge(10); };
void()	karasu_strike3	= [	$strike3,	karasu_strike4	] { monster_footstep(FALSE); ai_charge(8); };
void()	karasu_strike4	= [	$strike4,	karasu_strike5	] { ai_charge(8);
	sound (self, CHAN_VOICE, "redfield/karasu/melee_strike.wav", 1, ATTN_NORM); };
void()	karasu_strike5	= [	$strike5,	karasu_strike6	] { ai_charge(4); };
void()	karasu_strike6	= [	$strike6,	karasu_strike7	] { ai_charge(2); };
void()	karasu_strike7	= [	$strike7,	karasu_strike8	] { monster_footstep(FALSE); ai_charge(0); ai_melee(); };
void()	karasu_strike8	= [	$strike8,	karasu_strike9	] { ai_charge(0); ai_melee(); };
void()	karasu_strike9	= [	$strike9,	karasu_strike10	] { ai_charge(8); };
void()	karasu_strike10	= [	$strike10,	karasu_run1	] { ai_charge(4); };

//----------------------------------------------------------------------
void()	karasu_kick1	= [	$kick1,		karasu_kick2	] { ai_charge(4);
	sound (self, CHAN_VOICE, "redfield/karasu/melee_strike.wav", 1, ATTN_NORM); };
void()	karasu_kick2	= [	$kick2,		karasu_kick3	] { ai_charge(0); };
void()	karasu_kick3	= [	$kick3,		karasu_kick4	] { ai_charge(0); ai_melee(); };
void()	karasu_kick4	= [	$kick4,		karasu_kick5	] { ai_charge(0); ai_melee(); };
void()	karasu_kick5	= [	$kick5,		karasu_kick6	] { ai_charge(0); };
void()	karasu_kick6	= [	$kick6,		karasu_kick7	] { ai_charge(0); };
void()	karasu_kick7	= [	$kick7,		karasu_kick8	] { monster_footstep(FALSE); ai_charge(0); };
void()	karasu_kick8	= [	$kick8,		karasu_kick9	] { ai_charge(4); };
void()	karasu_kick9	= [	$kick9,		karasu_run1	] { ai_charge(8); };

float karasu_sork;

void() karasu_choosemelee = {
	karasu_sork = karasu_sork + 1;

	if (karasu_sork == 1)
		karasu_strike1();
	else if (karasu_sork == 2)
	{
		karasu_kick1();
		karasu_sork = 0;
	}
};

void()	karasu_pain1	= [	$pain1,		karasu_pain2	] { self.skin = 0;karasu_SpellRun();
	sound (self, CHAN_VOICE, "redfield/karasu/pain.wav", 1, ATTN_NORM);
};
void()	karasu_pain2	= [	$pain2,		karasu_pain3	] {};
void()	karasu_pain3	= [	$pain3,		karasu_pain4	] {};
void()	karasu_pain4	= [	$pain4,		karasu_pain5	] { monster_footstep(FALSE);ai_back(5); };
void()	karasu_pain5	= [	$pain5,		karasu_pain6	] {};
void()	karasu_pain6	= [	$pain6,		karasu_pain7	] {};
void()	karasu_pain7	= [	$pain7,		karasu_pain8	] {};
void()	karasu_pain8	= [	$pain8,		karasu_pain9	] {};
void()	karasu_pain9	= [	$pain9,		karasu_pain10	] {};
void()	karasu_pain10	= [	$pain10,	karasu_pain11	] {};
void()	karasu_pain11	= [	$pain11,	karasu_pain12	] {};
void()	karasu_pain12	= [	$pain12,	karasu_pain13	] {};
void()	karasu_pain13	= [	$pain13,	karasu_pain14	] {};
void()	karasu_pain14	= [	$pain14,	karasu_run1	] {};

void(entity inflictor, entity attacker, float damage) karasu_pain = {
	//Reset beam attachment
	karasu_reset_attachment();	
	
	// Check all pain conditions and set up what to do next
	monster_pain_check(attacker, damage);

	// Any pain animation/sound required?
	if (self.pain_check > 0) {
		sound (self, CHAN_VOICE, self.pain_sound, 1, ATTN_NORM);	
		if (self.pain_check == 1) karasu_pain1();
		else if (self.pain_check == 2) {
			// reset axe hit and setup short pain recovery
			self.pain_finished = time + 2;
			self.axhitme = 0;
			karasu_pain1();
		}
	}
};

// Attachment management (create, finish and delete)
void() karasu_create_attachment = {
	// Are the attachments setup yet?
	if (!self.attachment) {
		self.attachment = spawn();
		//self.attachment.owner = self;
		self.attachment.classtype = CT_ATTACHMENT;
		self.attachment.state = FALSE;
	}
};

void() karasu_reset_attachment = {
	if (self.attachment) {
		if (self.attachment.state) {
			// Move attachment into place ready for use
			self.attachment.movetype = MOVETYPE_NONE;
			self.attachment.solid = SOLID_NOT;
			self.attachment.frame = 0;
			self.attachment.skin = 0;
			setmodel(self.attachment, "");
			setsize (self.attachment, VEC_ORIGIN, VEC_ORIGIN);
			setorigin(self.attachment, self.origin);
			// Using empty model, so reset angle, frame and skin.
			self.attachment.angles = self.angles;
			self.attachment.state = FALSE;
		}
	}
};

void() karasu_setup_attachment = {
	if (self.attachment) {
		self.attachment.movetype = MOVETYPE_NONE;
		self.attachment.solid = SOLID_NOT;
		setmodel(self.attachment, MODEL_PROJ_KSPHERE);
		setsize (self.attachment, VEC_ORIGIN, VEC_ORIGIN);
		self.attachment.state = TRUE;
	}
};

void() karasu_remove_attachment = {
	if (self.attachment) {
		self.attachment.state = FALSE;
		self.attachment.think = SUB_Remove;
		self.attachment.nextthink = time + 0.1;
	}
};

// RANGE ATTACK 1 - classic hitscan beam
float beam_sweeper;

void(vector beamoffset) kbeam_shoot = {
	local vector org, dir;
	if (self.health < 1) return;
	
	ai_face();
	makevectors(self.angles);
	org = self.origin + attack_vector(self.attack_offset);
	dir = self.enemy.origin + (attack_vector(beamoffset)) - org;
	dir = normalize (dir);

	// Check if Karasu can fire further than default
	if (self.attack_sniper == TRUE) self.enemydist = range_distance(self.enemy, FALSE);
	else self.enemydist = MONAI_KARASURANGE;
	
	traceline (org, self.origin + dir*self.enemydist, TRUE, self); // Trace direct line of beam in front of Karasu
	QC_ParseBeam(0,"progs/redfield/beam.mdl", self, org, trace_endpos, 32); // Display beam model segments

	if (ai_foundbreakable(self, trace_ent, FALSE)) T_Damage (trace_ent, self, self, 80, DAMARMOR); // Check for any breakables first
	else LightningDamage(org, trace_endpos, self, 5 + skill); // Standard player lightning damage function
};

void(vector leftofs, vector rightofs, float spframe, float spalpha) karasu_charging = {
	local vector org, dir;
	local float litpoint;
	
	if (self.health < 1) return;

	// Check if attachment has been setup yet
	if (!self.attachment) karasu_create_attachment();

	// Frame 0 is start of the sequence (move everything into place)
	if (spframe == 0) karasu_setup_attachment();

	// Turn toward enemy
	ai_face();
	self.effects = self.effects | EF_MUZZLEFLASH;
	
	// Place orb in the center of the electricity
	setorigin(self.attachment, self.origin);
	self.attachment.angles = self.angles;
	self.attachment.frame = spframe;
	self.attachment.alpha = spalpha;	

	// Work out each hand position
	makevectors(self.angles);
	self.pos1 = self.origin + attack_vector(leftofs);
	self.pos2 = self.origin + attack_vector(rightofs);	

	// Spawn some particles around the sphere
	dir = normalize(self.pos2 - self.pos1);
	litpoint = vlen(self.pos2 - self.pos1) * random();
	self.pos3 = self.pos1 + (dir*litpoint);
	particle_explode(self.pos3, 3+random()*2, 0.1+random()*0.5, PARTICLE_BURST_YELLOW, PARTICLE_BURST_CENTER);
};


void()	karasu_beam1	= [	$beam1,		karasu_beam2	] { ai_face();karasu_reset_attachment();
	beam_sweeper = 0;
	sound (self, CHAN_WEAPON, "redfield/karasu/beam_charge.wav", 1, ATTN_NORM); };
void()	karasu_beam2	= [	$beam2,		karasu_beam3	] { ai_face(); };
void()	karasu_beam3	= [	$beam3,		karasu_beam4	] { ai_face(); };
void()	karasu_beam4	= [	$beam4,		karasu_beam5	] { ai_face(); };
void()	karasu_beam5	= [	$beam5,		karasu_beam6	] { ai_face();karasu_charging('21 -12 19','21 12 19',0,0.4);self.skin = 2;};
void()	karasu_beam6	= [	$beam6,		karasu_beam7	] { karasu_charging('21 -11 21','21 11 21',1,0.6); };
void()	karasu_beam7	= [	$beam7,		karasu_beam8	] { karasu_charging('21 -10 23','21 10 23',2,0.8); };
void()	karasu_beam8	= [	$beam8,		karasu_beam9	] { karasu_charging('21 -9 25','21 9 25',3,1);
	if (random() < 0.5) {
		beam_sweeper = 1;
		kbeam_shoot('0 48 16');
	}	
	else { kbeam_shoot('0 -48 16');}
	
	sound (self, CHAN_WEAPON, "redfield/karasu/beam.wav", 1, ATTN_NORM); };
void()	karasu_beam9	= [	$beam9,		karasu_beam10	] { karasu_charging('21 -9 25','21 9 25',3,1);
	if (beam_sweeper == 1) {
		kbeam_shoot('0 24 16');}
	else {
		kbeam_shoot('0 -24 16');
	}
};
void()	karasu_beam10	= [	$beam10,	karasu_beam11	] { karasu_charging('21 -9 25','21 9 25',3,1);kbeam_shoot('0 0 16'); };
void()	karasu_beam11	= [	$beam11,	karasu_beam12	] { karasu_charging('21 -9 25','21 9 25',3,1);
	if (beam_sweeper == 1) {
		kbeam_shoot('0 -24 16');}
	else {
		kbeam_shoot('0 24 16');
	}
};
void()	karasu_beam12	= [	$beam12,	karasu_beam13	] { karasu_charging('21 -9 25','21 9 25',3,1);
	if (beam_sweeper == 1) {
		kbeam_shoot('0 -48 16');}
	else {
		kbeam_shoot('0 48 16');
	}
};
void()	karasu_beam13	= [	$beam13,	karasu_run1	] { karasu_reset_attachment();self.skin = 0;};

// RANGE ATTACK 2 - Lightning Blast (Hitscan)
void() klight_shoot = {
	local vector org, dir;
	if (self.health < 1) return;
	
	ai_face();
	self.effects = self.effects | EF_MUZZLEFLASH;

	makevectors(self.angles);
	org = self.origin + attack_vector(self.attack_offset);
	dir = self.enemy.origin + '0 0 16' - org;
	dir = normalize (dir);

	self.enemydist = MONAI_KARASURANGE2;
	
	// Trace direct line of lightning in front of Karasu
	traceline (org, self.origin + dir*self.enemydist, TRUE, self);

	// Check for any breakables first
	if (ai_foundbreakable(self, trace_ent, FALSE)) {
		T_Damage (trace_ent, self, self, 80, DAMARMOR);
	}
	// Standard player lightning damage function
	else LightningDamage(org, trace_endpos, self, 4 + skill);
};

void(vector leftofsb, vector rightofsb) karasu_litcharge = {	
	if (self.health < 1) return;

	// Turn toward enemy
	ai_face();

	// Work out each hand position
	makevectors(self.angles);
	self.pos1 = self.origin + attack_vector(leftofsb);
	self.pos2 = self.origin + attack_vector(rightofsb);	

	// Spawn some particles around the hands
	particle_explode(self.pos1, 3+random()*2, 0.2+random()*0.5, PARTICLE_BURST_BLUE, PARTICLE_BURST_LOSTUP);
	particle_explode(self.pos2, 3+random()*2, 0.2+random()*0.5, PARTICLE_BURST_BLUE, PARTICLE_BURST_LOSTUP);
};


void()	karasu_lightning1	= [	$lightning1,		karasu_lightning2	] { ai_face();
	sound (self, CHAN_WEAPON, "redfield/karasu/light_charge.wav", 1, ATTN_NORM); };
void()	karasu_lightning2	= [	$lightning2,		karasu_lightning3	] { ai_face(); };
void()	karasu_lightning3	= [	$lightning3,		karasu_lightning4	] { ai_face();karasu_litcharge('16 -8 16','16 8 16');self.skin = 1;};
void()	karasu_lightning4	= [	$lightning4,		karasu_lightning5	] { ai_face();karasu_litcharge('18 -6 18','18 6 18'); };
void()	karasu_lightning5	= [	$lightning5,		karasu_lightning6	] { karasu_litcharge('18 -6 25','18 6 25'); };
void()	karasu_lightning6	= [	$lightning6,		karasu_lightning7	] { karasu_litcharge('21 -14 30','21 14 30'); };
void()	karasu_lightning7	= [	$lightning7,		karasu_lightning8	] { karasu_litcharge('20 -22 38','20 22 38');klight_shoot();
sound (self, CHAN_WEAPON, "redfield/karasu/light_bolt.wav", 1, ATTN_NORM);
local entity o;
ai_face();
self.owner = spawn();
o = self.owner;
setmodel (o, MODEL_PROJ_KLIGHT);
setorigin (o, self.origin);
o.angles = self.angles;
o.nextthink = time + 0.3;
o.think = SUB_Remove;};
void()	karasu_lightning8	= [	$lightning8,		karasu_lightning9	] { karasu_litcharge('20 -22 38','20 22 38');klight_shoot(); };
void()	karasu_lightning9	= [	$lightning9,		karasu_lightning10	] { klight_shoot(); };
void()	karasu_lightning10	= [	$lightning10,		karasu_lightning11	] {};
void()	karasu_lightning11	= [	$lightning11,		karasu_run1		] { self.skin = 0;};


// RANGE ATTACK 3 - Rings - from Golem rock storm

void() zring_particle = {

    	local    vector    org, vec;
    
    	org = self.origin;  

    	particle(org, vec, 72, 4);
    	self.think = zring_particle; 
    	self.nextthink = time + 0.1;
}

void() karasu_rocks = {
	local float shotcount, zpart;
	local vector org, dir, yrand, zrand;

	if (!self.enemy) return;
	if (self.health < 1) return;

	// Make sure facing the right direction
	ai_face();
	makevectors(self.angles);

	// Spawn a mist of particles where projectiles came from
	org = self.origin + v_forward*20;
	zpart = 25 + rint(random()*25);
	particle_explode(org, zpart, 1, PARTICLE_BURST_RED, PARTICLE_BURST_UPWARD);

	// Randomize quantity each time called
	if (random() < 0.5) shotcount = 2;
	else shotcount = 3;

	while (shotcount > 0) {
		// Randomly spawn rings from Karasu's chest
		yrand = (crandom()*30)*v_right;
		zrand = (crandom()*30)*v_up;
		org = self.origin + attack_vector(self.attack_offset) + yrand + zrand;

		// Straight line velocity from source to target
		dir = (self.enemy.origin - org) + (v_right*(crandom()*50));
		dir = normalize (dir);

		// Variable speed based on skill level with extra random spice
		self.attack_speed = SPEED_KARASUROCKS + (skill * SPEED_KARASUSKILL) + random()*10;
		launch_projectile(org,dir,NO_SPIN,CT_PROJ_ZRING,self.attack_speed);
		newmis.think = zring_particle;
    		newmis.nextthink = time + 0.1;
		shotcount = shotcount - 1;
	}
};

void()	karasu_rocks1	= [	$rocks1,	karasu_rocks2	] { ai_face();self.pain_finished = time + 1.5;
	sound (self, CHAN_WEAPON, "redfield/karasu/hotrings.wav", 1, ATTN_NORM); };
void()	karasu_rocks2	= [	$rocks2,	karasu_rocks3	] { ai_face(); };
void()	karasu_rocks3	= [	$rocks3,	karasu_rocks4	] { ai_face(); };
void()	karasu_rocks4	= [	$rocks4,	karasu_rocks5	] { ai_face(); };
void()	karasu_rocks5	= [	$rocks5,	karasu_rocks6	] { ai_face(); };
void()	karasu_rocks6	= [	$rocks6,	karasu_rocks7	] { karasu_rocks(); self.skin = 3;};
void()	karasu_rocks7	= [	$rocks7,	karasu_rocks8	] { karasu_rocks(); };
void()	karasu_rocks8	= [	$rocks8,	karasu_rocks9	] { karasu_rocks(); };
void()	karasu_rocks9	= [	$rocks9,	karasu_rocks10	] { self.skin = 0;};
void()	karasu_rocks10	= [	$rocks10,	karasu_rocks11	] {};
void()	karasu_rocks11	= [	$rocks11,	karasu_rocks12	] {};
void()	karasu_rocks12	= [	$rocks12,	karasu_rocks13	] {};
void()	karasu_rocks13	= [	$rocks13,	karasu_run1	] {};

void() karasu_choose_atk = {
	local vector delta;
	
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) < MONAI_KARASURANGE2) {
		karasu_lightning1();
	} else if (vlen(delta) < MONAI_KARASURANGE3)  {
		karasu_rocks1();
	} else {
		karasu_beam1();
	}
};
	
void()	karasu_die1	= [	$death1,	karasu_die2	] { ai_forward(5);self.skin = 0;};
void()	karasu_die2	= [	$death2,	karasu_die3	] { ai_forward(4); };
void()	karasu_die3	= [	$death3,	karasu_die4	] { sound (self, CHAN_VOICE, self.death_sound, 1, ATTN_NORM);
	self.solid = SOLID_NOT; ai_forward(7); };
void()	karasu_die4	= [	$death4,	karasu_die5	] {};
void()	karasu_die5	= [	$death5,	karasu_die6	] {};
void()	karasu_die6	= [	$death6,	karasu_die7	] {};
void()	karasu_die7	= [	$death7,	karasu_die8	] {};
void()	karasu_die8	= [	$death8,	karasu_die9	] {};
void()	karasu_die9	= [	$death9,	karasu_die10	] {};
void()	karasu_die10	= [	$death10,	karasu_die11	] {
	particle_explode(self.origin + '0 0 -24', 128, 1+random()*0.5, PARTICLE_BURST_RED, PARTICLE_BURST_UPWARD);
};
void()	karasu_die11	= [	$death11,	karasu_die12	] { ai_forward(4); };
void()	karasu_die12	= [	$death12,	karasu_die13	] { ai_forward(5); };
void()	karasu_die13	= [	$death13,	karasu_die14	] {};
void()	karasu_die14	= [	$death14,	karasu_die15	] {};
void()	karasu_die15	= [	$death15,	karasu_die16	] {
	sound (self, CHAN_FEET, GIBHIT1_METALSOUND, 1, ATTN_FEETL); };
void()	karasu_die16	= [	$death16,	karasu_die17	] {
	particle_explode(self.origin + '0 0 -16', 64, 1+random()*0.5, PARTICLE_BURST_RED, PARTICLE_BURST_UPWARD);
};
void()	karasu_die17	= [	$death17,	karasu_die18	] {};
void()	karasu_die18	= [	$death18,	karasu_die19	] { self.alpha = 0.8;};
void()	karasu_die19	= [	$death18,	karasu_die20	] { self.alpha = 0.6; self.skin = 4;};
void()	karasu_die20	= [	$death18,	karasu_die21	] { self.alpha = 0.4;};
void()	karasu_die21	= [	$death18,	karasu_die22	] { self.alpha = 0.2;
	self.effects = self.effects | EF_MUZZLEFLASH;
};
void()	karasu_die22	= [	$death18,	karasu_die22	] {
	// Stop thinking and hide entity (prevent karasu_die22 loop)
	self.nextthink = LARGE_TIMER;
	self.think = SUB_Null;
	entity_hide(self);
};

void() karasu_die = {
	// Pre-check routine to tidy up extra entities
	monster_death_precheck();
	// Make sure attachments are removed
	karasu_remove_attachment();
	
	// regular death
	if (!self.gibbed) karasu_die1();
};

void() monster_karasu_precache = {
	precache_model ("progs/redfield/mon_karasu.mdl");
	precache_model (MODEL_PROJ_KSPHERE);
	precache_model (MODEL_PROJ_KLIGHT);
	precache_model (MODEL_PROJ_ZRING);
	precache_model (MODEL_PROJ_KSPELL);
	precache_sound ("redfield/karasu/beam_charge.wav");
	precache_sound ("redfield/karasu/beam.wav");
	precache_sound ("redfield/karasu/light_charge.wav");
	precache_sound ("redfield/karasu/light_bolt.wav");
	precache_sound ("redfield/karasu/melee_strike.wav");
	precache_sound ("redfield/karasu/spell.wav");
	precache_sound ("redfield/karasu/chant.wav");
	precache_sound ("redfield/karasu/taunt.wav");
	precache_sound ("redfield/karasu/pain.wav");
	precache_sound ("redfield/karasu/hotrings.wav"); // Rings - range attack
	precache_sound ("hknight/hit.wav");
	precache_sound ("redfield/karasu/idle.wav");
	precache_sound ("redfield/karasu/sight.wav");
	precache_sound (SOUND_EMPTY);
	precache_sound ("redfield/karasu/death.wav");
	precache_sound ("redfield/karasu/armor1.wav");
	precache_sound ("redfield/karasu/armor2.wav");
	precache_sound ("redfield/karasu/armor3.wav");
	precache_sound ("redfield/karasu/armor4.wav");
	precache_sound ("redfield/karasu/armor5.wav");
};

// QUAKED monster_karasu (1 0 0) (-16 -16 -24) (16 16 40) Ambush
void() monster_karasu = {
	if (deathmatch) { remove(self); return; }

	self.mdl = "progs/redfield/mon_karasu.mdl";			// Lord Karasu with skins for each attack
	self.idle_sound = "redfield/karasu/idle.wav";
	self.sight_sound = "redfield/karasu/sight.wav";
	self.pain_sound = SOUND_EMPTY;	
	self.death_sound = "redfield/karasu/death.wav";
	self.solid = SOLID_NOT;					// No interaction with world
	self.movetype = MOVETYPE_NONE;			// Static item, no movement
	if (self.bboxtype < 1) self.bboxtype = BBOX_TALL;
	if (self.health < 1) self.health = 1800;
	self.gibhealth = MON_NEVERGIB;			// Cannot be gibbed by weapons
	self.gibbed = FALSE;					// Still in one piece
	self.pain_flinch = 200;					// Highpain threshold
	self.pain_timeout = 3;				// Very high pain tolerance
	self.pain_longanim = FALSE;		// cannot be stunned with Cursed Blade
	self.infightextra = 2;			// High damage to monsters
	self.blockudeath = TRUE;		// No player gib sound
	self.attack_offset = '21 0 25';		// Between hands			
	self.deathstring = " was taught a lesson by Lord Karasu\n";
	self.stepc1 = "redfield/karasu/armor1.wav"; // Custom feet sounds
	self.stepc2 = "redfield/karasu/armor2.wav";
	self.stepc3 = "redfield/karasu/armor3.wav";
	self.stepc4 = "redfield/karasu/armor4.wav";
	self.stepc5 = "redfield/karasu/armor5.wav";
	self.steptype = FS_TYPECUSTOM;
	Resist_ChangeType(self,-1); // Always reset Ammo Resistance to be consistent
	self.resist_rockets = self.resist_nails = 0.5; 
	self.reflectnails = TRUE;		// Reflect nail projectiles	
	self.th_checkattack = KarasuCheckAttack;
	self.th_stand = karasu_idleb1;
	self.th_walk = karasu_walk1;
	self.th_run = karasu_run1;
	self.th_melee = karasu_choosemelee;
	self.th_missile = karasu_choose_atk;
	self.th_pain = karasu_pain;
	self.th_die = karasu_die;
	self.classgroup = CG_BOSS;	
	self.classtype = CT_MONKARASU;
	self.classmove = MON_MOVEWALK;
	monster_start();
};

// QUAKED monster_karasu_spelltrig (0.75 0.25 1) (-32 -32 -8) (32 32 8) x
// Target for boss spell trigger
// -------- KEYS --------
// targetname : name of wave event (links to noise key on boss)
// target     : trigger name of adds to spawn
// -------- SPAWNFLAGS --------
// -------- NOTES --------
// Used to trigger events when Karasu starts a spell
void() monster_karasu_spelltrig = {
	self.classtype = CT_MONKARASUSPELL;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NONE;
	self.takedamage = DAMAGE_NO;
	setsize (self, VEC_ORIGIN, VEC_ORIGIN);
};