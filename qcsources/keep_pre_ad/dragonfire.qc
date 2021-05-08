void () s_firballexplode5 = [ 5.000, s_firballexplode6 ] {};
void () s_firballexplode6 = [ 6.000, s_firballexplode7 ] {};
void () s_firballexplode7 = [ 7.000, s_firballexplode8 ] {};
void () s_firballexplode8 = [ 8.000, s_firballexplode9 ] {};
void () s_firballexplode9 = [ 9.000, s_firballexplode10 ] {};
void () s_firballexplode10 = [ 10.000, s_firballexplode11 ] {};
void () s_firballexplode11 = [ 11.000, s_firballexplode12 ] {};
void () s_firballexplode12 = [ 12.000, s_firballexplode13 ] {};
void () s_firballexplode13 = [ 13.000, SUB_Remove ] {};

void () s_firespurtexplode1 = [ 1.000, s_firespurtexplode2 ] {};
void () s_firespurtexplode2 = [ 2.000, s_firespurtexplode3 ] {};
void () s_firespurtexplode3 = [ 3.000, s_firespurtexplode4 ] {};
void () s_firespurtexplode4 = [ 4.000, s_firespurtexplode5 ] {};
void () s_firespurtexplode5 = [ 5.000, s_firespurtexplode6 ] {};
void () s_firespurtexplode6 = [ 6.000, s_firespurtexplode7 ] {};
void () s_firespurtexplode7 = [ 7.000, s_firespurtexplode8 ] {};
void () s_firespurtexplode8 = [ 8.000, s_firespurtexplode9 ] {};
void () s_firespurtexplode9 = [ 9.000, s_firespurtexplode10 ] {};
void () s_firespurtexplode10 = [ 10.000, s_firespurtexplode11 ] {};
void () s_firespurtexplode11 = [ 11.000, s_firespurtexplode12 ] {};
void () s_firespurtexplode12 = [ 12.000, s_firespurtexplode13 ] {};
void () s_firespurtexplode13 = [ 13.000, SUB_Remove ] {};

void () BecomeFireSpurt = {

   T_RadiusDamage (self,self.owner,40,world);
   self.touch = SUB_Null;
   setmodel (self,"progs/medexp.spr");
   sound (self,CHAN_WEAPON,"pyro/fstop.wav",TRUE,ATTN_NORM);
   s_firespurtexplode1();

};

void () BecomeFireBall = {

   T_RadiusDamage (self,self.owner,40,world);
   self.touch = SUB_Null;
   setmodel (self,"progs/smlexp.spr");
   sound (self,CHAN_WEAPON,"pyro/fstop.wav",TRUE,ATTN_NORM);
   s_firballexplode5();

};

void () FireBallVerticalLaunch = {

   local entity missile;
   local float tempRand;

   missile = spawn ();
   missile.owner = self.owner;
   missile.movetype = MOVETYPE_BOUNCE;
   missile.solid = SOLID_BBOX;
   missile.classname = "Dragonfire";
   missile.v_angle = self.v_angle;
   missile.v_angle_z = (missile.v_angle_z - 90);
   makevectors (missile.v_angle);
   missile.velocity = ((v_forward * 15) + (v_up * 160));
   tempRand = ((crandom () * 60.000) - SVC_INTERMISSION);
   missile.velocity = (missile.velocity + (tempRand * v_forward));
   tempRand = ((crandom () * CTF_FLAG_RETURN_TIME) - 20.000);
   missile.velocity = (missile.velocity + (tempRand * v_right));
   tempRand = ((crandom () * 60.000) - SVC_INTERMISSION);
   missile.velocity = (missile.velocity + (tempRand * v_up));
   missile.avelocity = '300.000 300.000 300.000';
   missile.angles = vectoangles (missile.velocity);
   missile.touch = BecomeFireBall;
   missile.frame = 6;
   setmodel (missile,"progs/smlexp.spr");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,self.origin);
   missile.nextthink = ((time + TRUE) + (crandom () * 0.500));
   missile.think = BecomeFireBall;

};

void (float offsetAngle) FireBallSpurtLaunch = {

   local entity missile;
   local float tempRand;

   missile = spawn ();
   missile.owner = self.owner;
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_BBOX;
   missile.classname = "Dragonfire";
   missile.v_angle = self.v_angle;
   missile.v_angle_y = (missile.v_angle_y + offsetAngle);
   makevectors (missile.v_angle);
   missile.velocity = ((v_forward * 150.000) + (v_up * 2.000));
   tempRand = ((crandom () * 60.000) - SVC_INTERMISSION);
   missile.velocity = (missile.velocity + (tempRand * v_forward));
   tempRand = ((crandom () * CTF_FLAG_RETURN_TIME) - 20.000);
   missile.velocity = (missile.velocity + (tempRand * v_right));
   tempRand = ((crandom () * 60.000) - SVC_INTERMISSION);
   missile.velocity = (missile.velocity + (tempRand * v_up));
   missile.avelocity = '300.000 300.000 300.000';
   missile.angles = vectoangles (missile.velocity);
   missile.touch = BecomeFireSpurt;
   missile.frame = 6;
   setmodel (missile,"progs/medexp.spr");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,self.origin);
   missile.nextthink = ((time + TRUE) + (crandom () * 0.500));
   missile.think = BecomeFireSpurt;

};

void (float offsetAngle) MiniFireBallLaunch = {

   local entity missile;
   local float tempRand;

   missile = spawn ();
   missile.owner = self.owner;
   missile.movetype = MOVETYPE_BOUNCE;
   missile.solid = SOLID_BBOX;
   missile.classname = "Dragonfire";
   missile.v_angle = self.v_angle;
   missile.v_angle_y = (missile.v_angle_y + offsetAngle);
   makevectors (missile.v_angle);
   missile.velocity = ((v_forward * 100.000) + (v_up * CTF_TARGET_PROTECT_RADIUS));
   tempRand = ((crandom () * 60.000) - SVC_INTERMISSION);
   missile.velocity = (missile.velocity + (tempRand * v_forward));
   tempRand = ((crandom () * CTF_FLAG_RETURN_TIME) - 20.000);
   missile.velocity = (missile.velocity + (tempRand * v_right));
   tempRand = ((crandom () * 60.000) - SVC_INTERMISSION);
   missile.velocity = (missile.velocity + (tempRand * v_up));
   missile.avelocity = '300.000 300.000 300.000';
   missile.angles = vectoangles (missile.velocity);
   missile.touch = BecomeFireBall;
   missile.frame = 6;
   setmodel (missile,"progs/smlexp.spr");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,self.origin);
   missile.nextthink = ((time + TRUE) + (crandom () * 0.500));
   missile.think = BecomeFireBall;

};

void () DragonFire_Touch = {

   if (pointcontents(self.origin) == CONTENT_SKY)
   {
      remove(self);
      return;
   }
   if (other.takedamage) {

      T_Damage (other,self,self.owner,12);

   }
   BecomeFireBall();

}

void () DragonFireExplode = {

   if (self.ammo_rockets > FALSE) {

      T_RadiusDamage (self,self.owner,50,world);
      if (self.ammo_rockets == 6) {

         self.frame = 6;

      }
      if (self.ammo_rockets == 4) {

         self.frame = 7;

      }
      if (self.ammo_rockets == 3) {

         self.frame = 8;

      }
      if (self.ammo_rockets == 2) {

         self.frame = 9;

      }
      self.ammo_rockets = (self.ammo_rockets - TRUE);
      self.think = DragonFireExplode;
      self.nextthink = (time + 0.250);

   } else {

      //MiniFireBallLaunch (FALSE);
      //MiniFireBallLaunch (72);
      //MiniFireBallLaunch (144);
      //MiniFireBallLaunch (216);
      //MiniFireBallLaunch (288);
      //FireBallSpurtLaunch (35);
      //FireBallSpurtLaunch (100);
      //FireBallSpurtLaunch (192);
      //FireBallSpurtLaunch (240);
      //FireBallSpurtLaunch (315);
      //FireBallVerticalLaunch();
      BecomeFireBall();

   }

};

void () Fire_DragonFire = {

   self.ammo_rockets1 = (self.ammo_rockets1 - TRUE);  // REMOVE
   self.currentammo = (self.currentammo - TRUE);	// REMOVE
   UpdateAmmoCounts (self);					// REMOVE
   sound (self,CHAN_WEAPON,"pyro/flame.wav",TRUE,ATTN_NORM);

   newmis = spawn();
   newmis.owner = self;
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.classname = "Dragonfire";
   newmis.solid = SOLID_NOT;
   setmodel (newmis,"progs/smlexp.spr");
   setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (newmis,self.origin);
   newmis.frame = 5;

   self.punchangle_x = CONTENT_SOLID;
   makevectors (self.v_angle);
   if ( self.v_angle_x ) {

      newmis.velocity = (((v_forward * 600.000) + ((crandom () * v_right) * MOVETYPE_BOUNCE)) + ((crandom () * v_up) * MOVETYPE_BOUNCE));

   } else {

      newmis.velocity = aim (self,10000.000);
      newmis.velocity = (newmis.velocity * 600.000);
      newmis.velocity_z = 200.000;

   }
   newmis.avelocity = '300.000 300.000 300.000';
   newmis.effects = EF_DIMLIGHT;
   newmis.angles = vectoangles (newmis.velocity);
   newmis.ammo_rockets = 10;
   newmis.touch = DragonFire_Touch;
   newmis.nextthink = (time + 0.50);
   newmis.think = DragonFireExplode;

};