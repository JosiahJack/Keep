// CSQC GUI Stuff
// draws the selection box with text inside it (only draws one box style for now)
void (vector boxpos, vector boxsize, string boxtext, vector boxrgb, float boxalpha) spawnbox =
{
   drawpic(boxpos, "progs/csqc/csqcguiback.tga", boxsize, boxrgb, boxalpha);
   drawstring(boxpos + '10 12 0', boxtext, '8 8 0', boxrgb, 1);
};

void () CSQCGUI_ClearMenu =
{
   local entity button;
   
   // Remove all buttons
   button = find(world, classname, "gui_button");
   while (button)
   {
      remove(button);
      button = find(button, classname, "gui_button");
   }

   global_bt_no = 0;      // clear globally assigned button #s
   
   menu_selected = 0;
   in_menu = 0;
   menu_impulse = 0;
   
   // reset mouse pos
   if (!mouse_branch) {
      mousepos_x = vid_realwidth*.5;
      mousepos_y = vid_realheight*.5;
   }
   else
      mouse_branch = FALSE;
};

void () CSQCGUI_Render =
{
   local float args, boxno, i;
   entity button;

   if (!in_menu)
      return;

   cprint("\n");         // clear the currently printed menu
   
   CSQC_GUI_MenuBackground ();
   
   button = find(world, classname, "gui_button");
   while (button)
   {
      boxno = button.bt_no;
      if (MouseInBox() == boxno) {
         CSQC_GUI_MouseOverButton( button.bt_img, button.origin, button.size, button.bt_text );
         if (menu_selected) {
            CSQC_GUI_ButtonClick( button );
         }
      }
      else {
         if (button.bt_flags & MENUFLAG_DISABLED)
            spawnbox(button.origin, button.size, button.bt_text, '.4 .4 .4', .2);
         else
            spawnbox(button.origin, button.size, button.bt_text, '1 1 1', .2);
      }
         
      button = find(button, classname, "gui_button");
   }

   CSQC_GUI_MenuForeground ();
   
   if (!(global_menu_flags & MFG_NOCURSOR))
      drawstring(mousepos, "X", '8 8 0', '1 0.91 0.51', .6);      // Draw the "cursor"
};

void (string menu_name, float menu_flags) InitMenu =
{
   localcmd("csqcgui_menu ", menu_name, " ", ftos(menu_flags), "\n");
   global_menu_flags = menu_flags;
};

void (string button_text, string button_cmd, vector button_spawnpos, string button_image, vector button_size, float button_flags) CreateButton =
{
   local entity newbutton;
   
   global_bt_no++;
   
   newbutton = spawn();
   newbutton.classname = "gui_button";
   newbutton.origin = button_spawnpos;
   newbutton.size = button_size;
   newbutton.bt_img = button_image;
   newbutton.bt_text = button_text;
   newbutton.bt_cmd = button_cmd;
   newbutton.bt_flags = button_flags;
   newbutton.bt_no   = global_bt_no;
};

// Which box the mouse is hovering over currently
float () MouseInBox =
{
   float in_box, boxval;
   entity button;
   
   button = find(world, classname, "gui_button");
   while (button)
   {
      if (mousepos_y >= button.origin_y && mousepos_y <= button.origin_y+button.size_y) 
         if (mousepos_x >= button.origin_x && mousepos_x <= button.origin_x+button.size_x) {
            if (!button.bt_flags & MENUFLAG_DISABLED)
               boxval = button.bt_no;
            break;
         }
      button = find(button, classname, "gui_button");
   }
   
   return boxval;
};