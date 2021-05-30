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
	Written by Frank Condello <pox@planetquake.com>
	
	Misc triggers...
	
	trigger_relay2
	trigger_chat
	trigger_chat_relay
	trigger_shake
	trigger_enemy
*/

//============================================================================

void() relay2_use =
{
	// Fire first target
	SUB_UseTargets();
	
	// Copy off and fire second target
	if (self.event) {
		self.target = self.event;
		self.delay = self.wait;
		self.message = self.message2;
		self.killtarget = self.killtarget2;
		SUB_UseTargets();
		
		// Restore first target
		self.target = self.event2;
		self.delay = self.wait2;
		self.message = self.noise;
		self.killtarget = self.deathtype;
	}
};

/*QUAKED trigger_relay2 (.5 .5 .5) (-8 -8 -8) (8 8 8)
Works just like the original trigger_relay, but allows you to fire two unique targets
(or the same target twice, useful for starting and stopping emitters at regular intervals).

First Target:
"target"
"delay"
"message"
"killtarget"

Second Target (optional):
"event"
"wait"
"message2"
"killtarget2"

*/
void() trigger_relay2 =
{
	// Save out first target so it can be restored
	if (self.event) {
		self.event2 = self.target;
		self.wait2 = self.delay;
		self.noise = self.message;
		self.deathtype = self.killtarget;
	}
	
	self.use = relay2_use;
};

//============================================================================

void() chat_chat =
{
	if (self.touch) {
		
		if (other.classname != "player")
			return;
		
		if (self.movedir != '0 0 0')
		{
			makevectors (other.angles);
			if (v_forward * self.movedir < 0)
				return;// not facing the right way
		}
	}
	
	activator = world;// This will centreprint if player is activator
	
	// Basically swiped from FikBot...
	WriteByte(MSG_ALL, 8);// svc_print
	WriteByte(MSG_ALL, 1);// svc_nop
	WriteString(MSG_ALL, self.netname);
	WriteByte(MSG_ALL, 8);
	WriteByte(MSG_ALL, 1);
	WriteString(MSG_ALL, ": ");
	WriteByte(MSG_ALL, 8);
	WriteByte(MSG_ALL, 1);
	WriteString(MSG_ALL, self.message);
	WriteByte(MSG_ALL, 8);
	WriteByte(MSG_ALL, 2);// svc_disconnect
	WriteString(MSG_ALL, "\n");
	if (HasTargets(self)) SUB_UseTargets();
	remove(self);
};

/*QUAKED trigger_chat (.5 .5 .5) ?
A little hack to print a "chat" message in a single player game from a non-existant
source (good for sending messages to the player from "HQ" or whatever).

"angle"			Angle the player must be facing to trigger
"netname"		Name of the sender
"message"		The chat message
"delay"			Delay before activating target
"target"		Activate this ent after delay (setup a chat relay)

NOTES:

These are always one-off triggers, removed after sending their message.

*/
void() trigger_chat =
{
	if (!self.netname) objerror("trigger_chat without netname");
	if (!self.message) objerror("trigger_chat without message");
	
	if (self.delay <=0)
		self.delay = 0.1;
	
	InitTrigger ();
	
	self.touch = chat_chat;
};

/*QUAKED trigger_chat_relay (.5 .5 .5) (-8 -8 -8) (8 8 8) ?
Like trigger_chat, but must be remotely triggered. Can trigger another
ent after delay time (for stringing together a bunch of timed messages)

"netname"		Name of the sender
"message"		The chat message
"delay"			Delay before activating target
"target"		Activate this ent after delay
"targetname"	This trigger's name

NOTES:

See trigger_chat notes.

*/
void() trigger_chat_relay =
{
	if (!self.netname) objerror("trigger_chat_relay without netname");
	if (!self.message) objerror("trigger_chat_relay without message");
	
	if (self.delay <=0)
		self.delay = 0.1;
		
	self.use = chat_chat;
};

//============================================================================
float VIEWONLY = 1;

void() trig_shake_think =
{
	if (self.attack_finished < time) {// Done
		
		self.nextthink = -1;
		
		if (self.noise1)
			sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
		
		return;
	}
	
	local	entity plyr;
	
	// Shake all players in the effect radius...
	
	plyr = findradius(self.origin, self.count);
	
	while(plyr)
	{
		if (plyr.classname == "player") {
			
			local float	d;
			
			// Scale effect by distance
			d = vlen(self.origin - plyr.origin);
			d = (self.count - d)/self.count;
			
			if (d > 0) {

				// shake up the view
				plyr.punchangle_x = -1 * (random() + (0.025*self.dmg*d));
				
				// push the player around
				if (plyr.flags & FL_ONGROUND && !(self.spawnflags & VIEWONLY)) {
					d = self.dmg*d;
					plyr.velocity_x = plyr.velocity_x + (random()*d*2 - d);
					plyr.velocity_y = plyr.velocity_y + (random()*d*2 - d);
					plyr.velocity_z = plyr.velocity_z + (random()*d);// always push up
				}	
			}
		}
		
		plyr = plyr.chain;
	}
	
	// keep going
	self.nextthink = time + 0.1;
};

void() trig_shake_use =
{
	if (self.attack_finished > time) return;// already active

	// Start...
	
	if (self.noise)
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	
	self.attack_finished = time + self.wait;
	self.nextthink = time + 0.01;
};

/*QUAKED trigger_shake (.5 .5 .5) ? VIEWONLY
Earthquake trigger - shakes players in it's radius when active.
Strength of tremor is greatest at the centre.

"dmg"			Strength at center (default is 120)
"wait"			Duration of shake (default is 1)
"count"			Affect radius (defalt is 200)
"noise"			Noise to play when starting to shake
"noise1"		Noise to play when stopping
"targetname"	Must be triggered

Spawnflags:
"VIEWONLY"		Shakes the view, but player movement is not affected

*/
void() trigger_shake =
{	
	if (!self.targetname) objerror("trigger_shake without name");

	if (self.noise) precache_sound (self.noise);
	if (self.noise1) precache_sound (self.noise1);
	
	if (!self.dmg) self.dmg = 120;
	if (self.count <= 0) self.count = 200;
	if (self.wait <= 0) self.wait = 1.0;
	
	setorigin(self, self.origin);
	
	self.nextthink = -1;
	self.think = trig_shake_think;
	self.use = trig_shake_use;
};

float IGNORE_ALIGNMENT = 1;
float HATE_NEUTRAL = 2;
float IGNORE_CURRENT_ENEMY = 4;

void() enemy_anger = {
	local entity mnstr, stemp, hateme;
	
	mnstr = find(world, targetname, self.target);
	hateme = find(world, targetname, self.sighttarget);
	if (hateme.health < 1 || !(hateme.flags & FLx_CREATURE)) return; // maybe they died ya know
	while (mnstr) {
		if (mnstr.flags & FL_MONSTER && ((self.spawnflags & IGNORE_CURRENT_ENEMY) || !mnstr.enemy)) {
			if (self.spawnflags & IGNORE_ALIGNMENT || !Align_Match(mnstr,hateme)) {
				if (self.spawnflags & HATE_NEUTRAL || mnstr.alignment != NEUTRAL) {
					if (self.spawnflags & IGNORE_ALIGNMENT) mnstr.temperament = TEMPRA_PSYCHOTIC; // So we don't abandon them right away
					mnstr.enemy = hateme;
					stemp = self;
					self = mnstr;
					FoundTarget();
					self = stemp;
				}
			}
		}
		mnstr = find(mnstr, targetname, self.target);
	}
};

// QUAKED trigger_enemy (.5 .5 .5) (-8 -8 -8) (8 8 8) ?
// Hack to get a monster's attention (for "scripted" events).
// "target"		The monster(s) to anger
// "sighttarget"	The monster to hate
// "targetname"	Must be triggered

void() trigger_enemy = {
	if (!self.targetname) objerror("trigger_enemy without name");
	if (!self.target) objerror("trigger_enemy without a target");

	setorigin (self, self.origin);
	setmodel (self, string_null);
	self.health = 100;
		
	self.use = enemy_anger;
};