/////// Based on Nehahra



/////////////////     was in hiprot.qc  

float(vector ang) NormalizeAngles =	
{
  while (ang_x > 360) 
  {
    ang_x = ang_x - 360;
  }
  while (ang_x < 0) 
  {
    ang_x = ang_x + 360;
  }
  while (ang_y > 360) 
  {
    ang_y = ang_y - 360;
  }
  while (ang_y < 0) 
  {
    ang_y = ang_y + 360;
  }
  while (ang_z > 360) 
  {
    ang_z = ang_z - 360;
  }
  while (ang_z < 0) 
  {
    ang_z = ang_z + 360;
  }
  return ang_x;
};

///////////////// 




/////////////////     was in monster.qc  

float() borkfactor1 =
{
  if (self.health < 1) 
  {
    dprint("borkfactor1: rare bug\n");
    self.th_die();
    return TRUE;
  }
  return FALSE;
};

/////////////////





/////////////////     was in ai2.qc  

void(vector vec, float num, vector dave) ai2_jump =
{
  if (self.flags & FL_SWIM) 
	return;
  if (self.flags & FL_ONGROUND) 
  {
    vec_x = 0;
    vec_z = 0;
    makevectors(vec);
    self.origin_z = self.origin_z + 1;
    self.velocity = v_forward * num + dave;
    self.flags = self.flags - FL_ONGROUND;
  }
};

/////////////////






float(vector vec) panicjump;
void(entity threat, float dodge) dodge_fixed;
float(entity missile, entity head) Calc_Strafemove;
float(entity missile, entity head) Calc_Dodgemove;


void(entity missile) dodge_incoming =
{
	local vector megadeth;
	local float mr, num, g;
  if ((self.model == "progs/soldier.mdl") || (self.model == "progs/soldier1.mdl"))
      g = 15;
  else
      g = 20;
  megadeth = VEC_ORIGIN;
  ai_face();
  if (infront(missile)) 
  {
    if (walkmove(self.angles_y - 180, g) == FALSE) 
        mr = 1;
  }
  else 
  {
    if (walkmove(self.angles_y, g) == FALSE) 
        mr = 1;
  }
  if (missile.classname == "player") 
      megadeth_y = Calc_Strafemove(missile, self);
  else 
      megadeth_y = Calc_Dodgemove(missile, self);
  if (walkmove(megadeth_y, g) == FALSE) 
  {
    if (self.nojump == 0) 
    {
      if (panicjump(megadeth)) 
      { 
        ai2_jump(megadeth, 250, [0 0 250]);
        return;
      }
      num = -1;				// at_ledge(megadeth, self.origin);
      if (num > CONTENT_SLIME) 
      {
        ai2_jump(megadeth, 250, [0 0 250]);
        return;
      }
    }
    num = vectoyaw(self.origin - missile.origin);
    if (walkmove(num, g) == FALSE) 
        dprint("\n");
  }  
};







float() ai_threats =
{
	local entity threat;
	local vector megadeth, spot1, spot2, traj;
	local float num, dodge, blah;
	local string astri;
  if (!(self.flags & FL_ONGROUND))
  {
  	if (self.classname != "monster_wizard")
		return FALSE;
  }
  
  dodge = 0;
  astri = "thrett";
  if (self.enemy.classname != "player")
  	astri = "mthret";
  
  threat = find(world, event, astri);
  if (threat != world)
  {
    if (threat.classname == "player" && threat.health > 0) 
    {
      dodge_incoming(threat);
      if (self.th_runfire && infront(self.enemy) && self.tactic != 1)	 // if (self.th_runfire && visible(self.enemy) && self.tactic != 1)
      {
        self.tactic = 1;
        self.th_runfire();
        return;
      }
      return TRUE;
    }
    if (threat.owner.classname == "player") 
    {
      if (threat.owner.health < 1) 
         return FALSE;
    }
    megadeth = threat.origin - self.origin;
    if (vlen(megadeth) < 1000) 
    {
      num = fabs(threat.velocity_x) + fabs(threat.velocity_y);
      if (num > 20) 
      {
        makevectors(threat.angles);
        spot1 = threat.origin;
        traj = normalize(threat.velocity);
        spot2 = threat.origin + (traj * 1000);
        traceline(spot1, spot2, 0, threat);
        megadeth = trace_endpos - self.origin;
        if (vlen(megadeth) < 400 || trace_ent == self) 
           dodge = 1;
      }
      else 
      {
        megadeth = threat.origin - self.origin;
        blah = vlen(megadeth);
        if (blah < 300) 
	{
          if (blah < 150) 
            dodge = 2;
          else 
            dodge = 3;
        }
      }
    }
  }
  if (dodge == 0) 
     return FALSE;
  if (dodge == 1) 
     dodge_incoming(threat);
  else 
     dodge_fixed(threat, dodge);
  return TRUE;
};







void(float num) dodge_cardinalize =
{
	local vector vec;
	local float mr, t, dodge, r;
  if (num > 360) 
      num = num - 360;
  num = num + 90;
  dodge = rint(num / 90);
  r = (num / 90) - dodge;
  mr = dodge * 90;
  mr = mr - 90;
  t = mr - 90;
  if (r > 0) 
  {
    dodge = mr;
    mr = t;
    t = dodge;
  }
  if (walkmove(mr, 15) == FALSE) 
  {
    if (walkmove(t, 15) == FALSE) 
    {
      vec = VEC_ORIGIN;
      vec_y = t;
//    ai_ledgejump(vec, 0);
    }
  }
};






void(entity threat, float dodge) dodge_fixed =
{
	local vector megadeth;
	local float t, mr, num, g;
  if ((self.model == "progs/soldier.mdl") || (self.model == "progs/soldier1.mdl"))
     g = 15;
  else 
     g = 20;
  mr = 0;
  ai_face();
  if (infront(threat)) 
  {
    if (dodge == 2) 
    {
      if (walkmove(self.angles_y, g) == FALSE) 
          mr = 1;
      num = -1;				// at_ledge(self.angles, self.origin);
      if (num == 0 && self.nojump == 0) 
      {
        ai2_jump(self.angles, 200, [0 0 225]);
        return;
      }
    }
    else 
    { 
      megadeth = self.angles - [0 180 0];
      NormalizeAngles(megadeth);
      if (walkmove(megadeth_y, g) == FALSE) 
      {
        if (panicjump(megadeth)) 
            return;
        mr = 1;
        num = -1;			// at_ledge(megadeth, self.origin);
        if (num == 0 && self.nojump == 0) 
	{
          ai2_jump(megadeth, -250, [0 0 225]);
          return;
        }
      }
    }
  }
  else 
  {
    if (walkmove(self.angles_y, g) == FALSE) 
        mr = 1;
    num = -1;				// at_ledge(self.angles, self.origin);
    if (num == 0 && self.nojump == 0) 
    {
      ai2_jump(self.angles, 200, [0 0 225]);
      return;
    }
  }
  t = vectoyaw(self.origin - threat.origin);
  if (walkmove(t, g) == FALSE) 
      dodge_cardinalize(t);
};







float(entity missile, entity head) Calc_Strafemove =
{
	local vector dave, megadeth;
	local float num;

  dave = normalize(head.origin - missile.origin);
  makevectors(missile.angles);
  megadeth = normalize(v_forward * 6000);
  if (dave_y < megadeth_y) 
      num = megadeth_y - 90;
  else
      num = megadeth_y + 90;
  if (num > 360) 
      num = num - 360;
  else 
  {
    if (num < 0) 
        num = num + 360;
  }
  return num;
};







float(entity missile, entity head) Calc_Dodgemove =
{
	local vector dave, megadeth;
	local float num;

  dave = normalize(head.origin - missile.origin);
  megadeth = normalize(missile.velocity);
  if (dave_y < megadeth_y) 
      num = megadeth_y - 90;
  else 
      num = megadeth_y + 90;
  if (num > 360) 
      num = num - 360;
  else 
  {
    if (num < 0) 
        num = num + 360;
  }
  return num;
};







float(vector vec) panicjump =
{
	local vector start, end;
	local float num;

  if (self.health > 10) 
      return FALSE;
  if (self.nojump > 0) 
      return FALSE;
  vec_x = 0;
  vec_z = 0;
  if (random() < 0.4) 
  {
    vec_y = vec_y + 180;
    if (vec_y > 360) 
        vec_y = vec_y - 360;
  }
  makevectors(vec);
  end = self.origin + v_forward * 75;
  traceline(self.origin, end, 1, self);
  if (trace_fraction == 1) 
  {
    start = trace_endpos;
    end = start - [0 0 1500];
    traceline(start, end, 1, self); 
    if (trace_fraction > 0.1) 
      	return FALSE;
    num = pointcontents(trace_endpos);
    if (num < CONTENT_WATER) 
        return FALSE;
    if (num == CONTENT_WATER) 
	return FALSE;
  }
  return TRUE;
};
