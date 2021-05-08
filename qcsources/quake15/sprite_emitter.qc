
void() smokemit_think =
{
	self.frame++;
		
	self.ltime++;
	
	self.alpha-=.05;
	self.scale-=.007;
	self.velocity_z = self.velocity_z+6;
	//self.velocity_x = self.velocity_x-25;
	self.think = sprite_smoke_think;
	self.nextthink = time + .07;
	
	if (self.ltime > 61)
		remove(self);		
}


void(entity e, string spritepath, float spscale, vector pos_mod, vector startvelocity, vector velocityrandom, float startalpha) Part_Emitter =			//Spawns a first person sprite
{
	newmis = spawn();
	newmis.movetype = MOVETYPE_NOCLIP;
	newmis.solid = SOLID_NOT;
	//newmis.viewmodelforclient = e;
	newmis.owner = e;
	newmis.classname = "particle";
	
	
	setmodel(newmis, spritepath);
	
	newmis.scale = spscale;
	newmis.scale+= random(-0.1, 0.1);
	newmis.alpha = startalpha;
	newmis.velocity = startvelocity;

	//newmis.velocity_x += random(velocitydecay_x-10, velocitydecay_x);
	//newmis.velocity_y += random(velocitydecay_y-30, velocitydecay_y);
	//newmis.velocity_z += random(velocitydecay_z-20, velocitydecay_z);
	
	newmis.velocity_x += random(-velocityrandom_x, velocityrandom_x);
	newmis.velocity_y += random(-velocityrandom_y, velocityrandom_y);
	newmis.velocity_z += random(-velocityrandom_z, velocityrandom_z);
	
	setsize(newmis, '0 0 0', '0 0 0');
	setorigin(newmis, e.origin);	
	
	//if (emittertype == TYPE_STANDARD)
	//{
		pos_mod_x += random(-2, 3);
		pos_mod_y += random(-3, 3);
		pos_mod_z += random(-6, 6);
	//}
		
	newmis.origin+= pos_mod;
	
	newmis.think = smokemit_think;
	newmis.nextthink = time + 0.01;		//Adjust this as you wish
	
};