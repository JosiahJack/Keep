float CM_TRIGGER_NON_PLAYER = 1;
float CM_SOLID_NOT = 2;
float CM_NO_ENTER_SOUND = 4;
float CM_NO_EXIT_SOUND = 8;
/*
 * $Header: /H2 Mission Pack/HCode/camera.hc 24    3/27/98 2:14p Mgummelt $
 */
void(entity voyeur, entity viewthing) CameraViewPort =
{//FIXME: Doesn't seem to work if it's out of vis- only 
//	remembers last spot it was at last time it WAS in vis
	msg_entity = voyeur;                        
	WriteByte (MSG_ONE, SVC_SETVIEWPORT);   
	WriteEntity (MSG_ONE, viewthing);
	WriteByte (MSG_ONE, 10);				// 10 = SVC_SETVIEWANGLES
	WriteAngle (MSG_ONE,-self.cameramode.angles_x);		// pitch
	WriteAngle (MSG_ONE,self.cameramode.angles_y);		// yaw
	WriteAngle (MSG_ONE,self.cameramode.angles_z);		// roll
};

void(entity voyeur, entity viewthing) CameraViewAngles =
{//FIXME: Doesn't seem to work if it's out of vis- only 
//	remembers last angles it was at last time it WAS in vis
	msg_entity = voyeur;                        
	WriteByte (MSG_ONE, SVC_SETVIEWANGLES); 
	if(viewthing.classname=="camera_remote")
		WriteAngle(MSG_ONE, /*180+*/-viewthing.angles_x);
	else
		WriteAngle(MSG_ONE, -viewthing.angles_x);
	WriteAngle(MSG_ONE, viewthing.angles_y);
	WriteAngle(MSG_ONE, viewthing.angles_z);
};

/*-----------------------------------------
	play_camera - play noise for when popping in or out of camera mode
  -----------------------------------------*/
void() play_camera =
{
	sound (self, CHAN_VOICE, "misc/camera.wav", 1, ATTN_NORM);
	remove (self);
};

/*-----------------------------------------
	camera_track - camera tracks its target
  -----------------------------------------*/
void camera_track ()
{
	vector new_angles;

	if(self.trigger_field.camera_time<=time - 0.05||self.trigger_field.cameramode!=self)
		return;

	//self.wallspot=self.enemy.origin; Inky 20210203 Suspecting that wallspot thing to be yagni stuff
	new_angles=vectoangles(self.enemy.origin - self.origin);
	if(self.angles!=new_angles)
	{
		self.angles = new_angles;
		msg_entity = self.trigger_field;                        
		WriteByte (MSG_ONE, SVC_SETVIEWANGLES);//change to interpolation 
		if(self.classname=="camera_remote")
			WriteAngle(MSG_ONE, /*180+*/-self.angles_x);
		else
			WriteAngle(MSG_ONE, -self.angles_x);
		WriteAngle(MSG_ONE, self.angles_y);
		WriteAngle(MSG_ONE, 0);
	}

	self.think = camera_track;
	self.nextthink = time;
}

/*-----------------------------------------
	CameraUse - place player in camera remote
  -----------------------------------------*/
void CameraUse (void)
{
	entity snd_ent;
	other = other.enemy;	// Use the enemy of the trigger or button

	if (other.classname != "player")
	{
		if(self.spawnflags & CM_TRIGGER_NON_PLAYER)
		{
			//Cam can be triggered by a non player
			other = find(world,classname,"player");
		}
		else
		{
			//Cam must be triggered by the player
			return;
		}
	}

//put back in

	other.cameramode = self;
	other.camera_time = time + self.wait;
	other.attack_finished = other.camera_time;

	//Inky 20201128 If self.nexttarget is set the player's facing angle is set towards that target upon return + the player is set invisible during the cutscene
	/*
	20210203 Commented out for yagni reasons
	if(self.nexttarget != "")
	{
		//other.effects (+) EF_NODRAW; Inky 20210203 Seems not to be supported by Quake
		snd_ent = find (world,targetname,self.nexttarget);
		other.oldangles = vectoangles(snd_ent.origin - other.origin);
		other.oldangles_x = 0 - other.oldangles_x;
	}
	else
	*/
	//Inky 20201110 If self.mangle is set the player's facing angle is set to its value upon return + the player is set invisible during the cutscene --> 20210203: commenting it out of laziness because probably yagni
	//if(self.mangle != '0 0 0')
	//{
	//	//other.effects (+) EF_NODRAW; Inky 20210203 Seems not to be supported by Quake
	//	other.oldangles = self.mangle;
	//}
	////Standard behavior: the player will retrieve their initial facing angle upon return
	//else
	//{
		other.finalangle = other.angles;
	//}
	
	//Inky 20210203 Instead of Hexen II's EF_NODRAW thing, let's go with model & movetype
	other.invisible_finished = other.invisible_sound = time + 99999;
	other.movetype = MOVETYPE_NONE;
	
	//Inky 20201211
	if(self.oldorigin) setorigin(other,self.oldorigin);

	if (other.weaponmodel!= string_null)
	{
		other.mdl = other.weaponmodel;
		other.weaponmodel = string_null;
	}
	
	//Inky 20201127 To prevent the player from being hurt if something spawns too close to the camera during the cutscene
	other.takedamage = DAMAGE_NO;
	if(self.spawnflags & CM_SOLID_NOT) other.solid = SOLID_NOT; //Inky 20201226 To prevent camera collision with close stuff
	if(self.armorvalue)
	{
		//self.armortype = cvar("fov");
		cvar_set("fov", ftos(self.armorvalue));
	}
	//self.ammo_nails = cvar("crosshair");
	cvar_set("crosshair", "0");

	msg_entity = other;                        
	
	if(self.enemy != world) self.angles = vectoangles(self.enemy.origin - self.origin); //else self.wallspot='0 0 0'; //Inky 20201215 Tweaking for proper handling of targetless cameras only set up by angles
	CameraViewPort(other,self);
	WriteByte (MSG_ONE, SVC_SETVIEWANGLES);
	WriteAngle (MSG_ONE,/*180+*/-self.angles_x);		// pitch
	WriteAngle (MSG_ONE,self.angles_y);		// yaw
	WriteAngle (MSG_ONE,self.angles_z);		// roll
	self.trigger_field = other;
	
	if(!self.spawnflags & CM_NO_ENTER_SOUND)
	{
		snd_ent = spawn ();
		snd_ent.origin = self.origin;
		snd_ent.nextthink = time + 0.05;
		snd_ent.think = play_camera;
	}
	
	self.nextthink = time;
	self.think=camera_track;

}

/*-----------------------------------------
	CameraReturn - return the player to his body
  -----------------------------------------*/
void CameraReturn(void)
{
	entity snd_ent;
	string otarget;

	//if(self.cameramode.armorvalue) cvar_set("fov", ftos(self.cameramode.armortype)); //Inky 20201227 Restoring the initial fov if needed
	//cvar_set("crosshair", ftos(self.cameramode.ammo_nails));

	//Inky 20201210 Fire targets before returning to normal view, notably in order to clean any inopportune remaining cutscene element (like a NPC)
	/*
	Lazily commented out because of probably being yagni stuff
	if(self.cameramode.close_target)
	{
		otarget = self.cameramode.target;
		self.cameramode.target = self.cameramode.close_target;
		snd_ent=self;
		self=self.cameramode;
		SUB_UseTargets();
		self=snd_ent;
		self.cameramode.target = otarget;
	}
	*/
	
	self.cameramode = world;
	
	self.attack_finished = self.camera_time = 0;
	self.weaponmodel = self.mdl;
	self.view_ofs = '0 0 22';
	
	//self.effects (-) EF_NODRAW;   //Inky 20201110 In case the player had been made invisible during the cutscene thanks to camera.mangle 20210203 Seems not to be supported by Quake
	self.takedamage = DAMAGE_YES; //Inky 20201127 No more camera invulnerability
	self.solid = SOLID_SLIDEBOX;  //Inky 20201226 No more untouchable
	
	//Inky 20210203 Instead of Hexen II's EF_NODRAW thing, let's go with just movetype
	self.movetype = MOVETYPE_WALK;
	
	self.angles = self.finalangle;
	//self.idealroll = 0; Inky 20210203 Probably yagni stuff --> commented out

	CameraViewPort(self,self);
	CameraViewAngles(self,self);
	
	if(!self.spawnflags & CM_NO_EXIT_SOUND)
	{
		snd_ent = spawn ();
		snd_ent.origin = self.origin;
		snd_ent.nextthink = time + 0.05;
		snd_ent.think = play_camera;
	}
}

void camera_target();
void camera_find_tracks ()
{/*Inky 20210203 Not sure .movechain is supported by Quake and don't feel like spending too much time on that if I eventually don't use it

string temp_str;
	temp_str=self.netname;
	self.netname="";
	self.lockentity=find(world,netname,temp_str);
	self.netname=temp_str;

	if(self.lockentity)
	{
		if(self.lockentity.classname=="player")
		{
			self.target=self.lockentity.targetname=self.lockentity.netname;
			self.lockentity=world;
			camera_target();
		}
		else
		{
			setorigin(self,self.lockentity.origin);
			self.lockentity.movechain=self;
		}
	}
	else
	{
		self.think=camera_find_tracks;
		thinktime self : 1;
	}*/
}

/*-----------------------------------------
	camera_target- point the camera at it's target
  -----------------------------------------*/
void camera_target (void)
{
	self.enemy = find (world,targetname,self.target);
	//self.wallspot=self.enemy.origin; Inky 20210203 Suspecting that wallspot thing to be yagni stuff
	self.angles = vectoangles(self.enemy.origin - self.origin);
	if(self.netname)
	{
		self.think=camera_find_tracks;
		self.nextthink = time + 0.5;
	}
}

/*QUAKED camera_remote (1 0 0) (-8 -8 -8) (8 8 8)
A camera which the player becomes when triggered. 
-------------------------FIELDS-------------------------
"wait" - amount of time player is stuck in camera mode
   (default 3 seconds)

"netname" - will find an entity that has the same netname and attach itself to it's movement
if netname is a player's name, the camera will always point at that player.

To point camera in a direction

target a "target_null" entity


or fill out the angle fields:
angles_x - pitch of camera
angles_y - yaw of camera


--------------------------------------------------------
*/
void camera_remote (void)
{
	if(deathmatch)
	{
		remove(self);
		return;
	}

	precache_sound ("misc/camera.wav");
	
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_NOCLIP;

	//setmodel(self,"progs/null.spr"); Inky 20210203 Yagni?

	self.use = CameraUse;

	if (!self.wait)
		self.wait = 3;

	if (self.target)	
	{
		self.think = camera_target;
		self.nextthink = time + 0.5; // Give target a chance to spawn into the world
	}
	else if(self.netname)
	{
		self.think=camera_find_tracks;
		self.nextthink = time + 0.5;
	}


	setsize(self, '-1 -1 0', '1 1 1');
}

void CameraThink ()
{
vector viewdir;
vector spot1,spot2;
float level;
	level=cvar("chase_back");
	if(self.cnt<level)
		self.cnt+=1;
	else if(self.cnt>level)
		self.cnt-=1;

	makevectors(self.owner.v_angle);
	viewdir=normalize(v_forward);
	spot1=self.owner.origin+self.owner.view_ofs;
	spot2=spot1-viewdir*self.cnt;
	traceline(spot1,spot2,TRUE,self.owner);

	viewdir=normalize(spot1-trace_endpos);
	setorigin(self,trace_endpos+viewdir*4);

	self.think=CameraThink;
	self.nextthink = time;
}


