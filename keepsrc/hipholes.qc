void() wallsprite = {
   if (!self.model) self.model = "progs/hipnotic/s_blood1.spr";
   precache_model(self.model);
   setmodel(self,self.model);
   if ( (self.angles == '0.000 -1.000 0.000') ) self.angles = '-90.000 0.000 0.000';
   else if ( (self.angles == '0.000 -2.000 0.000') ) self.angles = '90.000 0.000 0.000';

   makevectors(self.angles);
   setorigin (self,(self.origin - (v_forward * 0.200)));
   makestatic (self);
};

void() InitBulletHoles = {
   bulletholes = nullentity;
   lastbullet = nullentity;
   numbulletholes = FALSE;
};

void() remove_bullethole = {
   local entity ent;

   if (bulletholes == nullentity) objerror ("remove_bullethole: bulletholes == nullentity! ");
   ent = bulletholes;
   if (ent.classname != "bullethole")  objerror ("remove_bullethole: Tried to remove non-bullethole!");
   bulletholes = bulletholes.lastvictim;
   remove(ent);
   if (lastbullet == ent) lastbullet = nullentity;
   numbulletholes = (numbulletholes - TRUE);
};

void(vector pos) placebullethole = {
   local entity new;
   local vector norm;

   new = spawn();
   new.owner = new;
   new.movetype = MOVETYPE_NONE;
   new.solid = SOLID_NOT;
   new.classname = "bullethole";
   setmodel (new,"progs/hipnotic/s_bullet.spr");
   setsize (new,VEC_ORIGIN,VEC_ORIGIN);
   norm = trace_plane_normal;
   norm_x = (FALSE - norm_x);
   norm_y = (FALSE - norm_y);
   new.angles = vectoangles (norm);
   makevectors(self.angles);
   setorigin (new,(pos - (v_forward * 0.200)));
   new.think = remove_bullethole;
   new.nextthink = (time + 300.000);
   numbulletholes = (numbulletholes + TRUE);
   if (numbulletholes > 32) remove_bullethole();
   if (lastbullet != nullentity) lastbullet.lastvictim = new;
   else bulletholes = new;

   new.lastvictim = nullentity;
   lastbullet = new;
};