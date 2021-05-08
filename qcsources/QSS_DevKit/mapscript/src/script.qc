//#include "qsextensions.qc"

.string killtarget;

strbuf statements;

float(string subname) runscripts;

void(entity e) calluse =
{
	entity oself = self;
	self = e;
	e.use();
	self = oself;
};

//finds one and only one, and only if it has no subject. etc.
int (string subname) findonescript =
{
	float n = buf_getsize(statements);
	float st = 0;
	float len;
	float ret;

	for (st = 0; st < n; st += len)
	{
		tokenize(bufstr_get(statements, st));
		len = stof(argv(0));
		string func = argv(1);
		string subject = argv(2);
		st++;
		
		if (func == subname)
		{
			//if the script has a target, run one script per. otherwise run a single script
			if (subject != "")
				return 0;
			if (ret)
				return 0;
			ret = st;
		}
	}
	return ret;
};

class script
{
	float st;
	float stack[4];
	float stackdepth;
	entity enemy;
	entity owner;
	virtual void() think =
	{
		string s;
		float lhs, rhs;
		float fld;
		float doloop;
		for (;;)
		{
			//we don't need any runaway loop check - the engine does that for us anyway, and infinite loops with sleeps can be useful.
			string cmdstring = bufstr_get(statements, st);
			if (!cmdstring)
			{
				//reached end of function / block.
				if (stackdepth > 0)
				{	//return to caller.
					stackdepth -= 1;
					st = stack[stackdepth];
					continue;
				}
				break;	//no caller.
			}
			
//			print(sprintf("Command string is %s\n", cmdstring));
			tokenize(cmdstring);
			switch(argv(0))
			{
			case "while":	//both of these are basically a jump-if-not.
			case "if":
				fld = findentityfield(argv(1));
				if (!fld)
					print("Field \"", argv(1), "\" was not found\n");
				else
				{
					doloop = FALSE;
					if (entityfieldtype(fld) == EV_FLOAT)
					{
						lhs = stof(getentityfieldstring(fld, owner));
						rhs = stof(argv(3));
						switch(argv(2))
						{
						case "<": doloop = lhs < rhs; break;
						case "<=": doloop = lhs <= rhs; break;
						case ">": doloop = lhs > rhs; break;
						case ">=": doloop = lhs >= rhs; break;
						case "==": doloop = lhs == rhs; break;
						default:
						case "!=": doloop = lhs != rhs; break;
						}
					}
					else
					{
						switch(argv(2))
						{
						case "==": doloop = getentityfieldstring(fld, owner) == argv(3); break;
						default:
						case "!=": doloop = getentityfieldstring(fld, owner) != argv(3); break;
						}
					}
					if (!doloop)
					{
						st += stof(argv(4));
						continue;
					}
				}
				break;
			case "_jmp":
				st += stof(argv(1));
				continue;
			case "call":
				st++;
				if (stackdepth == 4)
				{
					print("exceeded stack depth\n");
					continue;
				}
				stack[stackdepth] = st;
				stackdepth+=1;
				s = argv(1);
				st = findonescript(s);
				if (!st)
				{
					stackdepth -= 1;
					st = stack[stackdepth];
					print("Function \"", s, "\" not found\n");
				}
				continue;
			case "moveto":
				SUB_CalcMoveEnt(owner, stov(argv(1)), stof(argv(2)), 0);
				break;
			case "set":
				fld = findentityfield(argv(1));
				if (fld)
					putentityfieldstring(fld, owner, argv(2));
				else
					print("Field \"", argv(1), "\" was not found\n");
				break;
			case "setfind":
				fld = findentityfield(argv(1));
				if (fld)
					putentityfieldstring(fld, owner, etos(find(world, ::targetname, argv(2))));
				else
					print("Field \"", argv(1), "\" was not found\n");
				break;
			case "inc":
				fld = findentityfield(argv(1));
				if (fld)
				{
					lhs = stof(getentityfieldstring(fld, owner));
					putentityfieldstring(fld, owner, ftos(lhs + stof(argv(2))));
				}
				else
					print("Field \"", argv(1), "\" was not found\n");
				break;
			case "dec":
				fld = findentityfield(argv(1));
				if (fld)
				{
					lhs = stof(getentityfieldstring(fld, owner));
					putentityfieldstring(fld, owner, ftos(lhs - stof(argv(2))));
				}
				else
					print("Field \"", argv(1), "\" was not found\n");
				break;
			case "sleep":
				nextthink = time + stof(argv(1));
				st++;
				return;
			case "bprint":
				bprint(strcat(argv(1), "\n"));
				break;
			case "cprint":
				centerprint(enemy, argv(1));
				break;
			case "dprint":
				dprint(argv(1), "\n");
				break;
			case "print":
				print(argv(1), "\n");
				break;
			case "run":
				activator = enemy;
				runscripts(argv(1));
				break;
			case "use":
				killtarget = 0;
				target = argv(1);
				activator = enemy;
				if (target != "")
					SUB_UseTargets();
				else if (owner.use)
					calluse(owner);
				break;
			case "kill":
				killtarget = argv(1);
				target = 0;
				activator = enemy;
				SUB_UseTargets();
				break;
			case "precache_sound":
				precache_sound(argv(1));
				break;
			case "sound":
				sound(owner, CHAN_AUTO, argv(1), 1, ATTN_NORM);
				break;
			case "precache_effect":
				particleeffectnum(argv(1));
				break;
			case "effect":
				if (owner.solid == SOLID_BSP)
					makevectors(owner.angles);
				else
					makevectors([-1*owner.angles_x, owner.angles_y, owner.angles_z]);
				pointparticles(particleeffectnum(argv(1)), (owner.absmin + owner.absmax) * 0.5, v_forward, 1);
				break;
			default:
				print("Unknown script command: ", cmdstring, "\n");
				break;
			}
			st++;
		}
		remove(self);
	};
	void() script =
	{
		if (!owner)
			owner = self;

		if (!time)
			nextthink = 0.001;
		else
			nextthink = time;
	};
};

float(string subname) runscripts =
{
	float n = buf_getsize(statements);
	float success = FALSE;
	float sub, len;
	
	for (sub = 0; sub < n; sub += len)
	{
		string line = bufstr_get(statements, sub);
		tokenize(line);
		len = stof(argv(0));
		string func = argv(1);
		string tname = argv(2);
		sub++;

		if (func == subname)
		{
//			dprint(sprintf("running %s:%s\n", tname, subname));
			//if the script has a target, run one script per. otherwise run a single script
			if (tname != "")
			{
				entity t;
				for (t = world; (t = find(t, ::targetname, tname)); )
					spawn(script, st: sub, owner: t, enemy: activator);
			}
			else
				spawn(script, st: sub, owner: world, enemy: activator);
			success = TRUE;
		}
	}
	return success;
};

float(float infile) ScriptCompileStatements =
{
	string line;
	
	float t;
	float st = buf_getsize(statements);
	float firststatement = st;
	
	line = fgets(infile);
	tokenize(line);
	if (argv(0) != "{")
		error(sprintf("expected open brace, got \"%s\"\n", line));

	while((line = fgets(infile)))
	{
		float args = tokenize(line);
		if (!args)
			continue;
		if (argv(0) == "}")
			break;

//		line = strtrim(line);
		bufstr_set(statements, st++, line);

//FIXME: rewrite field names to field indexes, so that we don't need to scan for them later.
		switch(argv(0))
		{
		case "while":	//FLD COMPARISON REF
			if (args != 1+3)
				dprint("Script expected two parameters: ", line, "\n");
			t = ScriptCompileStatements(infile);
			bufstr_set(statements, st-1, sprintf("%s %f", bufstr_get(statements, st-1), t+2));	//add an offset to the while statement, so it can jump beyond the while if needed
			st += t;
			bufstr_set(statements, st++, sprintf("_jmp %f", -t));	//and the end of the loop needs to restart the loop
			break;
		case "if":		//FLD COMPARISON REF
			if (args != 1+3)
				dprint("Script expected two parameters: ", line, "\n");
			t = ScriptCompileStatements(infile);
			bufstr_set(statements, st-1, sprintf("%s %f", bufstr_get(statements, st-1), t+1));	//add an offset to the while statement, so it can jump beyond the while if needed
			st += t;
			break;

		case "moveto":	//"x y z" speed
		case "set":	//field value
		case "setfind":	//entfield target
		case "inc":	//field value
		case "dec":	//field value
			if (args != 1+2)
				dprint("Script expected two parameters: ", line, "\n");
			break;
		case "call":	//funcname
		case "run":	//funcname
		case "use":	//target
		case "kill":	//killtarget
		case "sleep":	//delay
		case "bprint":	//message
		case "cprint":	//message
		case "dprint":	//message
		case "print":	//message
		case "precache_sound":	//soundname
		case "sound":			//soundname
		case "precache_effect":	//effectname
		case "effect":			//effectname
			if (args != 1+1) 
				dprint("Script expected one parameter: ", line, "\n");
			break;
		case "{":
			dprint("unexpected start of block\n");
			break;
		default:
			dprint("Script line not known: ", line, "\n");
			break;
		}
	}

	return st - firststatement;
};

void(string inname) ScriptCompile =
{
	float infile = fopen(inname, FILE_READ);
	if (infile < 0)
		return;

	float sub, len;
	string line, n, t;
	while((line = fgets(infile)))
	{
		if (!tokenize(line))
			continue;
		n = argv(0);
		t = "";
		
		if (argv(1) == ":")
			t = argv(2);
		sub = buf_getsize(statements);
		//generate the function info. the entry isn't final yet
		bufstr_set(statements, sub, sprintf("\"%s\" \"%s\"", n, t));

		//parse the statements
		len = ScriptCompileStatements(infile);
		//add the 'done'.
		bufstr_set(statements, buf_getsize(statements), __NULL__);
		len++;

		//update function info to include length.
		bufstr_set(statements, sub, sprintf("%f %s", len, bufstr_get(statements, sub)));	//add an offset to the while statement, so it can jump beyond the while if needed
	}

	fclose(infile);
};

__wrap void() SUB_UseTargets =
{
	string targ = self.target;

	if (runscripts(targ))
		return;

	prior();
};

/*
void(string cmd) SV_ParseClientCommand =
{
	tokenize(cmd);
	switch(argv(0))
	{
	case "compile":
		ScriptCompile(argv(1));
		return;
	case "run":
		runscripts(argv(1));
		return;
	}
	clientcommand(self, cmd);
};
*/
__wrap void() worldspawn =
{
	prior();
	
	statements = buf_create();
	ScriptCompile(strcat("maps/", mapname, ".script"));
	
	runscripts("mapinit");
};