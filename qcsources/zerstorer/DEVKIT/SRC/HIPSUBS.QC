//=========================
//
// Hipnotic Sub-routines
//
//=========================


//=========================
//
// SUB_NormalizeAngles
//
//=========================

vector ( vector ang ) SUB_NormalizeAngles =
   {
   while( ang_x > 360 )
      {
      ang_x = ang_x - 360;
      }
   while( ang_x < 0 )
      {
      ang_x = ang_x + 360;
      }

   while( ang_y > 360 )
      {
      ang_y = ang_y - 360;
      }
   while( ang_y < 0 )
      {
      ang_y = ang_y + 360;
      }

   while( ang_z > 360 )
      {
      ang_z = ang_z - 360;
      }
   while( ang_z < 0 )
      {
      ang_z = ang_z + 360;
      }

   return ang;
   };
