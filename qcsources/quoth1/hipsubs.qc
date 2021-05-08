vector(vector ang) SUB_NormalizeAngles = 
{
	while (ang_x > 360)
	{
		ang_x = ang_x - 360;
	}
	while (ang_x < MSG_BROADCAST)
	{
		ang_x = ang_x + 360;
	}
	while (ang_y > 360)
	{
		ang_y = ang_y - 360;
	}
	while (ang_y < MSG_BROADCAST)
	{
		ang_y = ang_y + 360;
	}
	while (ang_z > 360)
	{
		ang_z = ang_z - 360;
	}
	while (ang_z < MSG_BROADCAST)
	{
		ang_z = ang_z + 360;
	}
	return ang_x;
};

