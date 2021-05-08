/***********************************************
*                                              *
*             FrikBot Waypoints                *
*         "The better than roaming AI"         *
*                                              *
***********************************************/

/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Waypoint Linking code

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

.entity target1;
.entity target2;
.entity target3;
.entity target4;
float WAYPOINT_MODE; 
float WAYPOINTS;
// 0 = Try the cfg load first, 1 = Dynamic, 2 = Loaded or Manual or Off
// Returns TRUE if the two ents are linked.
// FALSE if not

float (entity e1, entity e2) CheckLinked =
{
	if (e1.target1 == e2)
		return TRUE;
	else if (e1.target2 == e2)
		return TRUE;
	else if (e1.target3 == e2)
		return TRUE;
	else if (e1.target4 == e2)
		return TRUE;
	else if (e2.target1 == e1)
		return TRUE;
	else if (e2.target2 == e1)
		return TRUE;
	else if (e2.target3 == e1)
		return TRUE;
	else if (e2.target4 == e1)
		return TRUE;
	else return FALSE;
};

void(entity ent) WaypointPriority =
{
	local entity t;
	t = find(world, classname, "waypoint");
	while(t != world)
	{
		if (CheckLinked(ent, t))
			t.priority = t.priority + 15;
		t = find(t, classname, "waypoint");
	}
};


// Links two waypoints......
// This function normally returns TRUE
// only false if it can't link the two waypoints
// that will be rare (cross fingers)

float (entity e1, entity e2) LinkWays =
{
	if (CheckLinked(e1, e2))
		return FALSE; // already linked!!!

	if (e1.target1 == world)
	{
		e1.target1 = e2;
		return TRUE;
	}
	else if (e1.target2 == world)
	{
		e1.target2 = e2;
		return TRUE;
	}
	else if (e1.target3 == world)
	{
		e1.target3 = e2;
                return TRUE;
	}
	else if (e1.target4 == world)
	{
		e1.target4 = e2;
		return TRUE;
	}
	else if (e2.target1 == world)
	{
		e2.target1 = e1;
		return TRUE;
	}
	else if (e2.target2 == world)
	{
		e2.target2 = e1;
		return TRUE;
	}
	else if (e2.target3 == world)
	{
		e2.target3 = e1;
		return TRUE;
	}
	else if (e2.target4 == world)
	{
		e2.target4 = e1;
		return TRUE;
	}
	else return FALSE;

};
/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Waypoint Spawning Code

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

entity() FindWayPoint =// return closest, visible waypoint
{
	local entity t;
	local float dst, tdst;
	local entity best;
	t = find(world, classname, "waypoint");
	dst = 100000;
	best = t;
	while(t != world)
	{
		tdst = vlen(t.origin - self.origin);
                if ((tdst < dst) && (visible(t)))
		{
			dst = tdst;
			best = t;
		} else if (tdst <  64)
		{
			dst = 1; // too damn close!
			best = self;
		}
		t = find(t, classname, "waypoint");
	} 
	return best;
};

entity(vector org) make_waypoint = 
{
	local entity point;
	point = spawn();
	point.classname = "waypoint";
	point.search_time = time + 15; // don't double back for me;
	point.solid = SOLID_TRIGGER;
	point.movetype = MOVETYPE_NONE;
	setorigin(point, org);
	
	setsize(point, VEC_HULL_MIN, VEC_HULL_MAX); // FIXME: convert these to numerical

	WAYPOINTS = WAYPOINTS + 1;
	//bprint(ftos(WAYPOINTS));
	//bprint("\n");
	point.count = WAYPOINTS;
	//setmodel(point, "progs/s_bubble.spr"); // DEBUG
	return point;
};
void() DynamicWaypoint =
{
	if (WAYPOINT_MODE != 1)
		return;
	else if (fMaxClients < 2) // don't waypoint in SP
		return;
	else if (!((self.flags & FL_ONGROUND) || self.waterlevel == 3))
		return;
	local entity newp;

	newp = FindWayPoint();
	
       if (vlen(newp.origin - self.origin) < 256)
	{
		if (newp != self) // point = self when dist < 128
		{
			if (newp != self.target1)
			{
				LinkWays(newp, self.target1);
			}
			self.target1 = newp;
			self.ldest1 = self.origin + self.view_ofs;

		}
		return;
	}

	newp = make_waypoint(self.ldest1);
	if (!visible(newp))
		setorigin(newp, self.origin + self.view_ofs);
	else
		LinkWays(self.target1, newp);
	self.ldest1 = self.origin + self.view_ofs;

};
/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Temporary Marker code

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/

void() TempWay_Remove =
{
	if (self.goalentity.temp_way = self)
		self.goalentity.temp_way = world;
	if (self.goalentity.goalentity = self)
		self.goalentity.goalentity = world;
	remove(self);
};

void(vector org, float prior) SpawnTempWaypoint =
{	
	local entity tep;

	if (self.temp_way.classname == "temp_waypoint")
		tep = self.temp_way;
	else
		tep = spawn();
	self.temp_way = tep;
	tep.classname = "temp_waypoint";
	tep.search_time = 0;
	tep.think = TempWay_Remove;
	tep.nextthink = time + 6;
	tep.goalentity = self;
	tep.solid = SOLID_TRIGGER;
	tep.movetype = MOVETYPE_NONE;
	tep.priority = prior;
	tep.search_time = 0;
        setorigin(tep, org);
	self.goalentity = tep;
	self.enemy = world;
	self.search_time = time + 6;
	
	setsize(tep, VEC_HULL_MIN, VEC_HULL_MAX); // FIXME: convert these to numerical
	//setmodel (tep, "progs/h_player.mdl"); // DEBUG
};


/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Waypoint Loading from file

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/
void() LoadWaypoint = 
{
	local vector org;
	local entity tep;
	org_x = cvar("saved1");
	org_y = cvar("saved2");
	org_z = cvar("saved3");
	tep = make_waypoint(org);
	// I know this looks weirder than hell, but
	// the deal is, I can't restore links until all the ways are spawned

	tep.missile_speed = cvar("scratch1");
	tep.chat_subj = cvar("scratch2");
	tep.keys = cvar("scratch3");
	tep.tfrags = cvar("scratch4");
};

void() ClearAllWays =
{

	local entity t;
	t= find(world,classname, "waypoint");
	while(t != world)
	{
		remove(t);
		t = find(t, classname, "waypoint");
	}
	WAYPOINTS = 0;
};
void() FixNumbers =
{
	local entity t;
	WAYPOINTS = 0;

	t= find(world,classname, "waypoint");
	while(t != world)
	{
		WAYPOINTS = WAYPOINTS + 1;
		t.count = WAYPOINTS;
		t = find(t, classname, "waypoint");
	}

};
entity(float num) WaypointForNum =
{
	local entity t;
	t = find(world, classname, "waypoint");
	while (t != world)
	{
		if (t.count == num)
			return t;
		t = find(t, classname, "waypoint");
	}
};

void() FixWaypoints =
{
	//FixNumbers();
	local entity tep;
	tep = find(world, classname, "waypoint");
	while (tep != world)
	{
		tep.target1 = WaypointForNum(tep.missile_speed);
		tep.target2 = WaypointForNum(tep.chat_subj);
		tep.target3 = WaypointForNum(tep.keys);
		tep.target4 = WaypointForNum(tep.tfrags);

		tep = find(tep, classname, "waypoint");
	}

	bprint("waypoints loaded\n");


};

void() WaypointWatch =
{
	local float g;
	g = cvar("saved4");
	if (g != 0)
	{
		cvar_set("saved4", "0");
		if (g == 1)
			ClearAllWays();
		else if (g == 3)
		{
			FixWaypoints();
			return;
		}
		LoadWaypoint();
		WAYPOINT_MODE = 2;
	}
	else if (WAYPOINT_MODE == 0)
	{
		localcmd("exec maps/");
		localcmd(mapname);
		localcmd(".way\n");
		WAYPOINT_MODE = 1;
	}

};
/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Waypoint Saving to file

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
*/
void() DumpWaypoints =
{
	local entity t;
	bprint("// begin waypoint dump - maps/");
	bprint(mapname);
	bprint(".way\n");
	FixNumbers();
	t = find(world, classname, "waypoint");
	while(t != world)
	{
		bprint("// waypoint ");
		bprint(ftos(t.count));
		bprint("\n");

		bprint("saved1 ");
		bprint(ftos(t.origin_x));
		bprint("; saved2 ");
		bprint(ftos(t.origin_y));
		bprint("; saved3 ");
		bprint(ftos(t.origin_z));

		bprint("\nscratch1 ");
		bprint(ftos(t.target1.count));
		bprint("; scratch2 ");
		bprint(ftos(t.target2.count));
		bprint("; scratch3 ");
		bprint(ftos(t.target3.count));
		bprint("; scratch4 ");
		bprint(ftos(t.target4.count));

		if (t.count != 1)
			bprint("\nsaved4 2");
		else 
			bprint("\nsaved4 1");
		bprint ("; wait\n");
		t = find(t, classname, "waypoint");

	}
	bprint("saved4 3\n// end waypoint dump\n");


};


