//=============================================================================
//       ___  ___  __            __   __  
// |__/ |__  |__  |__)     |\/| /  \ |  \
// |  \ |___ |___ |        |  | \__/ |__/                                                    
//
// Compiled by Qmaster
//
// Attributions: FrikaC, Kashua & LordHavoc & Preach
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
// Entity count: 0
// Function count: 52
//
// Implements: Math functions, specifically trigonometry calculations
//
// Description:
// Adds in math functions that weren't originally available as builtins by the
// engine.  Some of these are simpler and faster than newer engines' builtins.
//=============================================================================

// for speed...
float pi = 3.14159265; // Pie, endless pie! (well okay not so endless, only 8 slices to share)
float OneEightyOverPi = 57.295779; // Convert to degrees, multiply by this
float PiOverOneEighty =  0.017453; // Convert to radians, multiply by this 
float SQRT2           =  1.414214; // The square root of 2.
float COS30           =  0.866025; // Handy performance helpers
float COS45           =  0.707107; // to save time
float COS60           =  0.500000; // and money!
float() crandom = { return 2*(random() - 0.5); }; // Random between -1.0 and 1.0
void(entity ent, string text) Safe_stuffcmd;
float(float val, float min, float max) SUB_ClampFloat;

// You can set the accuracy of mathlib by changing this value.
// If unset, it defaults to 0.001
float mathlib_accuracy; //accuracy of sqrt & pow

// Definition/list of all math functions
float(float num) mathlib_sqrt;
float(float num) mathlib_sin; // Bless me father for I have trigonometry homework
float(float num) mathlib_cos;
float(float a, float b) mathlib_fast_pow;
float (float number, float exp) mathlib_bitshift;
float(float a, float b) mod;
float(float v) anglemod;
float (float y1, float y2) angcomp;
float (float a, float b) mathlib_min;
float (float a, float b) mathlib_max;
float(float minimum, float val, float maximum) mathlib_bound;
vector() mathlib_randomvec;
float (float num) rad2deg;
float (float num) deg2rad;
float(float theta) mathlib_tan;
float(float y, float x) mathlib_atan2;

// Will return 0/1 if bitflag is present in bitvalue
float(float bitvalue, float bitflag) mathlib_bitvalue = { return floor( (bitvalue & bitflag) / bitflag); };

float(float num) mathlib_sqrt = {
	local float apr;

	if(mathlib_accuracy <= 0) mathlib_accuracy = 0.001; //this sets a level of accuracy, it's a global float

	if (num < mathlib_accuracy) return 0;
	if (num>1) apr = num;
	else apr = 1;
	do {
		apr = (num + (apr * apr)) / (2 * apr);
	}
	while (fabs((apr * apr) - num) > (num * mathlib_accuracy));
	return apr;
};

// Sine
float(float num) mathlib_sin = {
	local vector ang,vf,vu,vr;

	vf = v_forward; // Save V_ variable states
	vu = v_up;
	vr = v_right;
	ang = '0 1 0' * num;
	makevectors(ang); // Use makevectors to get sin
	num = v_forward_y;
	v_forward = vf; // Restore V_ variables
	v_up = vu;
	v_right = vr;
	return num; // Return SIN
};

// Cosine
float(float num) mathlib_cos = {
	local vector ang,vf,vu,vr;
	
	vf = v_forward;
	vu = v_up;
	vr = v_right;
	ang = '0 1 0' * num;
	makevectors(ang);
	num = v_forward_x;
	v_forward = vf;
	v_up = vu;
	v_right = vr;
	return num;
};

// Raise to a power.  You ought not use this if the power you're raising to is constant, ie, just use r * r * r for cubing, it's a lot faster
float(float a, float b) mathlib_fast_pow = {
	local float fb, n, bit, factor;
	
	fb = fabs(b);
	bit = 1;
	n = 1;
	factor = a;
	while (bit <= fb)
	{
		if (fb&bit)
			n = n * factor;
		factor = factor * factor;
		bit = bit * 2;
	}
	if (b < 0)
		return 1/n;
	else
		return n;
};

float(float a, float b) mathlib_pow = {
	local float e1,e2,f,i;
	
	if (mathlib_accuracy <= 0) mathlib_accuracy = 0.001; 
	if (fabs(rint(b) - b) <= mathlib_accuracy) return mathlib_fast_pow(a, rint(b));
		
	f = (a - 1) / (a + 1);
	// This is the first trick we're essentially doing exp(b*log(a)), but the power series for log (1+x) is only defined for small x however log x = 2 * arctanh((x-1)/(x+1)) which will converge for any x we choose
	e1 = 0;	            
	e2 = 2 * f;
	i = 1;
	f = f * f;
	// This calculates successive terms of arctanh.  When the absolute value of a term drops below accuracy we call it a day.
	// Note that this doesn't actually mean the output is accurate to 0.001, there's no direct bound on accuracy
	while(fabs(e2) > mathlib_accuracy) {
		e1 = e1 + e2;
		e2 = e2 * f * ((2 * i) - 1) / ((2 * i) + 1);
		i = i + 1;
	}

	f = e2 = e1 * b;
	e1 = 1;
	i = 1;
	// Same idea, this is the exponential function which has a nice power series.  Same comments about accuracy apply, except 
	// the rapid decay of terms mean it's probably close to the true value of exp f, if not pow(a,b)
	while(fabs(e2) > mathlib_accuracy) {
		e1 = e1 + e2;
		i = i + 1;
		e2 = e2 * f / i;
	}
	return e1;
} ;

// Bitshift
float (float number, float exp) mathlib_bitshift = {
	local float bit, fexp;

	bit = 1;
	fexp = fabs(exp);
	number = rint(number);
	while (bit <= fexp) {
		if (fexp & bit) {
			if (exp > 0) number = number * bit * 2;
			else number = floor(number / (bit * 2));
		}
		bit = bit * 2;
	}
	return number;
};

// Returns power of 10
float(float pow_loop, float pow_bit) mathlib_powbit = {
	local float pow_num, pow_counter;
	// Allow for starting range to be different
	pow_num = pow_bit;
	pow_counter = 1;
	if (pow_loop < 1) pow_loop = 1;
			
	while (pow_counter < pow_loop) {
		pow_num = pow_num * pow_bit;
		pow_counter = pow_counter + 1;
	}
	return pow_num;
}; 

// Return exact division
float(float divnum, float divider) mathlib_divisible = {
	local float retval;
	retval = 0;
	// Check for leading zero (always return zero)
	if (divider > divnum) return retval;
	
	while (divnum >= divider) { // Got a number that can be divided
		divnum = divnum - divider;
		retval = retval + 1;
	}
	return retval;
};

// Return truncated number
float(float trnum, float topbit, float botbit) mathlib_truncate = {
	local float tr_pow, tr_counter, tr_result;
	
	// Calc Maximum POW above number to truncate
	tr_counter = 0;
	tr_pow = mathlib_powbit(topbit,10);
	while (tr_pow < trnum) {
		tr_counter = tr_counter + 1;
		tr_pow = tr_pow * 10;
	}

	while (tr_counter > 0) { // Count down the digits to remove
		// Move down one pow digit
		tr_pow = tr_pow / 10;
		// Divide number by pow to get divider
		tr_result = mathlib_divisible(trnum, tr_pow);
		trnum = trnum - (tr_result * tr_pow);
		tr_counter = tr_counter - 1;
	}
	tr_pow = mathlib_powbit(botbit,10); // Fix the rounding errors by shifting the number up/down
	trnum = rint(trnum*tr_pow);
	trnum = trnum / tr_pow;
	return trnum; // Final result
};

// Remainder.  Similar to C's % operator, but deals with negative numbers differently.
float(float a, float b) mod = { return a - (floor(a / b) * b); };

// Faster version of id's anglemod
float(float v) anglemod = { return v - floor(v/360) * 360; };

// Vector version of anglemod
vector(vector targang) vectormod = {
	local vector finang;
	finang_x = anglemod(targang_x);
	finang_y = anglemod(targang_y);
	finang_z = anglemod(targang_z);
	return finang;
}

// Subtracts one angle from another (part of FrikBot)
float (float y1, float y2) angcomp = {
	y1 = anglemod(y1);
	y2 = anglemod(y2);

	local float answer;
	answer = y1 - y2;
	if (answer > 180)
		answer = answer - 360;
	else if (answer < -180)
		answer = answer + 360;
	return answer;
};

// Returns the lesser of two (or more) numbers
float (float a, float b) mathlib_min = {
	if (a<b)return a;
	else	return b;
};

float (float a, float b, float c) mathlib_min3 = {
	if (a<b) {
		if (c<a)	return c;
		else		return a;
	} else {
		if (c<b)	return c;
		else		return b;
	}
};
float (float a, float b, float c, float d) mathlib_min4 = { return mathlib_min(mathlib_min3(a,b,c),d); };
float (float a, float b, float c, float d, float e) mathlib_min5 = { return mathlib_min3(mathlib_min3(a,b,c),d,e); };
float (float a, float b, float c, float d, float e, float f) mathlib_min6 = { return mathlib_min(mathlib_min3(a,b,c), mathlib_min3(d,e,f)); };
float (float a, float b, float c, float d, float e, float f, float g) mathlib_min7 = { return mathlib_min3(mathlib_min3(a,b,c), mathlib_min3(d,e,f), g); };
float (float a, float b, float c, float d, float e, float f, float g, float h) mathlib_min8 = { return mathlib_min3(mathlib_min3(a,b,c), mathlib_min3(d,e,f), mathlib_min(g, h)); };

// Returns the greater of two (or more) numbers
float (float a, float b) mathlib_max = {
	if (a>b)return a;
	else	return b;
};
float (float a, float b, float c) mathlib_max3 = {
	if (a>b) {
		if (c>a)	return c;
		else		return a;
	} else {
		if (c>b)	return c;
		else		return b;
	}
};
float (float a, float b, float c, float d) mathlib_max4 = { return mathlib_max(mathlib_max3(a,b,c),d); };
float (float a, float b, float c, float d, float e) mathlib_max5 = { return mathlib_max3(mathlib_max3(a,b,c),d,e); };
float (float a, float b, float c, float d, float e, float f) mathlib_max6 = { return mathlib_max(mathlib_max3(a,b,c), mathlib_max3(d,e,f)); };
float (float a, float b, float c, float d, float e, float f, float g) mathlib_max7 = { return mathlib_max3(mathlib_max3(a,b,c), mathlib_max3(d,e,f), g); };
float (float a, float b, float c, float d, float e, float f, float g, float h) mathlib_max8 = { return mathlib_max3(mathlib_max3(a,b,c), mathlib_max3(d,e,f), mathlib_max(g, h)); };

// Returns a number bound to certain limits
float(float minimum, float val, float maximum) mathlib_bound = {
	if (val<minimum)
		val=minimum;
	else if (val>minimum)
		val=maximum;
	return val;
};

// Returns a random vector of length < 1
// Different than vecrand: vector(float base, float rndmix, float plusminus) vecrand 
vector () mathlib_randomvec = {
	local vector v;
	do {
		v_x = random() * 2 - 1;
		v_y = random() * 2 - 1;
		v_z = random() * 2 - 1;
	}
	while(vlen(v) > 1);
	return v;
};

// Radians <--> Degrees.  Simple functions that convert radians to degrees.
float (float num) rad2deg = { return num*OneEightyOverPi; };
float (float num) deg2rad = { return num*PiOverOneEighty; };

// QC Rotation around world co-ord 0,0,0 (2 axis only) - Expecting one axis (XYZ) to always be constant
vector(vector targvec, float targang) mathlib_vectorotateX = {
	local vector retvec;
	retvec_x = targvec_x;
	retvec_y = (targvec_y * mathlib_cos(targang)) - (targvec_z * mathlib_sin(targang));
	retvec_z = (targvec_y * mathlib_sin(targang)) + (targvec_z * mathlib_cos(targang));
	return(retvec);
};

vector(vector targvec, float targang) mathlib_vectorotateY = {
	local vector retvec;
	retvec_x = (targvec_x * mathlib_cos(targang)) + (targvec_z * mathlib_sin(targang));
	retvec_y = targvec_y;
	retvec_z = (-targvec_x * mathlib_sin(targang)) + (targvec_z * mathlib_cos(targang));
	return(retvec);
};

vector(vector targvec, float targang) mathlib_vectorotateZ = {
	local vector retvec;
	retvec_x = (targvec_x * mathlib_cos(targang)) - (targvec_y * mathlib_sin(targang));
	retvec_y = (targvec_x * mathlib_sin(targang)) + (targvec_y * mathlib_cos(targang));
	retvec_z = targvec_z;
	return(retvec);
};

// Tangent.  Changes v_forward, v_right, v_up
float(float theta) mathlib_tan = {
  local vector ang; //temporary used to calculate trig values
  ang = '0 0 0';
  ang_y = theta; //assign theta to the yaw to simplify reasoning
  makevectors(ang);
  return v_forward_y / v_forward_x;
};

// Inverse Tangent
float(float y, float x) mathlib_atan2 = {
  local vector ang; //temporary used to calculate trig values
  ang = '0 0 0';
  ang_x = x;
  ang_y = y;
  //return mathlib_vectoyaw(ang);
  return vectoyaw(ang);
};

// QC version of engine code vectoangles function - Used to prevent returning integers (errors) on some engines.  Found a better solution with angle smoothing code instead
vector(vector targvec) mathlib_vectoangles = {
	// value1[0] = targvec_x, value1[1] = targvec_y, value1[2] = targvec_z
	// X=Pitch, Y=Yaw, Z=Forward;
	local vector ang;
	ang = '0 0 0';
	
	// if (value1[1] == 0 && value1[0] == 0)
	if (targvec_y == 0 && targvec_x == 0) {
		ang_y = 0;	// yaw=0
		// if (value1[2] > 0) pitch = 90;
		if (targvec_z > 0) ang_x = 90;	// pitch=90
		else ang_x = 270;				// pitch=270
	} else {
		// yaw = (int) (atan2(value1[1], value1[0]) * 180 / M_PI);
		// mathlib atan2 returns degree's not radian's (don't need *180/PI)
		ang_y = mathlib_atan2(targvec_y, targvec_x);
		if (ang_y < 0) ang_y = ang_y + 360;	// yaw += 360;
		
		// forward = sqrt (value1[0]*value1[0] + value1[1]*value1[1]);
		ang_z = mathlib_sqrt(targvec_x * targvec_x + targvec_y * targvec_y);

		// pitch = (int) (atan2(value1[2], forward) * 180 / M_PI);
		// mathlib atan2 returns degree's not radian's (don't need *180/PI)
		ang_x = mathlib_atan2(targvec_z, ang_z);
		if (ang_x < 0) ang_x = ang_x + 360;	// pitch += 360;
	}
	ang_z = 0; // forward (Z) not required, zero instead
	return ang;
};

// QC version of engine makevectors function
void(vector targang) mathlib_makevectors = {
	local float sr, sp, sy, cr, cp, cy;
	
	// targangs X=Pitch, Y=Yaw, Z=Roll
    sp = mathlib_sin(targang_x);
    cp = mathlib_cos(targang_x);
    sy = mathlib_sin(targang_y);
    cy = mathlib_cos(targang_y);
    sr = mathlib_sin(targang_z);
    cr = mathlib_cos(targang_z);
    v_forward_x = cp*cy;
    v_forward_y = cp*sy;
    v_forward_z = -sp;
    v_right_x = (-1*sr*sp*cy+-1*cr*-sy);
    v_right_y = (-1*sr*sp*sy+-1*cr*cy);
    v_right_z = -1*sr*cp;
    v_up_x = (cr*sp*cy+-sr*-sy);
    v_up_y = (cr*sp*sy+-sr*cy);
    v_up_z = cr*cp;
};

//========================================================================
// SPECIAL parm# ENCODING CODE TO STORE MULTIPLE VALUES IN A SINGLE parm#
//==========================================================================

//  Bits and Bytes
//------------------------------------------------------------------------
// World of the 24-bit or 3 byte parm. This chart from PM Drake mod.
//-----------------------------------------------------------------
//       7       6       5       4       3       2       1       0
//-----------------------------------------------------------------
//     128      64      32      16       8       4       2       1
//   32768   16384    8192    4096    2048    1024     512     256
// 8388608 4194304 2097152 1048576  524288  262144  131072   65536
//
// Byte1 = bits 0-7.  Byte2 = bits 8-15.  Byte3 = bits 16-23.
//       = 255              = 65280             = 16711680
//
// Bit24 = 16777216
//------------------------------------------------------------------------

// Boundary check function
// Take a float value and return:
// < 0, return 0
// 0 - max, return integer value, always rounding down
// > max, return max, where max is the max bit value, 255 is used with standard encoder below
float(float f, float max) f_bound = {
	if (max > 16777215) max = 16777215;

	if (f > max)
		f = max;
	else if (f < 0)
		f = 0;

	f = floor(f);
	return f;
};

// parm* value encoding and decoding
// Maximize storage of data in parm* values, most ammo data has a maximum of 200, armor is 200, health is 100, etc.
// This can be encoded into 8 bits.  The original code uses 1 parm* per data point - a serious waste of bits
// Each parm* variable has 24 bits = 3 * 8 bit values; encode 3 values according to formulas with all values bounded 0 - 255
// Values are set into float value 0 - 16777215
// Big endian ordering of passed arguments:
// s1 - into high 8 bits
// s2 - into middle 8 bits
// s3 - into low 8 bits

float(float s1, float s2, float s3) encode = {
	local float f;

	s1 = SUB_ClampFloat(s1,0,255);
	s2 = SUB_ClampFloat(s2,0,255);
	s3 = SUB_ClampFloat(s3,0,255);
	f = s1* 65536 + s2 * 256 + s3;
	return f;
};

// generic encode
// s1 is value
// bits are max value - 1, 3, 7, 15, 31...255...65535...{n} - a series of 1 bits
// pos is the position in the parm* variable
// - position will be the next bit value above the previous bits
// - i.e. for 3 value bits at position 1, the next position is 4
// - for 7 value bits at position 4, the next position is 32
// binary math equivalent:
// - 00000011 - 3 value at 1
// - 00011100 - 7 value at 4
// - 11100000 - 7 value at 32

// you could encode any values in any position with this function
// it is included here as an example if you have values smaller or larger than 255 to encode
// such as the painkeep carry items with a limit of 3 on most inventory

float(float s1, float bits, float pos) g_encode = {
	local float f;

	f = f_bound(s1, bits) * pos;
	return f;
};

// Recover an 8 bit value (0 - 255) from parm encoding, `parmval` is the passed value of parm* variable
// The value of `which` is one of
// 3 - return high 8 bits
// 2 - return middle 8 bits
// 1 - return low 8 bits
// Any other value will return low 8 bits

// Use these handy codes to avoid confusion
float HI8 = 3; // s3 value of encode() call
float MID8 = 2; // s2 value of encode() call
float LOW8 = 1; // s1 value of encode() call

float(float parmval, float which) decode = {
	local float f;

	if (which == 1)
		f = (parmval / 65536) & 255;
	else if (which == 2)
		f = (parmval / 256) & 255;
	else
		f = parmval & 255;

	return f;
};

// generic decode - extract data from generic encode above
// parmval is the parm* variable data
// bits are max value - 1, 3, 7, 15, 31...255...65535...{n} - a series of 1 bits
// pos is the position in the parm* variable
// this uses the same bits & pos to extract any generic encoded data, see notes under g_encode for more details
float(float parmval, float bits, float pos) g_decode = {
	local float f;

	f = (parmval / pos) & bits;
	return f;
};

//=========================================================================================
// PM:  Here because some engines support builtin math functions. (e.g., DarkPlaces).
//=========================================================================================

// Returns a point relative to entity 'e'.  Vector 'a' adds to e's absmins.
// a: '0 0 0' = mins, '0.5 0.5 0.5' = midpoint, '1 1 1' = maxs.
vector(entity e, vector a) Anypoint = {
    local vector v;

    v = e.absmin;
    v_x = v_x + e.size_x * a_x;
    v_y = v_y + e.size_y * a_y;
    v_z = v_z + e.size_z * a_z;
    return v;
};

// Returns the center of the entity 'e'.
vector(entity e) Midpoint = {return e.origin + (e.mins + e.maxs)*0.5;};

// Returns upper-mid point of a creature, or center of an object.
// Used for aiming by NPCs.
vector(entity e) Aimpoint = {
    if (e.flags & FLx_CREATURE)
        return Anypoint (e, '0.5 0.5 0.7');
    return Midpoint (e);
};

// Calculates outgoing vector when bouncing off a surface.
// Variation of SV_ClipVelocity.
// dir = inbound vector.
// norm = trace_plane_normal.
// ob = overbounce.  Use 1.5 for grenades, 2 for HipLaser.
// stop = stop_epsilon.  0.1 in C code, but use 0 for HipLaser.
vector(vector dir, vector norm, float ob, float stop) Vec_Reflect = {
    local   float   ddot;       // Double dot product, or dot * 2.

    ddot = dir * norm * ob;     // 'ob' for overbounce.  Was 2.
    dir_x = dir_x - (norm_x * ddot);
    if (fabs(dir_x) < stop) dir_x = 0;
    dir_y = dir_y - (norm_y * ddot);
    if (fabs(dir_y) < stop) dir_y = 0;
    dir_z = dir_z - (norm_z * ddot);
    if (fabs(dir_z) < stop) dir_z = 0;
    return dir;
};

// Direction Vector Change
// Originally in 'mirv.qc'.  Placed here now that other rocket attacks
// use them.  Specifically, rocketters' rockets and players' hydra missile. -PM
// This returns a unit vector whose direction points toward end if it is within theta degrees of dir.  If not, the vector returned will a direction somewhere between dir and the ideal vector.
// Similar to 'ai_turn', but for three dimensions.  NOTE:  Assumes (0 <= theta <= 180).
vector(vector dir, vector start, vector end, float theta) Dir_GotoIdeal = {
    local   vector  v1, v2;
    local   float   dist, dot, qccos, qcsin, rncos, rnsin;

    v1 = dir;
    v2 = end - start;
    dist = vlen(v2);
    v2 = normalize(v2);

    dot = v1 * v2;
    qccos = mathlib_cos(theta);
    qcsin = mathlib_sin(theta);
    if (dot < qccos) { // Endpoint not in the cone.  Calculate a new vector toward the endpoint that is within the cone.
        local   vector  vx, vy, vz;
        local   float   side, up;

        // Get the three vectors that make up dir.
        dir = vectoangles (dir);
        dir_x = 0 - dir_x;
        makevectors (dir);
        vx = v_forward; vy = v_right; vz = v_up;

        // Project, from start, to the point where the endpoint is neither ahead nor behind it.
        dist = dist * dot;
        start = start + v1*dist;
        dir = normalize(end - start);
        side = dir * vy; // Get the dot products of the horizontal and vertical vectors.
        up = dir * vz;
        dir = vy*side + vz*up;
        dist = vlen(dir);
        if (dist == 0) { // Can't use zero vector, so create a random unit vector.
            theta = random() * 360;
			rncos = mathlib_cos(theta);
			rnsin = mathlib_sin(theta);
            dir = vy*rncos + vz*rnsin;
        } else { // Make sure we have a unit vector.
            dir = normalize(dir);
        }

        // Calculate the final vector.  The result is already normalized.
        dir = vx*qccos + dir*qcsin;
    } else { // Endpoint is within the cone, so simply take its vector.
        dir = v2;
    }

    return dir;
};

// Fixed version of 'vectoangles'. From Drake.
// Note 8/4/2010:  Fixed by what standard?  Some need it, some don't.
vector(vector dir) Vangles = {
    dir   = vectoangles(dir);
    dir_x = anglemod(0 - dir_x);  // 'vectoangles' reverses pitch -- fix it!
    return dir;
};

//  This changes a directional vector. Useful for things that need drunken or spiraling paths.
// 'ang1' affects forward vector.
// 'ang2' affects side (right and up) vectors.
vector(vector dir, float ang1, float ang2) Dir_Change = {
	local float qccos, qcsin;

    dir = Vangles(dir);
    makevectors (dir);
    qccos = mathlib_cos(ang2);
    qcsin = mathlib_sin(ang2);
    dir = v_right*qccos + v_up*qcsin; // Get a vector perpendicular to its direction vector.
    qccos = mathlib_cos(ang1);
    qcsin = mathlib_sin(ang1);
    dir = v_forward*qccos + dir*qcsin; // Calculate new direction.
    return dir;
};

//  This randomly changes a vector's path.  Used by drunken missiles.
//
//  NOTE:  Assumes (0 <= theta <= 180).
vector(vector dir, float ang) Dir_Randomize = {
    local float a1, a2;

    a1 = random()*ang;
    a2 = random()*360;  // Random angle for perpendicular vector.
    return Dir_Change (dir, a1, a2);
};

// Emulate 'P_Random' from Doom/Heretic source.  Returns an integer from 0 to 255.
float() prandom = {return (random() * 256) & 255;};

// Damage when hit by a rocket directly.  Emulates 100-120 when d = 120.  Does 83.333% to 100% damage
float(float d) SUB_RandomDamage = {return d / 6 * (5 + random());};

// Damage when hit by melee attack.  Typical amount is the sum of three
// random calls multiplied by a given number.
float(float mx) SUB_MeleeDamage = {
    local   float   d;

    d = random();
    d = d + random();
    d = d + random();
    return d * mx;
};

vector() safe_client_forward = {
	local vector vf,vu,vr,retval;
	
	vf = v_forward; // Cache to preserve
	vu = v_up;
	vr = v_right;
	makevectors(self.v_angle);
	retval = v_forward; // Capture the forward vector.
	v_forward = vf; // Return to previous values.  This is what makes this safe as opposed to makevectors willy nilly.
	v_up = vu;
	v_right = vr;
	return retval; // Take me home!
};

// (Long Float To String) Format and print a number to the console
// - str_player : needs to be a client for various buffer commands
// - buffer : BUFFER_STUFFCMD, BUFFER_SPRINT, BUFFER_DPRINT
void(entity str_player, float str_num, float topbit, float botbit, float buffer) lftos = {
	local float str_counter, str_pow, str_result, str_remain, str_first;
	
	str_counter = topbit;		// Upper number length
	str_pow = mathlib_powbit(topbit,10);// Setup initial base 10 power for checking
	str_remain = FALSE;			// Decimal point been done yet
	str_first = FALSE;			// First non-zero digit printed

	// Deal with negative state first
	if (str_num < 0) {
		if (buffer & BUFFER_STUFFCMD) Safe_stuffcmd(str_player, "-");
		else if (buffer & BUFFER_SPRINT) sprint(str_player, "-");
		else if (buffer & BUFFER_DPRINT) dprint("-");
	}
	// Get rid of negative state
	str_num = fabs(str_num);
	
	// If number larger than fixed length?
	if (str_num > str_pow) str_num = str_num - (floor(str_num / str_pow) * str_pow);
	// New system, not used for this function
	// str_num = mathlib_truncate(str_num, topbit, botbit);

	// Loop through upper part of number
	while(str_counter > 0) {
		// Move down one pow digit
		str_pow = str_pow / 10;

		// Divide number by pow to get divider
		// Floor can produce rounding errors (fix it with 0.01)
		str_result = floor((str_num / str_pow)+0.01);
		if (str_result > 9) str_result = 9; // Result must be 0-9 digits
		if (str_result < 1) str_result = 0;
		
		// Fill front of number with spaces
		if (str_counter > 1 && str_result == 0 && str_first == FALSE) {
			// Print space to buffer type
			if (buffer & BUFFER_STUFFCMD) Safe_stuffcmd(str_player, " ");
			else if (buffer & BUFFER_SPRINT) sprint(str_player, " ");
			else if (buffer & BUFFER_DPRINT) dprint(" ");
		} else if (str_result > 0 || str_first) { // Display a number
			str_first = TRUE;
			// Print digit to buffer type
			if (buffer & BUFFER_STUFFCMD) Safe_stuffcmd(str_player, ftos(str_result));
			else if (buffer & BUFFER_SPRINT) sprint(str_player, ftos(str_result));
			else if (buffer & BUFFER_DPRINT) dprint(ftos(str_result));
		}
		
		str_num = str_num - (str_result * str_pow); // remove top part of number, decrease str length counter
		str_counter = str_counter - 1;
	}
	
	// Any decimal place?
	if (botbit <= 0) {
		// Check for zero value
		if (!str_first) {
			if (buffer & BUFFER_STUFFCMD) Safe_stuffcmd(str_player, "0");
			else if (buffer & BUFFER_SPRINT) sprint(str_player, "0");
			else if (buffer & BUFFER_DPRINT) dprint("0");
		}
		return;
	}
	
	// Is there any remainder?
	if (str_counter < 1) {
		// Print decimal point to buffer type
		if (!str_first) {
			str_first = TRUE;
			if (buffer & BUFFER_STUFFCMD) Safe_stuffcmd(str_player, "0.");
			else if (buffer & BUFFER_SPRINT) sprint(str_player, "0.");
			else if (buffer & BUFFER_DPRINT) dprint("0.");
		} else {
			if (buffer & BUFFER_STUFFCMD) Safe_stuffcmd(str_player, ".");
			else if (buffer & BUFFER_SPRINT) sprint(str_player, ".");
			else if (buffer & BUFFER_DPRINT) dprint(".");
		}
		if (botbit <1) botbit=1;
		str_counter = botbit;
		while (botbit > 0) { 
			str_num = str_num * 10; 
			botbit = botbit -1;
		}
		str_pow = mathlib_powbit(str_counter,10);
	}

	// Loop through lower part of number
	while(str_counter > 0) {
		str_pow = str_pow / 10; // Move down one pow digit
		str_result = floor((str_num / str_pow)+0.01); // Divide number by pow to get divider.  Floor can produce rounding errors (fix it with 0.01)
		if (str_result > 9) str_result = 9; // Result must be 0-9 digits
		if (str_result < 1) str_result = 0;

		if (str_result > 0 || str_first) {
			str_first = TRUE;
			if (buffer & BUFFER_STUFFCMD) Safe_stuffcmd(str_player, ftos(str_result)); // Print digit to buffer type
			else if (buffer & BUFFER_SPRINT) sprint(str_player, ftos(str_result));
			else if (buffer & BUFFER_DPRINT) dprint(ftos(str_result));
		}

		str_num = str_num - (str_result * str_pow); // remove top part of number, decrease str length counter
		str_counter = str_counter - 1;
	}
};