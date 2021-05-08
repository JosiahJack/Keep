float(float inhibitspawnflags, float first) parsenewmapentity =
{
	local string field, value;
	local entity nent;
	local string edata = "";

	while (1)
	{
		field = getentitytoken();
		if not (field)
			break;

		if (field == "}")
		{
			if (first)
				nent = world;	//yup, worldspawn, innit.
			else
				nent = spawn();
			parseentitydata(nent, strcat("{\n", edata, "}\n"));

			if (nent.spawnflags & inhibitspawnflags)
			{
				/*do nothing, just make sure the following blocks can't trigger*/
				//print("inhibit ", nent.classname, "\n");
			}
			else if (isfunction(nent.classname))
			{
				self = nent;
				callfunction(nent.classname);
				return TRUE;
			}
			else
			{
//				print("ignoring ", nent.classname, "\n");
			}

			if (nent)
				remove(nent);
			return TRUE;
		}

		value = getentitytoken();
		if not (value)
			break;

		edata = strcat(edata, field, " \"", value, "\"\n");
	}

	return FALSE;
};

void() SpawnEntities =
{
	local string tok;
	local float inhibitspawnflags;
	float isfirst = TRUE;

	//reset the parser
	getentitytoken(__NULL__);

	/*if this wasn't purecsqc, you would want to use serverinfo instead for these, so that any teleporters match properly*/
	if (cvar("deathmatch"))
		inhibitspawnflags = 2048/*SPAWNFLAG_NOT_DEATHMATCH*/;
	else
	{
		//fte likes to default the string cvar to empty instead of 1
		tok = cvar_string("skill");
		if (tok == "")
			tok = "1";
		inhibitspawnflags = stof(tok);
		if (inhibitspawnflags < 0.5)
			inhibitspawnflags = 256/*SPAWNFLAG_NOT_EASY*/;
		else if (inhibitspawnflags > 1.5)
			inhibitspawnflags = 1024/*SPAWNFLAG_NOT_HARD*/;
		else
			inhibitspawnflags = 512/*SPAWNFLAG_NOT_MEDIUM*/;
	}

	while (1)
	{
		tok = getentitytoken();

		if (tok == "")
			break;

		if (tok != "{")
		{
			print("bad entity data\n");
			return;
		}
		
		if (!parsenewmapentity(inhibitspawnflags, isfirst))
		{
			print("bad entity data\n");
			return;
		}
		isfirst = FALSE;
	}
};
