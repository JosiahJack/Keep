void  (float dm)ThrowSolidHead;

void  ()blood_splatter =  {
   SpawnPuff ( self.origin, (normalize ( self.velocity) * -20.00000), 10.00000, self);
   remove ( self);
};


void  (vector org,vector dir)ThrowBlood =  {
local entity blood;
   blood = spawn_temp ( );
   blood.solid = SOLID_BBOX;
   blood.movetype = MOVETYPE_TOSS;
   blood.touch = blood_splatter;
   blood.velocity = dir;
   blood.avelocity = random('-700.00000 -700.00000 -700.00000','700.00000 700.00000 700.00000');
   blood.thingtype = THINGTYPE_FLESH;
   setmodel ( blood, "models/bldspot4.spr");
   setsize ( blood, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( blood, org);
};


void  (vector spot,vector normal,float scaling,float face,float roll)ZeBrains =  {
   newmis = spawn ( );
   newmis.scale = scaling;
   newmis.angles = vectoangles ( normal);
   if ( face ) {

      newmis.angles_y += 180.00000;

   }
   newmis.angles_z = roll;
   setmodel ( newmis, "models/brains.mdl");
   setsize ( newmis, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( newmis, (spot + (normal * 1.00000)));
   newmis.think = corpseblink;
   AdvanceThinkTime(newmis,30.00000);
   spot = newmis.origin;
   makevectors ( normal);
   ThrowBlood ( spot, (((normal + (random(0.75000,0.75000) * v_up)) + (random(0.75000,0.75000) * v_right)) * random(200.00000,400.00000)));
   ThrowBlood ( spot, (((normal + (random(0.75000,0.75000) * v_up)) + (random(0.75000,0.75000) * v_right)) * random(200.00000,400.00000)));
   ThrowBlood ( spot, (((normal + (random(0.75000,0.75000) * v_up)) + (random(0.75000,0.75000) * v_right)) * random(200.00000,400.00000)));
   ThrowBlood ( spot, (((normal + (random(0.75000,0.75000) * v_up)) + (random(0.75000,0.75000) * v_right)) * random(200.00000,400.00000)));
   ThrowBlood ( spot, (((normal + (random(0.75000,0.75000) * v_up)) + (random(0.75000,0.75000) * v_right)) * random(200.00000,400.00000)));
};


void  ()ChunkRemove =  {
   chunk_cnt -= 1.00000;
   SUB_Remove ( );
};


vector  ()ChunkVelocity =  {
local vector v = '0.00000 0.00000 0.00000';
   v_x = (300.00000 * crandom ( ));
   v_y = (300.00000 * crandom ( ));
   v_z = random(100.00000,400.00000);
   v = (v * 0.70000);
   return ( v );
};


void  (string chunkname,vector location,float life_time,float skinnum)ThrowSingleChunk =  {
local entity chunk;
   if ( (chunk_cnt < CHUNK_MAX) ) {

      chunk = spawn_temp ( );
      setmodel ( chunk, chunkname);
      chunk.frame = 0.00000;
      setsize ( chunk, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
      chunk.movetype = MOVETYPE_BOUNCE;
      chunk.solid = SOLID_NOT;
      chunk.takedamage = DAMAGE_NO;
      chunk.velocity = ChunkVelocity ( );
      chunk.think = ChunkRemove;
      chunk.flags ^= FL_ONGROUND;
      chunk.origin = location;
      chunk.avelocity_x = random(10.00000);
      chunk.avelocity_y = random(10.00000);
      chunk.avelocity_z = random(30.00000);
      chunk.skin = skinnum;
      chunk.ltime = time;
      AdvanceThinkTime(chunk,life_time);
      chunk_cnt += 1.00000;

   }
};


void  (vector org,vector dir,float chunk_count)MeatChunks =  {
local float final = 0.00000;
local entity chunk;
   while ( chunk_count ) {

      chunk = spawn_temp ( );
      chunk_count -= 1.00000;
      final = random();
      if ( (final < 0.33000) ) {

         setmodel ( chunk, "models/flesh1.mdl");
      } else {

         if ( (final < 0.66000) ) {

            setmodel ( chunk, "models/flesh2.mdl");
         } else {

            setmodel ( chunk, "models/flesh3.mdl");

         }

      }
      setsize ( chunk, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
      chunk.movetype = MOVETYPE_BOUNCE;
      chunk.solid = SOLID_NOT;
      if ( (dir == '0.00000 0.00000 0.00000') ) {

         chunk.velocity = ChunkVelocity ( );
      } else {

         chunk.velocity = dir;

      }
      chunk.think = ChunkRemove;
      chunk.avelocity_x = random(1200.00000);
      chunk.avelocity_y = random(1200.00000);
      chunk.avelocity_z = random(1200.00000);
      chunk.scale = 0.45000;
      chunk.ltime = time;
      AdvanceThinkTime(chunk,random(2.00000));
      setorigin ( chunk, org);

   }
};


void  (vector space,float scalemod)CreateModelChunks =  {
local entity chunk;
local float final = 0.00000;
   chunk = spawn_temp ( );
   space_x = (space_x * random());
   space_y = (space_y * random());
   space_z = (space_z * random());
   setorigin ( chunk, (self.absmin + space));
   final = random();
   if ( ((((self.thingtype == THINGTYPE_GLASS) || (self.thingtype == THINGTYPE_REDGLASS)) || (self.thingtype == THINGTYPE_CLEARGLASS)) || (self.thingtype == THINGTYPE_WEBS)) ) {

      if ( (final < 0.20000) ) {

         setmodel ( chunk, "models/shard1.mdl");
      } else {

         if ( (final < 0.40000) ) {

            setmodel ( chunk, "models/shard2.mdl");
         } else {

            if ( (final < 0.60000) ) {

               setmodel ( chunk, "models/shard3.mdl");
            } else {

               if ( (final < 0.80000) ) {

                  setmodel ( chunk, "models/shard4.mdl");
               } else {

                  setmodel ( chunk, "models/shard5.mdl");

               }

            }

         }

      }
      if ( (self.thingtype == THINGTYPE_CLEARGLASS) ) {

         chunk.skin = 1.00000;
         chunk.drawflags |= DRF_TRANSLUCENT;
      } else {

         if ( (self.thingtype == THINGTYPE_REDGLASS) ) {

            chunk.skin = 2.00000;
         } else {

            if ( (self.thingtype == THINGTYPE_WEBS) ) {

               chunk.skin = 3.00000;

            }

         }

      }
   } else {

      if ( (self.thingtype == THINGTYPE_WOOD) ) {

         if ( (final < 0.25000) ) {

            setmodel ( chunk, "models/splnter1.mdl");
         } else {

            if ( (final < 0.50000) ) {

               setmodel ( chunk, "models/splnter2.mdl");
            } else {

               if ( (final < 0.75000) ) {

                  setmodel ( chunk, "models/splnter3.mdl");
               } else {

                  setmodel ( chunk, "models/splnter4.mdl");

               }

            }

         }
      } else {

         if ( (self.thingtype == THINGTYPE_METAL) ) {

            if ( (final < 0.25000) ) {

               setmodel ( chunk, "models/metlchk1.mdl");
            } else {

               if ( (final < 0.50000) ) {

                  setmodel ( chunk, "models/metlchk2.mdl");
               } else {

                  if ( (final < 0.75000) ) {

                     setmodel ( chunk, "models/metlchk3.mdl");
                  } else {

                     setmodel ( chunk, "models/metlchk4.mdl");

                  }

               }

            }
         } else {

            if ( (self.thingtype == THINGTYPE_FLESH) ) {

               if ( (self.model == "models/spider.mdl") ) {

                  if ( (final < 0.33000) ) {

                     setmodel ( chunk, "models/sflesh1.mdl");
                  } else {

                     if ( (final < 0.66000) ) {

                        setmodel ( chunk, "models/sflesh2.mdl");
                     } else {

                        setmodel ( chunk, "models/sflesh3.mdl");

                     }

                  }
               } else {

                  if ( (final < 0.33000) ) {

                     setmodel ( chunk, "models/flesh1.mdl");
                  } else {

                     if ( (final < 0.66000) ) {

                        setmodel ( chunk, "models/flesh2.mdl");
                     } else {

                        setmodel ( chunk, "models/flesh3.mdl");

                     }

                  }

               }
               if ( (self.classname == "hive") ) {

                  chunk.skin = 1.00000;

               }
            } else {

               if ( (self.thingtype == THINGTYPE_BROWNSTONE) ) {

                  if ( (final < 0.25000) ) {

                     setmodel ( chunk, "models/schunk1.mdl");
                  } else {

                     if ( (final < 0.50000) ) {

                        setmodel ( chunk, "models/schunk2.mdl");
                     } else {

                        if ( (final < 0.75000) ) {

                           setmodel ( chunk, "models/schunk3.mdl");
                        } else {

                           setmodel ( chunk, "models/schunk4.mdl");

                        }

                     }

                  }
                  chunk.skin = 1.00000;
               } else {

                  if ( (self.thingtype == THINGTYPE_CLAY) ) {

                     if ( (final < 0.25000) ) {

                        setmodel ( chunk, "models/clshard1.mdl");
                     } else {

                        if ( (final < 0.50000) ) {

                           setmodel ( chunk, "models/clshard2.mdl");
                        } else {

                           if ( (final < 0.75000) ) {

                              setmodel ( chunk, "models/clshard3.mdl");
                           } else {

                              setmodel ( chunk, "models/clshard4.mdl");

                           }

                        }

                     }
                  } else {

                     if ( (self.thingtype == THINGTYPE_LEAVES) ) {

                        if ( (final < 0.33000) ) {

                           setmodel ( chunk, "models/leafchk1.mdl");
                        } else {

                           if ( (final < 0.66000) ) {

                              setmodel ( chunk, "models/leafchk2.mdl");
                           } else {

                              setmodel ( chunk, "models/leafchk3.mdl");

                           }

                        }
                     } else {

                        if ( (self.thingtype == THINGTYPE_HAY) ) {

                           if ( (final < 0.33000) ) {

                              setmodel ( chunk, "models/hay1.mdl");
                           } else {

                              if ( (final < 0.66000) ) {

                                 setmodel ( chunk, "models/hay2.mdl");
                              } else {

                                 setmodel ( chunk, "models/hay3.mdl");

                              }

                           }
                        } else {

                           if ( (self.thingtype == THINGTYPE_CLOTH) ) {

                              if ( (final < 0.33000) ) {

                                 setmodel ( chunk, "models/clthchk1.mdl");
                              } else {

                                 if ( (final < 0.66000) ) {

                                    setmodel ( chunk, "models/clthchk2.mdl");
                                 } else {

                                    setmodel ( chunk, "models/clthchk3.mdl");

                                 }

                              }
                           } else {

                              if ( (self.thingtype == THINGTYPE_WOOD_LEAF) ) {

                                 if ( (final < 0.14000) ) {

                                    setmodel ( chunk, "models/splnter1.mdl");
                                 } else {

                                    if ( (final < 0.28000) ) {

                                       setmodel ( chunk, "models/leafchk1.mdl");
                                    } else {

                                       if ( (final < 0.42000) ) {

                                          setmodel ( chunk, "models/splnter2.mdl");
                                       } else {

                                          if ( (final < 0.56000) ) {

                                             setmodel ( chunk, "models/leafchk2.mdl");
                                          } else {

                                             if ( (final < 0.70000) ) {

                                                setmodel ( chunk, "models/splnter3.mdl");
                                             } else {

                                                if ( (final < 0.84000) ) {

                                                   setmodel ( chunk, "models/leafchk3.mdl");
                                                } else {

                                                   setmodel ( chunk, "models/splnter4.mdl");

                                                }

                                             }

                                          }

                                       }

                                    }

                                 }
                              } else {

                                 if ( (self.thingtype == THINGTYPE_WOOD_METAL) ) {

                                    if ( (final < 0.12500) ) {

                                       setmodel ( chunk, "models/splnter1.mdl");
                                    } else {

                                       if ( (final < 0.25000) ) {

                                          setmodel ( chunk, "models/metlchk1.mdl");
                                       } else {

                                          if ( (final < 0.37500) ) {

                                             setmodel ( chunk, "models/splnter2.mdl");
                                          } else {

                                             if ( (final < 0.50000) ) {

                                                setmodel ( chunk, "models/metlchk2.mdl");
                                             } else {

                                                if ( (final < 0.62500) ) {

                                                   setmodel ( chunk, "models/splnter3.mdl");
                                                } else {

                                                   if ( (final < 0.75000) ) {

                                                      setmodel ( chunk, "models/metlchk3.mdl");
                                                   } else {

                                                      if ( (final < 0.87500) ) {

                                                         setmodel ( chunk, "models/splnter4.mdl");
                                                      } else {

                                                         setmodel ( chunk, "models/metlchk4.mdl");

                                                      }

                                                   }

                                                }

                                             }

                                          }

                                       }

                                    }
                                 } else {

                                    if ( (self.thingtype == THINGTYPE_WOOD_STONE) ) {

                                       if ( (final < 0.12500) ) {

                                          setmodel ( chunk, "models/splnter1.mdl");
                                       } else {

                                          if ( (final < 0.25000) ) {

                                             setmodel ( chunk, "models/schunk1.mdl");
                                          } else {

                                             if ( (final < 0.37500) ) {

                                                setmodel ( chunk, "models/splnter2.mdl");
                                             } else {

                                                if ( (final < 0.50000) ) {

                                                   setmodel ( chunk, "models/schunk2.mdl");
                                                } else {

                                                   if ( (final < 0.62500) ) {

                                                      setmodel ( chunk, "models/splnter3.mdl");
                                                   } else {

                                                      if ( (final < 0.75000) ) {

                                                         setmodel ( chunk, "models/schunk3.mdl");
                                                      } else {

                                                         if ( (final < 0.87500) ) {

                                                            setmodel ( chunk, "models/splnter4.mdl");
                                                         } else {

                                                            setmodel ( chunk, "models/schunk4.mdl");

                                                         }

                                                      }

                                                   }

                                                }

                                             }

                                          }

                                       }
                                    } else {

                                       if ( (self.thingtype == THINGTYPE_METAL_STONE) ) {

                                          if ( (final < 0.12500) ) {

                                             setmodel ( chunk, "models/metlchk1.mdl");
                                          } else {

                                             if ( (final < 0.25000) ) {

                                                setmodel ( chunk, "models/schunk1.mdl");
                                             } else {

                                                if ( (final < 0.37500) ) {

                                                   setmodel ( chunk, "models/metlchk2.mdl");
                                                } else {

                                                   if ( (final < 0.50000) ) {

                                                      setmodel ( chunk, "models/schunk2.mdl");
                                                   } else {

                                                      if ( (final < 0.62500) ) {

                                                         setmodel ( chunk, "models/metlchk3.mdl");
                                                      } else {

                                                         if ( (final < 0.75000) ) {

                                                            setmodel ( chunk, "models/schunk3.mdl");
                                                         } else {

                                                            if ( (final < 0.87500) ) {

                                                               setmodel ( chunk, "models/metlchk4.mdl");
                                                            } else {

                                                               setmodel ( chunk, "models/schunk4.mdl");

                                                            }

                                                         }

                                                      }

                                                   }

                                                }

                                             }

                                          }
                                       } else {

                                          if ( (self.thingtype == THINGTYPE_METAL_CLOTH) ) {

                                             if ( (final < 0.14000) ) {

                                                setmodel ( chunk, "models/metlchk1.mdl");
                                             } else {

                                                if ( (final < 0.28000) ) {

                                                   setmodel ( chunk, "models/clthchk1.mdl");
                                                } else {

                                                   if ( (final < 0.42000) ) {

                                                      setmodel ( chunk, "models/metlchk2.mdl");
                                                   } else {

                                                      if ( (final < 0.56000) ) {

                                                         setmodel ( chunk, "models/clthchk2.mdl");
                                                      } else {

                                                         if ( (final < 0.70000) ) {

                                                            setmodel ( chunk, "models/metlchk3.mdl");
                                                         } else {

                                                            if ( (final < 0.84000) ) {

                                                               setmodel ( chunk, "models/clthchk3.mdl");
                                                            } else {

                                                               setmodel ( chunk, "models/metlchk4.mdl");

                                                            }

                                                         }

                                                      }

                                                   }

                                                }

                                             }
                                          } else {

                                             if ( (self.thingtype == THINGTYPE_ICE) ) {

                                                setmodel ( chunk, "models/shard.mdl");
                                                chunk.skin = 0.00000;
                                                chunk.frame = random(2.00000);
                                                chunk.drawflags |= (DRF_TRANSLUCENT | MLS_ABSLIGHT);
                                                chunk.abslight = 0.50000;
                                             } else {

                                                if ( (final < 0.25000) ) {

                                                   setmodel ( chunk, "models/schunk1.mdl");
                                                } else {

                                                   if ( (final < 0.50000) ) {

                                                      setmodel ( chunk, "models/schunk2.mdl");
                                                   } else {

                                                      if ( (final < 0.75000) ) {

                                                         setmodel ( chunk, "models/schunk3.mdl");
                                                      } else {

                                                         setmodel ( chunk, "models/schunk4.mdl");

                                                      }

                                                   }

                                                }
                                                chunk.skin = 0.00000;

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
   setsize ( chunk, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   chunk.movetype = MOVETYPE_BOUNCE;
   chunk.solid = SOLID_NOT;
   chunk.velocity = ChunkVelocity ( );
   chunk.think = ChunkRemove;
   chunk.avelocity_x = random(1200.00000);
   chunk.avelocity_y = random(1200.00000);
   chunk.avelocity_z = random(1200.00000);
   if ( (self.classname == "monster_eidolon") ) {

      chunk.scale = random(2.10000,2.50000);
   } else {

      chunk.scale = random(scalemod,(scalemod + 0.10000));

   }
   chunk.ltime = time;
   AdvanceThinkTime(chunk,random(2.00000));
};

void  ()DropBackpack;

void  (vector location)TinySplat =  {
local vector holdplane = '0.00000 0.00000 0.00000';
local entity splat;
   traceline ( (((location + (v_up * 8.00000)) + (v_right * 8.00000)) + (v_forward * 8.00000)), (((location - (v_up * 32.00000)) + (v_right * 8.00000)) + (v_forward * 8.00000)), TRUE, self);
   holdplane = trace_plane_normal;
   if ( (trace_fraction == 1.00000) ) {

      return ;

   }
   traceline ( (((location + (v_up * 8.00000)) - (v_right * 8.00000)) + (v_forward * 8.00000)), (((location - (v_up * 32.00000)) - (v_right * 8.00000)) + (v_forward * 8.00000)), TRUE, self);
   if ( ((holdplane != trace_plane_normal) || (trace_fraction == 1.00000)) ) {

      return ;

   }
   traceline ( (((location + (v_up * 8.00000)) + (v_right * 8.00000)) - (v_forward * 8.00000)), (((location - (v_up * 32.00000)) + (v_right * 8.00000)) - (v_forward * 8.00000)), TRUE, self);
   if ( ((holdplane != trace_plane_normal) || (trace_fraction == 1.00000)) ) {

      return ;

   }
   traceline ( (((location + (v_up * 8.00000)) - (v_right * 8.00000)) - (v_forward * 8.00000)), (((location - (v_up * 32.00000)) - (v_right * 8.00000)) - (v_forward * 8.00000)), TRUE, self);
   if ( ((holdplane != trace_plane_normal) || (trace_fraction == 1.00000)) ) {

      return ;

   }
   traceline ( (location + (v_up * 8.00000)), (location - (v_up * 32.00000)), TRUE, self);
   splat = spawn ( );
   splat.owner = self;
   splat.classname = "bloodsplat";
   splat.movetype = MOVETYPE_NONE;
   splat.solid = SOLID_NOT;
   trace_plane_normal_x = (trace_plane_normal_x * -1.00000);
   trace_plane_normal_y = (trace_plane_normal_y * -1.00000);
   splat.angles = vectoangles ( trace_plane_normal);
   setmodel ( splat, "models/bldspot4.spr");
   setsize ( splat, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( splat, (trace_endpos + '0.00000 0.00000 2.00000'));
};


void  ()BloodSplat =  {
local entity splat;
local vector holdangles = '0.00000 0.00000 0.00000';
   if ( (random() < 0.50000) ) {

      holdangles_x = random(-30.00000,-20.00000);
      holdangles_y = random(30.00000,20.00000);
   } else {

      holdangles_x = random(30.00000,20.00000);
      holdangles_y = random(-30.00000,-20.00000);

   }
   holdangles_z = 16.00000;
   TinySplat ( (self.origin + holdangles));
   if ( (random() < 0.50000) ) {

      holdangles_x = random(-30.00000,-10.00000);
      holdangles_y = random(30.00000,10.00000);
   } else {

      holdangles_x = random(30.00000,10.00000);
      holdangles_y = random(-30.00000,-10.00000);

   }
   holdangles_z = 16.00000;
   TinySplat ( (self.origin + holdangles));
   makevectors ( self.angles);
   traceline ( (self.origin + (v_up * 8.00000)), (self.origin - (v_up * 32.00000)), TRUE, self);
   if ( (trace_fraction == 1.00000) ) {

      dprint ( "\n no floor ");
      return ;

   }
   splat = spawn ( );
   splat.owner = self;
   splat.classname = "bloodsplat";
   splat.movetype = MOVETYPE_NONE;
   splat.solid = SOLID_NOT;
   trace_plane_normal_x = (trace_plane_normal_x * -1.00000);
   trace_plane_normal_y = (trace_plane_normal_y * -1.00000);
   splat.angles = vectoangles ( trace_plane_normal);
   setmodel ( splat, "models/bldspot2.spr");
   setsize ( splat, '0.00000 0.00000 0.00000', '0.00000 0.00000 0.00000');
   setorigin ( splat, (trace_endpos + '0.00000 0.00000 2.00000'));
};


void  ()chunk_reset =  {
   chunk_cnt = FALSE;
   remove ( self);
};


void  ()make_chunk_reset =  {
   newmis = spawn ( );
   newmis.think = chunk_reset;
   AdvanceThinkTime(newmis,1.50000);
};


void  ()chunk_death =  {
local vector space = '0.00000 0.00000 0.00000';
local float spacecube = 0.00000;
local float model_cnt = 0.00000;
local float scalemod = 0.00000;
local string deathsound;
   DropBackpack ( );
   space = (self.absmax - self.absmin);
   spacecube = ((space_x * space_y) * space_z);
   model_cnt = (spacecube / 8192.00000);
   if ( (((self.thingtype == THINGTYPE_GLASS) || (self.thingtype == THINGTYPE_CLEARGLASS)) || (self.thingtype == THINGTYPE_REDGLASS)) ) {

      deathsound = "fx/glassbrk.wav";
   } else {

      if ( ((self.thingtype == THINGTYPE_WOOD) || (self.thingtype == THINGTYPE_WOOD_METAL)) ) {

         if ( (self.classname == "bolt") ) {

            deathsound = "assassin/arrowbrk.wav";
         } else {

            deathsound = "fx/woodbrk.wav";

         }
      } else {

         if ( ((((self.thingtype == THINGTYPE_GREYSTONE) || (self.thingtype == THINGTYPE_BROWNSTONE)) || (self.thingtype == THINGTYPE_WOOD_STONE)) || (self.thingtype == THINGTYPE_METAL_STONE)) ) {

            deathsound = "fx/wallbrk.wav";
         } else {

            if ( ((self.thingtype == THINGTYPE_METAL) || (self.thingtype == THINGTYPE_METAL_CLOTH)) ) {

               deathsound = "fx/metalbrk.wav";
            } else {

               if ( ((self.thingtype == THINGTYPE_CLOTH) || (self.thingtype == THINGTYPE_REDGLASS)) ) {

                  deathsound = "fx/clothbrk.wav";
               } else {

                  if ( (self.thingtype == THINGTYPE_FLESH) ) {

                     if ( (self.health < -80.00000) ) {

                        deathsound = "player/megagib.wav";
                     } else {

                        deathsound = "player/gib1.wav";

                     }
                     sound ( self, CHAN_AUTO, deathsound, 1.00000, ATTN_NORM);
                     self.level = -666.00000;
                  } else {

                     if ( (self.thingtype == THINGTYPE_CLAY) ) {

                        deathsound = "fx/claybrk.wav";
                     } else {

                        if ( ((self.thingtype == THINGTYPE_LEAVES) || (self.thingtype == THINGTYPE_WOOD_LEAF)) ) {

                           deathsound = "fx/leafbrk.wav";
                        } else {

                           if ( (self.thingtype == THINGTYPE_ICE) ) {

                              deathsound = "misc/icestatx.wav";
                           } else {

                              deathsound = "fx/wallbrk.wav";

                           }

                        }

                     }

                  }

               }

            }

         }

      }

   }
   if ( (self.level != -666.00000) ) {

      sound ( self, CHAN_VOICE, deathsound, 1.00000, ATTN_NORM);

   }
   if ( (spacecube < 5000.00000) ) {

      scalemod = 0.20000;
      model_cnt = (model_cnt * 3.00000);
   } else {

      if ( (spacecube < 50000.00000) ) {

         scalemod = 0.45000;
         model_cnt = (model_cnt * 3.00000);
      } else {

         if ( (spacecube < 500000.00000) ) {

            scalemod = 0.50000;
         } else {

            if ( (spacecube < 1000000.00000) ) {

               scalemod = 0.75000;
            } else {

               scalemod = 1.00000;

            }

         }

      }

   }
   if ( (model_cnt > CHUNK_MAX) ) {

      model_cnt = CHUNK_MAX;

   }
   while ( (model_cnt > 0.00000) ) {

      if ( (chunk_cnt < (CHUNK_MAX * 2.00000)) ) {

         CreateModelChunks ( space, scalemod);
         chunk_cnt += 1.00000;

      }
      model_cnt -= 1.00000;

   }
   make_chunk_reset ( );
   if ( (self.classname == "monster_eidolon") ) {

      return ;

   }
   SUB_UseTargets ( );
   if ( ((self.headmodel != "") && (self.classname != "head")) ) {

      ThrowSolidHead ( 50.00000);
   } else {

      remove ( self);

   }
};

