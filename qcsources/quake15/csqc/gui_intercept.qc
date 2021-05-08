// Handle GUI events in menu-specific manners

// A button is clicked..
void ( entity t_button ) CSQC_GUI_ButtonClick =
{
   switch(in_menu) {
      default:
         if (!menu_impulse) {         // if the menu didn't already send the reply to the server regarding the menu..
            menu_impulse = TRUE;
            if (t_button.bt_flags & MENUFLAG_BRANCH) 
               mouse_branch = TRUE;
            if (t_button.bt_cmd == "default")
               localcmd("impulse ", ftos(t_button.bt_no), "\n");
            else
               localcmd(t_button.bt_cmd, "\n");
         }
   }
};

// When a mouse hovers over a button, apply this effect..
void (string button_image, vector button_position, vector button_size, string button_text) CSQC_GUI_MouseOverButton =
{
   local float selected_button, stl;
   selected_button = MouseInBox();
   
   switch(in_menu) {
      default:
         drawpic(button_position, button_image, button_size, '1 1 1', .4);
         drawstring(button_position + '10 12 0', button_text, '8 8 0', '1 1 1', 1);
         break;
   }
};

// Called before the menu buttons are rendered
void () CSQC_GUI_MenuBackground =
{
   switch(in_menu) {
      default:         // No default background image
         break;
   }
};

// Called after the menu buttons are rendered
void () CSQC_GUI_MenuForeground =
{
   switch(in_menu) {
      default:         // No default foreground image
         break;
   }
};