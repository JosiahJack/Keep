vector (vector ang) SUB_NormalizeAngles = {

   while ( (ang_x > 360.000) ) {

      ang_x = (ang_x - 360.000);

   }
   while ( (ang_x < FALSE) ) {

      ang_x = (ang_x + 360.000);

   }
   while ( (ang_y > 360.000) ) {

      ang_y = (ang_y - 360.000);

   }
   while ( (ang_y < FALSE) ) {

      ang_y = (ang_y + 360.000);

   }
   while ( (ang_z > 360.000) ) {

      ang_z = (ang_z - 360.000);

   }
   while ( (ang_z < FALSE) ) {

      ang_z = (ang_z + 360.000);

   }
   return ( ang );

};