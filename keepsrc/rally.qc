//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: Qmaster, inspired by Halo and using Quake Rally as a base.
//
//
// Distribution / Copyright / Permissions 
//
// Please do not use any of these assets in ANY COMMERCIAL PROJECT.
// and remember to give credit if you use any of these assets. Please credit
// the appropriate authors of the various content used.  Refer to the credits
// folder.
//				  
// The QC files in this MOD are based on 1.06 source files by ID Software.
// These files are released under the terms of GNU General Public License v2 or
// later. You may use the source files as a base to build your own MODs as long
// as you release them under the same license and make the source available.
// Please also give proper credit. Check http://www.gnu.org for details.
//
// Quake is a registered trademark of id Software, Inc.
//
// All of these resources may be electronically distributed only at 
// NO CHARGE to the recipient.
//
// Stats:
// Entity count: 
// Function count: 
// Implements: Vehicles
//
// Description:
// Vehicles that you can enter and use until they are destroyed, or jump to get
// out of.  Provides animations for vehicle models, firing vehicle-mounted
// weapons, and general driving with noises.
//=============================================================================

void() item_rallycar_touch;

void() item_rallycar_realign = { // [FUNCTION]
	ChangeYaw();
	self.think = SUB_Null;
};

void() HonkHorn = { // [FUNCTION]
	if (!(self.flags & FL_CLIENT)) return;
	if (!self.in_a_vehicle) { sprint(self,"Not in a vehicle, can't honk horn\n"); return; }

    if (self.wing_sound < time) {
        self.wing_sound = time + 0.2;
		sound(self,CHAN_VOICE,"qrally/meepmeep.wav",1,ATTN_NORM);
	}
};

void() vehicle_death = {
	self.think = SUB_Remove;
	self.nextthink = time + 0.1;
};

void(float jump, float destroy) TakePlayerOutOfVehicle = { // [FUNCTION]
	local float oldChaseBack, oldChaseSetting;
	local entity vehicle;

	if (!self) return;
	if (!(self.flags & FL_CLIENT)) return;
	if (!self.in_a_vehicle) return;

	oldChaseSetting = decode(cvar("scratch2"),LOW8);
	oldChaseBack = decode(cvar("scratch2"),MID8);
	self.in_a_vehicle = FALSE;
	self.modelindex = modelindex_player;
	localcmd("chase_active ");
	localcmd(ftos(oldChaseSetting));
	localcmd("\n");
	localcmd("chase_back ");
	localcmd(ftos(oldChaseBack));
	localcmd("\n");
	cvar_set("scratch2","0");
	if (destroy) {
		if (self.vehicleattachment) {
			self.vehicleattachment.think = vehicle_death;
			self.vehicleattachment.nextthink = time + 0.1;
			self.vehicleattachment = world;
		}
	} else { // Preserve the vehicle separately.
		vehicle = spawn();
		setorigin(vehicle,self.origin); // do before jumping
		vehicle.skin = self.vehicle_skindex;
		vehicle.solid = SOLID_TRIGGER;
		vehicle.touch = item_rallycar_touch;
		vehicle.scale = 2;
		setmodel(vehicle,self.vehicle_model);
		setsize(vehicle,VEC_HULL2_MIN,VEC_HULL2_MAX);
		vehicle.pain_finished = time + 5; // prevent re-entry for a bit
		vehicle.ideal_yaw = self.angles_y;
		vehicle.think = item_rallycar_realign;
		vehicle.nextthink = time + 0.1;
	}
	self.health = self.turrethealth; // Restore health
	self.max_health = self.turrethealth2;
	self.armorvalue = self.turrettimer;
	self.turrethealth = self.turrethealth2 = self.turrettimer = 0;
	self.flags = self.flags - (self.flags & FL_JUMPRELEASED); // Very precise order for this, Jumprelease and then onground
	self.flags = self.flags - FL_ONGROUND;	// don't stairwalk
	self.button2 = 0;
	if (jump) {
		if (self.shroom_finished > time) sound(self,CHAN_BODY,"qmaster/player/jumpmario.wav",1,ATTN_NORM);
		else sound (self, CHAN_BODY, SOUND_PLAYER_JUMP, 1, ATTN_NORM); // player jumping sound

		self.velocity_z = self.velocity_z + map_jumpheight;
		makevectors (self.v_angle);
		self.velocity = self.velocity + (v_right * -80);
		if (self.shroom_finished > time) self.velocity_z = self.velocity_z + SHROOM_JUMP_BOOST; // Big Jump for Big Dude!
	}
};

void(entity targ, float jump, float destroy) TakeTargetOutOfVehicle = { // [FUNCTION]
	local entity stemp;

	stemp = self;
	self = targ;
	TakePlayerOutOfVehicle(jump, destroy);
	self = stemp;
}

/*
void() rally_centre = [0, rally_centre] {};

void() rally_right10 = [1, rally_right10] {};
void() rally_right20 = [2, rally_right20] {};
void() rally_right30 = [3, rally_right30] {};

void() rally_left10 = [4, rally_left10] {};
void() rally_left20 = [5, rally_left20] {};
void() rally_left30 = [6, rally_left30] {};

void() steer_centre = [11, steer_centre] { self.weaponframe = 5; };

void() steer_right10 = [12, steer_right10] { self.weaponframe = 6; };
void() steer_right20 = [13, steer_right20] { self.weaponframe = 7;};
void() steer_right30 = [14, steer_right30] { self.weaponframe = 8; };
void() steer_right40 = [15, steer_right40] { self.weaponframe = 9; };

void() steer_left10 = [7, steer_left10] { self.weaponframe = 1; };
void() steer_left20 = [8, steer_left20] { self.weaponframe = 2; };
void() steer_left30 = [9, steer_left30] { self.weaponframe = 3; };
void() steer_left40 = [10, steer_left40] { self.weaponframe = 4; };

float(float a1, float a2) angle_diff = {
	if (a2 > a1) {
		if (a2 - a1 > 180) {
			return a1 - (a2 - 360);
		} else {
			return a1 - a2;
		}
	} else {
		if (a1 - a2 > 180) {
			return a1 - (a2 + 360);
		} else {
			return a1 - a2;
		}
	}
};

entity(vector vec_min, vector vec_max) SpawnPart = {
	local entity w;
	local vector vect_offset_fwd, vect_offset_side;

	w = spawn();
	w.angles = self.angles;
	w.solid = SOLID_NOT;
	w.movetype = MOVETYPE_NOCLIP;
	setsize(w, vec_min, vec_max);
	setorigin(w, self.origin + '0 0 4');
	w.owner = self;
	w.velocity = '0 0 0';
	w.flags = FL_ONGROUND;
	return w;
};

void() SetCarDetails = {
	if (self.rwhl != world) self.rwhl.frame = 0;

	if (self.car_index <= 2) {
		self.num_skins = 2;
		self.veh_body.skin = self.skin;
		self.fwhl_offset_y = 6;
		self.rwhl_offset_y = -26.5;
		self.fwhl_offset_z = -2;
		self.rwhl_offset_z = -2;
		if (!cvar("deathmatch") && rally_type_index == 1) {
			setmodel(self.veh_body, "progs/qrally/sumacar.mdl");
		} else {
			setmodel(self.veh_body, "progs/qrally/sumabase.mdl");
			self.basemodel = self.veh_body.modelindex;
		}
		spawn_tfog(self.veh_body.origin);
		if (self.classname == "player") {
			if (self.skin == 0) {
				centerprint(self, "Stock Car selected");
			} else {
				centerprint(self, "Commodore selected");
			}
		}
	} else if (self.car_index == 3) {
		self.num_skins = 1;
		self.veh_body.skin = self.skin;
		self.fwhl_offset_y = 6;
		self.rwhl_offset_y = -26.5;
		self.fwhl_offset_z = -2;
		self.rwhl_offset_z = -2;
		if (self.classname == "player") {
			centerprint(self, "4WD Hatchback selected");
		}
		if (!cvar("deathmatch") && rally_type_index == 1) {
			setmodel(self.veh_body, "progs/qrally/zumacar.mdl");
		} else {
			setmodel(self.veh_body, "progs/qrally/zumabase.mdl");
			self.basemodel = self.veh_body.modelindex;
		}
		spawn_tfog(self.veh_body.origin);
	} else if (self.car_index == 4) {
		self.num_skins = 2;
		self.veh_body.skin = self.skin;
		self.fwhl_offset_y = 6;
		self.rwhl_offset_y = -22;
		self.fwhl_offset_z = -2;
		self.rwhl_offset_z = -2;
		if (!cvar("deathmatch") && rally_type_index == 1) {
			setmodel(self.veh_body, "progs/qrally/mycar.mdl");
		} else {
			setmodel(self.veh_body, "progs/qrally/mgnabase.mdl");
			self.basemodel = self.veh_body.modelindex;
		}
		if (self.rwhl != world) self.rwhl.frame = 7;

		spawn_tfog(self.veh_body.origin);
		if (self.classname == "player") {
			if (self.skin == 0) {
				centerprint(self, "Magna selected");
			} else {
				centerprint(self, "BMW Z3 selected");
			}
		}
	} else if (self.car_index == 5) {
		self.num_skins = 2;
		self.veh_body.skin = self.skin;
		self.fwhl_offset_y = 6;
		self.rwhl_offset_y = -26.5;
		self.fwhl_offset_z = -2;
		self.rwhl_offset_z = -2;
		if (!cvar("deathmatch") && rally_type_index == 1) {
			setmodel(self.veh_body, "progs/qrally/triton.mdl");
		} else {
			setmodel(self.veh_body, "progs/qrally/tritbase.mdl");
			self.basemodel = self.veh_body.modelindex;
		}
		spawn_tfog(self.veh_body.origin);
		if (self.classname == "player") {
			if (self.skin == 0) {
				centerprint(self, "Triton selected");
			} else {
				centerprint(self, "Hilux selected");
			}
		}
	}
	if (rally_type_index > 1) W_SetCurrentAmmo();
};

void(entity plyr) CallClientPrefs = {
	local entity oself;

	if (plyr.classname != "player") return;

	oself = self;
	self = plyr;
	if (!(self.client_settings & CS_CAM)) {
		stuffcmd(plyr, "setcam\n");
		self.client_settings = self.client_settings | CS_CAM;
	} else {
		if (!(self.client_settings & CS_WHEEL)) {
			stuffcmd(plyr, "setwheel\n");
			self.client_settings = self.client_settings | CS_WHEEL;
		} else {
			if (!(self.client_settings & CS_CAR)) {
				stuffcmd(plyr, "setcar\n");
				self.client_settings = self.client_settings | CS_CAR;
			} else {
				if (!(self.client_settings & CS_ZOOM)) {
					stuffcmd(plyr, "setzoom\n");
					self.client_settings = self.client_settings | CS_ZOOM;
				} 	else {
					if (!(self.client_settings & CS_TRACKING)) {
						stuffcmd(plyr, "settracking\n");
						self.client_settings = self.client_settings | CS_TRACKING;
					}
				}
			}
		}
	}
	self = oself;
};

entity() FindFirstMarker = {
	local entity trav;

	while ((trav = find(trav, classname, "rally_marker")) != world) {
		if (trav.ammo_shells == 1) return trav;
	}
	return world;
};

void() angle_think = {
	msg_entity = self.owner;
	WriteByte(MSG_ONE, SVC_SETVIEW);
	WriteEntity(MSG_ONE, self.owner.chasecam);
	WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
	WriteAngle(MSG_ONE, 20);
	WriteAngle(MSG_ONE, msg_entity.angles_y);
	WriteAngle(MSG_ONE, msg_entity.angles_z);
	stuffcmd(msg_entity, "+mlook\n");
	stuffcmd(msg_entity, "cl_movespeedkey 1\n");
	stuffcmd(msg_entity, "cl_anglespeedkey 1.5\n");
	stuffcmd(msg_entity, "cl_forwardspeed 2300\n");
	stuffcmd(msg_entity, "cl_rollangle 0\n");
	stuffcmd(msg_entity, "cl_sidespeed 0\n");
	stuffcmd(msg_entity, "cl_backspeed 0\n");
	stuffcmd(msg_entity, "cl_bob 0\n");
	sprint(msg_entity, "-----------------------------------\n");
	sprint(msg_entity, " Welcome to QuakeRally!       v1.2 \n");
	sprint(msg_entity, " Brought to you by the IMPACT TEAM \n");
	sprint(msg_entity, "  ->  http://impact.frag.com  <-   \n");
	sprint(msg_entity, "-----------------------------------\n");
	CallClientPrefs(self.owner);
	if (rally_type_index < 3) {
		self.owner.next_marker = FindFirstMarker();
	}
	remove(self);
};

void() fade_to_normal = {
	local string intensity;
	self.speed = self.speed - 250 * (time - self.last_idle);
	if (self.speed < 0) self.speed = 0;
	intensity = ftos(self.speed);
	stuffcmd(self.owner, "v_cshift 0 0 0 ");
	stuffcmd(self.owner, intensity);
	stuffcmd(self.owner, "\n");
	if (self.speed == 0) { remove(self); return; }

	self.last_idle = time;
	self.nextthink = time + 0.2;
};

void() CreateVehicleEntities = {
	local entity tail, body, hl, w, angle_think_ent;
	local vector plyrBoxMin, plyrBoxMax, cam_angles;

	cvar_set("cl_rollangle", "0");
	cvar_set("cl_bob", "0");
	if (self.classname == "player") {
		w = spawn();
		w.speed = 254;
		w.owner = self;
		w.last_idle = time;
		w.think = fade_to_normal;
		w.nextthink = time + 0.5;
	}
	lose_speed_on_slide = 0;
	self.is_racer = "yes";
	if (self.classname == "rally_bot") self.car_index = floor(random() * 3.9) + 2;
	if ((tail = SpawnPart(VEC_HULL_MIN * 0.5, VEC_HULL_MAX * 0.5)) != world) {
		tail.classname = "veh_tail";
		tail.movetype = MOVETYPE_FLY;
		makevectors(self.angles);
		setorigin(tail, self.origin - v_forward * TAIL_DIST + '0 0 1');
		tail.veh_dir = '0 1 0';
		tail.yaw_speed = REAR_TRACTION;
		plyrBoxMin_x = -1;
		plyrBoxMin_y = -1;
		plyrBoxMin_z = VEC_HULL_MIN_Z;
		plyrBoxMax_x = 1;
		plyrBoxMax_y = 1;
		plyrBoxMax_z = VEC_HULL_MAX_z;
		setsize(tail, plyrBoxMin, plyrBoxMax);
		tail.slide_ratio = 0;
		self.veh_tail = tail;
	}
	if ((body = SpawnPart(VEC_HULL_MIN, VEC_HULL_MAX)) != world) {
		body.classname = "veh_body";
		self.veh_body = body;
		SetCarDetails();
		if (self.classname != "rally_bot") self.car_index = 3;
		setorigin(body, body.origin + VEH_BODY_OFFSET);
		self.veh_body.angles = '0 0 0';
		self.veh_body.avelocity = '0 0 0';
		self.veh_body.roll_velocity = '0 0 0';
		self.veh_body.veh_dir = '0 0 0';
	} else {
		bprint("couldn't create vehicle body\n");
	}
	if (!cvar("deathmatch")) {
		if ((w = SpawnPart(VEH_WHEEL_MIN, VEH_WHEEL_MAX)) != world) {
			w.classname = "veh_wheel";
			setmodel(w, "progs/qrally/fwhl.mdl");
			self.fwhl = w;
		}
		if ((w = SpawnPart(VEH_WHEEL_MIN, VEH_WHEEL_MAX)) != world) {
			w.classname = "veh_wheel";
			setmodel(w, "progs/qrally/fwhl.mdl");
			self.rwhl = w;
			if (self.car_index == 4) w.frame = 7;
		}
	}
	if (challenge == 2 || !deathmatch) {
		self.racing_flags = self.racing_flags | QR_HEADLIGHTS_ON;
		if ((hl = spawn()) != world) {
			hl.classname = "veh_headlight";
			hl.owner = self;
			setsize(hl, '0 0 0', '0 0 0');
			setmodel(hl, "progs/null.mdl");
			if (challenge == 2) hl.effects = EF_DIMLIGHT;
			self.hl_r = hl;
		}
		if ((hl = spawn()) != world) {
			hl.classname = "veh_headlight";
			hl.owner = self;
			setsize(hl, '0 0 0', '0 0 0');
			setmodel(hl, "progs/null.mdl");
			if (challenge == 2) hl.effects = EF_DIMLIGHT;
			self.hl_l = hl;
		}
		if ((hl = spawn()) != world) {
			hl.classname = "veh_headlight";
			hl.owner = self;
			setsize(hl, '0 0 0', '0 0 0');
			setmodel(hl, "progs/null.mdl");
			if (challenge == 2) hl.effects = EF_DIMLIGHT;
			self.hl_m = hl;
		}
	}
	self.last_jump_touch = 0;
	self.last_prevsurf;
	self.prev_surfangle1 = 0;
	self.prev_surfangle2 = 0;
	self.prev_surfangle3 = 0;
	self.prev_surfangle4 = 0;
	self.prev_surfangle5 = 0;
	droptofloor();
	makevectors(self.angles);
	self.oldorigin = self.origin - v_forward * 8;
	self.veh_tail.veh_dir = v_forward;
	setorigin(self.veh_tail, self.origin - v_forward * TAIL_DIST);
	plyr_angles_y = self.angles_y;
	self.body_roll = '0 0 0';
	self.body_roll_vel = '2 0 5';
	self.reversing = 0;
	self.reverse_release = 0;
	self.current_surface = world.current_surface;
	if (self.current_surface == 0) self.current_surface = SURF_MUD;
	self.chasecam_zoom = DEFAULT_CHASECAM_ZOOM;
	self.cam = CAM_CHASECLOSE;
	self.last_marker = world;
	self.slide_donut_vel = 0;
	if (racing_type == RT_TIME_TRIAL) self.currentammo = TIMETRIAL_STARTTIME;
	self.death_thinker = spawn();
	self.death_thinker.owner = self;
	if (rally_type_index == 4) self.cult_cars = NUM_CARS;
	self.tracking_speed = DEFAULT_TRACKING_SPEED;
	MoveVehicle();
	if (self.classname == "player") {
		self.weaponmodel = "progs/qrally/wheel.mdl";
		self.weaponframe = 5;
		self.veh_tail.veh_dir = self.veh_dir;
		cam_angles = self.veh_body.angles;
		msg_entity = self;
		WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
		WriteAngle(MSG_ONE, 25);
		WriteAngle(MSG_ONE, cam_angles_y);
		WriteAngle(MSG_ONE, cam_angles_z);
		tail = find(world, classname, "player");
		angle_think_ent = spawn();
		angle_think_ent.owner = self;
		angle_think_ent.think = angle_think;
		angle_think_ent.nextthink = time + 0.5;
	}
};

void(vector source, float right, float forward, float up) CalcVehPosition = 
{
	local vector vect_offset_fwd;
	local vector vect_offset_side;
	local vector vect_offset_up;
	local vector temp;
	temp = self.veh_body.angles - self.body_roll;
	if (temp_x > 180)
	{
		temp_x = temp_x - 360;
	}
	temp_x = -1 * temp_x;
	makevectors(temp);
	vect_offset_fwd = v_forward * forward - v_forward * dist_infront;
	vect_offset_side = v_right * right;
	vect_offset_up = v_up * up;
	temp = source + vect_offset_fwd;
	temp = temp + vect_offset_side;
	temp = temp + vect_offset_up;
	return temp_x;
};

void(entity source, entity w, float right, float forward, float up) SetVehPosition = 
{
	local vector newpos;
	newpos = CalcVehPosition(source.origin, right, forward, up);
	setorigin(w, newpos);
};

float(float s_angle, float e_angle, float rate) MoveToAngle = 
{
	local float result;
	if (s_angle > e_angle && s_angle - e_angle > 180)
	{
		e_angle = e_angle + 360;
	}
	else
	{
		if (e_angle > s_angle && e_angle - s_angle > 180)
		{
			s_angle = s_angle + 360;
		}
	}
	if (s_angle > e_angle)
	{
		result = s_angle - rate * frametime;
		if (result < e_angle)
		{
			result = e_angle;
		}
	}
	else
	{
		result = s_angle + rate * frametime;
		if (result > e_angle)
		{
			result = e_angle;
		}
	}
	if (result >= 360)
	{
		result = result - 360;
	}
	if (result < 0)
	{
		result = result + 360;
	}
	return result;
};

void() BodyRoll = 
{
	if (self.angles_z < 5 && self.angles_z > -5)
	{
		self.avelocity_z = 0;
		self.angles_z = 0;
	}
	if (self.angles_x < 5 && self.angles_x > -5)
	{
		self.avelocity_x = 0;
		self.angles_x = 0;
	}
};

void() CheckCultCars = 
{
	local string str;
	if (!challenge)
	{
		return;
	}
	if (self.cult_cars <= 0)
	{
		sprint(self, "You are out of cars!\nYou failed to destroy the Cult.\n");
		changelevel(mapname);
	}
	else
	{
		str = ftos(self.cult_cars);
		sprint(self, "You have ");
		sprint(self, str);
		if (self.cult_cars > 1)
		{
			sprint(self, " cars left\n");
		}
		else
		{
			sprint(self, " car left\n");
		}
	}
};

void(float right, float forward) SpawnDeathWheel = 
{
	local entity part;
	makevectors(self.owner.veh_body.angles);
	part = spawn();
	part.movetype = MOVETYPE_BOUNCE;
	part.solid = SOLID_NOT;
	part.angles = self.owner.veh_body.angles;
	setmodel(part, "progs/qrally/whl.mdl");
	setsize(part, VEC_HULL_MIN + '0 0 12', VEC_HULL_MAX - '0 0 16');
	setorigin(part, self.owner.veh_body.origin + v_right * right * (VEH_WIDTH / 2) + v_forward * forward * (VEH_LENGTH / 2));
	part.velocity = random() * '128 0 0' + random() * '0 128 0' + random() * '0 0 200' + '0 0 150' - '64 64 0';
	part.avelocity = part.velocity;
	part.avelocity_z = 8;
	part.avelocity = part.avelocity * 5;
	part.think = SUB_Remove;
	part.nextthink = time + 3;
};

void() DeathThink = {
	local entity exp, part;
	local float rnd;

	if (!(self.speed) && (self.owner.health < 40 || self.last_idle < time - 2)) {
		part = spawn();
		part.movetype = MOVETYPE_BOUNCE;
		part.solid = SOLID_NOT;
		part.angles = self.veh_body.angles;
		part.colormap = self.veh_body.colormap;
		if (self.owner.car_index == 2) {
			setmodel(part, "progs/qrally/sumacar.mdl");
		} else {
			if (self.owner.car_index == 3) {
				setmodel(part, "progs/qrally/zumacar.mdl");
			} else {
				if (self.owner.car_index == 4) {
					setmodel(part, "progs/qrally/mycar.mdl");
				} else {
					if (self.owner.car_index == 5) setmodel(part, "progs/qrally/triton.mdl");
				}
			}
		}
		part.skin = self.veh_body.skin;
		setsize(part, VEC_HULL_MIN + '0 0 8', VEC_HULL_MAX);
		setorigin(part, self.veh_body.origin);
		part.velocity = random() * '32 0 0' + random() * '0 32 0' + random() * '0 0 200' + '0 0 400' - '16 16 0';
		part.avelocity = part.velocity;
		part.avelocity_x = 0;
		part.think = SUB_Remove;
		part.nextthink = time + 5;
		SpawnDeathWheel(1, 1);
		SpawnDeathWheel(-1, 1);
		SpawnDeathWheel(1, -1);
		SpawnDeathWheel(-1, -1);
		if (self.owner.health <= 0) {
			setorigin(self.owner.veh_body, '0 0 -3900');
			if (self.owner.fwhl != world) setorigin(self.owner.fwhl, '0 0 -3900');
			if (self.owner.rwhl != world) setorigin(self.owner.rwhl, '0 0 -3900');
			if (self.owner.gun != world) setorigin(self.owner.gun, '0 0 -3900');
		}
		self.veh_body = part;
		self.speed = 1;
	}

	if (self.last_idle > time - 2.5)
		self.nextthink = time + 0.5;
	else
		self.nextthink = -1;
};

void() DestroyVehicle = {
	local float ftemp;

	if (self.spawn_time > time - 1) return;

	self.veh_body.roll_velocity = '0 0 0';
	self.veh_body.avelocity = '0 0 0';
	setsize(self.veh_body, VEC_HULL_MIN, VEC_HULL_MAX);
	self.veh_body.angles_x = 0;
	self = self.veh_body;
	droptofloor();
	self = self.owner;
	makevectors(self.veh_body.angles);
	if (v_up_z < 0)
	{
		setorigin(self.veh_body, self.veh_body.origin + '0 0 6' * -1 * v_up_z);
	}
	ftemp = fabs(v_up_z);
	setorigin(self.veh_body, self.veh_body.origin + (1 - ftemp) * '0 0 8');
	makevectors(self.veh_body.angles);
	self.veh_dir = v_forward;
	MoveWheels();
	sound(self, CHAN_VOICE, "player/lburn1.wav", 1, ATTN_STATIC);
	sound(self, CHAN_BODY, "player/lburn2.wav", 1, ATTN_STATIC);
	self.deathtype = "rolled_car";
	if (self.health > 0)
	{
		T_Damage(self, world, world, 500);
	}
};

float() GetAveragePrevRoll = 
{
	local float ave_roll;
	ave_roll = angle_diff(self.prev_surfangle1, self.prev_surfangle5) / 4;
	if (ave_roll < -10)
	{
		ave_roll = -10;
	}
	else
	{
		if (ave_roll > 10)
		{
			ave_roll = 10;
		}
	}
	return ave_roll;
};

void() CarAirborne = 
{
	local float vspeed;
	local vector tail_angle;
	local string str;
	makevectors(self.veh_body.angles);
	if (v_up_z < 0)
	{
		return;
	}
	tail_angle = vectoangles(self.veh_tail.veh_dir);
	self.veh_tail.tracking_speed = angle_diff(self.veh_body.angles_y, tail_angle_y);
	if (time - self.last_jump_touch >= 2 && self.lastmove_z / frametime > 4)
	{
		if (rally_type_index < 3)
		{
			self.veh_body.roll_velocity_z = GetAveragePrevRoll();
		}
		else
		{
			self.veh_body.roll_velocity_z = self.veh_body.veh_dir_z;
		}
		if (self.oldorigin_z >= self.origin_z)
		{
			self.veh_body.roll_velocity_z = self.veh_body.roll_velocity_z / 10;
		}
		if (self.veh_body.roll_velocity_z > 180)
		{
			self.veh_body.roll_velocity_z = self.veh_body.roll_velocity_z - 360;
		}
		self.veh_body.roll_velocity_z = self.veh_body.roll_velocity_z * 10;
		if (self.veh_body.roll_velocity_z > 150)
		{
			self.veh_body.roll_velocity_z = 150;
		}
		else
		{
			if (self.veh_body.roll_velocity_z < -150)
			{
				self.veh_body.roll_velocity_z = -150;
			}
		}
		if (!(global_racing_flags & QR_NO_SIDEWAYS_ROLL))
		{
			self.veh_body.roll_velocity_y = -1 * angle_diff(self.veh_body.old_angles_y, self.veh_body.angles_y) / frametime;
		}
		if (self.veh_body.roll_velocity_y > 25)
		{
			self.veh_body.roll_velocity_y = 25;
		}
		else
		{
			if (self.veh_body.roll_velocity_y < -25)
			{
				self.veh_body.roll_velocity_y = -25;
			}
		}
	}
	else
	{
		self.veh_body.roll_velocity_z = 0;
	}
	self.leave_ground_time = time;
	self.last_jump_z = 0;
	makevectors(self.veh_body.angles);
	self.veh_body.roll_velocity_x = (vspeed / MAX_SPEED * 9 - 10) * 5;
	if (v_forward_z > 0.4)
	{
		self.veh_body.roll_velocity_x = self.veh_body.roll_velocity_x + v_forward_z * 5;
	}
	if (self.oldorigin_z < self.origin_z && time - self.last_jump_touch < 2)
	{
		if (world.model == "maps/qrally02.bsp" && vspeed > 400)
		{
			self.velocity = normalize(self.velocity) * 100;
			self.last_velocity = self.old_velocity = self.velocity;
			self.last_speed = 100;
		}
		else
		{
			self.velocity = self.velocity * 1.5;
		}
		self.velocity_z = self.velocity_z + 250;
		self.last_jump_touch = 0;
	}
};

void() dirt1 = [2, dirt2]
{
	self.nextthink = time + 0.05;
};

void() dirt2 = [3, dirt3]
{
	self.nextthink = time + 0.15;
};

void() dirt3 = [4, dirt5]
{
	self.nextthink = time + 0.05;
	if (vlen(self.owner.velocity) < 100)
	{
		self.think = dirt9;
	}
};

void() dirt5 = [5, dirt6]
{
	if (vlen(self.owner.velocity) < 100)
	{
		self.think = dirt9;
		self.nextthink = time + 0.05;
	}
};

void() dirt6 = [4, dirt7]
{
};

void() dirt7 = [5, dirt8]
{
};

void() dirt8 = [4, dirt9]
{
};

void() dirt9 = [3, dirt10]
{
};

void() dirt10 = [2, dirt11]
{
};

void() dirt11 = [3, dirt12]
{
};

void() dirt12 = [2, dirt13]
{
};

void() dirt13 = [1, dirt14]
{
};

void() dirt14 = [0, dirt14]
{
	remove(self);
};

void(entity own, vector org, vector vel, vector ang) SpawnDirt = 
{
	local entity dirt;
	local vector vang;
	local vector vunit;
	dirt = spawn();
	setorigin(dirt, org);
	setmodel(dirt, "progs/qrally/dirt.mdl");
	dirt.velocity = vel;
	vunit = normalize(own.velocity);
	vang = vectoangles(vunit);
	dirt.angles = ang;
	dirt.angles_y = vang_y;
	dirt.owner = own;
	dirt.think = dirt1;
	dirt.nextthink = time + 0.05;
};

float() MoveTail = 
{
	local vector tail_vect;
	local vector tail_angles;
	local vector veh_angles;
	local vector v1;
	local vector vfront;
	local vector vback;
	local vector vtemp;
	local vector vtemp2;
	local float dist;
	local float this_slide;
	local float ftemp;
	local entity tail;
	local entity efloor;
	local entity temp_e;
	local float floor_dist;
	local float rear_dir;
	local float new_angle;
	local float old_angle;
	local float old_vel_z;
	local float this_yaw;
	local float steer_angle;
	local float slide_angle;
	local float forwardspeed;
	local float vspeed;
	local float targ_heading;
	local float vol;
	local float real_slide_angle;
	local float unstable_ground;
	local float rand;
	local string str;
	if (self.last_flags & FL_ONGROUND && !(self.flags & FL_ONGROUND))
	{
		CarAirborne();
	}
	tail = self.veh_tail;
	vspeed = vlen(self.velocity);
	self.last_flags = self.flags;
	self.veh_body.old_angles = self.veh_body.angles;
	if (self.flags & FL_ONGROUND && (tail.flags & FL_ONGROUND) && !checkbottom(self))
	{
		if (random() < 0.4 && vspeed > 600)
		{
			traceline(self.origin, self.origin - '0 0 256', 1, self);
			if (trace_fraction > 0.5)
			{
				commentary(self, "qrally/voice/yeah.wav");
			}
		}
		self.flags = self.flags - FL_ONGROUND;
		CarAirborne();
	}
	else
	{
		if (!(self.flags & FL_ONGROUND))
		{
			self.veh_tail.slide_ratio = 0;
			if (self.origin_z < self.oldorigin_z)
			{
				self.last_jump_z = self.last_jump_z + (self.oldorigin_z - self.origin_z);
			}
			setorigin(self.veh_tail, self.origin - self.veh_dir * TAIL_DIST);
			if (checkbottom(self) && !(self.bot_flags && BF_STARTJUMP))
			{
				self.flags = self.flags + FL_ONGROUND;
				self.racing_flags = self.racing_flags | QR_JUST_LANDED;
				if (tail.flags & FL_ONGROUND)
				{
					tail.flags = tail.flags - FL_ONGROUND;
				}
				makevectors(self.veh_body.angles);
				setorigin(self.veh_tail, self.origin - v_forward * TAIL_DIST);
				tail_angles = vectoangles(self.veh_dir);
				tail_angles_y = anglemod(self.veh_body.angles_y - self.veh_tail.tracking_speed);
				makevectors(tail_angles);
				self.veh_tail.veh_dir = v_forward;
				if (self.last_land < time - SNDLEN_LAND && self.leave_ground_time < time - 0.4)
				{
					vol = self.last_jump_z / 64;
					if (vol > 1)
					{
						vol = 1;
					}
					if (fabs(self.veh_body.angles_z) < 60)
					{
						sound(self, CHAN_ITEM, "qrally/ray/susp1.wav", vol, ATTN_STATIC);
					}
					rand = random();
					if (rand < 0.4)
					{
						sound(self, CHAN_WEAPON, "qrally/bangbang.wav", vol, ATTN_STATIC);
					}
					else
					{
						if (rand < 0.6)
						{
							sound(self, CHAN_WEAPON, "qrally/process/bang01.wav", vol, ATTN_STATIC);
						}
						else
						{
							if (rand < 0.8)
							{
								sound(self, CHAN_WEAPON, "qrally/process/bang02.wav", vol, ATTN_STATIC);
							}
							else
							{
								sound(self, CHAN_WEAPON, "qrally/process/bang03.wav", vol, ATTN_STATIC);
							}
						}
					}
					self.last_land = time;
				}
			}
			else
			{
				tail_vect = normalize(tail.origin - self.origin) * TAIL_DIST;
				setorigin(tail, self.origin + tail_vect);
			}
			if (self.bot_flags && BF_STARTJUMP)
			{
				self.bot_flags = self.bot_flags - BF_STARTJUMP;
			}
		}
	}
	if (self.racing_flags & QR_JUST_LANDED && (self.flags & FL_ONGROUND))
	{
		makevectors(self.veh_body.angles);
		if (v_up_z < 0.2)
		{
			sound(self, CHAN_AUTO, "qrally/process/rolltest.wav", 1, ATTN_STATIC);
			self.deathtype = "rolled_car";
			T_Damage(self, world, world, 2);
			if (self.health < 0)
			{
				DestroyVehicle();
				return 0;
			}
			traceline(self.origin, self.origin - '0 0 64', 1, world);
			if (trace_plane_normal_z > 0.5)
			{
				self.velocity_z = self.last_jump_z / 2;
				if (self.velocity_z < 220)
				{
					self.velocity_z = 220;
				}
				else
				{
					if (self.velocity_z > 300)
					{
						self.velocity_z = 300;
					}
				}
			}
			if (fabs(self.veh_body.roll_velocity_z) < 15)
			{
				self.veh_body.roll_velocity_z = self.veh_body.roll_velocity_z * 1.2;
			}
			setorigin(self, self.origin + '0 0 1');
			self.last_jump_z = self.last_jump_z * 0.9;
			self.flags = self.flags - FL_ONGROUND;
			if (self.roll_velocity_z < 0 && self.roll_velocity_z > -10)
			{
				self.roll_velocity_z = -10;
			}
			else
			{
				if (self.roll_velocity_z > 0 && self.roll_velocity_z < 10)
				{
					self.roll_velocity_z = 10;
				}
			}
			return 1;
		}
	}
	self.racing_flags = self.racing_flags - (self.racing_flags & QR_JUST_LANDED);
	if (self.flags & FL_ONGROUND)
	{
		unstable_ground = 0;
		tail_vect = self.origin - self.veh_tail.origin;
		dist = vlen(tail_vect);
		vtemp2 = normalize(tail_vect);
		tail_vect_z = 0;
		tail_vect = normalize(tail_vect);
		vfront = self.origin + tail_vect * 14 + '0 0 12';
		traceline(vfront, vfront - '0 0 96', 1, self);
		if (trace_fraction < 1)
		{
			vfront = trace_endpos;
		}
		else
		{
			unstable_ground = 1;
		}
		vtemp = tail_vect;
		vback = self.origin - vtemp * TAIL_DIST + '0 0 12';
		traceline(vfront, vback, 1, self);
		if (trace_fraction < 1)
		{
			vback = self.origin - tail_vect * 14 + '0 0 12';
		}
		traceline(vback, vback - '0 0 96', 1, self);
		if (trace_fraction < 1)
		{
			vback = trace_endpos;
		}
		else
		{
			unstable_ground = 1;
		}
		v1 = normalize(vback - vfront);
		if (unstable_ground)
		{
			setorigin(tail, self.origin - vtemp2 * dist);
		}
		else
		{
			setorigin(tail, self.origin + v1 * dist);
		}
	}
	if (!(self.flags & FL_ONGROUND))
	{
		return 1;
	}
	tail_vect = normalize(self.velocity);
	if (self.reversing && (vspeed < 100 || vlen(tail_vect + self.veh_dir) < 1.5))
	{
		setorigin(self.veh_tail, self.veh_tail.origin + (self.origin - self.oldorigin));
	}
	else
	{
		tail_vect = self.origin - self.veh_tail.origin;
		dist = vlen(tail_vect) - TAIL_DIST;
		vspeed = vlen(self.velocity);
		tail_vect = normalize(tail_vect);
		tail_vect = tail_vect * vlen(self.origin - self.oldorigin);
		if (self.origin != self.oldorigin)
		{
			tail_vect = tail_vect * (1 - vspeed / MAX_SPEED) * 5;
		}
		tail_angles = vectoangles(self.veh_tail.veh_dir);
		if (self.flags & FL_ONGROUND)
		{
			tail_angles_x = 0;
		}
		veh_angles = vectoangles(normalize(tail_vect));
		targ_heading = angle_diff(anglemod(self.angles_y), veh_angles_y);
		if (targ_heading > 180)
		{
			targ_heading = targ_heading - 360;
		}
		targ_heading = MoveToAngle(?/00000004\?, anglemod(veh_angles_y + targ_heading), 360);
		this_yaw = tail.yaw_speed * ((self.cam == CAM_INCAR) * 2 + 1);
		if (self.current_surface == SURF_ASPHALT)
		{
			this_yaw = this_yaw * 2;
		}
		if (vspeed > MAX_SPEED / 3 && (self.racing_flags & QR_FULL_TRACTION))
		{
			if (self.full_traction_time < time - 30)
			{
				sprint(self, "Extra traction has worn out\n");
				self.racing_flags = self.racing_flags - QR_FULL_TRACTION;
			}
			else
			{
				this_yaw = this_yaw * 2;
			}
		}
		steer_angle = angle_diff(tail_angles_y, self.angles_y);
		steer_angle = fabs(steer_angle);
		if (steer_angle > 180)
		{
			steer_angle = 360 - steer_angle;
		}
		real_slide_angle = angle_diff(tail_angles_y, veh_angles_y);
		slide_angle = fabs(real_slide_angle);
		if (slide_angle > 180)
		{
			slide_angle = 360 - slide_angle;
		}
		if (slide_angle > 2 && steer_angle < slide_angle)
		{
			vol = (vspeed < MAX_SPEED / 2) * 4;
			this_yaw = this_yaw * ((slide_angle - steer_angle) * STEER_CORRECTION_RATIO);
		}
		if (slide_angle > 5 && vspeed > 100 && (self.flags & FL_ONGROUND) && !hold_flag && !(self.reversing) && self.classname == "player")
		{
			vol = slide_angle / 45;
			if (vol > 1)
			{
				vol = 1;
			}
			if (self.slide_time < time - SNDLEN_SLIDE && self.classname == "player")
			{
				if (self.current_surface == SURF_MUD)
				{
					sound(self, CHAN_AUTO, "qrally/skidmud.wav", vol * 0.4, ATTN_STATIC);
					rand = random();
					if (self.slide_time > time - SNDLEN_SLIDE * 2 && rand < 0.3 && self.classname == "player")
					{
						if (rand < 0.15)
						{
							sound(self, CHAN_AUTO, "qrally/process/drft02.wav", vol, ATTN_STATIC);
						}
						else
						{
							sound(self, CHAN_AUTO, "qrally/ray/skidgrav.wav", vol, ATTN_STATIC);
						}
					}
				}
				else
				{
					rand = random() * 3;
					if (rand <= 1)
					{
						sound(self, CHAN_AUTO, "qrally/ray/screech1.wav", vol, ATTN_STATIC);
					}
					else
					{
						if (rand <= 2)
						{
							sound(self, CHAN_AUTO, "qrally/ray/screech2.wav", vol, ATTN_STATIC);
						}
						else
						{
							if (rand <= 3)
							{
								sound(self, CHAN_AUTO, "qrally/ray/screech3.wav", vol, ATTN_STATIC);
							}
						}
					}
				}
				self.slide_time = time;
			}
			if (lose_speed_on_slide)
			{
				vol = vlen(self.velocity) / MAX_SPEED;
				self.velocity = self.velocity * (SLIDING_SLOWDOWN * ((1 - vol) / 20) + 0.95);
			}
		}
		if (slide_angle > 5 && vspeed > 50 && !hold_flag && !(self.reversing) && random() < 0.7 && pointcontents(self.origin - '0 0 16') != CONTENT_WATER)
		{
			vol = slide_angle / 45;
			if (vol > 1)
			{
				vol = 1;
			}
			makevectors(self.veh_body.angles - self.body_roll);
			if (deathmatch != 10)
			{
				if (self.current_surface == SURF_MUD)
				{
					ftemp = random() * 3;
					ftemp = 112 + floor(ftemp);
					particle(self.origin - '0 0 8' - self.veh_dir * 32, self.velocity * 0.5 + v_right * 16, ftemp, vol * 80);
					particle(self.origin - '0 0 8' - self.veh_dir * 32, self.velocity * 0.5 - v_right * 16, ftemp, vol * 80);
				}
				else
				{
					if (self.current_surface == SURF_ASPHALT)
					{
						ftemp = random() * 5;
						ftemp = 4 + floor(ftemp);
						particle(self.origin - '0 0 8' - self.veh_dir * 32, self.velocity * 0.5 + v_right * 16 + '0 0 10', ftemp, vol * 40);
						particle(self.origin - '0 0 8' - self.veh_dir * 32, self.velocity * 0.5 - v_right * 16 + '0 0 10', ftemp, vol * 40);
					}
					else
					{
						if (self.current_surface == SURF_GRASS)
						{
							ftemp = random() * 6;
							ftemp = 53 + floor(ftemp);
							particle(self.origin - '0 0 8' - self.veh_dir * 32, self.velocity * 0.5 + v_right * 16 + '0 0 10', ftemp, vol * 60);
							particle(self.origin - '0 0 8' - self.veh_dir * 32, self.velocity * 0.5 - v_right * 16 + '0 0 10', ftemp, vol * 60);
						}
					}
				}
			}
		}
		tail_angles_y = MoveToAngle(tail_angles_y, veh_angles_y, this_yaw);
		new_angle = angle_diff(veh_angles_y, tail_angles_y);
		if (new_angle > 180)
		{
			new_angle = new_angle - 360;
		}
		old_angle = angle_diff(veh_angles_y, tail.last_speed);
		if (old_angle > 180)
		{
			old_angle = old_angle - 360;
		}
		rear_dir = angle_diff(veh_angles_y, tail_angles_y);
		if (rear_dir > 2 || rear_dir < -2)
		{
			tail.slide_ratio = tail.slide_ratio + 0.09 * (1 - vspeed / MAX_SPEED) * 3;
			if (tail.slide_ratio > 1 && vspeed < MAX_SPEED / 3 && self.slide_donut_vel < 40)
			{
				tail.slide_ratio = tail.slide_ratio + 0.1;
				self.slide_donut_vel = self.slide_donut_vel + 20 * frametime;
			}
			else
			{
				self.slide_donut_vel = self.slide_donut_vel - 40 * frametime;
				if (self.slide_donut_vel < 0)
				{
					self.slide_donut_vel = 0;
				}
			}
			this_slide = tail.slide_ratio;
		}
		else
		{
			this_slide = 0;
			self.slide_donut_vel = 0;
			tail.slide_ratio = 0;
		}
		if (this_slide > 1)
		{
			this_slide = 1;
		}
		if (rear_dir > MAX_SLIDING_ANGLE)
		{
			tail_angles_y = anglemod(veh_angles_y - MAX_SLIDING_ANGLE);
		}
		else
		{
			if (rear_dir < -1 * MAX_SLIDING_ANGLE)
			{
				tail_angles_y = anglemod(veh_angles_y + MAX_SLIDING_ANGLE);
			}
		}
		tail.last_speed = tail_angles_y;
		makevectors(tail_angles);
		tail_vect = dist * this_slide * v_forward;
		v1 = self.veh_tail.origin + tail_vect;
		tail_vect = normalize(v1 - self.origin) * TAIL_DIST;
		setorigin(self.veh_tail, self.origin + tail_vect);
	}
	self.veh_tail.veh_dir = v_forward;
	self.veh_dir = normalize(self.origin - self.veh_tail.origin);
	tail_angles = vectoangles(tail_vect);
	self.veh_tail.angles = tail_angles;
	return 1;
};

void() MoveWheels = 
{
	local vector heading;
	local entity w;
	local float dist;
	if (self.hl_r != world)
	{
		SetVehPosition(self, self.hl_r, VEH_WIDTH * 4, VEH_LENGTH * 6, 0);
		traceline(self.origin, self.hl_r.origin, 0, self.hl_r);
		if (trace_fraction < 1)
		{
			setorigin(self.hl_r, trace_endpos);
		}
	}
	if (self.hl_l != world)
	{
		SetVehPosition(self, self.hl_l, -1 * VEH_WIDTH * 4, VEH_LENGTH * 6, 0);
		traceline(self.origin, self.hl_l.origin, 0, self.hl_l);
		if (trace_fraction < 1)
		{
			setorigin(self.hl_l, trace_endpos);
		}
	}
	if (self.hl_m != world)
	{
		SetVehPosition(self, self.hl_m, 0, VEH_LENGTH * 10, 0);
		traceline(self.origin, self.hl_m.origin, 0, self.hl_m);
		if (trace_fraction < 1)
		{
			setorigin(self.hl_m, trace_endpos);
		}
	}
	if (!cvar("deathmatch"))
	{
		heading = vectoangles(self.veh_dir);
		self.fwhl.angles = self.veh_body.angles - self.body_roll;
		SetVehPosition(self.veh_body, self.fwhl, 0, self.fwhl_offset_y, self.fwhl_offset_z);
		self.rwhl.angles = self.veh_body.angles - self.body_roll;
		SetVehPosition(self.veh_body, self.rwhl, 0, self.rwhl_offset_y, self.rwhl_offset_z);
		w = self.fwhl;
		dist = floor(vlen(self.lastmove) / 2);
		if (dist > 7)
		{
			dist = -1;
		}
		if (self.reversing)
		{
			w.skin = w.skin + dist;
		}
		else
		{
			w.skin = w.skin - dist;
		}
		while (w.skin < 0)
		{
			w.skin = w.skin + 7;
		}
		while (w.skin > 6)
		{
			w.skin = w.skin - 7;
		}
		self.rwhl.skin = w.skin;
	}
	if (self.gun != world)
	{
		makevectors(self.veh_body.angles);
		if (self.car_index == 3 || self.car_index == 5)
		{
			setorigin(self.gun, self.veh_body.origin + v_up * GUN_ZOFS);
		}
		else
		{
			setorigin(self.gun, self.veh_body.origin + v_up * (GUN_ZOFS * 0.75));
		}
		if (self.weapon == IT_ROOBAR)
		{
			setorigin(self.gun, self.gun.origin - v_up * 8);
		}
		self.gun.angles = self.veh_body.angles;
	}
};

void(entity e, float ratio) ReduceVelocity = 
{
	local float new_length;
	new_length = vlen(e.velocity) * (1 - ratio);
	e.velocity = normalize(e.velocity) * new_length;
};

void(float newangle) SetPrevSurfAngle = 
{
	self.prev_surfangle5 = self.prev_surfangle4;
	self.prev_surfangle4 = self.prev_surfangle3;
	self.prev_surfangle3 = self.prev_surfangle2;
	self.prev_surfangle2 = self.prev_surfangle1;
	self.last_prevsurf = time;
	self.prev_surfangle1 = newangle;
};

void() SetSurfaceAngle = 
{
	local vector left;
	local vector right;
	local vector spos;
	local vector epos;
	local vector angle;
	local vector veh_angle;
	local float gravity;
	local float temp_z;
	local float dist;
	local float diff;
	local float vspeed;
	if (self.veh_dir_z > 0.8 || self.veh_dir_z < -0.8)
	{
		return 0;
	}
	if (!(self.flags & FL_ONGROUND))
	{
		return 0;
	}
	gravity = cvar("sv_gravity");
	if (vlen(self.origin - self.oldorigin) > 0)
	{
		vspeed = vlen(self.velocity);
		if (vspeed > 150)
		{
			angle = normalize(self.velocity);
			angle = vectoangles(angle);
			diff = angle_diff(self.veh_body.angles_y, angle_y);
			if (diff > 5)
			{
				self.body_lean = self.body_lean + 25 * (vspeed / MAX_SPEED) * frametime;
				if (self.body_lean > 15)
				{
					self.body_lean = 15;
				}
			}
			else
			{
				if (diff < -5)
				{
					self.body_lean = self.body_lean - 25 * (vspeed / MAX_SPEED) * frametime;
					if (self.body_lean < -15)
					{
						self.body_lean = -15;
					}
				}
				else
				{
					if (fabs(self.body_lean) > 0)
					{
						if (self.body_lean < 0)
						{
							self.body_lean = self.body_lean + 30 * frametime;
							if (self.body_lean > 0)
							{
								self.body_lean = 0;
							}
						}
						else
						{
							self.body_lean = self.body_lean - 30 * frametime;
							if (self.body_lean < 0)
							{
								self.body_lean = 0;
							}
						}
					}
				}
			}
		}
		else
		{
			if (fabs(self.body_lean) > 0)
			{
				if (self.body_lean < 0)
				{
					self.body_lean = self.body_lean + 30 * frametime;
					if (self.body_lean > 0)
					{
						self.body_lean = 0;
					}
				}
				else
				{
					self.body_lean = self.body_lean - 30 * frametime;
					if (self.body_lean < 0)
					{
						self.body_lean = 0;
					}
				}
			}
		}
		self.body_roll_z = self.body_roll_z - self.body_lean;
		if (self.current_surface != SURF_ASPHALT)
		{
			self.body_roll_x = self.body_roll_x + self.body_roll_vel_x * (vlen(self.velocity) / MAX_SPEED) * (random() * 2) * (1 / ((self.cam == CAM_INCAR) + 1));
			self.body_roll_z = self.body_roll_z + self.body_roll_vel_z * (vlen(self.velocity) / MAX_SPEED) * (random() * 2) * (1 / ((self.cam == CAM_INCAR) + 1));
			if (fabs(self.body_roll_x) > 0.5)
			{
				self.body_roll_vel_x = -1 * self.body_roll_vel_x;
				self.body_roll_x = self.body_roll_x / fabs(self.body_roll_x) * 2;
			}
			if (fabs(self.body_roll_z) > 5)
			{
				self.body_roll_vel_z = -1 * self.body_roll_vel_z;
				self.body_roll_z = self.body_roll_z / fabs(self.body_roll_z) * 2;
			}
		}
		else
		{
			self.body_roll = '0 0 0';
		}
		self.body_roll_z = self.body_roll_z + self.body_lean;
	}
	veh_angle = vectoangles(self.veh_dir);
	veh_angle_z = 0;
	veh_angle_x = 0;
	makevectors(veh_angle);
	left = self.origin - v_right * 14;
	spos = left + 48 * v_up;
	epos = left - 1000 * v_up;
	traceline(spos, epos, 1, self);
	if (trace_fraction == 1)
	{
		return 0;
	}
	else
	{
		if (vlen(left - trace_endpos) > MAX_DIST)
		{
			return 0;
		}
		else
		{
			left = trace_endpos;
		}
	}
	right = self.origin + v_right * 14;
	spos = right + 48 * v_up;
	epos = right - 1000 * v_up;
	traceline(spos, epos, 1, self);
	if (trace_fraction == 1)
	{
		return 0;
	}
	else
	{
		if (vlen(right - trace_endpos) > MAX_DIST)
		{
			return 0;
		}
		else
		{
			right = trace_endpos;
		}
	}
	angle = normalize(left - right);
	angle = vectoangles(angle);
	veh_angle = self.veh_body.veh_dir;
	veh_angle_z = anglemod(veh_angle_z);
	if (fabs(angle_diff(veh_angle_z, angle_x)) > ROLL_PER_SECOND_z * frametime)
	{
		angle_x = MoveToAngle(veh_angle_z, angle_x, ROLL_PER_SECOND_z);
	}
	if (self.last_prevsurf < time - 0.2)
	{
		SetPrevSurfAngle(angle_x);
	}
	self.veh_body.last_roll_z = angle_x - self.veh_body.veh_dir_z;
	self.veh_body.veh_dir_z = angle_x;
	return 1;
};

void() checkHealth = 
{
	if (self.health <= 2)
	{
		DestroyVehicle();
	}
};

void(entity veh1, entity veh2) CarCollision = 
{
	local vector veh1_to_veh2;
	local float veh1_speed;
	local float veh2_speed;
	local float rnd;
	local float impact;
	veh1_to_veh2 = normalize(veh2.origin - veh1.origin);
	veh1_speed = vlen(veh1.velocity);
	veh2_speed = vlen(veh2.velocity);
	veh1.velocity = normalize(veh1.velocity) * veh2_speed * 0.95;
	veh2.velocity = (veh2.velocity + normalize(veh1_to_veh2) * veh2_speed) * 0.5;
	rnd = random() * 5;
	if (rnd < 1)
	{
		sound(self, CHAN_AUTO, "qrally/nexus/wall.wav", 1, ATTN_NORM);
	}
	else
	{
		if (rnd < 2)
		{
			sound(self, CHAN_AUTO, "qrally/ray/crash2.wav", 1, ATTN_NORM);
		}
		else
		{
			if (rnd < 3)
			{
				sound(self, CHAN_AUTO, "qrally/ray/crash3.wav", 1, ATTN_NORM);
			}
			else
			{
				if (rnd < 4)
				{
					sound(self, CHAN_AUTO, "qrally/ray/crash4.wav", 1, ATTN_NORM);
				}
				else
				{
					if (rnd < 5)
					{
						sound(self, CHAN_AUTO, "qrally/ray/crash5.wav", 1, ATTN_NORM);
					}
				}
			}
		}
	}
	impact = vlen(veh1.velocity - veh2.velocity) / 10;
	if (veh1.weapon != IT_ROOBAR)
	{
		veh2.deathtype = "car_collision";
	}
	T_Damage(veh2, veh1, veh1, impact / 10);
};

void(vector pos, vector vel) CarGib = 
{
	local entity gib;
	local float f;
	if (deathmatch == 10)
	{
		return;
	}
	gib = spawn();
	gib.solid = SOLID_BBOX;
	gib.movetype = MOVETYPE_BOUNCE;
	setmodel(gib, "progs/qrally/gibs.mdl");
	setorigin(gib, pos);
	setsize(gib, '0 0 0', '0 0 0');
	f = random() * 4;
	gib.frame = floor(f);
	gib.velocity = vel;
	gib.avelocity = '300 300 300' * (random() * 0.5 + 0.5);
	gib.colormap = self.colormap;
	gib.think = SUB_Remove;
	gib.nextthink = time + 0.75;
};

void(vector pos, vector vel, float dam) CarGibs = 
{
	local float num_gibs;
	local vector randvect;
	num_gibs = floor(dam * 2);
	while (num_gibs > 0)
	{
		randvect_x = random() * 4;
		randvect_y = random() * 4;
		randvect_z = random() * 2;
		randvect = randvect - '2 2 1';
		CarGib(pos + randvect, vel + randvect * 50);
		num_gibs = num_gibs - 1;
	}
};

void(float vel_speed) CheckForCollision = 
{
	local vector dir;
	local vector pos;
	local float vol;
	local float rnd;
	local float ent_speed;
	local string crash_snd;
	local entity ent;
	local entity oldself;
	local float vspeed;
	local float lspeed;
	vspeed = vlen(self.velocity);
	lspeed = vlen(self.last_velocity);
	if (vel_speed < self.last_speed && self.last_crash < time - SNDLEN_CRASH)
	{
		dir = self.veh_body.angles;
		dir_x = -1 * dir_x;
		rnd = random() * 2;
		if (rnd < 1)
		{
			crash_snd = "qrally/crash5.wav";
		}
		else
		{
			crash_snd = "qrally/process/crsh01.wav";
		}
		makevectors(dir);
		pos = self.origin + v_forward * VEH_MAX_x * 2;
		traceline(self.origin, pos, 0, self);
		if (trace_fraction < 1)
		{
			vol = (self.last_speed - vel_speed) / 40;
			if (vol > 1)
			{
				vol = 1;
			}
			if (vol < 0)
			{
				vol = 0;
			}
			if (self.weapon == IT_ROOBAR && self.ammo_roobar > 0)
			{
				if (trace_ent.classname == "rally_roo" || trace_ent.classname == "rally_dude")
				{
					oldself = self;
					other = self;
					self = trace_ent;
					self.touch();
					self = oldself;
				}
				else
				{
					if (trace_ent.classname == "player")
					{
						T_Damage(trace_ent, self, self, vol * 150);
						if (trace_ent.weapon == IT_ROOBAR)
						{
							T_Damage(self, world, world, vol * 150);
							self.deathtype = "repulsor_feedback";
						}
					}
					if (self.ammo_roobar > vol * 12)
					{
						self.currentammo = self.ammo_roobar = self.ammo_roobar - vol * 12;
					}
					else
					{
						self.ammo_roobar = 0;
						self.currentammo = 0;
					}
				}
				sound(self, CHAN_AUTO, "qrally/process/elect02.wav", 1, ATTN_NORM);
				self.veh_body.effects = self.veh_body.effects | EF_DIMLIGHT;
				W_Attack();
			}
			else
			{
				if (trace_ent == world && vlen(trace_plane_normal + self.veh_dir) < 0.5 && vspeed > 500)
				{
					T_Damage(self, world, world, 30);
					if (random() < 0.5)
					{
						sound(self, CHAN_AUTO, "qrally/dude/sevpain1.wav", 1, ATTN_NORM);
					}
					else
					{
						sound(self, CHAN_AUTO, "qrally/dude/sevpain2.wav", 1, ATTN_NORM);
					}
					sound(self, CHAN_AUTO, "qrally/ray/crash5.wav", 1, ATTN_NORM);
					centerprint(self, "Whiplash damage!");
				}
				else
				{
					T_Damage(self, world, world, vol * 4);
				}
				CarGibs(trace_endpos - v_forward * 6, self.velocity * 0.75 + '0 0 150', vol * 4);
				checkHealth();
				sound(self, CHAN_AUTO, crash_snd, vol, ATTN_STATIC);
			}
			if (trace_ent != world)
			{
				CarCollision(self, trace_ent);
			}
			self.last_crash = time;
			return;
		}
		dir = normalize(v_right + v_forward);
		pos = self.origin + dir * VEH_MAX_x * 2;
		traceline(self.origin, pos, 0, self);
		if (trace_fraction < 1)
		{
			vol = (self.last_speed - vel_speed) / 40;
			if (vol > 1)
			{
				vol = 1;
			}
			if (vol < 0)
			{
				vol = 0;
			}
			if (self.weapon == IT_ROOBAR && self.ammo_roobar > 0)
			{
				if (trace_ent.classname == "rally_roo" || trace_ent.classname == "rally_dude")
				{
					oldself = self;
					other = self;
					self = trace_ent;
					self.touch();
					self = oldself;
				}
				else
				{
					if (trace_ent.classname == "player")
					{
						T_Damage(trace_ent, self, self, vol * 150);
					}
					if (self.ammo_roobar > vol * 12)
					{
						self.currentammo = self.ammo_roobar = self.ammo_roobar - vol * 12;
					}
					else
					{
						self.ammo_roobar = 0;
						self.currentammo = 0;
					}
				}
				sound(self, CHAN_AUTO, "qrally/process/elect02.wav", 1, ATTN_NORM);
				self.veh_body.effects = self.veh_body.effects | EF_DIMLIGHT;
				W_Attack();
			}
			else
			{
				T_Damage(self, world, world, vol * 4);
				CarGibs(trace_endpos - dir * 4, self.velocity * 0.75 + '0 0 150', vol * 4);
				sound(self, CHAN_AUTO, crash_snd, vol, ATTN_STATIC);
				checkHealth();
			}
			if (trace_ent != world)
			{
				CarCollision(self, trace_ent);
			}
			self.last_crash = time;
			return;
		}
		dir = normalize(-1 * v_right + v_forward);
		pos = self.origin + dir * VEH_MAX_x * 2;
		traceline(self.origin, pos, 0, self);
		if (trace_fraction < 1)
		{
			vol = (self.last_speed - vel_speed) / 40;
			if (vol > 1)
			{
				vol = 1;
			}
			if (vol < 0)
			{
				vol = 0;
			}
			if (self.weapon == IT_ROOBAR && self.ammo_roobar > 0)
			{
				if (trace_ent.classname == "rally_roo" || trace_ent.classname == "rally_dude")
				{
					oldself = self;
					other = self;
					self = trace_ent;
					self.touch();
					self = oldself;
				}
				else
				{
					if (trace_ent.classname == "player")
					{
						T_Damage(trace_ent, self, self, vol * 150);
					}
					if (self.ammo_roobar > vol * 12)
					{
						self.currentammo = self.ammo_roobar = self.ammo_roobar - vol * 12;
					}
					else
					{
						self.ammo_roobar = 0;
						self.currentammo = 0;
					}
				}
				sound(self, CHAN_AUTO, "qrally/process/elect02.wav", 1, ATTN_NORM);
				self.veh_body.effects = self.veh_body.effects | EF_DIMLIGHT;
				W_Attack();
			}
			else
			{
				T_Damage(self, world, world, vol * 4);
				CarGibs(trace_endpos - dir * 4, self.velocity * 0.75 + '0 0 150', vol * 4);
				checkHealth();
				sound(self, CHAN_AUTO, crash_snd, vol, ATTN_STATIC);
			}
			if (trace_ent != world)
			{
				CarCollision(self, trace_ent);
			}
			self.last_crash = time;
			return;
		}
		ent = findradius(self.origin, 64);
		while (ent != world)
		{
			if (ent == self || ent.classname != "player" || ent.classname != "rally_bot")
			{
				ent = ent.chain;
			}
			else
			{
				ent_speed = vlen(ent.velocity);
				self.velocity = normalize(self.velocity) * (ent_speed * 0.95);
			}
		}
	}
	if (self.racing_flags & QR_OUT_OF_TIME || self.car_index != 3)
	{
		return;
	}
	if (vspeed > lspeed && (self.racing_flags & QR_START_READY) && self.last_rev < time - SNDLEN_HIGHREV && (self.flags & FL_ONGROUND))
	{
		if (vspeed > 450 && vspeed < 650)
		{
			dir = vectoangles(self.veh_tail.veh_dir);
			if (fabs(angle_diff(dir_y, self.veh_body.angles_y)) > 15)
			{
				if (vspeed > 550)
				{
					sound(self, 6, "qrally/engine/rev/highrev2.wav", 0.75, ATTN_NORM);
				}
				else
				{
					sound(self, 6, "qrally/engine/rev/highrev.wav", 0.75, ATTN_NORM);
				}
				self.last_rev = time;
			}
		}
		else
		{
			if (lspeed < 250)
			{
				sound(self, 6, "qrally/engine/rev/takeoff.wav", 0.75, ATTN_NORM);
				self.last_rev = time;
			}
		}
	}
	else
	{
		if (vspeed < lspeed && self.last_backrev < time - SNDLEN_HIGHREV)
		{
			if (vspeed > 800 && vspeed < 950)
			{
				sound(self, 5, "qrally/engine/rev/backrev2.wav", 0.75, ATTN_NORM);
				self.last_backrev = time;
			}
			else
			{
				if (vspeed > 600 && vspeed < 750)
				{
					sound(self, 5, "qrally/engine/rev/backrev.wav", 0.75, ATTN_NORM);
					self.last_backrev = time;
				}
				else
				{
					if (vspeed > 400 && vspeed < 550)
					{
						sound(self, 5, "qrally/engine/rev/backrev3.wav", 0.75, ATTN_NORM);
						self.last_backrev = time;
					}
				}
			}
		}
	}
};

void(float vel_speed) DoEngineNoises = 
{
	local float speed_ratio;
	local float vol;
	local float snd_delay;
	local float samp;
	local string new_sample;
	local string ch;
	if (self.racing_flags & QR_OUT_OF_TIME)
	{
		return;
	}
	if (self.last_engine < time - 0.1)
	{
		self.last_engine = time;
		if (self.racing_flags & QR_START_READY && !hold_flag || (global_racing_flags & QR_NO_STARTFINISH && race_start_time < time - 1) || rally_type_index >= 3)
		{
			if (self.flags & FL_ONGROUND)
			{
				speed_ratio = 20 * (vel_speed / MAX_SPEED);
				if (speed_ratio < 6)
				{
					speed_ratio = speed_ratio * 2;
				}
				else
				{
					if (speed_ratio < 12)
					{
						speed_ratio = (speed_ratio - 6 + 3) * 1.5;
					}
					else
					{
						speed_ratio = (speed_ratio - 6) * 1.6;
					}
				}
			}
			else
			{
				speed_ratio = self.last_engine_ratio + 1;
				if (speed_ratio > 20)
				{
					speed_ratio = 20;
				}
			}
			speed_ratio = floor(speed_ratio);
			if (speed_ratio > 20)
			{
				speed_ratio = 20;
			}
			if (speed_ratio > 1 && speed_ratio == self.last_engine_ratio)
			{
				if (self.last_engine_ratio == 20)
				{
					speed_ratio = self.last_engine_ratio - 1;
				}
				else
				{
					speed_ratio = self.last_engine_ratio + 1;
				}
			}
			if (self.car_index == 4)
			{
				if (self.skin == 0)
				{
					ch = "m";
					if (speed_ratio <= 2)
					{
						new_sample = "qrally/engine/ma01.wav";
					}
					else
					{
						if (speed_ratio <= 4)
						{
							new_sample = "qrally/engine/ma01.wav";
						}
						else
						{
							if (speed_ratio <= 6)
							{
								new_sample = "qrally/engine/ma02.wav";
							}
							else
							{
								if (speed_ratio <= 8)
								{
									new_sample = "qrally/engine/ma03.wav";
								}
								else
								{
									if (speed_ratio <= 10)
									{
										new_sample = "qrally/engine/ma04.wav";
									}
									else
									{
										if (speed_ratio <= 12)
										{
											new_sample = "qrally/engine/ma05.wav";
										}
										else
										{
											if (speed_ratio <= 14)
											{
												new_sample = "qrally/engine/ma06.wav";
											}
											else
											{
												if (speed_ratio <= 16)
												{
													new_sample = "qrally/engine/ma07.wav";
												}
												else
												{
													if (speed_ratio <= 18)
													{
														new_sample = "qrally/engine/ma08.wav";
													}
													else
													{
														if (speed_ratio <= 20)
														{
															if (self.flags & FL_ONGROUND)
															{
																new_sample = "qrally/engine/ma09.wav";
																speed_ratio = 19;
															}
															else
															{
																new_sample = "qrally/engine/ma10.wav";
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
				else
				{
					ch = "t";
					if (speed_ratio <= 2)
					{
						new_sample = "qrally/engine/test01.wav";
					}
					else
					{
						if (speed_ratio <= 4)
						{
							new_sample = "qrally/engine/test01.wav";
						}
						else
						{
							if (speed_ratio <= 6)
							{
								new_sample = "qrally/engine/test02.wav";
							}
							else
							{
								if (speed_ratio <= 8)
								{
									new_sample = "qrally/engine/test03.wav";
								}
								else
								{
									if (speed_ratio <= 10)
									{
										new_sample = "qrally/engine/test04.wav";
									}
									else
									{
										if (speed_ratio <= 12)
										{
											new_sample = "qrally/engine/test05.wav";
										}
										else
										{
											if (speed_ratio <= 14)
											{
												new_sample = "qrally/engine/test06.wav";
											}
											else
											{
												if (speed_ratio <= 16)
												{
													new_sample = "qrally/engine/test07.wav";
												}
												else
												{
													if (speed_ratio <= 18)
													{
														new_sample = "qrally/engine/test08.wav";
													}
													else
													{
														if (speed_ratio <= 20)
														{
															if (self.flags & FL_ONGROUND)
															{
																new_sample = "qrally/engine/test09.wav";
																speed_ratio = 19;
															}
															else
															{
																new_sample = "qrally/engine/test10.wav";
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
			if (self.car_index == 2)
			{
				ch = "s";
				if (speed_ratio <= 1)
				{
					new_sample = "qrally/engine/su01.wav";
				}
				else
				{
					if (speed_ratio == 2)
					{
						new_sample = "qrally/engine/su02.wav";
					}
					else
					{
						if (speed_ratio == 3)
						{
							new_sample = "qrally/engine/su03.wav";
						}
						else
						{
							if (speed_ratio == 4)
							{
								new_sample = "qrally/engine/su04.wav";
							}
							else
							{
								if (speed_ratio == 5)
								{
									new_sample = "qrally/engine/su05.wav";
								}
								else
								{
									if (speed_ratio == 6)
									{
										new_sample = "qrally/engine/su06.wav";
									}
									else
									{
										if (speed_ratio == 7)
										{
											new_sample = "qrally/engine/su07.wav";
										}
										else
										{
											if (speed_ratio == 8)
											{
												new_sample = "qrally/engine/su08.wav";
											}
											else
											{
												if (speed_ratio == 9)
												{
													new_sample = "qrally/engine/su09.wav";
												}
												else
												{
													if (speed_ratio == 10)
													{
														new_sample = "qrally/engine/su10.wav";
													}
													else
													{
														if (speed_ratio == 11)
														{
															new_sample = "qrally/engine/su11.wav";
														}
														else
														{
															if (speed_ratio == 12)
															{
																new_sample = "qrally/engine/su12.wav";
															}
															else
															{
																if (speed_ratio == 13)
																{
																	new_sample = "qrally/engine/su13.wav";
																}
																else
																{
																	if (speed_ratio == 14)
																	{
																		new_sample = "qrally/engine/su14.wav";
																	}
																	else
																	{
																		if (speed_ratio == 15)
																		{
																			new_sample = "qrally/engine/su15.wav";
																		}
																		else
																		{
																			if (speed_ratio == 16)
																			{
																				new_sample = "qrally/engine/su16.wav";
																			}
																			else
																			{
																				if (speed_ratio == 17)
																				{
																					new_sample = "qrally/engine/su17.wav";
																				}
																				else
																				{
																					if (speed_ratio == 18)
																					{
																						new_sample = "qrally/engine/su18.wav";
																					}
																					else
																					{
																						if (speed_ratio == 19)
																						{
																							new_sample = "qrally/engine/su19.wav";
																						}
																						else
																						{
																							if (speed_ratio <= 20)
																							{
																								if (self.flags & FL_ONGROUND)
																								{
																									new_sample = "qrally/engine/su19.wav";
																									speed_ratio = 19;
																								}
																								else
																								{
																									new_sample = "qrally/engine/su20.wav";
																								}
																							}
																						}
																					}
																				}
																			}
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
			else
			{
				if (self.car_index == 3)
				{
					ch = "a";
					if (speed_ratio <= 2)
					{
						new_sample = "qrally/engine/aa01.wav";
					}
					else
					{
						if (speed_ratio <= 4)
						{
							new_sample = "qrally/engine/aa01.wav";
						}
						else
						{
							if (speed_ratio <= 6)
							{
								new_sample = "qrally/engine/aa02.wav";
							}
							else
							{
								if (speed_ratio <= 8)
								{
									new_sample = "qrally/engine/aa03.wav";
								}
								else
								{
									if (speed_ratio <= 10)
									{
										new_sample = "qrally/engine/aa04.wav";
									}
									else
									{
										if (speed_ratio <= 12)
										{
											new_sample = "qrally/engine/aa05.wav";
										}
										else
										{
											if (speed_ratio <= 14)
											{
												new_sample = "qrally/engine/aa06.wav";
											}
											else
											{
												if (speed_ratio <= 16)
												{
													new_sample = "qrally/engine/aa07.wav";
												}
												else
												{
													if (speed_ratio <= 18)
													{
														new_sample = "qrally/engine/aa08.wav";
													}
													else
													{
														if (speed_ratio <= 20)
														{
															if (self.flags & FL_ONGROUND)
															{
																new_sample = "qrally/engine/aa09.wav";
																speed_ratio = 19;
															}
															else
															{
																new_sample = "qrally/engine/aa10.wav";
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
				else
				{
					if (self.car_index == 5)
					{
						ch = "r";
						if (speed_ratio <= 2)
						{
							new_sample = "qrally/engine/tri01.wav";
						}
						else
						{
							if (speed_ratio <= 4)
							{
								new_sample = "qrally/engine/tri01.wav";
							}
							else
							{
								if (speed_ratio <= 6)
								{
									new_sample = "qrally/engine/tri02.wav";
								}
								else
								{
									if (speed_ratio <= 8)
									{
										new_sample = "qrally/engine/tri03.wav";
									}
									else
									{
										if (speed_ratio <= 10)
										{
											new_sample = "qrally/engine/tri04.wav";
										}
										else
										{
											if (speed_ratio <= 12)
											{
												new_sample = "qrally/engine/tri05.wav";
											}
											else
											{
												if (speed_ratio <= 14)
												{
													new_sample = "qrally/engine/tri06.wav";
												}
												else
												{
													if (speed_ratio <= 16)
													{
														new_sample = "qrally/engine/tri07.wav";
													}
													else
													{
														if (speed_ratio <= 18)
														{
															new_sample = "qrally/engine/tri08.wav";
														}
														else
														{
															if (speed_ratio <= 20)
															{
																if (self.flags & FL_ONGROUND)
																{
																	new_sample = "qrally/engine/tri09.wav";
																	speed_ratio = 19;
																}
																else
																{
																	new_sample = "qrally/engine/tri10.wav";
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
			if (self.last_engine_chan == 2)
			{
				self.SAMP_ENGINE1 = new_sample;
				self.SNDLEN_ENGINE1 = 0.2;
				self.last_engine_chan = 1;
			}
			else
			{
				self.SAMP_ENGINE2 = new_sample;
				self.SNDLEN_ENGINE2 = 0.2;
				self.last_engine_chan = 2;
			}
			self.last_engine_ratio = speed_ratio;
			vol = 0.15 + speed_ratio / 20 * 0.3;
			if (self.car_index >= 3 && self.car_index <= 4)
			{
				vol = vol * 1.5;
			}
			samp = ceil(speed_ratio / 2);
			if (samp > 10)
			{
				samp = 10;
			}
			else
			{
				if (samp < 1)
				{
					samp = 1;
				}
			}
			if (self.last_engine1 < time - self.SNDLEN_ENGINE1 && self.SAMP_ENGINE1 != "")
			{
				if (deathmatch < 10 || self.lastmove_z > 0)
				{
					sound(self, CHAN_VOICE, self.SAMP_ENGINE1, 1, 1);
				}
				else
				{
					stuffcmd(self, ch);
					new_sample = ftos(samp);
					stuffcmd(self, new_sample);
					stuffcmd(self, "\n");
				}
				self.last_engine1 = time;
				self.last_engine2 = time;
				self.last_idle = 0;
			}
			if (self.last_engine2 < time - self.SNDLEN_ENGINE2 && self.SAMP_ENGINE2 != "")
			{
				if (deathmatch < 10 || self.lastmove_z > 0)
				{
					sound(self, CHAN_BODY, self.SAMP_ENGINE2, 1, 1);
				}
				else
				{
					stuffcmd(self, ch);
					new_sample = ftos(samp);
					stuffcmd(self, new_sample);
					stuffcmd(self, "\n");
				}
				self.last_engine1 = time;
				self.last_engine2 = time;
				self.last_idle = 0;
			}
		}
		else
		{
			if (hold_flag && vel_speed > self.last_speed && (self.racing_flags & QR_START_READY) && self.last_rev < time - SNDLEN_REV)
			{
				self.last_rev = time;
				if (self.car_index == 4) {
					sound(self, CHAN_WEAPON, "qrally/rev3.wav", 1, ATTN_STATIC);
					self.last_rev = time - 0.5;
				} else {
					if (self.car_index == 3) {
						sound(self, CHAN_WEAPON, "qrally/rev4.wav", 1, ATTN_STATIC);
					} else {
						sound(self, CHAN_WEAPON, "qrally/rev2.wav", 1, ATTN_STATIC);
					}
				}
			}
			if (self.last_idle < time - SNDLEN_IDLE && (self.racing_flags & QR_START_READY) && self.ignition_time < time - SNDLEN_IGNITION) {
				if (self.car_index == 1) {
					sound(self, CHAN_VOICE, "qrally/engine/aa01.wav", 0.4, ATTN_STATIC);
					sound(self, CHAN_BODY, "qrally/engine/aa01.wav", 0, ATTN_STATIC);
				} else {
					if (self.car_index == 2) {
						sound(self, CHAN_VOICE, "qrally/engine/suidle.wav", 0.4, ATTN_STATIC);
						sound(self, CHAN_BODY, "qrally/engine/suidle.wav", 0, ATTN_STATIC);
					} else {
						if (self.car_index == 3) {
							sound(self, CHAN_VOICE, "qrally/engine/aa01.wav", 0.4, ATTN_STATIC);
							sound(self, CHAN_BODY, "qrally/engine/aa01.wav", 0, ATTN_STATIC);
						} else {
							if (self.car_index == 4) {
								if (self.veh_body.skin == 0) {
									sound(self, CHAN_VOICE, "qrally/engine/test01.wav", 0.4, ATTN_STATIC);
									sound(self, CHAN_BODY, "qrally/engine/test01.wav", 0, ATTN_STATIC);
								} else {
									sound(self, CHAN_VOICE, "qrally/engine/ma01.wav", 0.4, ATTN_STATIC);
									sound(self, CHAN_BODY, "qrally/engine/ma01.wav", 0, ATTN_STATIC);
								}
							} else {
								if (self.car_index == 5) {
									sound(self, CHAN_VOICE, "qrally/engine/tri01.wav", 0.4, ATTN_STATIC);
									sound(self, CHAN_BODY, "qrally/engine/tri01.wav", 0, ATTN_STATIC);
								}
							}
						}
					}
				}
				self.last_idle = time;
				self.last_engine1 = 0;
			}
		}
	}
};

void(float max_dist) body_close_to_ground = {
	local entity e, etemp;
	local vector org;

	org = self.origin;
	traceline(org, org - '0 0 1' * max_dist, 0, self);
	if (trace_fraction < 1) {
		if (trace_ent == world) return TRUE;
	}
};

entity(entity old_next) FindNextMarker = {
	local entity trav;
	local float marker_count, next_index;

	trav = find(world, classname, "rally_startfinish");
	if (trav) {
		marker_count = trav.ammo_shells;
		next_index = old_next.ammo_shells + 1;
		if (next_index > marker_count) next_index = 1;
	} else {
		dprint("Unable to find Start/Finish entity\n");
		return world;
	}
	trav = world;
	while ((trav = find(trav, classname, "rally_marker")) != world) {
		if (trav.ammo_shells == next_index) return trav;
	}
	dprint("Unable to find next marker entity\n");
	return world;
};

void() MoveVehicle = {
	local vector vel_angles;
	local vector veh_dir_angles;
	local vector veh_angles;
	local vector reb_vect;
	local vector body_vect;
	local vector angle;
	local vector vtemp;
	local vector ideal_org;
	local float vel_speed;
	local float old_z;
	local float ftemp;
	local float too_steep;
	local float num_collisions;
	local float last_collision;
	local float max_speed;
	local float collision_type;
	local float adjust_body;
	local float this_pitch;
	local float old_dist;
	local float new_dist;
	local vector new_org;
	local vector dir_angles;
	local vector old_org;
	local entity oself;
	local string str;
	old_z = self.veh_body.origin_z;
	if (self.origin_z < -3000 && self.classname == "player")
	{
		bprint(self.netname);
		bprint(" visits the angels\n");
		T_Damage(self, world, world, 500);
		return;
	}
	vel_speed = vlen(self.velocity);
	self.lastmove = self.origin - self.oldorigin;
	if (self.lastmove_z == 0)
	{
		self.last_flat_z = self.origin_z;
	}
	if (rally_type_index < 3 && !(global_racing_flags & QR_NO_STARTFINISH))
	{
		new_dist = vlen(self.origin - self.next_marker.origin);
		old_dist = vlen(self.oldorigin - self.next_marker.origin);
		if (new_dist < 64 || (cvar("skill") <= 1 || !challenge && new_dist > old_dist && old_dist < 384))
		{
			oself = self;
			self = self.next_marker;
			other = oself;
			marker_touch();
			self = oself;
			self.next_marker = FindNextMarker(self.next_marker);
		}
		else
		{
			if (challenge && new_dist > old_dist && old_dist < 312 && self.last_turnaround < time - 1)
			{
				centerprint(self, "Marker missed!");
				commentary(self, "qrally/voice/wrongway.wav");
				self.last_turnaround = time;
			}
		}
	}
	if (self.classname == "player" && vel_speed < 25 && !(self.reversing) && !(self.accelerating))
	{
		traceline(self.origin, self.origin - '0 0 64', 1, self);
		if (trace_plane_normal_z < 1)
		{
			self.velocity = '0 0 0';
			self.origin = self.oldorigin;
			self.lastmove = '0 0 0';
		}
	}
	if (self.flags & FL_ONGROUND)
	{
		if (self.racing_flags & QR_MINE_EXPLODED)
		{
			self.racing_flags = self.racing_flags - QR_MINE_EXPLODED;
		}
	}
	if (!MoveTail())
	{
		return;
	}
	vel_speed = vlen(self.velocity);
	if (self.flags & FL_ONGROUND && self.use_surface_angle)
	{
		SetSurfaceAngle();
	}
	else
	{
		if (!(self.flags & FL_ONGROUND) && !(self.last_flags & FL_ONGROUND))
		{
			self.veh_body.veh_dir_z = self.veh_body.veh_dir_z + self.veh_body.roll_velocity_z * frametime;
			if (self.veh_body.veh_dir_z < -180)
			{
				self.veh_body.veh_dir_z = self.veh_body.veh_dir_z + 360;
			}
		}
	}
	vel_angles = vectoangles(self.veh_dir);
	self.veh_body.angles_y = vel_angles_y;
	if (self.flags & FL_ONGROUND)
	{
		self.veh_body.angles_x = vel_angles_x;
	}
	else
	{
		if (self.classname == "player")
		{
			dir_angles = self.veh_body.angles;
			makevectors(dir_angles);
			dir_angles_y = MoveToAngle(dir_angles_y, dir_angles_y + self.veh_body.roll_velocity_y * frametime, 1000);
			self.veh_body.angles_y = dir_angles_y;
			if (self.leave_ground_time > time - 1)
			{
				self.veh_body.angles_x = self.veh_body.angles_x + self.veh_body.roll_velocity_x * (time - self.leave_ground_time) * frametime;
			}
			else
			{
				self.veh_body.angles_x = self.veh_body.angles_x + self.veh_body.roll_velocity_x / 4 * frametime;
			}
			if (self.veh_body.angles_x > 180)
			{
				self.veh_body.angles_x = self.veh_body.angles_x - 360;
			}
			else
			{
				if (self.veh_body.angles_x < -180)
				{
					self.veh_body.angles_x = self.veh_body.angles_x + 360;
				}
			}
			if (self.veh_body.angles_x > 40 && self.veh_body.roll_velocity_x > 0 || (self.veh_body.angles_x < -40 && self.veh_body.roll_velocity_x < 0))
			{
				self.veh_body.roll_velocity_x = 0;
			}
			if (self.veh_body.angles_x > 25 && self.veh_body.roll_velocity_x > 0 || (self.veh_body.angles_x < -25 && self.veh_body.roll_velocity_x < 0))
			{
				self.veh_body.roll_velocity_x = self.veh_body.roll_velocity_x * 0.9;
			}
		}
	}
	if (self.veh_body.veh_dir_z > 180)
	{
		self.veh_body.angles_z = self.veh_body.veh_dir_z - 360;
	}
	else
	{
		self.veh_body.angles_z = self.veh_body.veh_dir_z;
	}
	self.veh_body.angles_z = self.veh_body.angles_z + self.angles_z;
	makevectors(self.veh_body.angles);
	self.veh_dir = v_forward;
	if (self.flags & FL_ONGROUND)
	{
		self.veh_body.angles = self.veh_body.angles + self.body_roll;
	}
	else
	{
		self.veh_body.angles_z = self.veh_body.angles_z + self.body_roll_z;
	}
	setorigin(self.veh_body, self.origin - v_forward * (VEH_LENGTH / 2) - v_forward * dist_infront + VEH_BODY_OFFSET + v_forward * (vel_speed / MAX_SPEED) * 8 * (1 - hold_flag));
	if (self.car_index == 5)
	{
		setorigin(self.veh_body, self.veh_body.origin + '0 0 4');
	}
	if (self.classname == "rally_bot")
	{
		self.veh_body.origin = self.veh_body.origin - '0 0 8';
	}
	if (self.veh_body.last_velocity == '0 0 0')
	{
		self.veh_body.last_velocity = self.veh_body.origin;
	}
	if (self.veh_body.angles_x > 40 && self.veh_body.angles_x < 180)
	{
		self.veh_body.angles_x = 40;
	}
	if (self.veh_body.angles_x >= 180 && self.veh_body.angles_x < 320)
	{
		self.veh_body.angles_x = 320;
	}
	angle = self.veh_body.angles;
	veh_angles = self.veh_body.veh_dir;
	veh_angles_x = anglemod(veh_angles_x);
	traceline(self.origin, self.origin - '0 0 64', 1, self);
	if (trace_fraction < 1 && trace_plane_normal_z < 0.95)
	{
		this_pitch = 50;
	}
	else
	{
		this_pitch = ROLL_PER_SECOND_z;
	}
	if (fabs(angle_diff(veh_angles_x, angle_x)) > this_pitch * frametime)
	{
		angle_x = MoveToAngle(veh_angles_x, angle_x, this_pitch);
		self.veh_body.angles_x = angle_x;
	}
	self.veh_body.veh_dir_x = angle_x;
	makevectors(self.veh_body.angles);
	setorigin(self.veh_body, self.veh_body.origin + '0 0 1' * VEH_BODY_OFFSET_z);
	if (self.origin_z > self.oldorigin_z && (self.flags & FL_ONGROUND) && self.accelerating && vel_speed > MAX_SPEED / 2 && !(self.reversing))
	{
		vtemp = v_forward;
		vtemp_z = 0;
		vtemp = normalize(vtemp);
		traceline(self.origin, self.origin + vtemp * 64, 1, world);
		too_steep = 0;
		if (trace_fraction < 1)
		{
			if (trace_plane_normal_z < 0.3)
			{
				too_steep = 1;
			}
		}
		if (!too_steep)
		{
			self.velocity = normalize(self.velocity) * self.last_speed;
			if (vel_speed < MAX_SPEED / 2)
			{
				self.velocity = self.velocity + normalize(self.velocity) * 200 * frametime;
			}
			vel_speed = vlen(self.velocity);
		}
	}
	adjust_body = 1;
	if (adjust_body)
	{
		old_org = self.veh_body.last_velocity + (self.veh_body.origin - self.veh_body.last_velocity);
		ideal_org = self.veh_body.origin;
		if (v_up_z < 0)
		{
			ideal_org = ideal_org + '0 0 8';
		}
		ftemp = fabs(v_up_z);
		ideal_org = ideal_org + (1 - ftemp) * '0 0 16';
		if (v_forward_z < 0)
		{
			v_forward_z = 0;
		}
		ideal_org = ideal_org + v_forward_z * '0 0 20';
		if (self.leave_ground_time > time - 1)
		{
			ideal_org = self.veh_body.origin + (ideal_org - self.veh_body.origin) * (time - self.leave_ground_time);
		}
		else
		{
			if (self.last_land < time - 1 && self.leave_ground_time < time - 1)
			{
				ftemp = (ideal_org_z - self.veh_body.origin_z) * 2;
				if (ftemp > 48)
				{
					ftemp = 48;
				}
				ideal_org_z = self.veh_body.origin_z - ftemp;
			}
		}
		self.veh_body.origin_z = old_org_z + (ideal_org_z - old_org_z) * frametime;
		self.veh_body.last_velocity = self.veh_body.origin;
	}
	if (self.classname == "player")
	{
		self.armorvalue = ceil(vlen(self.lastmove) * 1600 / frametime / 64 / 100);
		if (self.armorvalue < 0)
		{
			self.armorvalue = 0;
		}
		if (rally_type_index == 1 && !(self.racing_flags & QR_FINISHED_RACE) && !(self.racing_flags & QR_OUT_OF_TIME) && racing_type == RT_TIME_TRIAL && !hold_flag)
		{
			self.time_remaining = self.time_remaining - frametime;
			self.currentammo = self.time_remaining;
			if (self.time_remaining < 1)
			{
				self.racing_flags = self.racing_flags | QR_OUT_OF_TIME;
				centerprint(self, "You are out of time.\n");
			}
			else
			{
				if (self.time_remaining < 5 && self.time_remaining != self.last_time_remaining)
				{
					commentary(self, "qrally/voice/tone05.wav");
				}
			}
			self.last_time_remaining = self.time_remaining;
		}
	}
	max_speed = cvar("sv_maxspeed");
	CheckForCollision(vel_speed);
	if (!(self.deadflag))
	{
		DoEngineNoises(vel_speed);
	}
	self.last_speed = vel_speed;
	if (hold_flag)
	{
		self.velocity = '0 0 0';
	}
	traceline(self.origin, self.origin - '0 0 48', 0, self);
	if (self.veh_body.origin_z - old_z > 4 && self.veh_body.origin_z - old_z < 32 && trace_plane_normal_z == 1)
	{
		new_org = self.veh_body.origin;
		new_org_z = old_z + (self.veh_body.origin_z - old_z) * 6 * (1 + vel_speed / MAX_SPEED * 4) * frametime;
		if (new_org_z > self.veh_body.origin_z)
		{
			new_org_z = self.veh_body.origin_z;
		}
		setorigin(self.veh_body, new_org);
	}
	MoveWheels();
	if (self.chasecam != world)
	{
		self = self.chasecam;
		Keep_cam_chasing_owner();
		self = self.owner;
	}
	self.back_vel = self.velocity;
};

void() checkSteering = 
{
	local float head_diff;
	local float ftemp;
	local vector veh_angles;
	local vector vel;
	local float new_heading;
	local float vel_speed;
	vel_speed = vlen(self.velocity);
	vel = vectoangles(self.velocity);
	veh_angles = vectoangles(self.veh_dir);
	new_heading = anglemod(self.angles_y + 1.9);
	head_diff = angle_diff(new_heading, self.old_angles_y);
	if (self.steering == STEER_CENTER)
	{
		ftemp = self.steer_angles_y;
		if (fabs(angle_diff(self.steer_angles_y, veh_angles_y) < 5))
		{
			self.steer_angles_y = veh_angles_y;
		}
		else
		{
			self.steer_angles_y = MoveToAngle(self.steer_angles_y, veh_angles_y, STEERING_CENTERSPEED);
		}
	}
	else
	{
		if (self.steering == STEER_RIGHT)
		{
			self.steer_angles_y = anglemod(self.steer_angles_y + STEERING_TURNSPEED * frametime);
			if (fabs(angle_diff(self.steer_angles_y, veh_angles_y)) > VEH_MAX_STEER)
			{
				self.steer_angles_y = anglemod(veh_angles_y + VEH_MAX_STEER);
			}
		}
		else
		{
			if (self.steering == STEER_LEFT)
			{
				self.steer_angles_y = anglemod(self.steer_angles_y - STEERING_TURNSPEED * frametime);
				if (fabs(angle_diff(self.steer_angles_y, veh_angles_y)) > VEH_MAX_STEER)
				{
					self.steer_angles_y = anglemod(veh_angles_y - VEH_MAX_STEER);
				}
			}
		}
	}
	bprint(ftos(self.steer_angles_y));
	bprint(" - (");
	bprint(ftos(veh_angles_y));
	bprint(")\n");
	self.veh_body.steer_angles_y = MoveToAngle(self.veh_body.steer_angles_y, self.steer_angles_y, 900);
	if (!(self.reversing))
	{
		vel_y = self.veh_body.steer_angles_y;
		makevectors(vel);
		self.velocity = normalize(v_forward + self.veh_tail.veh_dir * (vel_speed / (MAX_SPEED * 2))) * vel_speed;
	}
};

void(float index) SteerChange = 
{
	local float real_index;
	real_index = index;
	if (fabs(self.owner.weaponframe - index) > 1)
	{
		index = self.owner.weaponframe + ((index > self.owner.weaponframe) * 2 - 1) * frametime * 20;
	}
	if (real_index == index)
	{
		return;
	}
	if (real_index < self.owner.weaponframe && index < real_index)
	{
		index = real_index;
	}
	else
	{
		if (real_index > self.owner.weaponframe && index > real_index)
		{
			index = real_index;
		}
	}
	if (index > 16)
	{
		index = 16;
	}
	else
	{
		if (index < 0)
		{
			index = 0;
		}
	}
	self.owner.weaponframe = index;
	self.owner.last_steerchange = time;
};

void() calc_steering_controls = 
{
	local float steer;
	local float before;
	local float after;
	local string str;
	before = anglemod(self.last_heading);
	after = anglemod(self.angles_y);
	steer = angle_diff(before, after);
	if (steer > 180)
	{
		steer = steer - 360;
	}
	if (fabs(steer) < 3)
	{
		self.steering = STEER_CENTER;
	}
	else
	{
		if (steer > 0)
		{
			self.steering = STEER_LEFT;
		}
		else
		{
			if (steer < 0)
			{
				self.steering = STEER_RIGHT;
			}
		}
	}
};

void() VehiclePreThink = {
	local float mspeed, aspeed, angle_between, dir, veh_heading, tail_heading, max_steer, ftemp, damage_accel, damage_topspeed, vel_speed, old_vel_speed;
	local vector old_vel, vtemp, steer_angle, vel_angles, back_angles;
	local string str;

	vel_speed = vlen(self.velocity);
	self.veh_body.colormap = self.colormap;
	ftemp = vel_speed - vlen(self.back_vel);
	if (self.racing_flags & QR_OUT_OF_TIME) {
		if (self.flags & FL_ONGROUND) {
			old_vel_speed = vlen(self.old_velocity);
			vtemp = normalize(self.old_velocity) * OUT_OF_TIME_SLOWDOWN * frametime;
			if (vlen(vtemp) < old_vel_speed) {
				self.velocity = self.old_velocity - vtemp;
			} else {
				self.velocity = '0 0 0';
			}
		}
		if (vel_speed < 10) DestroyVehicle();
	}
	if (self.zoomin) {
		self.chasecam_zoom = self.chasecam_zoom - ZOOM_SPEED * frametime;
		if (self.chasecam_zoom < 5) self.chasecam_zoom = 5;
	} else {
		if (self.zoomout) {
			self.chasecam_zoom = self.chasecam_zoom + ZOOM_SPEED * frametime;
			if (self.chasecam_zoom > 200) self.chasecam_zoom = 200;
		}
	}
	if (self.cam == CAM_TEST) calc_steering_controls();

	if (pointcontents(self.origin) == CONTENT_LAVA) { DestroyVehicle(); return; }

	checkHealth();
	if ((self.veh_body.effects & EF_DIMLIGHT) && (self.last_crash < time - 0.5)) self.veh_body.effects = self.veh_body.effects - EF_DIMLIGHT;

	if (self.misc_flags & MISC_HORN_ON && self.horn_time < time - SNDLEN_HORN) {
		if (self.car_index < 3) {
			sound(self, CHAN_AUTO, "qrally/meepmeep.wav", 1, ATTN_STATIC);
		} else {
			sound(self, CHAN_AUTO, "qrally/nexus/horn.wav", 1, ATTN_STATIC);
		}
		self.horn_time = time;
	}
	makevectors(self.veh_body.angles);
	if (self.mine_attached != world) {
		if (v_up_z < 0.1) {
			remove(self.mine_attached);
			sprint(self, "Detonator removed\n");
			self.mine_attached = world;
		}
	}
	if (self.flags & FL_ONGROUND) {
		if (v_up_z < 0.1) {
			self.use_surface_angle = 0;
			aspeed = self.velocity_z;
			mspeed = vlen(self.old_velocity);
			self.velocity = normalize(self.origin - self.oldorigin);
			if (mspeed > 10) {
				self.velocity = self.velocity * (mspeed * 0.8);
			} else {
				self.velocity = '0 0 0';
				DestroyVehicle();
			}
		} else {
			if (v_up_z > 0.5) {
				if (!(self.use_surface_angle)) sound(self, CHAN_AUTO, "demon/dland2.wav", 0.5, ATTN_STATIC);
				self.use_surface_angle = 1;
				self.veh_body.angles_z = 0;
			} else {
				if (self.veh_body.roll_velocity_z > 0) {
					self.veh_body.roll_velocity_z = 20;
				} else {
					self.veh_body.roll_velocity_z = -20;
				}
				self.flags = self.flags - FL_ONGROUND;
				self.last_flags = self.last_flags - (self.last_flags & FL_ONGROUND);
				self.velocity = self.velocity + '0 0 50';
			}
		}
	}
	if (self.flags & FL_ONGROUND) vtemp = vectoangles(self.veh_tail.veh_dir);
	tail_heading = anglemod(vtemp_y);
	vtemp = vectoangles(self.veh_dir);
	veh_heading = anglemod(vtemp_y);
	angle_between = angle_diff(veh_heading, tail_heading);
	angle_between = fabs(angle_between);
	if ((mspeed = vlen(self.velocity)) > self.last_speed) {
		damage_accel = 1 + (1 - mspeed / MAX_SPEED) * 2;
		damage_topspeed = MAX_SPEED * damage_accel;
		if (self.origin_z - self.oldorigin_z <= 0) {
			aspeed = self.last_speed + (mspeed - self.last_speed) * VEH_ACCEL_SLOWDOWN * ((self.cam == CAM_INCAR) + 1) * damage_accel;
		} else {
			aspeed = vlen(self.velocity);
		}
		if (aspeed > damage_topspeed) aspeed = damage_topspeed;
		self.velocity = normalize(self.velocity) * aspeed;
		if (mspeed < MAX_SPEED / 2 && self.last_slide < time - SNDLEN_SLIDE && self.last_speed < mspeed && vel_speed > 100 && !hold_flag && !(self.reversing)) {
			if (self.current_surface == SURF_MUD) {
				sound(self, CHAN_AUTO, "qrally/skidmud.wav", 0.8, ATTN_STATIC);
			} else {
				sound(self, CHAN_AUTO, "qrally/ray/screech4.wav", 0.8, ATTN_STATIC);
			}
			self.last_slide = time;
		}
	}
	vel_speed = vlen(self.velocity);
	if (deathmatch != 10 && self.waterlevel && vel_speed > MAX_SPEED / 3) {
		makevectors(self.veh_body.angles);
		ftemp = 37 + random() * 6;
		particle(self.origin + v_right * 12, (v_up + v_right) * 100 + self.velocity * 0.75, ftemp, vel_speed / MAX_SPEED * 80);
		ftemp = 36 + random() * 6;
		particle(self.origin - v_right * 12, (v_up - v_right) * 100 + self.velocity * 0.75, ftemp, vel_speed / MAX_SPEED * 80);
	}
	if (vel_speed == 0 && !(self.reversing) && self.cam != CAM_INCAR && self.cam != CAM_TEST) {
		vtemp = vectoangles(self.veh_dir);
		ftemp = angle_diff(vtemp_y, self.angles_y);
		if (fabs(ftemp) < 180) {
			if (ftemp > 0) {
				dir = 25;
			} else {
				dir = -25;
			}
		} else {
			dir = 0;
		}
		vtemp_y = anglemod(vtemp_y + dir);
		makevectors(vtemp);
		self.veh_tail.veh_dir = v_forward;
	} else {
		if (vlen(self.lastmove) < 1) self.veh_tail.veh_dir = self.veh_dir;
	}
	if (self.cam == CAM_TEST) {
		checkSteering();
	} else {
		old_vel = self.velocity;
		plyr_angles = self.angles;
		steer_angle = vectoangles(self.veh_dir);
		self.angles_y = anglemod(self.angles_y);
		angle_between = angle_diff(steer_angle_y, self.angles_y);
		mspeed = vlen(self.velocity);
	}
	if (self.reversing) {
		dir = -1;
	} else {
		dir = 1;
	}
	if (self.fwhl) {
		self = self.fwhl;
	} else {
		self = self.veh_body;
	}
	if (fabs(angle_between) < 10 || self.reversing) {
		if (!deathmatch) rally_centre();
		if (angle_between >= 5) {
			SteerChange(7);
		} else {
			if (angle_between <= -5) {
				SteerChange(9);
			} else {
				SteerChange(8);
			}
		}
	} else {
		if (angle_between > 0) {
			if (angle_between >= 40) {
				if (!deathmatch) rally_right30();
				SteerChange(0);
			} else {
				if (angle_between >= 30) {
					if (!deathmatch) rally_right30();
					if (angle_between >= 35) {
						SteerChange(1);
					} else {
						SteerChange(2);
					}
				} else {
					if (angle_between >= 20) {
						if (!deathmatch) rally_right20();
						if (angle_between >= 25) {
							SteerChange(3);
						} else {
							SteerChange(4);
						}
					} else {
						if (!deathmatch) rally_right10();

						if (angle_between >= 15) {
							SteerChange(5);
						} else {
							SteerChange(6);
						}
					}
				}
			}
		} else {
			if (angle_between <= -40) {
				if (!deathmatch) rally_left30();
				SteerChange(16);
			} else {
				if (angle_between <= -30) {
					if (!deathmatch) rally_left30();
					if (angle_between <= -35) {
						SteerChange(15);
					} else {
						SteerChange(14);
					}
				} else {
					if (angle_between <= -20) {
						if (!deathmatch) rally_left20();
						if (angle_between <= -25) {
							SteerChange(13);
						} else {
							SteerChange(12);
						}
					} else {
						if (!deathmatch) rally_left10();
						if (angle_between <= -15) {
							SteerChange(11);
						} else {
							SteerChange(10);
						}
					}
				}
			}
		}
	}
	self = self.owner;
	if (deathmatch) {
		if (angle_between <= -30) {
			self.veh_body.frame = 4;
		} else {
			if (angle_between <= -15) {
				self.veh_body.frame = 3;
			} else {
				if (angle_between >= 30) {
					self.veh_body.frame = 2;
				} else {
					if (angle_between >= 15) {
						self.veh_body.frame = 1;
					} else {
						self.veh_body.frame = 0;
					}
				}
			}
		}
	}
	self.old_dir = dir;
	max_steer = VEH_MAX_STEER * (vel_speed / MAX_SPEED * 0.5 + 1);
	if (self.reversing) {
		self.angles_y = steer_angle_y + angle_between * 0.25;
		angle_between = angle_between * 0.25;
		max_steer = max_steer * 0.25;
	}
	if (self.classname == "player" && (self.reverse_release < time - 0.75 && (self.cam != CAM_TEST || self.reversing))) {
		if (angle_between > 0) {
			if (angle_between > max_steer || self.reversing) {
				if (angle_between > max_steer) self.angles_y = steer_angle_y - max_steer;
				if (self.angles_y < 0) {
					self.angles_y = self.angles_y + 360;
				} else {
					if (self.angles_y >= 360) self.angles_y = self.angles_y - 360;
				}
				if (self.flags & FL_ONGROUND && (self.last_land > time - 2 || mspeed < 200)) {
					if (dir == -1 && mspeed > cvar("cl_backspeed")) mspeed = cvar("cl_backspeed");
					plyr_velocity = vectoangles(self.velocity);
					plyr_velocity_y = self.angles_y;
					makevectors(plyr_velocity);
					if (mspeed > 200) {
						plyr_velocity = normalize(v_forward * dir * mspeed * 0 + self.velocity);
						plyr_velocity = plyr_velocity * (mspeed - 750 * ((angle_between - max_steer) / 45) * (mspeed / MAX_SPEED) * frametime);
					} else {
						plyr_velocity = v_forward * dir * mspeed;
					}
					self.velocity = plyr_velocity;
				}
			}
		} else {
			if (angle_between < -1 * max_steer || self.reversing) {
				if (angle_between < -1 * max_steer) self.angles_y = steer_angle_y + max_steer;
				if (self.angles_y < 0) {
					self.angles_y = self.angles_y + 360;
				} else {
					if (self.angles_y >= 360) self.angles_y = self.angles_y - 360;
				}
				if (self.flags & FL_ONGROUND && (self.last_land > time - 2 || mspeed < 200)) {
					if (dir == -1 && mspeed > cvar("cl_backspeed")) mspeed = cvar("cl_backspeed");
					plyr_velocity = vectoangles(self.velocity);
					plyr_velocity_y = self.angles_y;
					makevectors(plyr_velocity);
					if (mspeed > 200) {
						plyr_velocity = normalize(v_forward * dir * mspeed * 0 + self.velocity);
						plyr_velocity = plyr_velocity * (mspeed - 750 * ((max_steer - angle_between) / 45) * (mspeed / MAX_SPEED) * frametime);
					} else {
						plyr_velocity = v_forward * dir * mspeed;
					}
					self.velocity = plyr_velocity;
				}
			}
		}
	}
	self.velocity_z = old_vel_z;
	steer_angle = self.angles;
	self.angles = plyr_angles;
	if (!(self.cam == CAM_TEST)) self.steer_angles = self.angles;
	if (self.flags & FL_ONGROUND) {
		if (self.reversekey && !(self.racing_flags & QR_OUT_OF_TIME)) {
			plyr_velocity = normalize(self.velocity);
			if (vlen(self.velocity) > 100 && vlen(plyr_velocity + self.veh_dir) > 1.5) self.old_velocity = self.old_velocity - normalize(self.old_velocity) * (200 * frametime);
			makevectors(self.veh_body.angles);
			self.velocity = self.old_velocity - v_forward * (200 * frametime);
			if ((vlen(plyr_velocity + self.veh_dir) < 0.3) && (vlen(self.velocity) > 250)) self.velocity = normalize(self.velocity) * 250;
		} else {
			if (self.reversing) {
				plyr_velocity = normalize(self.old_velocity);
				if (vlen(plyr_velocity + self.veh_dir) < 0.5) {
					if (vlen(self.old_velocity) > 80) {
						self.velocity = self.old_velocity + self.veh_dir * (120 * frametime);
					} else {
						self.velocity = self.old_velocity + self.veh_dir * ((vlen(self.old_velocity) + 20) * frametime);
					}
				}
			}
		}
	}
	self.old_velocity = self.velocity;
	if (self.flags & FL_GODMODE && vlen(self.velocity) > MAX_SPEED / 2) self.velocity = normalize(self.velocity) * (MAX_SPEED / 2);
	self.last_velocity = self.velocity;
};

void() DestroyVehicleParts = {
	if (self.veh_tail) remove(self.veh_tail);
	if (self.veh_body) remove(self.veh_body);
	if (self.fwhl) remove(self.fwhl);
	if (self.rwhl) remove(self.rwhl);
	if (self.hl_r != world) remove(self.hl_r);
	if (self.hl_l != world) remove(self.hl_l);
	if (self.hl_m != world) remove(self.hl_m);
	if (self.gun != world) remove(self.gun);
};

void() CheckDriverReady = {
	local entity plyr;

	if (!hold_flag) return;
	if (self.racing_flags & QR_START_READY) return;
	self.racing_flags = self.racing_flags | QR_START_READY;
	if (first_engine_start == 0) first_engine_start = time;
	if (self.car_index == 3) sound(self, CHAN_AUTO, "qrally/ray/engstart.wav", 1, ATTN_STATIC);
	if (self.car_index == 4) sound(self, CHAN_AUTO, "qrally/start2.wav", 1, ATTN_STATIC);
	if (self.car_index == 4) sound(self, CHAN_AUTO, "qrally/start.wav", 1, ATTN_STATIC);
	self.ignition_time = time;
	plyr = find(world, classname, "player");
	while (plyr != world) {
		if (!(plyr.racing_flags & QR_START_READY) && !(plyr.racing_flags & QR_OBSERVER) && !(plyr.deadflag)) return;
		plyr = find(plyr, classname, "player");
	}
	starter.racing_flags = starter.racing_flags - (starter.racing_flags & QR_NOT_RACING);
	starter.last_lap = 3;
};

void() NullSelfModel = { setmodel(self, ""); };

void() PreRaceMsg = {
	local entity plyr;
	local entity startent;
	local string secs;
	if (self.racing_flags & QR_NOT_RACING) {
		plyr = find(world, classname, "player");
		while (plyr != world)
		{
			if (!(plyr.racing_flags & QR_START_READY) && !(plyr.racing_flags & QR_OBSERVER))
			{
				if (first_engine_start)
				{
					if (first_engine_start < time - 30)
					{
						sprint(plyr, "Automatic engine start\n");
						W_Attack();
					}
					else
					{
						if (first_engine_start < time - 20)
						{
							centerprint(plyr, "You now have less than 10 seconds\nto start your engine!");
						}
						else
						{
							centerprint(plyr, "Press FIRE when all players\nare ready!\n");
						}
					}
				}
				else
				{
					if (challenge)
					{
						if (world.model == "maps/qrally01.bsp")
						{
							centerprint(plyr, "Stage One: Time Trial stage\n\nFinish the race before your\ncar explodes. Flags give an\nextra 6 seconds when touched,\nin sequence.\n\nPress FIRE when ready!\n");
						}
						else
						{
							if (world.model == "maps/qrally02.bsp")
							{
								centerprint(plyr, "Stage Two: Time Trial stage\n\nYou have advanced to the\nsecond round.\nSame deal, try and stay alive.\n\nPress FIRE when ready!\n");
							}
							else
							{
								if (world.model == "maps/qrally03.bsp")
								{
									centerprint(plyr, "Stage Three: Time Trial stage\n\nFinal elimination, time is short, watch\nout for dangerous obstructions.\n\nPress FIRE when ready!\n");
								}
							}
						}
					} else {
						centerprint(plyr, "Press FIRE when all players\nare ready!\n");
					}
				}
			} else {
				centerprint(plyr, "Waiting for other drivers\n");
			}
			plyr = find(plyr, classname, "player");
		}
		self.nextthink = time + 1;
	} else {
		if (self.last_lap == 0) {
			plyr = find(world, classname, "player");
			while (plyr != world) {
				centerprint(plyr, "GO!");
				sound(plyr, CHAN_ITEM, "qrally/voice/gotst01.wav", 1, ATTN_STATIC);
				commentary(plyr, "qrally/voice/gotst01.wav");
				plyr.last_lap_time = time;
				plyr.time_remaining = TIMETRIAL_STARTTIME;
				if (cvar("skill") >= 3) plyr.time_remaining = floor(plyr.time_remaining * 0.65);
				plyr.velocity = '0 0 0';
				plyr = find(plyr, classname, "player");
			}
			if ((startent = find(world, classname, "rally_starter")) != world) {
				startent.skin = 2;
				startent.think = NullSelfModel;
				startent.nextthink = time + 3;
			}
			race_start_time = time;
			BuildPlayerList();
			hold_flag = 0;
			return;
		}
		secs = ftos(self.last_lap);
		plyr = find(world, classname, "player");
		while (plyr != world)
		{
			centerprint(plyr, secs);
			commentary(plyr, "qrally/voice/tone05.wav");
			plyr = find(plyr, classname, "player");
		}
		if ((startent = find(world, classname, "rally_starter")) != world)
		{
			if (self.last_lap == 2)
			{
				startent.skin = 0;
			}
			else
			{
				if (self.last_lap == 1)
				{
					startent.skin = 1;
				}
			}
		}
		self.nextthink = time + 1;
		self.last_lap = self.last_lap - 1;
	}
};

void() CheckFirstStartFinish = 
{
	if (first_startfinish_flag)
	{
		if (rally_type_index < 3)
		{
			hold_flag = 1;
			starter = spawn();
			starter.classname = "race_starter";
			starter.racing_flags = QR_NOT_RACING;
			starter.nextthink = time + 0.5;
			starter.think = PreRaceMsg;
		}
		global_racing_flags = global_racing_flags - (global_racing_flags & QR_NO_STARTFINISH);
		all_fastest_lap = 9999999;
		first_startfinish_flag = 0;
	}
};

void() finish_think = 
{
	self.frame = self.frame + 1;
	if (self.frame > 11)
	{
		self.frame = 0;
	}
	self.nextthink = time + 0.05;
};

void() spawn_finish_model = 
{
	local entity flag;
	local entity oself;
	if (rally_type_index > 2)
	{
		return;
	}
	if (find(world, classname, "rally_flag") != world)
	{
		return;
	}
	flag = spawn();
	flag.classname = "rally_flag";
	flag.view_ofs = '0 0 7';
	setsize(flag, VEC_HULL_MIN, VEC_HULL_MAX);
	setmodel(flag, "progs/qrally/finish.mdl");
	makevectors(self.angles);
	setorigin(flag, self.origin);
	traceline(flag.origin, flag.origin - '0 0 64', 1, flag);
	setorigin(flag, trace_endpos);
	flag.angles_y = self.angles_y;
	flag.think = finish_think;
	flag.nextthink = time + 0.1;
	remove(self);
};

void() rally_startfinish = 
{
	local vector min;
	local vector max;
	local float first;
	local entity place_flag;
	first = first_startfinish_flag;
	CheckFirstStartFinish();
	if (self.speed == 0)
	{
		self.speed = 128;
	}
	min = '-1 -1 0' * self.speed;
	min_z = -24;
	max = '1 1 0' * self.speed;
	max_z = 16;
	setsize(self, min, max);
	if (first)
	{
		place_flag = spawn();
		place_flag.origin = self.origin;
		place_flag.angles = self.angles;
		place_flag.nextthink = time + 0.5;
		place_flag.think = spawn_finish_model;
	}
	if (cvar("skill") <= 1 && !cvar("deathmatch"))
	{
		self.ammo_nails = floor(self.ammo_nails * 0.75);
	}
	else
	{
		if (cvar("deathmatch"))
		{
			self.ammo_nails = cvar("skill") * 2;
		}
	}
	self.touch = startfinish_touch;
	StartRallyItem();
};

void() rally_startfinish_brush = 
{
	CheckFirstStartFinish();
	self.touch = startfinish_touch;
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
	if (cvar("skill") <= 1 && !cvar("deathmatch"))
	{
		self.ammo_nails = floor(self.ammo_nails * 0.75);
	}
	else
	{
		if (cvar("deathmatch"))
		{
			self.ammo_nails = cvar("skill") * 2;
		}
	}
	self.classname = "rally_startfinish";
};

void() rally_startfinish_flag = 
{
	setsize(self, '-4 -4 0', '4 4 16');
	droptofloor();
	spawn_finish_model();
};

void() StartNextRace = 
{
	execute_changelevel();
	remove(self);
};

void(float pos) GetDriverAtPos = 
{
	local entity plyr;
	plyr = find(world, classname, "player");
};

void() ShowRaceResults = 
{
	local entity plyr;
	local entity trav;
	local float pos;
	if (race_finish_time < time)
	{
		self.think = StartNextRace;
		self.nextthink = time + 1;
		return;
	}
};

void() RaceOverMsg = 
{
	local entity plyr;
	if (race_finish_time > time)
	{
		self.nextthink = time + 1;
		return;
	}
	plyr = find(world, classname, "player");
	while (plyr != world)
	{
		centerprint(plyr, "Race Over!");
		plyr = find(plyr, classname, "player");
	}
	self.nextthink = time + 3;
	self.think = StartNextRace;
};

void() CheckLaps = 
{
	local entity plyr;
	local string stemp;
	local float ftemp;
	if (other.last_lap == self.ammo_nails)
	{
		if (!(global_racing_flags & QR_SOMEONE_FINISHED))
		{
			global_racing_flags = global_racing_flags | QR_SOMEONE_FINISHED;
			if (!challenge)
			{
				bprint(other.netname);
				bprint(" has WON the race!\n");
				if (other.classname == "player")
				{
					sound(other, CHAN_ITEM, "qrally/voice/win3.wav", 1, ATTN_NORM);
					centerprint(other, "You have WON the race!");
				}
			}
			else
			{
				centerprint(other, "You have passed the stage!\n");
			}
			if (!challenge)
			{
				race_finish_time = time + 20;
			}
			else
			{
				race_finish_time = time + 2;
			}
			global_racing_flags = global_racing_flags | QR_FINISHED_RACE;
			remove(positioner);
			starter.nextthink = time + 2;
			starter.think = RaceOverMsg;
		}
		num_finished = num_finished + 1;
		if (num_finished <= 3 && !challenge)
		{
			if (other.gun == world)
			{
				other.gun = SpawnPart('0 0 0', '0 0 0');
				other.gun.classname = "veh_gun";
			}
			setmodel(other.gun, "progs/qrally/trophy.mdl");
			other.gun.skin = num_finished - 1;
		}
		other.racing_flags = other.racing_flags | QR_FINISHED_RACE;
		other.race_time = time - race_start_time;
		if (other.classname == "player")
		{
			sprint(other, "Your total race time was: ");
			stemp = ftos(floor(other.race_time / 60));
			sprint(other, stemp);
			sprint(other, "m");
			ftemp = other.race_time - floor(other.race_time / 60) * 60;
			stemp = ftos(ftemp);
			sprint(other, stemp);
			sprint(other, "s\n");
		}
	}
	else
	{
		if (other.last_lap == self.ammo_nails - 1)
		{
			if (other.classname == "player")
			{
				commentary(other, "qrally/voice/finallap.wav");
				centerprint(other, "Final Lap!");
			}
		}
	}
};

void() CheckFastestLap = 
{
	local string lap_time_str;
	lap_time_str = ftos(time - other.last_lap_time);
	if (other.classname == "player")
	{
		sprint(other, "Lap time: ");
		sprint(other, lap_time_str);
		sprint(other, "\n");
		stuffcmd(other, "bf\n");
	}
	sound(other, CHAN_ITEM, "qrally/lapcom.wav", 1, ATTN_STATIC);
	if (time - other.last_lap_time < other.fastest_lap)
	{
		other.fastest_lap = time - other.last_lap_time;
		if (other.classname == "player")
		{
			centerprint(other, "Personal Fastest Lap!\n");
		}
		if (other.fastest_lap < all_fastest_lap)
		{
			all_fastest_lap = other.fastest_lap;
			commentary(other, "qrally/voice/fastest.wav");
			bprint("New Lap Record by ");
			bprint(other.netname);
			bprint(": ");
			bprint(ftos(other.fastest_lap));
			bprint("\n");
		}
	}
};

void() startfinish_touch = 
{
	local string laps_left;
	if (!(other.classname == "player" || other.classname == "rally_bot"))
	{
		return;
	}
	if (other.racing_flags & QR_NOT_RACING)
	{
		return;
	}
	if (other.racing_flags & QR_FINISHED_RACE)
	{
		return;
	}
	if (rally_type_index > 2)
	{
		return;
	}
	if (other.last_marker_num != self.ammo_shells)
	{
		return;
	}
	other.last_marker_num = 0;
	CheckFastestLap();
	other.last_lap_time = time;
	if (rally_type_index == 3)
	{
		other.frags = other.frags + FRAGS_PER_LAP;
	}
	else
	{
		other.last_lap = other.last_lap + 1;
		CheckLaps();
		if (!(global_racing_flags & QR_FINISHED_RACE))
		{
			laps_left = ftos(self.ammo_nails - other.last_lap);
			if (other.classname == "player")
			{
				sprint(other, laps_left);
				sprint(other, " laps left\n");
			}
		}
	}
	self.solid = SOLID_TRIGGER;
	setorigin(self, self.origin);
};

void() flag_think = 
{
	self.frame = self.frame + 1;
	if (self.frame > 9) {
		self.frame = 0;
		self.nextthink = -1;
		return;
	}
	self.nextthink = time + 0.1;
};

void() spawn_marker_flag = {
	local entity flag;
	local entity oself;

	if (racing_type != RT_TIME_TRIAL) return;

	flag = spawn();
	flag.classname = "rally_flag";
	flag.view_ofs = '0 0 7';
	setsize(flag, VEC_HULL_MIN, VEC_HULL_MAX);
	setmodel(flag, "progs/qrally/marker.mdl");
	makevectors(self.angles);
	setorigin(flag, self.origin + v_forward * 8);
	traceline(flag.origin, flag.origin - '0 0 64', 1, flag);
	setorigin(flag, trace_endpos);
	flag.angles_y = anglemod(self.angles_y + 180);
	flag.nextthink = time + 0.1;
	flag.think = flag_think;
	self.movetarget = flag;
};

void() rally_marker = {
	local vector min;
	local vector max;
	setorigin(self, self.origin + '0 0 12');
	setsize(self, '-2 -2 -8', '2 2 8');
	droptofloor();
	self.nextthink = time + 1;
	self.think = spawn_marker_flag;
};

void() rally_marker_brush = 
{
	self.classname = "rally_marker";
};

void() marker_touch = {
	local string stemp;
	if (!(other.classname == "player" || other.classname == "rally_bot")) return;
	if (other.racing_flags & QR_NOT_RACING || (other.racing_flags & QR_FINISHED_RACE)) return;

	if (other.last_marker_num == self.ammo_shells - 1)
	{
		other.last_marker_num = self.ammo_shells;
		other.last_marker = self;
		if (racing_type == RT_TIME_TRIAL)
		{
			if (cvar("skill") <= 1)
			{
				other.time_remaining = other.time_remaining + 7;
			}
			else
			{
				other.time_remaining = other.time_remaining + 6;
			}
			other.racing_flags = other.racing_flags - (other.racing_flags & QR_OUT_OF_TIME);
		}
		commentary(other, "qrally/voice/checkpnt.wav");
		if (racing_type == RT_TIME_TRIAL) {
			self.movetarget.frame = 0;
			self.movetarget.angles_y = other.veh_body.angles_y;
			self.movetarget.nextthink = time + 0.1;
		}
		if (rally_type_index < 3 && random() < 0.3 && self.dmg_inflictor != world && self.dmg_inflictor != other && self.last_lap == other.last_lap) {
			stemp = ftos(time - self.attack_finished);
			if (other.classname == "player") {
				sprint(other, self.dmg_inflictor.netname);
				sprint(other, " ahead: ");
				sprint(other, stemp);
				sprint(other, " secs\n");
			}
		}
		self.dmg_inflictor = other;
		self.attack_finished = time;
		self.last_lap = other.last_lap;
	} else {
		if (fabs(angle_diff(self.angles_y, other.angles_y)) > 150 && other.last_turnaround < time - SNDLEN_TURNAROUND) {
			if (other.classname == "player") centerprint(other, "Wrong Way!");
			commentary(other, "qrally/voice/wrongway.wav");
			other.last_turnaround = time;
			if (self.ammo_shells == 1) {
				other.last_marker_num = 1;
				self.dmg_inflictor = other;
				self.attack_finished = time;
				self.last_lap = other.last_lap;
			}
		}
	}
};

void() ToggleHeadlights = {
	if (self.hl_r.effects == EF_DIMLIGHT) {
		self.racing_flags = self.racing_flags - QR_HEADLIGHTS_ON;
		setmodel(self.hl_r, "");
		setmodel(self.hl_l, "");
		setmodel(self.hl_m, "");
		self.hl_r.effects = 0;
		self.hl_l.effects = 0;
		self.hl_m.effects = 0;
	} else {
		self.racing_flags = self.racing_flags | QR_HEADLIGHTS_ON;
		setmodel(self.hl_r, "");
		setmodel(self.hl_l, "");
		setmodel(self.hl_m, "");
		self.hl_r.effects = EF_DIMLIGHT;
		self.hl_l.effects = EF_DIMLIGHT;
		self.hl_m.effects = EF_DIMLIGHT;
	}
};

entity(entity player1, entity player2) player_infront = {
	local float len1;
	local float len2;

	len1 = vlen(player1.origin - player1.last_marker.origin);
	len2 = vlen(player2.origin - player2.last_marker.origin);
	if (len1 >= len2) {
		return player1;
	} else {
		return player2;
	}
};

void() SortPlayersByPosition = {
	local entity current;
	local entity temp;
	local entity lastcurrent;
	local float done;
	local float current_frag;
	local float swap;
	local string stemp;
	if (current_leader == world)
	{
		return;
	}
	current = current_leader;
	lastcurrent = world;
	swap = 0;
	while (current != world)
	{
		if (current.ahead != world && !(current.ahead.racing_flags & QR_FINISHED_RACE))
		{
			if (current.racing_flags & QR_FINISHED_RACE && !(current.ahead.racing_flags & QR_FINISHED_RACE))
			{
				swap = 1;
			}
			else
			{
				if (current.racing_flags & QR_FINISHED_RACE && (current.ahead.racing_flags & QR_FINISHED_RACE) && current.race_time < current.ahead.race_time)
				{
					swap = 1;
				}
				else
				{
					if (current.ahead.last_lap < current.last_lap || (current.ahead.last_lap == current.last_lap && current.ahead.last_marker_num < current.last_marker_num) || (current.ahead.last_lap == current.last_lap && current.ahead.last_marker_num == current.last_marker_num && player_infront(current.ahead, current) != current.ahead))
					{
						swap = 1;
					}
				}
			}
			if (swap)
			{
				temp = current.ahead;
				if (temp.ahead != world)
				{
					temp.ahead.behind = current;
				}
				if (current.behind != world)
				{
					current.behind.ahead = temp;
				}
				current.ahead = temp.ahead;
				temp.behind = current.behind;
				current.behind = temp;
				temp.ahead = current;
				if (current.ahead != world)
				{
					current = current.ahead;
				}
				else
				{
					current_leader = current;
				}
				swap = 0;
			}
			else
			{
				lastcurrent = current;
				current = current.behind;
			}
		}
		else
		{
			lastcurrent = current;
			current = current.behind;
		}
	}
	current_frag = 1;
	current = lastcurrent;
	while (current != world) {
		current.frags = current_frag;
		lastcurrent = current;
		current = current.ahead;
		current_frag = current_frag + 1;
	}
	current_frag = 1;
	current = lastcurrent;
	while (current != world) {
		if (current.position != current_frag && current.last_lap > 0 && current.classname == "player") {
			if (current_frag == 1) {
				centerprint(current, "You are in the lead!");
			} else {
				if (current_frag == 2) {
					centerprint(current, "You are in second place");
				} else {
					if (current_frag == 3)
					{
						centerprint(current, "You are in third place");
					}
					else
					{
						if (current_frag == 4)
						{
							centerprint(current, "You are in fourth place");
						}
						else
						{
							if (current_frag == 5)
							{
								centerprint(current, "You are in fifth place");
							}
							else
							{
								if (current_frag == 6)
								{
									centerprint(current, "You are in sixth place");
								}
								else
								{
									if (current_frag == 7)
									{
										centerprint(current, "You are in seventh place");
									}
									else
									{
										if (current_frag == 8)
										{
											centerprint(current, "You are in eighth place");
										}
									}
								}
							}
						}
					}
				}
			}
		}
		current.position = current_frag;
		current = current.behind;
		current_frag = current_frag + 1;
	}
	self.nextthink = time + 1;
};

void() BuildPlayerList = {
	local entity current;
	local entity prev;

	current = find(world, is_racer, "yes");
	current_leader = current;
	prev = world;
	while (current != world) {
		current.ahead = prev;
		if (prev != world) prev.behind = current;
		prev = current;
		current = find(current, is_racer, "yes");
	}
	prev.behind = world;
	if (rally_type_index < 3) {
		positioner = spawn();
		positioner.classname = "positioner";
		positioner.think = SortPlayersByPosition;
		positioner.nextthink = time + 1;
	}
};

void() PlaceRallyItem = {
	self.flags = FL_ITEM;
	droptofloor();
	setorigin(self, self.origin + '0 0 1');
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
};

void() StartRallyItem = {
	self.nextthink = time + 0.2;
	self.think = PlaceRallyItem;
};

void() boost_touch = {
	if (!(other.classname == "player" || other.classname == "rally_bot")) return;
	if (other.last_boost > time - SNDLEN_BOOST) return;

	other.velocity = other.velocity + normalize(other.velocity) * self.ammo_shells;
	if (vlen(other.velocity) > 900) other.velocity = normalize(other.velocity) * 900;
	other.last_boost = time;
};

void() rally_boost = {
	self.touch = boost_touch;
	setsize(self, '-96 -96 0', '96 96 256');
	StartRallyItem();
};

void() rally_boost_brush = {
	self.touch = boost_touch;
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
	self.classname = "rally_boost";
};

void() rally_arrow = {
	setsize(self, '0 0 0', '64 32 32');
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
};

void() bot_marker_touch = {
	if (other.classname != "rally_bot" || (other.racing_flags & QR_NOT_RACING)) return;

	if (other.goalentity == self) other.goalentity = FindGoalMarker(other);
	self.solid = SOLID_TRIGGER;
	setorigin(self, self.origin);
};

void() rally_bot_marker = {
	local vector min;
	local vector max;
	setsize(self, '0 0 0', '0 0 0');
	num_markers = num_markers + 1;
	StartRallyItem();
};

void() rally_bot_marker_brush = {
	self.touch = bot_marker_touch;
	num_markers = num_markers + 1;
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
	self.classname = "rally_bot_marker";
};

void() jump_touch = {
	if (other.classname != "player" && other.classname != "rally_bot") return;

	other.last_jump_touch = time;
	self.solid = SOLID_TRIGGER;
	setorigin(self, self.origin);
};

void() rally_jump = {
	self.touch = jump_touch;
	setsize(self, '-32 -32 0', '32 32 16');
	StartRallyItem();
};

void() rally_jump_brush = {
	self.touch = jump_touch;
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
	self.classname = "rally_jump";
};

void() cone_think = {
	local entity new_cone;
	self.solid = SOLID_TRIGGER;
	self.flags = FL_ITEM;
	setorigin(self, self.origin);
};

void() cone_touch = {
	local vector pos;

	if (!(other.classname == "player" || other.classname == "rally_bot")) return;
	if (other.velocity == '0 0 0') return;

	pos = other.origin - other.veh_dir * 48;
	if (vlen(self.origin - pos) > 64) return;

	sound(self, CHAN_AUTO, "qrally/process/htcone01.wav", 1, ATTN_STATIC);
	self.velocity = other.velocity * 1.5;
	self.velocity_z = 200;
	self.avelocity_x = random() * 500;
	self.avelocity_y = random() * 500;
	self.avelocity_z = random() * 500;
	self.movetype = MOVETYPE_BOUNCE;
	self.solid = SOLID_NOT;
	self.flags = 0;
	self.think = cone_think;
	self.nextthink = time + 2;
};

void() rally_cone = {
	self.touch = cone_touch;
	setsize(self, '0 0 0', '0 0 8');
	self.velocity = '0 0 0';
	setmodel(self, "progs/qrally/cone.mdl");
	if (!droptofloor()) {
		dprint("cone fell out of level at ");
		dprint(vtos(self.origin));
		dprint("\n");
	} else {
		setorigin(self, self.origin - '0 0 8');
	}
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_TRIGGER;
	self.flags = FL_ITEM;
};

void() rally_baracade = {
	self.touch = cone_touch;
	setsize(self, '-16 -16 0', '16 16 8');
	self.velocity = '0 0 0';
	setmodel(self, "progs/qrally/baracade.mdl");
	if (!droptofloor()) {
		dprint("baracade fell out of level at ");
		dprint(vtos(self.origin));
		dprint("\n");
	} else {
		setorigin(self, self.origin - '0 0 8');
	}
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_TRIGGER;
	self.flags = FL_ITEM;
};

void() changesurface_touch = {
	if (other.is_racer != "yes") return;

	other.current_surface = self.current_surface;
};

void() rally_changesurface = {
	local vector min;
	local vector max;

	if (self.speed == 0) self.speed = 128;
	min = '-1 -1 0' * self.speed;
	min_z = -24;
	max = '1 1 0' * self.speed;
	max_z = 16;
	setsize(self, min, max);
	self.touch = changesurface_touch;
	StartRallyItem();
};

void() rally_changesurface_brush = {
	self.touch = changesurface_touch;
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.movetype = MOVETYPE_NONE;
	self.modelindex = 0;
	self.model = "";
	self.classname = "rally_changesurface";
};

void() bounce_object = {
	local vector pos;

	pos = other.origin - other.veh_dir * 48;
	if (vlen(self.origin - pos) > 64) return;

	self.velocity = other.velocity * 1.5;
	self.velocity_z = 250 * (random() * 0.5 + 0.5);
	self.avelocity_x = random() * 500;
	self.avelocity_y = random() * 500;
	self.avelocity_z = random() * 500;
	self.movetype = MOVETYPE_BOUNCE;
	self.solid = SOLID_NOT;
	self.flags = 0;
	self.think = cone_think;
	self.nextthink = time + 2;
};

void() stopsign_touch = {
	local entity part;
	local entity oldself;

	if (!(other.classname == "player" || other.classname == "rally_bot")) return;
	if (other.velocity == '0 0 0') return;

	if (vlen(other.velocity) < MAX_SPEED / 2) {
		self.angles = vectoangles(-1 * other.velocity);
		self.angles_x = 90;
		self.solid = SOLID_NOT;
		return;
	}
	sound(self, CHAN_AUTO, "qrally/process/htcone01.wav", 1, ATTN_STATIC);
	oldself = self;
	setorigin(self, oldself.origin + '0 0 32');
	setmodel(self, "progs/qrally/stoptop.mdl");
	self.touch = cone_touch;
	bounce_object();
	part = spawn();
	part.classname = "rally_stoppost";
	part.angles = oldself.angles;
	setsize(part, '0 0 0', '0 0 8');
	setorigin(part, self.origin);
	setmodel(part, "progs/qrally/stoppost.mdl");
	part.angles = self.angles + '90 0 0';
};

void() rally_stopsign = {
	self.touch = stopsign_touch;
	setsize(self, '0 0 0', '0 0 8');
	self.velocity = '0 0 0';
	setmodel(self, "progs/qrally/stopsign.mdl");
	if (!droptofloor()) {
		dprint("Stopsign fell out of level at ");
		dprint(vtos(self.origin));
		dprint("\n");
	} else {
		setorigin(self, self.origin - '0 0 8');
	}
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_TRIGGER;
	self.flags = FL_ITEM;
};

void() rally_starter = {
	precache_model("progs/qrally/starter.mdl");
	setsize(self, '0 0 0', '0 0 0');
	self.velocity = '0 0 0';
	setmodel(self, "progs/qrally/starter.mdl");
	self.skin = 3;
	self.movetype = MOVETYPE_NONE;
	self.solid = SOLID_NOT;
};

void() WaterScreenThink = {
	local string str;

	self.speed = self.speed - 50;
	if (self.speed < 0) {
		stuffcmd(self.owner, "v_cshift 0 0 0 0\n");
		remove(self);
		return;
	}
	str = ftos(self.speed);
	stuffcmd(self.owner, "v_cshift 0 0 64 ");
	stuffcmd(self.owner, str);
	stuffcmd(self.owner, "\n");
	self.nextthink = time + 1;
};
*/