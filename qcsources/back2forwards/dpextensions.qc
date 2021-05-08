
//DarkPlaces supported extension list, draft version 1.04

//DP_GFX_SKINFILES
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//description:
//alias models (mdl, md2, md3) can have .skin files to replace conventional texture naming, these have a naming format such as:
//progs/test.mdl_0.skin
//progs/test.mdl_1.skin
//...
//these files contain replace commands (replace meshname shadername), example:
//replace "helmet" "progs/test/helmet1.tga"
//replace "teamstripes" "progs/test/redstripes.tga"
//replace "visor" "common/nodraw"
//any names that are not replaced are automatically show up as a grey checkerboard to indicate the error status, and "common/nodraw" is a special case that is invisible.
//this feature is intended to allow multiple skin sets on md3 models (which otherwise only have one skin set).
//other commands might be added someday but it is not expected.

//DP_GFX_QUAKE3MODELTAGS
//idea: id Software
//darkplaces implementation: LordHavoc
//field definitions:
.entity tag_entity; // entity this is attached to (call setattachment to set this)
.float tag_index; // which tag on that entity (0 is relative to the entity, > 0 is an index into the tags on the model if it has any) (call setattachment to set this)
//builtin definitions:
void(entity e, entity tagentity, string tagname) setattachment = #443; // attachs e to a tag on tagentity (note: use "" to attach to entity origin/angles instead of a tag)
//description:
//allows entities to be visually attached to model tags (which follow animations perfectly) on other entities, for example attaching a weapon to a player's hand, or upper body attached to lower body, allowing it to change angles and frame separately (note: origin and angles are relative to the tag, use '0 0 0' for both if you want it to follow exactly, this is similar to viewmodelforclient's behavior).
//note 2: if the tag is not found, it defaults to "" (attach to origin/angles of entity)
//note 3: attaching to world turns off attachment
//note 4: the entity that this is attached to must be visible for this to work

//DP_QC_BOTCLIENT
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
// FIXME: these need numbers assigned, and they need to be added to the engine!
//entity() spawnclient = #; // like spawn but for client slots (also calls relevant connect/spawn functions), returns world if no clients available
//void(entity e) removeclient = #; // like remove but for client slots (also calls relevant disconnect functions)
//description:
//functions to allow bots to use client slots with no hacks, some notes:
.string netname; //controls name on scoreboard (so be sure to set it for a bot)
.float frags; //controls score on scoreboard (this is expected)
.float clientcolors; //controls coloring on scoreboard (this determines player colors exactly like the "color" command, except for using a single number that contains pants and shirt colors (pants + shirt * 16, 0-255 potentially), so be sure to set it for a bot)
//note also that these fields can be set on a real client to change the relevant settings.
//see also DP_SV_SETCOLOR extension for another way to manipulate clientcolors (made obsolete by this extension).

//unassigned stuff:  (need to write up specs but haven't yet)
.vector punchvector; // DP_SV_PUNCHVECTOR
.float  ping; // DP_SV_PING

//checkextension function
//idea: expected by almost everyone
//darkplaces implementation: LordHavoc
float(string s) checkextension = #99;
//description: check if (cvar("pr_checkextension")) before calling this, this is the only guarenteed extension to be present in the extension system, it allows you to check if an extension is available, by name, to check for an extension use code like this:
//// (it is recommended this code be placed in worldspawn or a worldspawn called function somewhere)
//if (cvar("pr_checkextension"))
//if (checkextension("DP_SV_SETCOLOR"))
//	ext_setcolor = TRUE;
//from then on you can check ext_setcolor to know if that extension is available

// LordHavoc: HIGHLY experimental, do not implement this in other engines
//DP_CGAME
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//SVC definitions:
float svc_cgame = 50; // [short] length [bytes] data
//description:
//contains network messages to client gamecode.

//DP_CL_LOADSKY
//idea: Nehahra, LordHavoc
//darkplaces implementation: LordHavoc
//client console commands:
//"loadsky" (parameters: "basename", example: "mtnsun_" would load "mtnsun_up.tga" and "mtnsun_rt.tga" and similar names, use "" to revert to quake sky, note: this is the same as Quake2 skybox naming)
//description:
//sets global skybox for the map for this client (can be stuffed to a client by QC), does not hurt much to repeatedly execute this command, please don't use this in mods if it can be avoided (only if changing skybox is REALLY needed, otherwise please use DP_GFX_SKYBOX).

//DP_EF_ADDITIVE
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//effects bit:
float   EF_ADDITIVE     = 32;
//description:
//additive blending when this object is rendered

//DP_EF_BLUE
//idea: id Software
//darkplaces implementation: LordHavoc
//effects bit:
float   EF_BLUE         = 64;
//description:
//entity emits blue light (used for quad)

//DP_EF_FLAME
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//effects bit:
float   EF_FLAME        = 1024;
//description:
//entity is on fire

//DP_EF_FULLBRIGHT
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//effects bit:
float   EF_FULLBRIGHT   = 512;
//description:
//entity is always brightly lit

//DP_EF_NODRAW
//idea: id Software
//darkplaces implementation: LordHavoc
//effects bit:
float   EF_NODRAW       = 16;
//description:
//prevents server from sending entity to client (forced invisible, even if it would have been a light source or other such things)

//DP_EF_RED
//idea: id Software
//darkplaces implementation: LordHavoc
//effects bit:
float   EF_RED          = 128;
//description:
//entity emits red light (used for invulnerability)

//DP_EF_STARDUST
//idea: MythWorks Inc
//darkplaces implementation: LordHavoc
//effects bit:
float   EF_STARDUST     = 2048;
//description:
//entity emits bouncing sparkles in every direction

//entity attributes used for rendering/networking:
//idea: Nehahra
//darkplaces implementation: LordHavoc
//DP_ENT_ALPHA
//field definition:
.float alpha;
//description:
//controls opacity of the entity, 0.0 is forced to be 1.0 (otherwise everything would be invisible), use -1 if you want to make something invisible, 1.0 is solid (like normal).

/*
//NOTE: no longer supported by darkplaces because no one used it
//DP_ENT_COLORMOD // no longer supported
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//field definition:
.vector colormod;
//description:
//controls color of the entity, '0 0 0', is forced to be '1 1 1' (otherwise everything would be black), used for tinting objects, for instance using '1 0.6 0.4' on an ogre would give you an orange ogre (order is red green blue).
*/

//DP_ENT_CUSTOMCOLORMAP
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//description:
//if .colormap is set to 1024 + pants + shirt * 16, those colors will be used for colormapping the entity, rather than looking up a colormap by player number.

/*
//NOTE: no longer supported by darkplaces because all entities are delta compressed now
//DP_ENT_DELTACOMPRESS // no longer supported
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//effects bit:
float EF_DELTA = 8388608;
//description:
//(obsolete) applies delta compression to the network updates of the entity, making updates smaller, this might cause some unreliable behavior in packet loss situations, so it should only be used on numerous (nails/plasma shots/etc) or unimportant objects (gibs/shell casings/bullet holes/etc).
*/

//DP_ENT_EXTERIORMODELTOCLIENT
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//fields:
.entity exteriormodeltoclient;
//description:
//the entity is visible to all clients with one exception: if the specified client is using first person view (not using chase_active) the entity will not be shown.

//DP_ENT_GLOW
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//field definitions:
.float glow_color;
.float glow_size;
.float glow_trail;
//description:
//customizable glowing light effect on the entity, glow_color is a paletted (8bit) color in the range 0-255 (note: 0 and 254 are white), glow_size is 0 or higher (up to the engine what limit to cap it to, darkplaces imposes a 1020 limit), if glow_trail is true it will leave a trail of particles of the same color as the light.

//DP_ENT_LOWPRECISION
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//effects bit:
float EF_LOWPRECISION = 4194304;
//description:
//uses low quality origin coordinates, reducing network traffic compared to the default high precision, intended for numerous objects (projectiles/gibs/bullet holes/etc).

//DP_ENT_SCALE
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//field definitions:
.float scale;
//description:
//controls rendering scale of the object, 0 is forced to be 1, darkplaces uses 1/16th accuracy and a limit of 15.9375, can be used to make an object larger or smaller.

//DP_ENT_VIEWMODEL
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//field definitions:
.entity viewmodelforclient;
//description:
//this is a very special capability, attachs the entity to the view of the client specified, origin and angles become relative to the view of that client, all effects can be used (multiple skins on a weapon model etc)...  the entity is not visible to any other client.

//DP_GFX_FOG
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//worldspawn fields:
//"fog" (parameters: "density red green blue", example: "0.1 0.3 0.3 0.3")
//description:
//global fog for the map, can not be changed by QC

//DP_GFX_SKYBOX
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//worldspawn fields:
//"sky" (parameters: "basename", example: "mtnsun_" would load "mtnsun_up.tga" and "mtnsun_rt.tga" and similar names, note: "sky" is also used the same way by Quake2)
//description:
//global skybox for the map, can not be changed by QC

//DP_GFX_EXTERNALTEXTURES
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//description:
//loads external textures found in various directories (tenebrae compatible)...
/*
in all examples .tga is merely the base texture, it can be any of these:
.tga (base texture)
_glow.tga (fullbrights or other glowing overlay stuff, NOTE: this is done using additive blend, not alpha)
_pants.tga (pants overlay for colormapping on models, this should be shades of grey (it is tinted by pants color) and black wherever the base texture is not black, as this is an additive blend)
_shirt.tga (same idea as pants, but for shirt color)
_diffuse.tga (this may be used instead of base texture for per pixel lighting)
_gloss.tga (specular texture for per pixel lighting, note this can be in color (tenebrae only supports greyscale))
_norm.tga (normalmap texture for per pixel lighting)
_bump.tga (bumpmap, converted to normalmap at load time, supported only for reasons of tenebrae compatibility)
_luma.tga (same as _glow but supported only for reasons of tenebrae compatibility)

due to glquake's incomplete Targa(r) loader, this section describes
required Targa(r) features support:
types:
type 1 (uncompressed 8bit paletted with 24bit/32bit palette)
type 2 (uncompressed 24bit/32bit true color, glquake supported this)
type 3 (uncompressed 8bit greyscale)
type 9 (RLE compressed 8bit paletted with 24bit/32bit palette)
type 10 (RLE compressed 24bit/32bit true color, glquake supported this)
type 11 (RLE compressed 8bit greyscale)
attribute bit 0x20 (Origin At Top Left, top to bottom, left to right)

image formats guarenteed to be supported: tga, pcx, lmp
image formats that are optional: png, jpg

mdl/spr/spr32 examples:
skins are named _A (A being a number) and skingroups are named like _A_B
these act as suffixes on the model name...
example names for skin _2_1 of model "progs/armor.mdl":
game/override/progs/armor.mdl_2_1.tga
game/textures/progs/armor.mdl_2_1.tga
game/progs/armor.mdl_2_1.tga
example names for skin _0 of the model "progs/armor.mdl":
game/override/progs/armor.mdl_0.tga
game/textures/progs/armor.mdl_0.tga
game/progs/armor.mdl_0.tga
note that there can be more skins files (of the _0 naming) than the mdl
contains, this is only useful to save space in the .mdl file if classic quake
compatibility is not a concern.

bsp/md2/md3 examples:
example names for the texture "quake" of model "maps/start.bsp":
game/override/quake.tga
game/textures/quake.tga
game/progs/quake.tga

sbar/menu/console textures: for example the texture "conchars" (console font) in gfx.wad
game/override/gfx/conchars.tga
game/textures/gfx/conchars.tga
game/gfx/conchars.tga
*/

//DP_HALFLIFE_MAP
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//description:
//simply indicates that the engine supports HalfLife maps (BSP version 30, NOT the QER RGBA ones which are also version 30).

//DP_HALFLIFE_MAP_CVAR
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//cvars:
//halflifebsp 0/1
//description:
//engine sets this cvar when loading a map to indicate if it is halflife format or not.

//DP_INPUTBUTTONS
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//field definitions:
.float button3;
.float button4;
.float button5;
.float button6;
.float button7;
.float button8;
//description:
//set to the state of the +button3, +button4, +button5, +button6, +button7, and +button8 buttons from the client, this does not involve protocol changes (the extra 6 button bits were simply not used).

//DP_MONSTERWALK
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//description:
//MOVETYPE_WALK is permitted on non-clients, so bots can move smoothly, run off ledges, etc, just like a real player.

//DP_MOVETYPEBOUNCEMISSILE
//idea: id Software
//darkplaces implementation: id Software
//movetype definitions:
// float MOVETYPE_BOUNCEMISSILE = 11;
//description:
//MOVETYPE_BOUNCE but without gravity, and with full reflection (no speed loss like grenades have), in other words - bouncing laser bolts.

//DP_MOVETYPEFOLLOW
//idea: id Software, LordHavoc (redesigned)
//darkplaces implementation: LordHavoc
//movetype definitions:
float MOVETYPE_FOLLOW = 12;
//description:
//MOVETYPE_FOLLOW implemented, this uses existing entity fields in unusual ways:
//aiment - the entity this is attached to.
//punchangle - the original angles when the follow began.
//view_ofs - the relative origin (note that this is un-rotated by punchangle, and that is actually the only purpose of punchangle).
//v_angle - the relative angles.
//here's an example of how you would set a bullet hole sprite to follow a bmodel it was created on, even if the bmodel rotates:
//hole.movetype = MOVETYPE_FOLLOW; // make the hole follow
//hole.solid = SOLID_NOT; // MOVETYPE_FOLLOW is always non-solid
//hole.aiment = bmodel; // make the hole follow bmodel
//hole.punchangle = bmodel.angles; // the original angles of bmodel
//hole.view_ofs = hole.origin - bmodel.origin; // relative origin
//hole.v_angle = hole.angles - bmodel.angles; // relative angles

//DP_QC_CHANGEPITCH
//idea: id Software
//darkplaces implementation: id Software
//field definitions:
.float idealpitch;
.float pitch_speed;
//builtin definitions:
void(entity ent) changepitch = #63;
//description:
//equivilant to changeyaw, ent is normally self. (this was a Q2 builtin)

//DP_QC_COPYENTITY
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
void(entity from, entity to) copyentity = #400;
//description:
//copies all data in the entity to another entity.

//DP_QC_ETOS
//idea: id Software
//darkplaces implementation: id Software
//builtin definitions:
string(entity ent) etos = #65;
//description:
//lists all of the entity's fields into a string (similar to edict command in console). (this was a Q2 builtin)

//DP_QC_FINDCHAIN
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
entity(.string fld, string match) findchain = #402;
//description:
//similar to find() but returns a chain of entities like findradius.

//DP_QC_FINDCHAINFLOAT
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
entity(.entity fld, entity match) findchainentity = #403;
entity(.float fld, float match) findchainfloat = #403;
//description:
//similar to findentity()/findfloat() but returns a chain of entities like findradius.

//DP_QC_FINDFLOAT
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
entity(entity start, .entity fld, entity match) findentity = #98;
entity(entity start, .float fld, float match) findfloat = #98;
//description:
//finds an entity or float field value, similar to find(), but for entity and float fields.

//DP_QC_GETLIGHT
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
vector(vector org) getlight = #92;
//description:
//returns the lighting at the requested location (in color), 0-255 range (can exceed 255).

//DP_QC_GETSURFACE
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
float(entity e, float s) getsurfacenumpoints = #434;
vector(entity e, float s, float n) getsurfacepoint = #435;
vector(entity e, float s) getsurfacenormal = #436;
string(entity e, float s) getsurfacetexture = #437;
float(entity e, vector p) getsurfacenearpoint = #438;
vector(entity e, float s, vector p) getsurfaceclippedpoint = #439;
//description:
//functions to query surface information.

//DP_QC_MINMAXBOUND
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
float(float a, float b) min = #94;
float(float a, float b, float c) min3 = #94;
float(float a, float b, float c, float d) min4 = #94;
float(float a, float b, float c, float d, float e) min5 = #94;
float(float a, float b, float c, float d, float e, float f) min6 = #94;
float(float a, float b, float c, float d, float e, float f, float g) min7 = #94;
float(float a, float b, float c, float d, float e, float f, float g, float h) min8 = #94;
float(float a, float b) max = #95;
float(float a, float b, float c) max3 = #95;
float(float a, float b, float c, float d) max4 = #95;
float(float a, float b, float c, float d, float e) max5 = #95;
float(float a, float b, float c, float d, float e, float f) max6 = #95;
float(float a, float b, float c, float d, float e, float f, float g) max7 = #95;
float(float a, float b, float c, float d, float e, float f, float g, float h) max8 = #95;
float(float minimum, float val, float maximum) bound = #96;
//description:
//min returns the lowest of all the supplied numbers.
//max returns the highest of all the supplied numbers.
//bound clamps the value to the range and returns it.

//DP_QC_RANDOMVEC
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
vector() randomvec = #91;
//description:
//returns a vector of length < 1, much quicker version of this QC: do {v_x = random();v_y = random();v_z = random();} while(vlen(v) > 1)

//DP_QC_SINCOSSQRTPOW
//idea: id Software, LordHavoc
//darkplaces implementation: id Software, LordHavoc
//builtin definitions:
float(float val) sin = #60;
float(float val) cos = #61;
float(float val) sqrt = #62;
float(float a, float b) pow = #97;
//description:
//useful math functions, sine of val, cosine of val, square root of val, and raise a to power b, respectively.

//DP_QC_TRACEBOX
//idea: id Software
//darkplaces implementation: id Software
//builtin definitions:
void(vector v1, vector min, vector max, vector v2, float nomonsters, entity forent) tracebox = #90;
//description:
//similar to traceline but much more useful, traces a box of the size specified (technical note: currently the hull size can only be one of the sizes used in the map for bmodel collisions, entity collisions will pay attention to the exact size specified however, this is a collision code limitation in quake itself, and will be fixed eventually).

//DP_QC_TRACETOSS
//idea: id Software
//darkplaces implementation: id Software
//builtin definitions:
void(entity ent, entity ignore) tracetoss = #64;
//description:
//simulates movement of the entity as if it is MOVETYPE_TOSS and starting with it's current state (location, velocity, etc), returns relevant trace_ variables (trace_fraction is always 0, all other values are supported - trace_ent, trace_endpos, trace_plane_normal), does not actually alter the entity.

//DP_QC_VECTORVECTORS
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
void(vector dir) vectorvectors = #432;
//description:
//creates v_forward, v_right, and v_up vectors given a forward vector, similar to makevectors except it takes a forward direction vector instead of angles.

//DP_QUAKE2_MODEL
//idea: quake community
//darkplaces implementation: LordHavoc
//description:
//shows that the engine supports Quake2 .md2 files.

//DP_QUAKE3_MODEL
//idea: quake community
//darkplaces implementation: LordHavoc
//description:
//shows that the engine supports Quake3 .md3 files.

//DP_REGISTERCVAR
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
float(string name, string value) registercvar = #93;
//description:
//adds a new console cvar to the server console (in singleplayer this is the player's console), the cvar exists until the mod is unloaded or the game quits.

//DP_SOLIDCORPSE
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//solid definitions:
float SOLID_CORPSE = 5;
//description:
//the entity will not collide with SOLID_CORPSE and SOLID_SLIDEBOX entities (and likewise they will not collide with it), this is useful if you want dead bodies that are shootable but do not obstruct movement by players and monsters, note that if you traceline with a SOLID_SLIDEBOX entity as the ignoreent, it will ignore SOLID_CORPSE entities, this is desirable for visibility and movement traces, but not for bullets, for the traceline to hit SOLID_CORPSE you must temporarily force the player (or whatever) to SOLID_BBOX and then restore to SOLID_SLIDEBOX after the traceline.

//DP_SPRITE32
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//description:
//the engine supports .spr32 sprites.

//DP_SV_CLIENTCOLORS
//idea: LordHavoc
//darkplaces implementation: LordHavoc
.float clientcolors; // colors of the client (format: pants + shirt * 16)
//description:
//allows qc to read and modify the client colors associated with a client entity (not particularly useful on other entities), and automatically sends out any appropriate network updates if changed

//DP_SV_CLIENTNAME
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//allows qc to modify the client's .netname, and automatically sends out any appropriate network updates if changed

//DP_SV_DRAWONLYTOCLIENT
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//field definitions:
.entity drawonlytoclient;
//description:
//the entity is only visible to the specified client.

//DP_SV_EFFECT
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
void(vector org, string modelname, float startframe, float endframe, float framerate) effect = #404;
//SVC definitions:
//float svc_effect = #52; // [vector] org [byte] modelindex [byte] startframe [byte] framecount [byte] framerate
//float svc_effect2 = #53; // [vector] org [short] modelindex [byte] startframe [byte] framecount [byte] framerate
//description:
//clientside playback of simple custom sprite effects (explosion sprites, etc).

//DP_SV_NODRAWTOCLIENT
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//field definitions:
.entity nodrawtoclient;
//description:
//the entity is not visible to the specified client.

//DP_SV_PLAYERPHYSICS
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//field definitions:
.vector movement;
//engine-called QC prototypes:
//void() SV_PlayerPhysics;
//description:
//.movement vector contains the movement input from the player, allowing QC to do as it wishs with the input, and SV_PlayerPhysics will completely replace the player physics if present (works for all MOVETYPE's), see darkplaces mod source for example of this function (in playermovement.qc, adds HalfLife ladders support, as well as acceleration/deceleration while airborn (rather than the quake sudden-stop while airborn), and simplifies the physics a bit)

//DP_SV_SETCOLOR
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
void(entity ent, float colors) setcolor = #401;
//engine called QC functions (optional):
//void(float color) SV_ChangeTeam;
//description:
//setcolor sets the color on a client and updates internal color information accordingly (equivilant to stuffing a "color" command but immediate)
//SV_ChangeTeam is called by the engine whenever a "color" command is recieved, it may decide to do anything it pleases with the color passed by the client, including rejecting it (by doing nothing), or calling setcolor to apply it, preventing team changes is one use for this.
//the color format is pants + shirt * 16 (0-255 potentially)

//DP_SV_SLOWMO
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//cvars:
//"slowmo" (0+, default 1)
//description:
//sets the time scale of the server, mainly intended for use in singleplayer by the player, however potentially useful for mods, so here's an extension for it.
//range is 0 to infinite, recommended values to try are 0.1 (very slow, 10% speed), 1 (normal speed), 5 (500% speed).

//DP_TE_BLOOD
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
void(vector org, vector velocity, float howmany) te_blood = #405;
//temp entity definitions:
float TE_BLOOD = 50;
//protocol:
//vector origin
//byte xvelocity (-128 to +127)
//byte yvelocity (-128 to +127)
//byte zvelocity (-128 to +127)
//byte count (0 to 255, how much blood)
//description:
//creates a blood effect.

//DP_TE_BLOODSHOWER
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
void(vector mincorner, vector maxcorner, float explosionspeed, float howmany) te_bloodshower = #406;
//temp entity definitions:
//float TE_BLOODSHOWER = 52;
//protocol:
//vector mins (minimum corner of the cube)
//vector maxs (maximum corner of the cube)
//coord explosionspeed (velocity of blood particles flying out of the center)
//short count (number of blood particles)
//description:
//creates an exploding shower of blood, for making gibbings more convincing.

//DP_TE_CUSTOMFLASH
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
void(vector org, float radius, float lifetime, vector color) te_customflash = #417;
//temp entity definitions:
//float TE_CUSTOMFLASH = 73;
//protocol:
//vector origin
//byte radius ((MSG_ReadByte() + 1) * 8, meaning 8-2048 unit radius)
//byte lifetime ((MSG_ReadByte() + 1) / 256.0, meaning approximately 0-1 second lifetime)
//byte red (0.0 to 1.0 converted to 0-255)
//byte green (0.0 to 1.0 converted to 0-255)
//byte blue (0.0 to 1.0 converted to 0-255)
//description:
//creates a customized light flash.

//DP_TE_EXPLOSIONRGB
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
void(vector org, vector color) te_explosionrgb = #407;
//temp entity definitions:
//float TE_EXPLOSIONRGB = 53;
//protocol:
//vector origin
//byte red (0.0 to 1.0 converted to 0 to 255)
//byte green (0.0 to 1.0 converted to 0 to 255)
//byte blue (0.0 to 1.0 converted to 0 to 255)
//description:
//creates a colored explosion effect.

//DP_TE_FLAMEJET
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//temp entity definitions:
float TE_FLAMEJET = 74;
//protocol:
//vector origin
//vector velocity
//byte count (0 to 255, how many flame particles)
//description:
//creates a single puff of flame particles.  (not very useful really)

//DP_TE_PARTICLECUBE
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
void(vector mincorner, vector maxcorner, vector vel, float howmany, float color, float gravityflag, float randomveljitter) te_particlecube = #408;
//temp entity definitions:
//float TE_PARTICLECUBE = 54;
//protocol:
//vector mins (minimum corner of the cube)
//vector maxs (maximum corner of the cube)
//vector velocity
//short count
//byte color (palette color)
//byte gravity (TRUE or FALSE, FIXME should this be a scaler instead?)
//coord randomvel (how much to jitter the velocity)
//description:
//creates a cloud of particles, useful for forcefields but quite customizable.

//DP_TE_PARTICLERAIN
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
void(vector mincorner, vector maxcorner, vector vel, float howmany, float color) te_particlerain = #409;
//temp entity definitions:
//float TE_PARTICLERAIN = 55;
//protocol:
//vector mins (minimum corner of the cube)
//vector maxs (maximum corner of the cube)
//vector velocity (velocity of particles)
//short count (number of particles)
//byte color (8bit palette color)
//description:
//creates a shower of rain, the rain will appear either at the top (if falling down) or bottom (if falling up) of the cube.

//DP_TE_PARTICLESNOW
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
void(vector mincorner, vector maxcorner, vector vel, float howmany, float color) te_particlesnow = #410;
//temp entity definitions:
//float TE_PARTICLERAIN = 56;
//protocol:
//vector mins (minimum corner of the cube)
//vector maxs (maximum corner of the cube)
//vector velocity (velocity of particles)
//short count (number of particles)
//byte color (8bit palette color)
//description:
//creates a shower of snow, the snow will appear either at the top (if falling down) or bottom (if falling up) of the cube, low velocities are advisable for convincing snow.

//DP_TE_QUADEFFECTS1
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
void(vector org) te_gunshotquad = #412;
void(vector org) te_spikequad = #413;
void(vector org) te_superspikequad = #414;
void(vector org) te_explosionquad = #415;
//temp entity definitions:
//float   TE_GUNSHOTQUAD  = 57; // [vector] origin
//float   TE_SPIKEQUAD    = 58; // [vector] origin
//float   TE_SUPERSPIKEQUAD = 59; // [vector] origin
//float   TE_EXPLOSIONQUAD = 70; // [vector] origin
//protocol:
//vector origin
//description:
//all of these just take a location, and are equivilant in function (but not appearance :) to the original TE_GUNSHOT, etc.

//DP_TE_SMALLFLASH
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
void(vector org) te_smallflash = #416;
//temp entity definitions:
//float TE_SMALLFLASH = 72;
//protocol:
//vector origin
//description:
//creates a small light flash (radius 200, time 0.2).

//DP_TE_SPARK
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
void(vector org, vector vel, float howmany) te_spark = #411;
//temp entity definitions:
//float TE_SPARK = 51;
//protocol:
//vector origin
//byte xvelocity (-128 to 127)
//byte yvelocity (-128 to 127)
//byte zvelocity (-128 to 127)
//byte count (number of sparks)
//description:
//creates a shower of sparks and a smoke puff.

//DP_TE_STANDARDEFFECTBUILTINS
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
void(vector org) te_gunshot = #418;
void(vector org) te_spike = #419;
void(vector org) te_superspike = #420;
void(vector org) te_explosion = #421;
void(vector org) te_tarexplosion = #422;
void(vector org) te_wizspike = #423;
void(vector org) te_knightspike = #424;
void(vector org) te_lavasplash = #425;
void(vector org) te_teleport = #426;
void(vector org, float color) te_explosion2 = #427;
void(entity own, vector start, vector end) te_lightning1 = #428;
void(entity own, vector start, vector end) te_lightning2 = #429;
void(entity own, vector start, vector end) te_lightning3 = #430;
void(entity own, vector start, vector end) te_beam = #431;
//description:
//to make life easier on mod coders.

//DP_TE_PLASMABURN
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//builtin definitions:
void(vector org) te_plasmaburn = #433;
//temp entity definitions:
//float TE_PLASMABURN = 75;
//protocol:
//vector origin
//description:
//creates a small light flash (radius 200, time 0.2) and marks the walls.

//DP_VIEWZOOM
//idea: LordHavoc
//darkplaces implementation: LordHavoc
//field definitions:
.float viewzoom;
//description:
//scales fov and sensitivity of player, valid range is 0 to 1 (intended for sniper rifle zooming, and such)

//FRIK_FILE
//idea: FrikaC
//darkplaces implementation: LordHavoc
//builtin definitions:
float(string s) stof = #81; // get numerical value from a string
float(string filename, float mode) fopen = #110; // opens a file inside quake/gamedir/data/ (mode is FILE_READ, FILE_APPEND, or FILE_WRITE), returns fhandle >= 0 if successful, or fhandle < 0 if unable to open file for any reason
void(float fhandle) fclose = #111; // closes a file
string(float fhandle) fgets = #112; // reads a line of text from the file and returns as a tempstring
void(float fhandle, string s) fputs = #113; // writes a line of text to the end of the file
float(string s) strlen = #114; // returns how many characters are in a string
string(string s1, string s2) strcat = #115; // concatenates two strings (for example "abc", "def" would return "abcdef") and returns as a tempstring
string(string s, float start, float length) substring = #116; // returns a section of a string as a tempstring
vector(string s) stov = #117; // returns vector value from a string
string(string s) strzone = #118; // makes a copy of a string into the string zone and returns it, this is often used to keep around a tempstring for longer periods of time (tempstrings are replaced often)
void(string s) strunzone = #119; // removes a copy of a string from the string zone (you can not use that string again or it may crash!!!)
//constants:
float FILE_READ = 0;
float FILE_APPEND = 1;
float FILE_WRITE = 2;
//cvars:
//pr_zone_min_strings : default 64 (64k), min 64 (64k), max 8192 (8mb)
//description:
//provides text file access functions and string manipulation functions, note that you may want to set pr_zone_min_strings in the worldspawn function if 64k is not enough string zone space.

//KRIMZON_SV_PARSECLIENTCOMMAND
//idea: KrimZon
//darkplaces implementation: KrimZon, LordHavoc
//engine-called QC prototypes:
//void(string s) SV_ParseCommand;
//builtin definitions:
void(entity e, string s) clientcommand = #440;
float(string s) tokenize = #441;
string(float n) argv = #442;
//description:
//provides QC the ability to completely control server interpretation of client commands ("say" and "color" for example, clientcommand is necessary for this and substring (FRIK_FILE) is useful) as well as adding new commands (tokenize, argv, and stof (FRIK_FILE) are useful for this)), whenever a clc_stringcmd is received the QC function is called, and it is up to the QC to decide what (if anything) to do with it

//NEH_RESTOREGAME
//idea: Nehahra
//darkplaces implementation: LordHavoc
//engine-called QC prototypes:
//void() RestoreGame;
//description:
//when a savegame is loaded, this function is called

//NEH_CMD_PLAY2
//idea: Nehahra
//darkplaces implementation: LordHavoc
//description:
//shows that the engine supports the "play2" console command (plays a sound without spatialization).

//TW_SV_STEPCONTROL
//idea: Transfusion
//darkplaces implementation: LordHavoc
//cvars:
//sv_jumpstep (0/1, default 1)
//sv_stepheight (default 18)
//description:
//sv_jumpstep allows stepping up onto stairs while airborn, sv_stepheight controls how high a single step can be.


