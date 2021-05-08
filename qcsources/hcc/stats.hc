float ExperienceValues [44]   = { 945.00000,
    2240.00000,    5250.00000,    10150.00000,    21000.00000,
    39900.00000,    72800.00000,    120400.00000,    154000.00000,
    210000.00000,    210000.00000,    911.00000,    2160.00000,
    5062.00000,    9787.00000,    20250.00000,    38475.00000,
    70200.00000,    116100.00000,    148500.00000,    202500.00000,
    202500.00000,    823.00000,    1952.00000,    4575.00000,
    8845.00000,    18300.00000,    34770.00000,    63440.00000,
    104920.00000,    134200.00000,    183000.00000,    183000.00000,
    675.00000,    1600.00000,    3750.00000,    7250.00000,
    15000.00000,    28500.00000,    52000.00000,    86000.00000,
    110000.00000,    150000.00000,    150000.00000};
float hitpoint_table [20]   = { 70.00000,
    85.00000,    8.00000,    13.00000,    4.00000,
    65.00000,    75.00000,    5.00000,    10.00000,
    3.00000,    65.00000,    75.00000,    5.00000,
    10.00000,    3.00000,    65.00000,    75.00000,
    5.00000,    10.00000,    3.00000};
float mana_table [20]   = { 84.00000,
    94.00000,    6.00000,    9.00000,    1.00000,
    88.00000,    98.00000,    7.00000,    10.00000,
    2.00000,    94.00000,    104.00000,    10.00000,
    12.00000,    4.00000,    92.00000,    102.00000,
    9.00000,    11.00000,    3.00000};
float strength_table [8]   = { 15.00000,
    18.00000,    12.00000,    15.00000,    6.00000,
    10.00000,    10.00000,    13.00000};
float intelligence_table [8]   = { 6.00000,
    10.00000,    10.00000,    13.00000,    15.00000,
    18.00000,    6.00000,    10.00000};
float wisdom_table [8]   = { 6.00000,
    10.00000,    15.00000,    18.00000,    10.00000,
    13.00000,    12.00000,    15.00000};
float dexterity_table [8]   = { 10.00000,
    13.00000,    6.00000,    10.00000,    8.00000,
    12.00000,    15.00000,    18.00000};

float  (float min,float max)stats_compute =  {
local float value = 0.00000;
   value = ((((max - min) + 1.00000) * random()) + min);
   if ( (value > max) ) {

      value = max;

   }
   value = ceil ( value);
   return ( value );
};


void  (entity e)stats_NewPlayer =  {
local float index = 0.00000;
   if ( e.strength ) {

      return ;

   }
   if ( ((e.playerclass < CLASS_PALADIN) || (e.playerclass > CLASS_ASSASSIN)) ) {

      sprint ( e, "Invalid player class ");
      sprint ( e, ftos ( e.playerclass));
      sprint ( e, "\n");
      return ;

   }
   index = ((e.playerclass - 1.00000) * 5.00000);
   e.health = stats_compute ( (hitpoint_table->index), (hitpoint_table->(index + 1.00000)));
   e.max_health = e.health;
   index = ((e.playerclass - 1.00000) * 5.00000);
   e.max_mana = stats_compute ( (mana_table->index), (mana_table->(index + 1.00000)));
   index = ((e.playerclass - 1.00000) * 2.00000);
   e.strength = stats_compute ( (strength_table->index), (strength_table->(index + 1.00000)));
   e.intelligence = stats_compute ( (intelligence_table->index), (intelligence_table->(index + 1.00000)));
   e.wisdom = stats_compute ( (wisdom_table->index), (wisdom_table->(index + 1.00000)));
   e.dexterity = stats_compute ( (dexterity_table->index), (dexterity_table->(index + 1.00000)));
   e.level = 1.00000;
   e.experience = 0.00000;
};


void  ()player_level_cheat =  {
local float index = 0.00000;
   index = ((self.playerclass - 1.00000) * (MAX_LEVELS + 1.00000));
   if ( (self.level > MAX_LEVELS) ) {

      index += (MAX_LEVELS - 1.00000);
   } else {

      index += (self.level - 1.00000);

   }
   self.experience = (ExperienceValues->index);
   if ( (self.level > MAX_LEVELS) ) {

      self.experience += ((self.level - MAX_LEVELS) * (ExperienceValues->(index + 1.00000)));

   }
   PlayerAdvanceLevel ( (self.level + 1.00000));
};


void  ()player_experience_cheat =  {
   AwardExperience ( self, self, 350.00000);
};


void  (float NewLevel)PlayerAdvanceLevel =  {
local string s2;
local float OldLevel = 0.00000;
local float Diff = 0.00000;
local float index = 0.00000;
local float HealthInc = 0.00000;
local float ManaInc = 0.00000;
   OldLevel = self.level;
   self.level = NewLevel;
   Diff = (self.level - OldLevel);
   sprint ( self, "You are now level ");
   s2 = ftos ( self.level);
   sprint ( self, s2);
   sprint ( self, "!!!!!!!!!!!!!!\n");
   if ( (self.playerclass == CLASS_PALADIN) ) {

      sprint ( self, "Paladin gained a level\n");
   } else {

      if ( (self.playerclass == CLASS_CRUSADER) ) {

         sprint ( self, "Crusader gained a level\n");
         self.greenmana = self.max_mana;
         self.bluemana = self.max_mana;
      } else {

         if ( (self.playerclass == CLASS_NECROMANCER) ) {

            sprint ( self, "Necromancer gained a level\n");
         } else {

            if ( (self.playerclass == CLASS_ASSASSIN) ) {

               sprint ( self, "Assassin gained a level\n");

            }

         }

      }

   }
   if ( ((self.playerclass < CLASS_PALADIN) || (self.playerclass > CLASS_ASSASSIN)) ) {

      return ;

   }
   index = ((self.playerclass - 1.00000) * 5.00000);
   while ( (Diff > 0.00000) ) {

      OldLevel += 1.00000;
      Diff -= 1.00000;
      if ( (OldLevel <= MAX_LEVELS) ) {

         HealthInc = stats_compute ( (hitpoint_table->(index + 2.00000)), (hitpoint_table->(index + 3.00000)));
         ManaInc = stats_compute ( (mana_table->(index + 2.00000)), (mana_table->(index + 3.00000)));
      } else {

         HealthInc = (hitpoint_table->(index + 4.00000));
         ManaInc = (mana_table->(index + 4.00000));

      }
      self.health += HealthInc;
      self.max_health += HealthInc;
      if ( (self.health > 150.00000) ) {

         self.health = 150.00000;

      }
      if ( (self.max_health > 150.00000) ) {

         self.max_health = 150.00000;

      }
      self.greenmana += ManaInc;
      self.bluemana += ManaInc;
      self.max_mana += ManaInc;

   }
   if ( (self.level > 2.00000) ) {

      self.flags |= FL_SPECIAL_ABILITY1;

   }
   if ( (self.level > 5.00000) ) {

      self.flags |= FL_SPECIAL_ABILITY2;

   }
};


float  (entity WhichPlayer)FindLevel =  {
local float Chart = 0.00000;
local float Amount = 0.00000;
local float Position = 0.00000;
local float Level = 0.00000;
   if ( ((WhichPlayer.playerclass < CLASS_PALADIN) || (WhichPlayer.playerclass > CLASS_ASSASSIN)) ) {

      return ( WhichPlayer.level );

   }
   Chart = ((WhichPlayer.playerclass - 1.00000) * (MAX_LEVELS + 1.00000));
   Level = 0.00000;
   Position = 0.00000;
   while ( ((Position < MAX_LEVELS) && (Level == 0.00000)) ) {

      if ( (WhichPlayer.experience < (ExperienceValues->(Chart + Position))) ) {

         Level = (Position + 1.00000);

      }
      Position += 1.00000;

   }
   if ( !Level ) {

      Amount = (WhichPlayer.experience - (ExperienceValues->((Chart + MAX_LEVELS) - 1.00000)));
      Level = (ceil ( (Amount / (ExperienceValues->(Chart + MAX_LEVELS)))) + MAX_LEVELS);

   }
   return ( Level );
};


void  (entity ToEnt,entity FromEnt,float Amount)AwardExperience =  {
local float AfterLevel = 0.00000;
local float IsPlayer = 0.00000;
local entity SaveSelf;
local float index = 0.00000;
local float test40 = 0.00000;
local float test80 = 0.00000;
local float diff = 0.00000;
local float index2 = 0.00000;
local float totalnext = 0.00000;
   if ( !Amount ) {

      return ;

   }
   if ( (ToEnt.deadflag >= DEAD_DYING) ) {

      return ;

   }
   IsPlayer = (ToEnt.classname == "player");
   if ( ((FromEnt != world) && (Amount == 0.00000)) ) {

      Amount = FromEnt.experience_value;

   }
   if ( (ToEnt.level < 4.00000) ) {

      Amount *= 0.50000;

   }
   if ( (ToEnt.playerclass == CLASS_PALADIN) ) {

      Amount *= 1.40000;
   } else {

      if ( (ToEnt.playerclass == CLASS_CRUSADER) ) {

         Amount *= 1.35000;
      } else {

         if ( (ToEnt.playerclass == CLASS_NECROMANCER) ) {

            Amount *= 1.22000;

         }

      }

   }
   ToEnt.experience += Amount;
   if ( IsPlayer ) {

      AfterLevel = FindLevel ( ToEnt);
      if ( (ToEnt.level != AfterLevel) ) {

         SaveSelf = self;
         self = ToEnt;
         PlayerAdvanceLevel ( AfterLevel);
         self = SaveSelf;

      }

   }
   if ( IsPlayer ) {

      if ( (ToEnt.playerclass == CLASS_CRUSADER) ) {

         index = ((ToEnt.playerclass - 1.00000) * (MAX_LEVELS + 1.00000));
         if ( ((ToEnt.level - 1.00000) > MAX_LEVELS) ) {

            index += MAX_LEVELS;
         } else {

            index += (ToEnt.level - 1.00000);

         }
         if ( (ToEnt.level == 1.00000) ) {

            test40 = ((ExperienceValues->index) * 0.40000);
            test80 = ((ExperienceValues->index) * 0.80000);
         } else {

            if ( ((ToEnt.level - 1.00000) <= MAX_LEVELS) ) {

               index2 = (index - 1.00000);
               diff = ((ExperienceValues->index) - (ExperienceValues->index2));
               test40 = ((ExperienceValues->index2) + (diff * 0.40000));
               test80 = ((ExperienceValues->index2) + (diff * 0.80000));
            } else {

               totalnext = (ExperienceValues->(index - 1.00000));
               totalnext += (((ToEnt.level - 1.00000) - MAX_LEVELS) * (ExperienceValues->index));
               test40 = (totalnext + ((ExperienceValues->index) * 0.40000));
               test80 = (totalnext + ((ExperienceValues->index) * 0.80000));

            }

         }
         if ( (((ToEnt.experience - Amount) < test40) && (ToEnt.experience > test40)) ) {

            ToEnt.health = ToEnt.max_health;
         } else {

            if ( (((ToEnt.experience - Amount) < test80) && (ToEnt.experience > test80)) ) {

               ToEnt.health = ToEnt.max_health;

            }

         }

      }

   }
};


void  (entity loser,float number)drop_level =  {
local float pos = 0.00000;
   if ( (loser.classname != "player") ) {

      return ;

   }
   if ( (loser.level > number) ) {

      loser.level -= number;
      pos = ((loser.playerclass - 1.00000) * (MAX_LEVELS + 1.00000));
      loser.experience = (ExperienceValues->((pos + loser.level) - 1.00000));
   } else {

      if ( (loser.level == number) ) {

         loser.level = 1.00000;
         loser.experience = 0.00000;

      }

   }
};

