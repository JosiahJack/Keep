float(float regbitflag) query_configflag =
{
	// Return bitflag value so multiple bits can be tested together
	return (configflag & regbitflag);
};


