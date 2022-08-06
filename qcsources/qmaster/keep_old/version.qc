
void () version_touch = {

   if ( (self.nextthink > time) ) {

      return ;

   }
   if ( (self.classname != "player") ) {

      return ;

   }
   centerprint (other,self.message);

};

void () trigger_version = {

   self.touch = version_touch;
   InitTrigger ();

};
