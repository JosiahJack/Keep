
void () flashlight_toggle;
void () flashlight_off;

void () ImpulseCommands = {

   if ( (self.impulse == TRUE) ) {

      if ( (self.flashlight_ammo < FL_SWIM) ) {

         sprint(self,"Not enough battery power\n");
         self.impulse = FALSE;
         return ;

      }
      flashlight_toggle ();

   }
   self.impulse = FALSE;

};

void () SetFlashlight_Frame = {

   ImpulseCommands ();

};

void () AmmoCnts = {

   if ( (self.flashlight_state == FALSE) ) {

      self.currentammo = self.ammo_shells;

   } else {

      self.currentammo = self.flashlight_ammo;
      if ( (self.flashlight_ammo <= FALSE) ) {

         self.currentammo = self.ammo_shells;
         self.flashlight_state = FALSE;
         sound (self,CHAN_VOICE,"misc/click.wav",TRUE,ATTN_NORM);
         sprint(self,"Flashlight turned off");
         sprint(self,"\n");
         flashlight_off ();

      }

   }
   self.ammo_cells = self.flashlight_ammo;

};

void () Flashlight_Ammo_Rot = {

   if ( (self.flashlight_state == FALSE) ) {

      return;

   }
   if ( (self.flashlight_ammo > FALSE) ) {

      self.flashlight_ammo = (self.flashlight_ammo - TRUE);
      AmmoCnts ();
      self.nextthink = (time + FL_SWIM);
      self.think = Flashlight_Ammo_Rot;
      return;

   }
   AmmoCnts ();

};

void () flashlight_update = {

   if ( (self.owner.health <= FALSE) ) {

      if ( (self.flashlight_state == TRUE) ) {

         self.flashlight_state = FALSE;
         sound (self,CHAN_VOICE,"misc/click.wav",TRUE,ATTN_NORM);
         sprint(self,"Flashlight turned off");
         sprint(self,"\n");
         flashlight_off ();

      }
      return;

   }
   self.effects = EF_DIMLIGHT;
   makevectors (self.owner.v_angle);
   traceline (self.owner.origin,(self.owner.origin + (v_forward * 500)),FALSE,self);
   setorigin (self,trace_endpos + (v_forward * -5));
   self.nextthink = time + 0.020;

};

void () flashlight_on = {

   local entity playerFlashlight;

   playerFlashlight = spawn();
   playerFlashlight.movetype = MOVETYPE_NONE;
   playerFlashlight.solid = SOLID_NOT;
   playerFlashlight.model = "progs/flashlight.spr";
   setmodel (playerFlashlight,"progs/flashlight.spr");
   setsize (playerFlashlight,'-8.00 -8.00 -8.00','8.00 8.00 8.00');
   playerFlashlight.owner = self;
   self.flashlight = playerFlashlight;
   playerFlashlight.classname = "flashlight";
   playerFlashlight.effects = EF_DIMLIGHT;
   makevectors (self.v_angle);
   traceline (self.origin,(self.origin + (v_forward * 500)),FALSE,self);
   setorigin (playerFlashlight,trace_endpos);
   AmmoCnts ();
   self.flashlight.think = flashlight_update;
   self.flashlight.nextthink = time + 0.020;
   
};

void () flashlight_toggle = {

   if ( (self.flashlight_ammo <= FALSE) ) {

      return;

   }
   if (!(self.flashlight_state) ) {

      self.flashlight_state = TRUE;
      sound (self,CHAN_VOICE,"misc/click.wav",TRUE,ATTN_NORM);
      sprint(self,"Flashlight turned on");
      sprint(self,"\n");
      self.currentammo = self.flashlight_ammo;
      self.items = (self.items | IT_SUPER_SHOTGUN);
      Flashlight_Ammo_Rot ();
      flashlight_on ();

   } else {

      self.flashlight_state = FALSE;
      sound (self,CHAN_VOICE,"misc/click.wav",TRUE,ATTN_NORM);
      sprint(self,"Flashlight turned off");
      sprint(self,"\n");
      flashlight_off ();
      AmmoCnts ();

   }

};

void () flashlight_off = {

   self.items = (self.items - IT_SUPER_SHOTGUN);
   self.flashlight.think = SUB_Remove;
   self.flashlight.nextthink = 0.100;

};