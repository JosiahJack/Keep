
/*
====================================
drsfrma.qc

Contains new model animation system stuffs

====================================
*/

void() DRS_PFrame =
{
// DRS: Set pf_state, then call Update_PF.
	if(self.pf_state <= PF_AXRUN || self.pf_state == PF_CLEAR)
	 {
		if((vlen(self.velocity) <= 0) && (self.flags & FL_ONGROUND) && (self.weapon != IT_AXE)) // Standing then...Whaddya waitin' for? Christmas!? =P
		 self.pf_state = PF_STAND;
		else if((vlen(self.velocity) <= 0) && (self.flags & FL_ONGROUND) && (self.weapon == IT_AXE)) // Standing then...Only with AXE! =P
		 self.pf_state = PF_AXSTAND;
		else if((vlen(self.velocity) > 0) && (self.flags & FL_ONGROUND) && self.weapon == IT_AXE) // ax running.  Running with Axes.  And not scissors. =P
		 self.pf_state = PF_AXRUN;
		else if((vlen(self.velocity) > 0) && (self.flags & FL_ONGROUND) && self.weapon != IT_AXE) // gun running.  You dirty smuggler. =P
		 self.pf_state = PF_RUN;
	 }

// DRS: Update Playerframe
	 if(self.pf_state <= 3)
	  Update_PF();
};
