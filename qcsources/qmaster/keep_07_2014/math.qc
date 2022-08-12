
float (float num) square = {

   local float val;

   val = (num * num);
   return (val);

};
float (float num, float power) raise_power = {

   local float product;

   product = num;
   do {

      product = (product * num);
      power = (power - TRUE);

   } while (power > TRUE);
   return (product);

};
float (float num) sqrt = {

   local float dividend;
   local float average;

   average = FL_SWIM;
   do {

      dividend = (num / average);
      average = ((dividend + average)/2);

   } while (dividend != average);
   return (dividend);

};
float (float num) factorial = {

   local float product;

   if (num > 0) {

      product = num * factorial( (num - 1) );

   } else {

      product = TRUE;

   } 
   return (product);

};