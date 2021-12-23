/*
=================================================================================

OGRE / ORGAN PLAYER - MadFox 5okt2020.

=================================================================================
*/

$cd /raid/quake/id1/models/ogre_c
$origin 0 -6 24
$base base		
$skin base

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9 stand10 stand11 stand12 stand13  
$frame stand14 stand15 stand16 stand17 stand18 stand19 stand20 stand21 stand22 stand23 stand24 stand25
$frame stand26 stand27 stand28 stand29 stand30 stand31 stand32 stand33 stand34 stand35 stand36 stand37  
$frame stand38 stand39 stand40 stand41 stand42 stand43 stand44 stand45 stand46 stand47 stand48 stand49
$frame stand50 stand51 stand52 stand53 stand54 stand55 stand56 stand57 stand58 stand59 stand60 stand61 
$frame stand62 stand63 stand64 stand65 stand66 stand67 stand68 stand69 stand70 stand71 stand72 stand73  
$frame stand74 stand75 stand76 stand77 stand78 stand79 stand80 stand81 stand82 stand83 stand84 stand85   
$frame stand86 stand87 stand88 stand89 stand90 stand91 stand92 stand93 stand94 stand95 stand96 stand97 
$frame stand98 stand99 stand100 stand101 stand102 stand103 stand104 stand105 stand106 stand107 stand108 
$frame stand109 stand110 stand111 stand112 stand113 stand114 stand115 stand116 stand117 stand118 stand119 
$frame stand120 stand121 stand122 stand123 stand124 stand125 stand126 stand127 stand128 stand129 stand130
$frame stand131 stand132 stand133 stand134 stand135 stand136 stand137 stand138  stand139 stand140 stand141
$frame stand142 stand143 stand144 stand145 stand146 stand147 stand148 stand149 stand150 stand151 stand152 
$frame stand153 

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16

$frame run1 run2 run3 run4 run5 run6 run7 run8 

$frame pain1 pain2 pain3 pain4 pain5

$frame atka1 atka2 atka3 atka4 atka5 atka6 atka7 atka8 atka9 atka10
$frame atka11 atka12 atka13 atka14 

$frame atkb1 atkb2 atkb3 atkb4 atkb5 atkb6 atkb7 atkb8 atkb9 atkb10
$frame atkb11 atkb12 atkb13 atkb14 

$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8 fly9 fly10
$frame fly11 fly12 fly13 fly14 fly15

void() Orqu_idlesound =
{
	{
	 		sound (self, CHAN_VOICE, "orquel/sabre01.wav", 1,  ATTN_IDLE);
	}
	return;
};

//================================================================================

void()	orga_stand1	=[	$stand1,  	orga_stand2	] {ai_stand();};
void()	orga_stand2	=[	$stand2,  	orga_stand3	] {ai_stand();};
void()	orga_stand3	=[	$stand3,  	orga_stand4	] {ai_stand();};
void()	orga_stand4	=[	$stand4,  	orga_stand5	] {ai_stand();};
void()	orga_stand5	=[	$stand5,  	orga_stand6	] {ai_stand();};
void()	orga_stand6	=[	$stand6,  	orga_stand7	] {ai_stand();};
void()	orga_stand7	=[	$stand7,  	orga_stand8	] {ai_stand();};
void()	orga_stand8	=[	$stand8,  	orga_stand9	] {ai_stand();};
void()	orga_stand9	=[	$stand9,  	orga_stand10	] {ai_stand();};
void()	orga_stand10	=[	$stand10, 	orga_stand11	] {ai_stand();};
void()	orga_stand11	=[	$stand11, 	orga_stand12	] {ai_stand();};
void()	orga_stand12	=[	$stand12, 	orga_stand13	] {ai_stand();};
void()	orga_stand13	=[	$stand13, 	orga_stand14	] {ai_stand();};
void()	orga_stand14	=[	$stand14, 	orga_stand15	] {ai_stand();};
void()	orga_stand15	=[	$stand15, 	orga_stand16	] 
{
if (random() < 0.2)
		sound (self, CHAN_VOICE, "orquel/sabre01.wav", 1, ATTN_IDLE);
	ai_stand();
};
void()	orga_stand16	=[	$stand16, 	orga_stand17	] {ai_stand();};
void()	orga_stand17	=[	$stand17,  	orga_stand18	] {ai_stand();};
void()	orga_stand18	=[	$stand18,  	orga_stand19	] {ai_stand();};
void()	orga_stand19	=[	$stand19,  	orga_stand20	] {ai_stand();};
void()	orga_stand20	=[	$stand20, 	orga_stand21	] {ai_stand();};
void()	orga_stand21	=[	$stand21,  	orga_stand22	] {ai_stand();};
void()	orga_stand22	=[	$stand22,  	orga_stand23	] {ai_stand();};
void()	orga_stand23	=[	$stand23,  	orga_stand24	] {ai_stand();};
void()	orga_stand24	=[	$stand24,  	orga_stand25	] {ai_stand();};
void()	orga_stand25	=[	$stand25,  	orga_stand26	] {ai_stand();};
void()	orga_stand26	=[	$stand26,  	orga_stand27	] {ai_stand();};
void()	orga_stand27	=[	$stand27,  	orga_stand28	] {ai_stand();};
void()	orga_stand28	=[	$stand28,  	orga_stand29	] {ai_stand();};
void()	orga_stand29	=[	$stand29,  	orga_stand30	] {ai_stand();};
void()	orga_stand30	=[	$stand30, 	orga_stand31	] {ai_stand();};
void()	orga_stand31	=[	$stand31, 	orga_stand32	] {ai_stand();};
void()	orga_stand32	=[	$stand32, 	orga_stand33	] {ai_stand();};
void()	orga_stand33	=[	$stand33, 	orga_stand34	] {ai_stand();};
void()	orga_stand34	=[	$stand34, 	orga_stand35	] {ai_stand();};
void()	orga_stand35	=[	$stand35, 	orga_stand36	] {ai_stand();};
void()	orga_stand36	=[	$stand36, 	orga_stand37	] {ai_stand();};
void()	orga_stand37	=[	$stand37,  	orga_stand38	] {ai_stand();};
void()	orga_stand38	=[	$stand38,  	orga_stand39	] {ai_stand();};
void()	orga_stand39	=[	$stand39,  	orga_stand40	] {ai_stand();};
void()	orga_stand40	=[	$stand40, 	orga_stand41	] {ai_stand();};
void()	orga_stand41	=[	$stand41, 	orga_stand42	] {ai_stand();};
void()	orga_stand42	=[	$stand42, 	orga_stand43	] {ai_stand();};
void()	orga_stand43	=[	$stand43, 	orga_stand44	] {ai_stand();};
void()	orga_stand44	=[	$stand44, 	orga_stand45	] {ai_stand();};
void()	orga_stand45	=[	$stand45, 	orga_stand46	] {ai_stand();};
void()	orga_stand46	=[	$stand46, 	orga_stand47	] {ai_stand();};
void()	orga_stand47	=[	$stand47,  	orga_stand48	] {ai_stand();};
void()	orga_stand48	=[	$stand48,  	orga_stand49	] {ai_stand();};
void()	orga_stand49	=[	$stand49,  	orga_stand50	] {ai_stand();};
void()	orga_stand50	=[	$stand50, 	orga_stand51	] {ai_stand();};
void()	orga_stand51	=[	$stand51,  	orga_stand52	] {ai_stand();};
void()	orga_stand52	=[	$stand52,  	orga_stand53	] {ai_stand();};
void()	orga_stand53	=[	$stand53,  	orga_stand54	] {ai_stand();};
void()	orga_stand54	=[	$stand54,  	orga_stand55	] {ai_stand();};
void()	orga_stand55	=[	$stand55,  	orga_stand56	] {ai_stand();};
void()	orga_stand56	=[	$stand56,  	orga_stand57	] {ai_stand();};
void()	orga_stand57	=[	$stand57,  	orga_stand58	] {ai_stand();};
void()	orga_stand58	=[	$stand58,  	orga_stand59	] {ai_stand();};
void()	orga_stand59	=[	$stand59,  	orga_stand60	] {ai_stand();};
void()	orga_stand60	=[	$stand60, 	orga_stand61	] {ai_stand();};
void()	orga_stand61	=[	$stand61, 	orga_stand62	] {ai_stand();};
void()	orga_stand62	=[	$stand62, 	orga_stand63	] {ai_stand();};
void()	orga_stand63	=[	$stand63, 	orga_stand64	] {ai_stand();};
void()	orga_stand64	=[	$stand64, 	orga_stand65	] {ai_stand();};
void()	orga_stand65	=[	$stand65, 	orga_stand66	] {ai_stand();};
void()	orga_stand66	=[	$stand66, 	orga_stand67	] {ai_stand();};
void()	orga_stand67	=[	$stand67,  	orga_stand68	] {ai_stand();};
void()	orga_stand68	=[	$stand68,  	orga_stand69	] {ai_stand();};
void()	orga_stand69	=[	$stand69,  	orga_stand70	] {ai_stand();};
void()	orga_stand70	=[	$stand70, 	orga_stand71	] {ai_stand();};
void()	orga_stand71	=[	$stand71, 	orga_stand72	] {ai_stand();};
void()	orga_stand72	=[	$stand72, 	orga_stand73	] {ai_stand();};
void()	orga_stand73	=[	$stand73, 	orga_stand74	] {ai_stand();};
void()	orga_stand74	=[	$stand74, 	orga_stand75	] {ai_stand();};
void()	orga_stand75	=[	$stand75, 	orga_stand76	] {ai_stand();};
void()	orga_stand76	=[	$stand76, 	orga_stand77	] {ai_stand();};
void()	orga_stand77	=[	$stand77,  	orga_stand78	] {ai_stand();};
void()	orga_stand78	=[	$stand78,  	orga_stand79	] {ai_stand();};
void()	orga_stand79	=[	$stand79,  	orga_stand80	] {ai_stand();};
void()	orga_stand80	=[	$stand80, 	orga_stand81	] {ai_stand();};
void()	orga_stand81	=[	$stand81,  	orga_stand82	] {ai_stand();};
void()	orga_stand82	=[	$stand82,  	orga_stand83	] {ai_stand();};
void()	orga_stand83	=[	$stand83,  	orga_stand84	] {ai_stand();};
void()	orga_stand84	=[	$stand84,  	orga_stand85	] {ai_stand();};
void()	orga_stand85	=[	$stand85,  	orga_stand86	] {ai_stand();};
void()	orga_stand86	=[	$stand86,  	orga_stand87	] {ai_stand();};
void()	orga_stand87	=[	$stand87,  	orga_stand88	] {ai_stand();};
void()	orga_stand88	=[	$stand88,  	orga_stand89	] {ai_stand();};
void()	orga_stand89	=[	$stand89,  	orga_stand90	] {ai_stand();};
void()	orga_stand90	=[	$stand90, 	orga_stand91	] {ai_stand();};
void()	orga_stand91	=[	$stand91, 	orga_stand92	] {ai_stand();};
void()	orga_stand92	=[	$stand92, 	orga_stand93	] {ai_stand();};
void()	orga_stand93	=[	$stand93, 	orga_stand94	] {ai_stand();};
void()	orga_stand94	=[	$stand94, 	orga_stand95	] {ai_stand();};
void()	orga_stand95	=[	$stand95, 	orga_stand96	] {ai_stand();};
void()	orga_stand96	=[	$stand96, 	orga_stand97	] {ai_stand();};
void()	orga_stand97	=[	$stand97,  	orga_stand98	] {ai_stand();};
void()	orga_stand98	=[	$stand98,  	orga_stand99	] {ai_stand();};
void()	orga_stand99	=[	$stand99,  	orga_stand100	] {ai_stand();};
void()	orga_stand100	=[	$stand100, 	orga_stand101	] {ai_stand();};
void()	orga_stand101	=[	$stand101, 	orga_stand102	] {ai_stand();};
void()	orga_stand102	=[	$stand102, 	orga_stand103	] {ai_stand();};
void()	orga_stand103	=[	$stand103, 	orga_stand104	] {ai_stand();};
void()	orga_stand104	=[	$stand104, 	orga_stand105	] {ai_stand();};
void()	orga_stand105	=[	$stand105, 	orga_stand106	] {ai_stand();};
void()	orga_stand106	=[	$stand106, 	orga_stand107	] {ai_stand();};
void()	orga_stand107	=[	$stand107,  	orga_stand108	] {ai_stand();};
void()	orga_stand108	=[	$stand108,  	orga_stand109	] {ai_stand();};
void()	orga_stand109	=[	$stand109,  	orga_stand110	] {ai_stand();};
void()	orga_stand110	=[	$stand110, 	orga_stand111	] {ai_stand();};
void()	orga_stand111	=[	$stand111,  	orga_stand112	] {ai_stand();};
void()	orga_stand112	=[	$stand112,  	orga_stand113	] {ai_stand();};
void()	orga_stand113	=[	$stand113,  	orga_stand114	] {ai_stand();};
void()	orga_stand114	=[	$stand114,  	orga_stand115	] {ai_stand();};
void()	orga_stand115	=[	$stand115,  	orga_stand116	] {ai_stand();};
void()	orga_stand116	=[	$stand116,  	orga_stand117	] {ai_stand();};
void()	orga_stand117	=[	$stand117,  	orga_stand118	] {ai_stand();};
void()	orga_stand118	=[	$stand118,  	orga_stand119	] {ai_stand();};
void()	orga_stand119	=[	$stand119,  	orga_stand120	] {ai_stand();};
void()	orga_stand120	=[	$stand120, 	orga_stand121	] {ai_stand();};
void()	orga_stand121	=[	$stand121, 	orga_stand122	] {ai_stand();};
void()	orga_stand122	=[	$stand122, 	orga_stand123	] {ai_stand();};
void()	orga_stand123	=[	$stand123, 	orga_stand124	] {ai_stand();};
void()	orga_stand124	=[	$stand124, 	orga_stand125	] {ai_stand();};
void()	orga_stand125	=[	$stand125, 	orga_stand126	] {ai_stand();};
void()	orga_stand126	=[	$stand126, 	orga_stand127	] {ai_stand();};
void()	orga_stand127	=[	$stand127,  	orga_stand128	] {ai_stand();};
void()	orga_stand128	=[	$stand128,  	orga_stand129	] {ai_stand();};
void()	orga_stand129	=[	$stand129,  	orga_stand130	] {ai_stand();};
void()	orga_stand130	=[	$stand130, 	orga_stand131	] {ai_stand();};
void()	orga_stand131	=[	$stand131, 	orga_stand132	] {ai_stand();};
void()	orga_stand132	=[	$stand132, 	orga_stand133	] {ai_stand();};
void()	orga_stand133	=[	$stand133, 	orga_stand134	] {ai_stand();};
void()	orga_stand134	=[	$stand134, 	orga_stand135	] {ai_stand();};
void()	orga_stand135	=[	$stand135, 	orga_stand136	] {ai_stand();};
void()	orga_stand136	=[	$stand136, 	orga_stand137	] {ai_stand();};
void()	orga_stand137	=[	$stand137,  	orga_stand138	] {ai_stand();};
void()	orga_stand138	=[	$stand138,  	orga_stand139	] {ai_stand();};
void()	orga_stand139	=[	$stand139,  	orga_stand140	] {ai_stand();};
void()	orga_stand140	=[	$stand140, 	orga_stand141	] {ai_stand();};
void()	orga_stand141	=[	$stand141,  	orga_stand142	] {ai_stand();};
void()	orga_stand142	=[	$stand142,  	orga_stand143	] {ai_stand();};
void()	orga_stand143	=[	$stand143,  	orga_stand144	] {ai_stand();};
void()	orga_stand144	=[	$stand144,  	orga_stand145	] {ai_stand();};
void()	orga_stand145	=[	$stand145,  	orga_stand146	] {ai_stand();};
void()	orga_stand146	=[	$stand146,  	orga_stand147	] {ai_stand();};
void()	orga_stand147	=[	$stand147,  	orga_stand148	] {ai_stand();};
void()	orga_stand148	=[	$stand148,  	orga_stand149	] {ai_stand();};
void()	orga_stand149	=[	$stand149,  	orga_stand150	] {ai_stand();};
void()	orga_stand150	=[	$stand150, 	orga_stand151	] {ai_stand();};
void()	orga_stand151	=[	$stand151, 	orga_stand152	] {ai_stand();};
void()	orga_stand152	=[	$stand152, 	orga_stand153	] {ai_stand();};
void()	orga_stand153	=[	$stand153, 	orga_stand16	] {ai_stand();};

void()	orga_walk1	=[	$walk1,  	orga_walk2	] {ai_walk(0);};
void()	orga_walk2	=[	$walk2,  	orga_walk3	] {ai_walk(0);};
void()	orga_walk3	=[	$walk3,  	orga_walk4	] {ai_walk(0);};
void()	orga_walk4	=[	$walk4,  	orga_walk5	] {ai_walk(0);};
void()	orga_walk5	=[	$walk5,  	orga_walk6	] {ai_walk(0);};
void()	orga_walk6	=[	$walk6,  	orga_walk7	] {ai_walk(0);};
void()	orga_walk7	=[	$walk7,  	orga_walk8	] {ai_walk(0);};
void()	orga_walk8	=[	$walk8,  	orga_walk9	] {ai_walk(0);};
void()	orga_walk9	=[	$walk9,  	orga_walk10	] {ai_walk(0);};
void()	orga_walk10	=[	$walk10, 	orga_walk11	] {ai_walk(0);};
void()	orga_walk11	=[	$walk11, 	orga_walk12	] {ai_walk(0);};
void()	orga_walk12	=[	$walk12, 	orga_walk13	] {ai_walk(0);};
void()	orga_walk13	=[	$walk13, 	orga_walk14	] {ai_walk(0);};
void()	orga_walk14	=[	$walk14,  	orga_walk15	] {ai_walk(0);};
void()	orga_walk15	=[	$walk15,  	orga_walk16	] {ai_walk(0);};
void()	orga_walk16	=[	$walk16,  	orga_walk1	] {ai_walk(0);};

void()	orga_run1	=[	$run1, 	orga_run2	] {ai_run(2);};
void()	orga_run2	=[	$run2, 	orga_run3	] {ai_run(4);};
void()	orga_run3	=[	$run3, 	orga_run4	] {ai_run(6);};
void()	orga_run4	=[	$run4, 	orga_run5	] {ai_run(4);};
void()	orga_run5	=[	$run5, 	orga_run6	] {ai_run(2);};
void()	orga_run6	=[	$run6, 	orga_run7	] {ai_run(4);};
void()	orga_run7	=[	$run7, 	orga_run8	] {ai_run(6);};
void()	orga_run8	=[	$run8, 	orga_run1	] {ai_run(4);};

//==============================================================================

void()	orga_pain1	=[	$pain1,		orga_pain2	] {};
void()	orga_pain2	=[	$pain2,		orga_pain3	] {};
void()	orga_pain3	=[	$pain3,		orga_pain4	] {};
void()	orga_pain4	=[	$pain4,		orga_pain5	] {};
void()	orga_pain5	=[	$pain5,		orga_atk1	] {};

void(entity attacker, float damage)	orga_pain =
{
	if (self.pain_finished > time)
		return;

	sound (self, CHAN_VOICE, "ogre/idle1.wav", 1, ATTN_IDLE);		

	{
		orga_pain1 ();
		self.pain_finished = time + 0.1;
	}
};
//==============================================================================

void()	orga_atk1	=[	$atka1, 	orga_atk2	] {ai_face();};
void()	orga_atk2	=[	$atka2, 	orga_atk3	] {ai_face();};
void()	orga_atk3	=[	$atka3, 	orga_atk4	] {ai_face();};
void()	orga_atk4	=[	$atka4, 	orga_atk5	] {ai_face();};
void()	orga_atk5	=[	$atka5, 	orga_atk6	] 
{
if (random() < 0.2)
		sound (self, CHAN_VOICE, "harmon/half.wav", 1, ATTN_IDLE);
	ai_face(),ThrowGib ("progs/harm0.mdl");
};
void()	orga_atk6	=[	$atka6, 	orga_atk7	] {ai_face();};
void()	orga_atk7	=[	$atka7, 	orga_atk8	] {ai_face();};
void()	orga_atk8	=[	$atka8, 	orga_atk9	] {ai_face();};
void()	orga_atk9	=[	$atka9, 	orga_atk10	] {ai_face();};
void()	orga_atk10	=[	$atka10,	orga_atk11	] {ai_face();};
void()	orga_atk11	=[	$atka11,	orga_atk12	] {ai_face();};
void()	orga_atk12	=[	$atka12,	orga_atk13	] {ai_face();};
void()	orga_atk13	=[	$atka13,	orga_atk14	] {ai_face();};
void()	orga_atk14	=[	$atka14,	orga_atk1	] {ai_face();};
void()	orga_atkb1	=[	$atkb1, 	orga_atkb2	] {ai_face();};
void()	orga_atkb2	=[	$atkb2, 	orga_atkb3	] {ai_face();};
void()	orga_atkb3	=[	$atkb3, 	orga_atkb4	] {ai_face();};
void()	orga_atkb4	=[	$atkb4, 	orga_atkb5	] {ai_face();};
void()	orga_atkb5	=[	$atkb5, 	orga_atkb6	] {ai_face();};
void()	orga_atkb6	=[	$atkb6, 	orga_atkb7	] {ai_face();};
void()	orga_atkb7	=[	$atkb7, 	orga_atkb8	] {ai_face();};
void()	orga_atkb8	=[	$atkb8, 	orga_atkb9	] {ai_face();};
void()	orga_atkb9	=[	$atkb9, 	orga_atkb10	] {ai_face();};
void()	orga_atkb10	=[	$atkb10,	orga_atkb11	] {ai_face();};
void()	orga_atkb11	=[	$atkb11,	orga_atkb12	] {ai_face();};
void()	orga_atkb12	=[	$atkb12,	orga_atkb13	] {ai_face();};
void()	orga_atkb13	=[	$atkb13,	orga_atkb14	] {ai_face();};
void()	orga_atkb14	=[	$atkb14,	orga_run1	] {ai_face();};

//==============================================================================

void()	orga_fly1	=[	$fly1,  	orga_fly2	] {};
void()	orga_fly2	=[	$fly2,  	orga_fly3	] {};
void()	orga_fly3	=[	$fly3,  	orga_fly4	] {};
void()	orga_fly4	=[	$fly4,  	orga_fly5	] {};
void()	orga_fly5	=[	$fly5,  	orga_fly6	] {};
void()	orga_fly6	=[	$fly6,  	orga_fly7	] {};
void()	orga_fly7	=[	$fly7,  	orga_fly8	] {};
void()	orga_fly8	=[	$fly8,  	orga_fly9	] {};
void()	orga_fly9	=[	$fly9,  	orga_fly10	] {};
void()	orga_fly10	=[	$fly10, 	orga_fly11	] {};
void()	orga_fly11	=[	$fly11, 	orga_fly12	] {};
void()	orga_fly12	=[	$fly12, 	orga_fly13	] {};
void()	orga_fly13	=[	$fly13, 	orga_fly14	] {};
void()	orga_fly14	=[	$fly14, 	orga_fly15	] {};
void()	orga_fly15	=[	$fly15, 	orga_fly1	] {};

//==============================================================================

void() orga_melee =
{
	if (random() > 0.5)
		orga_atk1 ();
	else
		orga_atkb1 ();
};

//==============================================================================

/*QUAKED monster_orqulus (1 0 0) (-16 -16 -24) (16 16 40) Ambush*/
void() monster_orqulus =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	
	precache_model2 ("progs/orqules.mdl");
	precache_model2 ("progs/harm0.mdl");
	precache_model2 ("progs/harm1.mdl");
	precache_model2 ("progs/harm2.mdl");

	precache_sound ("orquel/sabre01.wav");
	precache_sound ("orquel/idle1.wav");
	precache_sound ("harmon/half.wav");
	
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/orqules.mdl");

	//gnounc
	self.netname = "orqulus";

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 80;
	self.max_health = 80;

	self.th_stand = orga_stand1;
	self.th_walk = orga_walk1;
	self.th_run = orga_run1;
	self.th_pain = orga_pain;
	self.th_die = orga_fly1;
	self.th_melee = orga_melee;
        self.th_missile = orga_atkb1;
	
	walkmonster_start();
};
