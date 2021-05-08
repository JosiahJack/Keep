//=============================================================================================
//
// QRV : Map Effects : Particles
//
//
// Handles particle emitters, should also be linked to CSQC cuz its "better"
//=============================================================================================

//.float emitter_active
//.string emitter_fx


// QRV : Map Effects : Particle Emitter : SendToCSQC
float(entity to, float sendFlags) particle_emitter_sendtocsqc =
{
	
   WriteByte( MSG_ENTITY, ENT_PARTICLE_EMITTER );
   WriteByte( MSG_ENTITY, sendFlags);
   
   if (sendFlags & 1)
   {
	   // Emitter origin
	   WriteCoord( MSG_ENTITY, self.origin_x );
	   WriteCoord( MSG_ENTITY, self.origin_y );
	   WriteCoord( MSG_ENTITY, self.origin_z );

	  // Emitter velocity
	   WriteCoord( MSG_ENTITY, self.velocity_x );
	   WriteCoord( MSG_ENTITY, self.velocity_y );
	   WriteCoord( MSG_ENTITY, self.velocity_z );

	   // Emitter spawn amount
	   WriteCoord( MSG_ENTITY, self.count );

	   //Delay between particle calls, for map emitters like torches, flames, etc.
	   WriteCoord( MSG_ENTITY, self.wait );
	   
	   // Emitter ParticleEffectNum name
	   WriteString( MSG_ENTITY, self.message );
	   
   }
   
   // o.O
   return TRUE;
};


// QRV : Map Effects : Particle Emitter : Think
void() particle_emitter_think =
{

   self.SendEntity = particle_emitter_sendtocsqc;
   //self.SendFlags |= 1;
   //self.Version = self.Version + 1;
   self.think = SUB_Remove;
   self.nextthink = time + 0.2;
   
};


void(string partName, vector partOrg, vector partVel, float amount, float spawntime) sendParticle =
{
	newmis = spawn();
	newmis.message = partName;
	setorigin(newmis, partOrg);
	setmodel(newmis, "progs/s_smoke.spr");
	newmis.alpha = 0.001;
	
	newmis.velocity = partVel;
	newmis.count = amount;
	newmis.wait = spawntime;
	
	newmis.think = particle_emitter_think;
	
	newmis.nextthink = time;

}