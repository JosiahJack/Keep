.float frame1;
.vector origin2;
.vector origin1;
.float angle1;
.float angle2;

void() Lerp_ResetSelf =
{
	self.frame2time = self.frame1time;
	self.frame1time = self.nextthink;
	self.frame2 = self.frame1;
	self.frame1 = self.frame;
	self.origin2 = self.origin1;
	self.origin1 = self.origin;
	self.angle2 = self.angle1;
	self.angle1 = self.angles_y;
};

void() Lerp_ResetAll =
{
	self = world;
	while ((self = nextent(self)))
	{
		self.frame2time = self.frame1time;
		self.frame1time = self.nextthink;
		self.frame2 = self.frame1;
		self.frame1 = self.frame;
		self.origin2 = self.origin1;
		self.origin1 = self.origin;
		self.angle2 = self.angle1;
		self.angle1 = self.angles_y;
	}
};

void(float vwidth, float vheight, float notmenu) CSQC_UpdateView =
{
	if (theplayer)
	{
		if (theplayer.fixangle)
		{
			//yeah... no -1
			theplayer.fixangle = FALSE;
			setviewprop(VF_CL_VIEWANGLES, theplayer.angles);
			theplayer.v_angle = theplayer.angles;
		}
		if (autocvar_purecsqc_noreset && dochangelevel != "")
			loadlevel(dochangelevel);
		
		if (intermission_running)	//vanilla qc sucks. too lazy to change it elsewhere.
			setmodel(theviewmodel, "");
		else if (theviewmodel.model != theplayer.weaponmodel)
			setmodel(theviewmodel, theplayer.weaponmodel);
		theviewmodel.frame = theplayer.weaponframe;
		theviewmodel.origin = theplayer.origin + theplayer.view_ofs;
		theviewmodel.angles = theplayer.v_angle;
		theviewmodel.angles_x *= -1;
		theviewmodel.nextthink = theplayer.nextthink;
		theviewmodel.origin1 = theviewmodel.origin;
		theviewmodel.origin2 = theviewmodel.origin;
		theviewmodel.angle1 = theviewmodel.angles_y;
		theviewmodel.angle2 = theviewmodel.angles_y;
		clearscene();
		setviewprop(VF_DRAWWORLD, TRUE);
		setviewprop(VF_DRAWCROSSHAIR, TRUE);
		setviewprop(VF_ORIGIN, theplayer.origin + theplayer.view_ofs);
		vector ang = theplayer.v_angle;
		if (intermission_running)
		{	//wobblycam
			ang_x += sin(time*1.0)*0.3;
			ang_y += sin(time*2.0)*0.3;
			ang_z += sin(time*0.5)*0.1;
		}
		else
		{	//regular cam that gets knocked about by gunshot.
			ang_x += theplayer.punchangle_x;
			theplayer.punchangle_x += frametime*10;
			if (theplayer.punchangle_x > 0)
				theplayer.punchangle_x = 0;
		}
		setviewprop(VF_ANGLES, ang);

		theplayer.origin1 = theplayer.origin2 = theplayer.origin;
		theplayer.angle1 = theplayer.angle2 = theplayer.angles_y;

		self = world;
		while ((self = nextent(self)))
		{
			if (self.model)
			{
				if (self.effects & EF_MUZZLEFLASH)
				{
					self.effects &= ~EF_MUZZLEFLASH;
					makevectors([0, self.angles_y, 0]);
					pointparticles(particleeffectnum("te_muzzleflash"), self.origin, v_forward, 1);
				}
				if (self.movetype == MOVETYPE_STEP)
				{	//interpolate origins and angles so that they're synced to the thinks.
					//interpolation = latency.
					if (self.nextthink != self.frame1time)
					{
						self.frame2time = self.frame1time;
						self.frame1time = self.nextthink;
						self.frame2 = self.frame1;
						self.frame1 = self.frame;
						self.origin2 = self.origin1;
						self.origin1 = self.origin;
						self.angle2 = self.angle1;
						self.angle1 = self.angles_y;
					}
					self.lerpfrac = (time - self.frame2time) /(self.frame1time-self.frame2time);
					self.lerpfrac = 1-bound(0, self.lerpfrac, 1);

					float savedang = self.angles_y;
					float dir = (self.angle2-self.angle1);
					if (dir > 180)
						dir -= 360;
					else if (dir < -180)
						dir += 360;
					self.angles_y = self.angle1 + dir*self.lerpfrac;
					if (self.flags & (FL_ONGROUND|FL_PARTIALGROUND|FL_FLY|FL_SWIM))
					{
						//while its onground, it should move at the same animation speed as it animates
						vector saved = self.origin;						
						self.origin = self.origin1 + (self.origin2-self.origin1)*self.lerpfrac;
						if (self.flags & (FL_ONGROUND|FL_PARTIALGROUND))
							self.origin_z = saved_z;	//try and avoid monsters on plats juddering separately from the plat_center_touch. could probably do something better based on dotproducts with the direction of motion or something. not sure.
						addentity(self);
						self.origin = saved;
					}
					else
					{
						//but if its in free-fall, don't lag it.
						//no nasty surprises when it does hit the ground please.
						self.origin2 = self.origin1 = self.origin;
						addentity(self);
					}
				}
				else
				{	//general flying entity.
					//rockets, doors, etc.
					//no origin/angle lerps, but we do need to cope with trails properly.
					if (self.nextthink != self.frame1time)
					{
						self.frame2time = self.frame1time;
						self.frame1time = self.nextthink;
						self.frame2 = self.frame1;
						self.frame1 = self.frame;
					}
					self.lerpfrac = (time - self.frame2time) /(self.frame1time-self.frame2time);
					self.lerpfrac = 1-bound(0, self.lerpfrac, 1);

					//deal with trails
					float mf = self.modelflags;
					if ((mf||self.traileffectnum) && self.origin2 != self.origin)
					{
						float ef = self.traileffectnum;			
						if (mf & MF_ROCKET)
							ef = particleeffectnum("tr_rocket");
						else if (mf & MF_GRENADE)
							ef = particleeffectnum("tr_grenade");
						else if (mf & MF_GIB)
							ef = particleeffectnum("tr_blood");
						else if (mf & MF_TRACER)
							ef = particleeffectnum("tr_wizspike");
						else if (mf & MF_ZOMGIB)
							ef = particleeffectnum("tr_slightblood");
						else if (mf & MF_TRACER2)
							ef = particleeffectnum("tr_knightspike");
						else if (mf & MF_TRACER3)
							ef = particleeffectnum("tr_vorespike");
						if (ef && self.frame1 == -500)
							trailparticles(ef, self, self.origin2, self.origin);
						self.frame1 = -500;
						self.origin2 = self.origin;
					}
					//and add it.
					if (mf & MF_ROTATE)
					{
						float oy = self.angles_y;
						self.angles_y = time*90;
						addentity(self);
						self.angles_y = oy;
					}
					else
						addentity(self);
				}

				//fixme: explicit EF_BLUE, others.
				if (self.effects & EF_DIMLIGHT)
				{
					vector col = '0.5 0.5 0.2';	//vaugely match glquake's muzzleflash colours.
					if (self.items & (IT_QUAD|IT_INVULNERABILITY))
					{	//recolour it if the player is holding quad.
						col = '0 0 0';
						if (self.items & IT_QUAD)
							col_z = 1;
						if (self.items & IT_INVULNERABILITY)
							col_x = 1;
					}
					if (self == theplayer)
						makevectors(self.v_angle);
					else
						makevectors([-self.angles_x, self.angles_y, self.angles_z]);
					dynamiclight_add(self.origin, 200, col, 0, "", 0);
				}
			}
		}
		addentities(1);	//purely for lightning beams
		renderscene();

		if (notmenu)
		{
			if (intermission_running == 1)
				Hud_DrawIntermission([vwidth, vheight]);
			else if (!intermission_running)
			{
				self = theplayer;
				Hud_Draw(FALSE, vwidth, vheight);
			}
		}
	}
	else
	{
		if (serverkey("constate") == "connecting")
		{
			//should be stuck on the loading screen
			drawfill([0, 0], [vwidth, vheight], [1,1,1], 1, 0);
		}
		else
		{
			//no local player generally means we're being misused.
			clearscene();
			setviewprop(VF_DRAWWORLD, TRUE);
			setviewprop(VF_DRAWCROSSHAIR, TRUE);
			setviewprop(VF_DRAWENGINESBAR, TRUE);
			addentities(3);
			renderscene();
		}
	}

	if (notmenu)
		Menu_Draw();
};
 