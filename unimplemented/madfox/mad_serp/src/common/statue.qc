$frame 0 1 2 3

void() stat_stand1 =[  $0,   stat_stand2  ]{};
void() stat_stand2 =[  $1,   stat_stand3  ]{};
void() stat_stand3 =[  $2,   stat_stand4  ]{};
void() stat_stand4 =[  $3,   stat_stand1  ]{};

void() info_statue = 
{
     precache_model ("progs/s_stat1.spr");
     self.solid = SOLID_BBOX;                               
     self.movetype = MOVETYPE_NONE;

     setmodel (self, "progs/s_stat1.spr");

     setsize (self, '1 1 1', '2 2 2');
     self.think = stat_stand1;
     self.nextthink = time + 0.1;
}
 