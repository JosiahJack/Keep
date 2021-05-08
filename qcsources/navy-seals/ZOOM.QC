void () MoveCamera =
{
    local vector newpos;

    makevectors(self.owner.v_angle);
    newpos = (self.owner.origin + (v_forward * 200) );
    setorigin(self,newpos);

  	msg_entity = self.owner;                         // target of message
	WriteByte (MSG_ONE, 5);
	WriteEntity (MSG_ONE, self);           // view port

};

void () zoom = 
{
    local entity camera;

    camera = spawn ();

    camera.owner = self;
    camera.movetype = MOVETYPE_FLY;
    camera.solid = SOLID_NOT;

    camera.angles = camera.owner.angles;

    setmodel (camera , "progs/eyes.mdl");
    setsize (camera, '0 0 0', '0 0 0');

    makevectors(self.v_angle);
    camera.velocity = v_forward * 200;
    setorigin(camera,camera.owner.origin);

  	msg_entity = camera.owner;                         // target of message
	WriteByte (MSG_ONE, 5);
	WriteEntity (MSG_ONE, camera);           // view port

//    camera.nextthink = 0.1;
//    camera.think = MoveCamera; 

     
};

