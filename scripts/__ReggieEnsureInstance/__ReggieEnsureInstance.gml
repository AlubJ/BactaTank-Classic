// Feather disable all

function __ReggieEnsureInstance()
{
    if (!instance_exists(__ReggieWorker))
	{
		instance_activate_object(__ReggieWorker);		
		if (instance_exists(__ReggieWorker))
		{
			__ReggieWarn("`__ReggieWorker` was deactivated. Please ensure that this object instance is never deactivated.");
		}
		else
		{
			instance_create_depth(0, 0, 0, __ReggieWorker);
		}
	}
}