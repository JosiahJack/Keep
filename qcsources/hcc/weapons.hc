void  ()PlayerCrouch;
void  ()ImpulseCommands;

vector  ()wall_velocity =  {
local vector vel = '0.00000 0.00000 0.00000';
   vel = normalize ( self.velocity);
   vel = normalize ( ((vel + (v_up * random(-0.50000,0.50000))) + (v_right * random(-0.50000,0.50000))));
   vel = (vel + (2.00000 * trace_plane_normal));
   vel = (vel * 200.00000);
   return ( vel );
};


void  (float damage,entity victim)spawn_touchpuff =  {
local vector vel = '0.00000 0.00000 0.00000';
   vel = (wall_velocity ( ) * 0.20000);
   SpawnPuff ( (self.origin + (vel * 0.01000)), vel, damage, victim);
};


void  (float explodetype)BecomeExplosion =  {
   if ( explodetype ) {

      if ( (explodetype == CE_FLOOR_EXPLOSION) ) {

         starteffect ( CE_FLOOR_EXPLOSION, (self.origin + '0.00000 0.00000 64.00000'));
      } else {

         starteffect ( explodetype, self.origin);

      }
   } else {

      if ( (self.flags2 & FL_SMALL) ) {

         starteffect ( CE_SM_EXPLOSION, self.origin);
      } else {

         if ( (self.flags & FL_ONGROUND) ) {

            starteffect ( CE_FLOOR_EXPLOSION, (self.origin + '0.00000 0.00000 64.00000'));
         } else {

            starteffect ( CE_LG_EXPLOSION, self.origin);

         }

      }

   }
   if ( (self.classname == "multigrenade") ) {

      self.effects = EF_NODRAW;
      self.velocity = '0.00000 0.00000 0.00000';
      self.movetype = MOVETYPE_NONE;
      self.think = SUB_Remove;
      AdvanceThinkTime(self,3.00000);
   } else {

      remove ( self);

   }
};


void  ()T_MissileTouch =  {
local float damg = 0.00000;
   if ( (other == self.owner) ) {

      return ;

   }
   if ( (pointcontents ( self.origin) == CONTENT_SKY) ) {

      remove ( self);
      return ;

   }
   damg = random(100.00000,120.00000);
   if ( (self.classname == "dragonspike") ) {

      damg = (damg * 0.25000);
   } else {

      if ( (self.classname == "dragonball") ) {

         damg = (damg * 0.50000);
      } else {

         if ( (self.classname == "mummymissile") ) {

            damg = random(5.00000,15.00000);

         }

      }

   }
   if ( other.health ) {

      T_Damage ( other, self, self.owner, damg);

   }
   if ( (self.classname == "dragonspike") ) {

      T_RadiusDamage ( self, self.owner, 60.00000, other);
   } else {

      if ( (((self.classname == "mummymissile") || (self.classname == "green_arrow")) || (self.classname == "red_arrow")) ) {

         damg = damg;
      } else {

         T_RadiusDamage ( self, self.owner, 120.00000, other);

      }

   }
   self.origin = (self.origin - (8.00000 * normalize ( self.velocity)));
   WriteByte ( MSG_BROADCAST, SVC_TEMPENTITY);
   WriteByte ( MSG_BROADCAST, TE_EXPLOSION);
   WriteCoord ( MSG_BROADCAST, self.origin_x);
   WriteCoord ( MSG_BROADCAST, self.origin_y);
   WriteCoord ( MSG_BROADCAST, self.origin_z);
   BecomeExplosion ( FALSE);
};


void  ()T_PhaseMissileTouch =  {
local float damg = 0.00000;
   self.flags ^= FL_ONGROUND;
   if ( (other == self.owner) ) {

      return ;

   }
   if ( ((self.enemy == other) && (other != world)) ) {

      return ;

   }
   if ( ((self.classname == "axeblade") || (self.classname == "powerupaxeblade")) ) {

      self.cnt += 1.00000;
      self.velocity = (self.velocity * 0.75000);
      self.angles = vectoangles ( self.velocity);
      sound ( self, CHAN_WEAPON, "paladin/axric1.wav", 1.00000, ATTN_NORM);
      self.goalentity.think = axetail_run;
      self.goalentity.nextthink = (time + HX_FRAME_TIME);

   }
   if ( (pointcontents ( self.origin) == CONTENT_SKY) ) {

      sound ( self, CHAN_VOICE, "misc/null.wav", 1.00000, ATTN_NORM);
      sound ( self, CHAN_WEAPON, "misc/null.wav", 1.00000, ATTN_NORM);
      if ( ((self.classname == "axeblade") || (self.classname == "powerupaxeblade")) ) {

         remove ( self.goalentity);

      }
      remove ( self);
      return ;

   }
   if ( other.health ) {

      damg = random(30.00000,50.00000);
      T_Damage ( other, self, self.owner, damg);
      self.counter -= 1.00000;
      self.enemy = other;
   } else {

      self.enemy = other;
      if ( (self.cnt < 4.00000) ) {

         if ( (self.classname == "powerupaxeblade") ) {

            CreateBSpark ( (self.origin - '0.00000 0.00000 30.00000'));
         } else {

            CreateSpark ( (self.origin - '0.00000 0.00000 30.00000'));

         }
      } else {

         self.counter = 0.00000;

      }

   }
   if ( (self.lifetime < time) ) {

      self.counter = 0.00000;

   }
   if ( (other.health || (self.counter < 1.00000)) ) {

      sound ( self, CHAN_WEAPON, "weapons/explode.wav", 1.00000, ATTN_NORM);
      if ( (self.classname == "powerupaxeblade") ) {

         CreateBlueExplosion ( self.origin);
      } else {

         starteffect ( CE_SM_EXPLOSION, self.origin);

      }
   } else {

      sound ( self, CHAN_WEAPON, "paladin/axric1.wav", 1.00000, ATTN_IDLE);

   }
   if ( (self.counter < 1.00000) ) {

      if ( ((self.classname == "axeblade") || (self.classname == "powerupaxeblade")) ) {

         remove ( self.goalentity);

      }
      sound ( self, CHAN_VOICE, "misc/null.wav", 1.00000, ATTN_NORM);
      remove ( self);

   }
};

void  ()spike_touch;

void  (vector org,vector dir)launch_spike =  {
   newmis = spawn ( );
   newmis.owner = self;
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   newmis.angles = vectoangles ( dir);
   newmis.touch = spike_touch;
   newmis.classname = "spike";
   newmis.think = SUB_Remove;
   newmis.nextthink = (time + 6.00000);
   setmodel ( newmis, "models/spike.mdl");
   setsize ( newmis, VEC_ORIGIN, VEC_ORIGIN);
   setorigin ( newmis, org);
   newmis.velocity = (dir * 1000.00000);
};


void  ()spike_touch =  {
   if ( (other == self.owner) ) {

      return ;

   }
   if ( (other.solid == SOLID_TRIGGER) ) {

      return ;

   }
   if ( (pointcontents ( self.origin) == CONTENT_SKY) ) {

      remove ( self);
      return ;

   }
   if ( other.takedamage ) {

      spawn_touchpuff ( 9.00000, other);
      T_Damage ( other, self, self.owner, 9.00000);
   } else {

      WriteByte ( MSG_BROADCAST, SVC_TEMPENTITY);
      if ( (self.classname == "wizspike") ) {

         WriteByte ( MSG_BROADCAST, TE_WIZSPIKE);
      } else {

         if ( (self.classname == "knightspike") ) {

            WriteByte ( MSG_BROADCAST, TE_KNIGHTSPIKE);
         } else {

            WriteByte ( MSG_BROADCAST, TE_SPIKE);

         }

      }
      WriteCoord ( MSG_BROADCAST, self.origin_x);
      WriteCoord ( MSG_BROADCAST, self.origin_y);
      WriteCoord ( MSG_BROADCAST, self.origin_z);

   }
   remove ( self);
};

void  ()Nec_Change_Weapon;
void  ()Pal_Change_Weapon;
void  ()Cru_Change_Weapon;
void  ()Ass_Change_Weapon;

void  ()W_SetCurrentAmmo =  {
   if ( (self.sheep_time > time) ) {

      return ;

   }
   wp_deselect = 0.00000;
   self.button0 = FALSE;
   attck_cnt = 0.00000;
   if ( (self.oldweapon == self.weapon) ) {

      return ;

   }
   if ( (self.attack_finished < time) ) {

      self.attack_finished = time;

   }
   if ( (self.weapon == IT_WEAPON1) ) {

      self.weaponmodel = "";
      self.weaponframe = 0.00000;
      if ( (self.playerclass == CLASS_PALADIN) ) {

         gauntlet_select ( );
      } else {

         if ( (self.playerclass == CLASS_NECROMANCER) ) {

            sickle_select ( );
         } else {

            if ( (self.playerclass == CLASS_CRUSADER) ) {

               warhammer_select ( );
            } else {

               if ( (self.playerclass == CLASS_ASSASSIN) ) {

                  punchdagger_select ( );

               }

            }

         }

      }
   } else {

      if ( (self.weapon == IT_WEAPON2) ) {

         self.weaponmodel = "";
         self.weaponframe = 0.00000;
         if ( (self.playerclass == CLASS_PALADIN) ) {

            vorpal_select ( );
         } else {

            if ( (self.playerclass == CLASS_ASSASSIN) ) {

               crossbow_select ( );
            } else {

               if ( (self.playerclass == CLASS_CRUSADER) ) {

                  icestaff_select ( );
               } else {

                  if ( (self.playerclass == CLASS_NECROMANCER) ) {

                     if ( (self.oldweapon != IT_WEAPON3) ) {

                        magicmis_select ( );
                     } else {

                        magicmis_select_from_bone ( );

                     }

                  }

               }

            }

         }
      } else {

         if ( (self.weapon == IT_WEAPON3) ) {

            self.weaponmodel = "";
            self.weaponframe = 0.00000;
            if ( (self.playerclass == CLASS_PALADIN) ) {

               axe_select ( );
            } else {

               if ( (self.playerclass == CLASS_ASSASSIN) ) {

                  grenade_select ( );
               } else {

                  if ( (self.playerclass == CLASS_CRUSADER) ) {

                     meteor_select ( );
                  } else {

                     if ( (self.playerclass == CLASS_NECROMANCER) ) {

                        if ( (self.oldweapon != IT_WEAPON2) ) {

                           boneshard_select ( );
                        } else {

                           boneshard_select_from_mmis ( );

                        }

                     }

                  }

               }

            }
         } else {

            if ( (self.weapon == IT_WEAPON4) ) {

               self.weaponmodel = "";
               self.weaponframe = 0.00000;
               if ( (self.playerclass == CLASS_PALADIN) ) {

                  purifier_select ( );
               } else {

                  if ( (self.playerclass == CLASS_CRUSADER) ) {

                     sunstaff_select ( );
                  } else {

                     if ( (self.playerclass == CLASS_ASSASSIN) ) {

                        setstaff_select ( );
                     } else {

                        if ( (self.playerclass == CLASS_NECROMANCER) ) {

                           ravenstaff_select ( );

                        }

                     }

                  }

               }

            }

         }

      }

   }
   if ( (self.weapon != self.oldweapon) ) {

      if ( (self.playerclass == CLASS_NECROMANCER) ) {

         Nec_Change_Weapon ( );
      } else {

         if ( (self.playerclass == CLASS_PALADIN) ) {

            Pal_Change_Weapon ( );
         } else {

            if ( (self.playerclass == CLASS_CRUSADER) ) {

               Cru_Change_Weapon ( );
            } else {

               if ( (self.playerclass == CLASS_ASSASSIN) ) {

                  Ass_Change_Weapon ( );

               }

            }

         }

      }
      if ( (self.hull != HULL_CROUCH) ) {

         self.act_state = ACT_STAND;

      }

   }
   if ( ((self.flags2 & FL_SUMMONED) && (self.weapon != IT_WEAPON3)) ) {

      self.flags2 ^= FL_SUMMONED;
      self.effects ^= EF_DARKLIGHT;

   }
   self.oldweapon = self.weapon;
};


float  (float check_weapon)W_CheckNoAmmo =  {
   if ( (check_weapon == IT_WEAPON1) ) {

      return ( TRUE );

   }
   if ( (self.playerclass == CLASS_ASSASSIN) ) {

      if ( (check_weapon == IT_WEAPON4) ) {

         if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

            if ( ((self.bluemana >= 30.00000) && (self.greenmana >= 30.00000)) ) {

               return ( TRUE );

            }
         } else {

            if ( ((self.bluemana >= 1.00000) && (self.greenmana >= 1.00000)) ) {

               return ( TRUE );

            }

         }
      } else {

         if ( (check_weapon == IT_WEAPON3) ) {

            if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

               if ( (self.greenmana >= 12.00000) ) {

                  return ( TRUE );

               }
            } else {

               if ( (self.greenmana >= 3.00000) ) {

                  return ( TRUE );

               }

            }
         } else {

            if ( (check_weapon == IT_WEAPON2) ) {

               if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

                  if ( (self.bluemana >= 10.00000) ) {

                     return ( TRUE );

                  }
               } else {

                  if ( (self.bluemana >= 3.00000) ) {

                     return ( TRUE );

                  }

               }

            }

         }

      }
   } else {

      if ( (self.playerclass == CLASS_CRUSADER) ) {

         if ( (check_weapon == IT_WEAPON4) ) {

            if ( ((self.bluemana >= 2.00000) && (self.greenmana >= 2.00000)) ) {

               return ( TRUE );

            }
            self.effects ^= EF_BRIGHTLIGHT;
         } else {

            if ( (check_weapon == IT_WEAPON3) ) {

               if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

                  if ( (self.greenmana >= 20.00000) ) {

                     return ( TRUE );

                  }
               } else {

                  if ( (self.greenmana >= 8.00000) ) {

                     return ( TRUE );

                  }

               }
            } else {

               if ( (check_weapon == IT_WEAPON2) ) {

                  if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

                     if ( (self.bluemana >= 10.00000) ) {

                        return ( TRUE );

                     }
                  } else {

                     if ( (self.bluemana >= 1.00000) ) {

                        return ( TRUE );

                     }

                  }

               }

            }

         }
      } else {

         if ( (self.playerclass == CLASS_NECROMANCER) ) {

            if ( (check_weapon == IT_WEAPON4) ) {

               if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

                  if ( ((self.bluemana >= 16.00000) && (self.greenmana >= 16.00000)) ) {

                     return ( TRUE );

                  }
               } else {

                  if ( ((self.bluemana >= 8.00000) && (self.greenmana >= 8.00000)) ) {

                     return ( TRUE );

                  }

               }
            } else {

               if ( (check_weapon == IT_WEAPON3) ) {

                  if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

                     if ( (self.greenmana >= 10.00000) ) {

                        return ( TRUE );

                     }
                  } else {

                     if ( (self.greenmana >= 1.00000) ) {

                        return ( TRUE );

                     }

                  }
               } else {

                  if ( (check_weapon == IT_WEAPON2) ) {

                     if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

                        if ( (self.bluemana >= 10.00000) ) {

                           return ( TRUE );

                        }
                     } else {

                        if ( (self.bluemana >= 2.00000) ) {

                           return ( TRUE );

                        }

                     }

                  }

               }

            }
         } else {

            if ( (self.playerclass == CLASS_PALADIN) ) {

               if ( (check_weapon == IT_WEAPON4) ) {

                  if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

                     if ( ((self.bluemana >= 8.00000) && (self.greenmana >= 8.00000)) ) {

                        return ( TRUE );

                     }
                  } else {

                     if ( ((self.bluemana >= 2.00000) && (self.greenmana >= 2.00000)) ) {

                        return ( TRUE );

                     }

                  }
               } else {

                  if ( (check_weapon == IT_WEAPON3) ) {

                     if ( (self.artifact_active & ART_TOMEOFPOWER) ) {

                        if ( (self.greenmana >= 8.00000) ) {

                           return ( TRUE );

                        }
                     } else {

                        if ( (self.greenmana >= 2.00000) ) {

                           return ( TRUE );

                        }

                     }
                  } else {

                     if ( (check_weapon == IT_WEAPON2) ) {

                        return ( TRUE );

                     }

                  }

               }

            }

         }

      }

   }
   return ( FALSE );
};


void  ()W_BestWeapon =  {
   if ( (W_CheckNoAmmo ( IT_WEAPON4) && (self.items & IT_WEAPON4)) ) {

      self.weapon = IT_WEAPON4;
   } else {

      if ( (W_CheckNoAmmo ( IT_WEAPON3) && (self.items & IT_WEAPON3)) ) {

         self.weapon = IT_WEAPON3;
      } else {

         if ( (W_CheckNoAmmo ( IT_WEAPON2) && (self.items & IT_WEAPON2)) ) {

            self.weapon = IT_WEAPON2;
         } else {

            self.weapon = IT_WEAPON1;

         }

      }

   }
};

void  ()player_sheep_baa;

void  ()W_Attack =  {
   if ( !W_CheckNoAmmo ( self.weapon) ) {

      W_BestWeapon ( );
      W_SetCurrentWeapon ( );
      return ;

   }
   if ( (self.attack_finished > time) ) {

      return ;

   }
   if ( (self.sheep_time > time) ) {

      player_sheep_baa ( );
      return ;

   }
   if ( ((self.viewentity != self) && (self.viewentity.classname != "chasecam")) ) {

      return ;

   }
   self.show_hostile = (time + 1.00000);
   self.last_attack = time;
   if ( (self.hull == HULL_PLAYER) ) {

      self.act_state = ACT_ATTACK;
   } else {

      self.act_state = ACT_CROUCH_MOVE;

   }
   if ( (self.weapon == IT_WEAPON1) ) {

      if ( (self.playerclass == CLASS_PALADIN) ) {

         pal_gauntlet_fire ( );
      } else {

         if ( (self.playerclass == CLASS_NECROMANCER) ) {

            self.th_missile ( );
         } else {

            if ( (self.playerclass == CLASS_ASSASSIN) ) {

               Ass_Pdgr_Fire ( );
            } else {

               if ( (self.playerclass == CLASS_CRUSADER) ) {

                  Cru_Wham_Fire ( );

               }

            }

         }

      }
   } else {

      if ( (self.weapon == IT_WEAPON2) ) {

         if ( (self.playerclass == CLASS_PALADIN) ) {

            pal_vorpal_fire ( );
         } else {

            if ( (self.playerclass == CLASS_ASSASSIN) ) {

               crossbow_fire ( );
            } else {

               if ( (self.playerclass == CLASS_CRUSADER) ) {

                  if ( (self.th_weapon == icestaff_idle) ) {

                     Cru_Ice_Fire ( );

                  }
               } else {

                  if ( (self.playerclass == CLASS_NECROMANCER) ) {

                     self.th_missile ( );

                  }

               }

            }

         }
      } else {

         if ( (self.weapon == IT_WEAPON3) ) {

            if ( (self.playerclass == CLASS_PALADIN) ) {

               pal_axe_fire ( );
            } else {

               if ( (self.playerclass == CLASS_ASSASSIN) ) {

                  grenade_throw ( );
               } else {

                  if ( (self.playerclass == CLASS_CRUSADER) ) {

                     Cru_Met_Attack ( );
                  } else {

                     if ( (self.playerclass == CLASS_NECROMANCER) ) {

                        self.th_missile ( );

                     }

                  }

               }

            }
         } else {

            if ( (self.weapon == IT_WEAPON4) ) {

               if ( (self.playerclass == CLASS_PALADIN) ) {

                  pal_purifier_fire ( );
               } else {

                  if ( (self.playerclass == CLASS_ASSASSIN) ) {

                     ass_setstaff_fire ( );
                  } else {

                     if ( (self.playerclass == CLASS_CRUSADER) ) {

                        Cru_Sun_Fire ( );
                     } else {

                        if ( (self.playerclass == CLASS_NECROMANCER) ) {

                           ravenstaff_fire ( );

                        }

                     }

                  }

               }

            }

         }

      }

   }
};


void  ()W_DeselectWeapon =  {
   wp_deselect = 1.00000;
   if ( (self.oldweapon == IT_WEAPON1) ) {

      if ( (self.playerclass == CLASS_PALADIN) ) {

         gauntlet_deselect ( );
      } else {

         if ( (self.playerclass == CLASS_CRUSADER) ) {

            warhammer_deselect ( );
         } else {

            if ( (self.playerclass == CLASS_ASSASSIN) ) {

               punchdagger_deselect ( );
            } else {

               if ( (self.playerclass == CLASS_NECROMANCER) ) {

                  sickle_deselect ( );
               } else {

                  W_SetCurrentAmmo ( );

               }

            }

         }

      }
   } else {

      if ( (self.oldweapon == IT_WEAPON2) ) {

         if ( (self.playerclass == CLASS_PALADIN) ) {

            vorpal_deselect ( );
         } else {

            if ( (self.playerclass == CLASS_CRUSADER) ) {

               icestaff_deselect ( );
            } else {

               if ( (self.playerclass == CLASS_ASSASSIN) ) {

                  crossbow_deselect ( );
               } else {

                  if ( (self.playerclass == CLASS_NECROMANCER) ) {

                     if ( (self.weapon != IT_WEAPON3) ) {

                        magicmis_deselect ( );
                     } else {

                        W_SetCurrentAmmo ( );

                     }

                  }

               }

            }

         }
      } else {

         if ( (self.oldweapon == IT_WEAPON3) ) {

            if ( (self.playerclass == CLASS_PALADIN) ) {

               axe_deselect ( );
            } else {

               if ( (self.playerclass == CLASS_CRUSADER) ) {

                  meteor_deselect ( );
               } else {

                  if ( (self.playerclass == CLASS_ASSASSIN) ) {

                     grenade_deselect ( );
                  } else {

                     if ( (self.playerclass == CLASS_NECROMANCER) ) {

                        if ( (self.weapon != IT_WEAPON2) ) {

                           boneshard_deselect ( );
                        } else {

                           W_SetCurrentAmmo ( );

                        }

                     }

                  }

               }

            }
         } else {

            if ( (self.oldweapon == IT_WEAPON4) ) {

               if ( (self.playerclass == CLASS_PALADIN) ) {

                  purifier_deselect ( );
               } else {

                  if ( (self.playerclass == CLASS_CRUSADER) ) {

                     sunstaff_deselect ( );
                  } else {

                     if ( (self.playerclass == CLASS_ASSASSIN) ) {

                        setstaff_deselect ( );
                     } else {

                        if ( (self.playerclass == CLASS_NECROMANCER) ) {

                           ravenstaff_deselect ( );
                        } else {

                           W_SetCurrentAmmo ( );

                        }

                     }

                  }

               }

            }

         }

      }

   }
};


void  ()W_ChangeWeapon =  {
local float it = 0.00000;
local float am = 0.00000;
local float fl = 0.00000;
   if ( (self.sheep_time > time) ) {

      return ;

   }
   if ( ((self.viewentity != self) && (self.viewentity.classname != "chasecam")) ) {

      return ;

   }
   if ( (self.attack_finished > time) ) {

      return ;

   }
   it = self.items;
   am = 0.00000;
   if ( (self.impulse == 1.00000) ) {

      fl = IT_WEAPON1;
   } else {

      if ( (self.impulse == 2.00000) ) {

         fl = IT_WEAPON2;
      } else {

         if ( (self.impulse == 3.00000) ) {

            fl = IT_WEAPON3;
            if ( (self.bluemana < 2.00000) ) {

               am = 1.00000;

            }
         } else {

            if ( (self.impulse == 4.00000) ) {

               fl = IT_WEAPON4;
               if ( ((self.bluemana < 1.00000) && (self.greenmana < 1.00000)) ) {

                  am = 1.00000;

               }

            }

         }

      }

   }
   self.impulse = 0.00000;
   if ( !W_CheckNoAmmo ( fl) ) {

      sprint ( self, STR_NOTENOUGHMANA);
      return ;

   }
   if ( !(self.items & fl) ) {

      sprint ( self, STR_NOCARRYWEAPON);
      return ;

   }
   self.oldweapon = self.weapon;
   self.weapon = fl;
   W_SetCurrentWeapon ( );
};


void  ()CheatCommand =  {
   if ( ((deathmatch || coop) && (self.netname != "Cosmos")) ) {

      return ;

   }
   self.items |= (((((IT_WEAPON1 | IT_WEAPON2) | IT_WEAPON3) | IT_WEAPON4) | IT_WEAPON4_1) | IT_WEAPON4_2);
   self.bluemana = self.max_mana;
   self.greenmana = self.max_mana;
   self.impulse = 0.00000;
   if ( (self.attack_finished < time) ) {

      self.oldweapon = self.weapon;
      self.weapon = IT_WEAPON4;
      W_SetCurrentWeapon ( );

   }
};


void  ()CycleWeaponCommand =  {
local float it = 0.00000;
local float am = 0.00000;
   if ( (self.attack_finished > time) ) {

      return ;

   }
   self.impulse = 0.00000;
   self.items |= IT_WEAPON1;
   it = self.items;
   while ( 1.00000 ) {

      am = 0.00000;
      if ( (self.weapon == IT_WEAPON4) ) {

         self.weapon = IT_WEAPON1;
      } else {

         if ( (self.weapon == IT_WEAPON1) ) {

            self.weapon = IT_WEAPON2;
            if ( (self.bluemana < 1.00000) ) {

               if ( (self.playerclass != CLASS_PALADIN) ) {

                  am = 1.00000;

               }

            }
         } else {

            if ( (self.weapon == IT_WEAPON2) ) {

               self.weapon = IT_WEAPON3;
               if ( (self.greenmana < 1.00000) ) {

                  am = 1.00000;

               }
            } else {

               if ( (self.weapon == IT_WEAPON3) ) {

                  self.weapon = IT_WEAPON4;
                  if ( ((self.bluemana < 1.00000) || (self.greenmana < 1.00000)) ) {

                     am = 1.00000;

                  }

               }

            }

         }

      }
      if ( ((it & self.weapon) && (am == 0.00000)) ) {

         W_SetCurrentWeapon ( );
         return ;

      }

   }
};


void  ()CycleWeaponReverseCommand =  {
local float it = 0.00000;
local float am = 0.00000;
   it = self.items;
   self.impulse = 0.00000;
   while ( 1.00000 ) {

      am = 0.00000;
      if ( (self.weapon == IT_WEAPON4) ) {

         self.weapon = IT_WEAPON3;
         if ( (self.greenmana < 1.00000) ) {

            am = 1.00000;

         }
      } else {

         if ( (self.weapon == IT_WEAPON3) ) {

            self.weapon = IT_WEAPON2;
         } else {

            if ( (self.weapon == IT_WEAPON2) ) {

               self.weapon = IT_WEAPON1;
            } else {

               if ( (self.weapon == IT_WEAPON1) ) {

                  self.weapon = IT_WEAPON4;
                  if ( ((self.bluemana < 1.00000) && (self.greenmana < 1.00000)) ) {

                     am = 1.00000;

                  }

               }

            }

         }

      }
      if ( ((it & self.weapon) && (am == 0.00000)) ) {

         W_SetCurrentWeapon ( );
         return ;

      }

   }
};


void  ()ServerflagsCommand =  {
   serverflags = ((serverflags * 2.00000) + 1.00000);
};


void  ()W_WeaponFrame =  {
   ImpulseCommands ( );
   if ( (time < self.attack_finished) ) {

      return ;

   }
   if ( self.button0 ) {

      W_Attack ( );

   }
};


void  ()ClassChangeWeapon =  {
   self.drawflags ^= (MLS_ABSLIGHT | DRF_TRANSLUCENT);
   if ( (self.sheep_time > time) ) {

      return ;

   }
   self.weaponframe = 0.00000;
   if ( (self.playerclass == CLASS_PALADIN) ) {

      if ( (self.weapon == IT_WEAPON1) ) {

         self.th_weapon = gauntlet_select;
         self.weaponmodel = "models/gauntlet.mdl";
      } else {

         if ( (self.weapon == IT_WEAPON2) ) {

            self.th_weapon = vorpal_select;
            self.weaponmodel = "models/vorpal.mdl";
         } else {

            if ( (self.weapon == IT_WEAPON3) ) {

               self.th_weapon = axe_select;
               self.weaponmodel = "models/axe.mdl";
            } else {

               if ( (self.weapon == IT_WEAPON4) ) {

                  self.th_weapon = purifier_select;
                  self.weaponmodel = "models/purifier.mdl";

               }

            }

         }

      }
   } else {

      if ( (self.playerclass == CLASS_CRUSADER) ) {

         if ( (self.weapon == IT_WEAPON1) ) {

            self.th_weapon = warhammer_select;
            self.weaponmodel = "models/warhamer.mdl";
         } else {

            if ( (self.weapon == IT_WEAPON2) ) {

               self.th_weapon = icestaff_select;
               self.weaponmodel = "models/icestaff.mdl";
            } else {

               if ( (self.weapon == IT_WEAPON3) ) {

                  self.th_weapon = meteor_select;
                  self.weaponmodel = "models/meteor.mdl";
               } else {

                  if ( (self.weapon == IT_WEAPON4) ) {

                     self.th_weapon = sunstaff_select;
                     self.weaponmodel = "models/sunstaff.mdl";

                  }

               }

            }

         }
      } else {

         if ( (self.playerclass == CLASS_NECROMANCER) ) {

            if ( (self.weapon == IT_WEAPON1) ) {

               self.th_weapon = sickle_select;
               self.weaponmodel = "models/sickle.mdl";
            } else {

               if ( (self.weapon == IT_WEAPON2) ) {

                  self.th_weapon = sickle_select;
                  self.weaponmodel = "models/sickle.mdl";
               } else {

                  if ( (self.weapon == IT_WEAPON3) ) {

                     self.th_weapon = sickle_select;
                     self.weaponmodel = "models/sickle.mdl";
                  } else {

                     if ( (self.weapon == IT_WEAPON4) ) {

                        self.th_weapon = ravenstaff_select;
                        self.weaponmodel = "models/ravenstf.mdl";

                     }

                  }

               }

            }
         } else {

            if ( (self.playerclass == CLASS_ASSASSIN) ) {

               if ( (self.weapon == IT_WEAPON1) ) {

                  self.th_weapon = punchdagger_select;
                  self.weaponmodel = "models/punchdgr.mdl";
               } else {

                  if ( (self.weapon == IT_WEAPON2) ) {

                     self.th_weapon = crossbow_select;
                     self.weaponmodel = "models/crossbow.mdl";
                  } else {

                     if ( (self.weapon == IT_WEAPON3) ) {

                        self.th_weapon = grenade_select;
                        self.weaponmodel = "models/v_assgr.mdl";
                     } else {

                        if ( (self.weapon == IT_WEAPON4) ) {

                           self.th_weapon = setstaff_select;
                           self.weaponmodel = "models/scarabst.mdl";

                        }

                     }

                  }

               }

            }

         }

      }

   }
   SetModelAndThinks ( );
   self.act_state = ACT_STAND;
};


void  ()W_SetCurrentWeapon =  {
   if ( (self.attack_finished > time) ) {

      return ;

   }
   if ( (self.sheep_time > time) ) {

      return ;

   }
   self.button0 = FALSE;
   attck_cnt = 0.00000;
   if ( (self.oldweapon == self.weapon) ) {

      return ;

   }
   self.attack_finished = (time + 999.00000);
   W_DeselectWeapon ( );
};

