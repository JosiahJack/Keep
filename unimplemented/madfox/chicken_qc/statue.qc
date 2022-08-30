$frame 0

void() statu_stand1 =[  $0,   statu_stand2  ]{};
void() statu_stand2 =[  $0,   statu_stand1  ]{};

void() info_hellstatue = 
{
     precache_model ("progs/hell_statue.mdl");
     self.solid = SOLID_BBOX;                               
     self.movetype = MOVETYPE_NONE;

     setmodel (self, "progs/hell_statue.mdl");

     setsize (self, '1 1 1', '2 2 2');
     self.think = statu_stand1;
     self.nextthink = time + 0.1;
};

