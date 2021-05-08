void  ()SUB_regen;
void  ()StartItem;
void  ()ring_touch;

void  ()artifact_touch =  {
local float amount = 0.00000;
   if ( ((other.classname != "player") || (other.model == "models/sheep.mdl")) ) {

      return ;

   }
   if ( (other.health <= 0.00000) ) {

      return ;

   }
   if ( ((self.owner == other) && (self.artifact_ignore_owner_time > time)) ) {

      return ;

   }
   if ( (self.artifact_ignore_time > time) ) {

      return ;

   }
   if ( (self.netname == STR_TORCH) ) {

      if ( ((other.cnt_torch + 1.00000) > 15.00000) ) {

         return ;
      } else {

         other.cnt_torch += 1.00000;

      }
   } else {

      if ( (self.netname == STR_HEALTHBOOST) ) {

         if ( ((other.cnt_h_boost + 1.00000) > 25.00000) ) {

            return ;
         } else {

            other.cnt_h_boost += 1.00000;

         }
      } else {

         if ( (self.netname == STR_SUPERHEALTHBOOST) ) {

            if ( (deathmatch && ((other.cnt_sh_boost + 1.00000) > 2.00000)) ) {

               return ;
            } else {

               if ( ((other.cnt_sh_boost + 1.00000) > 5.00000) ) {

                  return ;
               } else {

                  other.cnt_sh_boost += 1.00000;

               }

            }
         } else {

            if ( (self.netname == STR_MANABOOST) ) {

               if ( ((other.cnt_mana_boost + 1.00000) > 15.00000) ) {

                  return ;
               } else {

                  other.cnt_mana_boost += 1.00000;

               }
            } else {

               if ( (self.netname == STR_TELEPORT) ) {

                  if ( ((other.cnt_teleport + 1.00000) > 15.00000) ) {

                     return ;
                  } else {

                     other.cnt_teleport += 1.00000;

                  }
               } else {

                  if ( (self.netname == STR_TOME) ) {

                     if ( ((other.cnt_tome + 1.00000) > 15.00000) ) {

                        return ;
                     } else {

                        other.cnt_tome += 1.00000;

                     }
                  } else {

                     if ( (self.netname == STR_SUMMON) ) {

                        if ( ((other.cnt_summon + 1.00000) > 15.00000) ) {

                           return ;
                        } else {

                           other.cnt_summon += 1.00000;

                        }
                     } else {

                        if ( (self.netname == STR_INVISIBILITY) ) {

                           if ( ((other.cnt_invisibility + 1.00000) > 15.00000) ) {

                              return ;
                           } else {

                              other.cnt_invisibility += 1.00000;

                           }
                        } else {

                           if ( (self.netname == STR_GLYPH) ) {

                              if ( (other.playerclass == CLASS_CRUSADER) ) {

                                 if ( ((other.cnt_glyph + 5.00000) > 50.00000) ) {

                                    return ;
                                 } else {

                                    other.cnt_glyph += 5.00000;

                                 }
                              } else {

                                 if ( ((other.cnt_glyph + 1.00000) > 15.00000) ) {

                                    return ;
                                 } else {

                                    other.cnt_glyph += 1.00000;

                                 }

                              }
                           } else {

                              if ( (self.netname == STR_HASTE) ) {

                                 if ( ((other.cnt_haste + 1.00000) > 15.00000) ) {

                                    return ;
                                 } else {

                                    other.cnt_haste += 1.00000;

                                 }
                              } else {

                                 if ( (self.netname == STR_BLAST) ) {

                                    if ( ((other.cnt_blast + 1.00000) > 15.00000) ) {

                                       return ;
                                    } else {

                                       other.cnt_blast += 1.00000;

                                    }
                                 } else {

                                    if ( (self.netname == STR_POLYMORPH) ) {

                                       if ( ((other.cnt_polymorph + 1.00000) > 15.00000) ) {

                                          return ;
                                       } else {

                                          other.cnt_polymorph += 1.00000;

                                       }
                                    } else {

                                       if ( (self.netname == STR_FLIGHT) ) {

                                          if ( ((other.cnt_flight + 1.00000) > 15.00000) ) {

                                             return ;
                                          } else {

                                             other.cnt_flight += 1.00000;

                                          }
                                       } else {

                                          if ( (self.netname == STR_CUBEOFFORCE) ) {

                                             if ( ((other.cnt_cubeofforce + 1.00000) > 15.00000) ) {

                                                return ;
                                             } else {

                                                other.cnt_cubeofforce += 1.00000;

                                             }
                                          } else {

                                             if ( (self.netname == STR_INVINCIBILITY) ) {

                                                if ( ((other.cnt_invincibility + 1.00000) > 15.00000) ) {

                                                   return ;
                                                } else {

                                                   other.cnt_invincibility += 1.00000;

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
   amount = random();
   if ( (amount < 0.50000) ) {

      sprint ( other, STR_YOUPOSSESS);
      sprint ( other, self.netname);
   } else {

      sprint ( other, STR_YOUHAVEACQUIRED);
      sprint ( other, self.netname);

   }
   sprint ( other, "\n");
   if ( self.artifact_respawn ) {

      self.mdl = self.model;
      if ( (self.netname == STR_INVINCIBILITY) ) {

         AdvanceThinkTime(self,120.00000);
      } else {

         if ( (self.netname == STR_INVISIBILITY) ) {

            AdvanceThinkTime(self,90.00000);
         } else {

            AdvanceThinkTime(self,60.00000);

         }

      }
      self.think = SUB_regen;

   }
   sound ( other, CHAN_VOICE, "items/artpkup.wav", 1.00000, ATTN_NORM);
   stuffcmd ( other, "bf\n");
   self.solid = SOLID_NOT;
   self.model = string_null;
   activator = other;
   SUB_UseTargets ( );
   if ( !self.artifact_respawn ) {

      remove ( self);

   }
};


void  ()Artifact_Cheat =  {
   self.cnt_sh_boost = 20.00000;
   self.cnt_summon = 20.00000;
   self.cnt_glyph = 20.00000;
   self.cnt_blast = 20.00000;
   self.cnt_polymorph = 20.00000;
   self.cnt_flight = 20.00000;
   self.cnt_cubeofforce = 20.00000;
   self.cnt_invincibility = 20.00000;
   self.cnt_invisibility = 20.00000;
   self.cnt_haste = 20.00000;
   self.cnt_mana_boost = 20.00000;
   self.cnt_sh_boost = 20.00000;
   self.cnt_h_boost = 20.00000;
   self.cnt_teleport = 20.00000;
   self.cnt_tome = 20.00000;
   self.cnt_torch = 20.00000;
};


void  (string modelname,string art_name,float respawnflag)GenerateArtifactModel =  {
   if ( respawnflag ) {

      self.artifact_respawn = deathmatch;

   }
   setmodel ( self, modelname);
   self.netname = art_name;
   if ( (modelname == "models/ringft.mdl") ) {

      self.netname = "Ring of Flight";
      self.touch = ring_touch;
   } else {

      if ( (modelname != "models/a_xray.mdl") ) {

         self.touch = artifact_touch;

      }

   }
   setsize ( self, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   StartItem ( );
};


void  (float artifact,float respawnflag)spawn_artifact =  {
   if ( (artifact == ARTIFACT_HASTE) ) {

      GenerateArtifactModel ( "models/a_haste.mdl", STR_HASTE, respawnflag);
   } else {

      if ( (artifact == ARTIFACT_POLYMORPH) ) {

         GenerateArtifactModel ( "models/a_poly.mdl", STR_POLYMORPH, respawnflag);
      } else {

         if ( (artifact == ARTIFACT_GLYPH) ) {

            GenerateArtifactModel ( "models/a_glyph.mdl", STR_GLYPH, respawnflag);
         } else {

            if ( (artifact == ARTIFACT_INVISIBILITY) ) {

               GenerateArtifactModel ( "models/a_invis.mdl", STR_INVISIBILITY, respawnflag);
            } else {

               if ( (artifact == ARTIFACT_INVINCIBILITY) ) {

                  GenerateArtifactModel ( "models/a_invinc.mdl", STR_INVINCIBILITY, respawnflag);
               } else {

                  if ( (artifact == ARTIFACT_CUBEOFFORCE) ) {

                     GenerateArtifactModel ( "models/a_cube.mdl", STR_CUBEOFFORCE, respawnflag);
                  } else {

                     if ( (artifact == ARTIFACT_SUMMON) ) {

                        GenerateArtifactModel ( "models/a_summon.mdl", STR_SUMMON, respawnflag);
                     } else {

                        if ( (artifact == ARTIFACT_TOME) ) {

                           GenerateArtifactModel ( "models/a_tome.mdl", STR_TOME, respawnflag);
                        } else {

                           if ( (artifact == ARTIFACT_TELEPORT) ) {

                              GenerateArtifactModel ( "models/a_telprt.mdl", STR_TELEPORT, respawnflag);
                           } else {

                              if ( (artifact == ARTIFACT_MANA_BOOST) ) {

                                 GenerateArtifactModel ( "models/a_mboost.mdl", STR_MANABOOST, respawnflag);
                              } else {

                                 if ( (artifact == ARTIFACT_BLAST) ) {

                                    GenerateArtifactModel ( "models/a_blast.mdl", STR_BLAST, respawnflag);
                                 } else {

                                    if ( (artifact == ARTIFACT_TORCH) ) {

                                       GenerateArtifactModel ( "models/a_torch.mdl", STR_TORCH, respawnflag);
                                    } else {

                                       if ( (artifact == ARTIFACT_HP_BOOST) ) {

                                          GenerateArtifactModel ( "models/a_hboost.mdl", STR_HEALTHBOOST, respawnflag);
                                       } else {

                                          if ( (artifact == ARTIFACT_SUPER_HP_BOOST) ) {

                                             GenerateArtifactModel ( "models/a_shbost.mdl", STR_SUPERHEALTHBOOST, respawnflag);
                                          } else {

                                             if ( (artifact == ARTIFACT_FLIGHT) ) {

                                                GenerateArtifactModel ( "models/ringft.mdl", STR_FLIGHT, respawnflag);

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
};


void  ()DecrementSuperHealth =  {
local float wait_time = 0.00000;
local float over = 0.00000;
local float decr_health = 0.00000;
   if ( (self.health > self.max_health) ) {

      if ( (self.health < 200.00000) ) {

         wait_time = 2.00000;
         decr_health = 1.00000;
      } else {

         if ( (self.health < 400.00000) ) {

            decr_health = 1.00000;
            over = (200.00000 - (self.health - 200.00000));
            wait_time = (over / 400.00000);
            if ( (wait_time < 0.10000) ) {

               wait_time = 0.10000;

            }
         } else {

            wait_time = 0.10000;
            over = (self.health - 400.00000);
            decr_health = (over * 0.01600);
            decr_health = ceil ( decr_health);
            if ( (decr_health < 2.00000) ) {

               decr_health = 2.00000;

            }

         }

      }
      self.health = (self.health - decr_health);
      self.healthtime = (time + wait_time);
   } else {

      self.artifact_flags ^= AFL_SUPERHEALTH;

   }
};


void  ()use_super_healthboost =  {
   self.healthtime = (time + 0.05000);
   if ( (self.health < -100.00000) ) {

      self.health = 1.00000;
   } else {

      if ( (self.health < 0.00000) ) {

         self.health += 100.00000;
      } else {

         if ( (self.health < 899.00000) ) {

            self.health = (self.health + 100.00000);
         } else {

            if ( (self.health > 999.00000) ) {

               self.health = 999.00000;

            }

         }

      }

   }
   self.cnt_sh_boost -= 1.00000;
   self.artifact_flags |= AFL_SUPERHEALTH;
};


void  ()art_SuperHBoost =  {
   spawn_artifact ( ARTIFACT_SUPER_HP_BOOST, RESPAWN);
};


void  ()use_healthboost =  {
   if ( (self.health >= self.max_health) ) {

      return ;

   }
   self.cnt_h_boost -= 1.00000;
   self.health += 25.00000;
   if ( (self.health > self.max_health) ) {

      self.health = self.max_health;

   }
};


void  ()art_HealthBoost =  {
   spawn_artifact ( ARTIFACT_HP_BOOST, RESPAWN);
};


void  ()art_torch =  {
   spawn_artifact ( ARTIFACT_TORCH, RESPAWN);
};


void  ()KillTorch =  {
   if ( !(self.artifact_active & ART_INVISIBILITY) ) {

      self.effects ^= EF_DIMLIGHT;

   }
   self.artifact_flags ^= AFL_TORCH;
};


void  ()DouseTorch =  {
   sound ( self, CHAN_BODY, "raven/douse.wav", 1.00000, ATTN_IDLE);
   self.torchtime = 0.00000;
   KillTorch ( );
};


void  ()DimTorch =  {
   sound ( self, CHAN_BODY, "raven/kiltorch.wav", 1.00000, ATTN_IDLE);
   self.effects ^= EF_TORCHLIGHT;
   self.torchtime = (time + 7.00000);
   self.torchthink = KillTorch;
};


void  ()FullTorch =  {
   sound ( self, CHAN_BODY, "raven/fire1.wav", 1.00000, ATTN_NORM);
   self.effects |= EF_TORCHLIGHT;
   self.torchtime = (time + 23.00000);
   self.torchthink = DimTorch;
};


void  ()UseTorch =  {
   if ( ((self.effects != EF_DIMLIGHT) && (self.effects != EF_TORCHLIGHT)) ) {

      sound ( self, CHAN_WEAPON, "raven/littorch.wav", 1.00000, ATTN_NORM);
      self.effects |= EF_DIMLIGHT;
      self.torchtime = (time + 1.00000);
      self.torchthink = FullTorch;
      self.artifact_flags |= AFL_TORCH;
      self.cnt_torch -= 1.00000;

   }
};


void  ()art_blastradius =  {
   spawn_artifact ( ARTIFACT_BLAST, RESPAWN);
};


void  ()UseManaBoost =  {
   self.bluemana = self.max_mana;
   self.greenmana = self.max_mana;
   self.cnt_mana_boost -= 1.00000;
};


void  ()art_manaboost =  {
   spawn_artifact ( ARTIFACT_MANA_BOOST, RESPAWN);
};


void  ()art_teleport =  {
   spawn_artifact ( ARTIFACT_TELEPORT, RESPAWN);
};


void  ()art_tomeofpower =  {
   spawn_artifact ( ARTIFACT_TOME, RESPAWN);
};


void  ()art_summon =  {
   spawn_artifact ( ARTIFACT_SUMMON, RESPAWN);
};


void  ()art_glyph =  {
   spawn_artifact ( ARTIFACT_GLYPH, RESPAWN);
};


void  ()art_haste =  {
   spawn_artifact ( ARTIFACT_HASTE, RESPAWN);
};


void  ()art_polymorph =  {
   spawn_artifact ( ARTIFACT_POLYMORPH, RESPAWN);
};


void  ()art_cubeofforce =  {
   spawn_artifact ( ARTIFACT_CUBEOFFORCE, RESPAWN);
};


void  ()art_invincibility =  {
   spawn_artifact ( ARTIFACT_INVINCIBILITY, RESPAWN);
};


void  ()art_invisibility =  {
   spawn_artifact ( ARTIFACT_INVISIBILITY, RESPAWN);
};


void  ()item_spawner_use =  {
   DropBackpack ( );
};


void  ()item_spawner =  {
   setmodel ( self, self.model);
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_NONE;
   self.modelindex = 0.00000;
   self.model = "";
   self.effects = EF_NODRAW;
   self.use = item_spawner_use;
};

