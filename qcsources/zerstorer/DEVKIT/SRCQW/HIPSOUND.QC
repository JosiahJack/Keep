//=========================
//
// Hipnotic Sub-routines
//
//=========================

/* Hipnotic sound entities */

void() play_sound_use =
   {
   if (self.spawnflags & 1)
      {
      if (self.state == 0)
         {
         self.state = 1;
         sound (self, self.impulse, self.noise, self.volume, self.speed);
         }
      else
         {
         self.state = 0;
         sound (self, self.impulse, "misc/null.wav", self.volume, self.speed);
         }
      }
   else
      {
      sound (self, self.impulse, self.noise, self.volume, self.speed);
      }
   };

void() PlaySoundThink =
   {
   local float t;
   t = self.wait * random();
   if (t < self.delay)
      t = self.delay;
   self.nextthink = time + t;
   play_sound_use();
   };

/*QUAKED play_sound_triggered (0.3 0.1 0.6) (-8 -8 -8) (8 8 8) toggle
play a sound when it is used
"toggle" determines whether sound should be stopped when triggered again
"volume" how loud (1 default full volume)
"noise" sound to play
"impulse" channel on which to play sound (0-7) (0 automatic is default)
"speed" attenuation factor
   -1 - no attenuation
    1 - normal
    2 - idle
    3 - static
*/
void() play_sound_triggered =
   {
   precache_sound (self.noise);
   precache_sound ("misc/null.wav");
   if (self.volume == 0)
      self.volume = 1;
   if (self.speed == 0)
      self.speed = 1;
   if (self.speed == -1)
      self.speed = 0;
   if (self.spawnflags & 1)
      if (self.impulse == 0)
         self.impulse = 7;
   self.use = play_sound_use;
   };

/*QUAKED play_sound (0.3 0.1 0.6) (-8 -8 -8) (8 8 8)
play a sound on a periodic basis
"volume" how loud (1 default full volume)
"noise" sound to play
"wait" random time between sounds (default 20)
"delay" minimum delay between sounds (default 2)
"impulse" channel on which to play sound (0-7) (0 automatic is default)
"speed" attenuation factor
   -1 - no attenuation
    1 - normal
    2 - idle
    3 - static
*/
void() play_sound =
   {
   local float t;

   play_sound_triggered();
   if (self.wait == 0)
      self.wait = 20;
   if (self.delay == 0)
      self.delay = 2;
   self.think = PlaySoundThink;
   t = self.wait * random();
   if (t < self.delay)
      t = self.delay;
   self.nextthink = time + t;
   };
