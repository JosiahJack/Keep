vector angle_alive;

void View_Update (void)
{
	vieworg = pmove_org;
	vieworg += '0 0 30';

	makevectors(input_angles);

	R_SetView(VF_ORIGIN, vieworg);
	R_SetView(VF_ANGLES, input_angles);
}
