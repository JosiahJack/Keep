
void () shell_touch;

void (vector org, vector dir) eject_shell = {

   local float r;
   local string temp;

   makevectors (self.v_angle);
   newmis = spawn ();
   newmis.owner = self;
   newmis.movetype = MOVETYPE_BOUNCE;
   r = random ();
   if (r < 0.5)
    newmis.solid = SOLID_BBOX;
   else
    newmis.solid = SOLID_NOT;
   newmis.angles = v_forward * (r + 1);
   newmis.classname = "shellcasing";
   newmis.touch = shell_touch;
   newmis.think = SUB_Remove;
   newmis.owner = self;
   newmis.nextthink = (time + 1);
   if ( (self.weaponmodel == "progs/v_moss.mdl") || (self.weaponmodel == "progs/v_ashot.mdl") )
    {
     setmodel (newmis,"progs/sshell.mdl");
    }
   else
    {
     setmodel (newmis,"progs/shell.mdl");
    }
   setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (newmis,org);
   newmis.avelocity_x = (r * 6000.000);
   newmis.avelocity_y = (r * 6000.000);
   if ( ((r < 0.100) && (r >= MSG_BROADCAST)) ) {

      newmis.velocity = (((v_forward * 20.000) + (v_right * 60.000)) + (v_up * 80.000));

   }
   if ( ((r < 0.200) && (r >= 0.100)) ) {

      newmis.velocity = (((v_forward * SVC_INTERMISSION) + (v_right * 65.000)) + (v_up * 90.000));

   }
   if ( ((r < 0.300) && (r >= 0.200)) ) {

      newmis.velocity = (((v_forward * 25.000) + (v_right * 70.000)) + (v_up * 100.000));

   }
   if ( ((r < 0.400) && (r >= 0.300)) ) {

      newmis.velocity = (((v_forward * 15.000) + (v_right * 75.000)) + (v_up * 110.000));

   }
   if ( ((r < 0.500) && (r >= 0.400)) ) {

      newmis.velocity = (((v_forward * 25.000) + (v_right * 80.000)) + (v_up * 130.000));

   }
   if ( ((r < 0.600) && (r >= 0.500)) ) {

      newmis.velocity = (((v_forward * 20.000) + (v_right * 85.000)) + (v_up * 150.000));

   }
   if ( ((r < 0.700) && (r >= 0.600)) ) {

      newmis.velocity = (((v_forward * TE_LAVASPLASH) + (v_right * 90.000)) + (v_up * 120.000));

   }
   if ( ((r < 0.800) && (r >= 0.700)) ) {

      newmis.velocity = (((v_forward * 20.000) + (v_right * 100.000)) + (v_up * 200.000));

   }
   if ( ((r < 0.900) && (r >= 0.800)) ) {

      newmis.velocity = (((v_forward * SVC_INTERMISSION) + (v_right * 110.000)) + (v_up * 130.000));

   }
   if ( ((r <= WEAPON_SHOTGUN) && (r >= 0.900)) ) {

      newmis.velocity = (((v_forward * 25.000) + (v_right * 105.000)) + (v_up * 175.000));

   }

};

void () shell_touch = {

   if ( (other.classname == "door") ) {

      SUB_Remove ();
      return ;

   }
   if (self.owner.weaponmodel == "progs/v_mk23.mdl")
    sound (self,CHAN_WEAPON,"weapons/shellhit.wav",TRUE,ATTN_NORM);
   else if (self.owner.weaponmodel == "progs/v_shotgun.mdl")
    sound (self,CHAN_WEAPON,"weapons/shellhit2.wav",TRUE,ATTN_NORM);
   else
    sound (self,CHAN_WEAPON,"weapons/shellhit3.wav",TRUE,ATTN_NORM);
      
      

};

