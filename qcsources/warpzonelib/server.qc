// for think function
.vector warpzone_save_origin;
.vector warpzone_save_angles;
.vector warpzone_save_eorigin;
.vector warpzone_save_eangles;

// for all entities
.vector warpzone_oldorigin, warpzone_oldvelocity, warpzone_oldangles;
.float warpzone_teleport_time;
.entity warpzone_teleport_zone;

void WarpZone_StoreProjectileData(entity e)
{
	e.warpzone_oldorigin = e.origin;
	e.warpzone_oldvelocity = e.velocity;
	e.warpzone_oldangles = e.angles;
}

void WarpZone_TeleportPlayer(entity teleporter, entity player, vector to, vector to_angles, vector to_velocity)
{
	vector from;

	makevectors (to_angles);

	from = player.origin;
	setorigin (player, to);
	player.oldorigin = to; // for DP's unsticking
	player.angles = to_angles;
	player.fixangle = TRUE;
	player.velocity = to_velocity;

	BITXOR_ASSIGN(player.effects, EF_TELEPORT_BIT);

	if(player.classname == "player")
		BITCLR_ASSIGN(player.flags, FL_ONGROUND);

	WarpZone_PostTeleportPlayer_Callback(player);
}

float WarpZone_Teleported_Send(entity to, float sf)
{
	WriteByte(MSG_ENTITY, ENT_CLIENT_WARPZONE_TELEPORTED);
	WriteCoord(MSG_ENTITY, self.angles_x);
	WriteCoord(MSG_ENTITY, self.angles_y);
	WriteCoord(MSG_ENTITY, self.angles_z);
	return TRUE;
}

float WarpZone_Teleport(entity player)
{
	vector o0, a0, v0, o1, a1, v1;

	o0 = player.origin + player.view_ofs;
	v0 = player.velocity;
	a0 = player.angles;

	if(WarpZone_PlaneDist(self, o0) >= 0) // wrong side of the trigger_warpzone
		return 2;
	// no failure, we simply don't want to teleport yet; TODO in
	// this situation we may want to create a temporary clone
	// entity of the player to fix graphics glitch

	o1 = WarpZone_TransformOrigin(self, o0);
	v1 = WarpZone_TransformVelocity(self, v0);
	if(clienttype(player) != CLIENTTYPE_NOTACLIENT)
		a1 = WarpZone_TransformVAngles(self, player.v_angle);
	else
		a1 = WarpZone_TransformAngles(self, a0);

	// put him inside solid
	tracebox(o1 - player.view_ofs, player.mins, player.maxs, o1 - player.view_ofs, MOVE_NOMONSTERS, player);
	if(trace_startsolid)
	{
		vector mi, ma;
		mi = player.mins;
		ma = player.maxs;
		setsize(player, mi - player.view_ofs, ma - player.view_ofs);
		setorigin(player, o1);
		if(WarpZoneLib_MoveOutOfSolid(player))
		{
			o1 = player.origin;
			setsize(player, mi, ma);
			setorigin(player, o0);
		}
		else
		{
			print("would have to put player in solid, won't do that\n");
			setsize(player, mi, ma);
			setorigin(player, o0 - player.view_ofs);
			return 0; // cannot fix
		}
	}

	if(WarpZone_TargetPlaneDist(self, o1) <= 0)
	{
		print("inconsistent warp zones or evil roundoff error\n");
		return 0;
	}

	//print(sprintf("warpzone: %f %f %f -> %f %f %f\n", o0_x, o0_y, o0_z, o1_x, o1_y, o1_z));

	//o1 = trace_endpos;
	WarpZone_RefSys_Add(player, self);
	WarpZone_TeleportPlayer(self, player, o1 - player.view_ofs, a1, v1);
	WarpZone_StoreProjectileData(player);
	player.warpzone_teleport_time = time;
	player.warpzone_teleport_zone = self;
#ifndef WARPZONE_USE_FIXANGLE
	// instead of fixangle, send the transform to the client for smoother operation
	player.fixangle = FALSE;

	entity ts = spawn();
	setmodel(ts, "null");
	ts.SendEntity = WarpZone_Teleported_Send;
	ts.SendFlags = 0xFFFFFF;
	ts.drawonlytoclient = player;
	ts.think = SUB_Remove;
	ts.nextthink = time + 1;
	ts.owner = player;
	ts.enemy = self;
	ts.effects = EF_NODEPTHTEST;
	ts.classname = "warpzone_teleported";
	ts.angles = self.warpzone_transform;
#endif

	return 1;
}

void WarpZone_Touch (void)
{
	entity oldself, e;

	if(other.classname == "trigger_warpzone")
		return;

	// FIXME needs a better check to know what is safe to teleport and what not
	if(other.movetype == MOVETYPE_NONE)
		return;

	if(WarpZoneLib_ExactTrigger_Touch())
		return;

	e = self.enemy;
	if(WarpZone_Teleport(other))
	{
		string save1, save2;
		activator = other;

		save1 = self.target; self.target = string_null;
		save2 = self.target3; self.target3 = string_null;
		SUB_UseTargets();
		if not(self.target) self.target = save1;
		if not(self.target3) self.target3 = save2;

		oldself = self;
		self = self.enemy;
		save1 = self.target; self.target = string_null;
		save2 = self.target2; self.target2 = string_null;
		SUB_UseTargets();
		if not(self.target) self.target = save1;
		if not(self.target2) self.target2 = save2;
		self = oldself;
	}
	else
	{
		dprint("WARPZONE FAIL AHAHAHAHAH))\n");
	}
}

float WarpZone_Send(entity to, float sendflags)
{
	float f;
	WriteByte(MSG_ENTITY, ENT_CLIENT_WARPZONE);

	// we must send this flag for clientside to match properly too
	f = 0;
	if(self.warpzone_isboxy)
		BITSET_ASSIGN(f, 1);
	if(self.warpzone_fadestart)
		BITSET_ASSIGN(f, 2);
	if(self.origin != '0 0 0')
		BITSET_ASSIGN(f, 4);
	WriteByte(MSG_ENTITY, f);

	// we need THESE to render the warpzone (and cull properly)...
	if(f & 4)
	{
		WriteCoord(MSG_ENTITY, self.origin_x);
		WriteCoord(MSG_ENTITY, self.origin_y);
		WriteCoord(MSG_ENTITY, self.origin_z);
	}

	WriteShort(MSG_ENTITY, self.modelindex);
	WriteCoord(MSG_ENTITY, self.mins_x);
	WriteCoord(MSG_ENTITY, self.mins_y);
	WriteCoord(MSG_ENTITY, self.mins_z);
	WriteCoord(MSG_ENTITY, self.maxs_x);
	WriteCoord(MSG_ENTITY, self.maxs_y);
	WriteCoord(MSG_ENTITY, self.maxs_z);
	WriteByte(MSG_ENTITY, bound(1, self.scale * 16, 255));

	// we need THESE to calculate the proper transform
	WriteCoord(MSG_ENTITY, self.warpzone_origin_x);
	WriteCoord(MSG_ENTITY, self.warpzone_origin_y);
	WriteCoord(MSG_ENTITY, self.warpzone_origin_z);
	WriteCoord(MSG_ENTITY, self.warpzone_angles_x);
	WriteCoord(MSG_ENTITY, self.warpzone_angles_y);
	WriteCoord(MSG_ENTITY, self.warpzone_angles_z);
	WriteCoord(MSG_ENTITY, self.warpzone_targetorigin_x);
	WriteCoord(MSG_ENTITY, self.warpzone_targetorigin_y);
	WriteCoord(MSG_ENTITY, self.warpzone_targetorigin_z);
	WriteCoord(MSG_ENTITY, self.warpzone_targetangles_x);
	WriteCoord(MSG_ENTITY, self.warpzone_targetangles_y);
	WriteCoord(MSG_ENTITY, self.warpzone_targetangles_z);

	if(f & 2)
	{
		WriteShort(MSG_ENTITY, self.warpzone_fadestart);
		WriteShort(MSG_ENTITY, self.warpzone_fadeend);
	}

	return TRUE;
}

float WarpZone_Camera_Send(entity to, float sendflags)
{
	float f;
	WriteByte(MSG_ENTITY, ENT_CLIENT_WARPZONE_CAMERA);

	if(self.warpzone_fadestart)
		BITSET_ASSIGN(f, 2);
	if(self.origin != '0 0 0')
		BITSET_ASSIGN(f, 4);
	WriteByte(MSG_ENTITY, f);

	// we need THESE to render the warpzone (and cull properly)...
	if(f & 4)
	{
		WriteCoord(MSG_ENTITY, self.origin_x);
		WriteCoord(MSG_ENTITY, self.origin_y);
		WriteCoord(MSG_ENTITY, self.origin_z);
	}

	WriteShort(MSG_ENTITY, self.modelindex);
	WriteCoord(MSG_ENTITY, self.mins_x);
	WriteCoord(MSG_ENTITY, self.mins_y);
	WriteCoord(MSG_ENTITY, self.mins_z);
	WriteCoord(MSG_ENTITY, self.maxs_x);
	WriteCoord(MSG_ENTITY, self.maxs_y);
	WriteCoord(MSG_ENTITY, self.maxs_z);
	WriteByte(MSG_ENTITY, bound(1, self.scale * 16, 255));

	// we need THESE to calculate the proper transform
	WriteCoord(MSG_ENTITY, self.enemy.origin_x);
	WriteCoord(MSG_ENTITY, self.enemy.origin_y);
	WriteCoord(MSG_ENTITY, self.enemy.origin_z);
	WriteCoord(MSG_ENTITY, self.enemy.angles_x);
	WriteCoord(MSG_ENTITY, self.enemy.angles_y);
	WriteCoord(MSG_ENTITY, self.enemy.angles_z);

	if(f & 2)
	{
		WriteShort(MSG_ENTITY, self.warpzone_fadestart);
		WriteShort(MSG_ENTITY, self.warpzone_fadeend);
	}

	return TRUE;
}

float WarpZone_CheckProjectileImpact()
{
	// if self hit a warpzone, abort
	vector o0, v0, a0;
	float mpd, pd, dpd;
	entity wz;
	wz = WarpZone_Find(self.origin + self.mins, self.origin + self.maxs);
	if(!wz)
		return 0;
	if(self.warpzone_teleport_time == time)
	{
		// just ignore if we got teleported this frame already and now hit a wall and are in a warpzone again (this will cause a detonation)
		// print("2 warps 1 frame\n");
		return -1;
	}
	o0 = self.origin;
	v0 = self.velocity;
	a0 = self.angles;

	// this approach transports the projectile at its full speed, but does
	// not properly retain the projectile trail (but we can't retain it
	// easily anyway without delaying the projectile by two frames, so who
	// cares)
	WarpZone_TraceBox_ThroughZone(self.warpzone_oldorigin, self.mins, self.maxs, self.warpzone_oldorigin + self.warpzone_oldvelocity * frametime, MOVE_NORMAL, self, wz, WarpZone_trace_callback_t_null); // this will get us through the warpzone
	setorigin(self, trace_endpos);
	self.angles = WarpZone_TransformAngles(WarpZone_trace_transform, self.angles);
	self.velocity = WarpZone_TransformVelocity(WarpZone_trace_transform, self.warpzone_oldvelocity);
	
	// in case we are in our warp zone post-teleport, shift the projectile forward a bit
	mpd = max(vlen(self.mins), vlen(self.maxs));
	pd = WarpZone_TargetPlaneDist(wz, self.origin);
	if(pd < mpd)
	{
		dpd = normalize(self.velocity) * wz.warpzone_targetforward;
		setorigin(self, self.origin + normalize(self.velocity) * ((mpd - pd) / dpd));
		if(!WarpZoneLib_MoveOutOfSolid(self))
		{
			setorigin(self, o0);
			self.angles = a0;
			self.velocity = v0;
			return 0;
		}
	}
	WarpZone_RefSys_Add(self, wz);
	WarpZone_StoreProjectileData(self);
	self.warpzone_teleport_time = time;

	return +1;
}
float WarpZone_Projectile_Touch()
{
	float f;
	if(other.classname == "trigger_warpzone")
		return TRUE;
	if(WarpZone_Projectile_Touch_ImpactFilter_Callback())
		return TRUE;
	if((f = WarpZone_CheckProjectileImpact()) != 0)
		return (f > 0);
	if(self.warpzone_teleport_time == time)
	{
		// sequence: hit warpzone, get teleported, hit wall
		// print("2 hits 1 frame\n");
		setorigin(self, self.warpzone_oldorigin);
		self.velocity = self.warpzone_oldvelocity;
		self.angles = self.warpzone_oldangles;
		return TRUE;
	}
	return FALSE;
}

void WarpZone_InitStep_FindOriginTarget()
{
	if(self.killtarget != "")
	{
		self.aiment = find(world, targetname, self.killtarget);
		if(self.aiment == world)
		{
			error("Warp zone with nonexisting killtarget");
			return;
		}
		self.killtarget = string_null;
	}
}

void WarpZonePosition_InitStep_FindTarget()
{
	if(self.target == "")
	{
		error("Warp zone position with no target");
		return;
	}
	self.enemy = find(world, targetname, self.target);
	if(self.enemy == world)
	{
		error("Warp zone position with nonexisting target");
		return;
	}
	if(self.enemy.aiment)
	{
		// already is positioned
		error("Warp zone position targeting already oriented warpzone");
		return;
	}
	self.enemy.aiment = self;
}

void WarpZoneCamera_Think(void)
{
	if(self.warpzone_save_origin != self.origin
	|| self.warpzone_save_angles != self.angles
	|| self.warpzone_save_eorigin != self.enemy.origin
	|| self.warpzone_save_eangles != self.enemy.angles)
	{
		WarpZone_Camera_SetUp(self, self.enemy.origin, self.enemy.angles);
		self.warpzone_save_origin = self.origin;
		self.warpzone_save_angles = self.angles;
		self.warpzone_save_eorigin = self.enemy.origin;
		self.warpzone_save_eangles = self.enemy.angles;
	}
	self.nextthink = time;
}

void WarpZoneCamera_InitStep_FindTarget()
{
	entity e;
	float i;
	if(self.target == "")
	{
		error("Camera with no target");
		return;
	}
	self.enemy = world;
	for(e = world, i = 0; (e = find(e, targetname, self.target)); )
		if(random() * ++i < 1)
			self.enemy = e;
	if(self.enemy == world)
	{
		error("Camera with nonexisting target");
		return;
	}
	warpzone_cameras_exist = 1;
	WarpZone_Camera_SetUp(self, self.enemy.origin, self.enemy.angles);
	self.SendFlags = 0xFFFFFF;
	if(self.spawnflags & 2)
	{
		self.think = WarpZoneCamera_Think;
		self.nextthink = time;
	}
	else
		self.nextthink = 0;
}

void WarpZone_InitStep_UpdateTransform()
{
	vector org, ang, norm, point;
	float area;
	vector tri, a, b, c, p, q, n;
	float i_s, i_t, n_t;
	string tex;

	org = self.origin;
	if(org == '0 0 0')
		org = 0.5 * (self.mins + self.maxs);

	norm = point = '0 0 0';
	area = 0;
	for(i_s = 0; ; ++i_s)
	{
		tex = getsurfacetexture(self, i_s);
		if not(tex)
			break; // this is beyond the last one
		if(tex == "textures/common/trigger" || tex == "trigger")
			continue;
		n_t = getsurfacenumtriangles(self, i_s);
		for(i_t = 0; i_t < n_t; ++i_t)
		{
			tri = getsurfacetriangle(self, i_s, i_t);
			a = getsurfacepoint(self, i_s, tri_x);
			b = getsurfacepoint(self, i_s, tri_y);
			c = getsurfacepoint(self, i_s, tri_z);
			p = b - a;
			q = c - a;
			n =     '1 0 0' * (q_y * p_z - q_z * p_y)
			+       '0 1 0' * (q_z * p_x - q_x * p_z)
			+       '0 0 1' * (q_x * p_y - q_y * p_x);
			area = area + vlen(n);
			norm = norm + n;
			point = point + vlen(n) * (a + b + c);
		}
	}
	if(area > 0)
	{
		norm = norm * (1 / area);
		point = point * (1 / (3 * area));
		if(vlen(norm) < 0.99)
		{
			print("trigger_warpzone near ", vtos(self.aiment.origin), " is nonplanar. BEWARE.\n");
			area = 0; // no autofixing in this case
		}
		norm = normalize(norm);
	}

	if(self.aiment)
	{
		org = self.aiment.origin;
		ang = self.aiment.angles;
		if(area > 0)
		{
			org = org - ((org - point) * norm) * norm; // project to plane
			makevectors(ang);
			if(norm * v_forward < 0)
			{
				print("Position target of trigger_warpzone near ", vtos(self.aiment.origin), " points into trigger_warpzone. BEWARE.\n");
				norm = -1 * norm;
			}
			ang = vectoangles(norm, v_up); // keep rotation, but turn exactly against plane
			ang_x = -ang_x;
			if(norm * v_forward < 0.99)
				print("trigger_warpzone near ", vtos(self.aiment.origin), " has been turned to match plane orientation (", vtos(self.aiment.angles), " -> ", vtos(ang), "\n");
			if(vlen(org - self.aiment.origin) > 0.5)
				print("trigger_warpzone near ", vtos(self.aiment.origin), " has been moved to match the plane (", vtos(self.aiment.origin), " -> ", vtos(org), ").\n");
		}
	}
	else if(area > 0)
	{
		org = point;
		ang = vectoangles(norm);
		ang_x = -ang_x;
	}
	else
		error("cannot infer origin/angles for this warpzone, please use a killtarget or a trigger_warpzone_position");

	self.warpzone_origin = org;
	self.warpzone_angles = ang;
}

void WarpZone_InitStep_ClearTarget()
{
	if(self.enemy)
		self.enemy.enemy = world;
	self.enemy = world;
}

entity warpzone_first; .entity warpzone_next;
void WarpZone_InitStep_FindTarget()
{
	float i;
	entity e, e2;

	if(self.enemy)
		return;

	// this way only one of the two ents needs to target
	if(self.target != "")
	{
		self.enemy = self; // so the if(!e.enemy) check also skips self, saves one IF

		e2 = world;
		for(e = world, i = 0; (e = find(e, targetname, self.target)); )
			if(!e.enemy)
				if(e.classname == self.classname) // possibly non-warpzones may use the same targetname!
					if(random() * ++i < 1)
						e2 = e;
		if(!e2)
		{
			self.enemy = world;
			error("Warpzone with non-existing target");
			return;
		}
		self.enemy = e2;
		e2.enemy = self;
	}
}

void WarpZone_Think();
void WarpZone_InitStep_FinalizeTransform()
{
	if(!self.enemy || self.enemy.enemy != self)
	{
		error("Invalid warp zone detected. Killed.");
		return;
	}

	warpzone_warpzones_exist = 1;
	WarpZone_SetUp(self, self.warpzone_origin, self.warpzone_angles, self.enemy.warpzone_origin, self.enemy.warpzone_angles);
	self.touch = WarpZone_Touch;
	self.SendFlags = 0xFFFFFF;
	if(self.spawnflags & 2)
	{
		self.think = WarpZone_Think;
		self.nextthink = time;
	}
	else
		self.nextthink = 0;
}

float warpzone_initialized;
entity warpzone_first;
entity warpzone_position_first;
entity warpzone_camera_first;
.entity warpzone_next;
void spawnfunc_misc_warpzone_position(void)
{
	// "target", "angles", "origin"
	self.warpzone_next = warpzone_position_first;
	warpzone_position_first = self;
	if (self.link)
		self.movetype = MOVETYPE_NOCLIP;
}
void spawnfunc_trigger_warpzone_position(void)
{
	spawnfunc_misc_warpzone_position();
}
void spawnfunc_trigger_warpzone(void)
{
	// warp zone entities must have:
	// "killtarget" pointing to a target_position with a direction arrow
	//              that points AWAY from the warp zone, and that is inside
	//              the warp zone trigger
	// "target"     pointing to an identical warp zone at another place in
	//              the map, with another killtarget to designate its
	//              orientation
	precache_model("null");
	
	if(!self.scale)
		self.scale = self.modelscale;
	if(!self.scale)
		self.scale = 1;
	string m;
	m = self.model;
	WarpZoneLib_ExactTrigger_Init();
 	if(m != "")
 	{
 		precache_model(m);
 		setmodel(self, m); // no precision needed
	}
	setorigin(self, self.origin);
	if(self.scale)
		setsize(self, self.mins * self.scale, self.maxs * self.scale);
	else
		setsize(self, self.mins, self.maxs);
	self.SendEntity = WarpZone_Send;
	self.SendFlags = 0xFFFFFF;
	BITSET_ASSIGN(self.effects, EF_NODEPTHTEST);
	self.warpzone_next = warpzone_first;
	warpzone_first = self;
	if (self.link)
		self.movetype = MOVETYPE_NOCLIP;

}
void spawnfunc_func_camera(void)
{
	if(!self.scale)
		self.scale = self.modelscale;
	if(!self.scale)
		self.scale = 1;
 	if(self.model != "")
 	{
 		precache_model(self.model);
 		setmodel(self, self.model); // no precision needed
	}
	setorigin(self, self.origin);
	if(self.scale)
		setsize(self, self.mins * self.scale, self.maxs * self.scale);
	else
		setsize(self, self.mins, self.maxs);
	if(!self.solid)
		self.solid = SOLID_BSP;
	else if(self.solid < 0)
		self.solid = SOLID_NOT;
	self.SendEntity = WarpZone_Camera_Send;
	self.SendFlags = 0xFFFFFF;
	self.warpzone_next = warpzone_camera_first;
	warpzone_camera_first = self;
	if (self.link)
		self.movetype = MOVETYPE_NOCLIP;

}
void WarpZones_Reconnect()
{
	entity e;
	e = self;
	for(self = warpzone_first; self; self = self.warpzone_next)
		WarpZone_InitStep_ClearTarget();
	for(self = warpzone_first; self; self = self.warpzone_next)
		WarpZone_InitStep_FindTarget();
	for(self = warpzone_camera_first; self; self = self.warpzone_next)
		WarpZoneCamera_InitStep_FindTarget();
	for(self = warpzone_first; self; self = self.warpzone_next)
		WarpZone_InitStep_FinalizeTransform();
	self = e;
}

void WarpZone_Think()
{
	if(self.warpzone_save_origin != self.origin
	|| self.warpzone_save_angles != self.angles
	|| self.warpzone_save_eorigin != self.enemy.origin
	|| self.warpzone_save_eangles != self.enemy.angles)
	{
		entity oldself;
		oldself = self;
		WarpZone_InitStep_UpdateTransform();
		self = self.enemy;
		WarpZone_InitStep_UpdateTransform();
		self = oldself;
		WarpZone_InitStep_FinalizeTransform();
		self = self.enemy;
		WarpZone_InitStep_FinalizeTransform();
		self = oldself;
		self.warpzone_save_origin = self.origin;
		self.warpzone_save_angles = self.angles;
		self.warpzone_save_eorigin = self.enemy.origin;
		self.warpzone_save_eangles = self.enemy.angles;
	}
	self.nextthink = time;
}

void WarpZone_StartFrame()
{
	entity e;
	if(warpzone_initialized == 0)
	{
		warpzone_initialized = 1;
		e = self;
		for(self = warpzone_first; self; self = self.warpzone_next)
			WarpZone_InitStep_FindOriginTarget();
		for(self = warpzone_position_first; self; self = self.warpzone_next)
			WarpZonePosition_InitStep_FindTarget();
		for(self = warpzone_first; self; self = self.warpzone_next)
			WarpZone_InitStep_UpdateTransform();
		self = e;
		WarpZones_Reconnect();
	}

	if(warpzone_warpzones_exist)
	{
		entity oldself, oldother;
		oldself = self;
		oldother = other;
		for(e = world; (e = nextent(e)); )
		{
			WarpZone_StoreProjectileData(e);
			float f;
			f = clienttype(e);
			if(f == CLIENTTYPE_REAL)
			{
				if(e.solid != SOLID_NOT) // not spectating?
					continue;
				if(e.movetype != MOVETYPE_NOCLIP && e.movetype != MOVETYPE_FLY) // not spectating? (this is to catch observers)
					continue;
				self = WarpZone_Find(e.origin + e.mins, e.origin + e.maxs);
				if(!self)
					continue;
				other = e;
				if(WarpZoneLib_ExactTrigger_Touch())
					continue;
				WarpZone_Teleport(e); // NOT triggering targets by this!
			}
			if(f == CLIENTTYPE_NOTACLIENT)
			{
				for(; (e = nextent(e)); )
					WarpZone_StoreProjectileData(e);
				break;
			}
		}
		self = oldself;
		other = oldother;
	}
}

.float warpzone_reconnecting;
float visible_to_some_client(entity ent)
{
	entity e;
	for(e = nextent(world); clienttype(e) != CLIENTTYPE_NOTACLIENT; e = nextent(e))
		if(e.classname == "player" && clienttype(e) == CLIENTTYPE_REAL)
			if(checkpvs(e.origin + e.view_ofs, ent))
				return 1;
	return 0;
}
void trigger_warpzone_reconnect_use()
{
	entity e;
	e = self;
	// NOTE: this matches for target, not targetname, but of course
	// targetname must be set too on the other entities
	for(self = warpzone_first; self; self = self.warpzone_next)
		self.warpzone_reconnecting = ((e.target == "" || self.target == e.target) && !((e.spawnflags & 1) && (visible_to_some_client(self) || visible_to_some_client(self.enemy))));
	for(self = warpzone_camera_first; self; self = self.warpzone_next)
		self.warpzone_reconnecting = ((e.target == "" || self.target == e.target) && !((e.spawnflags & 1) && visible_to_some_client(self)));
	for(self = warpzone_first; self; self = self.warpzone_next)
		if(self.warpzone_reconnecting)
			WarpZone_InitStep_ClearTarget();
	for(self = warpzone_first; self; self = self.warpzone_next)
		if(self.warpzone_reconnecting)
			WarpZone_InitStep_FindTarget();
	for(self = warpzone_camera_first; self; self = self.warpzone_next)
		if(self.warpzone_reconnecting)
			WarpZoneCamera_InitStep_FindTarget();
	for(self = warpzone_first; self; self = self.warpzone_next)
		if(self.warpzone_reconnecting || self.enemy.warpzone_reconnecting)
			WarpZone_InitStep_FinalizeTransform();
	self = e;
}

void spawnfunc_trigger_warpzone_reconnect()
{
	self.use = trigger_warpzone_reconnect_use;
}

void spawnfunc_target_warpzone_reconnect()
{
	spawnfunc_trigger_warpzone_reconnect(); // both names make sense here :(
}

void WarpZone_PlayerPhysics_FixVAngle(void)
{
#ifndef WARPZONE_DONT_FIX_VANGLE
	if(clienttype(self) == CLIENTTYPE_REAL)
	if(self.v_angle_z <= 360) // if not already adjusted
	if(time - self.ping * 0.001 < self.warpzone_teleport_time)
	{
		self.v_angle = WarpZone_TransformVAngles(self.warpzone_teleport_zone, self.v_angle);
		self.v_angle_z += 720; // mark as adjusted
	}
#endif
}
