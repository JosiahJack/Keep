/* -----------------------------------------------------------------

Face animation and effects (for evil textures effect)

-------------------------------------------------------------------- */


$cd id1/models/face
$origin 0 0 24
$base base
$skin skin

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10
$frame idle11 idle12 idle13 idle14 idle15 idle16 idle17 idle18 idle19 idle20
$frame idle21 idle22 idle23 idle24 idle25 idle26 idle27 idle28 idle29 idle30
$frame idle31 idle32 idle33 idle34 idle35 idle36 idle37 idle38 idle39 idle40
$frame idle41 idle42 idle43 idle44 idle45 idle46 idle47 idle48 idle49 idle50
$frame idle51 idle52 idle53 idle54 idle55 idle56 idle57 idle58 idle59 idle60
$frame idle61 idle62 idle63 idle64 idle65 idle66 idle67 idle68 idle69 idle70
$frame idle71 idle72 idle73 idle74 idle75 idle76 idle77 idle78 idle79 


void(entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage;

void(float how_far) FacePainTeleport =		//  Teleport Face to a slightly other position near its origin  (harder to hit)
{
local vector spot, vec;

// Select teleport destination within a given radius.
	spot = self.origin + (randomvec()*how_far);
	vec = normalize(spot - self.origin);
	traceline (self.origin, spot, TRUE, self);	// look through monsters
	spot = trace_endpos - vec*13;

// Check for walls and obstacles.
	if (PM_InWall(self, spot))
		return;
	if (!PM_TraceCheck(self, spot))
		return;

// Check if target is not blocked.
	traceline (spot, self.enemy.origin, FALSE, self);
	if (trace_fraction < 1.0)
		if (trace_ent != self.enemy)
			return;

// Teleport and face opponent!
	setorigin(self, spot);
	self.angles_y = vectoyaw(self.enemy.origin - spot);
};

void() FacePain =
{
	if (self.pain_finished > time)
		return;

	self.pain_finished = time + 0.5;
	sound (self, CHAN_VOICE, "face/face_pain.wav", 1, ATTN_NORM);
 	FacePainTeleport (66);
};


void() FaceDeath =
{
	pointparticles(particleeffectnum("Afrit_death_explode"), self.origin, '0 0 0', 1); 	// placeholder
	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);				// placeholder
	if ((!cvar("chase_active")) && (self.enemy.classname == "player") && (autocvar_HUD_blood_splatter))	// we are in 1st person mode
	{
		if (vlen (self.enemy.origin - self.origin) < autocvar_HUD_blood_splatter)
			blood_HUD_splat = 1;
	}
	remove (self);
};


void() FaceTouch =
{
	if (other.takedamage)
		{
		if (other.classname != "player")
			{
			FacePainTeleport (70);
			return;
			}
		T_Damage (other, self, self.owner, 10); 	
		sound (self, CHAN_WEAPON, "face/face_touch.wav", 1, ATTN_NORM);	 // To abort the face fly-sound. Use same channel !!!!
		remove(self);
		}
//var float autocvar_evil_faces_monster_behaviour = 1;		// 0= evil face monster will vanish, when hitting walls/meshes    1= evil face monster will NOT vanish, when hitting walls/meshes (= more dangerous)    (when evil_faces is set to "2")
	if (autocvar_evil_faces_monster_behaviour == 0)
		{
		if (!((other.model == "progs/spike.mdl") || (other.model == "progs/s_spike.mdl") || (other.model == "progs/grenade.mdl") || (other.model == "progs/missile.mdl")))
			{
			pointparticles(particleeffectnum("Afrit_death_explode"), self.origin, '0 0 0', 1); 	// FIXME:  placeholder
			sound (self, CHAN_WEAPON, "face/face_touch.wav", 1, ATTN_NORM);	 // To abort the face fly-sound. Use same channel !!!!
			remove(self);
			}
		}
};



void() FaceHoming =
{
if (self.enemy.health < 1)	// to avoid endless homing above players corpse
	remove (self);

	if (vlen((self.enemy.origin + '0 0 16') - self.origin) <= 70)		// to make it touchable again
	{
		traceline ((self.enemy.origin + '0 0 16'), self.origin, FALSE, self);
		if (trace_fraction == 1.0)
			self.movetype = MOVETYPE_FLYMISSILE;
	}

	if (self.origin == self.old_origin)					// when it got stuck
	{
		sound (self, CHAN_WEAPON, "face/face_touch.wav", 1, ATTN_NORM);	 // To abort the face fly-sound. Use same channel !!!!
		T_RadiusDamage (self, self, 30, self);	
		remove (self);
	}
	self.old_origin = self.origin;

local vector dir, offang, vec;
	dir = normalize((self.enemy.origin + '0 0 16') - self.origin);
	offang = vectoangles ((self.enemy.origin + '0 0 14') - self.origin);
	makevectors (offang);
	
// set homing-missile angles
	vec = normalize (v_forward);
	vec_z = vec_z * -1;
	self.angles = vectoangles(vec);  	// adjust the Face to always face the player !

	self.frame = self.frame + 1;			// Face animation
	if (self.frame >= 19)				//  D3= 19
		self.frame = 0;
	self.velocity = dir * 200;			// speed of Face.  Vore: 250;
	self.nextthink = time + 0.15;			// inertia of homing effect + animation.  Vore: 0.2
	self.think = FaceHoming;	
};




void() face_main = 	  	
{
	local	vector dir;

	dir = normalize((self.enemy.origin + '0 0 10') - self.origin);

	if (autocvar_evil_faces_monster_behaviour == 0)
		self.movetype = MOVETYPE_FLYMISSILE;	// else remains MOVETYPE_NOCLIP
	setsize (self, '-12 -12 -12', '12 12 12');	// because it is shootable now
	self.velocity = dir * 150;			//  to set speed for the first 0.05 seconds (Vore: 400)
	self.nextthink = time + 0.05;
	self.think = FaceHoming;
};




void (vector face_spawn_pos, vector face_spawn_vel, float starter) spawn_face =
{
	if (autocvar_evil_faces != 2)
		return;
/*
precache_model ("progs/face.mdl");		//   precached inside worldspawn
precache_sound ("face/face_pain.wav");
precache_sound ("face/face.wav");
precache_sound ("face/face_touch.wav");
*/
	newmis = spawn ();
	if (starter == 1)
		newmis.enemy = self;			// because player is still "self" (traceline started this effect)
	else
		newmis.enemy = self.owner;		// because player´s projectile started this effect
	newmis.movetype = MOVETYPE_NOCLIP; 		// Face comes out of the wall/texture, so it must be MOVETYPE_NOCLIP !!
	newmis.solid = SOLID_BBOX;

	newmis.velocity = face_spawn_vel * 7;	
	newmis.angles = vectoangles (newmis.velocity);
//var float autocvar_evil_faces_monster_scale = 2;     	// set cvar 'evil_faces_monster_scale' default to 2
newmis.scale = autocvar_evil_faces_monster_scale;
newmis.glow_color = 75;
newmis.glow_size = 666;
	newmis.touch = FaceTouch; 			
	newmis.classname = "face";
	setmodel (newmis, "progs/face.mdl");	
	newmis.frame = 0;			// D3= 0
	setsize (newmis, '0 0 0', '0 0 0');		// to let him come out of the wall !
	newmis.think = face_main;	
	newmis.nextthink = time + 0.7;			// let the Face come out of the evil texture first, then start homing !
//var float autocvar_evil_faces_monster_health = 35;	// set health for evil face monster (when evil_face is set to "2")
	newmis.health = autocvar_evil_faces_monster_health;
	newmis.takedamage = DAMAGE_AIM;
	setorigin (newmis, face_spawn_pos);
	newmis.traileffectnum = particleeffectnum("TR_FACE");
	newmis.th_pain = FacePain;
	newmis.th_die = FaceDeath;
face_psycho = time + 1;					// Screen is turning in psycho-mode for a short time

sound (newmis, CHAN_WEAPON, "face/face.wav", 1, ATTN_NORM); 
};


