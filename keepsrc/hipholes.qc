//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by W. Josiah Jack, aka Qmaster
//
// Attributions: Mission Pack 1 (Hipnotic) by Ritual Entertainment
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
// Function count: 3
//
// Implements: Shotgun Bullet Holes and Wall Sprite
//
// Description:
// When firing shotguns, will place a bullet hole sprite on a hit wall.
//
// wallsprite is a blood decal sprite.
//=============================================================================

void() wallsprite = { // [ENTITY], Blood sprite in hipnotic.
   if (!self.model) self.model = "progs/hipnotic/s_blood1.spr";
   info_sprite_static();
};

void() InitBulletHoles = { // [FUNCTION]
   bulletholes = world;
   lastbullet = world;
   numbulletholes = FALSE;
};

void() remove_bullethole = { // [FUNCTION]
   if (!bulletholes) return;
   if (bulletholes.classname != "bullethole") return;

   bulletholes = bulletholes.lastvictim;
   remove(bulletholes);
   if (lastbullet == bulletholes) lastbullet = world;
   numbulletholes = (numbulletholes - TRUE);
};

void(vector pos) placebullethole = { // [FUNCTION]
   local entity new;
   local vector norm;

   new = spawn();
   new.owner = new;
   new.movetype = MOVETYPE_NONE;
   new.solid = SOLID_NOT;
   new.classname = "bullethole";
   setmodel(new,"progs/hipnotic/s_bullet.spr");
   setsize (new,VEC_ORIGIN,VEC_ORIGIN);
   norm = trace_plane_normal;
   norm_x = (FALSE - norm_x);
   norm_y = (FALSE - norm_y);
   new.angles = vectoangles (norm);
   makevectors(self.angles);
   setorigin(new,(pos - (v_forward * 0.200)));
   new.think = remove_bullethole;
   new.nextthink = (time + 300.000);
   numbulletholes = (numbulletholes + TRUE);
   if (numbulletholes > 32) remove_bullethole();
   if (lastbullet) lastbullet.lastvictim = new;
   else bulletholes = new;

   new.lastvictim = world;
   lastbullet = new;
};