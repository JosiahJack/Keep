float (entity o) IsProjectile = {
	return (o.classgroup == CG_PROJALL || o.classgroup == CG_PROJSHELLS
		 || o.classgroup == CG_PROJNAILS  || o.classgroup == CG_PROJLAVANAILS
		 || o.classgroup == CG_PROJROCKETS  || o.classgroup == CG_PROJGRENADES
		 || o.classgroup == CG_PROJCELLS  || o.classgroup == CG_PROJHAZARD
		 || o.classgroup == CG_MINIONEGG || o.classgroup == CG_PROJMULTIROCKETS
		 || o.classgroup == CG_PROJBOLTSPOISON || o.classgroup == CG_PROJBOLTS
		 || o.classgroup == CG_PROJBLOODCRYSTALS || o.classgroup == CG_PROJVOID
		 || o.classgroup == CG_PROJMAGIC || o.classgroup == CG_PROJICE);
};

float(entity o) AffectedByPhysics = {
	if (IsProjectile(o)) return TRUE;
	if (o.classtype == CT_FUNCBREAKOBJ) return TRUE;
	if (o.classtype == CT_TEMPGIB) return TRUE;
	if (o.classtype == CT_TEMPPHYS) return TRUE;
	if (o.classtype == CT_BUBBLE) return TRUE;
	if (o.classtype == CT_MISCDRIP) return TRUE;
	if (o.classtype == CT_TEMPSPARK) return TRUE;
	if (o.classtype == CT_PROJ_MEGG) return TRUE;
	return FALSE;
};

void (entity srcent, entity destent) SUB_CopyEntity = {
	copyentity(srcent,destent);
};

/*======================================================================
 From Quoth for calculating gib velocity for polyp
======================================================================*/
vector (float dm) VelocityForDamage = {
	local vector v;

	v_x = 100 * crandom();
	v_y = 100 * crandom();
	v_z = 200 + 100 * random();
	if (dm > -50) {
		v = v * 0.7;
	} else {
		if (dm > -200) {
			v = v * 2;
		} else {
			v = v * 10;
		}
	}
	return v;
};

float(vector spot) InAir = { return (pointcontents(spot) == CONTENT_EMPTY); };
float(vector spot) InSolid = { return (pointcontents(spot) == CONTENT_SOLID); };
float(vector spot) InWater = { return (pointcontents(spot) == CONTENT_WATER); };
float(vector spot) InSlime = { return (pointcontents(spot) == CONTENT_SLIME); };
float(vector spot) InLava = { return (pointcontents(spot) == CONTENT_LAVA); };
float(vector spot) InSky = { return check_skycontent(spot); };
float(vector spot) InLiquid = {
	local float conts;

	conts = pointcontents(spot);
	return ((conts <= CONTENT_WATER) && (conts != CONTENT_SKY));
};

float(entity ent, vector p2, float dist, float nomonsters) pointvisible = {
    local vector p1;

    p1 = ent.origin;
    if (vlen (p2 - p1) > dist) return FALSE; // Exceeded maximum distance.
    traceline (p1, p2, nomonsters, self);
    if (trace_fraction < 1) return FALSE;    // Not in line-of-sight.
    return TRUE;
};