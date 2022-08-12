/*
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by the
Free Software Foundation; either version 2 of the License, or (at your
option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

/* 
	Originally written by "Kryten" <kryten@inside3d.com> <http://www.inside3d.com>
	Modifications by Frank Condello <pox@planetquake.com>
	
	Gibbable corpses.
	Dependant on changes in all appropriate monster QC files.

	Changes from original:
	- reduced height to avoid getting stuck on corpses at top of steps (shambler is same size as others)
	- touch "hurts" the corpse until it eventually gibs
	- just gib it if !checkbottom and player runs into it. i.e. if a monster dies on top of a player,
	  or is hanging off ledges/steps. (this makes getting hung up on a corpse much less likely)
	- Use less gibs for fish (with false "head" gib) to match URQP fix
	- reduced gib veloctiy so stuff doesn't fly around so much
*/

//============================================================================

void() corpse_touch = 
{
	self.velocity = '0 0 0';

	if (other.health && (other.flags & FL_CLIENT)) {
		
		if ((!other.flags & FL_ONGROUND))
			other.flags = other.flags + FL_ONGROUND;

		// if the corpse is on a ledge, or in mid-air, gib it to prevent hang-ups
		if (!checkbottom(self) || (other.absmin_z + 4 < self.absmin_z))
			T_Damage (self, other, other, 22);
		// if the player is moving, "step" on the corpse causing damgage.
		else if ( self.attack_finished < time &&
				 (fabs(other.velocity_x) > 30 ||
				  fabs(other.velocity_y) > 30 ||
				  fabs(other.velocity_z) > 30) ) {
			sound (self, CHAN_VOICE, "wizard/hit.wav", 0.25, ATTN_NORM);
			T_Damage (self, other, other, 1);
			self.attack_finished = time + 1.0;// Only allow 1 step per second to hurt
		}
	}
};

void() corpse_die =
{
	sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
	if (self.headmdl) 
		ThrowHead (self.headmdl, self.health*0.5);
	
	if (self.headmdl == "progs/gib3.mdl") {// Fish
		ThrowGib ("progs/gib3.mdl", self.health*0.25);
	} else {
		ThrowGib ("progs/gib1.mdl", self.health*0.25);
		ThrowGib ("progs/gib2.mdl", self.health*0.25);
		ThrowGib ("progs/gib3.mdl", self.health*0.25);
	}
	
	if (!self.headmdl) // if no head then this is needed!
		remove (self);
};

void() become_corpse =
{
	self.health = 20;
		
	self.takedamage = DAMAGE_AIM;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.flags = self.flags & (!FL_MONSTER);
	
	setsize (self, '-32 -32 -24', '32 32 -22');
	
	self.classname = "monster_corpse";
	
	self.origin_z = self.origin_z + 2; // less likely to fall into ground
	
	//target stuff: if a monsters death sets off a trigger then dont let the corpses death do the same
	self.use = SUB_Null;
	self.target = string_null;
	self.killtarget = string_null;
	self.targetname = string_null;
	
	self.th_die = SUB_Null;
	self.th_stand = SUB_Null;
	self.th_walk = SUB_Null;
	self.th_run = SUB_Null;
	self.th_missile = SUB_Null;
	self.th_melee = SUB_Null;
	self.th_pain = SUB_Null;
	self.touch = SUB_Null;
	self.th_die = corpse_die;
	self.touch = corpse_touch;
	self.attack_finished = time;
}

//============================================================================
