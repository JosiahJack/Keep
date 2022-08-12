float START_OFF = 1;                
void() Light_setup;                

void() light =                       
{
 Light_setup();                         
}; 


                       
void() Light_setup =   
{
};

void() LightStyles_setup =
{
 // Setup light animation tables. 'a' is total darkness, 'z' is maxbright.

lightstyle(0,"m");                                   // Style 0: Normal
lightstyle(1,"mmnmmommommnonmmonqnmmo");             // Style 1: Flicker
                                                     // Style 2: Slow Strong
                                                     //          Pulse
lightstyle(2,"abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
lightstyle(3,"mmmmmaaaaammmmmaaaaaabcdefgabcdefg");  // Style 3: Candle
lightstyle(4,"mamamamamama");                        // Style 4: Fast Strobe
lightstyle(5,"jklmnopqrstuvwxyzyxwvutsrqponmlkj");    // Style 5: Gentle Pulse
lightstyle(6,"nmonqnmomnmomomno");                   // Style 6: Flicker 2
lightstyle(7,"mmmaaaabcdefgmmmmaaaammmaamm");        // Style 7: Candle 2
                                                     // Style 8: Candle 3
lightstyle(8,"mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa"); 
lightstyle(9,"aaaaaaaazzzzzzzz");                    // Style 9: Slow Strobe
lightstyle(10,"mmamammmmammamamaaamammma");          // Style 10: Fluro
                                                     // Style 11: Slow Pulse
                                                     //           (no black)
lightstyle(11,"abcdefghijklmnopqrrqponmlkjihgfedcba"); 
};